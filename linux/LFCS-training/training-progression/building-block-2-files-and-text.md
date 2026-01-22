# 🧱 Building Block 2 — Files and Text

**Path:** `linux/LFCS-training/training-progression/building-block-2-files-and-text.md`  
**Purpose:** Build operator fluency with **filesystems as a map** and **text as the interface** to Linux state (configs, logs, command output).

---

## 🎯 What This Block Builds

You are building:

- Confidence navigating any filesystem layout under time pressure
- The ability to **find the right file fast**
- The ability to **extract signal from text output** reliably
- The habit of using text tools to audit and validate system state

---

## 🧠 Mental Models You Must Own

- Linux administration is primarily:
  - files (configs, state)
  - text (logs, output)
- Most “mysteries” become obvious when you:
  - find the right file
  - read it carefully
  - filter the right lines
- A command’s output is:
  - a dataset
  - to be filtered, reduced, and verified

Invariants:

- “I can find where the truth lives on disk.”
- “I can filter output to only the relevant lines.”
- “I can validate before I edit.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to find files, inspect content, and filter output without hesitation.

---

## 🧪 Canonical Failure Scenarios

None required at this level.

This block is foundational capability that later scenarios depend on.

---

## ⚙️ Canonical Execution Playbooks

None required at this level.

This block provides primitives used by all later playbooks.

---

## 🧭 Required Capabilities

You must be able to:

### Files as a Map
- Locate files by:
  - name
  - type
  - size/time
  - ownership
- Inspect file metadata quickly:
  - owner/group
  - modes
  - timestamps
  - type
- Move safely between:
  - absolute and relative paths
  - user and system locations

### Read and Compare Text
- View content safely (without editing):
  - head/tail views
  - paging views
- Search within files for specific settings:
  - exact match
  - partial match
  - anchored match
- Compare versions of a file:
  - before/after a change

### Filter Command Output
- Reduce output to only what matters:
  - matching lines
  - excluding lines
  - selecting fields/columns
  - counting occurrences
  - sorting and deduplicating

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- You can locate any file you need using at least two approaches:
  - by name/path search
  - by content search
- You can interpret config and log files without getting lost
- You can filter a long command output down to the one relevant line or field
- You do not “scroll hunt” blindly; you filter

Concrete tests:

- Given a directory tree, you can:
  - find the 10 largest files
  - find files modified in the last day
  - find files owned by a specific user
- Given a config file, you can:
  - find the exact directive
  - confirm whether it is active or commented
  - extract only the effective lines you need to review
- Given a long command output, you can:
  - isolate only failing items
  - count occurrences by category
  - produce a sorted list of unique values

---

## 🔁 Regression Rule

If later you:

- cannot find the correct config file quickly
- miss the relevant log line
- waste time manually scanning output

You must:

> Return here and re-run `files-and-text.md` until locating and filtering are automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **If you can’t find it, you can’t fix it. Locate the truth first.**

---
