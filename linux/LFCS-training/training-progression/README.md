ro6ert@ro6bx:~/kai-memory-palace/linux/LFCS-training/training-progression$ cat LFCS-training-progression-guide.md 
# 🧭 LFCS Training Progression Guide

**Path:** `linux/LFCS-training/training-progression/LFCS-training-progression-guide.md`  
**Purpose:** Define the **canonical, learner-facing progression** for building real Linux sysadmin competence and passing LFCS.

This guide is the **curriculum spine**.  
All *content* lives elsewhere:

- `linux/LFCS-training/execution-drills/` — instruction set (muscle memory)
- `linux/LFCS-training/failure-scenarios/` — pattern recognition (break/fix)
- `linux/LFCS-training/execution-playbooks/` — operator algorithms (procedures)

This guide defines **order**, **gates**, and **how to train**.

---

## 🧠 The Training Loop (How You Study)

For each Building Block:

1) **Drills (Mechanics)**
   - Run the linked drill surfaces until commands are automatic.

2) **Scenarios (Recognition)**
   - Run the linked failure scenarios as timed exercises.
   - Goal: pick the right approach under pressure.

3) **Playbooks (Operator Mode)**
   - Execute the linked playbook end-to-end.
   - Goal: follow a safe procedure with verification and rollback.

4) **Gate**
   - If you cannot pass the exit criteria, **do not advance**.

Rule:

> **Never skip a Building Block. Each one assumes mastery of all previous blocks.**

---

## 🧱 What Each Building Block Must Contain (Contract)

Each Building Block must explicitly define:

- **Linked drill surfaces** (mechanics)
- **Linked failure scenarios** (recognition)
- **Linked execution playbook(s)** (procedure)
- **Explicit exit criteria** (gate)

If any of these are missing, the Building Block is **incomplete**.

Building Blocks must **not** embed tutorials or encyclopedic command lists.  
They reference the canonical layers and define **what mastery means**.

---

## 🧱 The Building Blocks (Canonical Order)

The learner-facing progression lives in:

`linux/LFCS-training/training-progression/`

01  building-block-01-shell-and-safety.md  
02  building-block-02-files-and-text.md  
03  building-block-03-permissions-and-identity.md  
04  building-block-04-process-model.md  
05  building-block-05-logs-and-observation.md  
06  building-block-06-services-and-systemd.md  
07  building-block-07-service-configuration.md  
08  building-block-08-networking.md  
09  building-block-09-scheduling-and-automation.md  
10  building-block-10-storage-fundamentals.md  
11  building-block-11-storage-recovery.md  
12  building-block-12-package-management.md  
13  building-block-13-security-and-selinux.md  
14  building-block-14-tls-and-certificates.md  
15  building-block-15-containers-and-virtualization.md  
16  building-block-16-git-as-an-operator-tool.md  
17  building-block-17-incident-response.md  
18  building-block-18-exam-simulation.md  

---

## 🧭 How to Use This Guide

- Start at **Building Block 01**.
- Do **not** read ahead.
- Treat each block as a **gate**.
- If a later block exposes weakness:
  - Return to the referenced earlier block
  - Re-run drills and scenarios
  - Re-run the playbook

---

## 🧱 Design Contract

Building Blocks:

- Are **conceptual + operational units**
- Do **not** contain command encyclopedias
- Only reference:
  - drills
  - scenarios
  - playbooks
- Define:
  - what you must understand
  - what you must be able to do
  - what “done” means

They are **not**:

- tutorials
- notes
- historical documents
- phase logs

---

## 🧪 Relationship to Legacy Phase Files

If legacy `phase-*` files exist, they are:

- **internal scaffolding**
- **audit input only**

They should be mined for:

- missing topics
- ordering corrections
- conceptual gaps

After migration into Building Blocks, they should be **deleted**.

---

## 🎯 Final Objective

By the end of Building Block 18:

- You can operate under time pressure
- You can diagnose multi-domain incidents
- You can execute safe recovery procedures
- You can pass LFCS **and** function as a real sysadmin

---

