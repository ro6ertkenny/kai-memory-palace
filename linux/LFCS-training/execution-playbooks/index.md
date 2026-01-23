# 🧭 Execution Playbooks — Index (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/index.md`  
**Purpose:** Provide a **fast operator navigation surface** for the LFCS **playbook layer**.

This directory contains **exam-style operator playbooks** that compose:

- `linux/LFCS-training/execution-drills/` (muscle memory layer)
- `linux/LFCS-training/failure-scenarios/` (integration & practice cases)

Execution playbooks are the **algorithm layer**:

> observe → isolate → decide → correct → verify → persist → rollback

---

## 🧠 Where This Fits in the LFCS Training System

The LFCS system is intentionally built in **four layers**:

1) **Building Blocks** — mental models, invariants, gates  
2) **Execution Drills** — muscle memory and command fluency  
   - See: `linux/LFCS-training/execution-drills/README.md`
3) **Execution Playbooks** — **decision and flow-control algorithms** (this directory)
4) **Failure Scenarios** — exam-style break/fix integration tests

In other words:

- **Drills** teach you *how to type*  
- **Playbooks** teach you *how to think and route problems*  
- **Scenarios** test whether you can do both under pressure  

---

## 📘 Playbooks vs Runbooks (Important Distinction)

These files are **playbooks, not runbooks**.

- **Playbook** = strategic, diagnostic, flow-control algorithm  
  - Chooses *what to do next*
  - Routes between domains
  - Enforces safe order of operations
  - Always includes verification and rollback logic

- **Runbook** = tactical, step-by-step procedure for **one specific task**  
  - (e.g., “exact steps to rotate a cert”, “exact steps to rebuild initramfs”)

This repository currently emphasizes:

> ✅ Playbooks = **how to decide and recover**  
> ✅ Drills = **how to execute mechanics**  

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

### 🌱 Workflow Recovery (Local Tooling State)

- `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`

---

## 🧭 Symptom → Playbook Router

Use this when the prompt is vague.

- “Service down / fails to start” → `service-recovery-playbook.md`
- “Running but unreachable” → start `network-diagnosis-playbook.md`, then `service-recovery-playbook.md`
- “Disk full / read-only / won’t mount / emergency mode” → `storage-recovery-playbook.md`
- “CPU pegged / memory pressure / process stuck” → `process-control-playbook.md`
- “Permission denied / works as root only / SELinux AVC” → `security-triage-playbook.md`
- “TLS cert expired / handshake fails / key mismatch” → `tls-triage-playbook.md`
- “apt/dnf broken / locks / half-installed / deps” → `package-repair-playbook.md`
- “User can’t login / sudo broken / SSH auth fails” → `account-access-playbook.md`
- “Git state wrong / detached HEAD / undo commit” → `git-recovery-playbook.md`

---

## 🧠 How to Use This Layer (Training Procedure)

Recommended order for a given incident class:

1) Run the relevant **execution drill surface(s)** until mechanics are automatic  
2) Run the relevant **execution playbook** end-to-end as a timed operator algorithm  
3) Run the relevant **failure scenario(s)** as a timed break/fix exercise

Operator objective:

- Use playbooks as **decision trees**, not as “reading material”
- Execute, verify, and persist safely
- Avoid domain-hopping and “try random fixes” behavior

---

## 🔁 Failure Scenario → Playbook Map (Coverage Audit)

This map ensures every existing failure scenario has a corresponding operator algorithm.

### Existing failure scenarios

- `linux/LFCS-training/failure-scenarios/scenario-1-system-feels-slow.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if I/O or disk pressure signals appear)
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if a specific service is the offender)

- `linux/LFCS-training/failure-scenarios/scenario-2-disk-is-full.md`
  - Primary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if service fails due to disk/log growth)

- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`
  - Primary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if “down” is actually reachability)
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if permissions/SELinux block startup)

- `linux/LFCS-training/failure-scenarios/scenario-4-process-wont-die.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

- `linux/LFCS-training/failure-scenarios/scenario-5-cpu-pegged.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

- `linux/LFCS-training/failure-scenarios/scenario-6-memory-pressure.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if swap/disk I/O contributes to pressure)

---

## 🧪 Gap Notes (Optional Backlog for Future Scenarios)

No new scenarios are required to proceed, but adding these later improves coverage validation:

- SSH / sudo / locked account failure → `account-access-playbook.md`
- DNS broken / routing misconfig → `network-diagnosis-playbook.md`
- Package manager broken / dependency block → `package-repair-playbook.md`
- SELinux denial breaks service → `security-triage-playbook.md` + `service-recovery-playbook.md`
- Expired/invalid TLS cert breaks service → `tls-triage-playbook.md`
- Filesystem won’t mount / wrong UUID → `storage-recovery-playbook.md`
- Detached HEAD / bad commit recovery → `git-recovery-playbook.md`

---

## ✅ Design Contract (What These Are / Aren’t)

These playbooks:

- Are **operator algorithms** (diagnosis sequences + remediation patterns)
- Are **strategic and flow-controlling**, not step-by-step command lists
- Contain **decision points**, **verification steps**, and **rollback paths**
- Compose drills and (future) runbooks, but do **not** replace them

These playbooks are not:

- tutorials
- command references
- scenario narratives
- runbooks

---

## 🧠 Core Operator Rule

> **Stabilize → Identify → Execute → Verify → Persist → Rollback if needed.**  
> **Never skip a step.**

