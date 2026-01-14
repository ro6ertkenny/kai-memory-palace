# 🧰 Operator Playbook — Scenario 11: “Disk Full After Deleting Files (Deleted-but-Open)”

**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md  
**Why this domain:** The filesystem cannot reclaim space because blocks are still held by open file descriptors, which is an allocation failure.

---

## 🎯 The Symptom

- `df -h` shows the filesystem is full
- You delete large files
- `df -h` does **not** change
- The system is still out of space
- Services may still fail with:
  - “No space left on device”

This feels impossible until you know the rule:

> **On Unix, disk space is freed only when the last file descriptor is closed.**

---

## 🧠 The Critical Mental Model

A file has:

- A **name** (directory entry)
- **Inodes + blocks**
- **Open file descriptors** held by processes

If you:

- Delete the name
- But a process still has the file open

Then:

> The space is still allocated until that process closes the file.

This is **not a bug**. This is core Unix behavior.

---

## 🧪 Phase 1 — Prove It’s This Problem

### 1) Check disk usage

    df -h

Confirm:

- Which filesystem is full

---

### 2) Check visible usage

    du -x -sh /* | sort -h

If:

- `du` does **not** explain the fullness
- But `df` says it’s full

Then:

> Space is being held by **deleted-but-open files**.

---

## 🔎 Phase 2 — Find the Culprit Files

### 1) Use lsof to find deleted open files

    sudo lsof +L1

Or:

    sudo lsof | grep deleted

You will see entries like:

- A process
- Holding a file
- Marked `(deleted)`
- With a large size

That process is **still holding the disk blocks**.

---

## 🧠 Phase 3 — Understand What You’re Looking At

Typical causes:

- Log files that were deleted while a service is running
- Temporary files removed by cleanup scripts
- Databases or apps holding old rotated files
- Containers holding deleted layers or logs

The space will **not** return until:

- The process exits
- Or the file descriptor is closed

---

## 🛠️ Phase 4 — Fix It Safely

### Option A — Restart the service (preferred)

If the file belongs to a service:

    sudo systemctl restart servicename

This:

- Closes file descriptors
- Releases the space immediately

Then verify:

    df -h

---

### Option B — Kill the process (if safe)

If it’s a one-off process:

    kill PID

Or if needed:

    kill -9 PID

Then verify:

    df -h

---

### Option C — Truncate via /proc (advanced, use carefully)

If you **cannot restart** the process:

Find the FD:

    ls -l /proc/PID/fd/

Then:

    : > /proc/PID/fd/FDNUMBER

This:

- Truncates the file to zero
- Keeps the process running
- Frees the space

Use only when you understand the impact.

---

## 🧪 Phase 5 — Verify

    df -h

You should see:

- Space immediately reclaimed

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| df full, du normal | Hidden usage | Find deleted-open files |
| lsof shows deleted big files | Process holding space | Restart or kill process |
| Space frees after restart | Confirmed cause | Root cause fixed |
| Keeps happening | Log rotation or app bug | Fix config |

---

## ⚠️ Operator Warnings

- This happens **all the time** with logs.
- Logrotate + services that don’t reopen logs is the classic cause.
- Containers and long-running daemons are common offenders.
- Reboot also fixes it — but that’s the **nuclear option**.

---

## 🏁 The Operator Rule

> If `df` and `du` disagree, the space is being held by **deleted-but-open files**.

---

## 🧠 One-Sentence Operator Summary

> “When disk is full but deleting files doesn’t help, find the processes holding deleted files open and restart or kill them to release the space.”

---

## 🧾 The Minimal Proof Commands

    df -h
    du -x -sh /* | sort -h
    sudo lsof +L1
    sudo lsof | grep deleted
    ls -l /proc/PID/fd/

