# /etc/fstab and Persistent Mounts

This document explains how Linux decides what to mount at boot and how to validate that plan safely.

---

## The core mental model

/etc/fstab is the declarative plan for the mount tree.
The kernel’s mount table is the runtime reality.

At boot:

fstab -> systemd -> mount syscalls -> live mount tree

---

## fstab line format

<what> (device)   <where> (mountpoint)   <type>   <options>   <dump>   <fsck pass>

Example:

UUID=...  /home  ext4  defaults  0  2

---

## Why UUID= is used

Device names like /dev/sda2 can change.

UUID identifies the filesystem itself and is stable.

---

## The last two numbers (quick intuition)

dump:
- usually 0
- legacy backup tool, mostly ignored

pass:
- 1 = check first (root /)
- 2 = check later (/home, etc)
- 0 = do not fsck (swap, special)

---

## Verifying fstab safely

Never reboot blindly.

Always run:

sudo findmnt --verify

If this reports errors, your system may not boot.

---

## Mental model

fstab is the plan.
The live mount tree is the execution.

---
