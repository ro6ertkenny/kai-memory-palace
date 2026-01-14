# 🧠 Scenario 9 — “DNS / Networking Works Sometimes but Not Always”

**Mental mode:** Connectivity, name resolution, and partial failure  
**Failure class:** Intermittent DNS, routing, or network path instability  
**Goal:** Determine whether the failure is DNS, network, or service-path related

---

## 🎯 The Symptom

- Sometimes requests work
- Sometimes they timeout or fail
- Sometimes only some hosts work
- Sometimes only some domains work
- Retrying “fixes” it (for a while)

Common complaints:

- “The internet is flaky”
- “The API works from some machines but not others”
- “It works, then suddenly doesn’t”

---

## 🧠 The Critical Mental Model

> Intermittent network failures are almost always:
>
> - DNS resolution instability
> - Routing / path issues
> - Packet loss or MTU problems
> - Load balancer / upstream instability
> - Cache inconsistency

First rule:

> **Separate: DNS problems from network path problems.**

---

## 🧪 Phase 1 — Is It DNS or Is It the Network?

### 1) Resolve name repeatedly

    dig example.com
    dig example.com
    dig example.com

Or:

    getent hosts example.com

Watch:

- Do IPs change?
- Do some queries timeout?
- Do some succeed?

If DNS is inconsistent → **DNS problem**.

---

### 2) Bypass DNS completely

Take an IP you got and test it directly:

    curl http://1.2.3.4
    ping 1.2.3.4

If:

- IP works but name doesn’t → **DNS problem**
- IP also fails → **network or service path problem**

---

## 🌐 Phase 2 — Check Local Resolver State

### 1) Who is your resolver?

    resolvectl status

Or:

    cat /etc/resolv.conf

Check:

- Is it systemd-resolved?
- Is it NetworkManager?
- Is it a VPN?
- Is it a corporate DNS?

---

### 2) Test multiple resolvers

    dig example.com @1.1.1.1
    dig example.com @8.8.8.8

If:

- One works, one fails → **resolver path problem**

---

## 🛣️ Phase 3 — Check the Network Path

### 1) Basic reachability

    ping -c 5 1.1.1.1
    ping -c 5 example.com

Look for:

- Packet loss
- Big latency swings

---

### 2) Trace the path

    traceroute example.com

Or:

    tracepath example.com

Look for:

- Hops that sometimes respond, sometimes don’t
- Sudden black holes
- MTU warnings

---

## 🧱 Phase 4 — Check Local Interface and Routing

### 1) Interfaces

    ip a

Look for:

- Flapping interfaces
- Multiple IPs
- VPN tunnels

---

### 2) Routes

    ip route

Look for:

- Multiple default routes
- Weird metrics
- VPN hijacking traffic

---

## 🔥 Phase 5 — Check for MTU / Fragmentation Issues

Classic symptom:

- Small requests work
- Big requests hang or fail

Test:

    ping -M do -s 1400 example.com
    ping -M do -s 1472 example.com

If these fail → **MTU / path MTU issue**.

---

## 🧯 Phase 6 — Check Caches and Load Balancers

Intermittent failures often come from:

- DNS cache poisoning / stale entries
- Some backend nodes are broken, some healthy

Test:

    dig example.com +short

If it returns multiple IPs:

Try each one:

    curl http://ip1
    curl http://ip2

If one fails and one works → **upstream pool is partially broken**.

---

## 🧠 Phase 7 — Compare Machines

If possible:

- Test from another machine
- Test from the same network
- Test from another network (phone hotspot)

If:

- Only one machine fails → local config
- Only one network fails → routing / ISP / firewall
- Everywhere fails → upstream service

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| DNS sometimes times out | Resolver issue | Fix / change DNS |
| IP works, name fails | DNS issue | Fix resolver |
| Some backend IPs fail | Partial upstream outage | Remove bad nodes |
| Packet loss in ping | Network instability | Fix link / route |
| Large packets fail | MTU issue | Fix MTU / tunnel |
| Only on VPN | Tunnel routing problem | Fix VPN routes |
| Only this host | Local config | Fix interface / resolver |

---

## ⚠️ Operator Warnings

- “It works sometimes” almost always means **partial failure**.
- Never assume DNS is “fine”.
- Never assume the network is “fine”.

---

## 🏁 The Operator Rule

> First separate **name resolution** from **packet delivery**.

---

## 🧠 One-Sentence Operator Summary

> “When networking is flaky, first prove whether DNS is lying or the network path is dropping packets — then isolate whether the failure is local, upstream, or partial in the backend pool.”

---

## 🧾 The Minimal Proof Commands

    dig example.com
    getent hosts example.com
    ping example.com
    ping 1.1.1.1
    traceroute example.com
    ip a
    ip route
    resolvectl status
    curl http://<backend-ip>

