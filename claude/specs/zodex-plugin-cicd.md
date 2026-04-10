---
name: Zodex Plugin CI/CD Integration Spec
description: Three options for loading mercury-backend-core-plugin into Zodex CI/CD Claude Code sessions — marketplace ref, git submodule, or --plugin-dir extension
type: project
---

# Zodex Plugin CI/CD Integration Spec

## Problem

Zodex runs Claude Code in CI/CD pipelines against target repos (BMS, ZEH, ZDS). The team's shared plugin (`mercury-backend-core-plugin`) lives in a separate repo (`zillow/mercury-web/backend/mercury-backend-core-plugin`). Zodex auto-discovers `.mcp.json` and `CLAUDE.md` in the target repo, but not plugins from external repos.

**Why:** The team wants Claude Code running via Zodex to have access to team-specific skills (e.g., `mwb-fix-pipeline`, `mwb-review-code-mr`, `mwb-zim-backend-answer-bot`, `effective-java`, `mwb-write-spec`) during automated CI/CD tasks.

## Current Zodex Architecture

- **Docker image** (`hw-28-claude-code-base`): installs Claude Code, sets `enableAllProjectMcpServers: true`
- **Pipeline** (`hw-28-zodex-pipeline`): clones target repo, detects language, runs Claude
- **Settings** (`setup-claude-code-settings.ts`): enables `.mcp.json` discovery in workdir
- **MCP support** (`run-claude.ts`): supports `--mcp-config` via `INPUT_MCP_CONFIG` (not wired through webhook API yet)
- **Claude Code flags**: `--bare` mode + `--plugin-dir` supported natively

## Options

### Option 1: Marketplace reference in each service repo (works today)

Add `.claude/settings.json` to BMS/ZEH/ZDS:

```json
{
  "extraKnownMarketplaces": {
    "mercury-backend": {
      "source": {
        "source": "git",
        "url": "https://gitlab.zgtools.net/zillow/mercury-web/backend/mercury-backend-core-plugin.git"
      }
    }
  },
  "enabledPlugins": {
    "mercury-backend-core-plugin@mercury-backend": true
  }
}
```

**Pros:**
- No Zodex changes needed
- Team controls plugin enablement per-repo
- Works with existing `enableAllProjectMcpServers` setting

**Cons:**
- Depends on Zodex execution environment having git credentials to clone plugin repo
- Duplicated config across BMS/ZEH/ZDS
- Plugin version not pinned (always pulls latest main)

**Risk:** Git auth in Zodex container may not have access to the plugin repo.

### Option 2: Git submodule in each service repo (works today)

```bash
git submodule add https://gitlab.zgtools.net/zillow/mercury-web/backend/mercury-backend-core-plugin.git .claude/plugins/mercury-backend-core-plugin
```

**Pros:**
- Plugin version pinned to specific commit
- Standard git mechanism
- No Zodex changes needed if pipeline runs `git submodule update --init`

**Cons:**
- Submodule maintenance overhead (updating across 3+ repos)
- Zodex pipeline may not initialize submodules (needs verification)
- Developers must remember to update submodule refs

**Risk:** Zodex pipeline clone step may not include `--recurse-submodules`.

### Option 3: Extend Zodex to support `--plugin-dir` (most robust)

Add `pluginRepos` field to Zodex webhook payload:

```json
{
  "prompt": "...",
  "url": "https://gitlab.zgtools.net/zillow/mercury-web/messaging-handler/beth-messaging-service",
  "pluginRepos": [
    "https://gitlab.zgtools.net/zillow/mercury-web/backend/mercury-backend-core-plugin.git"
  ],
  "requestedBy": "user",
  "inputModel": "sonnet-4.5"
}
```

Changes required:
1. **Zodex service** (`hw-28-zodex-service`): accept `pluginRepos` in job request API
2. **Zodex pipeline** (`hw-28-zodex-pipeline`): clone plugin repos alongside target repo
3. **Claude execution** (`run-claude.ts`): pass `--plugin-dir /path/to/cloned-plugin` to Claude Code

```bash
claude --bare -p "task" \
  --plugin-dir /workspace/plugins/mercury-backend-core-plugin \
  --allowedTools "Read,Edit,Bash"
```

**Pros:**
- Cleanest separation — plugin not coupled to target repo
- Centrally managed, any team can use it
- Plugin loaded explicitly, no discovery magic
- Benefits entire Zodex user base

