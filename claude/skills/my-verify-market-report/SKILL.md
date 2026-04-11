---
name: my-verify-market-report
description: Verify a Deep Research market report against the DR Prompt Runbook quality checks and prompt structural rules. Compares Open House vs Tour reports for adequate reframing. Use when user wants to QA, verify, or check a DR market report.
user-invocable: true
allowed-tools: Read, AskUserQuestion, Glob
---

## Overview

Verify a Deep Research (DR) Open House market report against the Prompt Runbook required checks, prompt structural
rules, and compare it against a Tour market report for adequate open-house reframing.

**Expects two inputs:** Open House report + Tour report (for the same property).

## Step 1: Get Report Content

Parse the arguments to get both reports. Each arg can be:
- **File path** — contains `/` or ends in `.md`/`.txt`/`.html`. Read the file.
- **Pasted text** — raw report content.

Expected formats:
- `/verify-market-report <oh-path> <tour-path>`
- `/verify-market-report <oh-path>` then pasted Tour report
- Both pasted inline, separated by a clear delimiter

If only one report is provided or inputs are ambiguous, ask the user for the missing report.

Label the reports as **OH** (Open House) and **Tour** based on title detection:
- Title contains "Open House" -> OH
- Title contains "Tour" -> Tour
- If both look the same or neither matches, ask the user to clarify which is which.

## Step 2: Load Checklist

Read the checklist from `~/.claude/skills/my-verify-market-report/checklist.md`.

## Step 3: Run Layer 1 — Runbook Required Checks (on OH report)

Evaluate the OH report against every check in the **Layer 1: Runbook Required Checks** section of the checklist.

For each check, produce:
- **Status**: PASS, FAIL, or WARN
- **Evidence**: brief quote from the report or explanation justifying the status

WARN when the check cannot be reliably verified from markdown text (e.g., chart rendering, visual layout).

## Step 4: Run Layer 2 — Prompt Structural Checks (on OH report)

Evaluate the OH report against every check in **Layer 2: Prompt Structural Checks**.

Same output format: Status + Evidence per check.

For section length estimates, use ~500 words/page as the approximation. State the word count alongside the
status so the user can judge.

## Step 5: Run Layer 3 — OH vs Tour Comparison Checks

### Step 5a: Mechanical Differences

Evaluate checks M1–M4 against the OH report. These are standalone checks on the OH report — the Tour report
provides additional context but the checks are about what the OH report should/shouldn't contain.

### Step 5b: Semantic Diff

Compare the OH and Tour reports section-by-section, but **only for context-sensitive sections** as defined in
the checklist (SD1–SD5). Data-heavy sections (Section 1 market stats, Section 4 comps, Section 5 schools) are
expected to be similar and should NOT be flagged.

For each semantic check:
- Quote the relevant passages from both reports side-by-side
- Assess whether the OH report meaningfully adapted the framing
- PASS if adequately different, WARN if suspiciously similar, FAIL if verbatim identical

## Step 6: Output Results

### Format

```
## Market Report Verification: [property address from title]

### Runbook + Structural Checks

| ID | Category | Check | Status | Evidence |
|----|----------|-------|--------|----------|
| P1 | Policy & Tone | No negotiation tactics | PASS/FAIL/WARN | ... |
| ... | ... | ... | ... | ... |

### OH vs Tour Comparison

#### Mechanical Differences
| ID | Check | Status | Evidence |
|----|-------|--------|----------|
| M1 | Title says "Open House" | PASS/FAIL | ... |
| ... | ... | ... | ... |

#### Semantic Diff
| ID | Section | Status | OH excerpt | Tour excerpt | Notes |
|----|---------|--------|------------|--------------|-------|
| SD1 | Executive Summary | PASS/WARN/FAIL | "..." | "..." | ... |
| ... | ... | ... | ... | ... | ... |

### Summary
- **Passed:** X / N
- **Failed:** Y / N
- **Warnings:** Z / N

### Failed Items
For each FAIL: quote the offending text and name the violated rule.

### Warnings
For each WARN: quote the relevant text and explain why it could not be fully verified or why it is flagged.
```

If all checks pass, confirm the report meets the runbook quality bar and has adequate open-house differentiation.
