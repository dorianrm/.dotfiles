---
name: my-write-drs-spec
description: Write a DRS spec with the ZIM participant audit pre-loaded as context
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob, Write, Edit, AskUserQuestion
---

## Overview

Wrapper around `mercury-backend-core-plugin:write-spec` that pre-loads Display Ready Schema (DRS) project context.

### Problem

Each client surface (Web, iOS, Android) maintains its own display logic for conversations. This triplicates business
logic across platforms, multiplies with each new surface area, creates cross-platform inconsistencies, and ties logic
changes to app releases.

### Solution

Centralize display logic into the **ZIM Display Subgraph**. The server determines **WHAT** to display and **IF** it
should be displayed. Clients determine **HOW** to render it. This is display-ready data, not server-driven UI — the
backend returns pre-computed strings and values clients can render directly without additional business logic.

## Step 1: Load DRS Context

**Before doing anything else**, read the full DRS participant audit document — this is the **primary source of truth**:

```
/Users/dorianr/Desktop/ZIM_DRS_participant_audit.md
```

It covers the redesigned **ZIMParticipant** schema, **ZIMConversationListItem** mappings (formerly ZIMPreview),
per-persona field mappings, business logic, fallbacks, and edge cases per surface. Ground all spec content in this audit.

## Step 2: Scan the Codebase

Scan the current repo for relevant files, existing specs in `.specs/`, GraphQL schema, data models, and tests. Check
`~/code/beth-messaging-service` (the data graph) for reference.

If the audit lacks detail for a specific mapping, consult the client repos as needed:

- **Web**: `~/code/mercury-web/messaging-sdk/`
- **iOS**: `~/code/ZillowMap/Modules/Messaging/`
- **Android**: `~/code/zillow-android/features/messaging/`

## Step 3: Generate the Spec

Invoke the `mercury-backend-core-plugin:write-spec` skill, passing along all context gathered from the audit and
codebase scan. The plugin skill handles template generation, user review, and saving.
