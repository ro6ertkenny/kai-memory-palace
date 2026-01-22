# 🌱 Git Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`  
**Purpose:** Restore a **clean, consistent, and intended Git working state** using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- You are in a **detached HEAD**
- You need to **undo or recover** from a bad commit
- The working tree is **dirty or inconsistent**
- Files were **accidentally modified, deleted, or staged**
- You need to **safely reset, revert, or recover** history

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/git.md`

Related scenarios (practice inputs):

- (Future) bad-commit  
- (Future) detached-head  
- (Future) accidental-reset

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe repository state**
2. **Classify the failure mode**
3. **Select the minimal safe recovery**
4. **Apply**
5. **Verify**
6. **Make persistent**
7. **Rollback if needed**

Never run destructive commands without checking `git status` first.

---

## 🧭 Global Safety Rules

- **Always start and end with `git status`.**
- **Prefer `revert` over `reset` for committed history.**
- **Use `git reflog` as your safety net.**
- **Do not guess. Inspect first.**
- **Prefer minimal, reversible actions.**

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

From `git status` and `git log`, decide:

- Only **uncommitted changes** → go to **Section 3**
- **Bad commit(s)** exist → go to **Section 4**
- **Detached HEAD** → go to **Section 5**
- **History reset/rewrite mistake** → go to **Section 6**
- **Accidental file deletion/modification** → go to **Section 7**

---

## 3) Uncommitted Changes

### A) You want to discard them

    git restore .
    git clean -fd

Verify:

    git status

### B) You want to keep them

Commit them:

    git add .
    git commit -m "WIP: save work"

Or stash them:

    git stash

Verify:

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

Reset to a known-good commit:

    git reset --hard <good-commit>

Verify:

    git log --oneline --decorate

Return to **Section 1**.

---

## 5) Detached HEAD

Confirm:

    git status

If you have work you want to keep:

    git branch rescue-work
    git checkout rescue-work

Or return to main branch:

    git checkout main

Verify:

    git branch
    git status

Return to **Section 1**.

---

## 6) History Was Reset or Rewritten

Use reflog:

    git reflog

Find the last known-good state.

Restore it:

    git reset --hard <reflog-entry>

Verify:

    git log --oneline --decorate

Return to **Section 1**.

---

## 7) Accidental File Deletion or Modification

Restore from HEAD:

    git restore <file>

If staged but wrong:

    git restore --staged <file>

Verify:

    git status

Return to **Section 1**.

---

## 8) Verification

Always confirm:

    git status
    git log --oneline --decorate
    git branch

Ensure:

- You are on the correct branch
- Working tree state matches your intent
- History matches your intent

---

## 9) Persistence Check

If the issue was local-only:

- You are done.

If history was rewritten and already pushed:

- In real life: coordinate before force-push.
- For exam scope: avoid force-push unless explicitly required.

---

## 🔁 Rollback Strategy

Almost everything is recoverable via:

    git reflog

If you make a mistake:

- Stop
- Inspect `git reflog`
- Reset back to a known-good state

---

## ✅ Completion Criteria

- You are on the correct branch
- `git status` shows the intended state
- `git log` matches your intended history
- No unintended detached HEAD
- No unintended dirty working tree

You can explain:

- What went wrong
- Which recovery path you chose
- Why it was the safest minimal action
- How you verified success

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
