# 🧬 Phase 18 — Git (Execution Playbook)
*LFCS operator Git: initialize repos, commit, branch, merge, inspect history, and prove what changed — fast and clean.*

Path:
- linux/LFCS-execution-playbooks/phase-18-git.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- initialize a repository
- add and commit files
- configure a remote (simulated)
- create and switch branches
- merge branches back to main
- inspect history
- show which files changed in a commit
- prove state with logs and diffs

---

## 🧱 Lab Root

All Phase 18 drills run in:

- ~/lfcs-labs/phase-18

Initialize:

    mkdir -p ~/lfcs-labs/phase-18
    cd ~/lfcs-labs/phase-18
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT run these drills inside a real repo.
- Work only inside the lab directory.
- Use local repos only (no real pushing to GitHub).
- Always verify state before merging.

---

## 🧪 Completion Standard

Pass Phase 18 when you can complete P18-1 through P18-14:

- in ≤ 120 minutes
- without corrupting history
- with proof files created
- and with clean final state

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P18-1 — Initialize repository

Time limit:
- 2 minutes

Do:

    git init > init.txt
    git status > status-1.txt

Verify:

    test -d .git

-------------------------------------------------------------------------------

## P18-2 — Create initial file and commit

Time limit:
- 4 minutes

Do:

    echo "hello world" > file.txt
    git add file.txt
    git commit -m "Initial commit" > commit-1.txt

Verify:

    git log -1 > log-1.txt

-------------------------------------------------------------------------------

## P18-3 — Create second file and commit

Time limit:
- 4 minutes

Do:

    echo "second file" > file2.txt
    git add file2.txt
    git commit -m "Add second file" > commit-2.txt

Verify:

    git log --oneline > log-2.txt

-------------------------------------------------------------------------------

## P18-4 — Show files changed in last commit

Time limit:
- 3 minutes

Do:

    git show --name-only > show-last.txt

-------------------------------------------------------------------------------

## P18-5 — Create and switch to branch

Time limit:
- 3 minutes

Do:

    git checkout -b feature > branch-create.txt
    git branch > branches.txt

-------------------------------------------------------------------------------

## P18-6 — Modify file on branch and commit

Time limit:
- 4 minutes

Do:

    echo "feature change" >> file.txt
    git add file.txt
    git commit -m "Feature change" > commit-feature.txt

Verify:

    git log --oneline --decorate > log-feature.txt

-------------------------------------------------------------------------------

## P18-7 — Show diff between branches

Time limit:
- 3 minutes

Do:

    git diff master..feature > diff.txt

-------------------------------------------------------------------------------

## P18-8 — Switch back to master

Time limit:
- 2 minutes

Do:

    git checkout master > checkout-master.txt

-------------------------------------------------------------------------------

## P18-9 — Merge branch into master

Time limit:
- 4 minutes

Do:

    git merge feature > merge.txt

Verify:

    git log --oneline --decorate > log-after-merge.txt

-------------------------------------------------------------------------------

## P18-10 — Delete feature branch

Time limit:
- 2 minutes

Do:

    git branch -d feature > delete-branch.txt
    git branch > branches-after.txt

-------------------------------------------------------------------------------

## P18-11 — Show commit history with files

Time limit:
- 3 minutes

Do:

    git log --raw > log-raw.txt

-------------------------------------------------------------------------------

## P18-12 — Show diff working tree vs repo

Time limit:
- 3 minutes

Do:

    echo "temp change" >> file2.txt
    git diff > working-diff.txt

Revert change:

    git checkout -- file2.txt

-------------------------------------------------------------------------------

## P18-13 — Simulate remote (local bare repo)

Time limit:
- 6 minutes

Do:

    mkdir ../remote.git
    cd ../remote.git
    git init --bare > bare.txt
    cd ../phase-18

    git remote add origin ../remote.git
    git push origin master > push.txt

Verify:

    git remote -v > remotes.txt

-------------------------------------------------------------------------------

## P18-14 — Cleanup

Time limit:
- 2 minutes

Do:

    echo OK > cleanup.txt

---

## 🏁 Phase 18 Pass Criteria

You can:

- initialize a repo
- add and commit files
- create and delete branches
- merge branches
- inspect logs and changed files
- show diffs
- push to a remote
- explain what changed and when

---

## 🧠 Phase 18 Law

Git is **just structured file history**.  
Treat it like `cp` with memory.

---
