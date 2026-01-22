# 🌱 Git Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`  
**Purpose:** Restore a **clean, consistent, and intended Git working state** using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- You are in a **detached HEAD**
- You need to **undo or recover** from a bad commit
- The working tree is **dirty or inconsistent**
- Files were **accidentally modified, deleted, or staged**
- You need to **safely reset, revert, or recover** history

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/git.md`

Related scenarios (for practice validation):

- (Future) bad-commit
- (Future) detached-head
- (Future) accidental-reset

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe repository state**
2. **Identify what is wrong**
3. **Decide recovery strategy**
4. **Apply minimal safe operation**
5. **Verify**
6. **Make persistent**
7. **Rollback if needed**

Never run destructive commands without checking `git status` first.

---

## 0) Inputs

You must know or determine:

- What you *intended* the repo state to be
- Whether changes should be:
  - kept
  - discarded
  - moved to a branch
- Whether the mistake is:
  - local only
  - already committed
  - already pushed

---

## 1) Observe Current State

Always start with:

    git status

Check history:

    git log --oneline --decorate -n 10

Check branches:

    git branch
    git branch -a

Check HEAD:

    git symbolic-ref --short HEAD

If this prints nothing → you are in **detached HEAD** → go to **Section 5**.

---

## 2) Classify the Problem

From `git status`, determine:

- Uncommitted changes only → go to **Section 3**
- Bad commit(s) exist → go to **Section 4**
- Detached HEAD → go to **Section 5**
- History rewrite or reset mistake → go to **Section 6**

---

## 3) Uncommitted Changes

### A) You want to discard them

    git restore .
    git clean -fd

Verify:

    git status

### B) You want to keep them

Stage and commit:

    git add .
    git commit -m "WIP: save work"

Or stash:

    git stash

Then verify:

    git status

Return to **Section 1**.

---

## 4) Bad Commit(s)

Inspect:

    git log --oneline --decorate

### A) Commit should be undone but history preserved

Use revert:

    git revert <commit>

### B) Commit should be removed locally (not pushed)

Reset to previous commit:

    git reset --hard <good-commit>

Verify:

    git log --oneline --decorate

Return to **Section 1**.

---

## 5) Detached HEAD

Confirm:

    git status

Create a branch to save work:

    git branch rescue-work
    git checkout rescue-work

Or switch back to main branch:

    git checkout main

If you had commits in detached state:

- Create a branch pointing to them first.

Verify:

    git branch
    git status

Return to **Section 1**.

---

## 6) History Was Reset or Rewritten

Use reflog:

    git reflog

Find the lost commit or state.

Restore:

    git reset --hard <reflog-entry>

Verify:

    git log --oneline --decorate

Return to **Section 1**.

---

## 7) Accidental File Deletion or Modification

Restore from HEAD:

    git restore <file>

Or:

    git checkout -- <file>

If staged but wrong:

    git restore --staged <file>

Verify:

    git status

---

## 8) Verification

Always confirm:

    git status
    git log --oneline --decorate
    git branch

Ensure:

- You are on the correct branch
- Working tree is clean (or intentionally dirty)
- History matches your intent

---

## 9) Persistence Check

If you fixed a local-only issue:

- You are done.

If history was rewritten and already pushed:

- In real life: coordinate before force-push.
- For exam scope: avoid force-push unless explicitly required.

---

## 🔁 Rollback Strategy

Almost everything in Git is recoverable via:

    git reflog

If you make a mistake:

- Stop
- Inspect reflog
- Reset back to a known-good state

---

## ✅ Completion Criteria

- You are on the correct branch
- `git status` shows the intended state
- History (`git log`) matches your intent
- No accidental detached HEAD
- No unintended dirty state

---

## 🧠 Exam Safety Rules

- Always run `git status` before and after changes
- Prefer `git revert` over `git reset` for committed history
- Use `git reflog` as your safety net
- Never guess — inspect first

---

## 🧱 This Playbook Composes From

- git.md

This is a **composition layer**, not a source of primitives.

---
