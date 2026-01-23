# 🧯 Failure Scenarios — Index (LFCS)

**Path:** `linux/LFCS-training/failure-scenarios/index.md`  
Mental mode: **Diagnosis, recovery, and proof**.  
Purpose: This directory contains **scenario-driven incident simulations** that train you to **reason under pressure**, not just type commands.

If the system is already broken and you must **figure out why and fix it**, it belongs here.

This is not a tutorial set.  
This is a **simulate → diagnose → fix → verify** training surface.

---

## 🧠 Where This Fits in the LFCS Training System

The LFCS training system has **four layers**:

1) **Building Blocks** — mental models, invariants, gates  
2) **Execution Drills** — muscle memory and command fluency  
3) **Execution Playbooks** — operator algorithms and decision flow  
4) **Failure Scenarios** — **integration + pressure testing** (this directory)

In other words:

- **Drills** teach you how to type
- **Playbooks** teach you how to think and route problems
- **Scenarios** test whether you can do both under stress

Failure scenarios are **not** about new commands.  
They are about **correct diagnosis, correct playbook choice, and clean recovery**.

---

## 🧠 How to Use This Directory

### The rule

Each scenario:

- Starts from a **symptom**
- Forces you to **gather evidence**
- Requires you to **classify the failure**
- Requires you to **choose the correct playbook**
- Then **execute a recovery**
- And finally **prove the system is healthy**

You should **not** jump to the fix.

### The workflow

1) Read the scenario
2) Reproduce or imagine the broken state
3) Inspect:
   - CPU
   - Memory
   - Disk
   - Processes
   - Services
   - Logs
4) Decide **what class of failure this is**
5) Choose the **correct execution playbook**
6) Execute recovery
7) Prove the system is fixed
8) Be able to explain **what signal led you to the correct classification**

### Study modes

- **Cold start**: Pick one scenario at random and solve it without notes
- **Timed**: Give yourself 15–20 minutes per scenario
- **Root cause training**: Focus on *why* you knew what to check first

---

## 🗂️ Scenarios in This Directory

### 1) scenario-1-system-feels-slow.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

---

### 2) scenario-2-disk-is-full.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

---

### 3) scenario-3-service-is-down.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

Secondary playbooks:
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`

---

### 4) scenario-4-process-wont-die.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

---

### 5) scenario-5-cpu-pegged.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

---

### 6) scenario-6-memory-pressure.md

Primary playbook:
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

Secondary playbook:
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

---

## 🐳 Container & Runtime Scenarios

### 14) scenario-14-container-runtime-down.md

Symptom focus:
- `docker` / `podman` commands fail
- Runtime service is not running
- No containers can start

Primary playbook:
- `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`

Secondary playbook:
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

---

### 15) scenario-15-container-networking-broken.md

Symptom focus:
- Containers run but **ports are not reachable**
- `-p 8080:80` does not work
- Networking or firewall breaks access

Primary playbook:
- `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`

Secondary playbook:
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`

---

### 16) scenario-16-image-pull-fails.md

Symptom focus:
- `docker pull` / `podman pull` fails
- DNS, routing, or registry access problems

Primary playbook:
- `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`

Secondary playbook:
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`

---

## 🧭 Relationship to Drills and Playbooks

- **Execution drills** answer:
  “What do I type to perform a task?”

- **Execution playbooks** answer:
  “What algorithm do I follow to recover this class of failure?”

- **Failure scenarios** answer:
  “Can I recognize the failure, choose the right playbook, and fix it under pressure?”

All three are required.

---

## 🎯 Completion Criteria for This Directory

You are “ready” with failure scenarios when:

- You never panic at a broken system
- You always start by **measuring, not guessing**
- You can classify the failure **before** touching anything
- You choose the correct playbook quickly
- You can recover the system and **prove it’s healthy**
- You can explain **why** your diagnostic path was correct

---

## 🧠 Core Operator Rule

> **Stabilize → Identify → Execute → Verify → Persist → Rollback if needed.**  
> **Never skip classification.**

