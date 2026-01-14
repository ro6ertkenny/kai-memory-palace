# 🧰 Operator Playbooks — README

## 🎯 Purpose

This directory is the **capstone training ground** for becoming a real Linux operator.

It does not teach commands.

It teaches **how to think and decide under incident pressure**.

This wing trains one core loop:

Symptom → Evidence → Decision → Action → Verification

Not:

“Try random commands and hope.”

---

## 🧠 Mental Mode

**Operating a system under uncertainty and partial information**

You are training the skill of:

- recognizing what *kind* of problem this is
- collecting only the evidence that matters
- making a decision that matches the evidence
- taking the smallest safe action
- verifying that reality actually changed

This is the difference between:

“Knowing Linux commands”

and

“Being able to run a Linux system.”

---

## 🏗️ Conceptual Structure

This wing has **three layers**:

### 1) Scenario 0 — Universal Triage

**File:**
core/scenario-0-triage-playbook.md

This is the **entry point to every incident**.

It answers the first and most important question:

“What class of failure is this?”

CPU, memory, disk, I/O, service, network, permissions, time, etc.

You always start here.

---

### 2) Core Scenarios (`core/`)

These are the **highest-frequency, exam-grade, real-world failure patterns**.

They are:

- intentionally limited in number
- intentionally drilled until automatic
- the scenarios you should be able to run **without hesitation**

If you master only this set, you can operate most systems competently.

---

### 3) Advanced Scenarios (`advanced/`)

These are:

- rarer
- more specialized
- more multi-factor
- more environment-specific

They are:

- reference material
- pattern exposure
- depth building

Not daily drills unless you are preparing for a specific environment or exam.

---

## 🧪 How To Train With This Wing

1) Always start with:
   core/scenario-0-triage-playbook.md

2) Pick **one** scenario.

3) For that scenario:
   - read it
   - close it
   - talk through the decision process out loud
   - only then look at it again

4) You should be able to explain:
   - what you saw
   - what it means
   - what you will do
   - why that is safe
   - how you will verify

If you can’t explain it, you don’t own it yet.

---

## 🧭 Operator Rule Zero

Symptoms first.  
Evidence second.  
Action last.  
Verification always.

---

## 🧱 What This Wing Represents

This is where:

- Linux fundamentals
- filesystems
- processes
- memory
- networking
- services

…stop being “topics” and start being **operational tools**.

This is where you stop being a command runner and start being an operator.

---

## ✅ Outcome

If you can run these playbooks calmly and correctly, you can:

- pass admin-level exams
- debug real systems
- operate production environments
- and reason about failures instead of guessing

This is **operator thinking**.

EOF

