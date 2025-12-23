# ⚙️ Processes & Services
## Understanding what is running and who controls it

Mental mode: Controlling execution on the system.

This document explains how Linux runs programs, how they stay running,  
and how you inspect, control, and recover them safely.

Most “the system is acting weird” problems are **process or service problems**.

---

## Purpose
You should be able to answer, without guessing:
- What is running right now?
- Who started it?
- Why is it still running?
- How do I stop it safely?
- How do I confirm it restarted correctly?

---

## Processes vs Services (Mental Model)

A **process** is a running program.
A **service** is a managed process.

Key difference:
- Processes can start and stop freely
- Services are controlled by **systemd**

Most critical system workloads are services.

---

## Inspecting Processes

List all processes:
ps aux

Common fields:
- USER   → who owns it
- PID    → process ID
- %CPU   → CPU usage
- %MEM   → memory usage
- STAT   → process state
- COMMAND → what was executed

Filter output:
ps aux | grep ssh

Exclude the grep process:
ps aux | grep ssh | grep -v grep

---

## Process States (STAT)

Common states:
- R → running
- S → sleeping
- D → uninterruptible sleep (disk or IO)
- Z → zombie
- T → stopped

Zombie processes indicate a cleanup problem, not a resource hog.

---

## Real-Time Inspection

Interactive view:
top

Better filtering (if installed):
htop

Watch one command:
watch -n 2 ps aux | grep kubelet

---

## Signals and Process Control

Send a signal:
kill <PID>

Graceful stop:
kill -15 <PID>

Force stop (last resort):
kill -9 <PID>

Never use SIGKILL unless the process refuses to exit cleanly.

---

## Background and Foreground Jobs

Start in background:
command &

List jobs:
jobs

Bring to foreground:
fg %1

Send to background:
Ctrl+Z
bg

Job control is **shell-level**, not system-level.

---

## systemd (Service Control)

systemd manages services.

Check service status:
systemctl status <service>

Start a service:
sudo systemctl start <service>

Stop a service:
sudo systemctl stop <service>

Restart a service:
sudo systemctl restart <service>

Enable at boot:
sudo systemctl enable <service>

Disable at boot:
sudo systemctl disable <service>

---

## Inspecting Running Services

List active services:
systemctl list-units --type=service --state=running

Check failed services:
systemctl --failed

Service unit files live in:
- /etc/systemd/system
- /lib/systemd/system

---

## Logs and Journald

View recent logs for a service:
journalctl -u <service>

Follow logs:
journalctl -u <service> -f

Show errors only:
journalctl -p err

Logs explain *why* something failed, not just that it failed.

---

## Restart Discipline

Correct order:
1. Inspect status
2. Read logs
3. Restart
4. Re-check status
5. Confirm expected behavior

Blind restarts hide root causes.

---

## Common Failure Patterns

- Service running but port not open
- Service enabled but not started
- Process exists but owned by wrong user
- Restart loop due to config error

Always inspect before acting.

---

## Practice

Inspect SSH:
systemctl status ssh
ps aux | grep ssh
journalctl -u ssh -n 20

Explain:
- who owns it
- how it started
- how it stays running

If you can explain that, you understand services.

---

## Outcome

You should be able to say:

I know what is running,  
I know who controls it,  
and I know how to change its state safely.

That is process control.
