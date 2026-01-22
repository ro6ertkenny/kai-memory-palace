# 📦 Package Repair Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`  
**Purpose:** Restore a **working, consistent package manager and installed software set** using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- Package manager is **broken or locked**
- Install/remove operations **fail or hang**
- Packages are **half-installed / inconsistent**
- A required binary is **missing or corrupted**
- Repository configuration is **broken**

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/package-management.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- (Future) package-manager-broken / dependency-failure scenario

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

## 0) Inputs

You must know or determine:

- Distro family (apt/dpkg or dnf/rpm)
- Exact error message
- Operation that fails (install, remove, update)

---

## 1) Observe Failure Mode

Attempt a safe operation:

    apt-get update
    dnf makecache

Or reproduce failure:

    apt-get install <pkg>
    dnf install <pkg>

Classify:

- Lock error
- Dependency error
- Broken/half-installed packages
- Repo/config error
- Missing/corrupt binary

---

## 2) Lock File / Stuck Process

Check for running package processes:

    ps aux | grep -E "apt|dpkg|dnf|rpm"

If a package process is legitimately running:

- Wait for it.

If no real process but lock exists:

    ls -l /var/lib/dpkg/lock*
    ls -l /var/lib/apt/lists/lock
    ls -l /var/cache/apt/archives/lock

For dnf:

    ls -l /var/run/dnf.pid

Only if no process is running:

    rm -f /var/lib/dpkg/lock*
    rm -f /var/lib/apt/lists/lock
    rm -f /var/cache/apt/archives/lock
    rm -f /var/run/dnf.pid

Then return to **Section 1**.

---

## 3) Broken / Half-Installed Packages

For apt/dpkg:

    dpkg --configure -a
    apt-get -f install

Re-test:

    apt-get update

If still failing:

- Identify broken packages:

    dpkg -l | grep -E "^..r|^..iF|^..iU"

Then:

    apt-get remove <pkg>
    apt-get install <pkg>

Return to **Section 1**.

---

## 4) Dependency Resolution Failures

Attempt repair:

    apt-get -f install

For dnf:

    dnf check
    dnf distro-sync

If a specific package is blocking progress:

- Remove it (if safe):

    apt-get remove <pkg>
    dnf remove <pkg>

Then retry install or update.

---

## 5) Repository / Configuration Errors

Check repo files:

For apt:

    ls -l /etc/apt/sources.list
    ls -l /etc/apt/sources.list.d/

For dnf:

    ls -l /etc/yum.repos.d/

Inspect for obvious mistakes:

    cat /etc/apt/sources.list
    cat /etc/yum.repos.d/*.repo

Temporarily disable a suspect repo:

- Move file aside or comment lines

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

    apt-get --reinstall install <package>
    dnf reinstall <package>

Verify:

    <binary> --version

---

## 7) Package Database Corruption (Last Resort)

For rpm/dnf:

    rpm --rebuilddb

For apt/dpkg:

- Usually resolved via:

    dpkg --configure -a
    apt-get -f install

Then retry normal operations.

---

## 8) Verification

Confirm:

    apt-get update
    apt-get install <known-good-package>

Or:

    dnf install <known-good-package>

Confirm no errors.

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

- Reinstall package
- Use service recovery playbook if needed

---

## ✅ Completion Criteria

- Package manager runs without errors
- Can install and remove packages
- No broken or half-installed packages remain
- No stale locks exist

---

## 🧠 Exam Safety Rules

- Never delete package DB directories
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
