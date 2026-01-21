# 🧪 Execution Drills — Index (LFCS)

Mental mode: **Muscle memory and speed**.  
Purpose: This directory contains **procedural, execution-first drills** for the Linux Foundation Certified System Administrator (LFCS) exam.

If a task can be solved by **typing the right commands in the right order**, it belongs here.

This is not a tutorial set.  
This is a **do-it-from-memory** training surface.

---

## 🧠 How to Use This Directory

### The rule

Each file is:

- A **checklist of actions**
- A **repeatable lab**
- A **time-pressure drill**
- Focused on **what to type**, not long explanations

### The workflow

1) Pick one file
2) Run every section **from top to bottom**
3) Do not copy/paste — **type the commands**
4) When something breaks, fix it
5) Reset the lab (if needed)
6) Repeat until it’s automatic

### Study modes

- **Daily reps**: Pick 1–2 files and run them end-to-end
- **Weakness targeting**: Only drill the file you’re slow at
- **Mock exam**: Randomly pick 3 files and do them cold

---

## 🗂️ Files in This Directory

### 1) essential-commands.md

Scope:
- Core shell survival skills
- File operations
- Search, permissions, links
- Redirection, inspection, and basic system interaction

LFCS domains covered:
- Essential Commands

Use this when:
- You want **zero hesitation** on everyday Linux operations

---

### 2) files-and-text.md

Scope:
- Text processing
- Searching, filtering, comparing
- sed, grep, awk patterns
- Archives and compression

LFCS domains covered:
- Essential Commands

Use this when:
- You want to be **dangerous with text streams and files**

---

### 3) storage-and-mounts.md

Scope:
- Partitions and filesystems
- Mounting, fstab, swap
- Loop devices
- Filesystem repair
- **LVM, RAID, LUKS encryption**
- **Filesystem quotas**
- **autofs (automount)**

LFCS domains covered:
- Storage Management

Use this when:
- You want to be able to **build, fix, and recover storage from scratch**

---

### 4) networking.md

Scope:
- Interface inspection and configuration
- DNS testing
- Routing
- Firewalling and **packet filtering**
- Packet capture
- Network services
- **Time synchronization (NTP / timesyncd / chrony)**
- SSH and emergency recovery

LFCS domains covered:
- Networking

Use this when:
- You want to be able to **prove exactly where connectivity is broken**

---

### 5) users-and-permissions.md

Scope:
- Users and groups
- Password aging and policies
- Sudo and privilege control
- Ownership and permissions
- **ACLs (Access Control Lists)**

LFCS domains covered:
- User and Group Management

Use this when:
- You want **zero confusion** about who can do what on the system

---

### 6) services-and-logging.md

Scope:
- systemd service control
- Enable/disable/mask services
- Targets and boot behavior
- Logs (journalctl and log files)
- Scheduling and service diagnostics

LFCS domains covered:
- Operation of Running Systems

Use this when:
- You want to **control and diagnose services under pressure**

---

### 7) service-configuration.md

Scope:
- **SSH server/client**
- **Caching DNS resolver**
- **DNS zone management**
- **Email aliases**
- **HTTP proxy restrictions**
- **HTTP server log configuration**
- **Restricting access to web pages**
- **Database server basics**
- Tie-in to containers and virtualization

LFCS domains covered:
- Service Configuration

Use this when:
- You want to **stand up real services and prove they work**

---

### 8) containers-and-virtualization.md

Scope:
- Images and containers
- Running, inspecting, exec, logs
- Networking and storage for containers
- Resource limits
- Building images
- Host virtualization awareness

LFCS domains covered:
- Service Configuration

Use this when:
- You want **zero fear** of container tasks on the exam

---

### 9) security-and-selinux.md

Scope:
- System security inspection
- File permission audits
- ACL audits
- Firewall exposure checks
- sudo policy
- **SELinux / AppArmor modes, contexts, denials**
- Recovery from security lockouts

LFCS domains covered:
- Operation of Running Systems
- Security-relevant tasks across domains

Use this when:
- You want to **prove why access is denied and fix it correctly**

---

## 🧭 Relationship to Failure Scenarios

Execution drills answer:

> “What do I type to perform a task?”

Failure scenarios answer:

> “What do I do when the system is broken?”

Both are required for LFCS.

- **Execution drills** = build speed and confidence  
- **Failure scenarios** = build diagnosis and recovery skill  

Do both.

---

## 🎯 Completion Criteria for This Directory

You are “ready” with execution drills when:

- You can run **any file cold**
- You rarely look things up
- You don’t panic when something fails
- You know **which file to practice** when you’re weak in an area

---
