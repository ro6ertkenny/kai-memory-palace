# 🗄️ Phase 7 — Storage, Filesystems, Mounting, Swap, and LVM
*LFCS data plane: disks, filesystems, mounts, and capacity management.*

---

## 📌 Purpose

This phase makes you **storage-competent and outage-resistant** with:

- Partitioning disks
- Creating and repairing filesystems
- Mounting and persisting mounts
- Managing swap
- Using labels and UUIDs
- Creating and resizing LVM volumes

Many LFCS tasks are:

> “Disk is full.”  
> “Add space.”  
> “Mount this safely and persistently.”  
> “Make this filesystem read-only.”  

---

## 🧠 Mental Model

- Disk → Partition → Filesystem → Mountpoint
- LVM adds a layer:
  - Disk → PV → VG → LV → Filesystem → Mountpoint
- `/etc/fstab` defines **persistent mounts**
- Swap is just a special filesystem type

---

# 🧱 Part A — Discover Storage

List block devices:

    lsblk

Filesystem usage:

    df -h
    df -TH

Directory size:

    du -sh /bin

Mounted filesystems:

    findmnt
    cat /proc/mounts

Find UUID:

    blkid

---

# 🪓 Part B — Partitioning

Using fdisk:

    sudo fdisk /dev/vdb

Inside:

    m  (help)
    n  (new partition)
    w  (write)

Using cfdisk:

    sudo cfdisk

---

# 🧫 Part C — Create Filesystems

ext4:

    sudo mkfs.ext4 /dev/vdb1

xfs:

    sudo mkfs.xfs -L DataDisk /dev/vdb1

Check filesystem:

    sudo fsck /dev/vdb1
    sudo xfs_repair -n /dev/vdb1

---

# 📎 Part D — Mounting

Temporary:

    sudo mount /dev/vdb1 /mnt

Unmount:

    sudo umount /mnt

With options:

    sudo mount -o ro,noexec,nosuid /dev/vdb1 /mnt

Remount:

    sudo mount -o remount,rw /mnt

---

# 🧾 Part E — Persistent Mounts (/etc/fstab)

Edit:

    sudo vi /etc/fstab

Example:

    /dev/disk/by-uuid/UUID /data ext4 defaults 0 2
    /dev/vdb1 /mnt ext4 ro 0 2
    /swap.img none swap sw 0 0

Test:

    sudo mount -a

---

# 🔁 Part F — Swap

Create partition swap:

    sudo mkswap /dev/vdb2
    sudo swapon /dev/vdb2

Create swap file:

    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile

Show:

    swapon -h
    swapon -s

Disable:

    sudo swapoff /swapfile

Make persistent:

    /swapfile none swap sw 0 0

Remove from boot:

    sed -i '/swapfile/d' /etc/fstab

---

# 🧱 Part G — tmpfs

Mount:

    sudo mount -t tmpfs tmpfs /mnt/tmpfs

fstab:

    tmpfs /mnt/tmpfs tmpfs defaults 0 0

---

# 🧬 Part H — LVM

## Install:

    sudo apt install lvm2

## Create PV:

    sudo pvcreate /dev/vdb /dev/vdc
    pvs

## Create VG:

    sudo vgcreate volume1 /dev/vdb
    vgs

Extend VG:

    sudo vgextend volume1 /dev/vdc

## Create LV:

    sudo lvcreate -L 5G -n data volume1
    lvs

## Format and mount:

    sudo mkfs.xfs /dev/volume1/data
    sudo mount /dev/volume1/data /data

## Resize LV:

    sudo lvresize -L +2G /dev/volume1/data
    sudo lvresize -l 100%VG /dev/volume1/data

Then resize FS:

    sudo xfs_growfs /data
    sudo resize2fs /dev/volume1/data

---

# 🌐 Part I — Network Filesystems (NFS)

Server:

    sudo vi /etc/exports
    /home 10.0.0.0/24(ro)

Apply:

    sudo exportfs -r
    sudo systemctl restart nfs-server

Client mount:

    sudo mount server:/home /mnt

fstab:

    server:/home /mnt nfs defaults 0 0

---

# 🧪 Canonical Exam Scenarios

Create swap and persist:

    sudo mkswap /dev/vdb2
    sudo swapon /dev/vdb2
    echo "/dev/vdb2 none swap sw 0 0" >> /etc/fstab

Mount read-only persistently:

    /dev/vdb1 /staging ext4 ro 0 2

Extend LV:

    sudo vgextend volume1 /dev/vdc
    sudo lvresize -l 100%VG volume1/data
    sudo xfs_growfs /data

Find largest file and delete:

    find /mnt -type f -exec ls -s {} + | sort -n -r | head -1 | awk '{print $2}' | xargs sudo rm -f

---

## ⚠️ Failure Modes

- Formatting wrong disk
- Forgetting to resize filesystem after LV resize
- Breaking boot with bad fstab entry
- Forgetting mount -a test
- Removing wrong swap

---

## 🏁 Phase 7 Mastery Checklist

You must be able to:

- Partition disks
- Create ext4 and xfs filesystems
- Mount and persist mounts
- Use UUIDs and labels
- Create and manage swap
- Create, extend, and resize LVM volumes
- Repair filesystems
- Mount NFS shares

---

## 🔒 Exam Law

> **If you can’t manage storage safely, you can’t run production systems.**

---
