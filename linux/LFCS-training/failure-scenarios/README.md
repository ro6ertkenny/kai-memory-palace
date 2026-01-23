# 🧯 Failure Scenarios — README (LFCS)

**Path:** `linux/LFCS-training/failure-scenarios/`

Mental mode: **Diagnosis, judgment, and recovery under pressure**  
Purpose: Train you to **classify failures, choose the correct playbook, and recover systems correctly under time constraints**.

---

## 🎯 What This Layer Exists To Prove

This directory exists to answer one question:

> **Can you diagnose a broken system, choose the right recovery algorithm, and fix it correctly under stress?**

If the answer is “yes” for every scenario in this directory:

- You are ready for the LFCS exam.

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
- Proof, not hope

---

## 🚫 What This Layer Is NOT

They are not:

- Tutorials
- Command references
- Step-by-step walkthroughs
- Single-tool exercises

They assume:

- You already know the commands (from `execution-drills/`)
- You already know the playbooks (from `execution-playbooks/`)
- You are being tested on **judgment and flow**

---

## 🧱 How This Fits Into the LFCS Training System

The full system has four layers:

1) **Training Progression (Building Blocks)** — gates and prerequisites  
2) **Execution Drills** — muscle memory and mechanics  
3) **Execution Playbooks** — operator algorithms and decision trees  
4) **Failure Scenarios** (this directory) — **integration + pressure testing**

Relationship:

- Drills = how to execute  
- Playbooks = how to decide and route  
- Scenarios = prove you can do both together under stress

---

## 🧭 The Router Surface (Start Here)

If you do not know which scenario to run or what maps to what:

- Use: `linux/LFCS-training/failure-scenarios/index.md`

Rule:

> The index is the **coverage and routing map**.  
> The scenario files are the **training inputs**.

---

# 🚀 How To Use This Directory (Operationally)

---

## ⏱️ The 15–30 Minute Daily Rule

Every training day:

1) Run **one failure scenario** (timed)
2) Do not use notes
3) Do not jump to fixes
4) Classify → choose playbook → run algorithm
5) Do the proof ritual
6) Log what slowed you down (then drill it tomorrow)

---

## 🧪 The Canonical Scenario Run (Non-Negotiable)

When you run a scenario, you must do this **out loud** or in writing:

1) State the **symptom**
2) State the **incident class**
3) State the **chosen playbook**
4) Then follow the playbook order:
   - measure
   - classify
   - isolate
   - correct minimally
   - verify
   - persist
   - rollback plan
5) End with a **proof ritual**

You are not allowed to:

- “try something”
- domain-hop
- or fix before classifying

---

## ✅ Proof Ritual (Do Not Skip)

A scenario is only complete when you can prove:

- the original failure is gone
- there are no new errors
- the fix is minimal
- the change is correct and persistent
- you can explain:
  - what the root cause was
  - what signal revealed it
  - why the chosen playbook was correct

If you cannot explain the classification, you failed the scenario.

---

## 🏁 What “Pass” Looks Like

You have passed a scenario when:

- you classify before touching anything
- you choose the correct playbook quickly
- you follow it without skipping steps
- you reach a verified known-good state
- you can explain the entire causal chain

---

## 🛑 Build Freeze Rule (During Bootcamp)

Once you are actively prepping for LFCS:

> ❗ Do not rewrite scenarios unless they are wrong.

Only allowed edits:

- fix incorrect assumptions
- fix broken logic
- fix incorrect commands
- tighten proof rituals or references

If you keep adding scenarios or rewriting them, you are not training.

---

## 🧠 Final Rule

> **The exam does not test commands. It tests judgment under time pressure.**  
> This directory trains exactly that.

---

## 🏁 Bottom Line

> If failure scenarios feel boring and mechanical, you are ready.  
> If they feel stressful or confusing, you are not.

That is the calibration tool.

---

