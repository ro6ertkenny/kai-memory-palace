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
    sudo mkdir -p /mnt/loop
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

## 🧱 13) LVM (Physical Volume → Volume Group → Logical Volume)

Goal: Create LVM storage, mount it, extend it, and prove it worked.

Detect/install tools:

    command -v lvm || true
    sudo apt-get update
    sudo apt-get install -y lvm2

Inspect LVM state:

    sudo pvs
    sudo vgs
    sudo lvs

Create PV/VG/LV (example uses /dev/sdb2 as a lab partition):

    sudo pvcreate /dev/sdb2
    sudo vgcreate vg_lab /dev/sdb2
    sudo lvcreate -n lv_data -L 1G vg_lab

Make filesystem and mount:

    sudo mkfs.ext4 /dev/vg_lab/lv_data
    sudo mkdir -p /mnt/lv_data
    sudo mount /dev/vg_lab/lv_data /mnt/lv_data
    df -h | grep lv_data || true

Extend LV + filesystem (ext4 grow):

    sudo lvextend -L +512M /dev/vg_lab/lv_data
    sudo resize2fs /dev/vg_lab/lv_data
    df -h | grep lv_data || true

LVM rollback drill (only on lab devices):

    sudo umount /mnt/lv_data
    sudo lvremove -y /dev/vg_lab/lv_data
    sudo vgremove -y vg_lab
    sudo pvremove -y /dev/sdb2

---

## 🧱 14) RAID (mdadm) — Create and Verify a Mirror

Goal: Create a RAID1 array, format, mount, and confirm RAID health.

Detect/install tools:

    command -v mdadm || true
    sudo apt-get update
    sudo apt-get install -y mdadm

Inspect current arrays:

    cat /proc/mdstat
    sudo mdadm --detail --scan || true

Create RAID1 from two equal lab partitions (example: /dev/sdb3 and /dev/sdc3):

    sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb3 /dev/sdc3
    cat /proc/mdstat
    sudo mdadm --detail /dev/md0

Format and mount:

    sudo mkfs.ext4 /dev/md0
    sudo mkdir -p /mnt/md0
    sudo mount /dev/md0 /mnt/md0
    df -h | grep md0 || true

Persist mdadm config (Debian-style):

    sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
    sudo update-initramfs -u

Stop and remove RAID (lab cleanup):

    sudo umount /mnt/md0
    sudo mdadm --stop /dev/md0
    sudo mdadm --remove /dev/md0
    cat /proc/mdstat

---

## 🔒 15) LUKS Encryption (cryptsetup)

Goal: Encrypt a block device, open it, format it, mount it, and close it.

Detect/install tools:

    command -v cryptsetup || true
    sudo apt-get update
    sudo apt-get install -y cryptsetup

WARNING: Only use a lab partition (example: /dev/sdb4). This destroys data.

Initialize LUKS container:

    sudo cryptsetup luksFormat /dev/sdb4

Open encrypted device (mapper name: crypt_lab):

    sudo cryptsetup open /dev/sdb4 crypt_lab
    ls -la /dev/mapper/crypt_lab

Make filesystem and mount:

    sudo mkfs.ext4 /dev/mapper/crypt_lab
    sudo mkdir -p /mnt/crypt_lab
    sudo mount /dev/mapper/crypt_lab /mnt/crypt_lab
    df -h | grep crypt_lab || true

Close encrypted device:

    sudo umount /mnt/crypt_lab
    sudo cryptsetup close crypt_lab

Persist at boot awareness (not required to enable, but recognize files):

    ls -la /etc/crypttab || true
    sudo cat /etc/crypttab 2>/dev/null || true

---

## 📏 16) Filesystem Quotas (User/Group Disk Quotas)

Goal: Enable quotas on a filesystem, run quotacheck, and set a limit.

Detect/install tools:

    command -v quota || true
    command -v setquota || true
    sudo apt-get update
    sudo apt-get install -y quota

Choose a mount point (example: /mnt/data1) and enable quota mount options in /etc/fstab:
- For ext4: add usrquota,grpquota in mount options

Backup and edit fstab:

    sudo cp /etc/fstab /etc/fstab.quota.bak
    sudo nano /etc/fstab

Remount with quota options:

    sudo mount -o remount /mnt/data1
    mount | grep /mnt/data1 || true

Initialize quota files and enable quotas:

    sudo quotacheck -cum /mnt/data1
    sudo quotacheck -cugm /mnt/data1
    sudo quotaon -vug /mnt/data1

Set a quota for a user (example: testuser), in 1K blocks:
- soft=100000 (about 100MB), hard=120000 (about 120MB)

    sudo setquota -u testuser 100000 120000 0 0 /mnt/data1
    sudo quota -u testuser

Disable quotas and rollback mount options if needed:

    sudo quotaoff -vug /mnt/data1
    sudo cp /etc/fstab.quota.bak /etc/fstab
    sudo mount -a

---

## 🧷 17) Automount (autofs)

Goal: Configure on-demand mounting via autofs and prove it mounts when accessed.

Detect/install tools:

    command -v automount || true
    sudo apt-get update
    sudo apt-get install -y autofs

Inspect master map:

    sudo cp /etc/auto.master /etc/auto.master.bak
    sudo cat /etc/auto.master

Create a simple indirect map:
- Master points /- to /etc/auto.direct
- auto.direct defines a mount for /mnt/auto_data

Edit master:

    sudoedit /etc/auto.master

Add line:

    /-    /etc/auto.direct

Create map file:

    sudoedit /etc/auto.direct

Example mapping (use a real device or NFS share; example uses /dev/sdb1):

    /mnt/auto_data    -fstype=ext4    :/dev/sdb1

Restart autofs and trigger mount:

    sudo systemctl enable --now autofs
    sudo systemctl restart autofs
    ls -la /mnt/auto_data
    mount | grep auto_data || true

Cleanup and rollback:

    sudo cp /etc/auto.master.bak /etc/auto.master
    sudo rm -f /etc/auto.direct
    sudo systemctl restart autofs

---

## 🧯 18) Emergency Recovery Drills

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
- You can build LVM volumes, RAID arrays, and encrypted volumes from scratch
- You can enable and verify filesystem quotas
- You can configure autofs and prove it mounts on access

---
