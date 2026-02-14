# fstab-and-persistent-mounts.md

How Linux decides what to mount at boot and how to validate that plan safely.

---

## Core mental model

- `/etc/fstab` is the declarative plan.
- The kernel mount table is runtime reality.

At boot:

fstab -> systemd -> mount syscalls -> live mount tree

---

## fstab line format

    <what>   <where>   <type>   <options>   <dump>   <pass>

Example:

    UUID=...  /home  ext4  defaults  0  2

---

## Why UUID= is preferred

Device names like `/dev/sda2` can change.
UUID identifies the filesystem and is stable.

Get UUID:

    blkid
    lsblk -f

---

## The last two numbers

dump:
- usually 0

pass:
- 1 = check first (root /)
- 2 = check later (other local filesystems)
- 0 = never fsck (swap, special, some network mounts)

---

## Validation (do not skip)

Validate fstab entries:

    sudo findmnt --verify

Apply mounts without reboot:

    sudo mount -a

Inspect runtime mount truth:

    findmnt

---

## Swap entries in fstab

Swap is often defined in fstab with type `swap`.

Example:

    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  none  swap  sw  0  0

Inspect active swap:

    swapon --show

---

## Exam memory hook

fstab is the plan. Validate it with `findmnt --verify` before reboot.

