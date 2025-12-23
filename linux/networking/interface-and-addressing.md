# 🔌 interface-and-addressing.md — Seeing How a Host Is Connected

## 🎯 Purpose
Understand **how a Linux system is attached to a network**.

This file trains habits for:
- identifying network interfaces
- understanding link state
- inspecting IP addressing
- determining whether the host is reachable

If you cannot explain how the host is connected, nothing else matters.

---

## 🧠 Mental Rule
**Link before address. Address before route.**

If the interface is down, no higher-layer fixes will work.

---

## 🧩 Network Interfaces
A network interface is how the host connects to a network.

Interfaces may be:
- physical (ethernet, wifi)
- virtual (bridges, veth pairs, tunnels)
- loopback (lo)

Always start by listing interfaces.

Key questions:
- which interfaces exist
- which are up
- which are down
- which should be active

---

## 🔎 Inspecting Interfaces
Primary inspection tools:
- ip link
- ip addr

Things to observe:
- interface name
- state (UP or DOWN)
- assigned addresses
- whether the interface is loopback or external

Do not assume interface names.

---

## 🔗 Link State
Link state determines whether the interface can transmit.

Indicators:
- UP means the interface is administratively enabled
- DOWN means traffic cannot pass
- LOWER_UP indicates physical link presence

If link is down, stop here.

---

## 📬 IP Addressing
Addresses define how the host is identified on the network.

Address types:
- IPv4
- IPv6

Inspect:
- assigned addresses
- subnet masks
- scope (global, link-local, loopback)

Questions to answer:
- does the host have an address
- is the address in the expected subnet
- is the address appropriate for the interface

---

## 🧪 Multiple Addresses
Interfaces may have more than one address.

Common reasons:
- IPv4 and IPv6 coexistence
- temporary or secondary addresses
- container or virtualization overlays

Multiple addresses are normal.  
Unexpected addresses are not.

---

## 🔁 Address Assignment
Addresses may be assigned by:
- DHCP
- static configuration
- system services
- container runtimes

Know whether addressing is:
- expected
- persistent
- managed automatically

Misunderstanding this causes “it worked, then broke” problems.

---

## 🧪 Daily Drill (5 minutes)
On a running system:

- list interfaces
- identify the primary external interface
- inspect its addresses
- explain whether the host should be reachable

Do not test connectivity yet.  
Just observe and explain.

---

## 🧯 Common Mistakes
- skipping link state checks
- assuming interface names
- ignoring IPv6 addresses
- confusing loopback with external interfaces

If confused, return to link state.

---

## ✅ Exit Criteria
You are done with this file when:
- interface listings feel readable
- address assignments make sense
- you can explain how the host is connected

You now understand interface and addressing state.
