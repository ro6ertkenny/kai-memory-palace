# 🧯 Linux Troubleshooting — README

## 🎯 Purpose
This directory teaches **how to think when systems misbehave**.

Not:
- random command execution
- cargo-cult fixes
- blind restarts

But:
- symptom-driven diagnosis
- evidence-based decisions
- minimal, safe interventions
- verification after every change

---

## 🧠 Mental Mode
**Operator mode**

You are not here to “try things”.

You are here to:
- observe symptoms
- gather evidence
- form a hypothesis
- take the smallest safe action
- verify the result

---

## 🧭 Scope

This wing focuses on:
- system triage
- failure pattern recognition
- disk / memory / CPU incidents
- process and service failures
- recovery discipline
- not making things worse

Included:
- disk full incidents
- hung / stuck processes
- service failures
- performance pathologies
- misbehaving systems

Excluded:
- kernel debugging
- performance tuning theory
- application-level debugging

---

## 📁 Directory Navigation

Core doctrine:

- `triage-playbook.md`  
  The **first-response guide** when something is wrong.

- `mistakes.md`  
  High-signal operational mistakes you never want to repeat.

Supporting domains (cross-links):

- Processes & Resources:
  - `../process-and-resource-management/operator-decision-tree.md`
  - `../process-and-resource-management/operator-readiness-checklist.md`

- Filesystems:
  - `../filesystems-and-storage/df-command.md`

---

## 🧠 Day 9 — Operator Core

These documents define how you **actually operate a system under stress**:

- `triage-playbook.md`  
  What to do first when:
  - the system is slow
  - the disk is full
  - a service is down
  - a process is stuck
  - CPU is pegged

- `../process-and-resource-management/operator-decision-tree.md`  
  The global decision framework.

Together these form your **incident response doctrine**.

---

## 🧪 How To Use This Wing

Use this wing when:
- something feels wrong
- something is broken
- something is slow
- something is full
- something will not stop
- something will not start

Start with:

1) `triage-playbook.md`  
2) Then jump to the relevant domain (processes, disk, services, etc)

---

## ⚠️ Troubleshooting Rules

- Never act before you can explain the symptom
- Never kill before you inspect
- Never delete before you understand
- Never restart before you read logs
- Always verify after changes

---

## ✅ Outcome

You should be able to say:

I can walk up to a broken Linux system  
and methodically bring it back under control  
without making it worse.

That is operator competence.
EOF

