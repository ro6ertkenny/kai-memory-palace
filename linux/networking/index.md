# 🌐 Linux Networking — Index
*Understanding how Linux connects, routes, and exposes services*

---

## 📌 Purpose

This index is the **navigation map** for the `linux/networking` wing.

It answers the question:

> “When networking is broken, where do I look and in what order?”

This wing is about **systematic reasoning**, not memorizing commands.

---

## 🧠 Mental Model

Linux networking is **layered**:

1. Link (is there a usable interface?)
2. Address (does it have an IP?)
3. Route (does it know where to send packets?)
4. Name (can it resolve hostnames?)
5. Service (is something listening?)
6. Application (does the protocol work?)

If you skip layers, you will misdiagnose problems.

---

## 🔁 Recommended Reading Order

Read these **in order**. Each builds on the previous one.

---

### 1️⃣ `networking-basics.md`
Defines:
- what a network stack is
- what interfaces, addresses, routes, ports, and protocols are
- the vocabulary of networking

Start here to align concepts.

---

### 2️⃣ `interface-and-addressing.md`
Defines:
- how to inspect interfaces (`ip link`)
- how to inspect addresses (`ip a`)
- link state vs address state
- what makes an interface actually usable

This answers:

> “Is this host even connected to anything?”

---

### 3️⃣ `routes-and-reachability.md`
Defines:
- how to read `ip r`
- what the default route is
- how Linux chooses paths
- how to use `ip route get`

This answers:

> “Where will packets go and why?”

---

### 4️⃣ `dns-and-name-resolution.md`
Defines:
- `/etc/resolv.conf`
- `getent`
- NSS (`/etc/nsswitch.conf`)
- why names sometimes fail but IPs work

This answers:

> “Why does 8.8.8.8 work but google.com does not?”

---

### 5️⃣ `ports-and-listeners.md`
Defines:
- how to read `ss -tulpen`
- LISTEN vs ESTAB vs TIME-WAIT
- loopback-only services
- mapping ports to processes

This answers:

> “Is the service actually reachable?”

---

### 6️⃣ `network-debugging-checklist.md`
Defines:
- the **authoritative exam-grade debug order**
- how to triage any network failure
- how to never guess and never skip layers

This is the **capstone operational playbook**.

---

## 📚 Supporting Files

- `mistakes.md`  
  Common conceptual and operational mistakes.

- `README.md`  
  Scope, philosophy, and how this wing fits into the palace.

---

## ⚠️ Common Failure Pattern

> **Jumping to DNS, firewall, or services before checking link and address.**

Always start at the bottom of the stack.

---

## ▶️ How to Use This Wing

- New to Linux networking → read top to bottom
- Debugging a real issue → jump straight to `network-debugging-checklist.md`
- Something “mysterious” → trace it layer by layer

---

## ✅ Outcome

If you understand this wing:

- networking stops feeling random
- failures become **mechanical to diagnose**
- the LFCS networking section becomes **free points**

---
EOF

