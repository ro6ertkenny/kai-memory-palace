# 🧯 mistakes.md — Fast Recovery from Common Networking Errors

## 🎯 Purpose
Recover quickly from **recurring networking mistakes** without guessing.

This file exists to:
- stop trial-and-error fixes
- restore diagnostic order
- prevent repeat failures

Networking errors are common. Slow recovery is optional.

---

## 🧠 Mental Rule
Inspect the ladder. Do not skip steps.

Link → Address → Route → Listener → Name

If you jump ahead, you will misdiagnose.

---

## 🚫 Skipping Link State
Symptom:
- nothing works
- commands time out immediately

Mistake:
- debugging routes or DNS while the interface is down

Fix:
- inspect interfaces and link state
- confirm the expected interface is UP

No link means no traffic.

---

## 📭 Address Assumptions
Symptom:
- host reachable sometimes
- traffic behaves inconsistently

Mistake:
- assuming the host has the expected IP
- ignoring IPv6 or secondary addresses

Fix:
- inspect all assigned addresses
- confirm subnet and scope
- explain which address should be used

Addresses define identity.

---

## 🧭 Missing or Wrong Default Route
Symptom:
- local traffic works
- remote traffic fails

Mistake:
- assuming a default route exists
- ignoring route metrics or overrides

Fix:
- inspect the routing table
- identify the active default route
- confirm gateway and interface

No route means nowhere to go.

---

## 🔊 Listener Confusion
Symptom:
- connection refused
- port appears open but service is unreachable

Mistake:
- assuming a service is listening
- confusing local-only listeners with remote ones

Fix:
- inspect listening ports
- map ports to processes
- confirm bind address

A route without a listener still fails.

---

## 🌍 DNS Blame (Too Early)
Symptom:
- “it must be DNS” instinct

Mistake:
- blaming DNS before checking connectivity
- flushing caches prematurely

Fix:
- test by IP first
- inspect resolver configuration
- confirm name resolution independently

DNS is common, but not first.

---

## 🔁 Firewall Assumptions
Symptom:
- traffic blocked unexpectedly

Mistake:
- assuming a firewall is the cause
- changing rules without evidence

Fix:
- confirm listener and route first
- verify whether traffic reaches the host at all
- inspect firewall state only after evidence

Firewalls block traffic. They do not create it.

---

## 🧪 Testing Before Inspecting
Symptom:
- many commands run
- no clear conclusions

Mistake:
- pinging, curling, and tracing without context

Fix:
- inspect state first
- predict the outcome
- then test once

Tests confirm hypotheses. They do not create them.

---

## 🧪 Daily Drill (2 minutes)
Intentionally misdiagnose a problem.

- pretend a failure is DNS
- walk the ladder instead
- identify the real failure point

Train recovery, not speed.

---

## ✅ Exit Criteria
You are done with this file when:
- mistakes feel familiar
- recovery steps are automatic
- networking failures feel explainable

You now fail safely in networking.
