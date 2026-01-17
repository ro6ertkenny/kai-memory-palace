# 🧱 LVM & Volume Failures — Operator Playbook

**Domain:** Storage, block devices, filesystems, LVM  
**Mental mode:** Layers, not paths  
**Goal:** Determine which storage layer is actually broken and fix the correct one

---

## 📌 What This Domain Actually Covers

This playbook is for failures where:

- The system says:
  - “No space left on device”
  - “Filesystem won’t mount”
  - “Device not found”
  - “Read-only filesystem”
  - “Disk is full” but `df` disagrees
- A volume:
  - Disappears
  - Won’t activate
  - Won’t mount
  - Is smaller than expected
- A filesystem:
  - Is full but the disk isn’t
  - Is corrupt
  - Refuses to grow

Most storage incidents are:

> **Layering mistakes**, not hardware failures.

---

## 🧠 The Mental Model

Storage stack:

    Disk / Partition
        ↓
    Physical Volume (PV)
        ↓
    Volume Group (VG)
        ↓
    Logical Volume (LV)
        ↓
    Filesystem
        ↓
    Mountpoint

Failures almost always come from **confusing one layer for another**.

So always ask:

> “Which layer is actually failing?”

---

## 🔥 First 60 Seconds (Always Run These)

    lsblk
    df -h
    df -i
    mount | grep -E '^/dev'
    pvs || true
    vgs || true
    lvs || true

Interpretation:

- `df` full but VG has space → LV too small
- `lsblk` shows device but mount missing → filesystem/mount issue
- VG/LV missing → LVM activation or metadata issue
- `df -i` full → inode exhaustion, not disk space

---

## 🧭 Step 1 — Is This Even LVM?

Check:

    lsblk
    pvs

If no PV/VG/LV:

> This is a **plain block device** problem, not LVM.

Go to filesystem playbooks instead.

---

## 🧱 Step 2 — Walk the Stack Top to Bottom

---

### A) Mount Layer

    mount
    findmnt
    cat /etc/fstab

Symptoms:

- Wrong device mounted
- Not mounted at all
- Mounted read-only

Fix:

    mount -a
    mount /dev/vg/lv /mnt/path

---

### B) Filesystem Layer

Check:

    blkid
    fsck -n /dev/vg/lv

Symptoms:

- Corruption
- Wrong FS type
- Refuses to mount

Fix (if safe):

    fsck /dev/vg/lv

---

### C) Logical Volume Layer

Check:

    lvs
    lvdisplay
    lvscan

Symptoms:

- LV missing
- LV inactive
- LV too small

Fix:

Activate:

    lvchange -ay vg/lv

Extend:

    lvextend -L +10G /dev/vg/lv

---

### D) Volume Group Layer

Check:

    vgs
    vgdisplay

Symptoms:

- VG missing
- VG has free space but LV doesn’t use it

Fix:

    vgchange -ay
    vgextend vg /dev/sdX

---

### E) Physical Volume Layer

Check:

    pvs
    pvdisplay

Symptoms:

- Disk exists but not in VG
- Disk not initialized

Fix:

    pvcreate /dev/sdX
    vgextend vg /dev/sdX

---

## 📈 Case 1 — “No space left on device” but disk has space

Check:

    df -h
    vgs
    lvs

If:

- VG has free space
- LV is small

Fix:

    lvextend -l +100%FREE /dev/vg/lv

Then grow FS:

ext4:

    resize2fs /dev/vg/lv

xfs:

    xfs_growfs /mountpoint

---

## 📉 Case 2 — “Disk is full” but `df -h` looks fine

Check:

    df -i

If inodes are 100%:

> This is **inode exhaustion**, not block exhaustion.

Fix:

- Delete many small files
- Or rebuild filesystem with higher inode density

---

## 🧨 Case 3 — “Filesystem won’t mount”

Check:

    lsblk
    blkid
    fsck -n /dev/vg/lv

If FS dirty or corrupt:

    fsck /dev/vg/lv

If LV inactive:

    lvchange -ay vg/lv

---

## 🫥 Case 4 — “LV or VG disappeared”

Check:

    vgs
    lvs
    vgscan
    lvscan

Try:

    vgchange -ay

If disk missing:

> This is a **block device or hardware** problem.

---

## 🧪 Case 5 — You extended LV but space didn’t change

You forgot to grow the filesystem.

Check:

    df -h
    lvs

Fix:

ext4:

    resize2fs /dev/vg/lv

xfs:

    xfs_growfs /mountpoint

---

## ⚠️ Dangerous Operations

---

### Shrinking

Rules:

- Never shrink while mounted
- Always:

    umount
    fsck
    resize2fs
    lvreduce
    mount

Reversing this order **destroys data**.

---

### Formatting

Always confirm:

    lsblk
    blkid

Before:

    mkfs.*

---

## 🧠 Canonical Decision Tree

1) Is it mounted?
2) Is the filesystem healthy?
3) Is the LV present and active?
4) Does the VG have space?
5) Is the disk actually there?

> **Never skip layers.**

---

## 🛑 Escalation Criteria

Escalate or stop if:

- FS corruption is severe
- Metadata is missing
- Disks disappear from `lsblk`
- Multiple LVs/VGs vanish

---

## 🏁 Canonical Summary

- Storage failures are **layering failures**
- LVM adds power, not magic
- Most incidents are:

> “The LV is full, not the disk.”

Or:

> “The filesystem was never grown.”

- Always debug:

    Disk → PV → VG → LV → FS → Mount

