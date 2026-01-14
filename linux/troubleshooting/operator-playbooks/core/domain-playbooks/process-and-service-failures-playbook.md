# 🔁 Process & Service Failures — Operator Playbook

**Domain:** Process lifecycle, supervision, and service management  
**Mental mode:** Control loops and ownership, not “a single process”  
**Goal:** Understand why processes start, stop, respawn, or refuse to die

---

## 📌 What This Domain Actually Covers

This domain is about:

- Who **owns** a process
- Who **restarts** it
- Why it **won’t die**
- Why it **keeps coming back**
- Why it is **stuck**, **zombie**, or **orphaned**

Most operators think:

> “That process is misbehaving.”

But the real question is:

> “What control loop is managing this process?”

---

## 🧠 The Mental Model

In modern systems:

- Very few important processes are standalone
- Most are managed by:
  - systemd
  - a supervisor
  - Kubernetes
  - a watchdog
  - a cron job
  - or a shell loop

So:

> Killing the process is often **fighting the control plane**.

---

## 🔥 Primary Fast Signals

Run these immediately:

    ps -ef
    ps -eo pid,ppid,stat,cmd | head
    systemctl status <service>
    systemctl list-units --failed
    journalctl -xe

Interpretation:

- Look for:
  - rapid restarts
  - crash loops
  - parent process IDs
  - zombie processes (`Z`)
  - uninterruptible (`D`) processes
- `systemctl status` tells you:
  - restart policy
  - recent failures
  - last exit code

---

## 🧭 Common Failure Patterns

### 1) Crash loop

- Process exits
- Supervisor restarts it
- Repeats forever

You see:
- High restart count
- Logs repeating the same failure

### 2) “Process won’t die”

- You `kill -9` it
- It stays

Causes:
- It is in `D` state (IO wait)
- Or it is instantly respawned

### 3) Zombie process

- State `Z`
- Already dead
- Parent has not reaped it

Only the **parent** can clean it up.

### 4) Orphaned process

- Parent died
- Reparented to PID 1
- Often harmless, sometimes not

---

## 🧪 Deep Inspection Commands

### Process tree

    pstree -ap
    ps -eo pid,ppid,stat,cmd --forest

### Signals and states

    ps -o pid,stat,cmd -p <pid>

States:
- `R` = running
- `S` = sleeping
- `D` = uninterruptible (usually IO)
- `Z` = zombie

### systemd behavior

    systemctl cat <service>
    systemctl show <service> | grep Restart

Look for:
- `Restart=always`
- `Restart=on-failure`

---

## 🧯 Root Cause Classes

1. **Bad configuration**
   - Service fails instantly
   - Supervisor restarts it

2. **Missing dependencies**
   - DB not up
   - Network not ready
   - Filesystem not mounted

3. **Resource failure**
   - Memory OOM
   - Disk full
   - IO blocked

4. **Control loop fights**
   - You kill it
   - The orchestrator restarts it

5. **Kernel stuck tasks**
   - `D` state
   - Cannot be killed

---

## 🛑 Stabilization Actions (In Order)

1. **Identify the owner**

        ps -o pid,ppid,cmd -p <pid>

2. **Check supervisor**

        systemctl status <service>

3. **Stop the control loop**

        systemctl stop <service>

Or in Kubernetes:
- Scale to zero
- Or delete the pod controller

4. **Then fix the root cause**
   - Config
   - Dependency
   - Resource issue

---

## ⚠️ Dangerous Misinterpretations

- “kill -9 didn’t work, Linux is broken”
  - The process is either stuck in kernel or being respawned.

- “Why does it keep coming back?”
  - Because that is literally what supervisors do.

- “Just reboot it”
  - Reboot hides the control-plane problem.

---

## 🧨 When This Becomes Systemic

You will see:

- Restart storms
- Log floods
- CPU or IO amplification
- Cascading failures

At this point:

> The control system is unstable, not just the process.

---

## 🧱 Escalation Criteria

Escalate or drain the node if:

- You have many stuck `D` state tasks
- systemd itself is unhealthy
- Core services cannot be controlled
- You cannot stop restart storms

In Kubernetes:

> Scale down or remove the controller. Then fix the cause.

---

## 🧠 Canonical Summary

- Processes almost always have **owners**
- Killing a process does not remove its **control loop**
- Always ask:
  > “Who is responsible for keeping this process alive?”

---

## 🧭 This Domain Explains These Scenarios

- “Service keeps restarting”
- “Process won’t die”
- “Why did it come back?”
- “Zombie processes”
- “Crash loops”

All of these reduce to:

> A control system is managing the process lifecycle.

---
