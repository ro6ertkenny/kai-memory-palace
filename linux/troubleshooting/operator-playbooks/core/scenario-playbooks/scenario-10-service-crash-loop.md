# 🧰 Operator Playbook — Scenario 10: “Service Crash Loop”

**Primary domain:** Process & Service Failures  
**Domain playbook:** core/domain-playbooks/process-and-service-failures-playbook.md  
**Why this domain:** The incident is about service lifecycle control loops and supervision, even if the root cause is a resource failure.

---

## 🎯 The Symptom

- Service keeps restarting
- systemctl status shows:
  - “activating (auto-restart)”
  - “failed” → “starting” → “failed” → repeat
- The service never stays up
- CPU / logs may spike
- In Kubernetes: CrashLoopBackOff

---

## 🧠 The Critical Mental Model

> A restart loop is **not the problem**.  
> The restart loop is the **symptom** of a failing program.

systemd is doing its job:

- The service exits
- systemd restarts it
- It exits again
- Repeat

Your job:

> **Find the first real error that caused the process to exit.**

---

## 🧪 Phase 1 — Confirm It’s Actually Restarting

    systemctl status servicename --no-pager
    systemctl is-active servicename

Look for:

- “auto-restart”
- “failed”
- Rapid restarts
- Increasing restart counter

---

## 🧾 Phase 2 — Read the Logs (Always First)

    sudo journalctl -u servicename -n 100 --no-pager

Or:

    sudo journalctl -u servicename -b --no-pager

You are looking for:

- The **first fatal error**
- Config parse errors
- Missing files
- Permission denied
- Port already in use
- Dependency failures
- OOM kills
- Segfaults / panics

> Never restart blindly. The log already knows why it’s dying.

---

## 🧠 Phase 3 — Inspect the Service Definition

    systemctl cat servicename

Check:

- ExecStart=
- User=
- WorkingDirectory=
- Environment=
- Restart= policy

Common bugs:

- Wrong path in ExecStart
- Missing env vars
- Running as wrong user
- Bad working directory
- Refers to files that don’t exist

---

## 🔍 Phase 4 — Try Running It Manually

Take the ExecStart command and run it directly:

    /path/to/binary --with --args

Or:

    sudo -u serviceuser /path/to/binary ...

If it fails:

- You will usually see the **real error immediately**

---

## 🧱 Phase 5 — Check for Dependency Failures

Common causes:

- Port already in use:

    ss -lntp
    ss -lunp

- Missing files:

    ls -l /path/to/config
    ls -l /path/to/data

- Permission denied:

    namei -l /path/to/file

- Database or network dependency is down

---

## 💀 Phase 6 — Check for OOM Kills or Signals

    dmesg | egrep -i "oom|killed|out of memory"

Or:

    sudo journalctl -k | egrep -i "oom|killed"

If you see OOM:

- This is not an app bug
- This is a **memory limit / memory usage problem**

---

## 🧯 Phase 7 — Understand the Restart Policy

    systemctl show -p Restart,RestartSec,StartLimitIntervalUSec,StartLimitBurst servicename

If:

- Restart=always
- Restart=on-failure

Then:

> Killing the process will never fix it. The supervisor will bring it back.

---

## 🛑 Phase 8 — Stop the Loop (If Needed)

If the loop is noisy or dangerous:

    sudo systemctl stop servicename

Then debug in peace.

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| Config error in logs | Bad config | Fix config |
| Permission denied | Wrong user/ownership | Fix permissions |
| Port already in use | Conflict | Stop other service or change port |
| Missing file | Bad path or missing data | Fix paths / restore file |
| OOM kill | Memory limit or leak | Fix memory usage or limits |
| Segfault / panic | App bug | Debug or upgrade app |
| Dependency down | Ordering or availability | Fix dependency |

---

## ⚠️ Operator Warnings

- Restart loops **hide the real error** if you don’t read logs.
- Never keep restarting hoping it fixes itself.
- The **first failure** is the important one.

---

## 🏁 The Operator Rule

> The supervisor is not the problem. The crashing process is.

---

## 🧠 One-Sentence Operator Summary

> “When a service is crash looping, stop it, read the logs, run the binary by hand, and fix the real error instead of fighting the supervisor.”

---

## 🧾 The Minimal Proof Commands

    systemctl status servicename --no-pager
    journalctl -u servicename -n 100 --no-pager
    systemctl cat servicename
    systemctl show -p Restart,RestartSec,StartLimitIntervalUSec,StartLimitBurst servicename
    ss -lntp
    dmesg | egrep -i "oom|killed"