**Cons:**
- Requires changes to Zodex service, pipeline, and possibly webhook API
- Needs coordination with Zodex maintainers (@sophiege)
- Additional clone step adds pipeline latency

## Slack Thread Context (2026-03-17)

Thread: https://zillowgroup.slack.com/archives/C095GQZKGKE/p1773783119332559

**James Kusachi** raised this exact question in #zodex-headless-claude-code, cc'd @dorianr.

**Alex Sorokoletov** (Zodex maintainer) confirmed:
- Plugin installation is **not a problem** — team-level config page to inject plugins is on their radar
- Open questions: tooling dependencies and `env` settings the plugin needs (DD/CR API keys)
- Suggested approach: have Zodex install the plugin, then invoke the skill — aligns with **Option 3**
- **Workaround for interactive skills**: compose skills non-interactively via prompt engineering — tell Claude to "follow the process of skill X but in non-interactive mode" or "don't ask me" / "pick this and that"
- This means skill code changes may **not** be needed for headless compatibility

**Agreed next step**: Experiment with having Zodex install the plugin and invoke a skill, then report back to Alex.

### Updated Headless Skill Strategy

Based on Alex's feedback, interactive skills can be invoked headlessly by wrapping them in a prompt like:

```
Follow the /mwb-fix-pipeline skill process for pipeline {ID} but in non-interactive mode.
Do not ask for confirmation — apply all fixes directly.
```

This eliminates the need to modify skill source code for headless compatibility.

## Experiment Results (2026-04-09)

### Test 1: Clone plugin at runtime via prompt

**Pipeline**: https://gitlab.zgtools.net/zillow/rentals-connections/hw-28-zodex-pipeline/-/pipelines/13811861

**Approach**: Prompt Claude to `git clone` the plugin repo, copy into `.claude/plugins/`, then review MR.

**Results**:
- `git clone` to any path → **blocked** ("This command requires approval") — 7+ attempts, all denied
- `mkdir -p .claude/plugins` → **blocked** ("Claude requested permissions to edit .claude/plugins which is a sensitive file")
- `glab api` to the plugin repo → **blocked** (same approval error)
- Plugin was never installed; `"plugins": []` in init event confirmed no plugins loaded
- Claude fell back to reviewing MR without plugin context via `glab mr view` / `glab mr diff`

**Key finding**: The Zodex sandbox blocks all access to repos other than the target repo.

### Test 2: Install plugin via `claude plugin` CLI commands

**Pipeline job**: https://gitlab.zgtools.net/zillow/rentals-connections/hw-28-zodex-pipeline/-/jobs/96441797

**Approach**: Prompt Claude to run `claude plugin marketplace add` + `claude plugin install` + `/reload-plugins`.

