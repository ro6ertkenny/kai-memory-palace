# 🧪 Storage and Mounts — Execution Drills (LFCS)

Mental mode: Disk discipline.  
Goal: Be able to **identify, partition, format, mount, persist, inspect, and repair storage** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

---

## 💽 1) Inspect Block Devices

- List block devices
- Show filesystem types
- Show UUIDs and labels
- Show mount points

    lsblk
    lsblk -f
    blkid
    mount
    df -h
    df -T

---

## 🧱 2) Partitioning (Practice on a Spare Disk or Loop Device)

- List disks
- Enter partition tool
- Create partition
- Write table
- Re-read partition table

    lsblk
    sudo fdisk /dev/sdb
    sudo partprobe
    lsblk

---

## 🧪 3) Create Filesystems

- Create ext4 filesystem
- Create xfs filesystem
- Verify filesystem type
- Show filesystem details

    sudo mkfs.ext4 /dev/sdb1
    sudo mkfs.xfs /dev/sdb2
    lsblk -f
    sudo tune2fs -l /dev/sdb1

---

## 🏷️ 4) Labels and UUIDs

- Set filesystem label
- Show label
- Change label
- Mount by UUID
- Mount by label

    sudo e2label /dev/sdb1 data1
    sudo xfs_admin -L data2 /dev/sdb2
    blkid
    sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data1
    sudo mount LABEL=data1 /mnt/data1

---

## 📂 5) Mounting and Unmounting

- Create mount point
- Mount filesystem
- Verify mount
- Unmount filesystem
- Lazy unmount

    sudo mkdir -p /mnt/data1
    sudo mount /dev/sdb1 /mnt/data1
    mount | grep data1
    df -h | grep data1
    sudo umount /mnt/data1
    sudo umount -l /mnt/data1

---

## 🧷 6) Persistent Mounts (/etc/fstab)

- Backup fstab
- Get UUID
- Add entry
- Test fstab
- Mount all

    sudo cp /etc/fstab /etc/fstab.bak
    blkid
    sudo nano /etc/fstab
    sudo mount -a
    df -h

---

## 🧠 7) tmpfs and Special Mounts

- Mount tmpfs
- Verify tmpfs
- Unmount tmpfs

    sudo mount -t tmpfs -o size=256M tmpfs /mnt/tmpfs
    df -h | grep tmpfs
    sudo umount /mnt/tmpfs

---

## 🧪 8) Swap

- Show swap status
- Create swap file
- Set permissions
- Format swap
- Enable swap
- Make persistent
- Disable swap

    swapon --show
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    swapon --show
    sudo nano /etc/fstab
    sudo swapoff /swapfile

---

## 🔍 9) Filesystem Check and Repair

- Check ext filesystem
- Force check
- Check at next boot

    sudo umount /dev/sdb1
    sudo fsck /dev/sdb1
    sudo fsck -f /dev/sdb1
    sudo tune2fs -c 1 /dev/sdb1

---

## 📏 10) Disk Usage Analysis

- Show disk usage
- Show directory usage
- Find large files

    df -h
    du -sh /var/*
    du -sh *
    find / -size +1G 2>/dev/null

---

## 🧩 11) Loop Devices (Practice Without Real Disks)

- Create image file
- Attach loop device
- Format it
- Mount it
- Detach loop device

    dd if=/dev/zero of=disk.img bs=1M count=1024
    sudo losetup -fP disk.img
    losetup -a
    sudo mkfs.ext4 /dev/loop0
    sudo mount /dev/loop0 /mnt/loop
    sudo umount /mnt/loop
    sudo losetup -d /dev/loop0

---

## 🧰 12) Remounting and Mount Options

- Mount read-only
- Remount read-write
- Use noexec, nodev, nosuid

    sudo mount -o ro /dev/sdb1 /mnt/data1
    sudo mount -o remount,rw /mnt/data1
    sudo mount -o noexec,nodev,nosuid /dev/sdb1 /mnt/data1

---

## 🧯 13) Emergency Recovery Drills

- Boot into rescue/emergency mode
- Remount root read-write
- Fix fstab
- Reboot

    mount -o remount,rw /
    nano /etc/fstab
    reboot

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can provision storage from scratch in minutes
- You never break fstab
- You can recover from a bad mount under pressure
- You can do all of this **without Googling**

---
