# 🧭 LFCS Training System — kai-memory-palace

**Path:** `linux/LFCS-training/README.md`

This directory is a **purpose-built, professional-grade training system** for the  
**Linux Foundation Certified System Administrator (LFCS)** exam.

It is not a notes folder.  
It is not a tutorial collection.  
It is a **multi-layer competence engine** designed to train you to:

- operate Linux systems safely
- diagnose failures under pressure
- recover systems using correct procedures
- and pass the LFCS exam by **execution, not guessing**

---

## 🧠 Core Philosophy

LFCS does not test:

- memorization
- trivia
- multiple choice knowledge

LFCS tests:

- Can you **do the work**
- Can you **fix a broken system**
- Can you **prove the system is healthy again**

This training system is therefore built around **operator behavior**, not study notes.

---

## 🧱 The Four-Layer Training Architecture

This wing is intentionally split into **four layers**, each training a different mental mode:

### 1) Training Progression (`training-progression/`)

Mental mode: **Curriculum, order, and gates**

- Contains the **Building Blocks**
- Defines:
  - what you must master
  - in what order
  - and what “done” means
- You may not advance without passing exit criteria

Entry points:

    training-progression/README.md
    training-progression/index.md
    training-progression/LFCS-training-progression-guide.md

---

### 2) Execution Drills (`execution-drills/`)

Mental mode: **Muscle memory and mechanical fluency**

- Procedural drills
- Repeated until actions are automatic
- No narrative, no diagnosis, no strategy

They answer:

> “What do I type to perform this task?”

Entry point:

    execution-drills/index.md

---

### 3) Execution Playbooks (`execution-playbooks/`)

Mental mode: **Operator algorithms and decision trees**

- Diagnosis and recovery algorithms
- Evidence-first
- Verification and rollback built in
- Compose drills into **safe operational flows**

They answer:

> “Given this class of problem, what is the correct algorithm?”

Entry point:

    execution-playbooks/index.md

---

### 4) Failure Scenarios (`failure-scenarios/`)

Mental mode: **Judgment under pressure**

- Scenario-driven incidents
- Start from symptoms
- Force classification and playbook selection

They answer:

> “The system is already broken. What do I do now?”

Entry point:

    failure-scenarios/index.md

---

## 📜 Governance and Rules

The **constitution** of this entire system lives here:

    guiding-principles.md

You should read it. It defines:

- the no-sprawl rule
- the gate discipline
- the drills vs playbooks vs scenarios separation
- the operator-first philosophy

---

# 🚀 How To Use This System (The Only Way That Counts)

---

## ⏱️ The 60-Second “What Do I Do Today?” Rule

Every training day:

1) Open:
   
       linux/LFCS-training/failure-scenarios/index.md

2) Pick **one scenario** (random or rotating)

3) Solve it **from memory** using:

       linux/LFCS-training/execution-playbooks/

4) Verify using the scenario’s **proof ritual**

5) Then run **20–30 minutes of drills** from:

       linux/LFCS-training/execution-drills/

That is the entire system.

---

## 🔁 The Canonical Training Loop (Per Skill Area)

1) Run the linked **execution drills** until mechanics are automatic  
2) Run the linked **execution playbook** end-to-end  
3) Run the linked **failure scenarios** as timed break/fix exercises  
4) If you fail the gate, you **do not advance**

---

## 📅 Daily Bootcamp Mode (What You Should Be Doing Now)

**Minimum daily session: ~60–90 minutes**

1) 🔥 Warmup (20–30 min)
   - Pick 1–2 drill files
   - Run commands until you stop hesitating

2) 🚨 Main Event (20–40 min)
   - Pick **one failure scenario**
   - Timebox yourself
   - Diagnose → choose playbook → fix → verify

3) 🧾 After-Action (5–10 min)
   - Write down:
     - what signal told you what class of failure it was
     - what you hesitated on
     - what to drill tomorrow

---

## 🧪 Proof Ritual (Never Skip This)

A scenario is **not complete** until:

- The service / system works
- The negative symptom is gone
- You re-run the **known-good verification commands**
- You can explain:
  - what failed
  - why
  - how you knew
  - why your fix was minimal and safe

---

## 🛑 Build Freeze Rule

Once bootcamp starts:

> ❗ **No new docs. No refactors. No reorganizing.**

Only allowed changes:

- Fixing **incorrect commands**
- Fixing **broken procedures**
- Clarifying **ambiguous steps**

If you keep building, you are **not training**.

---

## 🏁 Graduation Standard

You are ready for LFCS when:

- Failure scenarios feel boring and mechanical
- Playbooks feel obvious
- Execution drills are muscle memory
- You stop exploring and start **operating**

At that point:

> The exam is execution, not discovery.

---

## 📁 Directory Map

    LFCS-training/
    ├── README.md
    ├── index.md
    ├── guiding-principles.md
    ├── training-progression/
    ├── execution-drills/
    ├── execution-playbooks/
    └── failure-scenarios/

---

## 🧠 Final Note

This is not a study guide.

This is a **system for producing an operator**.

