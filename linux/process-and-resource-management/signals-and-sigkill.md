# Signals, SIGTERM, and SIGKILL

A signal is a message sent to a process.

---

Common Signals

- SIGTERM (15): polite request to exit
- SIGKILL (9): force kill, cannot be caught or ignored
- SIGSTOP: pause
- SIGCONT: resume

---

What does -9 mean?

The number 9 means SIGKILL.

kill -9 PID sends SIGKILL.

This is the nuclear option.

---

Proper Escalation Path

1. kill PID
2. verify
3. kill -9 PID
4. verify

---

Why SIGKILL is not magic

If a process is in D-state (uninterruptible sleep), the kernel will not kill it.

The real problem is:

- disk
- network storage
- kernel

Not the process.
EOF

