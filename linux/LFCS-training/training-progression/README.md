# 🧱 Training Progression — README (LFCS)

**Path:** `linux/LFCS-training/training-progression/`

This directory is the **curriculum control layer** of the LFCS training system.

It does **not** contain drills, playbooks, or scenarios.

It defines:

- **What must be learned**
- **In what order**
- **With what dependencies**
- **And what “done” means**

This is the **gate system** that prevents gaps, randomness, and skill holes.

---

## 🧠 Role in the LFCS Training System

The full system has four layers:

- `training-progression/` → **curriculum, order, and gates** (this directory)
- `execution-drills/` → mechanical skill and command fluency
- `execution-playbooks/` → operator algorithms and recovery procedures
- `failure-scenarios/` → integration, diagnosis, and pressure testing

This directory is the **authority** for:

- sequence
- dependency
- scope
- and advancement rules

---

## 🧱 What Is a Building Block?

A **Building Block** is a **competence gate**.

It represents one coherent operator capability, such as:

- process control
- storage recovery
- networking
- services and systemd
- security and access
- etc.

A Building Block is **not**:

- a chapter
- a topic list
- a notes file
- a tutorial

It is a **proof-of-competence unit**.

You either **pass it** or you **do not advance**.

---

## 🧱 The Building Block Contract (Non-Negotiable)

Every Building Block **must** explicitly define:

- ✅ Linked **execution drills** (mechanics)
- ✅ Linked **execution playbook(s)** (procedure)
- ✅ Linked **failure scenarios** (recognition + integration)
- ✅ Explicit **exit criteria** (the gate)

If any of these are missing, the Building Block is **incomplete**.

Building Blocks:

- Do **not** embed tutorials
- Do **not** embed encyclopedic command lists
- Do **not** duplicate drill or playbook content

They define:

- what you must understand
- what you must be able to do
- and how mastery is proven

---

## 🗂️ Canonical Order

The **authoritative ordered list** of Building Blocks lives in:

> `linux/LFCS-training/training-progression/index.md`

That file is the **only supported navigation order**.

The order is:

- intentional
- dependency-driven
- and non-negotiable

---

## 🧭 How This Directory Is Used

- You always start at **Building Block 01**
- You never skip ahead
- You never partially complete a block
- You never advance without passing the exit criteria

If a later block exposes weakness:

> You must return to the earlier block and **re-earn the gate**.

---

## 🎯 Design Goals

This progression is designed so that:

- There are no gaps
- There is no redundancy
- There is no “topic soup”
- There is only **increasing operator competence**

---

## 🧠 Relationship to the Training Guide

The **method for how to study and train** is defined in:

> `linux/LFCS-training/training-progression/LFCS-training-progression-guide.md`

This README defines:

- the **structure**
- the **rules**
- and the **contract**

The guide defines:

- the **training process**
- the **daily workflow**
- and the **discipline**

---

## 🧠 Core Rule

> **The order is not negotiable. The gates are not optional.**

