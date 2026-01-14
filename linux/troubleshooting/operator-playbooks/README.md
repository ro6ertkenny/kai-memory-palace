# 🧰 Operator Playbooks — README

## 🎯 Purpose

This directory is the **capstone training ground** for becoming a real Linux operator.

It does not teach commands.

It teaches **how to think, classify, and decide under incident pressure**.

This wing trains one core loop:

Symptom → Classification → Evidence → Decision → Action → Verification

Not:

“Try random commands and hope.”

---

## 🧠 Mental Mode

**Operating a system under uncertainty and partial information.**

You are training the skill of:

- recognizing what *kind* of failure this is
- classifying it into the correct **domain**
- collecting only the evidence that matters
- making a decision that matches the evidence
- taking the smallest safe action
- verifying that reality actually changed

This is the difference between:

“Knowing Linux commands”

and

“Being able to run a Linux system.”

---

## 🏗️ Conceptual Architecture

This wing is organized into **three layers**:

---

### 1) Scenario 0 — Universal Triage

**Path:**
core/scenario-0-triage-playbook.md

This is the **entry point to every incident**.

It answers the first and most important question:

> “What class of failure is this?”

CPU, memory, IO, disk, process/service, network, time, etc.

You always start here.

Its only job is:

> Correct **classification**.

---

### 2) Domain Playbooks — The Physics of Failure

**Path:**
core/domain-playbooks/

These are the **canonical pressure / failure domains**.

They explain:

- what kind of failure is happening
- how to differentiate it from similar-looking failures
- how to stabilize the system
- when to escalate or drain a node

They are **not scenarios**.

They are the **underlying physics**:

- memory-pressure-playbook.md
- cpu-pressure-playbook.md
- io-pressure-playbook.md
- disk-exhaustion-playbook.md
- process-and-service-failures-playbook.md
- network-and-dns-failures-playbook.md
- time-and-clock-failures-playbook.md

Rule:

> If you correctly identify the **domain**, the solution space collapses.

---

### 3) Scenario Playbooks — Common Failure Patterns

**Path:**
core/scenario-playbooks/  
and  
advanced/

These are **concrete incidents**:

- “System is slow”
- “Process won’t die”
- “Disk full but df shows space”
- “Service crash looping”
- “Node randomly goes NotReady”

Each scenario:

- starts from symptoms
- guides classification
- then points you to the correct **domain playbook**

Core scenarios:

- high-frequency
- exam-grade
- should be drilled until automatic

Advanced scenarios:

- rarer
- more complex
- more environment-specific
- used for depth and pattern exposure

---

## 🧭 How To Use This System During an Incident

1) Start with:

   core/scenario-0-triage-playbook.md

2) Classify the failure into a **domain**.

3) Go to the matching **domain playbook**.

4) Use it to:
   - confirm the diagnosis
   - stabilize the system
   - decide next actions

5) Only then:
   - follow or consult a **scenario playbook** if needed.

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
   - what domain it belongs to
   - what you will do
   - why that is safe
   - how you will verify

If you can’t explain it, you don’t own it yet.

---

## 🧱 Operator Rule Zero

Symptoms first.  
Classification second.  
Evidence third.  
Action last.  
Verification always.

---

## 🧠 What This Wing Is Actually Teaching

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

---
