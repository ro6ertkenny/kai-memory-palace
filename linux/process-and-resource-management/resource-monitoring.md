# 📊 Resource Monitoring (CPU, Memory, Disk, LFCS)

Mental mode: **Understand what the system is doing right now**

This document covers how to **inspect CPU, memory, and disk usage** using standard Linux tools.  
These are **core LFCS exam skills** and are used constantly in real operations.

---

## 🎯 Goals

You must be able to:

- identify high CPU consumers
- identify high memory consumers
- understand load vs CPU
- inspect memory pressure
- inspect disk space usage
- inspect inode usage
- explain what is “normal” vs “concerning”

---

## 🧠 Core Idea

> **Processes consume CPU, memory, and disk.**  
> These tools tell you **who is using what** and **how badly**.

---

# 🧩 CPU & Process Load

## 1️⃣ ps — Snapshot of Process Usage

### Top CPU consumers:

```bash
ps aux --sort=-%cpu | head -n 10
```

### Top memory consumers:

```bash
ps aux --sort=-%mem | head -n 10
```

Important columns:
- `%CPU` = CPU usage
- `%MEM` = memory usage
- `RSS` = real memory in RAM
- `VSZ` = virtual memory
- `STAT` = process state

---

## 2️⃣ uptime — Load Averages

```bash
uptime
```

Shows:
- how long system has been up
- number of users
- **load average (1, 5, 15 min)**

### Rule of thumb:

> Load ≈ number of CPU cores = system is busy but OK  
> Load >> number of cores = system is overloaded

---

# 🧠 Memory

## 3️⃣ free — Memory Overview

```bash
free -h
```

You ran this:

```bash
free -h
```

Important columns:
- `total` = total RAM
- `used` = used RAM
- `free` = completely unused
- `available` = what the system can actually still give you

> **Always look at “available”, not “free”.**

---

# 💽 Disk Space

## 4️⃣ df — Filesystem Usage

### Human readable:

```bash
df -h
```

Shows:
- size
- used
- available
- percent used
- mountpoint

Example mental questions:
- Is `/` full?
- Is `/home` full?
- Is `/boot` full?

---

## 5️⃣ df — Inodes

```bash
df -i
```

Shows:
- inode usage (number of files)
- You can run out of inodes **even with free disk space**

> Disk full OR inode full both break systems.

---

# 📦 Disk Usage by Directory

## 6️⃣ du — Who Is Using Space?

### Top-level overview:

```bash
sudo du -x -sh /* | sort -h
```

Flags:
- `-s` = summary
- `-h` = human readable
- `-x` = stay on same filesystem
- `sort -h` = sort by size

---

## 7️⃣ Drill Down

```bash
du -sh /home/* | sort -h
du -sh /home/ro6ert/* | sort -h
du -sh /home/ro6ert/.* | sort -h
```

This answers:

> **Where did my disk space go?**

---

## 🧯 Why You Saw “cannot access /proc/...”

`/proc` is a **live virtual filesystem**.  
Processes come and go while `du` is scanning.

This is **normal and harmless**.

---

# 🧠 Memory vs Disk vs CPU (Mental Model)

- CPU → `ps`, `uptime`
- Memory → `free`, `ps`
- Disk space → `df -h`
- Inodes → `df -i`
- Directory usage → `du`

---

# 🧪 Quick Triage Checklist (Exam & Real Life)

```bash
uptime
free -h
df -h
df -i
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

---

# 🧭 LFCS What You Must Be Able To Do

- Find high CPU processes
- Find high memory processes
- Check system load
- Check RAM pressure
- Check disk usage
- Check inode exhaustion
- Identify which directory is consuming space

---

# 🧠 Exam Mental Model

> **Is the system slow?**  
> → Check CPU, memory, disk, inodes.

> **Is disk full?**  
> → Use `df`, then `du`.

---

# 🏁 Remember

> **df tells you WHAT is full**  
> **du tells you WHO filled it**

---

# 🔁 One-Line Emergency Workflow

```bash
uptime && free -h && df -h && df -i
```

Then:

```bash
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

Then:

```bash
sudo du -x -sh /* | sort -h
```

---

This is the **core operational skillset** for diagnosing a sick Linux system.

---

