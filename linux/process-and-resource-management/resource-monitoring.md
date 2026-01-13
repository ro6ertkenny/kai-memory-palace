## 📊 Resource Monitoring (CPU, Memory, Disk, LFCS)

Mental mode: **Understand what the system is doing right now**

This document covers how to inspect CPU, memory, and disk usage using standard Linux tools.

---

## 🎯 Goals

You must be able to:
- identify high CPU consumers
- identify high memory consumers
- understand load vs CPU saturation
- inspect memory pressure
- inspect disk space and inode exhaustion
- find where disk usage is coming from

---

## 🧠 Core Idea

Processes consume CPU, memory, and disk.

These tools tell you who is using what and how badly.

---

## 🧩 CPU and Process Usage

Top CPU consumers:

    ps aux --sort=-%cpu | head -n 10

Top memory consumers:

    ps aux --sort=-%mem | head -n 10

High-signal fields:
- `%CPU` = CPU usage
- `%MEM` = memory usage
- `RSS` = real memory in RAM
- `VSZ` = virtual memory
- `STAT` = process state

---

## ⏱️ uptime — Load Averages

    uptime

Shows:
- system uptime
- number of users
- load average (1, 5, 15 minutes)

Rule of thumb:
- load ≈ number of CPU cores: busy but possibly fine
- load >> number of cores: overloaded or blocked

Note: load includes tasks waiting on I/O, not only CPU.

---

## 🧠 Memory

Memory overview:

    free -h

Operator rule:
- use `available` to understand what can still be allocated
- `free` being low is not automatically a problem (Linux uses RAM for cache)

---

## 💽 Disk Space

Filesystem usage:

    df -h

Inode usage:

    df -i

Guardrail:
- a filesystem can fail because it is out of space OR out of inodes

---

## 📦 Disk Usage by Directory

High-level top-down scan (single filesystem):

    sudo du -x -sh /* | sort -h

Drill-down examples:

    du -sh /home/* | sort -h
    du -sh /home/ro6ert/* | sort -h
    du -sh /home/ro6ert/.* | sort -h

---

## 🧯 Why You May See “cannot access /proc/...”

`/proc` is a live virtual filesystem. Processes can exit while `du` is scanning.

This is normal.

---

## 🧪 Quick Triage Checklist (Exam and Real Life)

    uptime
    free -h
    df -h
    df -i
    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

---

## 🧭 LFCS What You Must Be Able To Do

- identify top CPU and memory consumers
- interpret load averages at a high level
- check memory availability (not just “free”)
- detect disk-full and inode-full conditions
- locate large directories using `du`
- build a safe, repeatable triage sequence

EOF

