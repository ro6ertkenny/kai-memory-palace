# 🧱 Building Block 8 — Networking

**Path:** `linux/LFCS-training/training-progression/building-block-8-networking.md`  
**Purpose:** Build the operational ability to **diagnose host connectivity** by reasoning from **interface → address → route → DNS → listening service**.

---

## 🎯 What This Block Builds

You are building:

- A layered mental model of networking:
  - link/interface
  - IP addressing
  - routing
  - name resolution
  - service listeners
- The ability to:
  - determine **where** connectivity is failing
  - avoid guessing
  - fix the **correct layer** first

This block turns “it can’t connect” into a **structured isolation process**.

---

## 🧠 Mental Models You Must Own

- Connectivity is a chain:
  - if any link is broken, the whole thing fails
- Layers fail independently:
  - interface down
  - wrong IP
  - wrong route
  - broken DNS
  - service not listening
- “The network is broken” is not a diagnosis:
  - you must name **which layer** is broken
- A service being “down” can look like:
  - a network problem
  - even when the network is fine

Invariants:

- “I can state exactly which layer is failing.”
- “I do not change firewall or routes until I know what layer is broken.”
- “I can prove where packets stop.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

Rule:

> You should be able to inspect interfaces, addresses, routes, and listeners **without hesitation**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md` (when it is actually reachability)
- Any “can’t connect” variant in exam-style tasks

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the service is not listening)

Rule:

> You should always isolate the network first **before** touching the service config.

---

## 🧭 Required Capabilities

You must be able to:

### Inspect the Local Stack

- Determine:
  - which interfaces exist
  - which are up/down
  - what addresses they have
- Determine:
  - default route
  - specific routes

### Prove or Disprove Each Layer

- Link:
  - interface state
- IP:
  - local address present
- Route:
  - path to destination exists
- DNS:
  - name resolves to the expected address
- Service:
  - process is listening on the expected port

### Distinguish Network vs Service

- Recognize:
  - connection refused vs timeout
  - name not resolved vs no route
- Decide:
  - whether to go to network-diagnosis or service-recovery

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given any “cannot connect” report, you can:
  - identify which layer is broken
  - prove it using inspection commands
- You can:
  - fix a local connectivity issue
  - or prove the problem is not local
- You do not:
  - change firewall, routes, or configs blindly
  - assume “network problem” without evidence

Concrete tests:

- You can:
  - explain the difference between:
    - no route
    - no DNS
    - no listener
    - blocked port
  - isolate each case in under a few minutes

---

## 🔁 Regression Rule

If later you:

- guess at firewall or routing changes
- restart services when the network is the issue
- cannot explain where packets stop

You must:

> Return here and re-run `networking.md` until layer-by-layer isolation is automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Always isolate by layer: interface → address → route → DNS → service.**

---

## 🧱 This Block Enables

- Reliable service reachability diagnosis
- Correct use of network vs service playbooks
- Almost all distributed-system troubleshooting

Without this block, **you will fix the wrong thing first**.

---
