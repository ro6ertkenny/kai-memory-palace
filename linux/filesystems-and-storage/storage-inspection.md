# storage-inspection.md
LFCS Day 3 — Filesystems & Storage

Goal: Reliably inspect disks, partitions, filesystems, and mounts before making any changes.

--------------------------------------------------------------------

MENTAL MODEL

- Before you format, mount, fsck, or resize anything, you must know:
  - What disks exist
  - What partitions exist
  - What filesystems exist
  - What is currently mounted
- Most catastrophic Linux storage mistakes come from touching the wrong device.
- Inspection is always step zero.

--------------------------------------------------------------------

THE CORE INSPECTION COMMANDS

You should be fluent with these:

    lsblk
    lsblk -f
    blkid
    findmnt
    df -hT
    mount
    fdisk -l

Together, these tell you:
- What exists
- What type it is
- What is mounted
- Where it is mounted
- How full it is

--------------------------------------------------------------------

LSBLK — YOUR PRIMARY MAP

Show block devices:

    lsblk

Show block devices WITH filesystems and UUIDs:

    lsblk -f

Typical output shows:

- Disk:     sda, sdb, nvme0n1, mmcblk0
- Partitions: sda1, sda2, etc.
- Filesystem type: ext4, xfs, vfat, etc.
- UUID
- Mountpoint (if mounted)

This is usually the FIRST command you run.

--------------------------------------------------------------------

BLKID — AUTHORITATIVE IDENTIFIERS

Show filesystem identifiers:

    blkid

Show specific device:

    blkid /dev/sdb1

Shows:

- UUID
- TYPE
- LABEL (if any)

Use this to copy UUIDs into /etc/fstab.

--------------------------------------------------------------------

FINDMNT — WHAT IS MOUNTED (TREE VIEW)

Show all mounts:

    findmnt

Show a specific mount:

    findmnt /mnt/data

Show source of a mount:

    findmnt -o SOURCE,TARGET,FSTYPE,OPTIONS

This shows the actual kernel mount table, not guesses.

--------------------------------------------------------------------

MOUNT — CLASSIC VIEW

    mount

Or cleaner:

    mount | column -t

Shows:

- What is mounted
- Where
- With what options

Less structured than findmnt, but still useful.

--------------------------------------------------------------------

DF — SPACE USAGE (FILESYSTEM VIEW)

Show filesystem usage:

    df -hT

Check specific path:

    df -hT /home

Shows:

- Filesystem
- Type
- Size
- Used
- Available
- Mount point

Important: df shows FILESYSTEM usage, not directory usage.

--------------------------------------------------------------------

FDISK — PARTITION TABLE VIEW

List all disks and partitions:

    sudo fdisk -l

Shows:

- Disk sizes
- Partition layout
- Partition types
- Start/end sectors

Use this to confirm partitioning before formatting.

--------------------------------------------------------------------

PUTTING IT ALL TOGETHER (SAFE WORKFLOW)

Before touching a disk:

1) See everything:

    lsblk -f

2) Confirm identifiers:

    blkid

3) Confirm what is mounted:

    findmnt

4) Confirm partition layout:

    sudo fdisk -l /dev/sdb

5) Confirm space usage (if relevant):

    df -hT

Only then proceed.

--------------------------------------------------------------------

COMMON PITFALLS

- Confusing /dev/sda and /dev/sdb
- Confusing disk and partition (/dev/sdb vs /dev/sdb1)
- Formatting a disk that is already mounted
- Mounting over a non-empty directory
- Trusting device names instead of UUIDs

--------------------------------------------------------------------

HOW TO TELL IF A DEVICE IS SAFE TO TOUCH

A device or partition should:

- NOT appear in findmnt
- NOT show a mountpoint in lsblk -f

Check:

    lsblk -f
    findmnt | grep sdb

If it is mounted: DO NOT format or fsck it.

--------------------------------------------------------------------

VIRTUAL FILESYSTEMS (YOU WILL SEE THESE)

In df or findmnt you will see:

- tmpfs
- devtmpfs
- proc
- sysfs

These are normal. They are not disks.

--------------------------------------------------------------------

REAL-WORLD EXAMPLES

“What disk is my root filesystem on?”

    findmnt /

“What filesystem is /home using?”

    df -hT /home

“What partitions exist on /dev/sdb?”

    lsblk /dev/sdb
    sudo fdisk -l /dev/sdb

“What is mounted at /mnt/data?”

    findmnt /mnt/data

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Full system inventory

    lsblk -f
    blkid
    findmnt
    df -hT

DRILL 2: Pick a disk and analyze it

    sudo fdisk -l /dev/sdb
    lsblk -f /dev/sdb

DRILL 3: Answer questions using only inspection tools

- Where is / mounted from?
- What filesystem is /home?
- Is /dev/sdb1 mounted?
- What is the UUID of /dev/sda1?

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Identify disks, partitions, and filesystems
- Determine what is mounted and where
- Find UUIDs and filesystem types
- Confirm a device is safe before modifying it
- Explain the difference between disk view, filesystem view, and mount view

--------------------------------------------------------------------
