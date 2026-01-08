cat << 'EOF' > linux/networking/routes-and-reachability.md
# 🧭 routes-and-reachability.md — Where Packets Go and Why

## 🎯 Purpose

Understand **how Linux decides where packets are sent**.

This file trains you to:

- read the routing table
- understand default routes vs specific routes
- explain why a destination is or is not reachable
- diagnose “I have an IP but nothing works” failures

If you cannot explain **where traffic should go**, connectivity problems will feel random.

---

## 🧠 Mental Rule

**Link → Address → Route → Reachability**

Routes only matter **after**:

- the interface is up
- the interface has a valid address

---

## 🔎 Core Commands

- `ip r` → show routing table
- `ip route get 1.1.1.1` → ask kernel: “which path would you use?”

---

# 🧱 Part 1 — Reading the Routing Table (`ip r`)

Run:

    ip r

Example:

    default via 192.168.1.254 dev wlx14ebb68f087a
    192.168.1.0/24 dev wlx14ebb68f087a proto kernel scope link src 192.168.1.86
    172.17.0.0/16 dev docker0 scope link

---

## 🧠 How to Read a Route Line

Example:

    default via 192.168.1.254 dev wlx14ebb68f087a

Meaning:

- `default` = any destination not matched by more specific routes
- `via 192.168.1.254` = send to this gateway
- `dev wlx14ebb68f087a` = use this interface

Example:

    192.168.1.0/24 dev wlx14ebb68f087a scope link src 192.168.1.86

Meaning:

- destination network = 192.168.1.0/24
- reachable directly on that interface
- source address will be 192.168.1.86

---

## 🧠 What `ip r` Really Means

> This is the kernel’s **decision table** for where packets go.

If there is **no matching route**, the packet is dropped.

---

# 🧱 Part 2 — Longest Prefix Wins

Linux chooses:

> **The most specific matching route.**

So:

- `10.0.0.0/8`
- `10.1.0.0/16`
- `10.1.2.0/24`

A packet to `10.1.2.5` uses:

> `10.1.2.0/24` (most specific)

---

# 🧱 Part 3 — The Default Route

The default route is:

> “Where traffic goes if nothing else matches.”

Example:

    default via 192.168.1.254 dev wlx14ebb68f087a

If this is missing:

> The machine cannot reach the internet.

---

# 🧱 Part 4 — Asking the Kernel Directly (`ip route get`)

Run:

    ip route get 1.1.1.1

Example output:

    1.1.1.1 via 192.168.1.254 dev wlx14ebb68f087a src 192.168.1.86 uid 1000

Meaning:

- destination: 1.1.1.1
- gateway: 192.168.1.254
- interface: wlx14ebb68f087a
- source IP: 192.168.1.86

This is **exam gold**:

> It tells you exactly what Linux would do.

---

# 🧱 Part 5 — Connected vs Routed Networks

Example:

    192.168.1.0/24 dev wlx14ebb68f087a scope link

Means:

- this network is **directly attached**
- no gateway is needed
- ARP / neighbor discovery is used

---

# 🧯 Exam-Grade Failure Patterns

- If there is **no default route** → internet will not work
- If route points to **wrong interface** → packets disappear
- If interface is DOWN → route is useless
- If address is wrong → route may exist but still fail

---

# 🧪 Debug Order (Never Skip)

1. `ip link`
2. `ip a`
3. `ip r`
4. `ip route get <destination>`
5. `ping`

---

# 🧪 Practical Drills

Run:

    ip r
    ip route get 1.1.1.1
    ip route get 192.168.1.1
    ip route get 8.8.8.8

Explain for each:

- which interface is used
- whether a gateway is used
- what source IP is chosen

---

## ✅ Exit Criteria

You are done with this file when:

- `ip r` feels readable
- `ip route get` feels obvious
- you can explain **why** a packet goes where it goes

You now understand **routes and reachability**.
EOF

