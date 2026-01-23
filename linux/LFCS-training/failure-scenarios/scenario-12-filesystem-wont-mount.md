# 🧯 Scenario 12 — Filesystem Won’t Mount / Wrong UUID (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-12-filesystem-wont-mount.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if boot or dependent services are blocked)
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if policy blocks access)

---

## 📌 Incident Brief (Symptom-First)

One or more filesystems:

- fail to mount at boot, or
- fail to mount when you run `mount -a`, or
- leave the system in emergency mode, or
- cause services to fail because paths are missing

You see messages like:

- “wrong fs type, bad option, bad superblock”
- “special device UUID=… does not exist”
- “dependency failed for /path”
- “you are in emergency mode”

Your job is to:
- identify **what mount failed and why**
- classify **whether this is identity, device, or filesystem damage**
- restore mounts **safely**
- bring the system back to a healthy state
- prove it is stable

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Identify **which mount(s)** failed
- State **why**:
  - wrong UUID / LABEL
  - missing device
  - filesystem corruption
  - wrong fs type or options
  - policy or permission block
- Apply the **minimal safe fix**
- Prove:
  - mounts succeed
  - dependent services start
  - the system boots or runs cleanly

---

## 🧠 Operator Rule

> **Never “fix” fstab blindly. Always prove what device exists and what it is.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Wrong UUID/LABEL in `/etc/fstab`**
2) **Device missing or renamed** (disk not present, device path changed)
3) **Wrong filesystem type or mount options**
4) **Filesystem corruption**
5) **Permission / policy block**
6) **Not a storage problem** (dependency or ordering issue)

---

## 🧪 Required Evidence (What Failed?)

If at boot or after `mount -a`:

  systemctl status local-fs.target --no-pager || true
  journalctl -b --no-pager | rg -i "mount|failed|dependency|uuid|superblock" || true

List configured mounts:

  cat /etc/fstab

List actual block devices:

  lsblk -f
  blkid

Interpretation anchors:

- Does the **UUID/LABEL in fstab** exist in `blkid`?
- Does the **device** exist in `lsblk`?
- Does the **fs type** match what the device actually is?

---

## 🧩 Test the Mount Manually (Safely)

For the failing entry:

  mount -v /mount/point || true

Or:

  mount -v UUID=... /mount/point || true

Read the **exact** error message.

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Wrong UUID/LABEL
Signals:
- fstab references a UUID/LABEL not present in `blkid`
Route:
- `storage-recovery-playbook.md`
Goal:
- correct fstab to the real device identity
Proof:
- `mount -a` succeeds

### Fork B — Device missing or renamed
Signals:
- device does not appear in `lsblk`
- disk or partition not present
Route:
- `storage-recovery-playbook.md`
Goal:
- restore device, rescan bus, or fix mapping
Proof:
- device appears and mounts

### Fork C — Wrong fs type or options
Signals:
- error: “wrong fs type” or option-related failures
Route:
- `storage-recovery-playbook.md`
Goal:
- correct fs type or mount options
Proof:
- mount succeeds with correct type/options

### Fork D — Filesystem corruption
Signals:
- errors about superblock or metadata
Route:
- `storage-recovery-playbook.md`
Goal:
- repair filesystem safely
Proof:
- filesystem mounts cleanly

### Fork E — Permission / policy block
Signals:
- AVC or permission denied messages
Route:
- `security-triage-playbook.md`
Goal:
- fix policy or permissions
Proof:
- mount works with policy still enforced

### Fork F — Not actually storage
Signals:
- mount is fine manually
- failure is ordering or dependency
Route:
- `service-recovery-playbook.md`
Goal:
- fix unit dependencies or ordering
Proof:
- boot and mounts complete cleanly

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not comment out fstab entries blindly.
- Do not reformat a filesystem “to make it mount”.
- Do not run repair tools on the wrong device.
- Do not reboot repeatedly without new evidence.

---

## 🧯 Recovery Principles

- Always:
  - verify device identity (`lsblk`, `blkid`)
  - verify fstab against reality
- Prefer:
  - identity fixes over destructive actions
  - minimal edits to fstab
  - non-destructive fs checks first

---

## ✅ Verification (Required Proof)

- All mounts succeed:

  mount -a

- No mount failures:

  systemctl status local-fs.target --no-pager

- Devices look correct:

  lsblk -f

- Dependent services start normally.

If boot-related, perform a clean reboot and confirm:

- no emergency mode
- no mount errors in journal

---

## 🧾 Post-Incident Debrief

Answer:

- Which mount failed?
- Which bucket was this?
- What evidence proved it?
- What was the minimal safe fix?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Editing fstab without checking devices
- Reformatting instead of repairing
- Assuming device names are stable
- Ignoring journal errors
- Treating boot failures as “random”

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misread device identity or fstab:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-10-storage-fundamentals.md`

### If you struggled with filesystem repair logic:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`

### If this was actually a boot or dependency issue:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- improve identity-first storage debugging
- prevent destructive “format-first” instincts
- strengthen boot-time failure diagnosis

---
