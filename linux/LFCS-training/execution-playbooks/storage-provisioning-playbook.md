# 🧱 Storage Provisioning Playbook (LFCS)
**Path:** `linux/LFCS-training/execution-playbooks/storage-provisioning-playbook.md`  
**Purpose:** Build and modify **persistent storage** safely (new disks, filesystems, mounts, fstab, swap, LVM), using an **exam-ready operator algorithm**.

This is not a tutorial.  
This is a **measure → classify → execute → verify → persist** playbook.

---

## 🎯 Scope

Use this playbook when the task is to **create or change storage intentionally**, such as:

- Add a new disk/partition and create a filesystem
- Mount/unmount a filesystem safely
- Make a mount persistent in `/etc/fstab` and prove it’s safe
- Create/enable/disable swap (file or partition)
- Create/extend LVM (PV/VG/LV) and grow filesystems
- Label/UUID-based mounting for reliability

This playbook is **not** for “it’s broken” recovery (that is `storage-recovery-playbook.md`).

---

## 🧩 Composes From (Execution Drills)

Mechanics live in drills. This playbook routes and sequences them.

- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

---

## 🧠 Operator Contract

Proceed in this order:

1) **Detect and identify** target devices (never guess)
2) **Classify** the requested storage outcome (FS mount vs swap vs LVM)
3) **Execute** minimal correct steps
4) **Verify** with multiple signals (lsblk/blkid/findmnt/df/free/swapon)
5) **Persist** safely (fstab) and prove `mount -a` is clean
6) **Capture evidence** (state snapshot)

Never start with `mkfs` or `fdisk` until you have proven the correct target device.

---

## ⚠️ Global Safety Rules (Non-Negotiable)

- **Never format your root disk.** If you aren’t 100% sure, STOP.
- Before any destructive command (`fdisk`, `parted`, `mkfs`, `pvcreate`):
  - **Prove target identity** with at least two of: `lsblk -f`, `blkid`, `fdisk -l`, `readlink -f /dev/disk/by-id/*`
- Prefer **UUID** or **LABEL** in `/etc/fstab`, not `/dev/sdX1`.
- After editing `/etc/fstab`:
  - Always run `sudo mount -a`
  - Always confirm mounts with `findmnt`
- Keep changes minimal. Create only what the task requires.

---

## 0) Inputs (What You Must Know)

Determine:

- What is being requested?
  - A filesystem mount?
  - Swap?
  - LVM?
  - Persistence across reboot?
- Which device(s) are safe to use?
- Where should it mount (path)?
- Filesystem type required (`ext4`, `xfs`, etc.)?
- For LVM: VG name, LV name, size.

---

## 1) Detect and Inventory (No Changes)

Baseline the system:

    lsblk -f
    blkid
    df -hT
    findmnt
    swapon --show || true
    free -h

If block devices are ambiguous:

    sudo fdisk -l

Decision gate:

- You can clearly identify the **target disk** that is NOT your root disk.
- You can clearly identify whether it is **blank**, **partitioned**, or **already in use**.

If you cannot: STOP and re-check. Do not proceed.

---

## 2) Classify the Task (Choose the Branch)

Choose exactly one primary branch:

A) **Filesystem Provisioning + Mount**  
B) **Persistent Mount via /etc/fstab**  
C) **Swap (file or partition)**  
D) **LVM Create** (PV → VG → LV → FS → mount)  
E) **LVM Extend + Grow FS** (LV grow + filesystem grow)  
F) **Label/UUID Governance** (standardizing mount identity)

You may compose branches (common: A + B, or D + B).

---

## A) Filesystem Provisioning + Mount (Partition optional)

### A1) If you need a new partition

Confirm target disk (example `/dev/vdb`):

    lsblk -f /dev/vdb
    sudo fdisk -l /dev/vdb

Create partition (fdisk example):

    sudo fdisk /dev/vdb

Inside `fdisk` (typical):
- `n` (new)
- accept defaults
- `w` (write)

Re-scan and verify partition exists:

    lsblk -f /dev/vdb

### A2) Create filesystem

Choose FS type required by task.

ext4:

    sudo mkfs.ext4 -F /dev/vdb1

xfs:

    sudo mkfs.xfs -f /dev/vdb1

Verify:

    sudo blkid /dev/vdb1
    lsblk -f /dev/vdb1

### A3) Mount temporarily

Create mountpoint:

    sudo mkdir -p /mnt/target

Mount:

    sudo mount /dev/vdb1 /mnt/target

Verify:

    findmnt /mnt/target
    df -hT /mnt/target

---

## B) Persist Mount Safely (/etc/fstab)

### B1) Capture UUID (preferred)

    sudo blkid /dev/vdb1

Create mountpoint if needed:

    sudo mkdir -p /mnt/target

