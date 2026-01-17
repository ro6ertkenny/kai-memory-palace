# 🧬 Virtual Filesystems — Operator Basics
*Understanding proc, sysfs, tmpfs, devtmpfs, cgroupfs, overlay, and why they exist*

---

## 🎯 Purpose

This document teaches you to:

- Understand what **virtual filesystems** are
- Recognize them in `mount` and `lsblk`
- Know **which ones are safe to ignore** and which are **critical**
- Debug problems involving:
  - `/proc`
  - `/sys`
  - `/dev`
  - `/run`
  - `/sys/fs/cgroup`
  - tmpfs
  - overlayfs

This is **not** about disk filesystems.

These filesystems are:

> Kernel-backed **views of system state**, not storage.

LFCS expects you to understand this distinction.

---

## 🧠 Mental Model

A **virtual filesystem**:

- Does **not** live on disk
- Is created by the kernel
- Exposes **live system state**
- Disappears on reboot
- Is often **writable** to change kernel behavior

Think:

> “This is a control panel, not a hard drive.”

---

## 🧭 How To Recognize Them

Run:

    findmnt -t tmpfs,proc,sysfs,devtmpfs,cgroup2,overlay

Or:

    mount | egrep 'proc|sys|tmpfs|devtmpfs|cgroup|overlay'

Or:

    lsblk -f

You will see many entries with:

- No real backing block device
- Type: `proc`, `sysfs`, `tmpfs`, `devtmpfs`, `cgroup2`, `overlay`

---

## 🧱 The Important Ones

---

# 1) procfs — `/proc`

Type: `proc`

    mount | grep ' /proc '

- Exposes:
  - processes
  - kernel state
  - runtime tunables

Examples:

    /proc/cpuinfo
    /proc/meminfo
    /proc/uptime
    /proc/<PID>/

Sysctl lives here:

    /proc/sys/net/ipv4/ip_forward
    /proc/sys/vm/swappiness

Writing here changes the **running kernel**.

---

# 2) sysfs — `/sys`

Type: `sysfs`

    mount | grep ' /sys '

- Exposes:
  - devices
  - drivers
  - kernel subsystems
  - hardware topology

Examples:

    /sys/class/net
    /sys/block
    /sys/devices

Used by:

- udev
- systemd
- hardware discovery

---

# 3) devtmpfs — `/dev`

Type: `devtmpfs`

    mount | grep ' /dev '

- Contains:
  - device nodes (`/dev/sda`, `/dev/null`, `/dev/tty`, etc.)
- Managed by:
  - kernel + udev

If this breaks:

> The system is basically dead.

---

# 4) tmpfs — `/run`, `/tmp`, sometimes `/var/tmp`

Type: `tmpfs`

    mount | grep tmpfs

- RAM-backed filesystem
- Used for:
  - runtime state
  - sockets
  - PID files
  - locks

Examples:

    /run
    /dev/shm

Reboot → data gone.

---

# 5) cgroupfs — `/sys/fs/cgroup`

Type: `cgroup2` (modern systems)

    mount | grep cgroup

- Exposes:
  - resource control
  - limits
  - accounting
  - PSI signals

Examples:

    /sys/fs/cgroup/memory.current
    /sys/fs/cgroup/cpu.stat

Used by:

- systemd
- containers
- Kubernetes

---

# 6) overlayfs — containers

Type: `overlay`

    mount | grep overlay

- Used for:
  - container filesystems
  - layered images
  - copy-on-write roots

Paths look like:

    overlay on /var/lib/docker/overlay2/... type overlay (...)

This is **not a real disk filesystem**.

---

# 7) Other Common Virtual FS Types

- `tracefs`
- `debugfs`
- `securityfs`
- `hugetlbfs`
- `fusectl`

Usually mounted under:

    /sys
    /proc
    /run

---

## ⚠️ Critical Warnings

- ❌ **Never** run `fsck` on these
- ❌ **Never** try to “repair” them
- ❌ **Never** expect data persistence
- ❌ **Never** treat them as disks

If they are broken:

> You reboot or fix the kernel / init system.

---

## 🧪 Operator Debug Use Cases

### Is this disk or virtual?

    findmnt /
    lsblk

If the filesystem type is:

- ext4, xfs → real disk
- tmpfs, proc, sysfs, overlay → virtual

---

### Why is `/run` full?

    df -h /run

It is **RAM-backed**.

---

### Why is `/dev` weird?

Check:

    mount | grep devtmpfs

---

### Why does `/proc/sys` change system behavior?

Because:

> You are writing into the kernel.

---

## 🧠 Exam Mindset

You should be able to:

- Identify virtual filesystems in `mount` output
- Explain what `/proc`, `/sys`, `/dev`, `/run` are
- Know that:
  - They are **not storage**
  - They are **interfaces**

---

## 🏁 Canonical Summary

- Virtual filesystems expose **live kernel state**
- They do **not** store data
- They are **not repairable**
- They are **critical for system operation**
- You inspect them, not manage them like disks

