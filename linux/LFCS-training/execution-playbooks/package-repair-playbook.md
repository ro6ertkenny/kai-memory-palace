# 📦 Package Repair Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`  
**Purpose:** Restore a **working, consistent package manager and installed software set** using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- Package manager is **broken or locked**
- Install/remove/update operations **fail or hang**
- Packages are **half-installed / inconsistent**
- A required binary is **missing or corrupted**
- Repository configuration is **broken**

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/package-management.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- `linux/LFCS-training/failure-scenarios/scenario-9-package-manager-broken.md` (primary)
- `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md` (secondary, when failures are caused by no space / read-only fs)
- `linux/LFCS-training/failure-scenarios/scenario-12-filesystem-wont-mount.md` (secondary, when root or var is not mounted correctly)

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe the failure mode**
2. **Stabilize the package system**
3. **Identify the specific break**
4. **Correct minimally**
5. **Verify**
6. **Make persistent**
7. **Rollback if needed**

Never start by deleting random package databases.

---

## 🧭 Global Safety Rules

- **Read the exact error message first.**
- **Never delete package database directories.**
- **Prefer repair commands before removals.**
- **Never remove core system packages blindly.**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Distro family:
  - Debian/Ubuntu → apt / dpkg
  - RHEL/Fedora → dnf / rpm
- Exact error message
- Operation that fails (install, remove, update)

---

## 1) Observe Failure Mode

Attempt a safe operation:

    apt-get update
    dnf makecache

Or reproduce the failing action:

    apt-get install <pkg>
    dnf install <pkg>

Classify the error:

- Lock error
- Dependency error
- Broken / half-installed packages
- Repo/config error
- Missing or corrupt binary

If the filesystem is read-only or full, **exit this playbook** and go to:

- `storage-recovery-playbook.md`

---

## 2) Lock File / Stuck Process

Check for running package processes:

    ps aux | grep -E "apt|dpkg|dnf|rpm"

If a real package process is running:

- **Do nothing. Wait.**

If no real process is running but locks exist:

For apt/dpkg:

    ls -l /var/lib/dpkg/lock*
    ls -l /var/lib/apt/lists/lock
    ls -l /var/cache/apt/archives/lock

For dnf:

    ls -l /var/run/dnf.pid

Only if **no process is running**:

    rm -f /var/lib/dpkg/lock*
    rm -f /var/lib/apt/lists/lock
    rm -f /var/cache/apt/archives/lock
    rm -f /var/run/dnf.pid

Return to **Section 1**.

---

## 3) Broken / Half-Installed Packages

For apt/dpkg:

    dpkg --configure -a
    apt-get -f install

Re-test:

    apt-get update

If still failing, list broken packages:

    dpkg -l | grep -E "^..r|^..iF|^..iU"

Then (only if safe):

    apt-get remove <pkg>
    apt-get install <pkg>

Return to **Section 1**.

---

## 4) Dependency Resolution Failures

For apt:

    apt-get -f install

For dnf:

    dnf check
    dnf distro-sync

If a specific package is blocking progress:

- Remove it (only if you understand impact):

    apt-get remove <pkg>
    dnf remove <pkg>

Then retry the original operation.

Return to **Section 1**.

---

## 5) Repository / Configuration Errors

Inspect repo config:

For apt:

    ls -l /etc/apt/sources.list
    ls -l /etc/apt/sources.list.d/
    cat /etc/apt/sources.list
    cat /etc/apt/sources.list.d/*

For dnf:

    ls -l /etc/yum.repos.d/
    cat /etc/yum.repos.d/*.repo

Look for:

- Typos
- Wrong distro version
- Dead mirrors

Temporarily disable a suspect repo (move file aside or comment lines).

Then:

    apt-get update
    dnf makecache

Return to **Section 1**.

---

## 6) Missing or Corrupt Binary

Check:

    which <binary>
    ls -l <binary>

Find owning package:

    dpkg -S <binary>
    rpm -qf <binary>

Reinstall:

    apt-get install --reinstall <package>
    dnf reinstall <package>

Verify:

    <binary> --version

---

## 7) Package Database Corruption (Last Resort)

For rpm/dnf:

    rpm --rebuilddb

For apt/dpkg:

- Usually resolved by:

    dpkg --configure -a
    apt-get -f install

Then retry normal operations.

---

## 8) Verification

Confirm normal operation:

    apt-get update
    apt-get install <known-good-package>

Or:

    dnf makecache
    dnf install <known-good-package>

Ensure no errors appear.

---

## 9) Persistence Check

Ensure:

- Repo files are correct
- No temporary repos remain disabled unintentionally
- No lock files remain
- Package manager works across multiple operations

---

## 🔁 Rollback Strategy

If a repo change caused breakage:

- Restore original repo file
- Re-run:

    apt-get update
    dnf makecache

If a package removal broke a service:

- Reinstall the package
- Use `service-recovery-playbook.md` if needed

---

## ✅ Completion Criteria

- Package manager runs without errors
- Can install and remove packages
- No broken or half-installed packages remain
- No stale locks exist

You can explain:

- What broke
- Why it broke
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Never delete package database directories
- Never remove core packages blindly
- Always read the error message
- Prefer repair commands before removal
- Verify with a real install

---

## 🧱 This Playbook Composes From

- package-management.md
- files-and-text.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
