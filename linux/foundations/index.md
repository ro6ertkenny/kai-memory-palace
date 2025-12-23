# 🧱 Linux Foundations — Index
*Understanding how Linux actually works before attempting to control it*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`linux/foundations` wing.

It answers the question:

> “What must I understand about Linux itself before tools,
commands, containers, or Kubernetes make sense?”

This wing builds **mental models**, not muscle memory.

---

## 🧠 Mental Model

Linux is not:
- a collection of commands
- a product
- a black box

Linux **is**:
- a kernel managing resources
- a userspace providing interfaces
- a contract between processes and hardware

Understanding Linux foundations means understanding **responsibility boundaries**.

---

## 🔁 Recommended Learning Order

Read these documents **in order** to establish correct system intuition.

---

### 1️⃣ `README.md`
Defines:
- scope and posture of the foundations wing
- what “understanding Linux” actually means
- how this wing differs from shell or ops content

Start here to align expectations.

---

### 2️⃣ `system-inspection.md`
Defines:
- how to observe a Linux system safely
- what information is always available
- how to answer “what state is this system in?”

This teaches **observation before action**.

---

### 3️⃣ `processes-and-services.md`
Defines:
- what a process is
- parent/child relationships
- PID namespaces and lifecycle
- services vs one-shot processes

Everything running on Linux is a process.

---

### 4️⃣ `filesystem-and-perms.md`
Defines:
- filesystem hierarchy
- ownership and permissions
- why “everything is a file” matters

This explains persistence, access, and isolation.

---

### 5️⃣ `package-management.md`
Defines:
- how software is installed
- dependency resolution
- versioning and trust

This explains where software *comes from*.

---

## ⚠️ Common Conceptual Mistakes (Callout)

> **⚠️ Mistake:** Treating Linux as “the terminal”  
> The terminal is just one interface to the OS.

> **⚠️ Mistake:** Fixing problems before understanding system state  
> Observation is always cheaper than recovery.

---

## 🔗 Relationship to Other Wings

- `linux/shell-and-bash/`  
  Uses these concepts to control the system

- `linux/networking/`  
  Builds on process and filesystem understanding

- `k8s/foundations/`  
  Kubernetes abstractions mirror Linux primitives

Linux foundations are **upstream of everything**.

---

## ▶️ How to Use This Wing

- New to Linux → read top to bottom
- Rusty fundamentals → focus on inspection and processes
- Debugging weird behavior → return here

If you understand Linux foundations,
higher-level systems stop feeling magical.

---
