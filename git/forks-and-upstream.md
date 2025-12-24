# 🔁 Fork Maintenance Canon (origin vs upstream)

## 🎯 Purpose
Standardize how forked repositories are maintained so updates from the original project
can be pulled in cleanly without corrupting your fork workflow.

This is the canonical pattern for:
- `origin` = your fork (where you push)
- `upstream` = original repo (where updates come from)

---

## ✅ When to use this
Use this pattern only when the repository is a fork.

Examples:
- Fork: ro6ertkenny/kuard  
  Upstream: kubernetes-up-and-running/kuard
- Fork: ro6ertkenny/cka-study-guide  
  Upstream: bmuschko/cka-study-guide
- Not a fork: ro6ertkenny/kai-memory-palace  
  (no upstream — you are the source)

---

## 🧭 Canonical Workflow

### 1) Clone your fork (origin)

    git clone https://github.com/<you>/<repo>.git
    cd <repo>

### 2) Add upstream (original repository)

    git remote add upstream https://github.com/<upstream_owner>/<repo>.git

### 3) Verify remotes

    git remote -v

Expected:
- origin → your fork (fetch / push)
- upstream → original project (fetch; push usually denied)

---

### 4) Fetch upstream references (SAFE)

    git fetch upstream

This command:
- downloads upstream branch references
- does NOT modify your working tree
- does NOT merge or rebase
- is safe to run at any time

---

## 🔄 Updating your fork later

### Strategy A — Merge upstream into main

    git checkout main
    git fetch upstream
    git merge upstream/main
    git push origin main

### Strategy B — Rebase onto upstream (cleaner history)

    git checkout main
    git fetch upstream
    git rebase upstream/main
    git push --force-with-lease origin main

Use rebase only if you understand force-with-lease.

---

## 🧱 Rules (non-negotiable)
- Never push to upstream
- Always push your work to origin
- Always git fetch upstream before merge/rebase
- No automation that hides these steps

---

## 🧪 Quick Inspection Commands

Show upstream branches:

    git branch -r | grep upstream

Inspect origin:

    git remote show origin

Inspect upstream:

    git remote show upstream

---

## 🗂️ Canonical Location in kai-memory-palace

Path:

    git/forks-and-upstream.md

Reason:
- Standalone Git mental primitive
- Applies across all domains (K8s, Linux, general dev)
- Keeps fork hygiene explicit and discoverable

---

## 🚀 Git Commands to Add This File to kai-memory-palace

    cd ~/kai-memory-palace
    vim git/forks-and-upstream.md
    # paste this file, save, and exit

    git status
    git add git/forks-and-upstream.md
    git commit -m "Add fork maintenance canon (origin vs upstream)"
    git push
