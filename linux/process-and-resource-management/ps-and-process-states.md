# ps and Process States

ps means process status.

It shows a snapshot of running processes.

---

Common Columns

- PID: process ID
- PPID: parent process ID
- STAT: process state
- ELAPSED: how long it has existed
- CMD: command line

---

Core States

- R = Running
- S = Sleeping (interruptible)
- D = Uninterruptible sleep (I/O wait)
- T = Stopped
- Z = Zombie

---

Modifiers

- + = foreground process group
- s = session leader
- l = multithreaded
- < = high priority
- N = low priority

Examples:

- Ss = sleeping session leader
- R+ = running in foreground
- S+ = sleeping in foreground

---

Key Mental Model

Most processes are in S (sleeping) most of the time.

That usually means:

- waiting for input
- waiting for I/O
- waiting for timers
- waiting for the kernel

This is normal.
EOF

