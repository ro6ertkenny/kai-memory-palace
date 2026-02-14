# Mounting and Unmounting Filesystems

What mounting means, how to inspect the live mount tree, and how to detach safely.

---

## Core mental model

Linux is a **tree of mountpoints**, not “a disk”.

Mounting attaches a filesystem to a path.
Unmounting removes that attachment.

Mounting does not move files.
It grafts a filesystem into the namespace at a directory.

---

## Device vs filesystem vs mountpoint

- Device: block device (example: /dev/sda2)
- Filesystem: on-disk structure (ext4, xfs, vfat)
- Mountpoint: directory where attached (/, /home, /mnt/data)

---

## Inspect mounts (three views)

1) Structured (best):

    findmnt

2) Classic:

    mount

3) Kernel raw truth:

    cat /proc/self/mounts

---

## Focused inspection

What backs / ?

    findmnt /
    df -hT /

Full topology:

    lsblk -f
    findmnt

---

## Mount / unmount basics

Mount by device:

    sudo mount /dev/sdb1 /mnt/data

Unmount by mountpoint:

    sudo umount /mnt/data

Unmount by device:

    sudo umount /dev/sdb1

---

## “Target is busy”

A filesystem is busy if any process:
- has cwd inside it
- has files open in it

Find offenders:

    sudo lsof +f -- /mnt/data
    sudo fuser -vm /mnt/data

Resolve:
- exit shells
- stop services
- close files

Then unmount cleanly.

---

## Last resort unmounts

Lazy unmount (detach now, cleanup later):

    sudo umount -l /mnt/data

Force unmount (dangerous; avoid unless required):

    sudo umount -f /mnt/data

---

## Loop mounts (filesystem inside a file)

Pattern:

file -> /dev/loopN -> filesystem -> mountpoint

Mount an ISO:

    sudo mkdir -p /mnt/iso
    sudo mount -o loop file.iso /mnt/iso
    sudo umount /mnt/iso

---

## Exam memory hook

Mounting is namespace grafting. Linux is a tree of mountpoints, not a disk.

