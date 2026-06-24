---
name: my-product-metric-context
description: Load base context for ZIM product metrics schema work — schema doc, pitch, memory, and zim-zep-java-client library structure
user-invocable: true
allowed-tools: Bash, Read, Glob, WebFetch
---

## Overview

Pre-loads all context needed to work on ZIM product metrics schema design or the `zim-zep-java-client` library integration.

## Step 1: Read Schema Doc

Read the full schema design doc:

```
/Users/dorianr/Desktop/Product Metrics for ZIM SCHEMA.md
```

## Step 2: Read Pitch Doc

Read the Shape Up pitch for P0/P1/P2 deliverables:

```
/Users/dorianr/Desktop/Product Metrics for ZIM - Shape Up Pitch.md
```

## Step 3: Load Memory

Read these memory files (decisions locked in prior sessions):

```
/Users/dorianr/.claude/projects/-Users-dorianr--claude/memory/zim-product-metrics-event-design.md
/Users/dorianr/.claude/projects/-Users-dorianr--claude/memory/zim-message-event-schema-draft.md
/Users/dorianr/.claude/projects/-Users-dorianr--claude/memory/zim-eventing-cloudevents-envelope.md
```

## Step 4: Scan zim-zep-java-client

Check out the library at `~/code/zim-zep-java-client` if it exists locally:

```bash
ls ~/code/zim-zep-java-client 2>/dev/null || echo "not cloned locally"
```

If present, scan for:
- `src/main/` directory structure (models, schema classes, publishers)
- `README.md` or `CLAUDE.md`
- Any existing event schema classes

If not cloned, note the GitLab URL: `https://gitlab.zgtools.net/zillow/mercury-web/zim-zep-java-client`

## Step 5: Surface Summary

After loading, output a compact summary:

- **Schema doc:** loaded (date from doc header)
- **Locked decisions:** list the fields/decisions marked LOCKED in memory
- **Open questions:** list unresolved items from schema draft
- **Library:** local path or GitLab URL + any schema classes found
- **Ready:** confirm context loaded, ask what to work on
