# 🧭 LFCS Practice Wing — Guiding Principles

## 🎯 Purpose

This document is the **governance and policy** for the LFCS practice wing.

It exists to:

- prevent scenario sprawl
- preserve a deliberate training structure
- keep practice high-signal and exam-relevant
- separate thinking drills from execution drills
- enforce mastery before expansion

This wing is not a question bank.
It is a **training system**.

---

## 🧠 Mental Mode

**Exam operator**

You are training two different skills:

1) Diagnosis & recovery

- Recognizing failure patterns
- Triage sequencing
- Choosing the correct control surface
- Fixing the real cause
- Verifying stability

2) Execution & accuracy

- Performing mechanical tasks quickly
- Using commands correctly without hesitation
- Avoiding syntax errors and unsafe actions

These skills are trained **separately** and **intentionally**.

---

## 🗂️ Structure of This Wing

This wing is split into two parts:

### 1) failure-scenarios/

Purpose:

- Train reasoning under pressure
- Train incident-style diagnosis and recovery

Characteristics:

- Few in number
- Deep and realistic
- Cross-domain
- Symptom → Evidence → Decision → Action → Verification

These are not checklists.
They are incidents.

---

### 2) execution-drills/

Purpose:

- Train mechanical speed and accuracy
- Build muscle memory for common LFCS tasks

Characteristics:

- Many tasks
- Grouped by domain
- No narrative
- No diagnosis
- Just: “Can you do this cleanly and correctly?”

These are not scenarios.
They are repetition drills.

---

## 🧱 Standing Rules (Non-Negotiable)

### Rule 1 — No Scenario Sprawl

Do not add new failure scenarios casually.

A new scenario is only allowed if it teaches:

- a new failure class
- or a new decision pattern

If an idea can be covered by:

- an existing scenario
- or an execution drill

Then:

Do not create a new scenario.

---

### Rule 2 — Mastery Gate

Do not add new failure scenarios until the current core set is:

- automatic
- hesitation-free
- mechanically fluent
- and mentally calm

If you still fumble the basics:

You are not allowed to add more.

---

### Rule 3 — Uniqueness Test

Before adding any new failure scenario, it must answer:

- What unique failure pattern does this teach?
- What decision does this train that no other scenario trains?

If the answer is “none”:

Do not add it.

---

### Rule 4 — Drills Can Expand, Scenarios Cannot

- execution-drills/ may grow freely.
- failure-scenarios/ must remain small and elite.

Execution drills are cheap.
Scenarios are expensive.

---

## 🧭 Current Scenario Set

The core failure scenarios are:

- System feels slow
- Disk is full
- Service is down
- Process won’t die
- CPU is pegged
- Memory pressure

You should be able to walk through all of these:

- without hesitation
- without guessing
- without random command flailing

---

## 🧭 Approved Future Scenario Candidates (When Ready)

These are the only pre-approved expansions, and only after mastery:

- Inode exhaustion
  Disk has space but writes still fail

- Permission denied but everything looks correct
  Ownership, mode bits, execute bit on directories, service users, SELinux interactions

- Networking / DNS failure
  Service is running but nobody can connect

- Boot / startup failure
  Drops to emergency or fails to mount root

These are candidates, not promises.

---

## 🧪 How To Practice (Daily Loop)

1) Pick one failure scenario
2) Talk through the plan out loud
3) Run only the first triage step
4) Interpret the output
5) Decide the next step
6) Fix the cause
7) Verify stability

Then:

1) Pick one execution-drill file
2) Do 5–10 tasks from it
3) Note which ones are slow or error-prone
4) Repeat those tomorrow

---

## 🏁 Graduation Standard

You are ready for the LFCS when:

- Failure scenarios feel boring and mechanical
- Execution drills are muscle memory
- You stop exploring and start operating

At that point:

The exam is execution, not discovery.

---

## 🧠 Philosophy

This wing is not about coverage.

It is about:

- calm
- correctness
- and control

Always prefer:

Fewer, deeper, automatic

Over:

More, shallower, forgotten

---
