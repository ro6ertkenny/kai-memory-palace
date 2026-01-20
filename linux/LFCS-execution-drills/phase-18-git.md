# 🧪 LFCS Execution Drills — Phase 18
# 🧬 Git (Essential Version Control)

Path:
  linux/execution-drills/phase-18-git.md

Purpose:
  Build reflex-level operational Git skills required for LFCS.

Mental Mode:
  Git here is a tool, not a workflow system.
  Every drill maps to an LFCS task pattern.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-18
    cd ~/lfcs-labs/execution-drills/phase-18

---

# 🧪 A) Initialize, Add, Commit

## A1 — Create repo

    git init

Verify:

    git status

---

## A2 — Add file and commit

    echo "LFCS Git Lab" > README.txt
    git add README.txt
    git commit -m "Add README"

Verify:

    git log --oneline

---

# 🧪 B) Inspect Changes

## B1 — Modify file and inspect diff

    echo "Second line" >> README.txt
    git diff

Stage and commit:

    git add README.txt
    git commit -m "Update README"

---

## B2 — Show what changed in last commit

    git show --name-only

---

# 🧪 C) Branching and Merging

## C1 — Create and switch branch

    git checkout -b docs

Verify:

    git branch

---

## C2 — Modify file in branch

    echo "Docs branch change" >> README.txt
    git add README.txt
    git commit -m "Docs change"

---

## C3 — Merge back to master

    git checkout master
    git merge docs

Delete branch:

    git branch -d docs

---

# 🧪 D) History Inspection

## D1 — Show log

    git log

---

## D2 — Show log with file changes

    git log --raw

---

## D3 — Show last commit only

    git log -1

---

# 🧪 E) Differences

## E1 — Working tree diff

    echo "Uncommitted change" >> README.txt
    git diff

Revert change:

    git restore README.txt

---

## E2 — Diff between commits

    git log --oneline

Copy two commit hashes and:

    git diff HASH1 HASH2

---

# 🧪 F) Remote Simulation (Optional but Good Muscle Memory)

## F1 — Add fake remote

    git remote add origin https://example.com/fake/repo.git

Show remotes:

    git remote -v

---

# 🧪 G) Full Exam-Style Scenario

## G1 — Scenario

1) Initialize repo
2) Add config file
3) Commit
4) Create branch
5) Modify file
6) Commit
7) Merge back
8) Show files changed in last commit

Commands (summary):

    git init
    echo "config=1" > config.cfg
    git add config.cfg
    git commit -m "Add config"

    git checkout -b feature
    echo "config=2" >> config.cfg
    git add config.cfg
    git commit -m "Modify config"

    git checkout master
    git merge feature

    git show --name-only

---

# 💣 H) Failure Mode Drills

## H1 — Forgetting to stage

    echo "oops" >> README.txt
    git commit -m "Broken commit"

Observe:
- Nothing happens or Git complains

Fix:

    git add README.txt
    git commit -m "Actually commit change"

---

# 🏁 Phase 18 Completion Criteria

You can:

- Initialize a repo
- Add and commit files
- Create and merge branches
- Inspect history
- Show changed files
- Use diff correctly

---

# 🧠 Phase 18 Law

Git is just structured file history. Treat it like cp with memory.

---

# 🧹 Cleanup

    cd ..
    rm -rf phase-18

---

