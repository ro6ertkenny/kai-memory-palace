# 🧱 LVM — Operator Basics
*Logical Volume Manager: resizing, composing, and surviving disk reality*

---

## 🎯 Purpose

This document teaches you to:

- Understand **what LVM is and why it exists**
- Read and reason about:
  - Physical Volumes (PV)
  - Volume Groups (VG)
  - Logical Volumes (LV)
- Perform **safe, exam-grade operations**:
  - Create
  - Extend
  - Reduce
  - Inspect
  - Mount
- Debug common LVM failures:
  - “No space left”
  - “Device not found”
  - “Filesystem won’t mount”
  - “LV is full but disk is not”

LFCS expects you to be **operationally competent** with LVM.

---

## 🧠 Mental Model

LVM is a **virtualization layer for block devices**.

Stack:

    Disk / Partition
        ↓
    Physical Volume (PV)
        ↓
    Volume Group (VG)  ← pool of storage
        ↓
    Logical Volume (LV) ← looks like a disk

Filesystems live **on LVs**, not directly on disks.

Think:

> “LVM lets me resize and compose disks **without caring** which disk the blocks came from.”

---

## 🧱 The Objects

---

# 1) Physical Volume (PV)

- A disk or partition prepared for LVM
- Created with:

    pvcreate /dev/sdb

Inspect:

    pvs
    pvdisplay

---

# 2) Volume Group (VG)

- A **pool of storage** made of one or more PVs
- Created with:

    vgcreate vg_data /dev/sdb

Extend later:

    vgextend vg_data /dev/sdc

Inspect:

    vgs
    vgdisplay

---

# 3) Logical Volume (LV)

- A **virtual block device** carved from a VG
- Created with:

    lvcreate -L 20G -n lv_data vg_data

Appears as:

    /dev/vg_data/lv_data

Inspect:

    lvs
    lvdisplay

---

## 🧪 Canonical Creation Flow

    lsblk
    pvcreate /dev/sdb
    vgcreate vg_data /dev/sdb
    lvcreate -L 20G -n lv_data vg_data
    mkfs.ext4 /dev/vg_data/lv_data
    mount /dev/vg_data/lv_data /mnt/data

Persist in `/etc/fstab` like any other block device.

---

## 🔍 Inspection Commands You Must Know

    lsblk
    pvs
    vgs
    lvs
    pvdisplay
    vgdisplay
    lvdisplay

Also:

    blkid
    findmnt
    df -h

---

## 📈 Growing Storage (Most Common Operation)

Scenario:

> “The filesystem is full but the disk is not.”

Steps:

1) Add disk (or partition)

    pvcreate /dev/sdc
    vgextend vg_data /dev/sdc

2) Extend LV

    lvextend -L +10G /dev/vg_data/lv_data

Or use all free space:

    lvextend -l +100%FREE /dev/vg_data/lv_data

3) Grow filesystem

For ext4:

    resize2fs /dev/vg_data/lv_data

For xfs:

    xfs_growfs /mnt/data

---

## 📉 Shrinking Storage (Dangerous, Rare)

⚠️ **Never shrink a filesystem while mounted.**

General pattern:

1) Unmount

    umount /mnt/data

2) Check filesystem

    e2fsck -f /dev/vg_data/lv_data

3) Shrink filesystem first

    resize2fs /dev/vg_data/lv_data 15G

4) Shrink LV

    lvreduce -L 15G /dev/vg_data/lv_data

5) Remount

    mount /mnt/data

> Filesystem first, LV second.  
> Reversing this **destroys data**.

---

## 🧯 Common Failure Modes

---

### “No space left on device” but VG has space

Check:

    df -h
    vgs
    lvs

Fix:

> Extend the LV, then grow the filesystem.

---

### “Filesystem won’t mount”

Check:

    lsblk
    blkid
    lvdisplay
    fsck /dev/vg_data/lv_data

Often:

- Wrong device
- Corrupt FS
- LV not active

Activate:

    lvchange -ay vg_data/lv_data

---

### “Device not found”

Check:

    vgs
    lvs
    lvscan

May need:

    vgchange -ay

---

### “Disk added but no space appears”

You forgot:

    pvcreate
    vgextend

---

## 🧠 Operator Rules

- Filesystems live on **LVs**, not disks
- Always inspect:

    lsblk
    pvs
    vgs
    lvs

- Always grow in this order:

    Disk → PV → VG → LV → Filesystem

- Always shrink in this order:

    Filesystem → LV

---

## 🧪 Exam-Grade Tasks You Should Be Able To Do

- Create PV, VG, LV from scratch
- Format and mount an LV
- Extend an LV and filesystem
- Diagnose “disk full” correctly
- Identify which layer is actually full

---

## ⚠️ Dangerous Mistakes

- ❌ Shrinking LV before filesystem
- ❌ Formatting the wrong device
- ❌ Confusing disk vs LV
- ❌ Forgetting to grow the filesystem aft

