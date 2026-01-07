# filesystem-creation-and-tuning.md
LFCS Day 3 — Filesystems & Storage

Goal: Create filesystems safely, label them, tune ext filesystems, and understand resizing and formatting workflows.

--------------------------------------------------------------------

MENTAL MODEL

- A disk or partition is just raw space until formatted.
- mkfs creates a filesystem structure on a device.
- Formatting DESTROYS existing data.
- Filesystems have tunable parameters (check intervals, labels, reserved space).
- ext4 uses mkfs.ext4 and tune2fs.
- xfs uses mkfs.xfs and xfs_growfs.

--------------------------------------------------------------------

DANGEROUS COMMAND WARNING

Formatting wipes data.

Always confirm target device:

    lsblk -f
    blkid

If you format the wrong disk, the data is gone.

--------------------------------------------------------------------

CREATING FILESYSTEMS

Create ext4:

    sudo mkfs.ext4 /dev/sdb1

Explicit type:

    sudo mkfs -t ext4 /dev/sdb1

Create XFS:

    sudo mkfs.xfs /dev/sdb1

Create FAT32 (vfat):

    sudo mkfs.vfat /dev/sdb1

--------------------------------------------------------------------

VERIFY AFTER FORMATTING

    lsblk -f
    blkid

--------------------------------------------------------------------

LABELS AND UUIDS

Show identifiers:

    lsblk -f
    blkid

Set ext label:

    sudo e2label /dev/sdb1 DATA

Or:

    sudo tune2fs -L DATA /dev/sdb1

Set XFS label:

    sudo xfs_admin -L DATA /dev/sdb1

Mount by label:

    sudo mount LABEL=DATA /mnt/data

--------------------------------------------------------------------

TUNING EXT FILESYSTEMS (tune2fs)

Show current settings:

    sudo tune2fs -l /dev/sdb1

Set max mount count before fsck:

    sudo tune2fs -c 30 /dev/sdb1

Set time-based check interval:

    sudo tune2fs -i 3m /dev/sdb1

Disable automatic checks (not usually not recommended):

    sudo tune2fs -c 0 -i 0 /dev/sdb1

--------------------------------------------------------------------

RESERVED BLOCKS (EXT FILESYSTEMS)

By default ~5% is reserved for root.

Show reserved blocks:

    sudo tune2fs -l /dev/sdb1 | grep -i reserved

Set reserved to 1%:

    sudo tune2fs -m 1 /dev/sdb1

On large data volumes, lowering this is common.

--------------------------------------------------------------------

RESIZING FILESYSTEMS

EXT FILESYSTEMS

Grow or shrink (filesystem must usually be unmounted):

    sudo resize2fs /dev/sdb1

XFS FILESYSTEMS

XFS can only grow, not shrink.

Grow mounted filesystem:

    sudo xfs_growfs /mnt/data

--------------------------------------------------------------------

SAFE WORKFLOW FOR A NEW DISK

1) Identify disk:

    lsblk

2) Partition it (if needed):

    sudo fdisk /dev/sdb

3) Create filesystem:

    sudo mkfs.ext4 /dev/sdb1

4) Create mount point:

    sudo mkdir -p /mnt/data

5) Mount:

    sudo mount /dev/sdb1 /mnt/data

6) Get UUID and add to fstab:

    blkid /dev/sdb1
    sudo vi /etc/fstab

7) Validate:

    sudo mount -a

--------------------------------------------------------------------

ADVANCED: FILESYSTEM FEATURES (EXT)

List features:

    sudo tune2fs -l /dev/sdb1

Some features:

- journaling
- extents
- metadata checksums

Changing features:

- May require unmount
- May require fsck
- May make filesystem incompatible with older kernels

For LFCS: know this exists; do not experiment on important disks.

--------------------------------------------------------------------

COMMON MISTAKES

- Formatting the disk instead of the partition (/dev/sdb vs /dev/sdb1)
- Formatting a mounted filesystem
- Forgetting to verify with lsblk -f
- Forgetting to add to /etc/fstab

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Create and mount a test filesystem

    lsblk
    sudo mkfs.ext4 /dev/sdb1
    sudo mkdir -p /mnt/test
    sudo mount /dev/sdb1 /mnt/test
    df -hT /mnt/test

DRILL 2: Label and mount by label

    sudo tune2fs -L TESTFS /dev/sdb1
    sudo umount /mnt/test
    sudo mount LABEL=TESTFS /mnt/test

DRILL 3: Tune check intervals

    sudo tune2fs -l /dev/sdb1
    sudo tune2fs -c 20 -i 2m /dev/sdb1

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Create filesystems with mkfs
- Identify filesystem types, labels, and UUIDs
- Change labels
- Tune ext filesystem check behavior
- Resize filesystems (conceptually and practically)
- Understand that XFS can grow but not shrink

--------------------------------------------------------------------
