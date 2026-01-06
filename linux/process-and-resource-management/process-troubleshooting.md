# 🧯 Process Troubleshooting (Hung, Zombie, D-State, LFCS)

Mental mode: **Diagnose before you destroy**

This document covers how to **recognize, diagnose, and respond to misbehaving processes**.  
These scenarios appear **on the LFCS exam** and constantly in real systems.

---

## 🎯 Goals

You must be able to:

- recognize process states
- identify hung and stuck processes
- understand zombies
- understand uninterruptible sleep (D-state)
- apply the correct kill strategy
- know when killing will NOT work

---

## 🧠 Process State Refresher

View state:

```bash
ps -o pid,stat,cmd -p PID
```

Common states:

- `R` = Running
- `S` = Sleeping
- `T` = Stopped
- `Z` = Zombie
- `D` = Uninterruptible sleep (usually disk I/O)

---

# 🧟 Zombie Processes

## What is a Zombie?

- Process has **finished**
- Parent has **not reaped it**
- Uses **no CPU**
- Uses **no memory**
- Still occupies a **PID entry**

Shows as:

```
Z
```

### Find zombies:

```bash
ps aux | awk '$8 ~ /Z/ { print $0 }'
```

### Fix:

> You do NOT kill zombies.  
> You kill or restart **the parent process**.

---

# 🪨 D-State (Uninterruptible Sleep)

## What is it?

- Process waiting on **I/O**
- Kernel will NOT allow it to be killed
- Even `kill -9` does **nothing**

Shows as:

```
D
```

### Common causes:

- dead disk
- hung NFS
- blocked storage
- kernel bug

### Fix:

> You fix the **I/O problem**, not the process.

Often requires:
- unmount
- storage fix
- reboot

---

# 🧊 Hung Processes

## Symptoms:

- 100% CPU or 0% CPU but never finishes
- ignores SIGTERM
- might ignore SIGKILL if in D-state

---

# 🗡️ Kill Escalation Strategy (EXAM CRITICAL)

1. Inspect:
```bash
ps -o pid,stat,cmd -p PID
```

2. Try polite:
```bash
kill PID
```

3. Verify:
```bash
ps -p PID || echo "gone"
```

4. Escalate:
```bash
kill -9 PID
```

5. If still alive and state = `D`:
> Killing will NOT work.

---

# 🧪 Stopped (T) vs Hung

Stopped:

- shows `T`
- can be resumed with:
```bash
kill -CONT PID
```
or:
```bash
fg
```

Hung:

- often shows `D` or `R`
- does NOT respond normally

---

# 🧠 Real Case: Spotify & Chrome

You observed:

- multiple processes
- some die, some respawn
- had to use:
```bash
pkill spotify
```
and sometimes:
```bash
kill -9 PID
```

That is **normal modern app behavior**.

---

# 🧪 Detecting a Respawning Service

If a process:

- dies
- comes back immediately

Check:

```bash
systemctl status servicename
```

systemd may be **restarting it**.

---

# 🧨 When Reboot Is the Only Fix

- many D-state processes
- broken storage
- kernel deadlock

> **This is not failure. This is Linux reality.**

---

# 🧭 LFCS What You Must Be Able To Do

- Recognize Z, D, T states
- Know which can be killed and which cannot
- Apply kill escalation correctly
- Understand when parent process is the problem
- Identify respawning daemons

---

# 🧠 Exam Decision Tree

> Is it stopped? → CONT  
> Is it zombie? → Fix parent  
> Is it running? → kill → kill -9  
> Is it D-state? → Fix I/O or reboot  

---

# 🏁 Mental Model

> **Not all processes can be killed.**  
> The kernel always wins.

---

