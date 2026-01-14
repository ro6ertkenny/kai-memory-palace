# 🧭 Operator Playbooks — Index
*The authoritative navigation map for Linux incident drill and operator reasoning*

---

## 🎯 Purpose

This index defines a **training and reasoning system**, not a folder of notes.

It exists to make playbooks:

- easy to drill
- easy to find under pressure
- easy to keep clean (no duplicates, no bloat)

This is where:

> Linux knowledge becomes **operational skill**.

---

## 🧠 Operator Rule Zero

Symptoms first.  
Classification second.  
Evidence third.  
Action last.  
Verification always.

---

## 🧠 Mental Model

Operating a system is not about commands.

It is about:

- recognizing what *kind* of failure this is
- classifying it into the correct **domain**
- collecting only the evidence that matters
- taking the smallest safe action
- verifying that reality actually changed

Correct **classification** collapses the solution space.

---

## 🏗️ Architecture Overview

This system has **three layers**:

---

### 1) Scenario 0 — Universal Triage (Entry Point)

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

They are the **underlying physics**.

If you identify the correct domain, the problem becomes mechanical.

See:

core/domain-playbooks/index.md

---

### 3) Scenario Playbooks — Concrete Incidents

**Paths:**
core/scenario-playbooks/  
advanced/

These are **specific failure patterns**:

- “System is slow”
- “Process won’t die”
- “Disk full but df shows space”
- “Service crash looping”
- “Node randomly goes NotReady”

Each scenario:

- starts from symptoms
- reinforces classification
- points you to the correct **domain playbook**

Core scenarios:

- high-frequency
- exam-grade
- should be drilled until automatic

Advanced scenarios:

- rarer
- more complex
- more environment-specific
- used for pattern exposure and depth

---

## 🧰 Start Here Every Time

### ✅ Scenario 0 — Universal Triage

- core/scenario-0-triage-playbook.md

If you don’t know what class of failure you’re seeing, you start here.

---

## ✅ Core Scenario Drill Set
*Daily drills — high-frequency failure patterns you should execute without hesitation*

Recommended drill order:

1) core/scenario-0-triage-playbook.md  
   Universal triage: classify the incident before you act.

2) core/scenario-1-system-feels-slow.md  
   Global slowness triage: CPU vs memory vs IO vs disk vs “one bad process”.

3) core/scenario-2-disk-full.md  
   Space vs inodes, find the offender, fix without breaking the system.

4) core/scenario-3-service-is-down.md  
   Service vs process vs dependency; confirm status; read logs; verify MainPID.

5) core/scenario-4-process-wont-die.md  
   Job vs PID; signals; D-state recognition; safe escalation.

6) core/scenario-5-cpu-pegged.md  
   Identify culprit; decide expected vs runaway; choose the smallest safe action.

7) core/scenario-6-memory-growth-leak.md  
   Memory creep: pressure vs “usage”; RSS growth; swap/PSI/OOM signals.

8) core/scenario-7-inodes-exhausted.md  
   Disk “looks fine” but writes fail: inode exhaustion workflow.

9) core/scenario-8-permission-denied-but-looks-correct.md  
   Permissions: identity + path + mount + ACL/caps/LSM checks.

10) core/scenario-9-dns-or-networking-intermittent.md  
    Intermittent failures: DNS, routing, packet loss, evidence-first isolation.

11) core/scenario-10-service-crash-loop.md  
    Restart loops: systemd policy, logs, exit codes, dependency failures, resources.

12) core/scenario-11-disk-full-deleted-open-files.md  
    Deleted-but-open files: why space doesn’t return; find handles; recover safely.

13) core/scenario-12-io-wait-slowness.md  
    IO wait: prove it; find device/process; decide safe mitigation.

14) core/scenario-13-time-skew-breaks-everything.md  
    Time skew: TLS/certs/auth breakage; verify NTP; fix clock safely.

Core is intentionally capped and refined over time.

---

## 🧠 Advanced Scenarios
*Reference playbooks — rarer, specialized, or environment-specific patterns*

- advanced/

Advanced is allowed to grow, but must remain:

- indexed
- non-duplicative
- conceptually clean

---

## 🧱 Anti-Bloat Policy (Enforced)

A new playbook must answer:

- What unique failure pattern does this teach?
- What decision does it train that no other playbook trains?

If the answer is “none”:

> It does not get a new file.

It is merged into an existing scenario.

---

## 🧭 How To Use This During a Real Incident

1) Start with:

   core/scenario-0-triage-playbook.md

2) Classify the failure into a **domain**.

3) Go to:

   core/domain-playbooks/

4) Use the domain playbook to:
   - confirm the diagnosis
   - stabilize the system
   - decide next actions

5) Only then:
   - consult a **scenario playbook** if needed.

---

## 🧪 How To Train With This System

1) Always start with Scenario 0.

2) Pick **one** scenario.

3) For that scenario:
   - read it
   - close it
   - talk through the reasoning out loud
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

## 🧠 What This System Actually Teaches

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

## 🏁 Outcome

If you can run the Core playbooks calmly and correctly:

You are no longer “running Linux commands.”  
You are operating a Linux system.

---
