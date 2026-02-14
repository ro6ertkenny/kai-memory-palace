# 🌐 Interface and Addressing (ip a) — Operator Canonical (LFCS)

Goal: prove **the host is actually connected and has a usable address**.

---

## 🧠 Operator mental model

Link → Address → Route

If link or address is wrong, nothing above works.

Two layers of UP:

- UP → admin enabled
- LOWER_UP → physical carrier present

Usable = UP + LOWER_UP + valid IP.

---

## ✅ Safe command order

    ip -br link
    ip -br a
    ip a show dev <iface>

---

## 🔎 Core workflows

### Compact overview (fast exam read)

    ip -br a

### Verify physical usability

    ip link show dev <iface>

LOWER_UP required for real connectivity.

### Show only IPv4

    ip -4 a

### Bring interface up (temporary)

    sudo ip link set dev <iface> up

### Add temporary address

    sudo ip addr add 192.168.1.10/24 dev <iface>

Remove:

    sudo ip addr del 192.168.1.10/24 dev <iface>

---

## 🧯 Failure-mode debugging

Interface DOWN:

    sudo ip link set dev <iface> up

UP but NO-CARRIER:

→ unplugged / not associated.

No inet address:

→ no L3 connectivity possible.

Ping works for 127.0.0.1 only:

→ interface or route problem.

---

## 🔗 Drill references

- linux/LFCS-training/execution-drills/networking-interface-and-addressing.md
- linux/LFCS-training/execution-drills/link-state-debug.md

---

## 🪝 Exam memory hook

Link → Address → Route

If this is wrong, stop here:

    ip -br a

