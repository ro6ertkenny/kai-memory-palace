# 🌐 Phase 13 — Networking Fundamentals (Execution Playbook)
*LFCS connectivity layer: prove which interface, which IP, which route, and which resolver are in use — and fix them under time pressure.*

Path:
- linux/LFCS-execution-playbooks/phase-13-networking-basics.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- inspect interfaces, addresses, routes, and DNS
- identify default gateway
- add and remove temporary IP addresses
- modify persistent network config (netplan on Ubuntu, when present)
- verify listening ports
- diagnose connectivity by layer
- produce proof artifacts for each step

---

## 🧱 Lab Root

All Phase 13 drills run in:

- ~/lfcs-labs/phase-13

Initialize:

    mkdir -p ~/lfcs-labs/phase-13
    cd ~/lfcs-labs/phase-13
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT break your only management interface.
- If using netplan, use `netplan try` when possible.
- Prefer adding/removing a *secondary* address for tests.
- Always leave the system reachable.

---

## 🧪 Completion Standard

Pass Phase 13 when you can complete P13-1 through P13-14:

- in ≤ 120 minutes
- without losing connectivity
- with proof files created
- and with temporary changes reverted

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P13-1 — Capture interface inventory

Time limit:
- 3 minutes

Do:

    ip a > interfaces.txt

Verify:

    wc -l interfaces.txt

-------------------------------------------------------------------------------

## P13-2 — Identify active interface and IP

Time limit:
- 4 minutes

Do:

    ip -o -4 a show > ipv4.txt
    ip route get 1.1.1.1 > route-to-internet.txt 2>/dev/null || true

Verify:

    cat ipv4.txt

-------------------------------------------------------------------------------

## P13-3 — Capture routing table

Time limit:
- 3 minutes

Do:

    ip route show > routes.txt

Verify:

    grep default routes.txt || true

-------------------------------------------------------------------------------

## P13-4 — Capture DNS configuration

Time limit:
- 3 minutes

Do:

    cat /etc/resolv.conf > resolv.txt
    resolvectl status > resolvectl.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P13-5 — Test connectivity (IP vs name)

Time limit:
- 4 minutes

Do:

    ping -c 2 1.1.1.1 > ping-ip.txt 2>&1 || true
    ping -c 2 google.com > ping-name.txt 2>&1 || true

-------------------------------------------------------------------------------

## P13-6 — Check listening ports

Time limit:
- 3 minutes

Do:

    ss -tlnp > listening.txt

Verify:

    wc -l listening.txt

-------------------------------------------------------------------------------

## P13-7 — Choose test interface

Time limit:
- 3 minutes

Task:
Pick a non-critical interface name from `ip a`. Save it.

Do:

    ip -o link show | awk -F': ' '{print $2}' > all-interfaces.txt
    head -n 1 all-interfaces.txt > test-interface.txt

(Manually edit `test-interface.txt` if needed to avoid primary interface.)

-------------------------------------------------------------------------------

## P13-8 — Add temporary IP address

Time limit:
- 5 minutes

Task:
Add a secondary address to the chosen interface.

Do:

    IFACE=$(cat test-interface.txt)
    sudo ip a add 10.13.13.13/24 dev "$IFACE"
    ip a show "$IFACE" > after-add.txt

-------------------------------------------------------------------------------

## P13-9 — Remove temporary IP address

Time limit:
- 4 minutes

Do:

    IFACE=$(cat test-interface.txt)
    sudo ip a del 10.13.13.13/24 dev "$IFACE"
    ip a show "$IFACE" > after-del.txt

-------------------------------------------------------------------------------

## P13-10 — Verify default route

Time limit:
- 3 minutes

Do:

    ip route | grep default > default-route.txt

-------------------------------------------------------------------------------

## P13-11 — Inspect netplan (if present)

Time limit:
- 4 minutes

Do:

    ls /etc/netplan > netplan-files.txt 2>/dev/null || echo "no netplan" > netplan-files.txt
    cat /etc/netplan/*.yaml > netplan-config.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P13-12 — Dry-run persistent config test (netplan)

Time limit:
- 6 minutes

Task:
If netplan exists, run a safe test apply.

Do:

    sudo netplan try > netplan-try.txt 2>&1 || echo "netplan try failed or not present" > netplan-try.txt

-------------------------------------------------------------------------------

## P13-13 — Identify which interface owns an IP

Time limit:
- 4 minutes

Task:
Pick one IPv4 from `ipv4.txt` and identify its interface.

Do:

    awk '{print $4, $2}' ipv4.txt > ip-to-iface.txt

-------------------------------------------------------------------------------

## P13-14 — Cleanup

Time limit:
- 2 minutes

Do:

    echo OK > cleanup.txt

---

## 🏁 Phase 13 Pass Criteria

You can:

- list interfaces and addresses
- identify active interface and default route
- inspect DNS configuration
- test IP vs name connectivity
- inspect listening ports
- add and remove temporary IP addresses safely
- locate persistent network config
- prove which interface owns which IP

---

## 🌐 Phase 13 Law

If you can’t answer:

- which interface?
- which IP?
- which route?
- which resolver?

…you don’t understand the network yet.

---
