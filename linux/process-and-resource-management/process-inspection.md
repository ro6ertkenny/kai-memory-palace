# 🔍 Process Inspection (LFCS)

Mental mode: **Observe before acting**

This document covers how to **inspect running processes**, identify resource usage, and understand process state before taking any action.  
These skills are **core LFCS exam material** and are required for real-world troubleshooting.

---

## 🎯 Goals

You must be able to:

- list running processes
- find a specific process
- sort by CPU or memory
- understand basic process states
- extract a PID for further action
- verify whether a process exists or is gone

**Rule:** Never kill what you haven’t inspected.

---

## 🧠 What “ps” Means

`ps` = **process status**

It shows a **snapshot** of processes at the moment you run it (not a live view like `top`).

---

## 📋 The One Command You Must Know

```bash
ps aux
```

Meaning:

- `a` = show processes for **all users**
- `u` = show in **user-oriented format**
- `x` = include processes **without a terminal**

This shows **almost everything running** on the system.

---

## 📊 Understanding the Columns

Example header:

```
USER   PID %CPU %MEM VSZ   RSS TTY  STAT START TIME COMMAND
```

Important ones:

- `USER` → who owns the process
- `PID` → process ID (used for kill, etc)
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
- `I` = Idle kernel thread
- `Sl`, `Ssl`, etc = sleeping + multithreaded or session leader

**Exam gold:**  
If you see `T` → the process is **stopped**, not dead.

---

## 🔎 Finding Specific Processes

### By name:

```bash
ps aux | grep spotify
```

### By PID:

```bash
ps -p 12345
```

### Custom output (very useful):

```bash
ps -o pid,user,%cpu,%mem,stat,etime,cmd -p 12345
```

---

## 🔢 Sorting by Resource Usage

### Highest CPU:

```bash
ps aux --sort=-%cpu | head
```

### Highest memory:

```bash
ps aux --sort=-%mem | head
```

This is **exactly how you found Spotify and Chrome hogs**.

---

## ✅ Verifying If a Process Exists

```bash
ps -p 12345 || echo "gone"
```

If it prints `gone`, the process is **truly dead**.

---

## 🧪 Practical Inspection Workflow (Exam Style)

1. List everything:
```bash
ps aux
```

2. Sort by CPU or memory:
```bash
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

3. Pick a suspicious PID

4. Inspect it:
```bash
ps -o pid,user,%cpu,%mem,stat,etime,cmd -p PID
```

5. Decide what to do **only after inspection**

---

## ⚠️ Important Distinctions

- `ps` shows a **snapshot**, not live updates
- High CPU ≠ broken (could be doing work)
- Always check:
  - owner
  - runtime
  - command
  - state

---

## 🧠 LFCS What You Must Be Able To Do

- List processes
- Sort by CPU and memory
- Identify a PID
- Recognize `R`, `S`, `T`, `Z` states
- Verify whether a process is running or gone
- Extract info before killing anything

---

## 🏁 Mental Model

> **Inspect → Understand → Decide → Act → Verify**

Never skip the inspection step.

---

