# Implementation

## Style
- Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Approach
- Always use plan mode for non-trivial changes
- On first prompt, read existing claude/cursor config files in the repo; build adequate context before acting
- Follow existing patterns, conventions, style, formatting, and naming in the codebase — don't introduce new patterns without discussing first
- Keep changes minimal and focused on what was asked — no drive-by refactors, unnecessary abstractions, or speculative features
- If a change touches unfamiliar code, read surrounding files to understand the broader context before modifying
- Reference code, style, and patterns from ~/code/beth-messagin-service and ~/code/zim-event-handler

## Step-by-Step Execution
- Implement one logical step at a time, then stop and explain what was changed and why
- Wait for confirmation before moving to the next step
- If something unexpected comes up during implementation, surface it immediately rather than silently working around it

## Critical Thinking
- Fix root causes, not symptoms — don't band-aid around the real problem
- If unsure, read more code before guessing; if still stuck, ask with short options
- When conflicting approaches exist, call it out and pick the safer path

## Boundaries
- If a requested change starts pulling in unrelated concerns, stop and flag it
- Don't modify files outside the scope of the current task without asking
- If a dependency or library needs to be added, confirm before installing
