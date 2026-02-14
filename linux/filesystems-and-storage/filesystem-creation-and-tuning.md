# filesystem-creation-and-tuning.md

Goal: Create filesystems safely, label them, and understand resizing workflows (ext4 vs xfs).

---

## Mental model

- A disk/partition is raw space until formatted.
- `mkfs*` creates the filesystem structure on a device.
- Formatting destroys existing data.
- Filesystems have identifiers:
  - TYPE (ext4/xfs/vfat)
  - UUID (stable identifier)
  - LABEL (human-friendly name)

---

## Dangerous command warning

Formatting wipes data.

Before any `mkfs`:

    lsblk -f
    blkid
    findmnt

If the target is mounted or swap-active: stop.

---

## Create filesystems (mkfs.*)

ext4:

    sudo mkfs.ext4 /dev/sdb1

Explicit type:

    sudo mkfs -t ext4 /dev/sdb1

xfs:

    sudo mkfs.xfs /dev/sdb1

vfat (FAT32):

    sudo mkfs.vfat /dev/sdb1

Verify after formatting:

    lsblk -f
    blkid /dev/sdb1

---

## Labels and UUIDs

Show identifiers:

    lsblk -f
    blkid

Set ext label:

    sudo e2label /dev/sdb1 DATA

Or:

    sudo tune2fs -L DATA /dev/sdb1

Set xfs label:

    sudo xfs_admin -L DATA /dev/sdb1

Mount by label:

    sudo mount LABEL=DATA /mnt/data

Mount by UUID (preferred for fstab):

    sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data

---

## Tune ext filesystems (tune2fs)

Show settings:

    sudo tune2fs -l /dev/sdb1

Set max mount count before fsck:

    sudo tune2fs -c 30 /dev/sdb1

Set time-based check interval:

    sudo tune2fs -i 3m /dev/sdb1

Reserved blocks (show + set):

    sudo tune2fs -l /dev/sdb1 | grep -i reserved
    sudo tune2fs -m 1 /dev/sdb1

---

## Resizing filesystems (operator view)

### ext4

Resize (often unmounted; depends on scenario):

    sudo resize2fs /dev/sdb1

### xfs

XFS can grow, not shrink.

Grow mounted filesystem:

    sudo xfs_growfs /mnt/data

---

## Safe workflow for a new disk (high-level)

1) Inspect:

    lsblk -f
    blkid
    findmnt

2) Partition (if needed):

    sudo fdisk /dev/sdb
    sudo cfdisk /dev/sdb

3) Format:

    sudo mkfs.ext4 /dev/sdb1

4) Mount:

    sudo mkdir -p /mnt/data
    sudo mount /dev/sdb1 /mnt/data

5) Add to fstab (UUID):

    blkid /dev/sdb1
    sudo vi /etc/fstab
    sudo mount -a
    sudo findmnt --verify

---

## Common mistakes

- Formatting disk instead of partition (`/dev/sdb` vs `/dev/sdb1`)
- Formatting a mounted filesystem
- Trusting device names instead of UUIDs
- Forgetting to verify after mkfs

---

## LFCS drills

Drill 1: format + mount

    lsblk -f
    sudo mkfs.ext4 /dev/sdb1
    sudo mkdir -p /mnt/test
    sudo mount /dev/sdb1 /mnt/test
    df -hT /mnt/test

Drill 2: label + mount by label

    sudo tune2fs -L TESTFS /dev/sdb1
    sudo umount /mnt/test
    sudo mount LABEL=TESTFS /mnt/test

Drill 3: show ext settings

    sudo tune2fs -l /dev/sdb1

---

## Related drills

- linux/LFCS-training/execution-drills/

---

## Exam memory hook

Always verify target device before mkfs. UUID is stable; /dev/sdX names are not.

