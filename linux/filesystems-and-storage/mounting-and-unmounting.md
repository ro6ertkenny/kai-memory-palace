# Mounting and Unmounting Filesystems

This document explains what mounting really means in Linux, how to inspect the live mount tree, and how filesystems are attached and detached from the running system.

---

## The core mental model

Linux is not "a disk".

Linux is:

A tree of mountpoints built from multiple filesystems.

Each filesystem is grafted into the namespace at a directory.

Mounting does not move files.
It attaches a filesystem to a path.

Unmounting removes that attachment.

---

## Device, filesystem, mountpoint (three different things)

- Device: a block device (e.g. /dev/sda2, /dev/loop0, a disk image)
- Filesystem: ext4, xfs, vfat, etc (the on-disk data structure)
- Mountpoint: a directory where that filesystem is attached (e.g. /, /home, /mnt)

These are not the same thing.

---

## Three ways to inspect mounts (three views of the same truth)

1) mount
- Human-readable view of the kernel mount table

2) findmnt
- Structured, tree-based view (best tool for humans)

3) /proc/self/mounts
- Raw kernel truth

Tools like mount and findmnt ultimately read from /proc/self/mounts.

Modern systems have many mounts:
- Real disk filesystems
- Plus many virtual kernel filesystems (proc, sysfs, tmpfs, cgroup, etc)

This is normal.

---

## Focused inspection commands

What backs / ?

findmnt /
df -hT /

Full topology:

lsblk -f
findmnt

---

## Loopback mounts (filesystem inside a file)

A regular file can be treated as a block device via a loop device:

file -> /dev/loopN -> filesystem -> mountpoint

This is how:
- disk images
- ISOs
- many container layers

work internally.

---

## What happens when you mount and unmount

When mounted:

The mountpoint directory is hidden.
The root of the mounted filesystem appears there.

When unmounted:

The graft is removed.
The original directory is visible again.
No data is deleted.

Files live in the filesystem, not in the directory.

---

## "Target is busy"

A filesystem is busy if any process:
- Has its current working directory inside it
- Or has any file open inside it

Even a shell "standing in the directory" makes it busy.

Correct workflow:
1) Find who is using it (fuser / lsof)
2) Exit or stop those processes
3) Then unmount cleanly

Lazy unmount:

umount -l

Detaches now, cleans up when processes exit.
Last resort tool.

---

## Big mental model

Mounting is namespace surgery.

You are grafting and ungrafting filesystems into a live tree.

---

## Exam memory hook

Linux is a tree of mountpoints, not a disk.

---
