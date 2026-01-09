# Filesystem Debugging Checklist

Use this flow before touching anything.

---

## 1) What is mounted?

findmnt
findmnt /
lsblk -f

---

## 2) Is something mounted where you think it is?

findmnt /path

If nothing prints, it is not a mountpoint.

---

## 3) Is unmount failing?

Error: target is busy

Check:

fuser -vm /path
lsof +D /path

Find and stop processes.

---

## 4) Is this a stacked mount?

If unmount does not remove it:

You may have multiple layers.

Run umount multiple times and re-check.

---

## 5) Is this supposed to mount at boot?

Check:

/etc/fstab
sudo findmnt --verify

---

## 6) Do you need fsck?

Rule:

Never fsck a mounted filesystem.

Check first with findmnt.

---

## Master mental model

Plan: /etc/fstab
Reality: live mount tree
Tools: findmnt, lsblk, mount

---
