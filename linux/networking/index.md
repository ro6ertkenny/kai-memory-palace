# 🌐 Linux Networking — Index
*Understanding how Linux connects, routes, and exposes services*

---

## 📌 Purpose

This index is the **navigation map** for the `linux/networking` wing.

It answers the question:

> “When networking is broken, where do I look and in what order?”

This wing is about **systematic reasoning**, not memorizing commands.

---

## 🧠 Mental Model

Linux networking is **layered**:

1. Link (is there a usable interface?)
2. Address (does it have an IP?)
3. Route (does it know where to send packets?)
4. Name (can it resolve hostnames?)
5. Service (is something listening?)
6. Application (does the protocol work?)

If you skip layers, you will misdiagnose problems.

---

## 🔁 Recommended Reading Order

Read these **in order**. Each builds on the previous one.

---

### 1️⃣ `networking-basics.md`
Defines:
- what a network stack is
- what interfaces, addresses, routes, ports, and protocols are
- the vocabulary of networking

Start here to align concepts.

---

### 2️⃣ `interface-and-addressing.md`
Defines:
- how to inspect interfaces (`ip link`)
- how to inspect addresses (`ip a`)
- link state vs address state
- what makes an interface actually usable

This answers:

> “Is this host even connected to anything?”

---

### 3️⃣ `routes-and-reachability.md`
Defines:
- how to read `ip r`
- what the default route is
- how Linux chooses paths
- how to use `ip route get`

This answers:

> “Where will packets go and why?”

---

### 4️⃣ `dns-and-name-resolution.md`
Defines:
- `/etc/resolv.conf`
- `getent`
- NSS (`/etc/nsswitch.conf`)
- why names sometimes fail but IPs work

This answers:

> “Why does 8.8.8.8 work but google.com does not?”

---

### 5️⃣ `ports-and-listeners.md`
Defines:
- how to read `ss -tulpen`
- LISTEN vs ESTAB vs TIME-WAIT
- loopback-only services
- mapping ports to processes

This answers:

> “Is the service actually reachable?”

---

### 6️⃣ `network-debugging-checklist.md`
Defines:
- the **authoritative exam-grade debug order**
- how to triage any network failure
- how to never guess and never skip layers

This is the **capstone operational playbook**.

---

### 7️⃣ `firewall-operator-basics.md`

Defines:
- how to identify which firewall system is active (nftables / iptables / ufw / firewalld)
- how to list active rules
- how to prove whether the firewall is blocking traffic
- how to safely open a port (without locking yourself out)
- how to verify end-to-end connectivity

This answers:

> “Is the firewall blocking this traffic?”

---

### 8️⃣ `ssh-operator-basics.md`

Defines:
- how to verify sshd service state
- how to verify listening ports
- how to distinguish service vs firewall vs auth failures
- how to read ssh client errors (`ssh -v`)
- how to diagnose and fix:
  - service down
  - wrong port
  - firewall blocking
  - key / permission problems
  - bad sshd_config

This answers:

> “Why can’t I SSH into this machine?”

---

### 9️⃣ `bridge-and-bonding-operator-basics.md`

Defines:
- what a bridge is and how to recognize one
- what bonding is and how to recognize it
- how to inspect:
  - which interfaces are enslaved
  - where the IP address actually lives
  - which device actually carries traffic
- how to verify the real egress path using `ip route get`

This answers:

> “Which interface is actually carrying my traffic, and why?”

---

### 🔟 `load-balancer-operator-basics.md`

Defines:
- what a load balancer / reverse proxy is at the operator level
- how to configure a **minimal** nginx or HAProxy load balancer
- how to verify:
  - the frontend is listening
  - backends are reachable
  - traffic is actually being forwarded
- how to diagnose:
  - all backends down
  - partial backend failure
  - misconfiguration (502/504)
  - firewall or bind-address issues

This answers:

> “Is the failure in the client, the load balancer, or the backend pool?”

---

## 📚 Supporting Files

- `mistakes.md`  
  Common conceptual and operational mistakes.

- `../troubleshooting/operator-playbooks/core/domain-playbooks/firewall-blocking-traffic.md`

- `README.md`  
  Scope, philosophy, and how this wing fits into the palace.

---

## ⚠️ Common Failure Pattern

> **Jumping to DNS, firewall, or services before checking link and address.**

Always start at the bottom of the stack.

---

## ▶️ How to Use This Wing

- New to Linux networking → read top to bottom
- Debugging a real issue → jump straight to `network-debugging-checklist.md`
- Something “mysterious” → trace it layer by layer

---

## ✅ Outcome

If you understand this wing:

- networking stops feeling random
- failures become **mechanical to diagnose**
- the LFCS networking section becomes **free points**

---
EOF

