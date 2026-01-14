# 🧱 Disk Exhaustion — Operator Playbook

**Domain:** Filesystem space and inode exhaustion  
**Mental mode:** Allocation failure, not performance  
**Goal:** Determine why the filesystem cannot allocate space or metadata

---

## 📌 What Disk Exhaustion Actually Means

Disk exhaustion means:

> The filesystem cannot allocate **data blocks** or **inodes**.

This is not about “disk is slow”.
This is about:

- No free blocks
- No free inodes
- Or space that is **logically unavailable** due to filesystem semantics

When disk exhaustion is present:

- Writes fail with `ENOSPC`
- Services crash or refuse to start
- Package managers fail
- Logs stop writing
- Sometimes **deleting files does nothing**

---

## 🔥 Primary Fast Signals

Run these immediately:

    df -h
    df -i
    mount | column -t
    dmesg | tail -n 50

Interpretation:

- `df -h` shows block usage
- `df -i` shows inode usage
- If either is at 100% → you are out
- `dmesg` may show:
  - “No space left on device”
  - “Remounting filesystem read-only”

---

## 🧠 The Mental Model

A filesystem has:

- A fixed number of **blocks**
- A fixed number of **inodes**

You can run out of either.

Also:

> Deleting a file does **not** free space if a process still has it open.

Space is only returned when:
- The last reference is closed

---

## 🧭 Differentiation: Space vs IO vs Memory

### Looks like disk exhaustion if:

- You get `ENOSPC`
- `df` or `df -i` shows 100%
- Services fail immediately on write
- The filesystem may remount read-only

### Looks like IO pressure instead if:

- Commands hang
- Processes stuck in `D` state
- No explicit “no space” errors

### Looks like memory pressure instead if:

- OOMs
- Reclaim activity
- Swap activity

---

## 🧪 Deep Inspection Commands

### Find what is using space

    du -xhd1 /
    du -xhd1 /var
    du -xhd1 /var/log

### Find deleted-but-open files

    lsof | grep '(deleted)'

Or:

    ls -l /proc/*/fd/* | grep deleted

### Check filesystem reservation

    tune2fs -l /dev/<device> | grep -i reserved

(ext filesystems reserve space for root)

---

## 🧯 Common Root Cause Classes

1. **Log growth**
   - Log rotation broken
   - Debug logging left on

2. **Unbounded data directories**
   - Caches
   - Uploads
   - Spool directories

3. **Deleted-but-open files**
   - Large log deleted but process still writing
   - Space not freed

4. **Inode exhaustion**
   - Millions of tiny files
   - Package caches
   - Temp directories

5. **Filesystem remounted read-only**
   - Due to detected corruption
   - Space situation will not improve until fixed

---

## 🛑 Stabilization Actions (In Order)

1. **Check block and inode usage**

        df -h
        df -i

2. **Find biggest consumers**

        du -xhd1 /

3. **Check for deleted-but-open files**

        lsof | grep deleted

4. **Restart offending processes**
   - This actually frees the space

5. **If inode exhaustion**
   - Remove directories with huge file counts

6. **If remounted read-only**
   - Stop
   - Prepare for fsck or controlled reboot

---

## ⚠️ Dangerous Misinterpretations

- “I deleted files but df didn’t change”
  - The space is still held open by a process.

- “df shows space but I still get ENOSPC”
  - You may be out of inodes.

- “Let’s just keep deleting things”
  - If the FS is read-only, nothing will help.

---

## 🧨 When Disk Exhaustion Becomes Systemic

You will see:

- Package installs fail
- Services fail to start
- Logging stops
- Databases may crash or corrupt
- Kubernetes nodes go NotReady due to disk pressure

At this point:

> This is no longer an application issue.  
> This is a **node health failure**.

---

## 🧱 Escalation Criteria

Escalate or cordon/drain the node if:

- Root filesystem is full
- Inodes are exhausted
- Filesystem is read-only
- You cannot reclaim space safely

In Kubernetes:

> Cordon and drain. Then repair the node.

---

## 🧠 Canonical Summary

- Disk exhaustion = **allocation failure**
- Watch:
  - `df -h`
  - `df -i`
  - deleted-but-open files
- Deleting files does not always free space
- Always ask:
  > “Am I out of blocks, inodes, or both?”

---

## 🧭 This Domain Explains These Scenarios

- “No space left on device”
- “But df shows space”
- “Deleting files didn’t help”
- “Filesystem went read-only”
- “Packages won’t install”

All of these reduce to:

> The filesystem cannot allocate.

---
