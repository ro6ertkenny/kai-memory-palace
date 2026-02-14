# 🛑 Process Control (LFCS)

Mental mode: **Act deliberately and reversibly**

This document covers how to **control processes**: stopping them, resuming them, terminating them, and mass-managing them using signals and job control.

Includes LFCS/KodeKloud surface:
- kill / pkill / killall
- escalation strategy
- nice / renice (priority)
- job control basics (shell-level)

---

## 🎯 Goals

You must be able to:
- stop and resume foreground and background jobs
- send signals to processes by PID and by name
- terminate runaway processes safely
- understand graceful vs forced termination
- verify whether a process is truly gone
- adjust process priority (nice/renice)

---

## 🧠 The Core Concept: Signals

Linux controls processes using **signals**.

A signal is a message sent to a process telling it to do something.

Common signals:
- `SIGTERM` (15) → polite request to terminate (default)
- `SIGKILL` (9) → force kill, cannot be ignored
- `SIGSTOP` → stop (pause) a process
- `SIGCONT` → continue a stopped process

---

## 🗡️ kill — Control by PID

Graceful stop (default = SIGTERM):

    kill 12345

Same as:

    kill -15 12345

Force kill (last resort):

    kill -9 12345

Stop (pause) a process:

    kill -STOP 12345

Continue a stopped process:

    kill -CONT 12345

---

## 🧨 Verify After You Signal

    ps -p 12345 || echo "gone"

Verification is not optional.

---

## 🧹 pgrep / pkill — Control by Name

Find PIDs by name:

    pgrep spotify

Show PID + command:

    pgrep -a spotify

Kill all matching processes:

    pkill spotify

Force kill all:

    pkill -9 spotify

---

## 🧯 killall — Name-based killer (use carefully)

    killall spotify

Force:

    killall -9 spotify

Guardrail: kills everything with that process name.

---

## 🧱 Kill Escalation Strategy (Exam Critical)

1) Inspect state and command first:

    ps -o pid,stat,etime,cmd -p PID

2) Send SIGTERM (graceful):

    kill PID

3) Verify:

    ps -p PID || echo "gone"

4) Escalate to SIGKILL only if needed:

    kill -9 PID

5) If the process is in `D` state (uninterruptible sleep):
- `kill -9` may not work
- fix the underlying I/O problem (disk/NFS/storage) instead

---

## 🎚️ Priority Control (nice / renice) — KodeKloud/LFCS

### Mental model

- Lower priority = higher nice value
- Higher priority = lower (or negative) nice value
- Negative nice generally requires sudo

### Start a command with a nice value

Run with lower priority (be “nicer” to the system):

    nice -n 10 <command>

Run with higher priority (requires privileges on many systems):

    sudo nice -n -5 <command>

### Change priority of an existing process

Set nice to 10:

    sudo renice 10 -p PID

Check nice value (NI column):

    ps -o pid,ni,cmd -p PID

Memory:
- NI bigger → runs “less aggressively”

---

## 🎛️ Job Control (Shell-Level)

Job control applies to your current terminal session.

Run a job in the background:

    sleep 300 &

List jobs:

    jobs

Stop a foreground job:

    Ctrl+Z

Resume a stopped job in background:

    bg %1

Bring a job to foreground:

    fg %1

Kill a job by job number:

    kill %1

---

## 🧪 Verify Stopped vs Running

    ps -o pid,stat,cmd -p PID

`T` indicates a stopped process.

---

## 🔧 Operator workflow (LFCS execution)

### Runaway process (safe loop)

1) Identify PID:

    pgrep -a <name>

2) Inspect:

    ps -o pid,ppid,user,stat,etime,cmd -p <PID>

3) Terminate politely:

    kill <PID>

4) Verify:

    ps -p <PID> || echo "gone"

5) Escalate only if needed:

    kill -9 <PID>

6) If it returns, check systemd management:

    systemctl status <unit> --no-pager

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/kill-escalation-drills.md`
- `linux/LFCS-training/execution-drills/nice-renice-drills.md`
- `linux/LFCS-training/execution-drills/job-control-drills.md`

---

## 🪝 Exam memory hook

Inspect → TERM → verify → KILL:

    ps -o pid,stat,etime,cmd -p <PID>
    kill <PID>
    ps -p <PID> || echo gone
    kill -9 <PID>

