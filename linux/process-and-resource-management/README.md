# ⚙️ Processes & Resource Management — README

## 🎯 Purpose
Build **situational awareness** of what is running on a Linux system and how it consumes resources.

This directory exists to make process behavior:
- observable
- controllable
- explainable

If you cannot see what the system is doing, you cannot control it.

---

## 🧠 Mental Mode
**Observing and shaping system activity**

You should be able to:
- know what is running
- know who started it
- know how it behaves over time
- know how it uses CPU, memory, and I/O

Processes are the living state of the system.

---

## 🧭 Scope
This domain focuses on **day-to-day operational control of processes and resources**.

Included:
- process inspection and process states
- foreground/background job control
- signals and termination strategy
- CPU, memory, and disk pressure triage
- services and long-running daemons (systemd)
- safe troubleshooting patterns

Excluded:
- kernel scheduler internals
- performance tuning theory
- real-time systems
- deep cgroup internals

If it does not help you understand or control running work, it does not belong here.

---

## 📁 Directory Navigation

Start with:
- `index.md` (authoritative navigation map)

Core process mechanics:
- `process-inspection.md`
- `process-control.md`
- `resource-monitoring.md`
- `services-and-daemons.md`
- `process-troubleshooting.md`

Process and signal fundamentals:
- `ps-and-process-states.md`
- `signals-and-sigkill.md`
- `shell-vs-system.md`

---

## 🧠 Day 9 — Operator Doctrine (Core of This Domain)

These documents define how an **operator thinks**, not just which commands to run.

Read in this order:

- `operator-decision-tree.md`  
  The mental model for diagnosing real systems under pressure.

- `operator-readiness-checklist.md`  
  The graduation standard for process and resource operations.

These are the capstone documents for this domain.

---

## 🧪 How to Use This Domain
Use this directory when:
- the system feels slow
- something is consuming resources
- a service is misbehaving
- a process will not stop
- load is unexpected

Observe first. Act second.

---

## 🔎 Diagnostic First Principle
Before changing anything, you should be able to answer:
- what process is involved
- who owns it
- how long it has been running
- what resources it is using
- whether it is expected

If you cannot explain the behavior, do not intervene yet.

---

## ⚠️ Operational Guardrails
- avoid killing processes blindly
- prefer graceful signals over force
- inspect parents and children
- verify impact after every action

Process mistakes can destabilize the system.

---

## ✅ Outcome
You should be able to say:

I know what is running,  
I know why it is running,  
and I know how to control it safely.

That is process fluency.
EOF

