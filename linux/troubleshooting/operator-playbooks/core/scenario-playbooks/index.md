# 🧭 Scenario Playbooks — Index
*Symptom-driven entry points that route into operator physics (domain playbooks)*

---

## 📌 Purpose

This directory contains **scenario playbooks**: symptom-first operator guides that help you:

1) **Instrument**
2) **Classify**
3) **Route** to the correct **domain playbook**
4) Stabilize and verify

Scenario playbooks are **not** “physics.”
They are the **front door**.

**Start here:**
- Scenario 0 is the universal router and should be used first.

---

## 🧠 Operator Rule

> Instrument → Classify → Domain (physics) → Scenario (symptom path) → Verify

Do not skip classification.
Do not guess.

---

## 🧱 Canonical Domain Set (Physics Targets)

These scenarios route into the 7 failure domains:

- Memory Pressure
- CPU Pressure
- IO Pressure
- Disk Exhaustion
- Process & Service Failures
- Network & DNS Failures
- Time & Clock Failures

Domain playbooks live in:

- `../domain-playbooks/`

---

## ✅ Scenario Inventory (Ordered)

### 🧭 Scenario 0 — Universal Triage (Domain Classification Router)
**File:** `scenario-0-universal-triage-domain-router.md`  
**Use when:** Always first. Classify the incident into one of the 7 domains.  
**Routes to:** The correct domain playbook.

---

### 🧰 Scenario 1 — System Feels Slow
**File:** `scenario-1-system-feels-slow.md`  
**Use when:** “Everything feels slow” (unknown cause).  
**Routes to:** CPU / Memory / IO / Disk / Network (depending on evidence).

---

### 💽 Scenario 2 — Disk Is Full (No space left on device)
**File:** `scenario-2-disk-is-full.md`  
**Use when:** Writes fail, package installs fail, logs stop, ENOSPC.  
**Routes to:** Disk Exhaustion domain playbook (blocks/inodes/deleted-open).

---

### 🧯 Scenario 3 — Service Is Down
**File:** `scenario-3-service-is-down.md`  
**Use when:** “The service isn’t responding” / “the API is down.”  
**Routes to:** Process & Service Failures (often reveals Disk/Memory/Port root cause).

---

### ☠️ Scenario 4 — Process Won’t Die
**File:** `scenario-4-process-wont-die.md`  
**Use when:** kill / kill -9 does not remove the process.  
**Routes to:** Process & Service Failures or IO Pressure (D-state).

---

### 🧮 Scenario 5 — CPU Pegged
**File:** `scenario-5-cpu-pegged.md`  
**Use when:** CPU “at 100%”, load high, laggy system.  
**Routes to:** CPU Pressure domain playbook.

---

### 🧠 Scenario 6 — Memory Growth / Leak
**File:** `scenario-6-memory-growth-leak.md`  
**Use when:** memory increases steadily, OOM risk, creeping slowness.  
**Routes to:** Memory Pressure domain playbook.

---

### 🧱 Scenario 7 — Inodes Exhausted
**File:** `scenario-7-inodes-exhausted.md`  
**Use when:** ENOSPC but `df -h` shows space available.  
**Routes to:** Disk Exhaustion domain playbook (inode failure).

---

### 🚫 Scenario 8 — Permission Denied But Looks Correct
**File:** `scenario-8-permission-denied-but-looks-correct.md`  
**Use when:** perms look right but access fails (services, scripts, containers).  
**Routes to:** Process & Service Failures (context/identity/mount flags/SELinux).

---

### 🌐 Scenario 9 — DNS or Networking Intermittent
**File:** `scenario-9-dns-or-networking-intermittent.md`  
**Use when:** “Sometimes it works”, timeouts, partial connectivity.  
**Routes to:** Network & DNS Failures domain playbook.

---

### 🔁 Scenario 10 — Service Crash Loop
**File:** `scenario-10-service-crash-loop.md`  
**Use when:** systemd auto-restart loops / CrashLoopBackOff.  
**Routes to:** Process & Service Failures domain playbook.

---

### 🧾 Scenario 11 — Disk Full After Deleting Files (Deleted-but-Open)
**File:** `scenario-11-disk-full-deleted-but-open.md`  
**Use when:** `df` stays full after deleting files; `du` doesn’t explain usage.  
**Routes to:** Disk Exhaustion domain playbook.

---

### ⏳ Scenario 12 — IO Wait Slowness
**File:** `scenario-12-io-wait-slowness.md`  
**Use when:** CPU not high but system “hangs” / high `%wa` / stalled commands.  
**Routes to:** IO Pressure domain playbook.

---

### ⏱️ Scenario 13 — Time Skew Breaks Everything
**File:** `scenario-13-time-skew-breaks-everything.md`  
**Use when:** TLS “not yet valid/expired”, tokens rejected, logs out of order.  
**Routes to:** Time & Clock Failures domain playbook.

---

## 🔁 Standard Usage Flow

1) Start with:

- `scenario-0-universal-triage-domain-router.md`

2) Classify into a domain.
3) Open the domain playbook and follow it.
4) If needed, return to the relevant scenario playbook for symptom-specific workflow.
5) Verify exit criteria and restore stability.

---

## ✅ Repository Hygiene Rules

- Scenario playbooks stay **short and symptom-oriented**
- Domain playbooks stay **small, stable, physics-oriented**
- If a scenario grows into “physics”, move the physics into the domain playbook
- Keep file names stable to avoid breaking links and operator muscle memory

---
