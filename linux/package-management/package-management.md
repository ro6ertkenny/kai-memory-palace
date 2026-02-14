# 📦 Package Management
## Maintaining a predictable system state (Debian-based)

Mental mode: Controlling what is installed, why it is installed, and when it changes.

This document defines **package discipline** for Debian-based systems.
Uncontrolled package changes are a primary source of instability.

This wing is **standardized on `apt-get`**.

Note: You may still see `apt` in labs/exam-style material. Treat it as an alternate frontend; your primary muscle memory remains `apt-get`.

---

## Purpose
You should be able to answer, without guessing:
- What packages are installed?
- Where did this binary come from?
- Why did an upgrade change behavior?
- How do I update safely?
- How do I clean up without breaking the system?

---

## Package Management Rules

Hard rules:
- Prefer `apt-get` for predictable, script-stable behavior
- Inspect before installing
- Upgrade deliberately
- Clean regularly
- Do not mix package managers (for the same system state)

Predictability matters more than convenience.

---

## Updating Package Metadata

Refresh package lists:

    sudo apt-get update

This does not install or upgrade anything.
It only updates metadata.

Run this before:
- installs
- upgrades
- troubleshooting missing packages

---

## Searching for Packages (LFCS/KodeKloud)

Search by keyword (primary):

    apt-cache search <keyword>

Show detailed package metadata:

    apt-cache show <package>

Show repository/priority and candidate version:

    apt-cache policy <package>

Also seen in labs/exam environments (apt frontend):

    apt search <keyword>

Mental model:
- search finds names/descriptions
- show explains what it is
- policy explains which version you will get and from where

---

## Installing Packages

Install a package:

    sudo apt-get install <package>

Install without prompts:

    sudo apt-get install -y <package>

Install multiple packages:

    sudo apt-get install <pkg1> <pkg2> <pkg3>

Always read what will be installed or removed before confirming.

---

## Inspecting Packages (Installed State)

Check if a package is installed:

    dpkg -l | grep <package>

Better exact match (reduces false hits):

    dpkg -l | awk '$2=="<package>" {print}'

Show available versions (source/candidate):

    apt-cache policy <package>

Knowing the version explains behavior changes.

---

## Listing Files Provided by a Package (LFCS/KodeKloud)

List all files installed by a package:

    dpkg --listfiles <package>

Short form:

    dpkg -L <package>

Use this when you need to know:
- where config files landed
- where binaries are installed
- what the package actually shipped

---

## Finding Which Package Owns a File (LFCS/KodeKloud)

Which package owns a path:

    dpkg --search /path/to/file

Short form:

    dpkg -S /path/to/file

Where a binary came from:

    command -v <binary>
    dpkg -S "$(command -v <binary>)"

This resolves “where did this come from?”

---

## Removing Packages

Remove package only (keep config files):

    sudo apt-get remove <package>

Remove package and config files:

    sudo apt-get purge <package>

Mental model:
- remove removes binaries
- purge also removes configs under /etc (where applicable)

---

## Autoremove and Cleanup (LFCS/KodeKloud)

Remove unused dependencies:

    sudo apt-get autoremove

Remove unused dependencies while removing a package (common lab/exam pattern):

    sudo apt-get remove --auto-remove <package>

Clean downloaded package cache:

    sudo apt-get clean

Systems accumulate debris over time.
Cleanup is maintenance, not optimization.

---

## Upgrading Packages

Upgrade installed packages (no dependency removals/additions beyond required):

    sudo apt-get upgrade

Full upgrade (handles dependency changes, may add/remove packages):

    sudo apt-get dist-upgrade

Mental model:
- upgrade is conservative
- dist-upgrade resolves dependency graph changes

Never upgrade blindly on production systems.
Inspect what will change.

---

## Holding Packages

Prevent a package from upgrading:

    sudo apt-mark hold <package>

Release hold:

    sudo apt-mark unhold <package>

Critical for:
- kernel
- container runtime
- kubelet
- kubeadm

Verify holds:

    apt-mark showhold

---

## Where Packages Live (Mental Map)

Binaries:
- /usr/bin
- /usr/sbin

Libraries:
- /usr/lib

Configuration:
- /etc

Package ownership explains file origin.

---

## Common Failure Patterns

- Package installed but binary missing (PATH or wrong package)
- Binary exists but wrong version (candidate vs installed)
- Config file persists after removal (remove vs purge)
- Upgrade changed defaults (version shift or config merge)

Always inspect package state first.

---

## 🔧 Operator workflow (LFCS execution)

### “I need a tool” (safe install flow)

1) Refresh metadata:

    sudo apt-get update

2) Find package name:

    apt-cache search <keyword>

3) Inspect what it is / versions:

    apt-cache show <package>
    apt-cache policy <package>

4) Install:

    sudo apt-get install <package>

5) Verify binary + ownership:

    command -v <binary>
    dpkg -S "$(command -v <binary>)"

### “What owns this file / port helper binary?”

1) Identify path:

    command -v <binary>

2) Owner package:

    dpkg -S "$(command -v <binary>)"

3) List files:

    dpkg -L <package>

### “Clean safely”

    sudo apt-get autoremove
    sudo apt-get clean

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/package-search-install-remove.md`
- `linux/LFCS-training/execution-drills/dpkg-search-and-listfiles.md`

---

## 🪝 Exam memory hook

Four questions, four commands:

- What’s available?        apt-cache search
- What version will I get? apt-cache policy
- Who owns this file?      dpkg -S
- What files are in it?    dpkg -L

Primary muscle memory:

    sudo apt-get update
    sudo apt-get install <pkg>
    sudo apt-get remove --auto-remove <pkg>

