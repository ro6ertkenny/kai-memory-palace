# 🗂️ Filesystems & Storage — README

## 🎯 Purpose
Build **operational clarity** around how Linux stores, exposes, and protects data.

This directory exists to make filesystem behavior:
- predictable
- inspectable
- fixable

Most Linux failures reduce to **paths, ownership, permissions, or storage state**.

---

## 🧠 Mental Mode
**Controlling access to data**

- know where data lives
- know who owns it
- know who can act on it
- know why access succeeds or fails
- know how filesystems are attached and detached at runtime

If you understand the filesystem, you can recover from most system issues.

---

## 🧭 Scope
This domain focuses on **filesystem fundamentals that affect daily operations**.

Included:
- filesystem hierarchy and paths
- ownership and permissions
- directory semantics
- execute bit behavior
- diagnosing access failures
- safe corrective actions
- mounting and unmounting filesystems
- bind mounts and namespace grafting
- /etc/fstab and persistent mounts
- fsck and offline recovery basics

Excluded:
- advanced filesystem internals
- performance tuning
- storage hardware specifics
- kernel-level VFS theory

If it does not explain *why a command can or cannot access data*,  
or *why data is or is not visible at a path*,  
it does not belong here.

---

## 📁 Directory Layout

### `filesystems-and-storage/README.md`
This file.
- defines scope
- sets mental model
- explains how to use this domain

---

### `filesystems-and-storage/filesystem-and-perms.md`
Core operational guide.

Covers:
- absolute vs relative paths
- ownership evaluation order
- permission bits
- directory behavior
- execute bit
- sudo boundaries
- diagnosing permission failures

This is the **primary reference** for filesystem-related access errors.

---

### Runtime & Recovery (Day 7)

This wing also covers **how filesystems are attached to the live system** and how to recover them safely:

- `mounting-and-unmounting.md`
  - the live mount tree
  - loop mounts
  - “target is busy”
  - lazy unmount
  - why Linux is a tree of mountpoints

- `bind-mounts-and-namespace-grafting.md`
  - making one directory appear at another path
  - stacked mounts
  - namespace composition

- `fstab-and-persistent-mounts.md`
  - /etc/fstab as the boot-time mount plan
  - UUIDs
  - pass and dump fields
  - verifying before reboot

- `fsck-and-recovery-basics.md`
  - what fsck is
  - why it must not run on mounted filesystems
  - offline consistency checking

- `filesystem-debugging-checklist.md`
  - systematic workflow for storage problems

These documents explain **why data sometimes “disappears”, why paths change meaning, and how to recover safely**.

---

## 🧪 How to Use This Domain
Use this directory when:
- a command fails unexpectedly
- something works with sudo but not without it
- a file exists but cannot be accessed
- permissions feel confusing
- ownership changes are required
- data is “missing” or a path does not show what you expect
- a mount or unmount fails
- a system dropped into recovery because of storage

Start with inspection, not action.

---

## 🔎 Diagnostic First Principle
Before fixing anything, you should be able to answer:
- which user is acting
- which path is being resolved
- who owns the target
- what permissions apply
- what filesystem is mounted there (if any)

If you cannot answer those, you are not ready to change state.

---

## ⚠️ Operational Guardrails
- avoid recursive permission changes
- prefer fixing ownership over loosening permissions
- never use broad permissions as a shortcut
- inspect parent directories, not just the target
- never run fsck on a mounted filesystem

Filesystem mistakes propagate quickly.

---

## ✅ Outcome
You should be able to say:

I know why access failed.  
I know what the filesystem state is.  
I know what is mounted where and why.  
And I know exactly how to fix it.

That is filesystem fluency.

