# 🧰 Operator Playbook — Scenario 3: “Service Is Down”

**Primary domain:** Process & Service Failures  
**Domain playbook:** core/domain-playbooks/process-and-service-failures-playbook.md  
**Why this domain:** The incident is about service lifecycle, supervision, or dependency failure rather than resource pressure.

---

## 🎯 Situation

> “The web app isn’t responding.”  
> “The API is down.”  
> “Users are getting connection errors.”

Your job is to determine, in order:

- Is the service running?
- If not, why not?
- Is it crashing?
- Is it being restarted?
- Is this a **service manager problem** or a **process problem**?

---

## 🧠 Core Mental Model

A “service” is:

- a **policy** (systemd unit, supervisor, etc)
- that **manages one or more processes**

So failure can exist at **three layers**:

1. The **service definition** layer (systemd)
2. The **process** layer (the actual program)
3. The **dependency / environment** layer (ports, files, disk, memory, network)

Never guess which one. Always prove it.

---

## 🧭 Operator Phases

1. Identify the service
2. Check service state
3. Check recent failures and logs
4. Check the process reality
5. Decide: service problem or process problem
6. Fix the cause, not the symptom
7. Verify stability

---

## 🥇 Phase 1 — Identify the Service

If you don’t know the unit name yet:

    systemctl list-units --type=service | grep -i <name>

Or:

    systemctl status

---

## 🥈 Phase 2 — Check Service State (Ground Truth)

    systemctl status <service>

Interpretation:

- active (running) → service manager thinks it’s up
- inactive (dead) → not running
- failed → crashed or failed to start
- activating / deactivating → stuck or flapping

Key questions:

- Is it **enabled**?
- Is it **failed**?
- Is it **restarting repeatedly**?

---

## 🥉 Phase 3 — Check Recent Failures and Logs

    journalctl -u <service> --since "10 minutes ago"

Or:

    journalctl -u <service> -n 100 --no-pager

Look for:

- crash messages
- permission errors
- missing files
- port bind errors
- config parse errors
- OOM kills
- dependency failures

---

## 🏃 Phase 4 — Check the Process Reality

Even if systemd says “running”, verify:

    ps aux | grep <binary-name>

Or:

    pgrep -a <binary>

Or:

    ss -lntup | grep <port>

Questions:

- Is the process actually running?
- Is it listening on the expected port?
- Is it stuck / zombied / defunct?

---

## 🧪 Phase 5 — Is It Crashing or Being Restarted?

    systemctl show <service> -p Restart,RestartSec,StartLimitIntervalUSec,StartLimitBurst

And:

    journalctl -u <service> | tail -n 200

If you see:

- repeated start → crash → start → crash loops  
Then:

👉 The service is **failing at runtime**, not “down”.

---

## 🧱 Phase 6 — Service Problem vs Process Problem

### It is a **service problem** if:

- systemd cannot start it
- unit file is wrong
- permissions / paths / dependencies are wrong
- environment variables are missing
- ExecStart is wrong

### It is a **process problem** if:

- binary starts but crashes
- binary hangs
- binary consumes all memory/CPU
- binary fails internally

---

## 🔍 Phase 7 — Check External Killers

Always check:

OOM killer:

    journalctl -k | grep -i oom

Disk full:

    df -h

Port conflict:

    ss -lntup

Permissions:

    ls -l <paths>

---

## 🧠 Decision Matrix

| What you see | What it means | What you do |
|---------------|---------------|-------------|
| systemctl says inactive/failed | Service not running | Read journal, fix start failure |
| Restart loop | Crashing on startup | Read logs, fix root cause |
| systemctl says running but no process | Manager is confused or fork issue | Inspect unit type, check ExecStart |
| Process running but not listening | App misconfigured or hung | Check config, logs, health |
| Process dies repeatedly | Runtime crash | Debug app or environment |
| OOM kill messages | Memory limit or leak | Fix memory or limits |

---

## ⚠️ The Golden Rule

Never “just restart it” without answering:

> Why did it stop or fail in the first place?

Restarting without diagnosis hides real problems.

---

## 🧠 The One-Sentence Operator Summary

> “When a service is down, first determine whether the service manager failed to start it or the process failed to stay alive — then fix the layer that is actually broken.”

---

## 🧪 Muscle Memory Commands

    systemctl status <service>
    journalctl -u <service>
    ps aux | grep <name>
    ss -lntup
    systemctl show <service> -p Restart,RestartSec
    journalctl -k | grep -i oom
    df -h

---

## 🏁 Outcome

You can now reliably determine:

- Is it a service problem?
- Is it a process problem?
- Is it a resource or dependency problem?
- And fix the **real cause**, not just the symptom.

That is real operator behavior.

---
