# fsck and Recovery Basics

This document explains what fsck is, what it checks, and when it is safe or dangerous to run.

---

## What fsck is

fsck = filesystem check.

It verifies and repairs on-disk filesystem data structures.

It works on the filesystem metadata itself.

---

## The big mental model

fsck works on the on-disk data structures.
Mounting uses those same structures live.

If you run fsck while mounted:

- The kernel and fsck both modify the same metadata
- That can corrupt the filesystem

---

## The golden rule

Never run fsck on a mounted filesystem.

Always check first:

findmnt <path>

If it prints nothing, it is not mounted.

---

## Example command (ext4)

sudo fsck.ext4 -f fs.img

Meaning:

- fsck.ext4 = check an ext4 filesystem
- -f = force a full check
- fs.img = the block device or image file

---

## What fsck does internally

It runs multiple passes:

1) inodes and blocks
2) directory structure
3) directory connectivity
4) reference counts
5) group summary information

---

## When fsck is used in real life

- At boot (according to fstab pass numbers)
- On unclean shutdowns
- On suspected corruption
- In recovery environments

---
