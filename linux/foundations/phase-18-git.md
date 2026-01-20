# 🧬 Phase 18 — Git (Essential Version Control for LFCS)
*LFCS execution layer: initialize repos, commit, branch, merge, inspect history, and prove what changed.*

---

## 📌 Purpose

LFCS does **not** test advanced Git workflows. It tests that you can:

- Initialize a repository
- Add and commit files
- Configure a remote and push
- Create a branch, modify, merge back
- Inspect logs and show what changed
- Identify files changed in a commit

This is **operator Git**, not developer Git.

---

## 🧠 Mental Model

- Git is a **time machine for files**
- You care about:
  - What changed?
  - When?
  - In which commit?
- On the exam, Git is a **tool**, not the goal.

---

# 🏗️ Part A — Initialize and Commit

Initialize repo:

    git init

Check status:

    git status

Add files:

    git add .

Commit:

    git commit -m "Initial commit"

---

## Add a Remote and Push

Add remote:

    git remote add origin https://github.com/user/repo.git

Pull first (common in labs):

    git pull origin master

Push:

    git push origin master

---

# 🌱 Part B — Branching and Merging

Create branch:

    git branch documentation

Switch to it:

    git checkout documentation

Or:

    git checkout -b documentation

Modify file, then:

    git add .
    git commit -m "Update docs"

Merge back into main:

    git checkout master
    git merge documentation

Delete branch:

    git branch --delete documentation

---

# 🔍 Part C — Inspect History

Show log:

    git log

Show log with file changes:

    git log --raw

Show last commit only:

    git log -1

Show which files changed in last commit:

    git show --name-only

---

# 🧾 Part D — Show Differences

Diff working tree:

    git diff

Diff staged:

    git diff --staged

Diff between commits:

    git diff COMMIT1 COMMIT2

---

# 🧪 Exam Scenarios

You may be asked to:

- Initialize a repo in /etc or /opt
- Add a config file and commit it
- Create a branch, change file, merge back
- Show which file changed in last commit
- Show commit history including filenames
- Push changes to remote

---

# ⚠️ Failure Modes

- Forgetting git add before commit
- Editing on wrong branch
- Forgetting to checkout master before merge
- Merge conflict panic (exam tasks are simple)
- Forgetting to pull before pushing in shared repo

---

# 🏁 Phase 18 Mastery Checklist

You can:

- Initialize repo
- Add and commit files
- Add remote and push
- Create and delete branches
- Merge branches
- Inspect history
- Show changed files

---

## 🧠 Exam Law

> **Git is just structured file history. Treat it like cp with memory.**

---

