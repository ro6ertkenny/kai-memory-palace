# 📦 Package Management
## Maintaining a predictable system state

Mental mode: Controlling what is installed, why it is installed, and when it changes.

This document defines **package discipline** for Debian-based systems.
Uncontrolled package changes are a primary source of instability.

This wing is **standardized on `apt-get`**.

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
- Use `apt-get`, not `apt`
- Inspect before installing
- Upgrade deliberately
- Clean regularly
- Never mix package managers

Predictability matters more than convenience.

---

## Updating Package Metadata

Refresh package lists:
apt-get update

This does not install or upgrade anything.
It only updates metadata.

Run this before:
- installs
- upgrades
- troubleshooting missing packages

---

## Installing Packages

Install a package:
apt-get install <package>

Install without prompts:
apt-get install -y <package>

Install multiple packages:
apt-get install <pkg1> <pkg2> <pkg3>

Always read what will be installed or removed before confirming.

---

## Inspecting Packages

Check if a package is installed:
dpkg -l | grep <package>

Show package details:
apt-cache show <package>

Show available versions:
apt-cache policy <package>

Knowing the version explains behavior changes.

---

## Removing Packages

Remove package only:
apt-get remove <package>

Remove package and config files:
apt-get purge <package>

Removing binaries does not always remove configuration.

---

## Autoremove and Cleanup

Remove unused dependencies:
apt-get autoremove

Clean downloaded package cache:
apt-get clean

Systems accumulate debris over time.
Cleanup is maintenance, not optimization.

---

## Upgrading Packages

Upgrade installed packages:
apt-get upgrade

Full upgrade (handles dependency changes):
apt-get dist-upgrade

Never upgrade blindly on production systems.
Inspect what will change.

---

## Holding Packages

Prevent a package from upgrading:
apt-mark hold <package>

Release hold:
apt-mark unhold <package>

Critical for:
- kernel
- container runtime
- kubelet
- kubeadm

---

## Where Packages Live

Binaries:
- /usr/bin
- /usr/sbin

Libraries:
- /usr/lib

Configuration:
- /etc

Package ownership explains file origin.

---

## Finding a Package for a File

Which package owns a file:
dpkg -S /path/to/file

Where a binary came from:
which <binary>
dpkg -S $(which <binary>)

This resolves “where did this come from?”

---

## Common Failure Patterns

- Package installed but binary missing
- Binary exists but wrong version
- Config file persists after removal
- Upgrade changed defaults

Always inspect package state first.

---

## Practice

Run:
apt-cache policy bash
dpkg -l | grep bash

Explain:
- installed version
- candidate version
- origin repository

If you can explain that, you control package state.

---

## Outcome

You should be able to say:

I know what software is installed,  
I know where it came from,  
and I know how to change it safely.

That is package discipline.
