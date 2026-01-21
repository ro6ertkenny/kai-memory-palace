# 🧪 Storage and Mounts — Execution Drills (LFCS)

Mental mode: Disk discipline.  
Goal: Be able to **identify, partition, format, mount, persist, inspect, repair, and safely move data** under time pressure.

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

## 📦 13) Archives, Compression, and Backups

Mental mode: Move data fast without destroying it.

### 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-3
    cd ~/lfcs-labs/execution-drills/phase-3
    mkdir -p data/src/projectA data/src/projectB logs backup restore mirror dest

    echo "alpha" > data/src/projectA/a.txt
    echo "beta"  > data/src/projectA/b.txt
    echo "gamma" > data/src/projectB/c.txt

    date > logs/log1.txt
    date > logs/log2.txt

    dd if=/dev/zero of=data/src/projectA/big1 bs=1K count=10 status=none
    dd if=/dev/zero of=data/src/projectB/big2 bs=1K count=50 status=none

---

### 📦 A) tar drills (create, list, extract)

Create and list:

    tar cf backup/a1.tar data/src
    tar tf backup/a1.tar

Create compressed variants:

    tar czf backup/a2.tar.gz data/src
    tar cjf backup/a2.tar.bz2 data/src
    tar cJf backup/a2.tar.xz data/src

List one:

    tar tzf backup/a2.tar.gz

Extract to specific directory:

    mkdir -p restore/a3
    tar xf backup/a1.tar -C restore/a3
    ls restore/a3/data/src

Extract a single file:

    tar tf backup/a1.tar
    tar xf backup/a1.tar -C restore/a3 data/src/projectA/a.txt
    cat restore/a3/data/src/projectA/a.txt

Safety notes:
- Prefer extracting into an empty restore directory
- Be intentional with `-C` (extract location)

---

### 🧊 B) gzip / bzip2 / xz drills (keep originals)

Compress while keeping original:

    cp backup/a1.tar backup/test.tar
    gzip -k backup/test.tar
    bzip2 -k backup/test.tar
    xz -k backup/test.tar

Verify:

    ls -la backup/test.tar*

Decompress:

    gunzip backup/test.tar.gz
    bunzip2 backup/test.tar.bz2
    unxz backup/test.tar.xz

Verify original still exists:

    test -f backup/test.tar && echo OK

---

### 🗜️ C) zip / unzip drills

Create and extract zip:

    command -v zip >/dev/null || sudo apt-get update && sudo apt-get install -y zip unzip

    zip -r backup/c1.zip data/src
    mkdir -p restore/c1
    unzip backup/c1.zip -d restore/c1
    ls restore/c1

---

### 🧠 D) Incremental/differential concept drill

Full backup:

    tar czf backup/full.tgz data/src

Modify data:

    echo "delta" >> data/src/projectA/a.txt

Create “since time” diff (concept drill):

    date -Iseconds > backup/last_full_time.txt
    tar czf backup/diff.tgz --newer-mtime="$(cat backup/last_full_time.txt)" data/src
    tar tzf backup/diff.tgz

Restore order (say it out loud):
1) restore full
2) restore diffs

Note:
- This is a concept drill; real-world incremental strategies vary.

---

### 🔁 E) rsync drills (mirror + safety)

Mirror copy:

    rsync -av data/src/ mirror/

Modify source:

    rm data/src/projectA/b.txt
    echo "new" > data/src/projectB/new.txt

Dry-run delete (must be dry-run first):

    rsync -av --delete --dry-run data/src/ mirror/

Real run:

    rsync -av --delete data/src/ mirror/

Verify mirror matches:

    diff -r data/src mirror

Copy with relative paths (exam pattern):

    mkdir -p backup/etc-like
    find data/src -name "*.txt" -exec rsync -R {} backup/etc-like \;
    find backup/etc-like

Safety law:
- Always do `--dry-run` before `--delete`
- Always triple-check direction: `source/` then `dest/`

---

### 🧱 F) dd safety drills (FILES ONLY)

⚠️ DO NOT use real disks. Use files.

Create fake “disk” file:

    dd if=/dev/zero of=fake-disk.img bs=1M count=20 status=progress

Write pattern:

    echo "HELLO" | dd of=fake-disk.img conv=notrunc

Backup and compress:

    dd if=fake-disk.img bs=4M status=progress | gzip > backup/fake-disk.img.gz

Restore to new file:

    gunzip -c backup/fake-disk.img.gz | dd of=fake-disk-restored.img bs=4M status=progress

Verify:

    cmp fake-disk.img fake-disk-restored.img && echo OK

Safety law:
- If you are not 100% sure what `if=` and `of=` point to, do not run dd.

---

### ✅ G) Backup, verify, restore (composition)

Backup:

    tar czf backup/comp.tgz data/src

Verify archive:

    tar tzf backup/comp.tgz

Restore:

    mkdir -p restore/comp
    tar xf backup/comp.tgz -C restore/comp

Verify restore:

    diff -r data/src restore/comp/data/src

---

## 🧱 14) LVM (Physical Volume → Volume Group → Logical Volume)

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

## 🧱 15) RAID (mdadm) — Create and Verify a Mirror

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

## 🔒 16) LUKS Encryption (cryptsetup)

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

## 📏 17) Filesystem Quotas (User/Group Disk Quotas)

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

## 🧷 18) Automount (autofs)

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

## 🧯 19) Emergency Recovery Drills

- Boot into rescue/emergency mode
- Remount root read-write
- Fix fstab
- Reboot

    mount -o remount,rw /
    nano /etc/fstab
    reboot

---

## ✅ Completion Criteria

You are done with this file when:

- You can provision storage from scratch in minutes
- You never break fstab
- You can recover from a bad mount under pressure
- You can create and extract archives in multiple formats
- You can perform backup → verify → restore and prove integrity
- You can use rsync safely with --delete and --dry-run
- You can image/restore file targets safely with dd
- You can build LVM volumes, RAID arrays, and encrypted volumes from scratch
- You can enable and verify filesystem quotas
- You can configure autofs and prove it mounts on access

---

