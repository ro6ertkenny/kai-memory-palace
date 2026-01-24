# 🧭 LFCS Practice Wing — Guiding Principles

**Path:** `linux/LFCS-training/guiding-principles.md`

This document is the **constitution and governance policy** of the LFCS practice wing.

It exists to:

- enforce **gates before progress**
- keep practice **high-signal and exam-relevant**
- separate **mechanics, algorithms, and judgment**
- train **operators**
---

## 🧠 The Four-Layer Training Architecture

This wing is intentionally split into **four layers**, each training a different mental mode:

1) **Training Progression (Building Blocks)**  
   - Defines order, scope, mental models, and gates  
   - Defines *what mastery means*  
   - You may not advance without passing exit criteria  

2) **Execution Drills**  
   - Purpose: **muscle memory and mechanical fluency**  
   - Trains: speed, accuracy, syntax, and safety  
   - Mental mode: “I can type this without thinking”  

3) **Execution Playbooks**  
   - Purpose: **operator algorithms and decision trees**  
   - Trains: diagnosis flow, safe recovery procedures, verification and rollback  
   - Mental mode: “Given this class of problem, I know the correct algorithm”  

4) **Failure Scenarios**  
   - Purpose: **integration and pressure testing**  
   - Trains: classification, judgment, calm execution under uncertainty  
   - Mental mode: “The system is broken; I must reason, not guess”

Relationship:

- Drills teach you **how to execute**
- Playbooks teach you **how to decide**
- Scenarios test whether you can do both
- Building Blocks define **what you must master and in what order**

---

## 🧠 The Operator Mental Mode

You are training two different skills, **separately and intentionally**:

### 1) Judgment, Diagnosis, and Recovery

- Recognizing failure classes
- Triage sequencing
- Choosing the correct playbook
- Fixing the real cause, not symptoms
- Verifying stability and correctness

### 2) Execution, Accuracy, and Safety

- Performing mechanical tasks quickly
- Using commands correctly without hesitation
- Avoiding syntax errors and unsafe actions
- Never operating blindly on the system

These are trained in **different layers** for a reason.

---

## 🗂️ Structure of This Wing

This wing is governed by four directories:

### 1) training-progression/

Purpose:

- Defines the **curriculum spine**
- Defines **order and dependency**
- Defines **gates**
- Defines **what “done” means**

These are **Building Blocks**. They are not tutorials.

---

### 2) execution-drills/

Purpose:

- Train **mechanical speed and accuracy**
- Build **muscle memory**

Characteristics:

- Many tasks
- Grouped by domain
- No narrative
- No diagnosis
- No strategy
- Just: “Can you do this cleanly and correctly?”

These are not scenarios.  
They are **repetition drills**.

---

### 3) execution-playbooks/

Purpose:

- Train **operator algorithms**
- Provide **safe, repeatable diagnosis and recovery flows**

Characteristics:

- Step-by-step decision trees
- Evidence-first
- Verification and rollback built in
- Compose drills into procedures

These are **playbooks**, not tutorials and not scenarios.

---

### 4) failure-scenarios/

Purpose:

- Train **reasoning under pressure**
- Train **classification and judgment**
- Force you to choose the correct playbook

Characteristics:

- Few in number
- Deep and realistic
- Cross-domain
- Symptom → Evidence → Classification → Playbook → Recovery → Verification

These are **incidents**, not exercises.

---

## 🧱 Standing Rules (Non-Negotiable)

### Rule 1 — No Scenario Sprawl

Do not add new failure scenarios casually.

A new scenario is only allowed if it teaches:

- a new **failure class**
- or a new **decision pattern**

If it can be covered by:

- an existing scenario
- or an execution drill
- or an execution playbook

Then:

**Do not create a new scenario.**

---

### Rule 2 — Gate Discipline

You do not advance because you “read the file”.

You advance only when:

- the drills are automatic
- the playbook can be executed end-to-end without confusion
- the exit criteria of the Building Block are satisfied

If a later block exposes weakness:

> You must return and re-earn the earlier gate.

---

### Rule 3 — Uniqueness Test

Before adding any new failure scenario, it must answer:

- What **unique failure pattern** does this teach?
- What **unique decision** does this train?

If the answer is “none”:

**Do not add it.**

---

### Rule 4 — Drills Can Expand, Scenarios Stay Elite

- execution-drills/ may grow freely.
- execution-playbooks/ grow only when a new failure class exists.
- failure-scenarios/ must remain **small, deep, and elite**.

Drills are cheap.  
Scenarios are expensive.

---

## 🧭 Current Core Scenario Set

The canonical failure scenarios are:

- System feels slow
- Disk is full
- Service is down
- Process won’t die
- CPU is pegged
- Memory pressure

You should be able to solve all of these:

- without panic
- without guessing
- without random command flailing
- using the correct playbook

---

## 🧭 Approved Future Scenario Candidates (Only After Mastery)

These are **candidates**, not commitments:

- Inode exhaustion (disk has space but writes still fail)
- “Permission denied but everything looks correct” (DAC vs MAC / SELinux)
- Networking or DNS failure (service running but unreachable)
- Boot or startup failure (drops to emergency, mount failures)

Do not add these until the core set is **boring and automatic**.

---

## 🧪 Daily Training Loop

1) Pick one failure scenario
2) Classify the problem out loud
3) State which playbook you will use
4) Run only the first triage step
5) Interpret the evidence
6) Continue the algorithm
7) Fix the root cause
8) Verify stability

Then:

1) Pick one execution-drill file
2) Run 5–10 tasks
3) Note what is slow or error-prone
4) Drill those again tomorrow

---

## 🏁 Graduation Standard

You are ready for the LFCS when:

- Failure scenarios feel boring and mechanical
- Playbooks feel obvious
- Execution drills are muscle memory
- You stop exploring and start **operating**

At that point:

The exam is execution, not discovery.

---

## 🧠 Core Philosophy

This wing is not about coverage.

It is about:

- calm
- correctness
- control
- and repeatability

Always prefer:

**Fewer, deeper, automatic**

Over:

**More, shallower, forgotten**

---

## 🧠 Final Rule

> **This system trains judgment first, procedures second, and speed third.**

