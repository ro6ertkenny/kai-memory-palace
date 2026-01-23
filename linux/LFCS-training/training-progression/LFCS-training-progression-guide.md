# 🧭 LFCS Training Progression Guide

**Path:** `linux/LFCS-training/training-progression/LFCS-training-progression-guide.md`  
**Purpose:** Define the **canonical, learner-facing progression** for building real Linux sysadmin competence and passing the LFCS exam.

This guide explains **how to use the LFCS training system** as a complete, coherent curriculum.

The authoritative navigation lives in:

- `linux/LFCS-training/training-progression/README.md`
- `linux/LFCS-training/training-progression/index.md`

This file explains the **method**, not the menu.

---

## 🧠 The Four-Layer Training System

All content in this system is organized into four layers:

- `linux/LFCS-training/training-progression/` — curriculum, order, gates  
- `linux/LFCS-training/execution-drills/` — mechanical execution and muscle memory  
- `linux/LFCS-training/execution-playbooks/` — operator algorithms and recovery procedures  
- `linux/LFCS-training/failure-scenarios/` — integration and pressure testing  

Each layer trains a **different mental mode**:

- **Building Blocks** decide what you must master, and in what order
- **Execution drills** make commands and mechanics automatic
- **Execution playbooks** teach safe, ordered recovery algorithms
- **Failure scenarios** train judgment, classification, and execution under pressure

This guide explains **how to move through these layers correctly**.

---

## 🧠 The Core Training Loop (How You Study)

Every Building Block is trained using the **same mandatory loop**:

1) **Execution Drills (Mechanics)**
   - Run the linked execution-drill files until commands are automatic.
   - Goal: remove hesitation, syntax recall, and uncertainty.

2) **Execution Playbooks (Operator Mode)**
   - Execute the linked playbook end-to-end.
   - Goal: follow a safe, verifiable operational algorithm without improvisation.

3) **Failure Scenarios (Recognition + Integration)**
   - Run the linked failure scenarios as timed exercises.
   - Goal: correctly identify the class of problem and choose the right playbook.

4) **Gate (Exit Criteria)**
   - If you cannot pass the exit criteria, **you do not advance**.
   - You return to execution drills and repeat.

Rule:

> **Never skip a Building Block. Each one assumes mastery of all previous blocks.**

---

## 🧱 What Each Building Block Must Contain (Contract)

Every Building Block explicitly defines:

- **Linked execution drills** (mechanics)
- **Linked execution playbook(s)** (procedure)
- **Linked failure scenarios** (integration and recognition)
- **Explicit exit criteria** (gate)

If any of these are missing, the Building Block is **incomplete**.

Building Blocks:

- do not contain tutorials
- do not contain encyclopedic command lists
- define **what mastery means**, not how to look things up

---

## 🧱 The Building Blocks (Canonical Order)

The authoritative list and ordering live in:

`linux/LFCS-training/training-progression/index.md`

That file is the **table of contents and gate sequence**.

This guide explains **how to move through it**.

---

## 🧭 How You Progress (The Discipline)

You will:

- Start at **Building Block 01**
- Complete it using the Core Training Loop
- Pass the gate
- Only then move to the next block

If a later block exposes a weakness:

- You **stop**
- You return to the earlier block
- You re-run execution drills, playbooks, and scenarios
- You do not “push through” with gaps

This is a **competence system**, not a reading list.

---

## 🧠 Two Training Phases (How Your Training Evolves)

Your training naturally has **two phases**.

---

### Phase 1 — Coverage Phase (Learning All Domains)

Mental mode:

- Learn new domains
- Build coverage across the entire LFCS scope
- Progress through Building Blocks in order

Primary activities:

- Execution drills
- First-pass playbook execution
- Learning to recognize scenario types

Goal:

> **Reach the final Building Block with no gaps in domain coverage.**

---

### Phase 2 — Practice Phase (Only Execution and Scenarios)

Mental mode:

- No new topics
- No new material
- Only:
  - failure scenarios
  - execution playbooks
  - weak execution drills

Primary activities:

- Timed failure-scenario runs
- Re-running full playbooks
- Re-drilling weak mechanical areas

Goal:

> **Turn knowledge into automatic, calm, exam-ready execution.**

This is where:

- speed develops
- confidence develops
- hesitation disappears

---

## 🧪 Daily Training Loop (Concrete Practice)

On any training day:

1) Pick **one failure scenario**
2) Solve it properly:
   - inspect
   - classify
   - choose the correct playbook
   - execute
   - verify
3) Then pick **one execution-drill file**
4) Run it end-to-end
5) Note:
   - what was slow
   - what caused hesitation
   - what you had to look up or re-think

The next day, focus your drill time on those weaknesses.

---

## ⏱️ Timed Practice Standard

As you approach exam readiness:

- Failure scenarios should feel **routine and structured**
- You should know **which playbook to use almost immediately**
- Execution should feel **mechanical, not exploratory**

If that is not true:

- You are not done with execution drills.

---

## 🎯 Graduation Standard

You are ready for the LFCS exam when:

- Failure scenarios feel repetitive and predictable
- You always inspect and classify before acting
- You never “try random fixes”
- You always follow a playbook
- You always verify
- You can explain:
  - what failed
  - why it failed
  - why your fix was safe
  - how you proved it worked

At that point:

> The exam is execution, not discovery.

---

## 🧠 Final Objective

By the end of the final Building Block and the practice phase:

- You can operate under time pressure
- You can diagnose multi-domain incidents
- You can execute safe recovery procedures
- You can pass LFCS **and** function as a real sysadmin

---

## 🧠 Final Rule

> **This system trains judgment first, mechanics second, and speed third.**  
> **If you try to reverse that order, you will fail under pressure.**

