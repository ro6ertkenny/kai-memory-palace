# ⚔️ Phase 7 — Storage, Filesystems, LVM, and Swap (Execution Playbook)
*LFCS data-plane layer: if you can’t add space, mount it safely, and recover from mistakes, you don’t control persistence.*

Path:
- linux/LFCS-execution-playbooks/phase-7-storage-filesystems-lvm-and-swap.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- discover block devices and filesystems
- partition disks
- create ext4 and xfs filesystems
- mount and unmount safely
- persist mounts with /etc/fstab and test them
- create and remove swap (partition and file)
- use UUIDs and labels
- create, extend, and resize LVM volumes
- grow filesystems after LV resize
- avoid breaking boot with bad fstab entries

---

## 🧱 Lab Root

All Phase 7 drills run in:

- ~/lfcs-labs/phase-7

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-7
    cd ~/lfcs-labs/phase-7
    rm -rf ./*

---

## ⚠️ Safety Contract

- These drills assume you have **at least one spare disk** (e.g., /dev/vdb, /dev/vdc).
- **Never** run partitioning or mkfs commands on your root disk.
- If you do not have spare disks, stop here and attach them first.

---

## 🧪 Completion Standard

Pass Phase 7 when you can complete P7-1 through P7-16:

- in ≤ 120 minutes total
- with zero fstab boot-breaks
- without formatting the wrong disk
- without forgetting to resize the filesystem after LV resize

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P7-1 — Discover block devices

Time limit:
- 4 minutes

Task:
Save block device layout to lsblk.txt.

Do:

    lsblk -f > lsblk.txt

Verify:

    cat lsblk.txt

-------------------------------------------------------------------------------

## P7-2 — Identify filesystem usage

Time limit:
- 3 minutes

Task:
Save filesystem usage to df.txt.

Do:

    df -hT > df.txt

Verify:

    cat df.txt

-------------------------------------------------------------------------------

## P7-3 — Partition a spare disk

Time limit:
- 10 minutes

Task:
Create one new partition on a spare disk (example: /dev/vdb1).

Do:

    sudo fdisk /dev/vdb

Inside fdisk:

    n
    w

Then:

    lsblk

Verify:
- You see /dev/vdb1 (or equivalent)

-------------------------------------------------------------------------------

## P7-4 — Create ext4 filesystem

Time limit:
- 4 minutes

Task:
Create ext4 on the new partition.

Do:

    sudo mkfs.ext4 /dev/vdb1

Verify:

    sudo blkid /dev/vdb1

-------------------------------------------------------------------------------

## P7-5 — Mount temporarily

Time limit:
- 4 minutes

Task:
Mount it at /mnt/p7test.

Do:

    sudo mkdir -p /mnt/p7test
    sudo mount /dev/vdb1 /mnt/p7test

Verify:

    findmnt /mnt/p7test

-------------------------------------------------------------------------------

## P7-6 — Unmount safely

Time limit:
- 2 minutes

Task:
Unmount it.

Do:

    sudo umount /mnt/p7test

Verify:

    findmnt /mnt/p7test || echo "unmounted"

-------------------------------------------------------------------------------

## P7-7 — Persist mount with UUID

Time limit:
- 10 minutes

Task:
Persist the mount at /mnt/p7test using UUID.

Do:

    sudo blkid /dev/vdb1
    sudo vi /etc/fstab

Add line (example):

    UUID=xxxx-xxxx /mnt/p7test ext4 defaults 0 2

Then:

    sudo mount -a

Verify:

    findmnt /mnt/p7test

-------------------------------------------------------------------------------

## P7-8 — Test fstab safety

Time limit:
- 3 minutes

Task:
Prove fstab is clean.

Do:

    sudo mount -a

Verify:
- No errors printed

-------------------------------------------------------------------------------

## P7-9 — Create swap file

Time limit:
- 8 minutes

Task:
Create 512M swap file and enable it.

Do:

    sudo fallocate -l 512M /swap-p7.img
    sudo chmod 600 /swap-p7.img
    sudo mkswap /swap-p7.img
    sudo swapon /swap-p7.img

Verify:

    swapon -s

-------------------------------------------------------------------------------

## P7-10 — Persist swap

Time limit:
- 5 minutes

Task:
Make swap persistent.

Do:

    echo "/swap-p7.img none swap sw 0 0" | sudo tee -a /etc/fstab
    sudo mount -a

Verify:

    swapon -s

-------------------------------------------------------------------------------

## P7-11 — Disable and remove swap

Time limit:
- 5 minutes

Task:
Remove the swap file.

Do:

    sudo swapoff /swap-p7.img
    sudo sed -i '\|/swap-p7.img|d' /etc/fstab
    sudo rm -f /swap-p7.img

Verify:

    swapon -s

-------------------------------------------------------------------------------

## P7-12 — Initialize LVM (PV + VG)

Time limit:
- 12 minutes

Task:
Create PV and VG on spare disk(s).

Do:

    sudo apt-get install -y lvm2
    sudo pvcreate /dev/vdb
    sudo vgcreate p7vg /dev/vdb

Verify:

    pvs
    vgs

-------------------------------------------------------------------------------

## P7-13 — Create LV and filesystem

Time limit:
- 10 minutes

Task:
Create 1G LV named data and format it.

Do:

    sudo lvcreate -L 1G -n data p7vg
    sudo mkfs.xfs /dev/p7vg/data

Verify:

    lvs
    sudo blkid /dev/p7vg/data

-------------------------------------------------------------------------------

## P7-14 — Mount LV and persist

Time limit:
- 8 minutes

Task:
Mount LV at /data-p7 and persist it.

Do:

    sudo mkdir -p /data-p7
    sudo mount /dev/p7vg/data /data-p7
    sudo blkid /dev/p7vg/data
    sudo vi /etc/fstab

Add line:

    UUID=xxxx-xxxx /data-p7 xfs defaults 0 0

Then:

    sudo mount -a

Verify:

    findmnt /data-p7

-------------------------------------------------------------------------------

## P7-15 — Extend LV and grow filesystem

Time limit:
- 12 minutes

Task:
Extend LV by +512M and grow filesystem.

Do:

    sudo lvextend -L +512M /dev/p7vg/data
    sudo xfs_growfs /data-p7

Verify:

    df -h /data-p7

-------------------------------------------------------------------------------

## P7-16 — Prove recovery mindset

Time limit:
- 5 minutes

Task:
Capture current mount table and block layout.

Do:

    findmnt > mounts.txt
    lsblk -f > block-layout.txt

Verify:

    wc -l mounts.txt
    wc -l block-layout.txt

---

## 🏁 Phase 7 Pass Criteria

You can:

- identify disks and filesystems
- partition safely
- create and mount filesystems
- persist mounts with UUID
- test fstab without breaking boot
- create, enable, disable, and remove swap
- create PV, VG, LV
- format and mount LVs
- extend LVs and grow filesystems
- capture evidence of state

---

## 🔒 Phase 7 Law

If you can’t add space and mount it safely without breaking boot,
you do not control persistence.

---

