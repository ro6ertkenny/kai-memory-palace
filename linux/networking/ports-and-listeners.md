# 🔊 ports-and-listeners.md — Understanding Who Is Listening

## 🎯 Purpose
Understand **which services are reachable on a host** and why.

This file trains habits for:
- identifying listening ports
- mapping ports to processes
- distinguishing local vs remote accessibility
- diagnosing “port open but nothing works” problems

If nothing is listening, nothing can connect.

---

## 🧠 Mental Rule
**A route gets you there. A listener answers.**

Reachability without a listener is still failure.

---

## 🧩 Ports and Sockets
A port is an endpoint where a process receives traffic.

Key concepts:
- ports belong to processes
- ports are protocol-specific
- listeners wait for connections
- connections are ephemeral

A service must be listening to respond.

---

## 🔎 Inspecting Listeners
Primary inspection tools:
- ss
- netstat (legacy)

Things to observe:
- protocol (TCP/UDP)
- local address
- port number
- listening state
- owning process

Never assume a service is listening.

---

## 🧭 Binding Addresses
Listeners bind to addresses.

Common cases:
- 0.0.0.0 or :: → all interfaces
- specific IP → one interface
- 127.0.0.1 → loopback only

Loopback-only services are not remotely reachable.

---

## 🔁 Ports vs Services
A port does not imply a service.

Confirm:
- which process owns the port
- whether it is expected
- whether it matches configuration

Processes can exit, restart, or bind differently.

---

## 🧪 Testing Connectivity
After confirming listeners, test connectivity.

Common tools:
- curl
- nc
- telnet (basic checks)

Testing answers:
- does the service respond
- does it respond locally
- does it respond remotely

Test after inspection, not before.

---

## 🧯 Common Listener Failures
- service not running
- bound only to loopback
- wrong port configured
- process crashed or restarting
- port conflict

Inspect before changing configuration.

---

## 🧪 Daily Drill (5 minutes)
On a running system:

- list listening ports
- pick one service
- identify its owning process
- explain whether it should be reachable locally or remotely

Do not change anything.

---

## ✅ Exit Criteria
You are done with this file when:
- listeners are easy to spot
- ports map cleanly to processes
- “connection refused” errors make sense

You now understand ports and listeners.
