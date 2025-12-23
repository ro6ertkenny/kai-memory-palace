# 🧭 routes-and-reachability.md — Understanding Where Traffic Goes

## 🎯 Purpose
Understand **how traffic leaves the host** and whether it can reach its destination.

This file trains habits for:
- inspecting routing decisions
- understanding default gateways
- diagnosing “can’t reach” failures
- explaining why traffic goes one way and not another

If routing is wrong, addressing does not matter.

---

## 🧠 Mental Rule
**No route, no traffic.**

If the system cannot decide where to send packets, communication stops.

---

## 🧩 What Routing Means
Routing determines:
- which interface traffic uses
- which gateway handles it
- whether a destination is reachable at all

Every outbound packet follows the routing table.

---

## 🔎 Inspecting Routes
Primary inspection tool:
- ip route

Things to observe:
- default route
- destination prefixes
- gateways
- output interfaces
- route metrics

Never assume a default route exists.

---

## 🚪 Default Gateway
The default route is used when no more specific route matches.

Questions to answer:
- is a default route present
- which interface it uses
- which gateway address it points to

Missing or incorrect default routes cause total connectivity failure.

---

## 🧭 Specific Routes
Some traffic uses non-default routes.

Examples:
- local subnets
- VPN routes
- container networks
- static routes

More specific routes override broader ones.

---

## 🧪 Testing Reachability
Once routes are known, test reachability.

Common tools:
- ping
- traceroute (or tracepath)

Use these to answer:
- can the destination be reached
- where traffic stops
- whether failure is local or remote

Do not test before inspecting routes.

---

## 🔁 Local vs Remote Traffic
Local traffic:
- stays on the same subnet
- does not use a gateway

Remote traffic:
- uses the default route or a specific gateway

Confusing these leads to incorrect fixes.

---

## 🧯 Common Routing Failures
- no default route
- wrong gateway address
- route bound to the wrong interface
- conflicting routes with different metrics
- VPN or container routes overriding defaults

Always inspect the routing table first.

---

## 🧪 Daily Drill (5 minutes)
On a running system:

- display the routing table
- identify the default route
- explain which interface traffic to the internet would use
- predict whether a remote host should be reachable

Only then test with ping.

---

## ✅ Exit Criteria
You are done with this file when:
- routing tables feel readable
- default gateways are obvious
- reachability failures are explainable

You now understand routing and reachability.
