# 🧬 Processes and Services
*What is running, who started it, and who is responsible for it*

---

## 🎯 Purpose

This document explains:

- What a **process** is in Linux
- How **PID** and **PPID** define parent/child relationships
- How processes are created and replaced
- The difference between:
  - interactive processes
  - background processes
  - daemons
  - system services

This is the **mental model** behind everything that runs on Linux.

---

## 🧠 Mental Model

Linux is a system of **processes**.

- Every program that is running is a process.
- Every process has:
  - an identity (PID)
  - a parent (PPID)
  - an owner (user)
  - a lifetime

Processes form a **tree**.

Except for the very first process, **every process is started by another process**.

---

## 🆔 Process Identity: PID and PPID

Every running process has:

- PID = Process ID  
  A unique number that identifies this running process.

- PPID = Parent Process ID  
  The PID of the process that created (spawned) this process.

In other words:

- A process is always started by another process (except the very first one).
- PPID tells you **who launched it**.

---

## 🔍 Inspecting PIDs and Parents

List processes:

    ps

Show more details, including PPID:

    ps -f

Show all processes whose parent is a given PID:

    ps --ppid 1234

Special case:

    ps --ppid $$

`$$` means: the PID of your **current shell**.

So this shows **all processes started by your shell**.

---

## 🌱 Process Creation (fork and exec)

Conceptually:

1. A process **forks** (makes a copy of itself)
2. The child process **execs** (replaces itself with a new program)

This is why:

- New processes always have a PPID
- Shells can start other programs
- Services can spawn workers

You do not usually see fork/exec directly, but **all process creation uses this model**.

---

## 🔁 Process Lifetime

A process can:

- start
- run
- spawn children
- exit

If a parent exits:

- The child is **reparented** (usually to PID 1 or systemd)

---

## 🧱 Interactive vs Background vs Daemon

### Interactive processes

- Started from a terminal
- Attached to your session
- Example:

    vim file.txt

### Background processes

- Started from a terminal
- Not blocking the terminal
- Example:

    sleep 1000 &

Still owned by your shell.

### Daemons

- Long-running background processes
- Not tied to a terminal
- Examples:
  - sshd
  - cron
  - systemd

---

## 🧭 Services and systemd

On modern Linux:

- systemd (PID 1) is the **first userspace process**
- It starts and supervises:
  - services
  - daemons
  - background system components

Check:

    ps -p 1

Services are:

- still processes
- but **managed by systemd**, not by your shell

---

## 🧠 Important Distinction

- A **process** is a kernel concept
- A **job** is a shell concept
- A **service** is a management concept

They are **different layers** talking about the same running programs.

---

## 🧪 Practical Drills

Run:

    ps -f
    echo $$
    ps --ppid $$

Then:

    sleep 1000 &
    ps -f | grep sleep

Explain out loud:

- which process is the parent
- which process is the child
- who owns them
- who will clean them up

---

## ✅ Outcome

You should be able to say:

- What a process is
- Who started it
- Who owns it
- Who will restart or kill it

That is **process literacy**.
EOF

