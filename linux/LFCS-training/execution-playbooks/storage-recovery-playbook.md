# 🗄️ Storage Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`  
**Purpose:** Restore a system to a **writable, mounted, and healthy** storage state using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- Disk is **full**
- Filesystem **won’t mount**
- System boots **read-only** or drops to **emergency**
- Wrong **UUID / device / mountpoint**
- Permissions vs mount options confusion
- Suspected filesystem inconsistency

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenario (practice input):

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

## 🧭 Global Safety Rules

- **Preserve evidence first.** Observe before changing fstab or running fsck.
- **Never fsck a mounted filesystem.**
- **Prefer smallest reversible change.**
- **Always validate with `mount -a` before reboot.**
- **Every action requires verification.**

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

## 1) Observe Current State (No Changes)

Check mounts:

    findmnt
    mount

Check disk usage:

    df -h
    df -i

Check block devices and filesystems:

    lsblk -f
    blkid

Branch:

- If **disk full** → go to **Section 2**
- If **mount missing or wrong** → go to **Section 4**
- If **filesystem read-only** → go to **Section 6**
- If **boot/emergency** → go to **Section 7**

---

## 2) Disk Full Triage

Find top consumers (start broad, then narrow):

    du -xh / | sort -h | tail -n 20

Common hotspots:

    du -xh /var | sort -h | tail -n 20
    du -xh /home | sort -h | tail -n 20

Check deleted-but-open files:

    lsof | grep deleted

Actions:

- Delete or move obviously large, unnecessary files
- Truncate runaway logs if appropriate

Then go to **Section 3**.

---

## 3) Verify Space Recovery

Re-check:

    df -h
    df -i

If space is now sufficient:

- Proceed to **Section 8** (Persistence Check)

If still full:

- Return to **Section 2** and continue investigation

---

## 4) Mount Missing or Wrong

Inspect fstab:

    cat /etc/fstab

Validate devices:

    lsblk -f
    blkid

Try manual mount:

    mount /mountpoint

Or:

    mount -a

Branch:

- If **UUID wrong / device missing** → go to **Section 5**
- If **mount works manually** → go to **Section 8**
- If **filesystem error** → go to **Section 9**

---

## 5) Fix /etc/fstab

Edit:

    vi /etc/fstab

Rules:

- Do not guess device names
- Prefer UUIDs
- Ensure filesystem type and options are correct

Validate without reboot:

    mount -a

If no errors:

- Go to **Section 8**

If errors:

- Re-check device names, UUIDs, filesystem types

---

## 6) Filesystem Is Read-Only

Check:

    mount | grep " ro,"

Check kernel messages:

    dmesg | tail -n 50

Likely causes:

- I/O error
- Filesystem inconsistency

Proceed to **Section 9**.

---

## 7) Emergency / Recovery Mode

Identify current root and devices:

    lsblk
    mount

Inspect fstab:

    cat /etc/fstab

Common causes:

- Bad UUID
- Wrong filesystem type
- Missing device

Fix fstab or comment out the bad line.

Attempt recovery:

    mount -o remount,rw /
    mount -a

Then:

- Exit recovery shell or reboot

---

## 8) Persistence Check

Confirm:

    findmnt
    df -h

Validate fstab:

    mount -a

If allowed and safe, test reboot:

    systemctl reboot

After reboot:

    findmnt
    df -h

---

## 9) Filesystem Check and Repair

WARNING: Only run fsck on **unmounted** filesystems.

Identify device:

    lsblk

Unmount:

    umount /mountpoint

Run check:

    fsck /dev/sdXN

If clean or repaired:

    mount /mountpoint

Return to **Section 8**.

---

## 🔁 Rollback Strategy

If an fstab edit breaks boot:

- Boot to recovery
- Comment offending line
- Validate:

    mount -a

Restore from backup if available:

    cp /etc/fstab.bak /etc/fstab

Re-test:

    mount -a

---

## ✅ Completion Criteria

- Filesystem is **mounted**
- Filesystem is **writable**
- `df -h` and `findmnt` look correct
- `mount -a` produces **no errors**
- Survives reboot (if tested)

You can explain:

- What failed
- Why it failed
- Why your fix was safe
- How you verified recovery

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

---
