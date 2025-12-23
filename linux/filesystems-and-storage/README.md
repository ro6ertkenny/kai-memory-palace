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

Excluded:
- advanced filesystems internals
- performance tuning
- storage hardware specifics
- kernel-level VFS theory

If it does not explain *why a command can or cannot access data*, it does not belong here.

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

This is the **primary reference** for filesystem-related errors.

---

## 🧪 How to Use This Domain
Use this directory when:
- a command fails unexpectedly
- something works with sudo but not without it
- a file exists but cannot be accessed
- permissions feel confusing
- ownership changes are required

Start with inspection, not action.

---

## 🔎 Diagnostic First Principle
Before fixing anything, you should be able to answer:
- which user is acting
- which path is being resolved
- who owns the target
- what permissions apply

If you cannot answer those, you are not ready to change state.

---

## ⚠️ Operational Guardrails
- avoid recursive permission changes
- prefer fixing ownership over loosening permissions
- never use broad permissions as a shortcut
- inspect parent directories, not just the target

Filesystem mistakes propagate quickly.

---

## ✅ Outcome
You should be able to say:

I know why access failed,  
I know what the filesystem state is,  
and I know exactly how to fix it.

That is filesystem fluency.
