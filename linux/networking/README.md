# 🌐 Linux Networking
*Understanding how Linux connects, routes, secures, and exposes services*

---

## 🎯 Purpose

This directory exists to make Linux networking **predictable, inspectable, and debuggable**.

Most networking problems feel “mysterious” only because people:

- skip layers
- guess
- jump to tools instead of state

This wing trains **layered, mechanical reasoning**.

---

## 🧠 Mental Model

Linux networking is a **stack of independent layers**:

1. **Link** — is there a usable interface?
2. **Address** — does it have an IP?
3. **Route** — does it know where to send packets?
4. **Name** — can it resolve hostnames?
5. **Service** — is something listening?
6. **Access** — is traffic allowed (firewall / policy)?
7. **Application** — does the protocol work?

> You must debug **from the bottom up**.

If you skip layers, you will misdiagnose the problem.

---

## 🧭 What This Wing Covers

This wing teaches you to:

- inspect interfaces and link state (`ip link`)
- inspect addresses (`ip a`)
- read and reason about routes (`ip r`, `ip route get`)
- understand name resolution (NSS, `getent`, `resolv.conf`)
- inspect listening services (`ss -tulpen`)
- debug failures **systematically** instead of guessing
- 🔥 **Firewalling**:
  - how to inspect active rules
  - how to prove whether traffic is being blocked
  - how to safely open a port
  - how to verify end-to-end reachability  
  See: `firewall-operator-basics.md`
- 🔐 **SSH access**:
  - how to verify sshd service and ports
  - how to distinguish network vs firewall vs auth failures
  - how to fix key, permission, config, and service issues  
  See: `ssh-operator-basics.md`

---

## 🧱 What This Wing Does NOT Cover

- advanced routing protocols (BGP, OSPF, etc.)
- deep firewall design or policy architecture
- performance tuning
- deep TCP internals

This wing is about **operational correctness and diagnosis**, not optimization or large-scale network engineering.

---

## 📚 How the Content Is Organized

The canonical navigation order is in:

> `index.md`

Conceptually, the flow is:

1. **Basics** → vocabulary and concepts
2. **Interface & Addressing** → is the host connected?
3. **Routes & Reachability** → where will packets go?
4. **Name Resolution** → how names become IPs
5. **Ports & Listeners** → is the service reachable?
6. **Firewalling** → is traffic being allowed or blocked?
7. **SSH Access** → can you actually log in?
8. **Debug Checklist** → the exam-grade operator flow

Each file owns **one layer of the stack**.

---

## 🏁 End State

When this wing is mastered:

- You do not guess.
- You do not jump layers.
- You can explain **any** network failure in terms of:
  - link
  - address
  - route
  - name
  - service
  - access
  - application
- And you can fix it **mechanically under pressure**.

