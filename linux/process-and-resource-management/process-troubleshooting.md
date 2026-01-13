# 🧯 Process Troubleshooting (Hung, Zombie, D-State, LFCS)

Mental mode: **Diagnose before you destroy**

This document covers how to recognize, diagnose, and respond to misbehaving processes.

---

## 🎯 Goals

You must be able to:
- recognize process states
- identify hung and stuck processes
- understand zombies
- understand uninterruptible sleep (D-state)
- apply the correct kill strategy
- know when killing will NOT work

---

## 🧠 Process State Refresher

    ps -o pid,stat,cmd -p PID

Common states:
- `R` = Running
- `S` = Sleeping
- `T` = Stopped
- `Z` = Zombie
- `D` = Uninterruptible sleep (usually disk or network I/O)

---

## 🧟 Zombie Processes

What it is:
- the process has finished
- the parent has not reaped it
- it uses no CPU and essentially no memory
- it still occupies a PID entry

Detect zombies:

    ps aux | awk '$8 ~ /Z/ { print $0 }'

Fix:
- you do not kill zombies
- you fix the parent (restart parent process/service, or fix the parent’s wait/reap behavior)

Practical approach:
- identify the parent PID (PPID)
- restart the owning service if applicable

---

## 🪨 D-State (Uninterruptible Sleep)

What it is:
- process is blocked in the kernel waiting on I/O
- the kernel will not allow it to be killed
- even `kill -9` may do nothing

Typical causes:
- failing disk
- hung NFS / remote filesystem
- blocked storage path
- device driver / kernel issues

Fix:
- solve the I/O problem (storage/network)
- sometimes requires unmount, storage recovery, or reboot

---

## 🧊 Hung Processes

Symptoms:
- high CPU and no progress
- unresponsive UI
- process ignores SIGTERM
- process may resist SIGKILL if in D-state

Operator approach:
1) inspect process state and command
2) inspect parent/service relationship
3) attempt graceful termination
4) escalate only if required
5) verify

---

## 🗡️ Kill Escalation Strategy (Exam Critical)

1) Inspect:

    ps -o pid,ppid,stat,etime,cmd -p PID

2) Graceful:

    kill PID

3) Verify:

    ps -p PID || echo "gone"

4) Force (last resort):

    kill -9 PID

5) If still alive and state is `D`:
- killing will not work
- fix the I/O path or reboot

---

## 🧪 Stopped (T) vs Hung

Stopped (`T`):
- typically caused by job control (`Ctrl+Z`) or SIGSTOP
- can be resumed

Resume with:

    kill -CONT PID

Or for shell jobs:

    fg %1

---

## 🧬 Detecting a Respawning Process

If a process dies and returns immediately:
- it may be managed by `systemd`
- it may be supervised by another process

Check:

    systemctl status servicename --no-pager

Then read logs:

    sudo journalctl -u servicename -n 50 --no-pager

---

## 🧨 When Reboot Is the Correct Fix

Examples:
- many D-state processes (blocked I/O)
- filesystem or storage path dead
- kernel deadlock symptoms
- core system services cannot be restarted reliably

Operator rule:
- reboot is not a first step
- reboot is sometimes the only step that actually restores the system

EOF

