# 🗄️ Storage Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`  
Mental mode: **Measure → Classify → Stabilize → Repair → Verify → Persist**  
Purpose: Restore a system to a **writable, mounted, and healthy** storage state using a **safe, exam-grade operator algorithm**.

This is **not** a tutorial.  
This is a **live-system decision and recovery playbook**.

---

## 🧠 When To Use This Playbook

Use this playbook when:

- A filesystem is **full**
- A filesystem **won’t mount**
- The system boots **read-only** or drops to **emergency mode**
- A mount fails due to **wrong UUID / device / fs type**
- There is **suspected filesystem corruption**
- Services fail because paths are missing

Do **not** use this playbook if the **first evidence** points to:

- a process runaway or D-state backlog → `process-control-playbook.md`
- a pure service lifecycle failure → `service-recovery-playbook.md`
- SELinux or policy root cause → `security-triage-playbook.md`
- network or DNS root cause → `network-diagnosis-playbook.md`

---

## 🧭 Scenarios That Validate This Playbook

This playbook is exercised by:

- `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md`
- `linux/LFCS-training/failure-scenarios/scenario-12-filesystem-wont-mount.md`
- `linux/LFCS-training/failure-scenarios/scenario-13-system-wont-boot.md`

If you cannot solve those scenarios **cleanly and repeatably**, this playbook is not yet fluent.

---

## 🧪 Drills Required For Fluency

You should be mechanically fluent with:

- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md` (for boot and dependency fallout)

This playbook is a **composition layer**, not a source of primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1. Measure
2. Identify
3. Classify
4. Stabilize
5. Repair
6. Verify
7. Make persistent
8. Roll back if needed

> **Never start with `fsck` or editing `/etc/fstab` blindly.**

---

## 🧭 Global Safety Rules

- Preserve evidence first.
- **Never fsck a mounted filesystem.**
- Prefer smallest reversible change.
- Always validate with `mount -a` before reboot.
- Every action requires verification.

---

## 🧭 Classification Buckets (Pick One Before Acting)

You must place the incident into **exactly one** bucket:

1) Disk or inode exhaustion  
2) Mount identity failure (UUID / device / fstab)  
3) Filesystem corruption or I/O error  
4) Read-only remount due to error  
5) Boot / emergency-mode mount failure  
6) Not actually a storage problem (exit this playbook)

---

## 🧪 Phase 1 — Observe Current State (No Changes)

Check mounts:

  findmnt  
  mount  

Check space:

  df -h  
  df -i  

Check devices and filesystems:

  lsblk -f  
  blkid  

If boot/emergency related:

  systemctl status local-fs.target --no-pager || true  
  journalctl -xb --no-pager | rg -i "mount|uuid|superblock|failed" || true  

Decision gate:

- If disk/inodes are full → Bucket 1  
- If mount missing or wrong → Bucket 2  
- If read-only or I/O errors → Bucket 3 or 4  
- If boot blocked → Bucket 5  
- If mounts are fine → exit this playbook

---

## 🧪 Phase 2 — Route Selection

### Route A — Disk or inode exhaustion (Bucket 1)

Find top consumers (broad first, then narrow):

  du -xh / | sort -h | tail -n 20  
  du -xh /var | sort -h | tail -n 20  
  du -xh /home | sort -h | tail -n 20  

Check deleted-but-open files:

  lsof | grep deleted || true  

Stabilize:

- Remove or move clearly safe, large data
- Truncate runaway logs if appropriate

Then verify:

  df -h  
  df -i  

If still full → continue investigation  
If recovered → go to **Phase 6**

---

### Route B — Mount identity failure (Bucket 2)

Inspect:

  cat /etc/fstab  
  lsblk -f  
  blkid  

Test manually:

  mount -v /mountpoint || true  
  mount -a || true  

If UUID/device/fs type is wrong:

- Edit fstab (do not guess)
- Prefer UUIDs
- Fix fs type or options

Validate:

  mount -a  

If clean → go to **Phase 6**

---

### Route C — Filesystem corruption or I/O error (Bucket 3)

Signals:

- superblock errors
- I/O errors
- forced read-only remount

Rules:

> **Never fsck a mounted filesystem.**

Procedure:

  lsblk  
  umount /mountpoint  
  fsck /dev/XXX  

If repaired or clean:

  mount /mountpoint  

Then → **Phase 6**

If cannot unmount (busy) → may need single-user or emergency mode

---

### Route D — Read-only remount (Bucket 4)

Confirm:

  mount | grep " ro,"  
  dmesg | tail -n 50  

Treat as:

- I/O error or corruption → Route C

---

### Route E — Boot / emergency-mode mount failure (Bucket 5)

Inspect:

  lsblk  
  mount  
  cat /etc/fstab  

Fix:

- wrong UUID
- wrong fs type
- missing device
- bad options

Test:

  mount -o remount,rw / || true  
  mount -a  

If boot dependencies are involved → may also need `service-recovery-playbook.md`

---

## 🧯 Phase 3 — Stabilization Principles

- Prefer:
  - identity fixes over destructive actions
  - unmount + repair over reformat
- Never:
  - reformat “to make it mount”
  - comment out fstab entries blindly
  - guess device names

---

## 🧪 Phase 4 — Verification Gate

Required proof:

  findmnt  
  df -h  
  mount -a  

If boot-related:

  systemctl status local-fs.target --no-pager  

There must be:

- no mount failures
- no read-only surprises
- no missing critical paths

---

## 🧪 Phase 5 — Persistence Check

If safe and allowed:

  reboot  

After reboot:

  findmnt  
  df -h  
  systemctl --failed  

---

## 🔁 Rollback Strategy

If an fstab edit breaks things:

- Boot to recovery
- Restore backup:

  cp /etc/fstab.bak /etc/fstab  

- Validate:

  mount -a  

---

## 🚫 Anti-Patterns (Auto-Fail)

- Running fsck on mounted filesystems
- Reformatting instead of repairing
- Guessing device names
- Editing fstab before checking devices
- Rebooting without `mount -a` validation

---

## 🧭 Exit Conditions

Exit this playbook if you discover:

- process storm or D-state backlog → `process-control-playbook.md`
- service dependency chain failure → `service-recovery-playbook.md`
- SELinux/policy block → `security-triage-playbook.md`
- network or DNS root cause → `network-diagnosis-playbook.md`

---

## ✅ Completion Criteria

- Filesystems are **mounted**
- Filesystems are **writable**
- `df -h` and `findmnt` are correct
- `mount -a` produces **no errors**
- System survives reboot (if tested)

You can explain:

- What failed
- Why it failed
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Operator Loop (Reinforced)

Symptom → Measure → Classify → Stabilize → Repair → Verify → Persist

Never skip identity checks.

---
