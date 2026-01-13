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

---

## 🧠 What “ps” Means

`ps` = **process status**

It shows a **snapshot** of processes at the moment you run it (not a live view like `top`).

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

By PID:

    ps -p 12345

Custom output (high-signal):

    ps -o pid,user,%cpu,%mem,stat,etime,cmd -p 12345

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

## 🧪 Practical Inspection Workflow (Exam Style)

1) List everything:

    ps aux

2) Sort by CPU and memory:

    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

3) Pick a suspicious PID

4) Inspect it:

    ps -o pid,user,%cpu,%mem,stat,etime,cmd -p PID

5) Decide what to do only after inspection

---

## 🏁 Mental Model

Inspect → Understand → Decide → Act → Verify

EOF

