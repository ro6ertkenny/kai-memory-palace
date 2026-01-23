# 🧯 Scenario 13 — System Won’t Boot / Drops to Emergency Shell (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-13-system-wont-boot.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbooks:
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

---

## 📌 Incident Brief (Symptom-First)

The system:

- fails to reach multi-user mode, or
- drops into **emergency mode**, **rescue mode**, or **dracut shell**, or
- hangs during boot waiting for a device or mount, or
- reboots in a loop

Messages include things like:

- “You are in emergency mode”
- “Dependency failed for …”
- “Timed out waiting for device …”
- “Cannot mount …”
- “Failed to start …”

Your job is to:
- **stabilize access**
- identify **what stage of boot is failing**
- classify **which subsystem is responsible**
- restore a **clean boot**
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Identify **what is blocking the boot**
- Classify the failure as:
  - storage / mount failure
  - service dependency failure
  - security / policy failure
  - configuration error
- Apply the **minimal safe fix**
- Prove:
  - the system boots cleanly
  - all critical targets are reached
  - no emergency mode remains

---

## 🧠 Operator Rule

> **Boot failures are dependency failures until proven otherwise.**  
> **Never guess. Always find the unit, mount, or device that blocked progress.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Filesystem / mount failure** (fstab, UUID, corruption)
2) **Missing or renamed device**
3) **Broken or misconfigured critical service**
4) **Security / SELinux policy blocking boot**
5) **Initramfs / early-boot failure**
6) **Configuration error** (fstab, systemd unit, kernel args)
7) **Not actually boot** (kernel panic, hardware failure)

---

## 🧪 Required Evidence (Where Did Boot Stop?)

If you are in emergency or rescue shell:

  systemctl --failed
  systemctl list-units --state=failed

Check the journal for this boot:

  journalctl -xb --no-pager

Look for:

- “dependency failed”
- “timed out waiting for”
- “cannot mount”
- “failed to start”
- “permission denied”
- “AVC”

Identify:

- **the first real failure**
- not the 20 things that failed because of it

---

## 🧩 Identify the Blocking Unit or Mount

If mounts are involved:

  systemctl status local-fs.target --no-pager || true
  mount
  lsblk -f
  blkid
  cat /etc/fstab

If services are involved:

  systemctl status <unit> --no-pager || true

If SELinux is suspected:

  getenforce
  ausearch -m avc -ts recent || true
  journalctl | rg -i "avc|selinux|denied" || true

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Filesystem / mount failure
Signals:
- errors about UUID, superblock, or mount options
- local-fs.target failed
Route:
- `storage-recovery-playbook.md`
Goal:
- fix fstab, identity, or filesystem
Proof:
- `mount -a` works
- boot proceeds past local-fs

### Fork B — Missing or renamed device
Signals:
- timeouts waiting for device
- device not present in `lsblk`
Route:
- `storage-recovery-playbook.md`
Goal:
- restore device mapping or correct fstab
Proof:
- device appears and mounts

### Fork C — Broken critical service
Signals:
- a service required by boot target is failed
Route:
- `service-recovery-playbook.md`
Goal:
- fix config or dependency
Proof:
- unit is active and boot continues

### Fork D — SELinux / policy block
Signals:
- AVC denials during boot
- service or mount blocked by policy
Route:
- `security-triage-playbook.md`
Goal:
- fix labels/booleans/minimal policy
Proof:
- boot succeeds with SELinux enforcing

### Fork E — Initramfs / early boot failure
Signals:
- failure occurs before root is mounted
- dropped into dracut or initramfs shell
Route:
- `storage-recovery-playbook.md`
Goal:
- fix root device, initramfs, or boot config
Proof:
- system reaches normal userspace

### Fork F — Configuration error
Signals:
- recent changes to fstab, units, kernel args
- boot breaks immediately after change
Route:
- appropriate playbook (storage/service/security)
Goal:
- revert or correct the change
Proof:
- boot works again

### Fork G — Not a Linux/userspace problem
Signals:
- kernel panic
- hardware I/O errors
Route:
- outside LFCS scope (but must be recognized)
Proof:
- you can explain why this is not a userspace recovery

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not reboot repeatedly without new evidence.
- Do not comment out random fstab entries.
- Do not disable SELinux blindly.
- Do not “fix” by reinstalling.

---

## 🧯 Recovery Principles

- Always:
  - identify the **first blocking dependency**
- Prefer:
  - fixing identity/configuration over destructive actions
  - minimal, reversible changes
- Use:
  - emergency shell as a **controlled repair environment**, not a panic mode

---

## ✅ Verification (Required Proof)

Before reboot:

  systemctl --failed
  mount -a

There should be:
- no failed critical units
- no mount errors

Reboot:

  reboot

After boot:

  systemctl is-system-running
  systemctl --failed
  journalctl -b -p err --no-pager

Define “healthy” as:

- reaches multi-user or graphical target
- `is-system-running` is `running` or `degraded` (with known, non-blocking reason)
- no emergency mode
- no boot-blocking failures

---

## 🧾 Post-Incident Debrief

Answer:

- Where did boot stop?
- What was the **first real failure**?
- Which bucket was this?
- What was the minimal safe fix?
- What change or condition caused this?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Treating the *last* error as the cause instead of the first
- Randomly editing fstab or units
- Disabling SELinux “to get in”
- Reinstalling instead of repairing
- Ignoring the journal

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If the root cause was storage or mounts:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`

### If the root cause was service dependencies:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If the root cause was SELinux or policy:
- Drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- strengthen “first failure” detection
- eliminate panic-driven changes
- improve whole-system dependency reasoning

---
