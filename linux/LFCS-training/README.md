# 🧪 LFCS Practice Questions — kai-memory-palace

This directory is a **purpose-built training environment** for the  
**Linux Foundation Certified System Administrator (LFCS)** exam.

It is not a collection of notes.  
It is a **hands-on, execution-and-diagnosis training system**.

---

## 🧠 Training Philosophy

LFCS does not test:

- Memorization
- Trivia
- Multiple choice knowledge

LFCS tests:

- Can you **do the work**
- Can you **fix a broken system**
- Can you **prove the system is healthy again**

Accordingly, this directory is split into **two complementary training modes**:

---

## 🧱 1) Execution Drills (`execution-drills/`)

Mental mode: **Muscle memory and speed**

These are:

- Step-by-step **procedural drills**
- Focused on **what to type**
- Designed to be repeated until actions are automatic

They answer the question:

> “What commands do I run to perform this task?”

Examples of what you train here:

- Storage (mounts, fstab, LVM, RAID, LUKS, quotas, autofs)
- Networking (IP, routing, firewall, packet filtering, time sync)
- Users and permissions (users, groups, ACLs, sudo)
- Services and logs (systemd, journalctl, boot behavior)
- Service configuration (DNS, web, proxy, mail, DB, SSH)
- Containers and virtualization
- Security and SELinux

Entry point:

    execution-drills/index.md

---

## 🧯 2) Failure Scenarios (`failure-scenarios/`)

Mental mode: **Diagnosis, recovery, and proof**

These are:

- Scenario-driven **incident response drills**
- Focused on **what to check first and why**
- Designed to train **calm, methodical troubleshooting**

They answer the question:

> “The system is broken. What do I do now?”

Examples of what you train here:

- System feels slow
- Disk is full
- Service is down
- Process won’t die
- CPU is pegged
- Memory pressure / OOM

Entry point:

    failure-scenarios/index.md

---

## 🗺️ How This Maps to the LFCS Exam

LFCS domains include:

- Essential Commands
- Operation of Running Systems
- User and Group Management
- Networking
- Service Configuration
- Storage Management

This directory covers **all of them** via:

- Execution drills → how to build and configure
- Failure scenarios → how to diagnose and recover

Together, they simulate **real exam conditions**.

---

## 🏃 How to Use This Directory

### Daily training

- Pick **one execution drill file**
- Run it top to bottom **by typing commands**
- Do not copy/paste

### Diagnostic training

- Pick **one failure scenario**
- Solve it **without jumping to the fix**
- Always:
  - Inspect
  - Hypothesize
  - Fix
  - Prove

### Mock exam mode

- Randomly choose:
  - 2 execution drills
  - 1 failure scenario
- Do them cold and timed

---

## 🎯 When You Are Ready for the Exam

You are ready when:

- You can run **any execution drill cold**
- You never panic at broken systems
- You always start by **measuring, not guessing**
- You can explain **why** a fix works
- You rarely need to look anything up

---

## 🧱 Design Principles

- One file = one training surface
- No diaries
- No notes
- No fluff
- Everything here is **executable skill**

---

## 📁 Directory Structure

    LFCS-training/
    ├── execution-drills/
    │   └── index.md
    ├── failure-scenarios/
    │   └── index.md
    ├── guiding-principles.md
    └── README.md

---
