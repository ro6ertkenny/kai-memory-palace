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
2. Establish local stack health (link, IP, route)
3. Establish L3 reachability
4. Establish DNS
5. Establish service reachability
6. Correct
7. Verify
8. Make persistent
9. Roll back if needed

> **Never assume “it’s the firewall” first.**

---

## 🧭 Global Safety Rules

- Preserve evidence first.
- Test **by layer**: link → IP → route → gateway → external IP → DNS → service.
- Prefer minimal, reversible changes.
- Avoid destructive firewall tests.
- Every action requires verification.

---

## 🧪 Phase 1 — Observe Current State (No Changes)

Interfaces and addresses:

  ip a  

Link state:

  ip link  

Routes:

  ip route  

DNS config:

  cat /etc/resolv.conf  

Decision gate:

- If **no interface has an IP** → Bucket A
- If **has IP but no default route** → Bucket B
- If **has IP + route but can’t reach outside** → Bucket C
- If **host has connectivity but service unreachable** → Bucket D

---

## 🧭 Classification Buckets

A) Interface has no IP  
B) No default route  
C) L3 connectivity failure  
D) DNS failure  
E) Service reachability failure  
F) Not actually a network problem (exit playbook)

---

## 🧪 Phase 2 — Bucket A: Interface Has No IP

Confirm interface is up:

  ip link  

Bring it up:

  ip link set <iface> up  

If using DHCP:

  dhclient <iface>  

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

  ip route add default via <gateway>  

Verify:

  ip route  
  ping -c 3 <gateway>  

If it works:

- Fix persistent configuration
- Go to Phase 8

If not:

  ip route del default  

Return to Phase 1

---

## 🧪 Phase 4 — Bucket C: Test Layer 3 Connectivity

Ping gateway:

  ping -c 3 <gateway>  

Ping external IP:

  ping -c 3 8.8.8.8  

Decision:

- If **can’t reach gateway** → back to Buckets A/B
- If **can reach external IP but not domains** → Bucket D (DNS)
- If **can’t reach external IP** → inspect firewall or upstream routing

---

## 🧪 Phase 5 — Bucket D: DNS Failure

Test resolver:

  getent hosts google.com  

Optional:

  dig google.com  

If resolution fails:

- Fix DNS servers in `/etc/resolv.conf` or system config
- Re-test
- Return to Phase 4

---

## 🧪 Phase 6 — Firewall / Policy Check (Only After L3 Fails)

Inspect rules (one may exist):

  iptables -L  
  nft list ruleset  

Prefer:

- targeted inspection and changes

Temporary flush **only if safe**:

  iptables -F  

Re-test:

  ping -c 3 8.8.8.8  

If firewall was cause:

- Restore correct rules
- Do not leave system exposed

---

## 🧪 Phase 7 — Bucket E: Service Reachability Failure

Check listener:

  ss -lntup | grep <port>  

Test locally:

  curl localhost:<port>  

Test remotely if possible:

  curl <host>:<port>  

Decision:

- If **not listening** → exit to `service-recovery-playbook.md`
- If **bound only to 127.0.0.1** → fix service config
- If **listening correctly but unreachable** → firewall or SELinux

If SELinux is relevant:

  getenforce  
  ausearch -m avc -ts recent || true  

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

  ss -lntup | grep <port>  
  curl localhost:<port>  

---

## 🧪 Phase 9 — Persistence Check

Ensure config survives reboot.

If safe and allowed:

  reboot  

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

  ip route del default  

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
