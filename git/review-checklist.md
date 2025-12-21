# Git Review Checklist (Definition of Done)

This checklist defines what **“done”** means before pushing changes to the
kai-memory-palace repository.

Use this as a final gate before `git push`.

---

## Review Checklist (Required)

Before pushing, confirm **all** of the following.

### 1. Working Tree Is Clean

- git status shows no unexpected changes
- no temporary or debug files remain

---

### 2. Diff Matches Intent

- git diff has been reviewed
- git diff --staged has been reviewed
- staged changes match the commit message
- no unrelated changes are included

---

### 3. Commit Message Is Correct

- commit message follows the standard in:
  - commit-message-standard.md
- type and scope are accurate
- subject is imperative and specific
- no vague language (WIP, update, fix stuff)

---

### 4. One Commit, One Idea

- commit represents a single coherent purpose
- unrelated wings are not mixed
- refactors are not mixed with content changes

If this rule is violated, split the commit.

---

### 5. Navigation Is Updated (If Needed)

If you changed structure or added material, confirm:

- README.md updated if navigation changed
- map.md updated if the knowledge map changed
- wing index updated if a new artifact was added

If nothing moved, no update is required.

---

### 6. Authority Rules Are Respected

- Git rules were not redefined elsewhere
- other wings reference Git rules instead of duplicating them
- no conflicting guidance was introduced

---

### 7. Push Readiness

- commit history reads cleanly
- commit message will make sense in six months
- you would be comfortable reviewing this commit cold

If unsure, stop and revise.

---

## When to Pause Instead of Push

Do not push if:
- you feel rushed or tired
- the diff surprised you
- the commit message feels unclear
- you are mixing cleanup with new content

Fix first. Push later.

---

## Authority

This checklist defines “done” for this repository.

If a change does not pass this checklist,
it is **not ready to be pushed**.
