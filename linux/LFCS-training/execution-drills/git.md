# 🧪 Git — Tiny Execution Drill (LFCS)

Path:
  linux/LFCS-training/execution-drills/git.md

Mental mode: **Mechanical Git operations under time pressure.**  
Goal: Execute LFCS-level Git tasks fast and correctly (no workflow theory).

Scope:
- init, status
- add/commit
- diff/show/log
- branch/merge
- undo local mistakes (restore/reset)
- remote awareness (recognize + simulate safely)

Core law:
Git is **structured file history**. If you can’t prove state, you don’t control the system.

---

## 🧭 Safety Contract

- Do NOT run these drills inside a real repo.
- Work only in the lab directory.
- Do NOT push to real remotes.
- Always inspect state before and after each operation.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/git
    cd ~/lfcs-labs/execution-drills/git
    rm -rf repo remote.git
    mkdir repo
    cd repo

Optional identity (only if commits fail):

    git config --global user.name "Your Name"
    git config --global user.email "you@example.com"

---

## 🧠 State Inspection Reflex (Run Anytime)

These are your “where am I?” commands:

    git status
    git log --oneline --decorate -n 5
    git branch --show-current
    git branch
    git show --name-only -1
    git diff
    git diff --staged

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
    git switch -c feature1 2>/dev/null || git checkout -b feature1
    git branch

## C2 — Change + commit on branch

    echo "feature work" >> README.txt
    git add README.txt
    git commit -m "Feature: update README"

## C3 — Merge into default branch cleanly

Detect default branch:

    git branch --show-current

Switch to default branch (choose one that exists):

    git switch main 2>/dev/null || git checkout main 2>/dev/null || git switch master || git checkout master

Merge:

    git merge feature1

Delete branch:

    git branch -d feature1

Verify:

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
    git diff

(Optional) discard the remaining working tree edit:

    git restore README.txt 2>/dev/null || git checkout -- README.txt

---

# E) Find What Changed (Prove It)

## E1 — Show files changed in last commit

    git show --name-only -1

## E2 — Show commit list (compact)

    git log --oneline --decorate --graph -n 15

---

# F) Remote Recognition + Safe Simulation

Goal: Recognize remotes and practice the flow without touching GitHub.

## F1 — Inspect remotes

    git remote -v

## F2 — Add a dummy URL remote (recognition only)

    git remote add origin https://example.com/fake/repo.git 2>/dev/null || true
    git remote -v

## F3 — Simulate a real remote safely (local bare repo)

From inside repo:

    cd ~/lfcs-labs/execution-drills/git
    git init --bare remote.git
    cd repo

Replace origin with the local bare remote:

    git remote remove origin 2>/dev/null || true
    git remote add origin ../remote.git
    git remote -v

Push (local only):

    git push -u origin main 2>/dev/null || git push -u origin master

Verify:

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

    git switch -c t2 2>/dev/null || git checkout -b t2
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
- recognize remotes and safely simulate a push to a local bare repo

---

# 🧹 Cleanup (Lab Only)

    cd ~
    rm -rf ~/lfcs-labs/execution-drills/git/repo
    rm -rf ~/lfcs-labs/execution-drills/git/remote.git

---

