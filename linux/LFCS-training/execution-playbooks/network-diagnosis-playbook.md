# 🌐 Network Diagnosis Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`  
**Purpose:** Restore **basic connectivity and service reachability** using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- Host has **no network**
- Cannot reach **gateway / DNS / internet**
- Clients cannot reach a service
- Service is running but **not reachable**
- Interface is **down / misconfigured**

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

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

## 0) Inputs

You must know or determine:

- Target host or service
- Expected behavior:
  - Should it have internet?
  - Should it serve traffic?
  - On which port?

---

## 1) Observe Current State

Check interfaces:

    ip a

Check routes:

    ip route

Check DNS config:

    cat /etc/resolv.conf

Check link state:

    ip link

Branch:

- If **no interface has an IP** → go to **Section 2**
- If **has IP but no route** → go to **Section 3**
- If **has route but can’t reach outside** → go to **Section 4**

---

## 2) Interface Has No IP

Check if interface is up:

    ip link

Bring it up:

    ip link set <iface> up

Check DHCP:

    dhclient <iface>

Re-check:

    ip a

If still no IP:

- Check config files or NetworkManager (distro dependent)
- Then return to **Section 1**

---

## 3) No Default Route

Check:

    ip route

Add temporary route (if required):

    ip route add default via <gateway>

If this fixes connectivity:

- Fix persistent config
- Go to **Section 8**

---

## 4) Test Layer 3 Connectivity

Ping gateway:

    ping -c 3 <gateway>

Ping external IP:

    ping -c 3 8.8.8.8

Branch:

- If **can’t reach gateway** → local network problem → go to **Section 2/3**
- If **can reach IP but not domains** → go to **Section 5**
- If **can’t reach anything external** → check firewall → go to **Section 6**

---

## 5) DNS Check

Test resolution:

    getent hosts google.com
    dig google.com

If fails:

- Check `/etc/resolv.conf`
- Fix DNS server entries
- Re-test

Return to **Section 4**

---

## 6) Firewall Check

List rules:

    iptables -L
    nft list ruleset

Temporarily test by flushing (ONLY IF SAFE):

    iptables -F

Re-test connectivity.

If firewall was the issue:

- Fix rules properly
- Go to **Section 8**

---

## 7) Service Reachability Check

If network works but service unreachable:

Check listening:

    ss -lntup | grep <port>

Check local access:

    curl localhost:<port>

Check remote access:

    curl <host>:<port>

Branch:

- If **not listening** → use service-recovery-playbook
- If **listening only on 127.0.0.1** → fix config
- If **blocked** → firewall / SELinux

---

## 8) Persistence Check

Ensure config survives reboot:

- Interface config
- Route config
- DNS config
- Firewall rules

Test:

    systemctl reboot

After reboot:

    ip a
    ip route
    ping -c 3 8.8.8.8
    getent hosts google.com

---

## 🔁 Rollback Strategy

If a change breaks networking:

- Revert config files
- Restart network stack or reboot
- Remove temporary routes:

    ip route del default

---

## ✅ Completion Criteria

- Interface has IP
- Default route exists
- Can ping external IP
- DNS resolves
- Service (if applicable) is reachable

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

