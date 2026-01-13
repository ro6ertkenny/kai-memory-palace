# Shell vs System: Two Control Planes

There are two different layers involved when you run commands.

---

The Shell Layer

The shell tracks:

- jobs
- fg / bg
- %1, %2, etc

This is job control and only applies to your current terminal session.

---

The System Layer

The kernel tracks:

- processes
- PIDs
- signals

You inspect this with:

- ps
- kill
- top

---

Why You Sometimes See Two Messages

Example:

- The shell prints: [2] Terminated sleep 1000
- ps shows: no such PID

Two systems are reporting the same outcome:

- Shell: job table update
- Kernel: process is gone

---

Mental Model

jobs / fg / bg / %1 -> shell-level control
ps / kill / PID     -> system-level control

They intersect, but they are not the same system.
EOF

