# 🧱 LVM — Operator Basics
Logical Volume Manager: resizing, composing, and surviving disk reality

---

## Purpose

You must be able to:

- Understand the LVM object model:
  - PV (Physical Volume)
  - VG (Volume Group)
  - LV (Logical Volume)
- Create PV/VG/LV, format, mount, and persist
- Extend storage safely (most common)
- Reduce storage safely (rare, dangerous)
- Debug common failures

---

## Mental model

LVM is a virtualization layer for block devices.

Stack:

    Disk / Partition
        ↓
    Physical Volume (PV)
        ↓
    Volume Group (VG)  ← pool of storage
        ↓
    Logical Volume (LV) ← virtual block device

Filesystems live on LVs, not directly on disks.

---

## The objects

### PV (Physical Volume)

Create:

    pvcreate /dev/sdb

Inspect:

    pvs
    pvdisplay

### VG (Volume Group)

Create:

    vgcreate vg_data /dev/sdb

Extend pool:

    vgextend vg_data /dev/sdc

Inspect:

    vgs
    vgdisplay

### LV (Logical Volume)

Create:

    lvcreate -L 20G -n lv_data vg_data

Device path:

    /dev/vg_data/lv_data

Inspect:

    lvs
    lvdisplay

---

## Canonical creation flow (exam-grade)

    lsblk -f
    pvcreate /dev/sdb
    vgcreate vg_data /dev/sdb
    lvcreate -L 20G -n lv_data vg_data
    mkfs.ext4 /dev/vg_data/lv_data
    sudo mkdir -p /mnt/data
    sudo mount /dev/vg_data/lv_data /mnt/data
    blkid /dev/vg_data/lv_data

Persist like any block device in `/etc/fstab` (prefer UUID):

    sudo vi /etc/fstab
    sudo mount -a
    sudo findmnt --verify

---

## Inspection commands you must know

LVM layers:

    pvs
    vgs
    lvs
    pvdisplay
    vgdisplay
    lvdisplay

System context:

    lsblk -f
    blkid
    findmnt
    df -hT

---

## Growing storage (common)

Goal:

“Filesystem is full but VG has free space.”

1) Add disk to VG (PV -> VG):

    pvcreate /dev/sdc
    vgextend vg_data /dev/sdc

2) Extend LV:

    lvextend -L +10G /dev/vg_data/lv_data

Or consume all free space:

    lvextend -l +100%FREE /dev/vg_data/lv_data

3) Grow filesystem:

ext4:

    resize2fs /dev/vg_data/lv_data

xfs (must be mounted):

    xfs_growfs /mnt/data

---

## Shrinking storage (rare, dangerous)

Rule: never shrink while mounted. Shrink filesystem first, then LV.

Pattern (ext4 only; xfs cannot shrink):

1) Unmount:

    sudo umount /mnt/data

2) Check filesystem:

    sudo e2fsck -f /dev/vg_data/lv_data

3) Shrink filesystem first:

    sudo resize2fs /dev/vg_data/lv_data 15G

4) Shrink LV second:

    sudo lvreduce -L 15G /dev/vg_data/lv_data

5) Remount:

    sudo mount /dev/vg_data/lv_data /mnt/data

---

## Activation / discovery (common debug path)

If LVs disappear after boot or device changes:

Scan:

    pvscan
    vgscan
    lvscan

Activate a VG:

    vgchange -ay vg_data

Activate an LV:

    lvchange -ay vg_data/lv_data

---

## Common failure modes

### “No space left on device” but disk seems fine

Check which layer is full:

    df -hT /mnt/data
    vgs
    lvs

Fix:
- extend LV
- grow filesystem

### “Device not found” / “VG not found”

Check:

    pvs
    vgs
    lvscan

Fix:

    vgchange -ay
    lvchange -ay vg_data/lv_data

### “Filesystem won’t mount”

Check:

    lsblk -f
    blkid /dev/vg_data/lv_data
    lvdisplay /dev/vg_data/lv_data

Then consider filesystem check:

    sudo fsck /dev/vg_data/lv_data

---

## Operator rules

- Always inspect first:

    lsblk -f
    pvs
    vgs
    lvs

- Grow order:

    Disk → PV → VG → LV → Filesystem

- Shrink order (ext4 only):

    Filesystem → LV

- Do not confuse disk paths with LV paths.

---

## Exam-grade tasks

- Create PV/VG/LV, format, mount, persist via fstab
- Extend LV and filesystem correctly
- Identify which layer is full and fix the correct layer
- Reactivate VGs/LVs after detection issues

---

## Related drills

- linux/LFCS-training/execution-drills/

---

## Exam memory hook

LVM is block-device virtualization. Always reason in layers: PV → VG → LV → FS.

