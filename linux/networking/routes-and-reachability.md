# 🧭 Routes and Reachability (ip route) — Operator Canonical (LFCS)

Goal: prove **where packets will go and why**.

---

## 🧠 Operator mental model

The kernel chooses routes by longest prefix match.

No default route = no internet.

---

## ✅ Safe command order

    ip route
    ip route get <destination>

Reachability chain:

    ping 127.0.0.1
    ping <gateway>
    ping 1.1.1.1
    getent hosts example.com

---

## 🔎 Core workflows

### Show routing table

    ip route

### Ask kernel which path it will use

    ip route get 1.1.1.1

### Add or replace default route (temporary)

    sudo ip route replace default via <gateway> dev <iface>

### Add specific route

    sudo ip route add 10.10.0.0/16 via <gateway>

### Delete route

    sudo ip route del default

---

## 🧯 Failure-mode debugging

No default route:

→ internet unreachable.

Gateway not pingable:

→ wrong IP/prefix or link down.

Wrong interface chosen:

    ip route get <target>

Ping by IP works but DNS fails:

→ resolver problem.

---

## 🔗 Drill references

- linux/LFCS-training/execution-drills/routes-and-reachability.md
- linux/LFCS-training/execution-drills/reachability-triage.md

---

## 🪝 Exam memory hook

The truth command:

    ip route get <target>

