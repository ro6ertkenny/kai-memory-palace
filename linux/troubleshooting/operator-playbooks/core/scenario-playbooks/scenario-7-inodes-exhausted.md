# 🧰 Operator Playbook — Scenario 7: “Inodes Exhausted”

**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md  
**Why this domain:** The incident is an inode allocation failure, not a performance or scheduling problem.

---

## 🎯 The Symptom

- Commands fail with:

    No space left on device

- But:

    df -h

…shows plenty of free space.

- Writes, temp files, logs, or package installs fail.
- Often happens on:
  - `/var`
  - `/tmp`
  - container storage
  - mail spools
  - cache directories

---

## 🧠 The Critical Mental Model

> Filesystems have **two limits**:
> - Data blocks (space)
> - **Inodes** (number of files)

You can run out of **inodes** long before you run out of **space**.

Small files can kill a filesystem.

---

## 🧪 Phase 1 — Prove It’s Inodes (Not Space)

### 1) Check space

    df -h

If space looks fine, continue.

### 2) Check inodes

    df -i

Look for:
- A filesystem at or near **100% IUse%**

Example:

    Filesystem      Inodes  IUsed   IFree IUse% Mounted on
    /dev/sda1      6553600 6553600       0  100% /var

### Decision

- If IUse% = 100% → **inode exhaustion confirmed**
- If not → this is a different disk problem

---

## 🔍 Phase 2 — Find Where the Inodes Are Going

You are looking for **directories with insane file counts**.

### 1) Start at the mount point

Example for `/var`:

    sudo du -x --inodes -d 1 /var | sort -n

Or (older du versions):

    sudo find /var -xdev -type f | wc -l

### 2) Drill down

    sudo du -x --inodes -d 1 /var/log | sort -n
    sudo du -x --inodes -d 1 /var/cache | sort -n
    sudo du -x --inodes -d 1 /var/tmp | sort -n

Repeat until you find:
- The directory with **hundreds of thousands or millions of files**

---

## 🧨 Phase 3 — The Usual Culprits

Common inode killers:

- Log directories with per-request or per-event files
- App temp directories
- Mail queues
- Package caches
- Container overlay layers
- Crash dump directories
- Badly written apps creating millions of tiny files

---

## 🧯 Phase 4 — Fix It Safely

### 1) Identify what the files are

    ls | head
    ls | wc -l

Do **not** blindly delete until you know:

- What created them
- Whether the service is still running and recreating them

---

### 2) Stop the source first (if applicable)

If a service is generating the files:

    systemctl stop servicename

Or scale it down / stop the container.

---

### 3) Remove files in controlled batches

Example:

    rm -rf /path/to/bad/dir/*

Or safer:

    find /path/to/bad/dir -type f | head
    find /path/to/bad/dir -type f -delete

---

### 4) Verify recovery

    df -i

You should see:
- IFree increasing
- IUse% dropping

---

## 🧱 Phase 5 — Prevent It from Happening Again

- Fix the app or config
- Add:
  - log rotation
  - tmp cleanup
  - cache eviction
- Consider:
  - separate filesystem
  - different filesystem with more inodes
  - monitoring inode usage

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| df -h full | Space exhaustion | Free space |
| df -h fine, df -i full | Inode exhaustion | Delete files |
| Millions of tiny files | Runaway file creation | Fix app |
| Inodes refill after cleanup | Source still running | Stop or fix source |

---

## ⚠️ Operator Warnings

- Inode exhaustion can:
  - break package managers
  - break logging
  - break SSH
  - break systemd
- A system can become **effectively unusable** even with lots of free space.

---

## 🏁 The Operator Rule

> Disk problems are **space OR inodes**. Always check both.

---

## 🧠 One-Sentence Operator Summary

> “If the disk says ‘no space left’ but df -h looks fine, check df -i — you’ve probably run out of inodes.”

---

## 🧾 The Minimal Proof Commands

    df -h
    df -i
    sudo du -x --inodes -d 1 /mountpoint | sort -n

