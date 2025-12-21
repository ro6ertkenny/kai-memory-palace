# Git Change Workflow

This document defines the **required workflow** for making changes in the
kai-memory-palace repository.

Its purpose is to make changes:
- intentional
- reviewable
- easy to understand months later

Follow this sequence every time.

---

## Core Rule

Never commit without inspecting both:
- the working diff
- the staged diff

If you skip a step, stop and restart the workflow.

---

## The Change Workflow (Required)

### 1. Edit

Make the smallest change that accomplishes the goal.

Rules:
- Avoid mixing unrelated changes
- Stay within one wing whenever possible
- If intent changes, plan a separate commit

---

### 2. Inspect Working Changes

Before staging anything:

git diff

Confirm:
- the diff matches your intent
- no accidental files are included
- formatting changes are intentional

If the diff looks wrong, fix it before continuing.

---

### 3. Stage Intentionally

Stage only what belongs in this commit.

Preferred:
git add <specific files>

Avoid:
git add .

If partial staging is needed:
git add -p

---

### 4. Inspect Staged Changes (Mandatory)

Before committing:

git diff --staged

This is the **last gate**.

Confirm:
- staged changes match the commit message you intend to write
- nothing extra slipped in
- the commit represents one coherent idea

If it does not pass, unstage and fix.

---

### 5. Commit

Write a commit message that follows the standard defined in:

- commit-message-standard.md

Rules:
- one commit = one idea
- message describes the result, not the process

Example:
docs(git): add change workflow discipline

---

### 6. Push

Only push after:
- staged diff has been reviewed
- commit message is correct
- repository is in a clean state

git push

---

## When to Split Commits

Split commits if:
- changes affect different wings
- refactors and content edits are mixed
- navigation updates and content updates are unrelated

Good:
- one commit for content
- one commit for structure
- one commit for navigation

---

## Recovery Rules

If you realize a mistake:
- before push: fix it properly (amend or reset)
- after push: do not panic; fix forward with a new commit

Never rewrite shared history unless you fully understand the impact.

---

## Authority

This workflow is mandatory for this repository.

If another document suggests a different Git workflow,
**this document takes precedence**.

