# 🧠 Git Mental Model — How Git Actually Works

**Path:** `git/mental-model.md`

This document explains **what Git is**, **what Git stores**, and **what your commands actually change**.

This is not a tutorial.  
This is not a workflow guide.  
This is the **mechanical model** you must carry in your head so every Git command is obvious instead of memorized.

If you understand this file, Git becomes **predictable**.

---

## 🎯 The One-Sentence Truth

> **Git is a content-addressed snapshot database with pointers.**

Not:
- not a file-diff tracker
- not a “change list” system
- not a patch queue

Git stores **complete snapshots of the project**, and moves **pointers** between them.

---

## 🧱 The Three Real Things You Are Manipulating

At all times, Git has **three states**:

1) **Working Tree**
   - Your actual files on disk
   - What you edit with an editor

2) **Index (Staging Area)**
   - The **next snapshot being constructed**
   - What will go into the next commit

3) **HEAD**
   - A pointer to the **current commit snapshot**
   - Usually points to the tip of the current branch

Think:

> Working Tree = messy desk  
> Index = items arranged for packaging  
> HEAD = last shipped box

---

## 📦 What a Commit Really Is

A commit is:

- a **snapshot of the entire tree**
- plus metadata (message, author, time, parent commit)

It is:

- immutable
- content-addressed (by hash)
- never changes once created

> Git does not store “changes”.  
> Git stores **complete states**.

---

## 🌳 What a Branch Really Is

A branch is:

- **just a pointer to a commit**

That’s it.

When you:

    git branch feature

You are creating:

- a new **label** pointing to the same commit

When you commit on that branch:

- the label moves forward
- other branch labels do not

---

## 🧭 What HEAD Really Is

HEAD is:

- a **pointer to a branch**
- which points to a commit

Usually:

    HEAD -> main -> commit123

When you:

    git checkout feature

You are moving:

    HEAD -> feature -> commitXYZ

---

## 🧩 What `git add` Actually Does

`git add` does NOT:

- add a file to a commit
- save history
- make a snapshot

It DOES:

- copy the **current content of the file**
- into the **Index (staging area)**

You are saying:

> “This exact version of this file goes into the next snapshot.”

---

## 🧾 What `git commit` Actually Does

`git commit`:

- takes **exactly what is in the Index**
- creates a **new snapshot**
- moves the current branch pointer to that snapshot

It does NOT:

- look at your working directory directly
- include unstaged changes

---

## 🔍 What `git status` Is Showing You

`git status` is comparing:

- Working Tree vs Index
- Index vs HEAD

It is answering:

- What changed but is not staged?
- What is staged but not committed?

---

## 🧪 What `git diff` Variants Mean

    git diff

- Working Tree vs Index

    git diff --staged

- Index vs HEAD

    git diff HEAD

- Working Tree vs HEAD

---

## 🔄 What a Merge Really Is

A merge is:

- Git finding a **common ancestor snapshot**
- combining the **two snapshot trees**
- producing a **new snapshot commit**

It is not:
- replaying commands
- applying patches line by line conceptually

It is **tree composition**.

---

## 🗂️ What the Repository Really Contains

Inside `.git/`:

- objects/ = snapshots and metadata (content-addressed)
- refs/    = pointers (branches, tags)
- HEAD     = which pointer you are using

> Everything is either **content** or a **pointer**.

---

## 🧷 The Pointer Rule (Critical)

Most Git commands either:

- create snapshots
- move pointers
- change what pointers point to

If you ask:

> “Which pointer moved?”

You understand the command.

---

## 🧠 Command → Mental Effect Map

    git init
    - creates empty object database + refs

    git add
    - copies file content into Index

    git commit
    - creates new snapshot from Index
    - moves current branch pointer

    git branch
    - creates or lists pointers

    git checkout / git switch
    - moves HEAD to point to another branch

    git merge
    - creates a new snapshot from two trees
    - moves current branch pointer

    git log
    - walks snapshot history by following pointers

    git reset
    - moves pointers and/or Index and/or Working Tree depending on mode

---

## 🧯 Why This Model Prevents Mistakes

If you know:

- what is a snapshot
- what is a pointer
- what is in the Index
- what HEAD points to

Then:

- you know what will be committed
- you know what will be lost
- you know what will move
- you know what is safe

---

## 🧱 The Only Three Questions You Ever Need to Ask

1) What is in the **Working Tree**?
2) What is in the **Index**?
3) What does **HEAD** point to?

Everything else follows.

---

## 🧠 Final Law

> Git is not complicated.  
> It is **precise**.

If you think in **snapshots and pointers**, every Git command becomes obvious instead of memorized.

---

