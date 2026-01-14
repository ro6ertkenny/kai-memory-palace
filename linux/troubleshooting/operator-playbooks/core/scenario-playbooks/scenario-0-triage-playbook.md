# 🧭 Scenario 0 — Universal Triage (Domain Classification Router)

**Type:** Meta-scenario (always first)  
**Mental mode:** Classification before action  
**Goal:** Route the incident into the correct **failure domain** before you do anything else

---

## 🎯 What This Playbook Is

This is **not** a troubleshooting guide.

This is a **classification router**.

Its only job is to answer:

> “Which **domain of failure** am I in?”

Once you know that, you stop guessing and switch to **physics**.

---

## 🧠 Operator Rule Zero

Symptoms first.  
Classification second.  
Evidence third.  
Action last.  
Verification always.

If you skip classification, you are guessing.

---

## 🧱 The 7 Canonical Failure Domains

All Linux production incidents reduce to one of these:

1. **Memory Pressure**  
   core/domain-playbooks/memory-pressure-playbook.md

2. **CPU Pressure**  
   core/domain-playbooks/cpu-pressure-playbook.md

3. **IO Pressure**  
   core/domain-playbooks/io-pressure-playbook.md

4. **Disk Exhaustion (Space/Inodes)**  
   core/domain-playbooks/disk-exhaustion-playbook.md

5. **Process & Service Failures**  
   core/domain-playbooks/process-and-service-failures-playbook.md

6. **Network & DNS Failures**  
   core/domain-playbooks/network-and-dns-failures-playbook.md

7. **Time & Clock Failures**  
   core/domain-playbooks/time-and-clock-failures-playbook.md

Your first job is **not** to fix.

Your first job is:

> Put the incident in the correct bucket.

---

## 🚦 The Instrument Panel (Minimal, High-Signal)

This replaces the old “if X then Y” checklist.

Run these first:

    uptime
    vmstat 1
    free -h
    df -h
    df -i
    ps -eo pid,stat,cmd | head
    cat /proc/pressure/memory
    cat /proc/pressure/cpu
    cat /proc/pressure/io

This gives you:

- scheduler pressure
- memory pressure
- IO pressure
- disk exhaustion
- process states

In one view.

---

## 🧭 Domain Routing Guide

### 🧠 Memory Pressure

Route here if you see:

- Swap activity or reclaim
- OOM kills
- PSI memory non-zero
- “Things freeze under load”

Then:

> core/domain-playbooks/memory-pressure-playbook.md

---

### 🧮 CPU Pressure

Route here if you see:

- High load relative to cores
- High `vmstat r`
- PSI CPU non-zero
- System feels laggy but not frozen

Then:

> core/domain-playbooks/cpu-pressure-playbook.md

---

### 💽 IO Pressure

Route here if you see:

- Processes in `D` state
- Commands hanging
- PSI IO non-zero
- High load with low CPU
- Obvious storage latency

Then:

> core/domain-playbooks/io-pressure-playbook.md

---

### 🧱 Disk Exhaustion

Route here if you see:

- “No space left on device”
- `df -h` or `df -i` at 100%
- Filesystem read-only
- Writes failing immediately

Then:

> core/domain-playbooks/disk-exhaustion-playbook.md

---

### 🔁 Process & Service Failures

Route here if you see:

- Services crash looping
- Process “won’t die”
- Zombies or orphans
- Things restarting unexpectedly

Then:

> core/domain-playbooks/process-and-service-failures-playbook.md

---

### 🌐 Network & DNS Failures

Route here if you see:

- Timeouts
- “Sometimes it works”
- Works with IP but not hostname
- Only some nodes affected

Then:

> core/domain-playbooks/network-and-dns-failures-playbook.md

---

### ⏱️ Time & Clock Failures

Route here if you see:

- TLS “not yet valid” or “expired”
- Auth tokens rejected immediately
- Logs out of order
- Works on one node but not another
- Things broke after reboot

Then:

> core/domain-playbooks/time-and-clock-failures-playbook.md

---

## ⚠️ Important Rules

- Do **not** start with a scenario playbook.
- Do **not** start with random commands.
- Do **not** guess the fix.

Always:

> Instrument → Classify → Domain → Then Scenario.

---

## 🧨 If More Than One Domain Looks Possible

Pick the **dominant blocking factor**:

- If tasks are in `D` state, it is IO, even if memory is high.
- If the filesystem is full, it is Disk, even if CPU is high.
- If the node is swapping, it is Memory, even if CPU is high.
- If TLS/auth is broken, check Time before anything else.

Start with the **hard blocker**.

---

## 🏁 Success Condition

You are done with Scenario 0 when:

> You can say, confidently:  
> “This is a **<domain>** problem.”

At that point:

> Stop.  
> Open the domain playbook.  
> Follow physics.

---
