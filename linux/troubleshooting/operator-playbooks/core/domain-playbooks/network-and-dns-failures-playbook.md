# 🌐 Network & DNS Failures — Operator Playbook

**Domain:** Connectivity, name resolution, and packet delivery  
**Mental mode:** Path, not process  
**Goal:** Determine whether the system can reliably resolve names and move packets to their destination

---

## 📌 What This Domain Actually Covers

This domain is about:

- Can we **resolve names**?
- Can we **establish connections**?
- Can packets **reach the destination and return**?
- Is the failure:
  - Local?
  - Remote?
  - Intermittent?
  - Asymmetric?

Most “mysterious” production issues are:

> Partial connectivity failures, not total outages.

---

## 🧠 The Mental Model

Every network request requires:

1. Name resolution (DNS)
2. Routing decision
3. Packet delivery out
4. Packet delivery back
5. No middlebox interference

Failure can occur at **any step**.

So always decompose:

> Is this a DNS problem, a routing problem, or a packet delivery problem?

---

## 🔥 Primary Fast Signals

Run these immediately:

    ip addr
    ip route
    resolvectl status || cat /etc/resolv.conf
    ping -c 3 1.1.1.1
    ping -c 3 google.com
    curl -v https://example.com

Interpretation:

- If IP ping works but name ping fails → DNS
- If name resolves but connect hangs → network path or firewall
- If some destinations work and others don’t → routing or ACLs
- If it works “sometimes” → packet loss or timeouts

---

## 🧭 DNS-Specific Triage

    resolvectl query google.com || dig google.com || nslookup google.com

Check:

- Which server is being used
- How long it takes
- Whether failures are:
  - NXDOMAIN
  - timeout
  - SERVFAIL

Also check:

    cat /etc/nsswitch.conf

Make sure resolution order is sane.

---

## 🧪 Deep Inspection Commands

### Interface and link state

    ip link
    ethtool <iface>

### Routing

    ip route
    ip rule

### Sockets

    ss -lntup
    ss -s

### Packet loss

    ping -i 0.2 -c 20 <target>

### Path inspection

    traceroute <target>
    tracepath <target>

---

## 🧯 Common Root Cause Classes

1. **DNS failures**
   - Resolver unreachable
   - Broken stub resolver
   - Search domain issues
   - systemd-resolved misbehavior

2. **Routing issues**
   - Wrong default route
   - Missing route to subnet
   - Policy routing mistakes

3. **Firewall / ACL**
   - Local iptables/nftables
   - Cloud security groups
   - Corporate middleboxes

4. **Packet loss / MTU issues**
   - Intermittent failures
   - TLS hangs
   - “Sometimes it works”

5. **Connection tracking exhaustion**
   - Many short-lived connections
   - New connections fail, old ones work

---

## 🛑 Stabilization Actions (In Order)

1. **Check local config**

        ip addr
        ip route
        resolvectl status || cat /etc/resolv.conf

2. **Differentiate DNS vs network**

        ping 1.1.1.1
        ping google.com

3. **Test with IP instead of name**

        curl http://<ip>

4. **Check for firewall rules**

        iptables -L -n || nft list ruleset

5. **If in Kubernetes or cloud**
   - Check security groups / network policies
   - Check CNI status

---

## ⚠️ Dangerous Misinterpretations

- “The service is down”
  - Often it is DNS.

- “It works from my machine”
  - Then this is **path-specific**.

- “It fails randomly”
  - That is usually packet loss, MTU, or state exhaustion.

---

## 🧨 When This Becomes Systemic

You will see:

- Timeouts everywhere
- TLS handshakes hanging
- Services flapping between healthy/unhealthy
- Kubernetes probes failing intermittently
- Distributed systems behaving erratically

At this point:

> You are debugging the **network fabric**, not an application.

---

## 🧱 Escalation Criteria

Escalate or drain the node if:

- The node cannot reliably resolve DNS
- The node has unstable connectivity
- Packet loss is sustained
- Core services cannot reach dependencies

In Kubernetes:

> Drain the node. Unreliable networking breaks the cluster.

---

## 🧠 Canonical Summary

- Network failures are about **paths and packets**
- DNS failures are about **names, not services**
- Always split the problem:
  > “Is this name resolution, or packet delivery?”

---

## 🧭 This Domain Explains These Scenarios

- “Sometimes it works”
- “Only from some nodes”
- “It times out but nothing is down”
- “Works with IP but not hostname”
- “Random connection failures”

All of these reduce to:

> The path between two endpoints is unreliable or misconfigured.

---
