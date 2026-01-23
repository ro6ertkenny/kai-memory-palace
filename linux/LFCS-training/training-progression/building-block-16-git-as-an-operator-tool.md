# 🧱 Building Block 16 — Git as an Operator Tool

**Path:** `linux/LFCS-training/training-progression/building-block-16-git-as-an-operator-tool.md`  
**Purpose:** Build the ability to **use Git safely in operational workflows**, recover from mistakes, and treat version control as a **safety system**, not a hazard.

---

## 🎯 What This Block Builds

You are building:

- Confidence using Git to:
  - track changes to configs, docs, and scripts
  - move between known-good states
  - recover from mistakes without panic
- The discipline to:
  - inspect state before changing history
  - choose the **least destructive** recovery method
  - verify after every operation

This block turns “I broke the repo” into a **reversible, inspectable event**.

---

## 🧠 Mental Models You Must Own

- Git is:
  - a history graph
  - with multiple safe exit ramps
- Almost nothing is truly lost:
  - `reflog` remembers
- There are **different classes of mistakes**:
  - uncommitted changes
  - bad commits
  - detached HEAD
  - wrong reset
- Rewriting history is:
  - a last resort
  - and has consequences

Invariants:

- “I always run `git status` before and after operations.”
- “I know whether my mistake is local or already committed.”
- “I prefer revert over reset when history matters.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/git.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to inspect repo state and choose the correct recovery action **without guessing**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- “Detached HEAD”
- “Accidental reset”
- “Bad commit”
- “Accidental file deletion”

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`

Rule:

> You should always follow the git recovery playbook instead of improvising destructive commands.

---

## 🧭 Required Capabilities

You must be able to:

### Inspect State

- Determine:
  - current branch
  - whether HEAD is detached
  - whether working tree is clean or dirty
- Inspect:
  - recent history
  - reflog entries

### Recover from Common Mistakes

- Restore:
  - deleted or modified files
- Handle:
  - detached HEAD safely
  - bad commits (revert vs reset)
  - accidental history movement

### Choose Safe Operations

- Decide when to:
  - revert
  - reset
  - checkout/restore
  - create a rescue branch
- Avoid:
  - rewriting history unless explicitly required

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given any Git mistake, you can:
  - classify what kind it is
  - choose a safe recovery path
- You can:
  - recover lost work using reflog
  - restore files without panic
- You do not:
  - run destructive commands without checking status and log
  - guess at which commit to reset to

Concrete tests:

- You can:
  - recover from a detached HEAD with commits
  - undo a bad commit safely
  - restore a deleted file from history

---

## 🔁 Regression Rule

If later you:

- lose work because you didn’t check status
- panic and run random reset commands
- forget that reflog exists

You must:

> Return here and re-run `git.md` and the git recovery playbook until recovery is calm and mechanical again.

---

## 🧠 Operator Rule (Carry Forward)

> **Git is a safety system. Use it deliberately, not emotionally.**

---

## 🧱 This Block Enables

- Safe operational change tracking
- Confident rollback of config or script changes
- Reliable collaboration workflows (as exam scope requires)

Without this block, **version control becomes a source of risk instead of safety**.

---

