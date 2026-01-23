# 🧯 Scenario 9 — Package Manager Is Locked or Broken (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-9-package-manager-broken.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md` (if another process is holding locks)
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if repos are unreachable)
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if disk/log pressure is involved)

---

## 📌 Incident Brief (Symptom-First)

You try to install or update packages:

- `apt-get` / `apt` / `dnf` / `yum` fails
- You see errors like:
  - “Could not get lock”
  - “Another process is using the package manager”
  - “Database is locked”
  - “RPM database is corrupted”
  - “Transaction failed”
  - “Failed to fetch …”

You **need packages** to fix something else.

Your job is to:
- classify **what kind of package manager failure this is**
- fix it **without making it worse**
- restore package operations
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- State **which failure class** this is:
  - active lock
  - stale lock
  - crashed transaction
  - database corruption
  - repo / network failure
- Apply the **minimal safe repair**
- Successfully run:
  - `apt-get update` / `dnf makecache`
  - and one install or upgrade
- Prove:
  - no locks remain
  - the package DB is consistent
  - normal operations work again

---

## 🧠 Operator Rule

> **Never delete lock files before you know who owns them.**  
> **Never force the database before you know its state.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Another package process is legitimately running**
2) **Stale lock file from a crashed process**
3) **Broken or interrupted transaction**
4) **Corrupted package database**
5) **Repository / network failure**
6) **Disk full / inode exhaustion breaking package ops**

---

## 🧪 Required Evidence (Is Someone Actually Using It?)

First check for active users:

  ps aux | rg -E "apt|dpkg|dnf|yum|rpm"

If something is running:

- Identify:
  - PID
  - command
  - how long it has been running
- Decide:
  - is this legitimate (auto-updater)?
  - or is it wedged?

If a real process owns the lock → **this is not a stale lock**.

---

## 🧪 Inspect Locks and State

For Debian/Ubuntu style:

  ls -l /var/lib/dpkg/lock*
  ls -l /var/lib/apt/lists/lock || true
  ls -l /var/cache/apt/archives/lock || true

For RPM systems:

  ls -l /var/lib/rpm/__db* || true

Do **not** delete anything yet.

---

## 🧩 Check Disk and Inodes (Common Hidden Cause)

  df -h
  df -i

If disk or inodes are full:

- This is **not** a package-manager-first incident.
- Route to:
  - `storage-recovery-playbook.md`

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Another package process is running
Signals:
- real apt/dnf/rpm process in `ps`
Route:
- `process-control-playbook.md`
Goal:
- decide whether to wait or safely stop it
Proof:
- only one package process remains
- lock clears naturally

### Fork B — Stale lock file
Signals:
- no package process running
- lock file exists
Route:
- `package-repair-playbook.md`
Goal:
- remove **only after** confirming no owner
Proof:
- package manager starts

### Fork C — Broken transaction
Signals:
- errors about “run dpkg --configure -a” or similar
- transaction left half-finished
Route:
- `package-repair-playbook.md`
Goal:
- complete or cleanly roll back transaction
Proof:
- normal install/update works again

### Fork D — Database corruption
Signals:
- rpm or dpkg reports DB corruption
- repeated failures even after cleanup
Route:
- `package-repair-playbook.md`
Goal:
- rebuild DB safely
Proof:
- queries and installs work

### Fork E — Repo or network failure
Signals:
- errors are fetch / mirror / name resolution related
Route:
- `network-diagnosis-playbook.md`
Proof:
- after network fix, package ops succeed

### Fork F — Disk/inode exhaustion
Signals:
- df shows full
- errors writing package DB
Route:
- `storage-recovery-playbook.md`
Proof:
- after space recovery, package ops succeed

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not delete lock files without checking for owners.
- Do not reboot “to fix apt”.
- Do not rebuild DB unless you know it is corrupted.
- Do not mix package tools (apt + dpkg, yum + rpm) blindly.

---

## 🧯 Recovery Principles

- Always:
  - identify the owner of locks
  - restore consistency before installing anything new
- Prefer:
  - finishing or cleanly repairing state
  - not brute-forcing around it

---

## ✅ Verification (Required Proof)

After repair:

  apt-get update || true
  dnf makecache || true

Then:

  apt-get install <small-known-package> || true
  dnf install <small-known-package> || true

Also verify:

- no package locks remain
- no DB errors appear

---

## 🧾 Post-Incident Debrief

Answer:

- Which failure bucket was this?
- What evidence proved it?
- What repair path did you use?
- What would have made it worse?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Deleting locks without checking owners
- Rebooting as the “fix”
- Rebuilding DB when it’s not corrupted
- Ignoring disk-full signals
- Treating network errors as package DB errors

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misidentified the lock owner or state:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-4-process-model.md`

### If you struggled with repair flows:
- Drill:
  - `linux/LFCS-training/execution-drills/package-management.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If the root cause was storage or network:
- Drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
  - `linux/LFCS-training/execution-drills/networking.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- prevent destructive “just delete the lock” reflexes
- improve state-based repair discipline
- strengthen root-cause routing

---
