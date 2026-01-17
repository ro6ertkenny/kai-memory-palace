# 🧬 Git — LFCS Execution Drills
*Mechanical Git operations for Essential Commands (no workflow theory, no philosophy)*

---

## 🎯 Purpose
This file exists to ensure you can **execute core Git operations under time pressure**:

- initialize repositories
- stage and commit changes
- create and merge branches
- inspect history and state
- perform basic remote operations

All **discipline, safety, and workflow rules** live in the `git/` wing.
This file is about **typing the right commands without hesitation**.

---

## 🧠 Mental Rule (Exam Mode)
In LFCS:

- Git is a **tool**, not a process discussion.
- You will be asked to **perform operations**, not design workflows.
- Think: “What is the minimal command that produces the required state?”

---

## 🧰 Core Command Set (Must Be Muscle Memory)

Initialization:
    git init

Staging & committing:
    git status
    git add <file>
    git commit -m "message"

Inspection:
    git log
    git log --raw
    git status
    git diff

Branches:
    git branch
    git branch <name>
    git checkout <name>
    git switch <name>
    git merge <name>
    git branch --delete <name>

Remotes:
    git clone <repo>
    git pull
    git push
    git remote -v

---

## 🧪 Drill 1 — Initialize and Commit an Existing File

Scenario:
“You are in a directory containing an existing config file. Put it under version control and commit it.”

    cd /some/directory
    git init
    git status
    git add config.conf
    git commit -m "Add initial config"

Verify:
    git status
    git log

---

## 🧪 Drill 2 — Modify and Commit

    echo "# change" >> config.conf
    git status
    git diff
    git add config.conf
    git commit -m "Modify config"

Verify:
    git log
    git log --raw

---

## 🧪 Drill 3 — Create a Testing Branch and Switch to It

    git branch testing
    git checkout testing

(or)

    git switch -c testing

Verify:
    git branch

---

## 🧪 Drill 4 — Modify on Branch and Commit

    echo "# test change" >> config.conf
    git status
    git add config.conf
    git commit -m "Test change on testing branch"

Verify:
    git log --oneline --decorate

---

## 🧪 Drill 5 — Merge Branch Back to Main

Switch back:
    git checkout main

(or)
    git switch main

Merge:
    git merge testing

Delete branch:
    git branch --delete testing

Verify:
    git branch
    git log --oneline --decorate

---

## 🧪 Drill 6 — Identify What File Changed in the Last Commit

    git log -1 --raw

Or:
    git log --raw | head -n 20

---

## 🧪 Drill 7 — Clone and Inspect a Remote Repo

    git clone https://example.com/some/repo.git
    cd repo
    git status
    git log --oneline --decorate
    git remote -v

---

## 🧪 Drill 8 — Pull and Push (If Remotes Are Configured)

    git pull
    git push

Verify:
    git status

---

## 🧯 Common Exam-State Fixes

### “Nothing to commit, working tree clean” but you expected changes
    git status
    git diff

### You edited a file but forgot to stage it
    git add <file>
    git commit -m "message"

### You are on the wrong branch
    git branch
    git checkout <correct-branch>

---

## ⚠️ Scope Rule

This file intentionally does NOT cover:
- rebase
- reflog
- cherry-pick
- stash
- history rewriting strategies

Those belong to the `git/` wing and are not required for LFCS.

---

## ✅ Definition of “Git Ready for LFCS”

You are ready when you can:

- initialize a repo in any directory
- add and commit files without thinking
- create a branch, switch, modify, commit, merge, delete
- inspect what changed using `git log` and `git log --raw`
- clone a repo and inspect its state

Calmly. Mechanically. Without reference.

---
