# 🧪 LFCS Execution Drills — Phase 7
# 🗄️ Storage, Filesystems, Mounting, Swap, and LVM

Path:
  linux/execution-drills/phase-7-storage-filesystems-lvm-and-swap.md

Purpose:
  Build reflex-level safety and precision with disks, filesystems, mounts, swap, and LVM without destroying data.

Mental Mode:
  Storage operations are irreversible. Always verify device names before acting.

---

## 🧱 Lab Safety Rules

⚠️ NEVER use your real system disk.
⚠️ ONLY use:
- extra VM disks
- loopback files

You should have at least **two extra disks** (e.g., /dev/vdb, /dev/vdc), or simulate them with loop devices.

---

## 🧱 Lab Setup (Loopback Disks — Safe Mode)

    mkdir -p ~/lfcs-labs/execution-drills/phase-7
    cd ~/lfcs-labs/execution-drills/phase-7

Create fake disks:

    dd if=/dev/zero of=disk1.img bs=1M count=2048 status=progress
    dd if=/dev/zero of=disk2.img bs=1M count=2048 status=progress

Attach as loop devices:

    sudo losetup -fP disk1.img
    sudo losetup -fP disk2.img

Find them:

    lsblk
    losetup -a

Assume they appear as /dev/loop0 and /dev/loop1 in examples.

---

# A) Discover Storage

## A1 — Inventory

    lsblk
    df -h
    findmnt
    blkid

---

# B) Partitioning

## B1 — Partition disk1

    sudo fdisk /dev/loop0

Inside fdisk:

    n
    p
    1
    <enter>
    <enter>
    w

Reload:

    sudo partprobe
    lsblk

---

# C) Create Filesystems

## C1 — ext4

    sudo mkfs.ext4 /dev/loop0p1

Mount:

    sudo mkdir -p /mnt/p7-ext4
    sudo mount /dev/loop0p1 /mnt/p7-ext4
    df -h | grep p7

---

## C2 — xfs (on disk2)

    sudo fdisk /dev/loop1   (create partition same way)
    sudo partprobe

    sudo mkfs.xfs -L DATA7 /dev/loop1p1
    sudo mkdir -p /mnt/p7-xfs
    sudo mount /dev/loop1p1 /mnt/p7-xfs

---

# D) Mount Options & Remount

## D1 — Read-only mount

    sudo mount -o remount,ro /mnt/p7-ext4
    touch /mnt/p7-ext4/test || echo "write blocked"

Remount rw:

    sudo mount -o remount,rw /mnt/p7-ext4

---

# E) Persistent Mounts (fstab)

## E1 — Use UUID

Find UUID:

    blkid /dev/loop0p1

Edit:

    sudo vi /etc/fstab

Add:

    UUID=<uuid> /mnt/p7-ext4 ext4 defaults 0 2

Test:

    sudo umount /mnt/p7-ext4
    sudo mount -a
    df -h | grep p7

---

# F) Swap

## F1 — Swap file

    sudo fallocate -l 512M /swap-p7
    sudo chmod 600 /swap-p7
    sudo mkswap /swap-p7
    sudo swapon /swap-p7

Check:

    swapon -h

Disable:

    sudo swapoff /swap-p7

Persist:

    echo "/swap-p7 none swap sw 0 0" | sudo tee -a /etc/fstab
    sudo swapon -a
    swapon -h

---

# G) tmpfs

## G1 — Mount tmpfs

    sudo mkdir -p /mnt/p7-tmpfs
    sudo mount -t tmpfs tmpfs /mnt/p7-tmpfs
    df -h | grep tmpfs

---

# H) Filesystem Check

## H1 — fsck (ext4)

    sudo umount /mnt/p7-ext4
    sudo fsck /dev/loop0p1
    sudo mount /dev/loop0p1 /mnt/p7-ext4

---

# I) LVM

⚠️ Use loop devices only.

## I1 — Install

    sudo apt install -y lvm2

---

## I2 — Create PV

    sudo pvcreate /dev/loop0 /dev/loop1
    pvs

---

## I3 — Create VG

    sudo vgcreate vg7 /dev/loop0 /dev/loop1
    vgs

---

## I4 — Create LV

    sudo lvcreate -L 500M -n lvdata vg7
    lvs

---

## I5 — Format and mount

    sudo mkfs.ext4 /dev/vg7/lvdata
    sudo mkdir -p /mnt/p7-lvm
    sudo mount /dev/vg7/lvdata /mnt/p7-lvm
    df -h | grep p7

---

## I6 — Extend LV

    sudo lvextend -L +300M /dev/vg7/lvdata

Resize FS:

    sudo resize2fs /dev/vg7/lvdata

Verify:

    df -h /mnt/p7-lvm

---

# J) Timed Drills

## J1 — Create FS and mount in 60 seconds

- mkfs
- mkdir
- mount

---

## J2 — Add swap in 60 seconds

- fallocate
- chmod
- mkswap
- swapon

---

## J3 — Extend LV and FS in 60 seconds

- lvextend
- resize2fs or xfs_growfs

---

# K) Failure Injection Drills

## K1 — Bad fstab entry

Add wrong device to /etc/fstab.

Test:

    sudo mount -a

Fix it.

Rule:
- ALWAYS test mount -a before reboot.

---

## K2 — Forgot to resize filesystem

Extend LV only:

    sudo lvextend -L +100M /dev/vg7/lvdata
    df -h

Explain why space did not appear.

Fix:

    sudo resize2fs /dev/vg7/lvdata

---

# L) Composition (Exam Style)

## L1 — “Disk full” scenario

Fill:

    dd if=/dev/zero of=/mnt/p7-lvm/bigfile bs=1M count=400

Check:

    df -h /mnt/p7-lvm

Extend LV and FS to fix.

---

## L2 — Persistent mount scenario

- Add entry to fstab using UUID
- umount
- mount -a
- verify

---

# ✅ Phase 7 Completion Criteria

You are Phase 7-ready when you can:

- Identify correct disks and partitions
- Create ext4 and xfs filesystems
- Mount with options and persist with fstab
- Create and manage swap
- Create and extend LVM volumes
- Resize filesystems safely
- Never break boot with bad fstab entries

---

# 🔒 Phase 7 Law

If you can’t manage storage safely, you can’t run production systems.

---

# Cleanup (Optional)

Detach loop devices:

    sudo losetup -d /dev/loop0
    sudo losetup -d /dev/loop1

---
