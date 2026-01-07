# 🧱 Linux Foundations — README
*Understanding how Linux actually works before attempting to control it*

---

## 🎯 Purpose

The **Linux Foundations** wing exists to build **correct mental models** of how Linux works.

This is not:

- a command reference
- a bag of tricks
- a “just tell me what to type” guide

This **is**:

- an explanation of what Linux *is*
- how the kernel and userspace relate
- how processes, files, memory, and resources actually behave
- how to reason about system state before touching it

If you understand this wing, higher-level tools (shell, systemd, containers, Kubernetes) stop feeling magical and start feeling **inevitable**.

---

## 🧠 Mental Posture

Linux is not:

- a collection of commands
- a product
- a black box

Linux **is**:

- a kernel managing resources
- a userspace providing interfaces
- a set of contracts between:
  - processes
  - memory
  - files
  - devices
  - and the scheduler

This wing teaches you to think in terms of:

- responsibility boundaries
- ownership
- state
- and causality

---

## 🧭 What This Wing Covers

This wing focuses on **conceptual and operational primitives**:

- how to inspect system state safely
- what a process really is
- what a file really is
- how metadata, ownership, and permissions work
- how the system represents and exposes resources
- how to reason about “what is happening” before acting

It intentionally avoids:

- deep performance tuning
- kernel internals
- hardware engineering
- tool-specific workflows

---

## 🚫 What This Wing Is Not

This wing is **not**:

- the shell wing (that is about *controlling* the system)
- the storage wing (that is about *disks and filesystems*)
- the networking wing (that is about *connectivity*)
- the Kubernetes wing (that is about *distributed systems*)

This wing is **upstream of all of those**.

---

## 🧱 How This Relates to Other Wings

- `linux/shell-and-bash/`  
  Uses these concepts to control the system

- `linux/filesystems-and-storage/`  
  Builds on the file and resource models defined here

- `linux/networking/`  
  Builds on process and resource understanding

- `k8s/foundations/`  
  Kubernetes abstractions mirror Linux primitives

If something feels confusing at a higher level, the answer is almost always **in this wing**.

---

## ▶️ How To Use This Wing

- New to Linux → read in order, starting from the beginning
- Rusty fundamentals → focus on inspection and processes
- Debugging weird behavior → come here before touching prod

This wing trains you to:

> **Understand first. Act second.**

---

## 🗺️ Navigation

The learning order and document map live in:

> 📄 **`index.md`**

Start there.

---

## ✅ Outcome

After completing this wing, you should be able to say:

- I know what the system *is*
- I know what state it is in
- I know why things behave the way they do
- I know where to look before I change anything

That is **Linux literacy**.

