# 🔍 System Inspection
## Knowing what the system is doing right now

Mental mode: Observing reality before acting.

This document defines how to inspect a Linux system’s **current state**:
- CPU
- memory
- disk
- network
- load

System inspection always comes **before** configuration changes, restarts, or upgrades.

---

## Purpose
You should be able to answer, without guessing:
- Is this system under load?
- What resource is constrained?
- Is the problem CPU, memory, disk, or network?
- Is this normal or abnormal for this host?

Inspection replaces intuition with evidence.

---

## Identity and Baseline

Who am I?
whoami

What system is this?
hostnamectl

What kernel and architecture?
uname -a

What OS?
cat /etc/os-release

Uptime and load:
uptime

Load averages represent runnable processes over time.

---

## CPU Inspection

Quick view:
top

What matters:
- %us → user processes
- %sy → kernel work
- %id → idle time
- load average vs CPU cores

Number of cores:
nproc

High load with low CPU usage usually indicates IO wait.

---

## Memory Inspection

Human-readable summary:
free -h

What to look for:
- available memory (not just free)
- swap usage

Kernel view:
cat /proc/meminfo | head

Swap pressure often explains slow systems with low CPU usage.

---

## Disk Usage

Filesystem usage:
df -hT

Block devices:
lsblk

Directory-level usage:
du -sh * 2>/dev/null | sort -h

Common failure:
Disk full causes unrelated services to fail.

---

## Disk IO Pressure

Check IO wait in top.
Look for:
- high load
- low CPU usage
- blocked processes

Disk issues often masquerade as “random slowness.”

---

## Network Inspection

Interfaces and addresses:
ip a

Routing:
ip r

Listening ports and owners:
ss -tulpen

DNS resolution:
resolvectl status
or
cat /etc/resolv.conf

Connectivity test:
ping -c 3 1.1.1.1

---

## Process-Level Correlation

Find heavy consumers:
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head

Correlate:
- process
- user
- service
- resource usage

---

## Time and Clock

Check system time:
date

Time drift breaks:
- TLS
- certificates
- cluster coordination

Ensure time is sane before deeper debugging.

---

## Inspection Discipline

Always inspect in this order:
1. uptime
2. cpu
3. memory
4. disk
5. network
6. processes

Skipping steps leads to false conclusions.

---

## Practice

Run the following and explain each result:
uptime
free -h
df -h
ss -tulpen
ps aux --sort=-%cpu | head

Say out loud:
- what looks normal
- what would concern you

If you can articulate that, you’re inspecting correctly.

---

## Outcome

You should be able to say:

I know the system’s current state,  
I know where pressure exists,  
and I know what to investigate next.

That is operational awareness.
