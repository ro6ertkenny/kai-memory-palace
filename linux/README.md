# 🐧 Linux
## The operating system foundation for everything else in this repository

---

## 📌 Purpose

The Linux wing exists to build **correct mental models** of how a Linux system
actually behaves.

Linux is not treated here as:
- a list of commands
- a certification topic
- a prerequisite to rush through

Linux is treated as the **substrate** that everything else depends on —
including containers, Kubernetes, and distributed systems.

If Linux behavior surprises you, higher layers will always feel fragile.

---

## 🧠 Learning Posture

This wing emphasizes:

- understanding before execution
- observation before change
- system behavior over tooling
- durability over memorization

Commands matter, but **reasoning matters more**.

---

## 🧭 How This Wing Is Organized

Linux knowledge is organized into **focused sub-wings**, each with a clear
mental mode and index for navigation.

### 🧱 Foundations  
`linux/foundations/`  
Understand what Linux *is* and how it represents system state.

- kernel vs userspace
- processes and services
- filesystems and permissions
- system inspection

👉 Start with: `linux/foundations/index.md`

---

### 🐚 Shell & Bash  
`linux/shell-and-bash/`  
Learn how to **control** a Linux system safely and fluently.

- shell execution model
- Bash behavior and pitfalls
- pipes, redirection, and expansion
- job control and history

👉 Start with: `linux/shell-and-bash/index.md`

---

### 💾 Filesystems & Storage  
`linux/filesystems-and-storage/`  
Understand persistence, mounts, and storage failure modes.

- filesystem hierarchy
- ownership and access
- disk pressure and limits

👉 Referenced from the foundations wing

---

### 🌐 Networking  
`linux/networking/`  
Understand how data moves through a Linux system.

- interfaces and addressing
- routing and name resolution
- diagnostic flow and failure patterns

👉 Start with: `linux/networking/index.md`

---

### ⚙️ Process & Resource Management  
`linux/process-and-resource-management/`  
Understand CPU, memory, and lifecycle pressure.

- scheduling and limits
- signals and process states
- early container concepts (cgroups, namespaces)

---

### 🧰 Package Management  
`linux/package-management/`  
Understand how software enters the system.

- repositories and trust
- versions and dependencies
- safe upgrade practices

---

### 🛠️ Troubleshooting  
`linux/troubleshooting/`  
Capture high-signal mistakes and recovery lessons.

- common conceptual errors
- failure patterns worth remembering

---

## 🔁 Relationship to Kubernetes

Linux is **upstream of all Kubernetes behavior**.

Kubernetes does not replace Linux — it orchestrates it.

If you understand:
- Linux processes → Pods make sense
- Linux networking → Services make sense
- Linux permissions → container security makes sense

Linux understanding makes Kubernetes predictable.

---

## ▶️ Where to Start

If you are new or rusty:

1. `linux/foundations/index.md`
2. `linux/shell-and-bash/index.md`
3. `linux/networking/index.md`

Do not rush.
This foundation compounds.

---

## 🎯 Outcome

After completing the Linux wing, you should be able to say:

I understand how Linux represents state,  
how it executes processes,  
how it moves data,  
and how higher-level systems build on top of it.

That understanding unlocks everything downstream.

---
