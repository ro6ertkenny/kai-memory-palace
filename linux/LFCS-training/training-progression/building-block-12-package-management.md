# 🧱 Building Block 12 — Package Management

**Path:** `linux/LFCS-training/training-progression/building-block-12-package-management.md`  
**Purpose:** Build the ability to **install, inspect, repair, and trust the system’s package state** so that software management is predictable and recoverable.

---

## 🎯 What This Block Builds

You are building:

- Confidence in:
  - installing and removing software
  - verifying what is installed
  - understanding where files come from
- The ability to:
  - recognize a **broken package system**
  - repair it safely
  - restore a **consistent, trusted state**

This block turns “apt/dnf is broken” into a **controlled repair procedure**.

---

## 🧠 Mental Models You Must Own

- The package manager is:
  - the **source of truth** for installed software
  - a database plus repositories
- A broken package system is:
  - a system integrity problem
- Installing software by hand outside the package manager:
  - creates **invisible, untracked state**
- Locks and half-installed packages:
  - are symptoms of interrupted operations

Invariants:

- “I trust the package manager more than random files on disk.”
- “I repair the package system before installing more things.”
- “I do not delete package databases.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/package-management.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

Rule:

> You should be able to install, remove, query, and verify packages **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- “Package manager is locked”
- “Half-installed packages”
- “Dependency resolution failure”

(These are covered operationally by the playbook below.)

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`

Rule:

> You should never attempt random fixes when the package system is broken. Follow the playbook.

---

## 🧭 Required Capabilities

You must be able to:

### Normal Operations

- Install and remove packages
- Query:
  - whether something is installed
  - which package owns a file
  - what files a package provides
- Update:
  - package lists
  - installed packages

### Diagnose Breakage

- Recognize:
  - lock errors
  - dependency errors
  - broken/half-installed states
- Determine:
  - whether the problem is:
    - a package
    - the database
    - the repositories

### Repair Safely

- Clear:
  - stale locks
- Repair:
  - half-installed packages
  - broken dependencies
- Restore:
  - a working install/remove/update cycle

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- You can:
  - install and remove packages normally
  - explain where a binary came from
- Given a broken package system, you can:
  - restore it to a working state
  - without deleting databases or reinstalling the OS
- You do not:
  - “just reboot and hope”
  - install software by random scripts when the package system is broken

Concrete tests:

- You can:
  - recover from an interrupted package install
  - fix a dependency failure
  - clear a stuck lock safely

---

## 🔁 Regression Rule

If later you:

- see package errors and ignore them
- start manually copying binaries around
- make package state worse by guessing

You must:

> Return here and re-run `package-management.md` and the package repair playbook until system integrity is respected again.

---

## 🧠 Operator Rule (Carry Forward)

> **The package manager is the source of truth. Fix it before trusting anything else.**

---

## 🧱 This Block Enables

- Safe software installation
- Reliable updates
- Trustworthy service deployment
- All higher-level configuration work

Without this block, **system state becomes unknowable**.

---
