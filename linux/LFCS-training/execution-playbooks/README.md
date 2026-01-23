# 🧠 Execution Playbooks — README (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/`

Mental mode: **Route fast → Run the right algorithm → Verify hard**  
Purpose: Provide **exam-ready operator algorithms** for diagnosis and recovery across LFCS domains.

---

## 📌 What This Directory Is

This directory contains **domain-level operational algorithms**.

Each file here is a **playbook** in the strict sense:

> **measure → classify → isolate → correct → verify → persist → rollback**

These are designed to be:

- usable during **real incidents**
- usable during **exam conditions**
- transferable across **any Linux system**
- and to train **operator behavior**, not memorization

---

## ✅ What These Playbooks Contain (Contract)

Every playbook must include:

- **Scope** (when to use it)
- **Inputs** (what you must know/determine)
- **Operator Contract** (the mandatory order of operations)
- **Evidence-first steps**
- **Decision points** (routing logic)
- **Minimal corrective actions**
- **Verification gates**
- **Persistence check**
- **Rollback strategy**
- **Links to composing drills**
- **Links to relevant failure scenarios (when they exist)**

If any of the above is missing, the playbook is incomplete.

---

## 🚫 What This Directory Is NOT

These files are **not**:

- Tutorials
- Command reference pages
- Scenario narratives
- App-specific “how to restart X” notes
- Trial-and-error debugging diaries

Those belong elsewhere:

- Mechanics / command fluency → `execution-drills/`
- Integration + pressure testing → `failure-scenarios/`
- Gates + progression rules → `training-progression/`

---

## 📘 Playbooks vs Runbooks (Operational Definition)

In many orgs:

- Runbook = narrow procedure
- Playbook = coordination / orchestration document

In **this repo**:

> Playbook = **operator algorithm** (with concrete commands + routing + gates)

If ultra-tactical runbooks are ever added later, playbooks will **call them** — not replace them.

---

## 🧭 The Router Surface (Start Here)

Do not guess which playbook to run.

The router is:

- `linux/LFCS-training/execution-playbooks/index.md`

Rule:

> If the prompt is vague, start at **index.md**, choose the incident class, then run the selected playbook end-to-end.

---

## 🔁 How This Fits Into the LFCS Training System

The LFCS system has **four layers**:

1) Training Progression (Building Blocks)  
2) Execution Drills (mechanics)  
3) Execution Playbooks (this directory)  
4) Failure Scenarios (integration)

Relationship:

- Drills teach **how to type**
- Playbooks teach **how to route and recover**
- Scenarios test whether you can do both under pressure

---

# 🚀 How To Use This Directory (Operationally)

---

## ⏱️ The 15–30 Minute Daily Rule

Every training day:

1) Run **one playbook** end-to-end (timed)
2) Verify hard (no “seems fine”)
3) Log what slowed you down (then drill it tomorrow)

This keeps the algorithm layer fresh.

---

## 🧪 The Canonical Playbook Run (Non-Negotiable)

When you run a playbook (even for practice), you must do this:

1) State the **symptom**
2) State the **incident class**
3) State the **chosen playbook**
4) Follow the playbook order exactly:
   - measure
   - classify
   - isolate
   - correct minimally
   - verify
   - persist
   - rollback plan
5) End with a **proof ritual** (see below)

---

## ✅ Proof Ritual (Do Not Skip)

A playbook run is complete only when you can prove:

- the original failure is gone
- there are no new errors introduced
- the fix is **minimal**
- the change is **persistent** (or deliberately temporary)
- you can explain:
  - DAC vs MAC
  - network vs service
  - disk vs inode vs RO
  - package state vs repo state
  - config vs runtime

If you cannot explain the classification, you did not run the playbook correctly.

---

## ✅ What “Pass” Looks Like

You have “passed” a playbook when:

- you follow it without skipping steps
- you do not domain-hop
- you reach a verified known-good state
- you can explain the classification and evidence
- you can do it again under a tighter timebox

---

## 🛑 Build Freeze Rule (During Bootcamp)

Once you are actively prepping for LFCS:

> ❗ Do not rewrite playbooks unless they are wrong.

Only allowed edits:

- fix incorrect commands
- fix broken logic
- add missing links to drills/scenarios
- tighten verification / rollback gates

If you keep polishing, you are not training.

---

## 🧠 Bottom Line

> These playbooks are operational algorithms.  
> Follow them exactly until the algorithm exists in your head.

That is the goal.

---

