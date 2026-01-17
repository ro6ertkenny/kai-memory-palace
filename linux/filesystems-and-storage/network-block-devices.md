# 🌐 Network Block Devices — Operator Basics
*Using remote storage as local disks (iSCSI, NBD) safely and predictably*

---

## 🎯 Purpose

This document teaches you how to:

- Attach **remote block devices** to a Linux system
- Treat them **exactly like local disks**
- Partition, format, mount, and unmount them
- Detach them **cleanly and safely**

This is **not** about:

- NFS / CIFS / SMB (those are **network filesystems**)
- This is about **network disks** that appear as `/dev/sdX` or `/dev/nbdX`.

LFCS explicitly tests this category.

---

## 🧠 Mental Model

A **network block device** is:

> A remote disk that pretends to be a local disk.

Once attached:

- It appears under `/dev/`
- You partition it
- You format it
- You mount it
- You treat it like any other disk

The system **does not care** that it is remote.

---

## ⚠️ Safety Rules (Always Follow)

Before doing anything destructive:

- Always identify the device with:

    lsblk
    blkid

- Never assume `/dev/sdb` is the new disk.
- Never format anything until you confirm:

    lsblk -f

- Always **unmount before detaching**.

---

## 🧱 Two Common Types You Will See

1) **iSCSI** — enterprise SAN-style block storage  
2) **NBD** (Network Block Device) — simple block device over the network (or image files)

Both appear as **real block devices**.

---

# Part 1 — iSCSI (Initiator Side)

## 🧰 Install tools (Debian/Ubuntu)

    sudo apt-get update
    sudo apt-get install -y open-iscsi

Check service:

    systemctl status iscsid

---

## 🔎 Discover targets

    sudo iscsiadm -m discovery -t sendtargets -p <server-ip>

You will see something like:

    iqn.2024-01.com.example:storage.lun1

---

## 🔌 Log in to target

    sudo iscsiadm -m node -T <IQN> -p <server-ip> --login

Now check:

    lsblk

You should see a **new disk** (e.g. `/dev/sdb`).

---

## 🧪 Treat it like a normal disk

### Partition (optional)

    sudo fdisk /dev/sdb

### Format

    sudo mkfs.ext4 /dev/sdb1

### Mount

    sudo mkdir -p /mnt/iscsi
    sudo mount /dev/sdb1 /mnt/iscsi

Verify:

    df -h
    lsblk

---

## 🔌 Clean detach (VERY IMPORTANT)

### Unmount first

    sudo umount /mnt/iscsi

### Logout

    sudo iscsiadm -m node -T <IQN> -p <server-ip> --logout

### Optional: remove record

    sudo iscsiadm -m node -o delete -T <IQN> -p <server-ip>

---

## 🧨 Failure Modes

- Disk disappears → network or target problem
- I/O hangs → path or SAN issue
- Mount hangs → remote path broken

From Linux’s perspective:

> This looks exactly like a dying disk.

---

# Part 2 — NBD (Network Block Device)

NBD is simpler and often used for:

- Serving disk images
- Attaching remote image files
- Quick labs and testing

---

## 🧰 Install tools

    sudo apt-get install -y nbd-client

Load module:

    sudo modprobe nbd

Verify:

    ls /dev/nbd*

---

## 🔌 Connect to an NBD server

    sudo nbd-client <server-ip> 10809 /dev/nbd0

Or with qemu-nbd (image file):

    sudo qemu-nbd --connect=/dev/nbd0 disk.img

Verify:

    lsblk

You now have:

    /dev/nbd0

---

## 🧪 Use it like a disk

    sudo fdisk /dev/nbd0
    sudo mkfs.ext4 /dev/nbd0p1
    sudo mount /dev/nbd0p1 /mnt/nbd

---

## 🔌 Clean detach

### Unmount

    sudo umount /mnt/nbd

### Disconnect

    sudo nbd-client -d /dev/nbd0

Or:

    sudo qemu-nbd --disconnect /dev/nbd0

---

# 🧭 How To Recognize Network Block Devices

Run:

    lsblk

Look for:

- `/dev/sdX` that came from nowhere
- `/dev/nbdX`

Check:

    dmesg | tail

---

# 🧯 Debug Checklist

- Does the device exist?

    lsblk

- Is it mounted?

    findmnt

- Is it busy?

    lsof +f -- /dev/sdX
    fuser -vm /dev/sdX

- Is the network path alive?

    ping <server>

---

# ⚠️ Important Distinction

| Type | Looks like | Use case |
|------|------------|-----------|
| iSCSI / NBD | Block device (`/dev/sdX`, `/dev/nbdX`) | Partition / format / mount |
| NFS / CIFS | Filesystem mount | Shared files, not disks |

If you see:

    mount -t nfs ...
    mount -t cifs ...

That is **not** a block device.

---

# 🧠 Exam Mindset

You should be able to:

- Discover an iSCSI target
- Attach it
- Prove it exists with `lsblk`
- Format and mount it
- Cleanly unmount and detach it

And explain:

> “This is a remote disk, not a remote filesystem.”

---

# 🏁 Canonical Summary

- Network block devices appear as **real disks**
- Linux treats them **exactly like local storage**
- Always:
  - identify
  - mount
  - unmount
  - detach
- Never remove the network path while mounted

