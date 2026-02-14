# mounting-and-fstab.md

Goal: Mount/unmount safely, use mount options correctly, and make mounts persistent with /etc/fstab.

---

## Mental model

- Mounting attaches a filesystem to a mountpoint directory.
- `/etc/fstab` is the declarative plan for what should be mounted (usually at boot).
- Runtime truth is the live kernel mount table (`findmnt`, `/proc/self/mounts`).

---

## Mountpoints

Create:

    sudo mkdir -p /mnt/data

Conventions:
- /mnt = temporary/admin mounts
- /media = removable media

---

## Manual mounting

By device:

    sudo mount /dev/sdb1 /mnt/data

By UUID (preferred):

    sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data

By LABEL:

    sudo mount LABEL=DATA /mnt/data

Explicit type (when needed):

    sudo mount -t ext4 /dev/sdb1 /mnt/data
    sudo mount -t xfs  /dev/sdb1 /mnt/data
    sudo mount -t vfat /dev/sdb1 /mnt/usb

---

## Mount options

Specify:

    sudo mount -o ro,noexec,nosuid,nodev /dev/sdb1 /mnt/data

Common options:
- defaults = rw,suid,dev,exec,auto,nouser,async
- ro / rw
- noexec
- nosuid
- nodev
- nofail (don’t fail boot if missing)
- x-systemd.automount (mount on first access)

---

## Verify mounts

Tree view:

    findmnt

Check specific mount:

    findmnt /mnt/data

Filesystem usage view:

    df -hT /mnt/data

---

## Unmounting

By mountpoint:

    sudo umount /mnt/data

By device:

    sudo umount /dev/sdb1

Busy mount debugging:

    sudo lsof +f -- /mnt/data
    sudo fuser -vm /mnt/data

Last resort:

    sudo umount -l /mnt/data
    sudo umount -f /mnt/data

---

## /etc/fstab basics

Format:

    <source>  <mountpoint>  <fstype>  <options>  <dump>  <pass>

Example (UUID recommended):

    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  /mnt/data  ext4  defaults  0  2

Fields:
- source: device, UUID=, or LABEL=
- mountpoint: directory
- fstype: ext4, xfs, vfat, swap
- options: defaults + extras
- dump: usually 0
- pass: fsck order (0/1/2)

UUID retrieval:

    blkid
    lsblk -f

---

## Validate fstab safely

After editing:

    sudo mount -a

Then verify:

    findmnt /mnt/data

Also validate declaratively:

    sudo findmnt --verify

Never reboot without a clean verification.

---

## Boot-time failure safety

For removable/optional disks:

    nofail

Example:

    UUID=xxxx  /mnt/usb  vfat  defaults,nofail  0  0

---

## Network mounts (conceptual)

NFS:

    sudo mount -t nfs server:/export /mnt/nfs

CIFS/SMB (requires utils):

    sudo apt-get update
    sudo apt-get install -y cifs-utils
    sudo mount -t cifs //server/share /mnt/smb -o username=USER

---

## Related drills

- linux/LFCS-training/execution-drills/

---

## Exam memory hook

fstab is the plan. findmnt is the runtime truth. Always verify before reboot.

