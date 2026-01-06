# 🛑 Process Control (LFCS)

Mental mode: **Act deliberately and reversibly**

This document covers how to **control processes**: stopping them, resuming them, terminating them, and mass-managing them using signals and job control.  
These skills are **core LFCS exam material** and are required for real-world recovery and remediation.

---

## 🎯 Goals

You must be able to:

- stop and resume foreground and background jobs
- send signals to processes by PID and by name
- terminate runaway processes
- understand the difference between graceful and forced termination
- verify whether a process is truly gone

---

## 🧠 The Core Concept: Signals

Linux controls processes using **signals**.

A signal is a **message sent to a process** telling it to do something.

Common signals:

- `SIGTERM` (15) → polite request to terminate (default)
- `SIGKILL` (9) → force kill, cannot be ignored
- `SIGSTOP` (19) → stop (pause) a process
- `SIGCONT` (18) → continue a stopped process

---

## 🗡️ kill — Control by PID

### Graceful stop (default = SIGTERM):

```bash
kill 12345
```

Same as:

```bash
kill -15 12345
```

### Force kill (last resort):

```bash
kill -9 12345
```

### Stop (pause) a process:

```bash
kill -STOP 12345
```

### Continue a stopped process:

```bash
kill -CONT 12345
```

---

## 🧨 Verifying a Kill

Always verify:

```bash
ps -p 12345 || echo "gone"
```

If it prints `gone`, the process is truly dead.

---

## 🧹 pgrep / pkill — Control by Name

### Find PIDs by name:

```bash
pgrep spotify
```

### Show PID + command:

```bash
pgrep -a spotify
```

### Kill all matching processes:

```bash
pkill spotify
```

### Force kill all:

```bash
pkill -9 spotify
```

**This is exactly how you killed all Spotify processes at once.**

---

## 🧯 killall — Another Name-Based Killer

```bash
killall spotify
```

Force:

```bash
killall -9 spotify
```

⚠️ Kills **everything** with that name. Use carefully.

---

## 🎛️ Job Control (Shell-Level)

Job control applies to **your current terminal session**.

---

## ▶️ Running a Job in Background

```bash
sleep 300 &
```

---

## ⏸️ Stopping a Running Job

Press:

```
Ctrl+Z
```

Now check:

```bash
jobs
```

You’ll see:

```
[1]+  Stopped  sleep 300
```

---

## 🔁 Resume in Background

```bash
bg %1
```

---

## 🎯 Bring to Foreground

```bash
fg %1
```

---

## 💀 Kill a Job by Job Number

```bash
kill %1
```

---

## 🧪 Verifying a Stopped Process State

```bash
ps -o pid,stat,cmd -p PID
```

If you see:

```
T
```

That means **stopped**.

---

## 🧠 The Spotify Case (Real Example)

You observed:

- multiple Spotify processes
- killed one PID → others remained
- used:

```bash
pkill spotify
```

Then verified:

```bash
pgrep spotify || echo "clean"
```

This is **exactly correct LFCS behavior**.

---

## ⚠️ When kill -9 Is Appropriate

Use `-9` only when:

- process ignores SIGTERM
- process is stuck in uninterruptible state
- normal kill does nothing

**Rule:** Try normal kill first. Escalate only if needed.

---

## 🧭 Standard Control Workflow (Exam)

1. Inspect:
```bash
ps aux | grep name
```

2. Narrow:
```bash
pgrep -a name
```

3. Try graceful:
```bash
kill PID
```

4. Verify:
```bash
ps -p PID || echo "gone"
```

5. Escalate if needed:
```bash
kill -9 PID
```

---

## 🧠 LFCS What You Must Be Able To Do

- Stop and resume jobs with Ctrl+Z, bg, fg
- Kill by PID and by name
- Use pkill, pgrep, killall
- Understand SIGTERM vs SIGKILL
- Verify process death
- Recognize stopped (`T`) state

---

## 🏁 Mental Model

> **Inspect → Signal → Verify → Escalate (if needed)**

Never start with `-9`.

---

