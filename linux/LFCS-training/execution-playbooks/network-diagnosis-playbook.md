# 🌐 Network Diagnosis Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`  
Mental mode: **Measure → Classify → Isolate by Layer → Fix → Verify → Persist**  
Purpose: Restore **basic connectivity and service reachability** using a **safe, exam-grade operator algorithm**.

This is **not** a tutorial.  
This is a **live-system diagnosis and recovery playbook**.

---

## 🧠 When To Use This Playbook

Use this playbook when:

- The host has **no network connectivity**
- The host cannot reach **gateway, DNS, or internet**
- Clients cannot reach a service
- A service is running but **not reachable**
- An interface is **down or misconfigured**

Do **not** use this playbook if the **first evidence** points to:

- service not running → `service-recovery-playbook.md`
- disk, mount, or boot failure → `storage-recovery-playbook.md`
- process storm or local resource collapse → `process-control-playbook.md`
- SELinux / policy as primary root cause → `security-triage-playbook.md`

---

## 🧭 Scenarios That Validate This Playbook

This playbook is exercised by:

- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md` (when root cause is reachability)
- `linux/LFCS-training/failure-scenarios/scenario-8-dns-resolution-failing.md`

If you cannot solve those scenarios **cleanly and repeatably**, this playbook is not yet fluent.

---

## 🧪 Drills Required For Fluency

You should be mechanically fluent with:

- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

This playbook is a **composition layer**, not a source of primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1. Observe
2. Preserve evidence
3. Establish local stack health (link, IP, route)
4. Establish L3 reachability (gateway → external IP)
5. Establish DNS
6. Establish service reachability
7. Correct (minimal, reversible)
8. Verify
9. Make persistent
10. Roll back if needed

Never assume “it’s the firewall” first.

---

## 🧭 Global Safety Rules

- Preserve evidence first.
- Test **by layer**: link → IP → route → gateway → external IP → DNS → service.
- Prefer minimal, reversible changes.
- Keep one root-capable session open when changing firewall rules on remote systems.
- Every action requires verification.

---

## 🧾 Phase 0 — Capture Evidence (Before Any Changes)

Create a quick evidence bundle:

  mkdir -p /tmp/net-evidence
  ip a > /tmp/net-evidence/ip-a.txt
  ip link > /tmp/net-evidence/ip-link.txt
  ip route > /tmp/net-evidence/ip-route.txt
  ss -lntup > /tmp/net-evidence/listeners.txt

Resolver evidence (modern + fallback):

  resolvectl status > /tmp/net-evidence/resolvectl.txt 2>/dev/null || true
  cat /etc/resolv.conf > /tmp/net-evidence/resolv.conf.txt 2>/dev/null || true

Optional (fast routing proof to a destination):

  ip route get 8.8.8.8 > /tmp/net-evidence/route-to-8.8.8.8.txt 2>/dev/null || true

---

## 🧪 Phase 1 — Observe Current State (No Changes)

Interfaces and addresses:

  ip a

Link state:

  ip link

Routes:

  ip route

DNS config (systemd-resolved if present):

  resolvectl status 2>/dev/null || cat /etc/resolv.conf

Decision gate:

- If **no interface has an IP** → Bucket A
- If **has IP but no default route** → Bucket B
- If **has IP + route but can’t reach gateway/external IP** → Bucket C
- If **can reach external IP but cannot resolve names** → Bucket D
- If **host connectivity is OK but service is unreachable** → Bucket E

---

## 🧭 Classification Buckets

A) Interface has no IP  
B) No default route  
C) L3 connectivity failure (gateway/external IP unreachable)  
D) DNS failure (names don’t resolve)  
E) Service reachability failure (host OK, service unreachable)  
F) Not actually a network problem (exit playbook)

---

## 🧪 Phase 2 — Bucket A: Interface Has No IP

Confirm interface is up:

  ip link

Bring it up:

  sudo ip link set <iface> up

If using DHCP:

  sudo dhclient <iface>

Re-check:

  ip a

If still no IP:

- Check distro-specific network configuration
- Make **one** change at a time
- Return to Phase 1

---

## 🧪 Phase 3 — Bucket B: No Default Route

Confirm:

  ip route

Add temporary route (only if you know gateway is correct):

  sudo ip route add default via <gateway>

Verify:

  ip route
  ping -c 3 <gateway>

If it works:

- Fix persistent configuration
- Go to Phase 8

If not:

  sudo ip route del default

Return to Phase 1

---

## 🧪 Phase 4 — Bucket C: Test Layer 3 Connectivity

Ping gateway:

  ping -c 3 <gateway>

Ping external IP:

  ping -c 3 8.8.8.8

Decision:

- If **can’t reach gateway** → return to Buckets A/B
- If **can reach external IP but not domains** → Bucket D (DNS)
- If **can’t reach external IP** → inspect firewall and upstream routing (Phase 6)

---

## 🧪 Phase 5 — Bucket D: DNS Failure

Test resolution:

  getent hosts google.com

Optional deeper proof:

  dig google.com 2>/dev/null || true
  resolvectl query google.com 2>/dev/null || true

If resolution fails:

- Fix DNS servers in `/etc/resolv.conf` or system resolver config
- Flush caches if applicable:

  sudo resolvectl flush-caches 2>/dev/null || true

Re-test:

  getent hosts google.com

Then return to Phase 4.

---

## 🧪 Phase 6 — Firewall / Policy Check (Only After L3 Fails)

Inspect first (read-only):

  sudo ufw status numbered 2>/dev/null || true
  sudo nft list ruleset 2>/dev/null || true
  sudo iptables -L -n -v 2>/dev/null || true
  sudo iptables -t nat -L -n -v 2>/dev/null || true

If you suspect firewall is blocking and it is safe to modify:

- Prefer targeted changes (allow required port/subnet) over flushing.

Last resort (lab/local console only; dangerous remotely):

  sudo iptables -F

Re-test:

  ping -c 3 8.8.8.8

If firewall was cause:

- Restore correct rules
- Do not leave system exposed

---

## 🧪 Phase 7 — Bucket E: Service Reachability Failure

Confirm host connectivity first:

  ping -c 3 8.8.8.8
  getent hosts google.com

Check listener:

  ss -lntup | grep <port> || true

Test locally:

  curl -I http://127.0.0.1:<port> 2>/dev/null | head -n 5 || true

Decision:

- If **not listening** → exit to `service-recovery-playbook.md`
- If **bound only to 127.0.0.1** → fix service config (bind address / listen)
- If **listening correctly but unreachable** → firewall or SELinux

If SELinux is relevant:

  getenforce 2>/dev/null || true
  ausearch -m avc -ts recent 2>/dev/null || true

If policy is the blocker → exit to `security-triage-playbook.md`

---

## 🧪 Phase 8 — Verification Gate

Verify:

  ip a
  ip route
  ping -c 3 <gateway>
  ping -c 3 8.8.8.8
  getent hosts google.com

If service-related:

  ss -lntup | grep <port> || true
  curl -I http://127.0.0.1:<port> 2>/dev/null | head -n 5 || true

---

## 🧪 Phase 9 — Persistence Check

Ensure config survives reboot.

If safe and allowed:

  sudo reboot

After reboot:

  ip a
  ip route
  ping -c 3 8.8.8.8
  getent hosts google.com

---

## 🔁 Rollback Strategy

If a change breaks networking:

- Revert **only the last change**
- Remove temporary routes:

  sudo ip route del default

- Restore firewall rules if modified
- Return to Phase 1

---

## 🚫 Anti-Patterns (Auto-Fail)

- Testing DNS before IP
- Flushing firewall as first move
- Making multiple changes at once
- Debugging service before host connectivity is proven

---

## 🧭 Exit Conditions

Exit this playbook if you discover:

- service is not running → `service-recovery-playbook.md`
- storage or boot failure → `storage-recovery-playbook.md`
- process/resource collapse → `process-control-playbook.md`
- SELinux is primary cause → `security-triage-playbook.md`

---

## ✅ Completion Criteria

- Interface has IP
- Default route exists
- Can ping gateway
- Can ping external IP
- DNS resolves
- Service (if applicable) is reachable

You can explain:

- Which layer failed
- What evidence proved it
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Operator Loop (Reinforced)

Symptom → Measure → Isolate by Layer → Fix → Verify → Persist

Never skip layers.

---

