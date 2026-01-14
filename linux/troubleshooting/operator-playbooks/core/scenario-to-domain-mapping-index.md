# 🧭 Scenario → Domain Mapping Index
*An authoritative crosswalk from concrete incidents (scenarios) to the underlying failure physics (domains)*

---

## 🎯 Purpose

This index maps **scenario playbooks** (symptoms) to **domain playbooks** (physics).

Use it to:

- route faster under pressure
- prevent misdiagnosis (CPU vs IO vs memory confusion)
- keep scenarios non-duplicative
- ensure every scenario has a single “source of truth” domain

Rule:

> Every scenario should map to **one primary domain**.

Secondary influences are allowed, but the scenario must have a single dominant domain.

---

## 🧠 Mental Model

- **Domain playbooks = physics**
  - classification, differentiation, stabilization

- **Scenario playbooks = symptoms**
  - concrete incident patterns
  - domain is the destination

Flow:

Scenario → Domain → Evidence → Action → Verification

---

## ✅ Core Scenarios → Domains

### 🧭 Scenario 0 — Universal Triage (Router)
**Scenario:** core/scenario-playbooks/scenario-0-triage-playbook.md  
**Domain:** N/A (router into all domains)

---

### 🐢 Scenario 1 — System Feels Slow
**Scenario:** core/scenario-playbooks/scenario-1-system-feels-slow.md  
**Primary domain:** Depends (classification scenario)

Routes into:
- Memory Pressure
- CPU Pressure
- IO Pressure
- Disk Exhaustion
- Process & Service Failures
- Network & DNS Failures
- Time & Clock Failures

---

### 🧱 Scenario 2 — Disk Full
**Scenario:** core/scenario-playbooks/scenario-2-disk-full.md  
**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md

---

### 🧯 Scenario 3 — Service Is Down
**Scenario:** core/scenario-playbooks/scenario-3-service-is-down.md  
**Primary domain:** Process & Service Failures  
**Domain playbook:** core/domain-playbooks/process-and-service-failures-playbook.md

---

### 🪓 Scenario 4 — Process Won’t Die
**Scenario:** core/scenario-playbooks/scenario-4-process-wont-die.md  
**Primary domain:** Process & Service Failures  
**Domain playbook:** core/domain-playbooks/process-and-service-failures-playbook.md

Note:
- If the process is `D` state, route to IO Pressure for root cause.

---

### 🧮 Scenario 5 — CPU Pegged
**Scenario:** core/scenario-playbooks/scenario-5-cpu-pegged.md  
**Primary domain:** CPU Pressure  
**Domain playbook:** core/domain-playbooks/cpu-pressure-playbook.md

---

### 🧠 Scenario 6 — Memory Growth / Leak
**Scenario:** core/scenario-playbooks/scenario-6-memory-growth-leak.md  
**Primary domain:** Memory Pressure  
**Domain playbook:** core/domain-playbooks/memory-pressure-playbook.md

---

### 🧷 Scenario 7 — Inodes Exhausted
**Scenario:** core/scenario-playbooks/scenario-7-inodes-exhausted.md  
**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md

---

### 🔒 Scenario 8 — Permission Denied But Looks Correct
**Scenario:** core/scenario-playbooks/scenario-8-permission-denied-but-looks-correct.md  
**Primary domain:** Process & Service Failures (execution/identity constraints)

Note:
This scenario is “constraints and identity” rather than a pure resource domain.
Keep it in core scenarios because it is high-frequency.

Recommended domain association:
- Primary: Process & Service Failures (ownership, identity, execution path)
- Secondary: Disk (mount flags), Security controls (LSM), Filesystem ACLs/caps

---

### 🌐 Scenario 9 — DNS or Networking Intermittent
**Scenario:** core/scenario-playbooks/scenario-9-dns-or-networking-intermittent.md  
**Primary domain:** Network & DNS Failures  
**Domain playbook:** core/domain-playbooks/network-and-dns-failures-playbook.md

---

### 🔁 Scenario 10 — Service Crash Loop
**Scenario:** core/scenario-playbooks/scenario-10-service-crash-loop.md  
**Primary domain:** Process & Service Failures  
**Domain playbook:** core/domain-playbooks/process-and-service-failures-playbook.md

Note:
- Root cause may be memory pressure, disk exhaustion, IO pressure, or network failures.
- The lifecycle control loop belongs to this domain.

---

### 🗑️ Scenario 11 — Disk Full After Deleting Files (Deleted-but-Open)
**Scenario:** core/scenario-playbooks/scenario-11-disk-full-deleted-open-files.md  
**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md

---

### 💽 Scenario 12 — IO Wait Slowness
**Scenario:** core/scenario-playbooks/scenario-12-io-wait-slowness.md  
**Primary domain:** IO Pressure  
**Domain playbook:** core/domain-playbooks/io-pressure-playbook.md

---

### ⏱️ Scenario 13 — Time Skew Breaks Everything
**Scenario:** core/scenario-playbooks/scenario-13-time-skew-breaks-everything.md  
**Primary domain:** Time & Clock Failures  
**Domain playbook:** core/domain-playbooks/time-and-clock-failures-playbook.md

---

## 🧠 Domain → Scenario Reverse Map (Core)

### 🧠 Memory Pressure
- scenario-6-memory-growth-leak.md
- scenario-1-system-feels-slow.md (classification)

### 🧮 CPU Pressure
- scenario-5-cpu-pegged.md
- scenario-1-system-feels-slow.md (classification)

### 💽 IO Pressure
- scenario-12-io-wait-slowness.md
- scenario-1-system-feels-slow.md (classification)

### 🧱 Disk Exhaustion
- scenario-2-disk-full.md
- scenario-7-inodes-exhausted.md
- scenario-11-disk-full-deleted-open-files.md
- scenario-1-system-feels-slow.md (classification)

### 🔁 Process & Service Failures
- scenario-3-service-is-down.md
- scenario-4-process-wont-die.md
- scenario-10-service-crash-loop.md
- scenario-8-permission-denied-but-looks-correct.md
- scenario-1-system-feels-slow.md (classification)

### 🌐 Network & DNS Failures
- scenario-9-dns-or-networking-intermittent.md
- scenario-1-system-feels-slow.md (classification)

### ⏱️ Time & Clock Failures
- scenario-13-time-skew-breaks-everything.md
- scenario-1-system-feels-slow.md (classification)

---

## 🧱 Anti-Bloat Rule (Mapping Enforcement)

A scenario may exist only if it teaches:

- a unique failure pattern
- a unique decision point
- a unique safe stabilization sequence

Otherwise:

> Merge it into an existing scenario and keep the mapping clean.

---
