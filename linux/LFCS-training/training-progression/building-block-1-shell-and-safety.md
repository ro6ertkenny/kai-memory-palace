# 🧱 Building Block 1 — Shell, Posture, and Safety

**Path:** `linux/LFCS-training/training-progression/building-block-1-shell-and-safety.md`  
**Purpose:** Establish **safe, fast, and confident shell operation**. This is the foundation for everything that follows.

---

## 🎯 What This Block Builds

You are building:

- Mechanical fluency in the shell
- A **safety-first operator posture**
- The habit of:
  - inspecting before acting
  - verifying targets
  - verifying results

Nothing else in the curriculum works if you are slow or careless here.

---

## 🧠 Mental Models You Must Own

- The shell is a **power tool**, not a toy.
- Every destructive command must be:
  - preceded by inspection
  - followed by verification
- Paths and globbing are **exact**; mistakes are **literal**.
- Pipes and redirection are how operators **compose tools into procedures**.
- You are always operating on **real state**.

Invariants:

- “I know exactly what object I am about to modify or delete.”
- “I can explain what this command will do before I press Enter.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to navigate, inspect, search, copy, move, and remove files and directories **without pausing to recall syntax**.

---

## 🧪 Canonical Failure Scenarios

None required at this level.

This block is about **posture and mechanics**, not diagnosis.

---

## ⚙️ Canonical Execution Playbooks

None required at this level.

This block underpins **all** later playbooks.

---

## 🧭 Required Capabilities

You must be able to:

- Navigate the filesystem confidently:
  - `pwd`, `ls`, `cd`
- Inspect before acting:
  - `ls -l`, `ls -ld`, `stat`, `file`
- Find things:
  - `find`, `which`, `whereis`
- Compose commands:
  - pipes, redirection, command substitution
- Work safely with:
  - `cp`, `mv`, `rm`, `mkdir`, `rmdir`
- Preview effects before destructive actions:
  - `ls` with the same glob
  - `echo` with the same arguments

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- You can:
  - navigate anywhere
  - inspect any path
  - explain what a command will do **before** running it
- You do **not**:
  - use `rm` without verifying the target
  - rely on trial-and-error
- You can:
  - build simple pipelines to answer questions
  - redirect output and errors intentionally

Concrete test:

- Given any path, you can:
  - explain who owns it
  - what type it is
  - what will happen if you remove it
- You can recover from:
  - “I’m in the wrong directory”
  - “I’m not sure what this glob expands to”
  - without panic or guessing

---

## 🔁 Regression Rule

If at any later point you:

- delete the wrong thing
- edit the wrong file
- run a command you “thought” would do something else

You must:

> Return here and re-run `essential-commands.md` until safety and intent are automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Never operate on a path or object you have not just inspected.**

This rule applies to **every single Building Block that follows**.

---

## 🧱 This Block Is the Foundation

Everything else assumes:

- you are fast
- you are precise
- you are safe

Do not rush this.

---
