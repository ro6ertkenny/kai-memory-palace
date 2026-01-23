# 🧪 Execution Drills — Index (LFCS)

**Path:** `linux/LFCS-training/execution-drills/`

Mental mode: **Muscle memory and execution speed**  
Purpose: This directory contains **procedural, execution-first drills** for the Linux Foundation Certified System Administrator (LFCS) exam.

If a task can be solved by:

> **Typing the right commands in the right order**

…it belongs here.

This is **not** a tutorial set.  
This is **not** a theory set.  
This is a **do-it-from-memory training surface**.

---

## 🧠 What These Drills Are

Each file is:

- A **repeatable lab**
- A **command execution checklist**
- A **speed + correctness drill**
- Focused on **what to type**, not long explanations
- Designed to make **basic operations automatic**

These drills are the **mechanical skill layer** under:

- Building Blocks (training gates)
- Execution Playbooks (domain algorithms)
- Failure Scenarios (diagnosis training)

---

## 🧭 How to Use This Directory

### The rule

- **Type the commands**
- Do **not** copy/paste
- If something breaks:
  - Fix it
  - Understand why
  - Continue
- Reset and repeat until it’s automatic

### The workflow

1) Pick one file  
2) Run every section **top to bottom**  
3) Type everything  
4) Verify results  
5) Reset the lab if needed  
6) Repeat until you no longer hesitate

### Study modes

- **Daily reps:** 1–2 files end-to-end
- **Weakness targeting:** Only drill what you’re slow at
- **Mock exam:** Randomly pick 3 files and do them cold

---

## 🗂️ Files in This Directory

---

### 1) essential-commands.md

Scope:
- Core shell survival
- File operations
- Search, permissions, links
- Redirection, inspection, basic system interaction

LFCS domains:
- Essential Commands

Use this when:
- You want **zero hesitation** in the shell

---

### 2) files-and-text.md

Scope:
- Text processing
- Searching, filtering, comparing
- grep, sed, awk
- Archives and compression

LFCS domains:
- Essential Commands

Use this when:
- You want to be **dangerous with text and output streams**

---

### 3) users-and-permissions.md

Scope:
- Users and groups
- Password aging
- sudo
- Ownership and permissions
- ACLs

LFCS domains:
- User and Group Management

Use this when:
- You want **zero confusion** about identity and access

---

### 4) processes-logs-and-scheduling.md

Scope:
- Process inspection and control
- Load, memory, CPU analysis
- Signals and priorities
- Cron and systemd timers
- Basic scheduling effects

LFCS domains:
- Operation of Running Systems

Use this when:
- You want to **see what the system is actually doing**

---

### 5) services-and-logging.md

Scope:
- systemd service control
- Start/stop/restart/enable/disable
- Targets and boot behavior
- Logs and journalctl

LFCS domains:
- Operation of Running Systems

Use this when:
- You want to **control and inspect services under pressure**

---

### 6) service-configuration.md

Scope:
- Editing and validating service configs
- SSH server/client
- DNS resolver / zones
- Web server basics
- Proxies, access restrictions, logging
- Database service basics

LFCS domains:
- Service Configuration

Use this when:
- You want to **change service behavior safely and predictably**

---

### 7) storage-and-mounts.md

Scope:
- Block devices, partitions, filesystems
- Mounting and fstab
- Swap
- Loop devices
- LVM, RAID, LUKS
- Quotas
- autofs

LFCS domains:
- Storage Management

Use this when:
- You want to **build, inspect, and reason about storage**

---

### 8) package-management.md

Scope:
- Installing and removing packages
- Querying package ownership
- Repairing broken package state
- Locks, dependencies, interrupted installs

LFCS domains:
- Operation of Running Systems

Use this when:
- You want **total trust in system package state**

---

### 9) networking.md

Scope:
- Interfaces, addresses, routes
- DNS testing
- Firewall inspection
- Listeners and ports
- Time sync (chrony / timesyncd)
- SSH connectivity

LFCS domains:
- Networking

Use this when:
- You want to **prove exactly where connectivity breaks**

---

### 10) security-and-selinux.md

Scope:
- Permission audits
- ACL audits
- sudo policy
- SELinux / AppArmor modes, contexts, denials
- Recovery from security lockouts

LFCS domains:
- Operation of Running Systems
- Security across domains

Use this when:
- You want to **prove why access is denied and fix it correctly**

---

### 11) ssl-certificates.md

Scope:
- Inspecting certificates
- Validity, expiration, subjects
- Key/cert matching
- Chain validation

LFCS domains:
- Service Configuration
- Security-related tasks

Use this when:
- You want **zero mystery around TLS breakage**

---

### 12) containers-and-virtualization.md

Scope:
- Running and inspecting containers
- Logs, exec, exit codes
- Volumes and networking
- Resource limits
- Host visibility

LFCS domains:
- Service Configuration

Use this when:
- You want **containers to feel like normal Linux processes**

---

### 13) git.md

Scope:
- Inspecting repo state
- Commits, history, branches
- Revert vs reset
- Reflog recovery
- File restore

LFCS domains:
- Essential Commands
- Real-world operational workflows

Use this when:
- You want **Git to be a safety system, not a risk**

---

## 🧪 Relationship to Failure Scenarios

Execution drills answer:

> “What do I type to perform a task?”

Failure scenarios answer:

> “What do I do when the system is broken?”

- **Execution drills** = mechanical skill  
- **Failure scenarios** = diagnosis + recovery  
- **Execution playbooks** = domain algorithms

You need **all three**.

---

## 🎯 Completion Criteria for This Directory

You are “ready” here when:

- You can run **any file cold**
- You rarely look things up
- You don’t hesitate at the shell
- You immediately know **which drill to practice** when weak

---

## 🧠 Final Rule

> **These drills are about eliminating thinking time for basic operations.**  
> Save your thinking time for diagnosis and playbook selection.

