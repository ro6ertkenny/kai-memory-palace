# 🧭 Execution Playbooks — Index (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/index.md`  
**Purpose:** Provide a **fast operator navigation surface** for the LFCS execution-playbooks layer.

This directory contains **exam-style operator flows** that compose the canonical:

- `linux/LFCS-training/execution-drills/` (muscle memory)
- `linux/LFCS-training/failure-scenarios/` (practice cases)

Execution playbooks are the **algorithm layer**:
observe → isolate → decide → correct → verify → persist → rollback.

---

## ✅ Playbooks

### 🧩 Core Operator Surfaces

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/account-access-playbook.md`
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

### 🔐 Integrity and Trust

- `linux/LFCS-training/execution-playbooks/package-repair-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`

### 🌱 Workflow Recovery

- `linux/LFCS-training/execution-playbooks/git-recovery-playbook.md`

---

## 🧠 How to Use This Layer (Training Procedure)

Recommended order for a given domain:

1) Run the relevant drill surface(s) until mechanics are automatic  
2) Run the relevant failure scenario(s) as a timed exercise  
3) Run the relevant execution playbook end-to-end as an operator algorithm

Operator objective:

- Use playbooks as **decision trees**, not as “reading material”
- Execute, verify, and persist safely

---

## 🔁 Failure Scenario → Playbook Map (Coverage Audit)

This map ensures every existing failure scenario has a corresponding operator algorithm.

### Existing failure scenarios

- `linux/LFCS-training/failure-scenarios/scenario-a-system-feels-slow.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if I/O or disk pressure signals appear)
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if a specific service is the offender)

- `linux/LFCS-training/failure-scenarios/scenario-b-disk-is-full.md`
  - Primary: `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if service fails due to disk/log growth)

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md`
  - Primary: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - Secondary: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if “down” is actually reachability)
  - Secondary: `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if permissions/SELinux block startup)

- `linux/LFCS-training/failure-scenarios/scenario-d-process-wont-die.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

- `linux/LFCS-training/failure-scenarios/scenario-e-cpu-pegged.md`
  - Primary: `linux/LFCS-training/execution-playbooks/process-control-playbook.md`

- `linux/LFCS-training/failure-scenarios/scenario-f-memory-pressure.md`
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

- Are **operator flows** (diagnosis sequences + remediation patterns)
- Contain **decision points**, **verification steps**, and **rollback paths**
- Compose drills, but do **not** replace drills

These playbooks are not:

- tutorials
- command references
- scenario narratives

---
