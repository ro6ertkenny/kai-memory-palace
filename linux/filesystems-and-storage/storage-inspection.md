# storage-inspection.md

Goal: Reliably inspect disks, partitions, filesystems, mounts, and swap **before** making changes.

---

## Mental model

- Catastrophic storage mistakes come from touching the wrong device.
- Inspection is always step zero.
- You must answer:
  - What block devices exist?
  - What partitions exist?
  - What filesystems exist (type/UUID/label)?
  - What is mounted, where, and with what options?
  - What is swap, and is it active?

---

## Core inspection commands (operator baseline)

    lsblk
    lsblk -f
    blkid
    findmnt
    df -hT
    mount
    sudo fdisk -l
    swapon --show

---

## lsblk — primary map

Show devices:

    lsblk

Show filesystems + UUIDs + mountpoints:

    lsblk -f

Target a single disk:

    lsblk -f /dev/sdb

Operator rule:
- verify whether you are looking at a disk (`/dev/sdb`) vs a partition (`/dev/sdb1`)
- verify mountpoints before formatting or fsck

---

## blkid — authoritative identifiers

All identifiers:

    blkid

Specific device:

    blkid /dev/sdb1

Use cases:
- copy UUID into `/etc/fstab`
- confirm TYPE and LABEL

---

## findmnt — runtime mount truth (best human view)

Full mount tree:

    findmnt

Specific mountpoint:

    findmnt /mnt/data

Custom columns:

    findmnt -o SOURCE,TARGET,FSTYPE,OPTIONS

Rule:
- `findmnt` reflects the kernel’s current mount table (runtime truth)

---

## mount — classic view

All mounts:

    mount

Readable view:

    mount | column -t

Use for quick option inspection, but prefer `findmnt` for structure.

---

## df — filesystem capacity view

All filesystem usage:

    df -hT

Path-focused:

    df -hT /home

Rule:
- `df` = filesystem usage
- `du` = directory usage (covered elsewhere)

---

## fdisk / cfdisk — partition table view

List partitions on all disks:

    sudo fdisk -l

List partitions on one disk:

    sudo fdisk -l /dev/sdb

Interactive partitioning (safer UI than raw fdisk):

    sudo cfdisk /dev/sdb

Operator rule:
- partitioning changes the disk layout; confirm target disk first with `lsblk`

---

## Swap inspection

Show active swap devices/files:

    swapon --show

Show overall memory + swap:

    free -h

Swap in `/etc/fstab` is usually:
- a partition (TYPE=swap)
- or a swapfile (not covered here unless you add it later)

---

## Safe pre-change workflow

Before touching a disk:

1) Map devices + FS:

    lsblk -f

2) Confirm UUID/TYPE:

    blkid

3) Confirm mount truth:

    findmnt
    swapon --show

4) Confirm partition table:

    sudo fdisk -l /dev/sdb

5) Confirm filesystem usage (if relevant):

    df -hT

Proceed only after inspection is clean.

---

## “Is this device safe to touch?”

A device/partition should:

- NOT appear in `findmnt`
- NOT show a mountpoint in `lsblk -f`
- NOT appear in `swapon --show` (swap is “in use” too)

Checks:

    lsblk -f
    findmnt | grep sdb
    swapon --show | grep sdb

If mounted or swap-active: do not format, fsck, or repartition it.

---

## Virtual filesystems (normal)

You will see in `df` / `findmnt`:

- tmpfs
- devtmpfs
- proc
- sysfs
- cgroup*

These are normal, not disk-backed partitions.

---

## LFCS drills (inspection only)

Drill 1: inventory

    lsblk -f
    blkid
    findmnt
    df -hT
    swapon --show

Drill 2: analyze a disk safely

    lsblk -f /dev/sdb
    sudo fdisk -l /dev/sdb

Drill 3: answer with inspection

- What backs `/`?
- What filesystem type is `/home`?
- Is `/dev/sdb1` mounted?
- Is any swap active on `/dev/sdb*`?
- What is the UUID of `/dev/sda1`?

---

## Related drills

- linux/LFCS-training/execution-drills/

---

## Exam memory hook

Inspection prevents disasters. Always confirm: device, filesystem, mount, swap.

