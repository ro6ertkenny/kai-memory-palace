# 🧪 LFCS Execution Drills — Phase 13
# 🌐 Networking Fundamentals: Interfaces, Addresses, Routes, and Name Resolution

Path:
  linux/execution-drills/phase-13-networking-basics.md

Purpose:
  Build reflex-level diagnosis and configuration of interfaces, IP addresses, routes, and name resolution.

Mental Mode:
  Always debug in this order:
  1) Interface exists?
  2) IP assigned?
  3) Route exists?
  4) Name resolves?

---

## 🧱 Lab Safety Rules

⚠️ Do NOT break your main network connection.
⚠️ Prefer:
- a VM
- or a secondary interface
- or dummy interfaces

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-13
    cd ~/lfcs-labs/execution-drills/phase-13

Install tools (if missing):

    sudo apt update
    sudo apt install -y net-tools iproute2

---

# A) Inspect Interfaces and Addresses

## A1 — Inventory

    ip a
    ip link

Save output:

    ip a > interfaces.txt

---

## A2 — Inspect specific interface

(Replace with a real interface name on your system.)

    ip a show eth0 || ip a show enp0s3 || true

---

## A3 — Find which interface owns an IP

    ip a | grep -i 127.0.0.1

(Use a real IP if needed.)

---

# B) Routes

## B1 — Show routes

    ip route
    ip route show

Save:

    ip route show > routes.txt

---

## B2 — Show default gateway

    ip route | grep default

---

# C) Temporary IP Configuration (Runtime Only)

⚠️ Use a dummy interface.

## C1 — Create dummy interface

    sudo ip link add dummy13 type dummy
    sudo ip link set dummy13 up
    ip link show dummy13

---

## C2 — Add IP

    sudo ip a add 192.168.13.10/24 dev dummy13
    ip a show dummy13

---

## C3 — Remove IP

    sudo ip a del 192.168.13.10/24 dev dummy13

---

## C4 — Delete interface

    sudo ip link del dummy13

Explain:
- ip commands are **not persistent**

---

# D) Persistent Config (Netplan) — Inspect Only Unless in VM

## D1 — View netplan files

    ls -l /etc/netplan
    sudo cat /etc/netplan/*.yaml

Explain structure:
- version
- ethernets
- addresses
- routes
- nameservers

---

## D2 — Safe test command

    sudo netplan try

(Abort if it would break connectivity.)

---

# E) Static Routes (Runtime)

## E1 — Add temporary route

    sudo ip route add 10.13.0.0/16 via 192.168.1.1 || true

Check:

    ip route

---

## E2 — Remove route

    sudo ip route del 10.13.0.0/16 || true

---

# F) Name Resolution

## F1 — Check resolver

    resolvectl status || true
    cat /etc/resolv.conf

---

## F2 — Local hosts override

Edit:

    sudo vi /etc/hosts

Add:

    127.0.0.1 phase13.test

Test:

    ping -c 1 phase13.test

---

# G) Listening Ports

## G1 — List listeners

    ss -tlnp
    sudo netstat -tulpn

---

## G2 — Check common ports

    ss -tlnp | grep :22 || true
    ss -tlnp | grep :80 || true

---

# H) Connectivity Tests

## H1 — Test raw IP

    ping -c 3 8.8.8.8

## H2 — Test DNS

    ping -c 3 google.com || true

## H3 — Test local service

    curl -I http://127.0.0.1 || true

---

# I) Timed Drills

## I1 — Save routes to file (10 seconds)

    ip route show > ~/lfcs-labs/execution-drills/phase-13/routes.txt

---

## I2 — Find interface owning an IP (10 seconds)

    ip a | grep -i 127.0.0.1

---

## I3 — Show listening SSH port (10 seconds)

    ss -tlnp | grep :22

---

# J) Failure Injection Drills (Mental)

## J1 — “Cannot ping IP”

Checklist:

    ip link
    ip a
    ip route

Conclusion:
- Interface down?
- No IP?
- No route?

---

## J2 — “Can ping IP but not domain”

Checklist:

    resolvectl status
    cat /etc/resolv.conf
    ping 8.8.8.8

Conclusion:
- DNS problem, not network.

---

## J3 — “Service running but unreachable”

Checklist:

    ss -tlnp
    ip a
    ip route
    firewall?

---

# K) Composition (Exam Style)

## K1 — Full diagnosis flow

Scenario:
- Cannot reach http://example.com

Run:

    ip a
    ip route
    ping 8.8.8.8
    resolvectl status
    ping example.com
    ss -tlnp

Explain:
- Which layer is broken?

---

## K2 — Save evidence

    ip a > ips.txt
    ip route > routes.txt
    ss -tlnp > listening.txt

---

# ✅ Phase 13 Completion Criteria

You are Phase 13-ready when you can:

- Inspect interfaces and IPs quickly
- Identify which interface owns an IP
- Inspect and reason about routes and default gateway
- Add and remove temporary IPs and routes
- Understand netplan structure and safety workflow
- Inspect name resolution configuration
- Diagnose connectivity failures by layer
- Verify which services are listening on which ports

---

# 🌐 Phase 13 Law

If you can’t explain:
- which interface
- which IP
- which route
- which resolver

…then you don’t understand why the network works or doesn’t.

---

# Cleanup (Optional)

    sudo ip link del dummy13 || true

---
