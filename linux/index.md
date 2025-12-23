# 🐧 Linux — Master Index
*A structured navigation map for Linux system understanding and operations*

---

## 📌 Purpose

This index provides a **single entry point** for all Linux-related knowledge
in the **kai-memory-palace**.

It answers the question:

> “What do I need to understand about Linux in order to operate systems,
containers, and Kubernetes confidently?”

Linux is not a prerequisite checkbox.
It is the **substrate** everything else depends on.

---

## 🧠 How Linux Is Treated in This Repository

Linux is approached as:

- an operating system
- a resource manager
- a process execution environment
- a security boundary
- a troubleshooting surface

This repository treats Linux as a **system to reason about**, not a list
of commands to memorize.

---

## 🧱 Linux Wing Overview (Recommended Order)

Linux knowledge is organized into **conceptual layers**, each building
on the previous.

---

### 1️⃣ `linux/foundations/`
**Mental mode:** Understanding the OS

This wing establishes:
- what the Linux kernel is responsible for
- user space vs kernel space
- files, processes, and permissions
- system startup and services

Start here if:
- Linux feels opaque
- commands feel magical
- failures feel unpredictable

This wing builds grounding.

---

### 2️⃣ `linux/shell-and-bash/`
**Mental mode:** Controlling the system

This wing establishes:
- shell behavior and execution
- pipes, redirection, and streams
- environment variables
- scripting fundamentals

Start here if:
- you rely on copy-paste commands
- scripts feel fragile
- debugging shell behavior is hard

This wing builds fluency.

---

### 3️⃣ `linux/filesystems-and-storage/`
**Mental mode:** Persistence and I/O

This wing establishes:
- filesystem hierarchy
- mounts and devices
- permissions and ownership
- disk pressure and failure modes

Start here if:
- storage failures confuse you
- containers feel “ephemeral”
- disk issues appear suddenly

This wing builds reliability.

---

### 4️⃣ `linux/networking/`
**Mental mode:** Connectivity and flow

This wing establishes:
- interfaces and addressing
- routing and name resolution
- ports, sockets, and processes
- how traffic actually moves

Start here if:
- networking issues feel invisible
- Kubernetes networking seems mysterious
- debugging connectivity is slow

This wing builds clarity.

---

### 5️⃣ `linux/process-and-resource-management/`
**Mental mode:** System pressure and limits

This wing establishes:
- CPU scheduling
- memory management
- cgroups and namespaces
- signals and process lifecycle

Start here if:
- systems slow down unexpectedly
- containers behave oddly
- resource limits cause outages

This wing builds intuition.

---

### 6️⃣ `linux/security-and-permissions/`
**Mental mode:** Isolation and trust

This wing establishes:
- users and groups
- file permissions and capabilities
- privilege boundaries
- secure defaults

Start here if:
- permissions errors are confusing
- privilege escalation feels risky
- containers and security overlap is unclear

This wing builds safety.

---

## 🔁 Relationship to Kubernetes

Linux is **upstream of all Kubernetes behavior**.

Every Kubernetes concept maps directly to Linux primitives:

- Pods → namespaces + processes
- Containers → cgroups + filesystem isolation
- Networking → Linux networking stack
- Storage → filesystems and mounts
- Security → users, groups, and capabilities

If Kubernetes behavior surprises you,
the explanation is almost always in Linux.

---

## 🔗 Relationship to Other Wings

- Upstream of:
  - `k8s/foundations`
  - `k8s/networking`
  - `k8s/ops+provisioning`

- Parallel to:
  - `git/`
  - `vim/`

Linux knowledge amplifies every other wing.

---

## 🎯 Core Outcome

After completing the Linux wings, you should be able to say:

I understand how Linux executes processes,
manages resources,
handles networking and storage,
and enforces security boundaries.

That understanding makes Kubernetes predictable.

---
