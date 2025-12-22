# 🐧 Linux Wing — README

## 🎯 Purpose
Build **operational fluency** with Linux.

This wing exists to make the system feel **controllable**, predictable, and observable — not mysterious.

Linux is not studied here.  
Linux is **operated**.

---

## 🧠 Mental Mode
**Controlling the system**

- observe state
- issue commands deliberately
- verify results immediately

You should feel in command, not exploratory.

---

## 🧩 Relationship to Other Wings
This wing sits between Vim and Kubernetes.

Mental stack:
- **Vim** → the hands (editing without thinking)
- **Bash** → the interface (issuing intent)
- **Linux** → the system (what actually changes)
- **Kubernetes** → orchestrated systems at scale

If Linux feels fuzzy, Kubernetes will feel fragile.

---

## 🧭 Scope
This wing focuses on **daily, durable Linux skills** needed for:
- servers
- containers
- Kubernetes nodes
- exams (LFCS, CKA)

Included:
- Bash usage and pipelines
- filesystem and permissions
- processes and services
- networking basics
- system inspection
- package management
- recovery from common mistakes

Excluded:
- distro history
- kernel internals
- desktop tooling
- GUI workflows
- advanced scripting theory

If it doesn’t help you operate a Linux system today, it doesn’t belong here.

---

## 🧰 Bash Lives Here (Explicitly)
Bash is the **primary control surface** for Linux.

This wing treats Bash as:
- how commands are issued
- how output is shaped
- how systems are inspected
- how tasks are chained

Bash is not separate from Linux.  
It is how Linux is used.

---

## 📁 Wing Layout

### `linux/README.md`
This file.
- scope
- mental model
- file map
- practice discipline

---

### `linux/bash/`
Bash-specific operational fluency.

Files in this directory train:
- issuing commands correctly
- chaining commands
- controlling execution
- understanding shell behavior

---

### `linux/filesystem-and-perms.md`
Working with:
- directories and files
- ownership
- permissions
- safe modification

---

### `linux/processes-and-services.md`
Understanding:
- running processes
- signals
- services
- system state over time

---

### `linux/networking-basics.md`
Core networking visibility:
- interfaces
- ports
- connections
- name resolution

This ties directly into the Kubernetes networking wing.

---

### `linux/system-inspection.md`
Seeing what the system is doing:
- disk
- memory
- CPU
- load
- logs (at the system level)

---

### `linux/package-management.md`
Managing software intentionally:
- installing
- upgrading
- removing
- verifying

This wing standardizes on apt-based systems.

---

### `linux/mistakes.md`
Fast recovery from common Linux errors:
- permissions issues
- wrong paths
- runaway commands
- broken assumptions

This file stays short.

---

## ⏱️ Practice Discipline
Practice mirrors the Vim wing.

- short sessions (20–30 minutes)
- real system interaction
- no copy/paste habits
- verify every command

Commands are not memorized.  
They are **used**.

---

## 🧪 Operating Rule
If you cannot explain:
- what a command will do
- what it will output
- what state it will change

You should not run it yet.

---

## ✅ Outcome
Linux becomes predictable.

You issue commands.  
The system responds.  
You verify and move on.
