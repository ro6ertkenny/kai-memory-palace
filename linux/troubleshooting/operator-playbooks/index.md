# 🧭 Operator Playbooks — Index
*The authoritative navigation map for incident playbook drills*

---

## 📌 Purpose

This index makes the playbooks:

- easy to drill
- easy to find under pressure
- easy to keep clean (no duplicates / no bloat)

This is a **training system**, not a folder of notes.

---

## 🧠 Operator Rule Zero

Symptoms first.  
Evidence second.  
Action last.  
Verification always.

---

## 🧰 Start Here Every Time

### ✅ Scenario 0 — Universal Triage (entry point to every incident)
- `core/scenario-0-triage-playbook.md`

If you don’t know what class of failure you’re seeing (CPU, memory, disk, service, network, permissions, time), you start here.

---

## ✅ Core Playbooks
*Daily drills — high-frequency failure patterns you should execute without hesitation*

Recommended drill order:

1) `core/scenario-0-triage-playbook.md`  
   Universal triage: classify the incident before you act.

2) `core/scenario-1-system-feels-slow.md`  
   Global slowness triage: prove CPU vs memory vs disk vs I/O vs “one bad process.”

3) `core/scenario-2-disk-full.md`  
   Space vs inodes, find the offender, fix without breaking the system.

4) `core/scenario-3-service-is-down.md`  
   Service vs process vs dependency; confirm status; read logs; verify MainPID.

5) `core/scenario-4-process-wont-die.md`  
   Job vs PID; signals; D-state recognition; safe escalation.

6) `core/scenario-5-cpu-pegged.md`  
   Identify culprit; decide expected vs runaway; choose the smallest safe action.

7) `core/scenario-6-memory-growth-leak.md`  
   Memory creep: prove pressure vs “usage”; identify RSS growth; watch swap/PSI/OOM signals.

8) `core/scenario-7-inodes-exhausted.md`  
   Disk “looks fine” but writes fail: inode exhaustion workflow.

9) `core/scenario-8-permission-denied-but-looks-correct.md`  
   Permissions denied: identity + path + mount + ACL/caps/SELinux/AppArmor checks (as applicable).

10) `core/scenario-9-dns-or-networking-intermittent.md`  
   Intermittent failures: DNS caching, resolver config, routing, packet loss, and evidence-first isolation.

11) `core/scenario-10-service-crash-loop.md`  
   Restart loops: systemd restart policy, logs, exit codes, dependency failures, resource ceilings.

12) `core/scenario-11-disk-full-deleted-open-files.md`  
   Deleted-but-open files: why space doesn’t return; find handles; recover safely.

13) `core/scenario-12-io-wait-slowness.md`  
   I/O wait: prove it with signals; find the device/process; decide safe mitigation.

14) `core/scenario-13-time-skew-breaks-everything.md`  
   Time skew: TLS/certs/auth breakage; verify NTP; fix clock safely.

Core is intentionally capped and refined over time.

---

## 🧠 Advanced Playbooks
*Reference scenarios — rarer, specialized, or environment-specific patterns*

- `advanced/` (currently empty or in-progress)

Advanced is allowed to grow, but must remain indexed and non-duplicative.

---

## 🧱 Anti-Bloat Policy (enforced)

A new playbook must answer:

- What unique failure pattern does this teach?
- What decision does it train that no other playbook trains?

If the answer is “none,” we merge it into an existing scenario.

---

## ✅ Outcome

If you can run the Core playbooks calmly and correctly:

You are no longer “running Linux commands.”  
You are operating a Linux system.

EOF

