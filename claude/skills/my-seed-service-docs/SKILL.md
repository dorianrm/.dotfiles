---
name: my-seed-service-docs
description: Seed a ZIM backend service's documentation pages in the zim-docs site, written from the service source. Use when onboarding a service to the Services group under the Use tab, or when a service's pages are still placeholders.
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob, Write, Edit, AskUserQuestion
---

# Seed Service Docs

Write documentation pages for a ZIM backend service into the `zim-docs` site, derived from that service's source code.

Every fact on the page comes from reading the service repo. Nothing is inferred or recalled. If a name cannot be confirmed in the source, describe the behavior generically instead of guessing.

## Step 1: Establish inputs

Need three things. Ask only for what you cannot determine.

- **Service repo path**: usually `~/code/<service>`
- **Service id**: the repo name, used as the docs folder name
- **Display name**: Title Case, e.g. `ZIM Event Handler`

Confirm `~/code/zim-docs` exists. If not, clone `git@gitlab.zgtools.net:zillow/mercury-web/zim-docs.git`.

Pages go in:

```
zim-docs/src/content/use/services/<service-id>/
```

**Never** put them under `src/content/build/`. That path is gitignored and `scripts/fetch-docs.mjs` deletes it on every build (the `messaging-sdk` source owns `targetPath: "build"`).

## Step 2: Read the service source

Derive everything. Invent nothing. For a Java Spring Boot ZIM service:

```bash
cd <service-repo>
# Package layout
find src/main/java -type d | sed 's|.*/<service-package>||' | sort
# SQS listeners
grep -rl '@SqsListener' src/main
# Traced handlers (these map 1:1 to per-event-type spans)
grep -rhoE 'operationName = "[^"]+"' src/main | sort -u
# Config: queue URLs, downstream base URLs, ports
cat src/main/resources/application*.y*ml
# Outbound clients and their public methods
find src/main -path '*client*' -name '*.java'
# Enums worth documenting: queue names, feature flags, routing types
find src/main -path '*enums*' -name '*.java'
# Retry and DLQ behavior
grep -rl 'MessageInterceptor\|MAX_RETRIES' src/main
```

Also read the repo's `CLAUDE.md`. It often already documents SLOs, span names, and logging conventions.

For each flow, trace listener → routing factory → handler → downstream calls, and note the branch conditions: feature-flag gates, early returns, fallbacks, and which exceptions cause a retry.

Adapt the commands for non-Java services, but keep the goal: inbound routes, routing, per-flow processing, outbound dependencies, retry semantics, config.

## Step 3: Write three pages

| File | Covers |
|------|--------|
| `index.mdx` | Purpose and capabilities, what the service does, where it sits, and when it is **not** the right fit |
| `architecture.mdx` | Inbound routes, per-flow processing with diagrams, outbound routes, data stores |
| `infrastructure.mdx` | Retry and DLQ, observability and spans, feature flags, runtime config, test hooks |

`index.mdx` serves two audiences: an engineer joining the service, and an engineer on another team deciding whether it fits their need. The "not the right fit" section matters as much as the capabilities list. Point at the correct alternative for each case.

Then update **two** `_meta.js` files:

```js
// src/content/use/services/<service-id>/_meta.js
export default {
  index: 'Overview',
  architecture: 'Architecture',
  infrastructure: 'Infrastructure'
}
```

```js
// src/content/use/services/_meta.js  (add one line)
'<service-id>': '<Display Name>'
```

## Step 4: Style rules

These are non-negotiable. Each one has bitten a previous page:

- **No em dashes or en dashes.** Restructure the sentence. Use a colon when a definition follows, a full stop when two independent claims are joined.
- **No semicolons in prose.** `import` statements are fine.
- **No headerless tables.** `| | |` renders an empty header row with blank cells. Use real headers, or a bullet list for key/value metadata.
- **Prefer tables** for event, field, config, and enum lists.
- **Use fenced `mermaid` blocks** for flow diagrams. They work in this site.
- **Callouts need an import**: `import { Callout } from 'nextra/components';` at the top of the file.
- **Internal links are absolute**: `/use/services/<service-id>/architecture`.
- Flag deliberate gaps rather than omitting them. If an enum has four values and two are handled, show all four with a Handled column.

## Step 5: Verify

```bash
cd ~/code/zim-docs
npm install                                   # first time only, ~6 min
export NODE_OPTIONS="--max_old_space_size=4096"
npx next build --webpack > /tmp/docs-build.log 2>&1; echo "exit=$?"
find out/use/services -name index.html | sort
```

`npx next build` skips `fetch-docs`, which is the slow part and unnecessary once federated content is populated. Run the full `npm run build` only to match CI exactly.

Pitfalls:

- **Always use absolute paths in Bash calls.** The working directory drifts between calls and a build from the wrong cwd fails with `Couldn't find any 'pages' or 'app' directory`.
- **Do not pipe a long build to `tail`.** It buffers until the pipe closes and looks hung. Redirect to a file.
- **Mermaid renders client-side after hydration.** Grepping the static HTML for `<svg>` proves nothing and will produce a false positive on unrelated icons. To verify, serve `out/` (`python3 -m http.server 4173`) and ask the user to look at the page.
- The `Failed to get the last modified timestamp from Git` warning is benign, and only appears for untracked files.

Check for regressions before committing:

```bash
grep -n '—\|–' src/content/use/services/<service-id>/*.mdx   # expect none
grep -n ';' src/content/use/services/<service-id>/*.mdx      # expect only imports
grep -n '^| *|' src/content/use/services/<service-id>/*.mdx  # expect none
```

## Step 6: Commit and open a draft MR

Branch, commit, push, then open a **draft** MR. Never push to `main`.

```bash
git checkout -b docs/<service-id>-seed-pages
```

Conventional commit, e.g. `docs(<abbrev>): seed <Display Name> service pages`.

Keep the MR description tight. Lead with What, then a bulleted Changes list, then a short section flagging the source-derived details a reviewer is most likely to distrust (unhandled enum values, idempotency semantics, fallback behavior, fail-closed paths, flag evaluation keys). Note anything deliberately not covered, such as a runbook page. One line for verification.
