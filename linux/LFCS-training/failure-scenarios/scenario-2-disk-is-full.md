# 🧯 Scenario 2 — Disk Is Full (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md` (if a process is the producer)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if a managed service is involved)

---

## 📌 Incident Brief (Symptom-First)

Commands or services fail with:

> “No space left on device”

Writes are failing. Services may crash or refuse to start. Shells may behave oddly.

Your job is to:
- identify **which filesystem** is impacted
- determine **space vs inode** exhaustion
- locate the **offending subtree or producer**
- restore **safe headroom**
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Name the exact filesystem under pressure
- State whether the failure was:
  - **space exhaustion** or
  - **inode exhaustion**
- Identify the top offending directory tree **or** the producing process
- Apply the **smallest safe cleanup**
- Prove:
  - headroom exists
  - the producer is controlled
  - services can write again

---

## 🧠 Operator Rule

> **Never delete before you know which filesystem and which directory tree is responsible.**  
> **Always restore headroom first; then fix the cause.**

---

## 🧭 Classification Buckets

Place the incident into one bucket before acting:

1) **Space exhaustion** (bytes)
2) **Inode exhaustion** (file count)
3) **Log explosion**
4) **Cache/temp growth**
5) **Runaway writer (process or service)**
6) **User data growth**
7) **Deleted-but-open files still consuming space**

---

## 🧪 Required Evidence (Global Snapshot)

Capture at least one snapshot:

  df -h
  df -i

Interpretation anchors:

- `df -h`
  - Find filesystems near 100%.
  - This answers: “**Which filesystem** is full?”

- `df -i`
  - If inodes are 100%, you are out of **file entries**, not bytes.

Decision gate:

- If **space** is full → proceed to locate bytes.
- If **inodes** are full → look for trees with **millions of small files**.

---

## 🔎 Locate the Offending Tree (Stay on the Filesystem)

Start at the mountpoint of the affected filesystem (example assumes `/` or `/var`):

  sudo du -x -sh /* | sort -h

Notes:
- `-x` stays on the same filesystem.
- This gives a **top-level size map**.

Then drill down the largest entries:

  sudo du -x -sh /var/* | sort -h
  sudo du -x -sh /var/log/* | sort -h
  sudo du -x -sh /home/* | sort -h

Repeat until you find the **offending subtree**.

---

## 🧩 Check for “Deleted but Open” Files (Common Trap)

If `df -h` shows full but `du` can’t account for it:

  sudo lsof | rg '(deleted)'

Or:

  sudo lsof +L1

If you see large deleted files still held open:
- identify the owning process
- restart or stop it **after** planning impact

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Space exhaustion from logs/cache/temp
Signals:
- `df -h` full, `df -i` OK
- `du` points to `/var/log`, cache, or temp
Route:
- `storage-recovery-playbook.md`
Goal:
- truncate or clean **known safe** locations
Proof:
- `df -h` shows restored headroom
- services resume writing

### Fork B — Inode exhaustion
Signals:
- `df -i` shows 100%
- many tiny files (spool, cache, temp, app dirs)
Route:
- `storage-recovery-playbook.md`
Goal:
- remove **safe** high-count trees
Proof:
- `df -i` shows headroom
- file creation succeeds again

### Fork C — Runaway writer (process/service)
Signals:
- a single tree grows rapidly
- or `lsof` shows a process holding huge files
Route:
- `process-control-playbook.md` (to stop/throttle)
- then `storage-recovery-playbook.md`
Proof:
- growth stops
- space is reclaimed
- root cause identified

### Fork D — User data growth
Signals:
- `/home` or user mount dominates
Route:
- `storage-recovery-playbook.md`
Goal:
- coordinate or move/archive data safely
Proof:
- headroom restored without data loss

---

## 🚫 Forbidden Actions (Diagnosis Phase)

Until you know **which filesystem** and **which tree**:

- Do not `rm -rf` randomly
- Do not “just free some space”
- Do not delete system directories blindly
- Do not reboot as a first move

Every deletion must be:
- targeted
- justified
- reversible if possible

---

## 🧯 Recovery Principles (Minimal, Safe)

- Prefer:
  - truncating logs
  - clearing **known** caches
  - removing **known** temp files
- Stop the producer **before** or **while** cleaning if it is still writing.
- Restore **headroom**, not just “0 bytes free”.

After cleanup:

  df -h
  df -i

---

## ✅ Verification (Required Proof)

- `df -h` shows safe headroom (not 99–100%)
- `df -i` shows inode headroom
- The failing service or command now works
- If a producer was involved:
  - confirm it is stopped, throttled, or fixed

Optional sanity:

  systemctl --failed

---

## 🧾 Post-Incident Debrief

Answer:

- Which filesystem was full?
- Was it space or inodes?
- What tree or process caused it?
- What was the minimal safe cleanup?
- What change prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Deleting before locating the mountpoint
- Cleaning the wrong filesystem
- Freeing space without stopping the producer
- Treating inode exhaustion like space exhaustion
- Leaving the system at 99% full and calling it “fixed”

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you hesitated locating the right filesystem or tree:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-10-storage-fundamentals.md`

### If you missed deleted-but-open files or the real producer:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`

### If this was caused by a service or job:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

Purpose of this section:
- close the exact gap revealed by the incident
- improve classification speed next time
- prevent recurrence

---
