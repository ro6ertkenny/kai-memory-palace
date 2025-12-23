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

- know what is running
- know who started it
- know how it behaves over time
- know how it uses CPU, memory, and I/O

Processes are the living state of the system.

---

## 🧭 Scope
This domain focuses on **day-to-day operational control of processes and resources**.

Included:
- process inspection
- foreground and background execution
- signals and termination
- CPU and memory usage
- load and contention
- services and long-running daemons

Excluded:
- kernel scheduler internals
- performance tuning theory
- real-time systems
- advanced cgroup internals

If it does not help you understand or control running work, it does not belong here.

---

## 📁 Directory Layout

### `process-and-resource-management/README.md`
This file.
- defines scope
- sets mental model
- explains how to use this domain

---

### `process-and-resource-management/processes-and-services.md`
Core operational guide.

Covers:
- process lifecycle
- inspecting running processes
- sending signals
- managing services
- understanding system load

This is the **primary reference** for runtime behavior.

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
