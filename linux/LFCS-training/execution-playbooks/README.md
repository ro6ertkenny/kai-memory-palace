# 🧠 Execution Playbooks — Algorithmic Operations System

**Path:** `linux/LFCS-training/execution-playbooks/`

---

## 📌 Purpose

This directory contains **domain-level operational algorithms** for Linux system administration.

These documents are intentionally called **playbooks**, but they are **not** orchestration-only guides and they are **not** shallow, app-specific runbooks.

They are:

> **Full-spectrum operational algorithms** that combine:
> - classification
> - diagnosis
> - ordered execution
> - safety constraints
> - verification gates

They are designed to be:

- usable during **real incidents**
- usable during **exam conditions**
- transferable across **any Linux system**
- and to **teach reasoning**, not memorization

---

## 🧱 Important Terminology (Industry vs This System)

In many organizations:

- **Runbook** = narrow, step-by-step recipe for a specific task  
  (“How to restart nginx”, “How to rotate certs”)

- **Playbook** = high-level orchestration and coordination guide  
  (“How we handle incidents”, “Who does what in an outage”)

That split usually produces:

- hundreds of brittle, app-specific docs
- shallow copy/paste procedures
- little real operator skill growth
- and poor performance under novel failures

---

## 🎯 This System’s Design (Deliberate and Different)

In **this repository**:

> Each document in `execution-playbooks/` is a **domain algorithm**.

It simultaneously serves the role of:

- a **playbook** (decides *which path to take*)
- and a **runbook** (tells you *exactly what to do*)

Each playbook:

- starts with **classification**
- proceeds through **ordered diagnostic steps**
- includes **concrete commands**
- enforces **safety rules**
- requires **verification before and after**
- ends in a **known-good state**

Examples:

- `storage-recovery-playbook.md`
- `network-diagnosis-playbook.md`
- `security-triage-playbook.md`
- `process-control-playbook.md`
- `service-recovery-playbook.md`
- `package-repair-playbook.md`
- `tls-triage-playbook.md`
- `git-recovery-playbook.md`

These are **not** app recipes.

They are **operator algorithms**.

---

## 🧠 Why There Is NO Separate “Runbooks” Directory

Classic model:

- Playbook: “If disk full, run disk cleanup runbook”
- Runbook: “Step 1: du, Step 2: rm logs, Step 3: …”

In this system:

- `storage-recovery-playbook.md` already contains:
  - classification (is it really full? wrong mount? readonly?)
  - inspection steps
  - safe deletion rules
  - mount verification
  - fstab safety testing
  - step-by-step execution
  - verification gates

So:

> The **runbook is embedded inside the playbook**, along with the reasoning.

This produces:

- fewer documents
- higher quality documents
- better skill transfer
- better exam performance
- better real-world operator behavior

---

## 🧪 Relationship to Failure Scenarios

`linux/LFCS-training/failure-scenarios/` are:

> The **inputs** to these playbooks.

They exist to train:

1. Symptom reading
2. Domain classification
3. Correct playbook selection
4. Calm, algorithmic execution

They replace the “incident type” layer found in enterprise playbooks.

---

## 🧱 Relationship to Building Blocks

`linux/LFCS-training/training-progression/building-block-*.md` are:

> **Training gates**, not runbooks.

They define:

- which skills must exist
- before you are allowed to rely on a playbook under pressure

They ensure:

- you are not executing blindly
- you understand what the commands mean
- you can reason, not just follow steps

---

## 🏛️ Design Philosophy

> **Train operators, not button-pressers.**  
> **Teach algorithms, not recipes.**  
> **Prefer reasoning over memorization.**  
> **Prefer domain thinking over app trivia.**

---

## 🧠 What Mastery Looks Like

You have mastered a playbook when:

- You can follow it **without surprises**
- You understand **why each step exists**
- You can detect when the system is lying to you
- You can explain **why the fix worked**
- You can apply the same algorithm to a new system

---

## ⚠️ What This System Explicitly Avoids

- App-specific “how to restart X” documents
- Shallow copy/paste procedures
- Orchestration-only docs with no commands
- Trial-and-error operations
- “Just try stuff and see” debugging

---

## 🏁 Final Rule

> **These playbooks are operational algorithms.  
> Follow them exactly until you no longer need them.**

At that point, the algorithm should exist in your head.

That is the goal.

---

## 📍 Scope Note (LFCS)

These playbooks are written to:

- cover **LFCS exam domains**
- but also represent **real operator behavior**
- and remain valid outside the exam context

They are not exam hacks.

They are **how systems should be operated**.

---


