# 🗄️ Storage Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`  
**Purpose:** Restore a system to a **writable, mounted, and healthy** storage state using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- Disk is **full**
- Filesystem **won’t mount**
- System boots **read-only** or drops to **emergency**
- Wrong **UUID / device / mountpoint**
- Permissions vs mount options confusion
- Suspected filesystem inconsistency

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- `linux/LFCS-training/failure-scenarios/scenario-b-disk-is-full.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe**
2. **Identify**
3. **Diagnose**
4. **Stabilize**
5. **Correct**
6. **Verify**
7. **Make persistent**
8. **Rollback if needed**

Never start with `fsck` or editing `/etc/fstab` blindly.

---

## 0) Inputs

You must know or determine:

- Affected path or mountpoint (e.g. `/`, `/var`, `/home`, `/data`)
- Symptoms:
  - Full?
  - Not mounted?
  - Read-only?
  - Boot failure?

---

## 1) Observe Current State

Check mounts:

    findmnt
    mount

Check disk usage:

    df -h
    df -i

Check block devices:

    lsblk -f

Branch:

- If **disk full** → go to **Section 2**
- If **mount missing or wrong** → go to **Section 4**
- If **filesystem read-only** → go to **Section 6**
- If **boot/emergency** → go to **Section 7**

---

## 2) Disk Full Triage

Find top consumers:

    du -xh / | sort -h | tail -n 20

Or more focused:

    du -xh /var | sort -h | tail -n 20

Check deleted-but-open files:

    lsof | grep deleted

Branch:

- If **obvious large files** → delete/move → go to **Section 3**
- If **logs exploded** → truncate → go to **Section 3**
- If **mystery usage** → continue inspection

---

## 3) Verify Space Recovery

Re-check:

    df -h
    df -i

If space OK:

- End incident

If still full:

- Return to **Section 2**

---

## 4) Mount Missing or Wrong

Check fstab:

    cat /etc/fstab

Validate devices:

    lsblk -f
    blkid

Try manual mount:

    mount /mountpoint

If fails, try:

    mount -a

Branch:

- If **UUID wrong / device missing** → fix fstab → go to **Section 5**
- If **mount works manually** → go to **Section 8**
- If **fs error** → go to **Section 9**

---

## 5) Fix /etc/fstab

Edit:

    vi /etc/fstab

Validate without reboot:

    mount -a

If no errors:

- Go to **Section 8**

If errors:

- Re-check device names, UUIDs, filesystem types

---

## 6) Filesystem Read-Only

Check:

    mount | grep " ro,"

Check dmesg:

    dmesg | tail -n 50

Likely causes:

- I/O error
- Filesystem inconsistency

Proceed to **Section 9**

---

## 7) Emergency / Recovery Mode

Identify root:

    lsblk
    mount

Check fstab:

    cat /etc/fstab

Common causes:

- Bad UUID
- Bad fs type
- Missing device

Fix fstab or comment bad line, then:

    mount -o remount,rw /
    mount -a

Then:

- Exit shell / reboot

---

## 8) Persistence Check

Confirm:

    findmnt
    df -h

Ensure mounts survive reboot:

    mount -a

If allowed:

    systemctl reboot

After reboot:

    findmnt
    df -h

---

## 9) Filesystem Check and Repair

WARNING: Only run fsck on **unmounted** filesystems.

Find device:

    lsblk

Unmount:

    umount /mountpoint

Run check:

    fsck /dev/sdXN

Then:

    mount /mountpoint

Return to **Section 8**

---

## 🔁 Rollback Strategy

If fstab edit breaks boot:

- Boot to recovery
- Comment offending line
- Re-run:

    mount -a

Restore from backup if available:

    cp /etc/fstab.bak /etc/fstab

---

## ✅ Completion Criteria

- Filesystem is **mounted**
- Filesystem is **writable**
- `df -h` and `findmnt` look correct
- `mount -a` produces **no errors**
- Survives reboot (if tested)

---

## 🧠 Exam Safety Rules

- Never fsck a mounted filesystem
- Never guess device names
- Always validate with `mount -a`
- Prefer UUIDs in fstab
- Always verify before reboot

---

## 🧱 This Playbook Composes From

- storage-and-mounts.md
- files-and-text.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

