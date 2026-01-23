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

- Step-by-step diagnosis and recovery procedures
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

## 🧪 How You Actually Train

### The canonical training loop (per Building Block):

1) Run the linked **execution drills** until mechanics are automatic  
2) Run the linked **execution playbook** end-to-end  
3) Run the linked **failure scenarios** as timed break/fix exercises  
4) If you fail the gate, you **do not advance**

---

### Daily practice loop:

1) Pick one failure scenario
2) Classify the problem out loud
3) Choose the playbook
4) Execute the algorithm
5) Verify recovery

Then:

1) Pick one execution-drill file
2) Run 5–10 tasks
3) Note what is slow or error-prone
4) Drill those again tomorrow

---

## 🏁 Graduation Standard

You are ready for LFCS when:

- Failure scenarios feel boring and mechanical
- Playbooks feel obvious
- Execution drills are muscle memory
- You stop exploring and start **operating**

At that point:

The exam is execution, not discovery.

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

