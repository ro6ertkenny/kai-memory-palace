cat << 'EOF' > linux/networking/ports-and-listeners.md
# 🔌 ports-and-listeners.md — Who Is Listening and Who Can Reach It

## 🎯 Purpose

Understand **which services are listening**, **where they are bound**, and **who can reach them**.

This file trains you to:

- read `ss` output confidently
- understand LISTEN vs ESTAB vs TIME-WAIT
- identify **loopback-only services**
- map ports to processes
- diagnose “service is running but I can’t connect” failures

On the exam: if something “should be reachable” — this file is where you prove why it is or isn’t.

---

## 🧠 Mental Rule

> **A service is reachable only if:**
> - it is listening
> - on the right address
> - on the right port
> - on the right interface
> - and not blocked by scope or binding

---

## 🔎 Core Commands

- `ss -tulpen` → full socket view (TCP + UDP + listeners + processes)
- `ss -tan` → TCP state view (LISTEN, ESTAB, TIME-WAIT, etc)

Flags explained:

- `-t` = TCP
- `-u` = UDP
- `-l` = listening sockets
- `-p` = show process
- `-e` = extended info
- `-n` = no name resolution (show numbers)

You can combine them in any order.

---

# 🧱 Part 1 — Understanding Listening Sockets

Run:

    ss -tulpen

You will see lines like:

    tcp LISTEN 0 128 0.0.0.0:22 0.0.0.0:* users:(("sshd",pid=...,fd=...))

Meaning:

- protocol = TCP
- state = LISTEN
- local address = 0.0.0.0:22
- bound to = all IPv4 interfaces
- service = sshd

---

## 🧠 Critical Concept: Binding Address

These mean very different things:

- `0.0.0.0:22` = listening on **all IPv4 interfaces**
- `127.0.0.1:631` = **loopback-only** (local machine only)
- `192.168.1.86:8080` = listening on **one specific interface**
- `[::]:22` = listening on **all IPv6 interfaces**

---

# 🧱 Part 2 — Loopback-Only Services (NT Critical)

Example from your system:

    127.0.0.1:631

Means:

> This service is only reachable from **this machine itself**.

Even if the network is perfect:

- other machines **cannot connect**
- firewall is irrelevant
- the service is **not exposed**

---

## 🧠 How to Spot Loopback-Only

In `ss` output:

- IPv4: `127.0.0.1:PORT`
- IPv6: `[::1]:PORT`

That is **loopback-only**.

---

# 🧱 Part 3 — Reading Connection States (`ss -tan`)

Run:

    ss -tan

Important states:

- `LISTEN` = waiting for connections
- `ESTAB` = active connection
- `TIME-WAIT` = recently closed, kernel cleanup
- `CLOSE-WAIT` = remote closed, local not yet

---

## 🧠 What TIME-WAIT Means

> This is normal. It is **not a problem**.

It means:

- a connection was recently closed
- the kernel is keeping it briefly to avoid packet confusion

---

# 🧱 Part 4 — Mapping Ports to Processes

Use:

    ss -tulpen

Look at:

    users:(("spotify",pid=11034,fd=153))

This tells you:

- which process owns the socket
- which PID
- which file descriptor

This answers:

> “What program is using this port?”

---

# 🧱 Part 5 — UDP Is Connectionless

UDP entries will show:

- state = UNCONN
- still bound to addresses and ports
- still owned by processes

UDP services can still be:

- loopback-only
- or externally reachable

---

# 🧯 Exam-Grade Failure Patterns

- Service is running but:
  - only bound to 127.0.0.1 → not reachable remotely
- Port is correct but:
  - bound to wrong interface
- IPv6 is listening but IPv4 is not (or vice versa)
- Looking at `ps` instead of `ss` (wrong layer)

---

# 🧪 Debug Checklist

1. `ss -tulpen`
2. Is the service LISTENing?
3. On what address?
4. On what port?
5. Which process?
6. Is it loopback-only?

---

# 🧪 Practical Drills

Run:

    ss -tulpen
    ss -tan

Find:

- one loopback-only service
- one externally reachable service
- one ESTAB connection
- one TIME-WAIT entry

Explain each in words.

---

## ✅ Exit Criteria

You are done with this file when:

- `ss -tulpen` feels readable
- loopback-only jumps out immediately
- you can prove why a service **is or is not reachable**

You now understand **ports and listeners**.
EOF

