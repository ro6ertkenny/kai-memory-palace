# 🔍 Process Inspection (LFCS)

Mental mode: **Observe before acting**

This document covers how to **inspect running processes**, identify resource usage, and understand process state before taking any action.

Rule: Never kill what you haven’t inspected.

---

## 🎯 Goals

You must be able to:
- list running processes
- find a specific process
- sort by CPU or memory
- understand basic process states
- extract a PID for further action
- verify whether a process exists or is gone
- identify what process owns a port or open file (lsof)

---

## 🧠 What “ps” Means

`ps` = **process status**

It shows a **snapshot** of processes at the moment you run it (not a live view like `top`).

Live view tools (useful context):
- `top` = live process view (built-in on most systems)
- `htop` = nicer live view (may not be installed)

LFCS: you must be fluent with `ps`.

---

## 📋 The One Command You Must Know

    ps aux

Meaning:
- `a` = show processes for **all users**
- `u` = show in **user-oriented format**
- `x` = include processes **without a terminal**

This shows **almost everything running** on the system.

---

## 📊 Understanding the Columns

Typical header:

    USER   PID %CPU %MEM VSZ   RSS TTY  STAT START TIME COMMAND

Important columns:
- `USER` → who owns the process
- `PID` → process ID (used for signals)
- `%CPU` → CPU usage
- `%MEM` → memory usage
- `VSZ` → virtual memory size
- `RSS` → real memory in RAM
- `STAT` → process state
- `TIME` → CPU time used
- `COMMAND` → what is running

---

## 🧩 Process States (STAT)

Common ones you will see:
- `R` = Running
- `S` = Sleeping
- `T` = Stopped (job control or SIGSTOP)
- `Z` = Zombie (dead but not reaped)
- `D` = Uninterruptible sleep (often I/O)

Operator rule:
- `T` means stopped, not dead
- `Z` means a parent reaping problem
- `D` can indicate storage/network I/O problems and may not respond to kills

---

## 🔎 Finding Specific Processes

By name:

    ps aux | grep spotify

Better by name (no grep false positives):

    pgrep spotify

Show PID + command:

    pgrep -a spotify

By PID:

    ps -p 12345

Custom output (high-signal):

    ps -o pid,user,%cpu,%mem,stat,etime,cmd -p 12345

Extra useful fields (PPID shows parent):

    ps -o pid,ppid,user,%cpu,%mem,stat,etime,cmd -p 12345

---

## 🔢 Sorting by Resource Usage

Highest CPU:

    ps aux --sort=-%cpu | head

Highest memory:

    ps aux --sort=-%mem | head

---

## ✅ Verifying If a Process Exists

    ps -p 12345 || echo "gone"

If it prints `gone`, the process is truly dead.

---

## 🔒 lsof (LFCS practical inspection)

`lsof` answers: “what has this resource open?”

Process owns this port:

    sudo lsof -i :8080

Show listeners (TCP LISTEN only):

    sudo lsof -nP -iTCP -sTCP:LISTEN

Which process holds a file open:

    sudo lsof /path/to/file

What a PID has open:

    sudo lsof -p 12345 | head

Why unmount fails (“device busy”):

    sudo lsof /mountpoint

Flags (memory-ready):
- `-n` = no DNS lookups
- `-P` = numeric ports (no service names)

---

## 🧪 Practical Inspection Workflow (Exam Style)

1) List everything:

    ps aux

2) Sort by CPU and memory:

    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

3) Pick a suspicious PID

4) Inspect it:

    ps -o pid,ppid,user,%cpu,%mem,stat,etime,cmd -p PID

5) Decide what to do only after inspection

---

## 🔧 Operator workflow (LFCS execution)

### “Something is wrong” triage loop

1) Identify offenders (CPU/MEM):

    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

2) Confirm identity + parent + runtime:

    ps -o pid,ppid,user,stat,etime,cmd -p <PID>

3) If the complaint is “port/file busy”, confirm resource owner:

    sudo lsof -i :<PORT>
    sudo lsof /path/or/mount

4) Only then control/kill (see process-control.md)

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/ps-drills.md`
- `linux/LFCS-training/execution-drills/pgrep-pkill-drills.md`
- `linux/LFCS-training/execution-drills/lsof-drills.md`

---

## 🪝 Exam memory hook

Inspect before action:

    pgrep -a <name>
    ps -o pid,ppid,stat,etime,cmd -p <PID>
    sudo lsof -i :<PORT>

