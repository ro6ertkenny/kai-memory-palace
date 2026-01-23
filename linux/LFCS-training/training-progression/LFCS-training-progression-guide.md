# 🧭 LFCS Training Progression Guide

**Path:** `linux/LFCS-training/training-progression/LFCS-training-progression-guide.md`  
**Purpose:** Define the **canonical, learner-facing progression** for building real Linux sysadmin competence and passing LFCS.

This guide is the **curriculum spine explainer**.

The authoritative navigation lives in:

- `linux/LFCS-training/training-progression/README.md`
- `linux/LFCS-training/training-progression/index.md`

---

## 🧠 The Four-Layer Training System

All content lives in four layers:

- `linux/LFCS-training/training-progression/` — curriculum, order, gates  
- `linux/LFCS-training/execution-drills/` — muscle memory (mechanics)  
- `linux/LFCS-training/execution-playbooks/` — operator algorithms (procedures)  
- `linux/LFCS-training/failure-scenarios/` — integration and pressure testing  

This guide explains **how to use them together**.

---

## 🧠 The Training Loop (How You Study)

For each Building Block:

1) **Drills (Mechanics)**
   - Run the linked drill surfaces until commands are automatic.

2) **Playbooks (Operator Mode)**
   - Execute the linked playbook end-to-end.
   - Goal: follow a safe, verifiable procedure.

3) **Scenarios (Recognition + Integration)**
   - Run the linked failure scenarios as timed exercises.
   - Goal: classify correctly and choose the right playbook under pressure.

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
They define **what mastery means**, not how to look things up.

---

## 🧱 The Building Blocks (Canonical Order)

The authoritative list lives in:

`linux/LFCS-training/training-progression/index.md`

---

## 🧭 How to Use This Guide

- Start at **Building Block 01**.
- Do **not** read ahead.
- Treat each block as a **gate**.
- If a later block exposes weakness:
  - Return to the referenced earlier block
  - Re-run drills, playbooks, and scenarios

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

By the end of the final Building Block:

- You can operate under time pressure
- You can diagnose multi-domain incidents
- You can execute safe recovery procedures
- You can pass LFCS **and** function as a real sysadmin

---

## 🧠 Final Rule

> **This system trains judgment first, mechanics second, and speed third.**

