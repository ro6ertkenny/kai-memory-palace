# 🧪 Git — Tiny Execution Drill (LFCS)

Path:
  linux/LFCS-training/execution-drills/git.md

Mental mode: Mechanical Git operations under time pressure.  
Goal: Execute the LFCS-level Git tasks fast and correctly (no workflow theory).

Scope:
- init, status
- add/commit
- diff/show/log
- branch/merge
- undo local mistakes (restore/reset)
- remote awareness (recognize, not heavy)

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/git
    cd ~/lfcs-labs/execution-drills/git
    rm -rf repo
    mkdir repo
    cd repo

Optional identity (if commits fail):

    git config --global user.name "Your Name"
    git config --global user.email "you@example.com"

---

# A) Initialize, Add, Commit

## A1 — Create repo + confirm clean state

    git init
    git status

## A2 — Create file, stage, commit

    echo "LFCS git drill" > README.txt
    git add README.txt
    git commit -m "Add README"

Verify:

    git log --oneline --decorate -n 3
    git show --name-only --oneline -1

---

# B) Inspect Changes (Diff + Status)

## B1 — Modify file + inspect

    echo "line2" >> README.txt
    git status
    git diff

## B2 — Stage and re-check diff surfaces

    git add README.txt
    git diff
    git diff --staged

Commit:

    git commit -m "Update README"

---

# C) Branch + Merge (LFCS Favorite)

## C1 — Create branch and switch

    git branch
    git switch -c feature1 || git checkout -b feature1
    git branch

## C2 — Change + commit on branch

    echo "feature work" >> README.txt
    git add README.txt
    git commit -m "Feature: update README"

## C3 — Merge into main/master

Detect default branch name:

    git branch --show-current

Switch to default branch (choose one that exists):

    git switch main 2>/dev/null || git checkout main 2>/dev/null || git switch master || git checkout master

Merge:

    git merge feature1

Delete branch:

    git branch -d feature1

Verify history:

    git log --oneline --decorate -n 10

---

# D) Undo Local Mistakes (Safe + Fast)

## D1 — Undo unstaged change (working tree)

    echo "oops" >> README.txt
    git status
    git restore README.txt 2>/dev/null || git checkout -- README.txt
    git status

## D2 — Unstage a staged change (keep file edits)

    echo "stage-oops" >> README.txt
    git add README.txt
    git status

Unstage:

    git restore --staged README.txt 2>/dev/null || git reset README.txt

Verify:

    git status

---

# E) Find What Changed

## E1 — Show files changed in last commit

    git show --name-only -1

## E2 — Show commit list (short)

    git log --oneline --decorate --graph -n 15

---

# F) Remote Recognition (Light)

Goal: Recognize and inspect remotes; do not over-index on push/pull.

    git remote -v

Add a dummy remote (optional recognition drill):

    git remote add origin https://example.com/fake/repo.git || true
    git remote -v

---

# ⏱️ Timed Drills

## T1 — Init + first commit (30 seconds)

    rm -rf /tmp/lfcs-git-t1
    mkdir -p /tmp/lfcs-git-t1 && cd /tmp/lfcs-git-t1
    git init
    echo "t1" > f.txt
    git add f.txt
    git commit -m "t1"
    git log --oneline -1

## T2 — Branch + merge (45 seconds)

    git switch -c t2 || git checkout -b t2
    echo "x" >> f.txt
    git add f.txt
    git commit -m "t2 change"
    git switch main 2>/dev/null || git checkout main 2>/dev/null || git switch master || git checkout master
    git merge t2
    git branch -d t2
    git log --oneline -3

---

# ✅ Completion Criteria

You are done when you can, from memory:

- initialize a repo and confirm state (`git init`, `git status`)
- stage and commit correctly (`git add`, `git commit`)
- inspect changes (`git diff`, `git diff --staged`, `git show`)
- create/merge/delete branches (`git switch -c`, `git merge`, `git branch -d`)
- undo common local mistakes (`git restore`, `git restore --staged`, `git reset <file>`)
- inspect history quickly (`git log --oneline`)

---

# 🧹 Cleanup

    cd ~
    rm -rf ~/lfcs-labs/execution-drills/git/repo

---
