# ⏱️ Time & Clock Failures — Operator Playbook

**Domain:** System time, monotonic time, and clock synchronization  
**Mental mode:** Causality and trust, not “just the current time”  
**Goal:** Determine whether time is consistent, monotonic, and trusted across systems

---

## 📌 What This Domain Actually Covers

This domain is about:

- Is the system clock **correct**?
- Is it **monotonic**?
- Is it **synchronized** with peers?
- Do certificates, tokens, and logs **agree on time**?

Time failures do not usually look like “time problems”.

They look like:

- TLS failures
- Authentication failures
- Expired tokens
- “Works on one node but not another”
- Distributed systems behaving irrationally

---

## 🧠 The Mental Model

Modern systems rely on time for:

- TLS certificate validity
- Token expiry (JWT, Kerberos, OAuth)
- Log ordering
- Cache expiry
- Consensus and coordination

If clocks disagree:

> Systems cannot agree on **causality** or **trust**.

---

## 🔥 Primary Fast Signals

Run these immediately:

    date
    timedatectl
    chronyc tracking || ntpq -p
    hwclock -r

Interpretation:

- `date` vs reality: obviously wrong?
- `timedatectl`:
  - Is NTP enabled?
  - Is the clock synchronized?
- `chronyc` / `ntpq`:
  - Are we in sync?
  - What is the offset?
- `hwclock`:
  - Is hardware clock wildly different?

---

## 🧭 Differentiation: Time vs Network vs Auth

### Looks like time failure if:

- TLS says “not yet valid” or “expired”
- Tokens are rejected immediately
- Logs from different nodes are out of order
- Things break across restarts or reboots
- One node works, another fails

### Looks like network failure instead if:

- Connections time out
- DNS fails
- Packets are dropped

### Looks like auth misconfig instead if:

- Only one service fails
- Errors are consistent and deterministic

---

## 🧪 Deep Inspection Commands

### Check offsets

    chronyc sources
    chronyc tracking

Or:

    ntpq -p

### Check time jump history

    journalctl | grep -i time
    dmesg | grep -i clock

### Check monotonic vs realtime drift (rare but nasty)

    cat /proc/timer_list

---

## 🧯 Common Root Cause Classes

1. **NTP not running or blocked**
   - Firewall blocking NTP
   - Service disabled
   - Misconfigured time source

2. **VM / hardware clock drift**
   - Bad host clock
   - Suspended VMs
   - Broken RTC

3. **Large time steps**
   - Manual `date` changes
   - NTP stepping time aggressively

4. **Mixed time sources**
   - Some nodes using chrony, some not
   - Some synced, some drifting

5. **Leap second or time sync bugs**
   - Rare, but catastrophic when they happen

---

## 🛑 Stabilization Actions (In Order)

1. **Check sync status**

        timedatectl
        chronyc tracking || ntpq -p

2. **Force resync if needed**

        chronyc makestep

3. **Verify firewall allows NTP**
   - UDP 123

4. **Check hardware clock sanity**

        hwclock -r

5. **If cluster**
   - Compare time across nodes

---

## ⚠️ Dangerous Misinterpretations

- “TLS is broken”
  - Often the clock is wrong.

- “Auth is down”
  - Often tokens are not valid *yet* or *anymore*.

- “It fixed itself after reboot”
  - Reboot reset the clock or resynced NTP.

---

## 🧨 When Time Failures Become Systemic

You will see:

- Widespread TLS failures
- Distributed systems losing quorum
- Databases refusing replication
- Caches misbehaving
- Logs becoming useless

At this point:

> The system no longer agrees on **reality**.

---

## 🧱 Escalation Criteria

Escalate or drain the node if:

- Clock cannot be synchronized
- Time jumps repeatedly
- TLS/auth failures are widespread
- The node disagrees with the cluster on time

In Kubernetes:

> Drain the node. Time skew breaks distributed systems.

---

## 🧠 Canonical Summary

- Time is part of **trust**
- Clock skew breaks **security and coordination**
- Always ask:
  > “Do these systems agree on what time it is?”

---

## 🧭 This Domain Explains These Scenarios

- “TLS certificate not yet valid”
- “Auth tokens always expired”
- “Works on one node but not another”
- “Everything broke after reboot”
- “Logs don’t make sense”

All of these reduce to:

> The system’s sense of time is wrong or inconsistent.

---
