# 🧭 Execution Playbooks — Index (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/index.md`  
Mental mode: **Route fast → Run the right algorithm → Verify hard**  
Purpose: Provide a **fast operator navigation surface** for the LFCS **playbook layer**.

This directory contains **exam-style operator playbooks** that compose:

- `linux/LFCS-training/execution-drills/` (muscle memory layer)
- `linux/LFCS-training/failure-scenarios/` (integration & practice cases)

Execution playbooks are the **algorithm layer**:

> measure → classify → correct → verify → persist → rollback

---

## 🧠 Where This Fits in the LFCS Training System

The LFCS system is intentionally built in **four layers**:

1) **Building Blocks** — mental models, invariants, gates  
2) **Execution Drills** — muscle memory and command fluency  
   - See: `linux/LFCS-training/execution-drills/README.md`
3) **Execution Playbooks** — **decision and flow-control algorithms** (this directory)
4) **Failure Scenarios** — exam-style break/fix integration tests

In other words:

- **Drills** teach you how to execute mechanics  
- **Playbooks** teach you how to route, decide, and recover safely  
- **Scenarios** test whether you can do both under pressure  

---

## 📘 Playbooks vs Runbooks (Important Distinction)

These files are **playbooks, not runbooks**.

- **Playbook** = strategic, diagnostic, flow-control algorithm  
  - Chooses what to do next
  - Routes between domains
  - Enforces safe order of operations
  - Always includes verification and rollback logic

- **Runbook** = tactical, step-by-step procedure for one specific task  
  - (e.g., exact steps to rotate a cert, exact steps to rebuild initramfs)

This repository emphasizes:

- Playbooks = how to decide and recover  
- Drills = how to execute mechanics  

If ultra-tactical runbooks are added later, **playbooks will call them** — not replace them.

---

## ✅ Playbooks

### 🧩 Core Operator Surfaces (Primary Incident Classes)

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/account-access-playbook.md`
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

### 🔐 Integrity and Trust (Control Plane Failures)

- `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`

### 🌱 Workflow & Runtime Recovery (Local Tooling / Containers)

- `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`

---

## 🧭 Symptom → Playbook Router

Use this when the prompt is vague.

- “Service down / fails to start” → `service-recovery-playbook.md`
- “Running but unreachable” → start `network-diagnosis-playbook.md`, then `service-recovery-playbook.md`
- “Disk full / read-only / won’t mount / emergency mode / boot broken” → `storage-recovery-playbook.md`
- “CPU pegged / memory pressure / process stuck / system slow” → `process-control-playbook.md`
- “Permission denied / works as root only / SELinux AVC” → `security-triage-playbook.md`
- “TLS cert expired / handshake fails / key mismatch” → `tls-triage-playbook.md`
- “apt/dnf broken / locks / half-installed / deps” → `package-repair-playbook.md`
- “User can’t login / sudo broken / SSH auth fails” → `account-access-playbook.md`
- “Git state wrong / detached HEAD / undo commit” → `git-recovery-playbook.md`
- “Containers fail / runtime broken / image pull issues” → `container-runtime-triage-playbook.md`

---

## 🧠 How to Use This Layer (Training Procedure)

Recommended order for a given incident class:

1) Run the relevant **execution drill surface(s)** until mechanics are automatic  
2) Run the relevant **execution playbook** end-to-end as a timed operator algorithm  
3) Run the relevant **failure scenario(s)** as a timed break/fix exercise

Operator objective:

- Use playbooks as **decision trees**, not reading material
- Execute, verify, and persist safely
- Avoid domain-hopping and random fixes

---

## 🔁 Failure Scenario → Playbook Map (Coverage Audit)

This map ensures every failure scenario has a corresponding operator algorithm.

### Scenario 1 — Slow system

- `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 2 — Disk full

- `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md`
  - Primary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 3 — Service down

- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`
  - Primary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`

### Scenario 4 — Process won’t die

- `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

### Scenario 5 — CPU pegged

- `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

### Scenario 6 — Memory pressure

- `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

### Scenario 7 — Can’t SSH / lost access

- `linux/LFCS-training/failure-scenarios/scenario-7-cant-ssh-lost-access.md`
  - Primary: `linux/LFCS-training/execution-playbooks/account-access-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 8 — DNS resolution failing

- `linux/LFCS-training/failure-scenarios/scenario-8-dns-resolution-failing.md`
  - Primary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 9 — Package manager broken

- `linux/LFCS-training/failure-scenarios/scenario-9-package-manager-broken.md`
  - Primary: `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

### Scenario 10 — TLS failures

- `linux/LFCS-training/failure-scenarios/scenario-10-tls-certificate-failure.md`
  - Primary: `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`

### Scenario 11 — SELinux denial breaks service

- `linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md`
  - Primary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 12 — Filesystem won’t mount

- `linux/LFCS-training/failure-scenarios/scenario-12-filesystem-wont-mount.md`
  - Primary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

### Scenario 13 — System won’t boot

- `linux/LFCS-training/failure-scenarios/scenario-13-system-wont-boot.md`
  - Primary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`

---

## 🐳 Container & Runtime Scenarios

### Scenario 14 — Container runtime down

- `linux/LFCS-training/failure-scenarios/scenario-14-container-runtime-down.md`
  - Primary: `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

### Scenario 15 — Container networking broken

- `linux/LFCS-training/failure-scenarios/scenario-15-container-networking-broken.md`
  - Primary: `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`

### Scenario 16 — Image pull fails

- `linux/LFCS-training/failure-scenarios/scenario-16-image-pull-fails.md`
  - Primary: `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`

---

## 🧠 Core Operator Rule

> **Stabilize → Identify → Execute → Verify → Persist → Rollback if needed.**  
> **Never skip classification.**

