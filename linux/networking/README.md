# 🌐 Linux Networking
*Understanding how Linux connects, routes, and exposes services*

---

## 🎯 Purpose

This directory exists to make Linux networking **predictable, inspectable, and debuggable**.

Most networking problems feel “mysterious” only because people:

- skip layers
- guess
- jump to tools instead of state

This wing trains **layered reasoning**.

---

## 🧠 Mental Model

Linux networking is a **stack of independent layers**:

1. **Link** — is there a usable interface?
2. **Address** — does it have an IP?
3. **Route** — does it know where to send packets?
4. **Name** — can it resolve hostnames?
5. **Service** — is something listening?
6. **Application** — does the protocol work?

> You must debug **from the bottom up**.

If you skip layers, you will misdiagnose the problem.

---

## 🧭 What This Wing Covers

This wing teaches you to:

- inspect interfaces and link state (`ip link`)
- inspect addresses (`ip a`)
- read and reason about routes (`ip r`, `ip route get`)
- understand name resolution (NSS, `getent`, `resolv.conf`)
- inspect listening services (`ss -tulpen`)
- debug failures **systematically** instead of guessing

---

## 🧱 What This Wing Does NOT Cover

- advanced routing protocols
- firewalling and nftables/iptables (separate topic)
- performance tuning
- deep TCP internals

This is about **operational correctness**, not optimization.

---

## 📚 How the Content Is Organized

The canonical navigation order is in:

> `index.md`

But conceptually, the flow is:

1. **Basics** → vocabulary and concepts
2. **Interface & Addressing** → is the host connected?
3. **Routes** → where will packets go?
4. **Name Resolution** → how names become IPs
5. **Ports & Listeners** → is the service reachable?
6. **Debug Checklist** → the exam-grade playbook

Each file owns **one layer of the stack**.

---

## 🧪 How to Use This Wing

### If you are learning:

Read **top to bottom** following `index.md`.

### If something is broken:

Jump straight to:

> `network-debugging-checklist.md`

And follow it **line by line**.

---

## ⚠️ The One Rule That Matters

> **Never guess. Always inspect. Always follow the layers.**

---

## ✅ Outcome

If you understand this wing:

- “networking issues” stop being vague
- failures become **mechanical to locate**
- the LFCS networking section becomes **free points**

---

## 🧭 Relationship to Other Wings

- `linux/foundations/` → processes, permissions, inspection
- `linux/shell-and-bash/` → using the tools
- `k8s/networking/` → builds on all of this

Linux networking understanding is **upstream of everything distributed**.

---
EOF

