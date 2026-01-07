# filesystem-concepts.md
LFCS Day 3 — Filesystems & Storage

Goal: Build a correct mental model of how Linux storage works: devices, partitions, filesystems, mount points, and identifiers.

--------------------------------------------------------------------

CORE MENTAL MODEL

- A disk provides raw storage.
- A disk may contain one or more partitions.
- A partition (or whole disk) may contain a filesystem.
- A filesystem is mounted into the single Linux directory tree at a mount point.
- Linux does not have drive letters. Everything lives under /.
- Mounting attaches a filesystem to a directory.
- Unmounting detaches it.
- Until something is mounted, it is just bytes on a device.

Think in layers:

Hardware → Block Device → Partition → Filesystem → Mount Point → Directory Tree

--------------------------------------------------------------------

BLOCK DEVICES

Block devices are things you can read/write in blocks:

Examples:

- /dev/sda        (entire disk)
- /dev/sda1       (partition)
- /dev/nvme0n1p1  (NVMe partition)
- /dev/mmcblk0p1  (SD card partition)

See them with:

    lsblk
    lsblk -f

--------------------------------------------------------------------

PARTITIONS

A partition is a slice of a disk.

- A disk can have 0, 1, or many partitions.
- Partitions exist to:
  - Separate data
  - Use different filesystems
  - Apply different mount options
  - Isolate failure domains

Tools:

    fdisk -l
    lsblk

--------------------------------------------------------------------

FILESYSTEMS

A filesystem defines:

- How files and directories are stored
- How metadata is tracked
- How free space is managed
- How recovery works

Common Linux filesystems:

- ext4 (most common, journaled)
- xfs (high performance, grows well)
- vfat (FAT32, for USB/boot/interop)
- ntfs (Windows)
- tmpfs (RAM-backed)
- iso9660 (CD/DVD images)

A filesystem lives ON a device or partition.

Until you mount it, you cannot access its contents.

--------------------------------------------------------------------

MOUNT POINTS

A mount point is just an empty directory.

Examples:

- /mnt/data
- /home
- /boot
- /var

When you mount a filesystem:

    mount /dev/sdb1 /mnt/data

The contents of that filesystem appear at:

    /mnt/data

If you unmount it, the directory is just an empty directory again.

--------------------------------------------------------------------

THE SINGLE DIRECTORY TREE

Linux always has exactly ONE directory tree, rooted at:

    /

All filesystems are grafted into this tree.

Examples:

- /            → root filesystem
- /home        → may be a separate filesystem
- /boot        → may be a separate filesystem
- /mnt/data    → manually mounted filesystem

--------------------------------------------------------------------

IDENTIFIERS: DEVICE NAMES VS UUID VS LABEL

Device names:

- /dev/sda1
- /dev/sdb1

Problem: They can change across boots.

Stable identifiers:

- UUID (unique, long, stable)
- LABEL (human-friendly name)

See them with:

    blkid
    lsblk -f

Examples:

    UUID=1234-ABCD
    LABEL=DATA

Best practice: use UUID (or LABEL) in /etc/fstab, not /dev/sdX.

--------------------------------------------------------------------

WHAT IS /etc/fstab (CONCEPTUALLY)

- /etc/fstab describes:
  - What should be mounted
  - Where
  - With what filesystem
  - With what options
  - At boot time

It is NOT magic. It is just a configuration file used by mount/systemd.

--------------------------------------------------------------------

VIRTUAL / SPECIAL FILESYSTEMS

Not all filesystems live on disks:

- tmpfs   → RAM-backed
- proc    → kernel info (/proc)
- sysfs   → kernel devices (/sys)
- devtmpfs → device nodes (/dev)

See them with:

    findmnt

--------------------------------------------------------------------

JOURNALING (WHY EXT4 AND XFS RECOVER)

Modern filesystems are journaled:

- Metadata changes are logged before being committed.
- After a crash, the filesystem can replay the journal.
- This prevents long full-disk scans on every boot.

This is why:

- ext4 and xfs usually recover fast
- fsck is not always run on every boot

--------------------------------------------------------------------

READ-ONLY MOUNTS

If the kernel detects corruption, it may:

- Remount a filesystem read-only
- To prevent further damage

Symptom:

- Writes fail
- dmesg shows filesystem errors

This is a protection mechanism.

--------------------------------------------------------------------

DANGEROUS OPERATIONS (CONCEPTUAL)

These operations can destroy data:

- mkfs (formatting)
- fsck with forced repairs
- Writing to the wrong disk
- Mounting the wrong filesystem over an important directory

Rule:

Always verify target device with:

    lsblk -f
    blkid

--------------------------------------------------------------------

COMMON TERMINOLOGY

- Block device: something like /dev/sda, /dev/sda1
- Partition: a slice of a disk
- Filesystem: ext4, xfs, etc.
- Mount: attach filesystem to directory
- Mount point: the directory you attach it to
- UUID: stable unique identifier
- LABEL: human-friendly name
- fstab: boot-time mount configuration

--------------------------------------------------------------------

EXAM STANDARD

You must conceptually understand:

- The difference between disk, partition, and filesystem
- What mounting actually does
- Why UUID/LABEL are better than /dev/sdX
- That Linux has one directory tree
- That some filesystems are virtual (tmpfs, proc, sysfs)

--------------------------------------------------------------------

