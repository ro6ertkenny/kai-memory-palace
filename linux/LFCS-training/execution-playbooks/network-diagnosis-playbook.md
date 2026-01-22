# 🌐 Network Diagnosis Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`  
**Purpose:** Restore **basic connectivity and service reachability** using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- Host has **no network**
- Cannot reach **gateway / DNS / internet**
- Clients cannot reach a service
- Service is running but **not reachable**
- Interface is **down / misconfigured**

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenario (practice input):

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Observe**
2. **Establish local stack health**
3. **Establish L3 connectivity**
4. **Establish DNS**
5. **Establish service reachability**
6. **Correct**
7. **Verify**
8. **Make persistent**
9. **Rollback if needed**

Never assume “it’s the firewall” first.

---

## 🧭 Global Safety Rules

- **Preserve evidence first.** Observe before changing config or flushing rules.
- **Test by layer:** link → IP → route → gateway → external IP → DNS → service.
- **Prefer minimal, reversible changes.**
- **Avoid destructive firewall tests.** Only do temporary flushes if explicitly safe.
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Target host or service
- Expected behavior:
  - Should it have internet?
  - Should it serve traffic?
  - On which port?

---

## 1) Observe Current State (No Changes)

Interfaces and addresses:

    ip a

Link state:

    ip link

Routes:

    ip route

DNS config:

    cat /etc/resolv.conf

Branch:

- If **no interface has an IP** → go to **Section 2**
- If **has IP but no default route** → go to **Section 3**
- If **has IP + route but can’t reach outside** → go to **Section 4**
- If **host has connectivity but service unreachable** → go to **Section 7**

---

## 2) Interface Has No IP

Confirm interface is up:

    ip link

Bring it up:

    ip link set <iface> up

If using DHCP, request a lease (if available):

    dhclient <iface>

Re-check:

    ip a

If still no IP:

- Check distro-specific network configuration (do not guess).
- Return to **Section 1** after making a single change.

---

## 3) No Default Route

Confirm routes:

    ip route

Add a temporary default route (only if you know the gateway is correct):

    ip route add default via <gateway>

Verify:

    ip route
    ping -c 3 <gateway>

If it works:

- Fix persistent network configuration.
- Go to **Section 8**.

If it does not work:

- Remove the temporary route:

    ip route del default

Return to **Section 1**.

---

## 4) Test Layer 3 Connectivity

Ping gateway:

    ping -c 3 <gateway>

Ping an external IP:

    ping -c 3 8.8.8.8

Branch:

- If **can’t reach gateway** → go back to **Section 2/3**
- If **can reach external IP but not domains** → go to **Section 5**
- If **can’t reach external IP** → go to **Section 6**

---

## 5) DNS Check

Test resolution using system resolver:

    getent hosts google.com

Optional helper if available:

    dig google.com

If resolution fails:

- Inspect and correct DNS server entries:

    cat /etc/resolv.conf

Re-test:

    getent hosts google.com

Return to **Section 4**.

---

## 6) Firewall / Policy Check (Only After L3 Fails)

If you cannot reach external IP but have link + IP + route:

Inspect firewall rules (one of these may exist):

    iptables -L
    nft list ruleset

Safer test approach:
- Prefer inspecting and making a targeted change.
- Avoid flushes unless explicitly safe.

If you must temporarily flush for diagnosis (ONLY IF SAFE):

    iptables -F

Re-test:

    ping -c 3 8.8.8.8

If firewall was the issue:
- Restore rules properly.
- Do not leave the system in an unprotected state.
- Proceed to **Section 8**.

---

## 7) Service Reachability Check (Network OK, Service Not Reachable)

Check listener:

    ss -lntup | grep <port>

Test locally:

    curl localhost:<port>

Test remotely (from another host) if possible:

    curl <host>:<port>

Classify:

- If **not listening** → use `service-recovery-playbook.md`
- If **listening only on 127.0.0.1** → fix service config (then verify)
- If **listening on 0.0.0.0 or host IP but unreachable remotely** → firewall / SELinux policy likely

If SELinux is relevant:

    getenforce
    ausearch -m avc -ts recent

After correction, go to **Section 8**.

---

## 8) Verification and Persistence Check

Verify current state:

    ip a
    ip route
    ping -c 3 <gateway>
    ping -c 3 8.8.8.8
    getent hosts google.com

If service-related:

    ss -lntup | grep <port>
    curl localhost:<port>

Persistence guidance:
- Ensure interface config, routing, DNS, and firewall policy survive reboot.
- Only perform reboot test if safe.

Reboot test (only if allowed):

    systemctl reboot

After reboot:

    ip a
    ip route
    ping -c 3 8.8.8.8
    getent hosts google.com

---

## 🔁 Rollback Strategy

If a change breaks networking:

- Revert the last change (one at a time).
- Remove temporary routes:

    ip route del default

- Restore firewall rules if you modified them.
- Return to **Section 1** and re-observe.

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

## 🧠 Exam Safety Rules

- Always test IP before DNS
- Always test localhost before remote
- Do not permanently flush firewall blindly
- Prefer observe → isolate → fix → verify

---

## 🧱 This Playbook Composes From

- networking.md
- services-and-logging.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
