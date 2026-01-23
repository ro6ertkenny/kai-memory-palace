# 🧱 Building Block 1 — Shell, Posture, and Safety

**Path:** `linux/LFCS-training/training-progression/building-block-1-shell-and-safety.md`  
**Purpose:** Establish **safe, fast, and confident shell operation**. This is the foundation for everything that follows.

This block is a **gate**. If this is weak, every later block becomes slow and error-prone.

---

## 🎯 What This Block Builds

You are building:

- Mechanical fluency in the shell
- A safety-first operator posture
- A consistent operator loop:
  - inspect → act → verify
- Predictable control of:
  - paths
  - quoting
  - glob expansion
  - pipes and redirection

---

## 🧠 Mental Models You Must Own

- The shell is a **power tool**, not a toy.
- Every destructive command must be:
  - preceded by inspection
  - followed by verification
- Paths and globbing are **literal**; mistakes are **literal**.
- Pipes and redirection compose tools into procedures.
- You are always operating on real state.

Invariants:

- “I know exactly what object I am about to modify or delete.”
- “I can explain what this command will do before I press Enter.”
- “I can prove what changed after I run it.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/shell-execution-and-redirection.md`

Definition of mastery for this block:

- You can execute the drill actions **without pausing to recall syntax**
- You can explain **what will happen** before you run the command
- You can verify outcomes using inspection commands, not hope

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

You must be able to do the following reliably.

### 1) Navigation and orientation

- `pwd`, `ls`, `cd`
- Identify “where am I?” and “what am I about to touch?” instantly

### 2) Inspection before action

- `ls -l`, `ls -ld`, `stat`, `file`
- Recognize:
  - file vs directory vs symlink
  - owner/group
  - basic permission posture
  - timestamps

### 3) Safe change operations

- `cp`, `mv`, `mkdir`, `rmdir`, `rm`

Safety behaviors (mandatory):

- Verify targets before destructive actions:
  - run `ls` on the same path/glob you intend to use
  - use `echo` to preview arguments/globs
- Confirm results after the action:
  - re-run `ls -l` / `stat` on the affected object(s)

### 4) Finding and locating

- `find`
- `which`, `whereis`

### 5) Composition primitives

- pipes: `|`
- redirection: `>`, `>>`, `2>`, `&>`
- command substitution: `$(...)`

You must be able to answer simple operational questions with a pipeline, without trial-and-error.

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true.

### A) Prediction
- You can explain what a command will do **before** running it.
- You can predict the target set when globs or `find` are involved.

### B) Safety posture
- You do not run `rm` without verifying the target.
- You do not “try things” in a real directory to see what happens.
- You do not act on a path you haven’t just inspected.

### C) Verification
- After any action, you verify outcomes by inspection.
- You can prove what changed (or that nothing changed).

---

## 🧪 Concrete Gate Test (Run in a Scratch Directory)

Create a scratch directory and demonstrate all of the following in one session:

- Create a nested tree and files
- Copy and move files safely
- Delete only the intended targets
- Use a pipeline to answer a question about the tree
- Use `find` to locate a file by name pattern
- Use redirection intentionally (capture output and errors)

Pass condition:

- Zero target mistakes
- Zero “surprise” glob expansions
- You can narrate intent → action → verification for each step

---

## 🔁 Regression Rule

If at any later point you:

- delete the wrong thing
- edit the wrong file
- run a command you “thought” would do something else

You must:

> Return here and re-run:
> - `linux/LFCS-training/execution-drills/essential-commands.md`
> - `linux/LFCS-training/execution-drills/shell-execution-and-redirection.md`
> until safety and intent are automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Never operate on a path or object you have not just inspected.**

This rule applies to every Building Block that follows.

---

