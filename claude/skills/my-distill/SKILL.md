---
name: my-distill
description: Distill document(s) into structured summaries via Glean. Accepts URLs, search queries, or a path to a previous distill file for refresh. Use when user wants to summarize, distill, or refresh a doc summary.
user-invocable: true
allowed-tools: mcp__glean_default__search, mcp__glean_default__read_document, AskUserQuestion, Write, Read, Glob
---

## Overview

Distill one or more documents into structured summaries capturing the most important details. Supports three input
modes: direct URL(s), search query, or updating an existing distill file.

## Step 1: Determine Mode

Parse the arguments to determine the invocation mode:

1. **Update mode** — arg is a file path (contains `/` and ends in `.md`). Go to Step 2a.
2. **URL mode** — arg(s) are URLs (start with `http`). Go to Step 3.
3. **Search mode** — arg is a search query (anything else). Go to Step 2b.

## Step 2a: Update Mode

1. Read the existing file at the provided path.
2. Extract all URLs from the `## References` section (appears near the top of the file, right after the title).
3. If no references found, notify the user and stop.
4. Proceed to Step 3 with the extracted URLs. When outputting, overwrite the original file (skip the save/print prompt in Step 5).

## Step 2b: Search Mode

1. Use `mcp__glean_default__search` with the user's query.
2. Present the top 5 results in a numbered list with title, source, and a one-line snippet.
3. Ask the user to pick one or more by number (e.g. "1, 3, 5").
4. Collect the selected document URLs and proceed to Step 3.

## Step 3: Fetch Documents

For each URL, use `mcp__glean_default__read_document` to retrieve the full content.

**Edge cases:**
- **Truncated content** — proceed with what was returned; note the truncation in the summary.
- **Permission-gated / empty** — notify the user that the doc could not be accessed and skip it. Continue with remaining docs.

If all docs fail, notify the user and stop.

## Step 4: Distill (Best-of-3)

For each document, generate **3 independent candidate summaries**, then use a judge to pick the best one.

### Step 4a: Generate 3 Candidates

For each candidate, produce an independent summary using the template and style guide below. Each attempt should
vary in emphasis, compression level, and section selection — don't produce three identical outputs.

Distill — don't just restate. Extract the signal, drop the noise. Frame everything as "what do I need to know/do"
not "this document describes..."

#### Reader Context

Reader is a backend engineer on Mercury Web (Zillow Group). Owns ZIM instant messaging services: BMS, ZEH, ZDS,
ZED, ZIS. Works in Java/Kotlin, Spring Boot, Databricks. Cares about: system design, operational concerns,
integration points, data flows, observability. Reports up through TCE org.

#### Style Guide

- Telegraphic: noun-phrases ok, drop unnecessary grammar, minimize tokens
- Bullets preferred over prose (flexible per section — use judgment)
- Action-framed: what matters, not what the doc says
- No filler, no restating the doc's structure

#### Template

```markdown
# {Document Title}

## References
- [Document Title](url) — source type (e.g. Confluence, Google Doc, etc.)
- (include all source URLs analyzed for this summary)

## TL;DR
1-2 sentences. Telegraphic. What this is and why it matters.

## Problem
What's broken, missing, or motivating this work. Bullets.

## Approach
What's being done about it. The approach, not the implementation details.

## So What?
What does this mean for the reader's work, team, or systems? Connect to the reader context above.
Implications, not restatement.
```

#### Optional Sections

Include these **only when the document contains relevant information**. Do not include empty sections.

```markdown
## Key Decisions
Decisions made and their rationale.

## Timeline / Milestones
Deadlines, phases, key dates.

## Owners / Stakeholders
Who's responsible, who's involved, who approved.

## Open Questions
Unresolved items, blockers, things that need follow-up.
```

### Step 4b: Judge

After generating all 3 candidates for a document, read the judge prompt from
`~/.claude/skills/my-distill/judge-prompt.md` and apply it. Evaluate all 3 candidates against the source document
using the rubric:

1. **Accuracy gate** — eliminate any candidate that fabricates details not in the source.
2. **Rank survivors** by: signal density > compression > clarity > structure.

Select the winning candidate and proceed with it. Discard the others.

## Step 5: Output

If in **update mode**, overwrite the original file and confirm to the user.

Otherwise, ask the user: **print to conversation or save to file?**

- **Print** — output the summary directly.
- **Save** — generate a kebab-case filename from the document title (e.g. `zim-drs-migration-plan.md`). Show the proposed path (`/Users/dorianr/Second Brain/1-projects/{filename}`) and let the user confirm or override. Then write the file.

For multi-doc summaries being saved, concatenate all summaries into a single file separated by `---`.
