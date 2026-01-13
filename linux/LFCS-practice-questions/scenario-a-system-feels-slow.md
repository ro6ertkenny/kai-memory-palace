# 🧠 Scenario A — The System Feels Slow

## 📍 Symptom

A user says:

“Everything is laggy.”

No other information is provided.

---

## 🎯 Goal

Decide whether the problem is:

- CPU pressure
- memory pressure
- disk / inode pressure
- or one bad process

And identify **where to look next** before touching anything.

---

## 🧭 Operator Rule

> **Global signals first. Local causes second. Action last.**

---

## 🧪 Step 1 — Global Triage Snapshot

Run these in order:

    uptime
    free -h
    df -h
    df -i

Interpretation:

- uptime
  - Look at load average vs CPU cores.
  - If load >> cores → runnable or I/O pressure.

- free -h
  - Look at “available”, not “free”.
  - If available is very low → memory pressure.

- df -h
  - Check if any filesystem is near 100%.

- df -i
  - Check if any filesystem is out of inodes.

If any of these show a hard limit being hit, **that is your primary axis**.

---

## 🔎 Step 2 — Find Top Consumers

Run:

    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

Interpretation:

- Identify:
  - which process is using the most CPU
  - which process is using the most memory
- Note:
  - owner
  - runtime
  - command

---

## 🧠 Step 3 — Decide What You Are Looking At

Use this decision table:

- If load is high:
  - Is CPU pegged?
  - Or are processes stuck in I/O?

- If memory available is low:
  - Find the top RSS consumer.
  - Decide if it is expected.

- If disk or inodes are full:
  - This is a storage incident.
  - Switch to the disk-full playbook.

- If one process dominates:
  - Inspect it before acting.
  - Who owns it?
  - Why is it running?
  - Is it managed by a service?

---

## ⚠️ Forbidden Actions

- Do not kill anything yet.
- Do not restart anything yet.
- Do not delete anything yet.

You are still **in diagnosis mode**.

---

## ✅ Success Criteria

You can say:

- Which resource axis is under pressure
- Which process or subsystem is responsible
- What your next investigation step is
- Why that step is correct

---

## 🏁 Operator Loop (Reinforced)

Symptom → Triage → Identify → Inspect → Decide → Act → Verify

Never skip steps.
EOF

