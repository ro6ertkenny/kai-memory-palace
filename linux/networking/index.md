# 🌐 Linux Networking — Index
*Reasoning about connectivity, flow, and failure at the operating system level*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`linux/networking` directory.

It answers the question:

> “How does networking actually work on a Linux system,
and how do I diagnose problems deterministically?”

This wing treats networking as a **system behavior**, not a set of commands.

---

## 🧠 Mental Model

Linux networking is about **packet flow through layers**.

At a high level, every connectivity problem can be reasoned through:

1. Link (is the interface up?)
2. Address (does it have an IP?)
3. Route (does it know where to send traffic?)
4. Name (can it resolve destinations?)
5. Service (is something listening?)

This wing reinforces that model repeatedly.

---

## 🔁 Recommended Reading Order

Read these documents **in order** to build durable intuition.

---

### 1️⃣ `README.md`
Defines:
- scope and diagnostic philosophy
- how networking is treated in this repository
- why structured observation matters

Start here to align mindset.

---

### 2️⃣ `networking-basics.md`
Defines:
- IP addressing fundamentals
- interfaces and link state
- local vs remote traffic

This establishes the vocabulary.

---

### 3️⃣ `ip-addressing.md` *(planned)*
Defines:
- IPv4 / IPv6 concepts
- CIDR notation
- subnet reasoning

This is about **address meaning**, not memorization.

---

### 4️⃣ `routing-and-gateways.md` *(planned)*
Defines:
- routing tables
- default gateways
- decision-making for packet forwarding

This explains *why traffic goes where it does*.

---

### 5️⃣ `dns-resolution.md` *(planned)*
Defines:
- name resolution flow
- `/etc/resolv.conf`
- local vs remote resolution

DNS is a frequent failure point and must be understood.

---

### 6️⃣ `interface-states.md` *(planned)*
Defines:
- physical vs logical interfaces
- link negotiation
- carrier vs configuration

This is where many “it works sometimes” bugs live.

---

### 7️⃣ `troubleshooting-flow.md` *(planned)*
Defines:
- a deterministic diagnostic sequence
- what to check and in what order
- how to avoid blind changes

This document turns intuition into discipline.

---

### 8️⃣ `common-failure-patterns.md` *(planned)*
Catalogs:
- recurring Linux networking failures
- symptom → cause mappings
- operator heuristics

Revisit this often.

---

### 9️⃣ `kubernetes-networking-primer.md` *(planned)*
Bridges:
- Linux networking fundamentals
- Kubernetes networking abstractions

This document explains **why Kubernetes networking behaves the way it does**.

---

## 🔗 Relationship to Other Wings

- `linux/foundations/`  
  Provides process, filesystem, and system context

- `linux/shell-and-bash/`  
  Provides the tools used to observe networking state

- `k8s/networking/`  
  Builds Kubernetes abstractions on top of Linux networking

Linux networking knowledge is **upstream of all distributed systems work**.

---

## ▶️ How to Use This Index

- New to networking → read top to bottom
- Debugging an issue → follow the layer model
- Confused in Kubernetes → return here

If you can reason about Linux networking,
higher-level abstractions stop feeling mysterious.

---
