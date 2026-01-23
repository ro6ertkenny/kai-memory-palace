# 🧯 Failure Scenarios (LFCS)

**Path:** `linux/LFCS-training/failure-scenarios/README.md`

This directory is the **integration and pressure-testing layer** of the LFCS training system.

It exists to answer one question:

> Can you diagnose a broken system, choose the right recovery algorithm, and fix it correctly under stress?

---

## 🧠 What This Layer Is

Failure scenarios are:

- **Exam-style incident simulations**
- **Multi-domain**
- **Symptom-driven**
- **Diagnosis-first**
- **Playbook-oriented**

They are designed to train:

- Classification
- Triage
- Correct playbook selection
- Calm, ordered recovery
- Verification discipline

---

## 🧱 How This Fits Into the LFCS Training System

The full system has four layers:

1) **Building Blocks**  
   Mental models, invariants, and gates.

2) **Execution Drills**  
   Muscle memory and command fluency.

3) **Execution Playbooks**  
   Operator algorithms and decision trees.

4) **Failure Scenarios** (this directory)  
   Integration, pressure, and realism.

Relationship:

- Drills = how to execute
- Playbooks = how to decide and route
- Scenarios = prove you can do both together

---

## 🧪 What Failure Scenarios Are Not

They are not:

- Tutorials
- Command references
- Step-by-step walkthroughs
- Single-tool exercises

They assume:

- You already know the commands (from drills)
- You already know the playbooks
- You are being tested on **judgment and flow**

---

## 🧠 How You Should Train With This Directory

Recommended loop:

1) Pick a scenario
2) Do not read the answer path
3) Start from the symptom
4) Inspect the system
5) Classify the failure
6) Choose the correct playbook
7) Execute recovery
8) Verify the system
9) Be able to explain:
   - What the root cause was
   - What signal revealed it
   - Why the chosen playbook was correct

---

## ⏱️ Training Modes

- **Cold start**: Random scenario, no notes
- **Timed**: 15–20 minutes per scenario
- **Playbook selection drills**: Focus only on classification speed
- **Post-mortem mode**: Write or verbalize the root cause chain

---

## 🎯 Completion Standard

You are ready for the LFCS exam when:

- You can solve every scenario calmly
- You classify before acting
- You never “try random fixes”
- You always verify
- You always stop when the requirement is satisfied

---

## 🧠 Final Rule

> **The exam does not test commands. It tests judgment under time pressure.**  
> This directory trains exactly that.

