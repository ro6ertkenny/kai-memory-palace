# 🧱 Building Block 11 — Storage Recovery

**Path:** `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`  
**Purpose:** Build the operational ability to **diagnose and recover from storage failures** safely: disk full, wrong mount, read-only filesystems, and boot-risky fstab mistakes.

---

## 🎯 What This Block Builds

You are building:

- The ability to:
  - recognize **which class** of storage failure you’re in
  - choose **safe, minimal actions** first
  - restore service and data visibility **without making things worse**
- The discipline to:
  - confirm mount state before deleting anything
  - free space surgically
  - validate fstab changes before reboot

This block turns “the disk is full / nothing writes / it won’t mount” into a **controlled recovery procedure**.

---

## 🧠 Mental Models You Must Own

- “Disk full” can mean:
  - the real filesystem is full
  - or the wrong filesystem is mounted
  - or a mount failed and you’re writing to the root FS
- A filesystem can be:
  - present but not mounted
  - mounted read-only due to errors
- fstab is:
  - a boot contract
  - one bad line can prevent boot
- Deleting data is:
  - **irreversible**
  - and should never be your first move

Invariants:

- “I verify mount state before freeing space.”
- “I identify what is consuming space before deleting.”
- “I test fstab changes before reboot.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Rule:

> You should be able to inspect mounts, usage, and large consumers **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised in this block:

- `linux/LFCS-training/failure-scenarios/scenario-b-disk-is-full.md`

Also overlaps with:

- “Filesystem mounted read-only”
- “Data missing after reboot (mount failed)”

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

Rule:

> You should never free space or edit fstab without following this playbook.

---

## 🧭 Required Capabilities

You must be able to:

### Classify the Failure

- Determine:
  - which filesystem is full
  - whether the correct filesystem is mounted
  - whether the filesystem is read-only
- Prove:
  - what device backs the path
  - what is actually consuming space

### Free Space Safely

- Identify:
  - largest directories
  - largest files
- Choose:
  - safe-to-remove data (logs, caches, temp)
- Avoid:
  - deleting application data blindly

### Recover Mount State

- Mount:
  - missing filesystems
  - at the correct mountpoint
- Fix:
  - wrong or missing fstab entries
- Test:
  - with `mount -a` before reboot

### Handle Read-Only Filesystems

- Recognize:
  - kernel forced read-only due to errors
- Take:
  - appropriate recovery actions (as exam scope allows)
- Restore:
  - writable state when possible

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given “disk full”, you can:
  - identify the exact filesystem
  - identify what is consuming space
  - free space **without touching unknown data**
- Given “data disappeared after reboot”, you can:
  - prove a mount failed
  - restore the correct mount
- You can:
  - edit fstab
  - test it safely
  - explain why it is correct

Concrete tests:

- You can:
  - recover from a full root filesystem
  - recover from a missing data mount
  - fix a broken fstab entry without breaking the system further

---

## 🔁 Regression Rule

If later you:

- delete data before checking mount state
- break boot with a bad fstab edit
- cannot explain where disk space actually went

You must:

> Return here and re-run `storage-and-mounts.md` and the storage recovery playbook until recovery is disciplined and calm.

---

## 🧠 Operator Rule (Carry Forward)

> **Never delete data to fix “disk full” until you prove the right filesystem is mounted.**

---

## 🧱 This Block Enables

- Safe disk pressure recovery
- Correct mount restoration
- Confident fstab management
- Prevention of catastrophic “oops, wrong filesystem” mistakes

Without this block, **storage incidents can permanently destroy data**.

---

