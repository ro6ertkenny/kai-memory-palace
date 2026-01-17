# 🗺️ LFCS Practice Questions — Index

Mental mode: **Exam navigation and training orchestration**.  
Purpose: This file is the **map** of the LFCS practice area inside kai-memory-palace. It explains **what exists**, **why it exists**, and **how to use it** to pass the Linux Foundation Certified System Administrator (LFCS) exam.

This is not content.  
This is **structure and intent**.

---

## 🎯 What This Area Is

`linux/LFCS-practice-questions/` is a **complete, hands-on training system** for LFCS.

It is built around two complementary skill surfaces:

1) **Execution** — Can you perform tasks quickly and correctly?
2) **Diagnosis** — Can you fix a broken system and prove it’s healthy?

LFCS tests **both**.

---

## 🧱 The Two Training Surfaces

### 1) Execution Drills (`execution-drills/`)

Mental mode: **Muscle memory and speed**

This directory contains **procedural checklists** you run repeatedly until actions are automatic.

They answer:

> “What do I type to accomplish this task?”

Coverage includes:

- Essential commands
- Files and text processing
- Storage and mounts (including LVM, RAID, LUKS, quotas, autofs)
- Networking (including packet filtering and time sync)
- Users and permissions (including ACLs)
- Services and logging
- Service configuration (DNS, web, proxy, mail, DB, SSH)
- Containers and virtualization
- Security and SELinux

Entry point:

    execution-drills/index.md

---

### 2) Failure Scenarios (`failure-scenarios/`)

Mental mode: **Diagnosis, recovery, and proof**

This directory contains **incident-style scenarios** that start from symptoms and force you to reason your way to a fix.

They answer:

> “The system is broken. What do I do now?”

Scenarios include:

- System feels slow
- Disk is full
- Service is down
- Process won’t die
- CPU is pegged
- Memory pressure / OOM

Entry point:

    failure-scenarios/index.md

---

## 🗺️ How This Maps to the LFCS Domains

LFCS exam domains include:

- Essential Commands
- Operation of Running Systems
- User and Group Management
- Networking
- Service Configuration
- Storage Management

Mapping strategy:

- **Execution drills** cover: building, configuring, operating
- **Failure scenarios** cover: diagnosing, recovering, proving

Together, they simulate **real exam conditions**.

---

## 🏃 How to Train

### Daily execution reps

- Pick **one execution drill file**
- Run it top-to-bottom
- **Type commands** (no copy/paste)
- Fix what breaks
- Repeat until it’s boring

### Diagnostic reps

- Pick **one failure scenario**
- Start from the symptom
- Always:
  - Measure first
  - Form a hypothesis
  - Fix
  - Prove

### Mock exam mode

- Randomly select:
  - 2 execution drill files
  - 1 failure scenario
- Do them **cold and timed**

---

## ✅ Readiness Criteria

You are ready for the exam when:

- You can run **any execution drill cold**
- You never panic at a broken system
- You always start by **measuring, not guessing**
- You can explain **why** a fix works
- You rarely need to look things up

---

## 🧱 Design Rules of This Area

- One file = one training surface
- No diaries
- No notes
- No fluff
- Everything here is **executable skill**

---

## 📁 Directory Map

    LFCS-practice-questions/
    ├── index.md
    ├── README.md
    ├── guiding-principles.md
    ├── execution-drills/
    │   └── index.md
    └── failure-scenarios/
        └── index.md

---

## 🧭 Relationship to the Rest of kai-memory-palace

This area is:

- A **capstone practice arena**
- Fed by:
  - linux/
  - shell-and-bash/
  - troubleshooting/
  - storage/
  - networking/
  - services/
- But focused purely on **exam execution and recovery**

---