Edit `/etc/fstab` (use your editor):

    sudo vi /etc/fstab

Add line (example for ext4):

    UUID=xxxx-xxxx  /mnt/target  ext4  defaults  0  2

For xfs (often last field 0):

    UUID=xxxx-xxxx  /mnt/target  xfs  defaults  0  0

### B2) Prove fstab is safe

Mandatory gate:

    sudo mount -a

Then prove it mounted:

    findmnt /mnt/target
    df -hT /mnt/target

If `mount -a` prints errors:
- Do not reboot.
- Fix `/etc/fstab` immediately.
- Re-run `sudo mount -a` until clean.

---

## C) Swap (File or Partition)

### C1) Swap file (common and safe)

Create swap file (example 512M):

    sudo fallocate -l 512M /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile

Verify:

    swapon --show
    free -h

Persist:

    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
    sudo mount -a

Verify again:

    swapon --show

### C2) Swap partition (when required)

Create/identify partition (example `/dev/vdb2`) then:

    sudo mkswap /dev/vdb2
    sudo swapon /dev/vdb2

Verify:

    swapon --show

Persist by UUID:

    sudo blkid /dev/vdb2
    sudo vi /etc/fstab

Add line:

    UUID=yyyy-yyyy none swap sw 0 0

Prove:

    sudo mount -a
    swapon --show

---

## D) LVM Create (PV → VG → LV → FS → Mount)

### D1) Prepare the disk

Use either a whole disk or a partition. If using a partition, create it first.

Install LVM tools (Debian/Ubuntu):

    sudo apt-get update
    sudo apt-get install -y lvm2

Create PV:

    sudo pvcreate /dev/vdb

Create VG:

    sudo vgcreate vgdata /dev/vdb

Verify:

    pvs
    vgs

### D2) Create LV

Example 1G LV named `data`:

    sudo lvcreate -L 1G -n data vgdata

Verify:

    lvs

### D3) Create filesystem on LV

ext4:

    sudo mkfs.ext4 -F /dev/vgdata/data

xfs:

    sudo mkfs.xfs -f /dev/vgdata/data

Verify:

    sudo blkid /dev/vgdata/data
    lsblk -f /dev/vgdata/data

### D4) Mount and persist (same as Branch B)

Mount:

    sudo mkdir -p /data
    sudo mount /dev/vgdata/data /data

Verify:

    findmnt /data
    df -hT /data

Persist with UUID:

    sudo blkid /dev/vgdata/data
    sudo vi /etc/fstab
    sudo mount -a
    findmnt /data

---

## E) LVM Extend + Grow Filesystem

### E1) Extend the LV

Example: extend by +512M:

    sudo lvextend -L +512M /dev/vgdata/data

### E2) Grow the filesystem (depends on FS type)

ext4 (mounted):

    sudo resize2fs /dev/vgdata/data

xfs (must use mountpoint):

    sudo xfs_growfs /data

Verify:

    df -hT /data
    lvs

---

## F) Labels and Stable Identity (Optional but Exam-Smart)

If the task expects stable naming:

Label ext4:

    sudo e2label /dev/vdb1 data01

Label xfs:

    sudo xfs_admin -L data01 /dev/vdb1

Verify:

    lsblk -f
    blkid

You may use `LABEL=` in `/etc/fstab` if desired:

    LABEL=data01  /mnt/target  ext4  defaults  0  2

---

## ✅ Verification Gate (Exit Criteria)

You are done only when:

- Devices and filesystems are correct:

    lsblk -f
    blkid

- Mounts are correct and persistent:

    findmnt
    sudo mount -a

- Filesystem shows correct type + usage:

    df -hT

- Swap is correct (if involved):

    swapon --show
    free -h

- LVM is correct (if involved):

    pvs
    vgs
    lvs

---

## 🧾 Evidence Capture (Recommended)

Capture “proof of state” for your own discipline:

    lsblk -f > storage-lsblk.txt
    findmnt > storage-findmnt.txt
    df -hT > storage-df.txt
    swapon --show > storage-swap.txt 2>/dev/null || true
    pvs > storage-pvs.txt 2>/dev/null || true
    vgs > storage-vgs.txt 2>/dev/null || true
    lvs > storage-lvs.txt 2>/dev/null || true

---

## 🔁 Rollback Guidance (Minimal)

If you created artifacts you shouldn’t keep:

- Unmount:

    sudo umount /mnt/target 2>/dev/null || true

- Remove fstab line (use editor or targeted delete with care)
- Disable swap:

    sudo swapoff /swapfile 2>/dev/null || true

- Remove swapfile:

    sudo rm -f /swapfile

Do not “wipe” disks unless the task explicitly requires it.

---

## 🧠 Operator Rule

> **Identify → Prove → Change → Verify → Persist → Prove again.**  
> Storage work is where careless operators destroy systems.

---

