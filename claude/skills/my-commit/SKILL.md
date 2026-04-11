---
name: my-commit-push-mr 
description: Stage, commit, and push changes following project git conventions
user-invocable: true
allowed-tools: Bash, Read, Grep, Glob, AskUserQuestion
---

# Commit and Push

## Step 1: Review Changes

Run the following in parallel:
- `git status` to see staged, unstaged, and untracked files
- `git diff` to see unstaged changes
- `git diff --cached` to see staged changes
- `git log --oneline -5` to see recent commit message style

## Step 2: Stage Files

- Stage only the files relevant to the current change
- Never use `git add -A` or `git add .`
- Never stage files that contain secrets (`.env`, credentials, etc.)
- If there are unrelated changes, ask the user whether to include them or leave them unstaged

## Step 3: Write Commit Message

- Use conventional commit format
- Keep the subject line concise — focus on the "why" not the "what"
- Do not include "Co-Authored-By" or any mention of Claude Code
- Pass the message via HEREDOC for proper formatting

## Step 4: Commit and Push

- Create the commit after user approval
- Push to the remote branch immediately after committing
- Never push to `main` or `master`
- Never use `--force`, `--no-verify`, or `--amend` unless explicitly asked

## Step 5: Update MR Description

- If a remote merge request exists for the current branch, read the existing MR description
- Update it with a concise summary of the changes on the branch so far
- Use bullet points
- Use `gh` or `glab` CLI as appropriate for the remote
