# Signals, SIGTERM, and SIGKILL

A signal is a message sent to a process.

---

## Common Signals

- SIGTERM (15): polite request to exit
- SIGKILL (9): force kill, cannot be caught or ignored
- SIGSTOP: pause (cannot be ignored)
- SIGCONT: resume
- SIGINT (2): Ctrl+C interrupt (may be handled)

---

## What does -9 mean?

The number 9 means SIGKILL.

    kill -9 PID

sends SIGKILL.

This is the nuclear option.

---

## Proper Escalation Path

1. kill PID
2. verify
3. kill -9 PID
4. verify

---

## Why SIGKILL is not magic

If a process is in D-state (uninterruptible sleep), the kernel will not kill it.

The real problem is:

- disk
- network storage
- kernel

Not the process.

---

## How to see the state (learning-critical)

Check STAT:

    ps -o pid,stat,etime,cmd -p PID

If STAT includes D:
- stop trying to kill
- investigate the I/O stall

---

## Signal lookup (memory tool)

List signal names/numbers:

    kill -l

---

## Relationship to services (systemd)

If you kill a PID that belongs to a systemd service:
- systemd may restart it automatically

Prefer lifecycle control:

    systemctl stop <unit>
    systemctl restart <unit>

---

## 🔧 Operator workflow (LFCS execution)

1) Inspect:

    ps -o pid,stat,etime,cmd -p PID

2) Terminate politely:

    kill PID

3) Verify:

    ps -p PID || echo gone

4) Escalate:

    kill -9 PID

5) If still present and STAT has D:

    ps -o pid,stat,etime,cmd -p PID

Then fix underlying I/O.

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/signals-drills.md`

---

## 🪝 Exam memory hook

TERM first, KILL last:

    kill PID
    ps -p PID || echo gone
    kill -9 PID

