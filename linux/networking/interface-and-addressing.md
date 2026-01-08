# 🔌 interface-and-addressing.md — Seeing How a Host Is Connected

## 🎯 Purpose

Understand **how a Linux system is attached to a network**.

This file trains habits for:

- identifying network interfaces
- understanding link state (software vs physical)
- inspecting IP addressing
- determining whether the host is even capable of communicating

If you cannot explain **how the host is connected**, nothing else matters.

---

## 🧠 Mental Rule

**Link before address. Address before route.**

If the interface is not usable, no higher-layer fix can work.

---

## 🧩 Network Interfaces

A network interface is how the host connects to a network.

Interfaces may be:

- physical (ethernet, wifi)
- virtual (bridges, veth pairs, dummy, tunnels)
- loopback (lo)

Always start by listing interfaces and asking:

- which interfaces exist?
- which are up?
- which are down?
- which one should be active?

---

## 🔎 Core Inspection Commands

- `ip link` → link-layer state (can it transmit?)
- `ip a` → addressing state (does it have IPs?)

Never assume interface names.

---

# 🧱 Part 1 — Understanding Link State (ip link)

Run:

    ip link

You will see output like:

    eno1: <NO-CARRIER,BROADCAST,MULTICAST,UP> ... state DOWN
    wlx...: <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UP

---

## 🧠 The Two Layers of “Up”

Linux tracks two different things:

- Administrative state (software)
- Physical state (hardware / carrier)

Flags you must understand:

- `UP` = interface is enabled in software
- `DOWN` = interface is disabled in software
- `LOWER_UP` = physical link is present
- `NO-CARRIER` = no physical link

The rule:

> **UP does NOT mean connected.**

Examples:

- `UP + LOWER_UP` → usable
- `UP + NO-CARRIER` → enabled but unplugged / not associated
- `DOWN` → unusable no matter what

---

## 🧠 state UP vs state DOWN

- `state UP` = kernel considers the link operational
- `state DOWN` = kernel considers the link non-operational

This usually tracks **LOWER_UP**, not just `UP`.

---

## 🧱 Example: Wired Interface With No Cable

    eno1: <NO-CARRIER,...,UP> ... state DOWN

Meaning:

- Software enabled ✅
- No cable / no link ❌
- Not usable ❌

---

# 🧱 Part 2 — Understanding Addressing (ip a)

Run:

    ip a

Example lines:

    inet 192.168.1.86/24 scope global wlx...
    inet6 fe80::da41:.../64 scope link

How to read:

    inet 192.168.1.86/24

- `inet` = IPv4
- `192.168.1.86` = the address
- `/24` = prefix length (subnet mask)
- `scope global` = usable for normal communication

    inet6 fe80::.../64 scope link

- IPv6 link-local address
- Only valid on this local network segment

---

## 🧠 Address Scopes You Must Recognize

- `scope global` = normal usable address
- `scope link` = link-local only (not routed)
- `scope host` = loopback

---

## 🧠 Multiple Addresses Are Normal

An interface may have:

- IPv4 and IPv6
- multiple IPv6 addresses
- temporary addresses

This is normal.  
Unexpected addresses are not.

---

# 🧱 Part 3 — The Three Independent Layers

Link state, address state, and routing state are **independent**.

You can have:

- Interface UP but no IP
- Interface has IP but is DOWN
- Interface UP + IP but NO-CARRIER
- Interface perfect but no route

This is why you must inspect in order.

---

# 🧪 Worked Example — Decoding `ip a show dummy0`

You created:

    sudo ip link add dummy0 type dummy
    sudo ip addr add 10.10.10.1/24 dev dummy0
    sudo ip link set dummy0 up

And saw:

    dummy0: <BROADCAST,NOARP,UP,LOWER_UP> ...
    inet 10.10.10.1/24 scope global dummy0
    inet6 fe80::.../64 scope link

How to read this:

- `dummy0` = virtual interface
- `UP` = enabled
- `LOWER_UP` = kernel considers it link-up (dummy always is)
- `inet 10.10.10.1/24` = IPv4 address assigned
- `scope global` = usable address
- `inet6 fe80::...` = automatic IPv6 link-local

This proves:

> You successfully created an interface, gave it an IP, and brought it up.

---

# 🧱 Part 4 — Temporary vs Persistent Configuration

Everything done with:

    ip link ...
    ip addr ...

is:

> ⚠️ **TEMPORARY**

It disappears when:

- you delete the interface
- or you reboot

Permanent configuration is handled by:

- NetworkManager
- or distro network config files

---

# 🧯 Exam-Grade Failure Patterns

- If interface is `NO-CARRIER` → stop. This is a link problem.
- If interface has no `inet` address → stop. Nothing else can work.
- If interface is `DOWN` → bring it up before anything else.
- Do not check routes before link + address.

---

## 🧪 Daily Drill (5 minutes)

- run `ip link`
- identify the real external interface
- check if it is truly usable
- run `ip a`
- explain every address you see

Do not test connectivity yet.  
Just explain the state.

---

## ✅ Exit Criteria

You are done with this file when:

- `ip link` output feels readable
- `ip a` output feels readable
- you can explain:
  - which interface matters
  - whether it is usable
  - and what addresses it has

You now understand **interface and addressing state**.
EOF

