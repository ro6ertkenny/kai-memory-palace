# 🧪 Git — LFCS Basics (Minimal Surface + Safe Workflow)

**Canonical depth lives in:** `~/kai-memory-palace/git/`  
This file is the **LFCS-training quick surface**: minimum commands + safe order.

---

## 🎯 LFCS expectation

Be comfortable with:
- clone
- status / log
- add / commit
- branch / checkout (or switch)
- merge
- pull / push
- basic conflict completion

---

## 🧠 Mental model (exam)

Git has three states:

1) Working tree = your files
2) Index (staging) = what will be committed next
3) HEAD = current commit pointer

Three inspections prevent most mistakes:

    git status
    git diff
    git diff --staged

---

## ✅ Standard LFCS workflow (edit → commit → push)

1) Inspect current state:

    git status

2) See what changed:

    git diff

3) Stage intentionally:

    git add <file>
    git add -p

4) Verify staged content:

    git diff --staged

5) Commit:

    git commit -m "docs(<scope>): <subject>"

6) Push:

    git push

---

## 📥 Clone (LFCS)

    git clone <url>
    cd <repo>

---

## 🌿 Branching (LFCS basics)

List branches:

    git branch

Create branch:

    git branch <name>

Switch (either may appear on labs):

    git checkout <name>
    git switch <name>

Create + switch:

    git checkout -b <name>
    git switch -c <name>

---

## 🔀 Merge (LFCS basics)

Merge a branch into your current branch:

    git merge <branch>

If a conflict occurs:
- Git pauses the merge
- files contain conflict markers
- you must edit, then add, then commit

Conflict completion pattern:

    git status
    # edit conflict files, remove markers
    git add <resolved-files>
    git commit
    git push

Abort merge (if needed):

    git merge --abort

---

## 🔄 Fetch vs Pull (exam-safe)

Fetch is always safe (no working tree change):

    git fetch

Pull fetches + integrates (may change your working tree):

    git pull

Safer discipline under pressure:
- fetch first
- inspect
- then integrate

    git fetch
    git log --oneline --decorate --graph -n 20
    git merge

---

## 🧹 Quick recovery (LFCS-level)

Unstage a file (keep working changes):

    git restore --staged <file>

Discard working changes to a file (destructive):

    git restore <file>

See recent pointer history (last resort):

    git reflog

---

## 🔗 Canon references (deep learning lives here)

- `git/change-workflow.md` — authoritative edit/stage/commit discipline
- `git/mental-model.md` — snapshots + pointers model
- `git/review-checklist.md` — definition of done before push
- `git/update-decision-tree.md` — fetch → inspect → integrate judgment
- `git/commit-message-standard.md` — searchable commit history

Fork-only:
- `git/forks-and-upstream.md`

---

## 🪝 Exam memory hook

Three checks + one flow:

    git status
    git diff
    git diff --staged

    git add <file>
    git commit -m "docs(scope): subject"
    git push
