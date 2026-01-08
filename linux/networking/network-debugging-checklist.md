# 🧪 network-debugging-checklist.md — Exam-Grade Network Triage

## 🎯 Purpose

This is the **authoritative, step-by-step checklist** for debugging **any Linux network problem**.

It turns “network is broken” into a **deterministic procedure**.

If you follow this order, you will:

- never guess
- never skip layers
- never chase symptoms
- always find the real failure point

This is **exam gold**.

---

## 🧠 The Only Correct Order

> **Link → Address → Route → Name → Service → Application**

If you skip a layer, you will misdiagnose the problem.

---

# 🧱 Step 1 — Link Layer

Run:

    ip link

Ask:

- is the correct interface present?
- is it UP?
- is it LOWER_UP?
- is it NO-CARRIER?

If you see:

- `NO-CARRIER` → stop. Physical / association problem.
- `DOWN` → bring it up.

Nothing else matters until this is correct.

---

# 🧱 Step 2 — Addressing

Run:

    ip a

Ask:

- does the interface have an `inet` or `inet6` address?
- is it in the correct subnet?
- is the scope `global`?

If:

- no address → nothing can work.
- only `scope link` → not routable.

---

# 🧱 Step 3 — Routing

Run:

    ip r

Ask:

- is there a default route?
- does it point to the correct interface?
- does it point to the correct gateway?

Then:

    ip route get 1.1.1.1

This tells you exactly what the kernel would do.

If there is no route → packet is dropped.

---

# 🧱 Step 4 — Raw Reachability

Run:

    ping 1.1.1.1

If this fails:

> You have a pure routing or link problem. DNS is irrelevant.

---

# 🧱 Step 5 — Name Resolution

Run:

    getent hosts google.com

If this fails but ping IP works:

> DNS / NSS problem.

Check:

    cat /etc/resolv.conf
    cat /etc/nsswitch.conf | grep hosts

---

# 🧱 Step 6 — Service Reachability

Run:

    ss -tulpen

Ask:

- is the service LISTENing?
- on what address?
- is it loopback-only?
- on the expected port?

Common trap:

> Service is bound to 127.0.0.1 → not reachable remotely.

---

# 🧱 Step 7 — Test the Actual Protocol

Examples:

    curl http://example.com
    curl https://example.com
    nc -vz host port

This tests:

- DNS
- routing
- TCP
- service
- application layer

---

# 🧯 Exam-Grade Failure Patterns

- No carrier → physical
- No inet → DHCP / config
- No default route → no internet
- Ping IP works, name fails → DNS
- Service running but unreachable → bound to loopback
- ss shows nothing listening → service is not actually running

---

# 🧪 One-Page Emergency Flow

1. `ip link`
2. `ip a`
3. `ip r`
4. `ip route get 1.1.1.1`
5. `ping 1.1.1.1`
6. `getent hosts google.com`
7. `ss -tulpen`
8. `curl ...`

---

## ✅ Exit Criteria

You are done when:

- you can run this checklist **from memory**
- you never guess
- you always know **which layer is broken**

You now have **exam-grade network debugging discipline**.
EOF