**Results**:
- `claude plugin marketplace add` → **blocked** ("This command requires approval") — tried 7+ times
- `claude plugin --help` → **blocked**
- `claude plugins --help` → **blocked**
- `git clone` fallback → **blocked** (same as Test 1)
- `glab api` to plugin repo → **blocked** (same as Test 1)
- Claude pivoted to reviewing MR !830 without plugin; **successfully posted review comment** ([note_11759112](https://gitlab.zgtools.net/zillow/mercury-web/messaging-handler/beth-messaging-service/-/merge_requests/830#note_11759112))
- Stats: 38 turns, 258s, $1.30, status: success

### Root Cause

The blocker is **`INPUT_ALLOWED_TOOLS`** in the Zodex pipeline (line 73 of job trace). The allowed Bash commands are explicitly whitelisted:

```
Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(glab mr:*), ...
```

`claude plugin` is **not** in this list. Every `claude plugin` command gets rejected with "This command requires approval."

Additionally, `glab api` calls are only permitted for the target project's merge request endpoints, not arbitrary projects.

### Option 4: Whitelist `claude plugin` in Zodex pipeline (simplest fix)

Add `Bash(claude plugin:*)` to `INPUT_ALLOWED_TOOLS_DEFAULT` in `hw-28-zodex-pipeline/.gitlab-ci.yml`.

**What to change:**
- **Repo**: `zillow/rentals-connections/hw-28-zodex-pipeline`
- **File**: `.gitlab-ci.yml`, line ~237
- **Change**: Add `Bash(claude plugin:*)` to the `INPUT_ALLOWED_TOOLS_DEFAULT` YAML variable

```yaml
INPUT_ALLOWED_TOOLS_DEFAULT: >-
  Write,Edit,Task,TodoWrite,MultiEdit,LS,View,Glob,Grep,Read,Batch,
  WriteTool,EditTool,TaskTool,TodoWriteTool,MultiEditTool,LSTool,ViewTool,GlobTool,GrepTool,ReadTool,BatchTool,
  Bash(claude plugin:*),
  Bash(git status:*),Bash(git log:*),...
```

**Why only this repo**: The pipeline is the gatekeeper. It passes `--allowedTools` to the `claude -p` invocation. Claude Code rejects any Bash command not matching a pattern in that list. The Docker image already has the `claude` binary. The Zodex service and webhook API are unaware of which Bash commands are permitted — they pass the prompt through without modification. Nothing upstream or downstream needs to change.

This would allow Claude to run mid-session:
```bash
claude plugin marketplace add https://gitlab.zgtools.net/zillow/mercury-web/backend/mercury-backend-core-plugin.git
claude plugin install mercury-backend-core-plugin@mercury-backend
```

Then `/reload-plugins` activates the plugin without restart.

**Pros:**
- One-line change to the pipeline config
- No changes to Zodex service, webhook API, or Docker image
- Teams self-serve — prompt includes plugin install commands
- `/reload-plugins` enables mid-session activation (no restart needed)
- Benefits any team wanting to use plugins

**Cons:**
- `_zodex` service account still needs git access to the plugin repo for the marketplace clone
- Plugin install adds ~30s to task execution
- Plugin not pinned to version (pulls latest)

**Remaining question**: Does `_zodex`'s git credential propagate to the `claude plugin marketplace add` internal git clone?

### Answers to previous open questions
- **Does Claude need a restart after plugin install?** `/reload-plugins` would activate mid-session, but it's a slash command and **slash commands are not available in `-p` (headless) mode** — confirmed by [Claude Code docs](https://code.claude.com/docs/en/headless). However, after `claude plugin install`, the plugin files exist on disk and Claude can read them directly (SKILL.md, docs/, CLAUDE.md). This is sufficient — Claude follows the skill process by reading the file, not by formally invoking the slash command.
- **Can `claude plugin` commands run from Bash?** Yes — `claude plugin marketplace add`, `claude plugin install` are valid CLI commands
- **What blocks plugin installation?** The `INPUT_ALLOWED_TOOLS` allowlist, not network/auth/sandbox issues
- **Can skills be invoked in headless mode?** No — user-invoked skills like `/mwb-review-code-mr` require interactive mode. In `-p` mode, the workaround is to prompt Claude to "follow the process of skill X in non-interactive mode" and it reads the SKILL.md from disk. This is Alex's suggested approach and it works.

## Recommendation

1. **Ask Alex to add `Bash(claude plugin:*)` to `INPUT_ALLOWED_TOOLS_DEFAULT`** — this is a one-line pipeline config change (Option 4)
2. **Re-run the experiment** once whitelisted to validate the full flow: marketplace add → install → reload → invoke skill
3. If git auth fails during marketplace add, fall back to **Option 3** (`--plugin-dir` with pipeline-level clone)
4. If Option 4 timeline is too long, **Option 1** (`.claude/settings.json` in each repo) is the self-service fallback — but requires validating that Claude Code reads project-level settings at startup in Zodex

### Remaining open questions
- Does `_zodex` git credential propagate to `claude plugin marketplace add` internal clone?
- How does Zodex inject env vars (DD_API_KEY, CR API keys) the plugin/tools need?
- What's the team-level config page timeline?

## Key Contacts

- Zodex maintainer: **Alex Sorokoletov** (@alexs)
- Zodex maintainer: **@sophiege** (Sophie Geyer)
- Mercury team: **James Kusachi** (@jamesk), **@dorianr**
- Slack: [#zodex-headless-claude-code](https://zillowgroup.enterprise.slack.com/archives/C095GQZKGKE)
- Zodex docs: https://zillow.pages.zgtools.net/rentals-connections/zodex/zodex-docs/

## References

- Zodex CI/CD components: https://gitlab.zgtools.net/zillow/web-platform/cicd/zodex-cicd-components
- Mercury backend plugin: https://gitlab.zgtools.net/zillow/mercury-web/backend/mercury-backend-core-plugin
- Claude Code CLI ref: https://code.claude.com/docs/en/cli-reference.md
- Claude Code plugins: https://code.claude.com/docs/en/plugins.md
- Slack thread: https://zillowgroup.slack.com/archives/C095GQZKGKE/p1773783119332559
