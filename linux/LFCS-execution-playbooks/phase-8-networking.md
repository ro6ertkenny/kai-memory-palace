# ⚔️ Phase 8 — Networking (Execution Playbook)
*LFCS connectivity layer: if you can’t prove which interface, which IP, which route, and which port is in use, you don’t control the machine.*

Path:
- linux/LFCS-execution-playbooks/phase-8-networking.md

Rule:
- This is not documentation.
- This is execution under time pressure.
- Every task ends with proof.

---

## 📌 Purpose

Build reflex-level ability to:

- inspect interfaces and IP addresses
- identify default route and routing table
- add and remove temporary IP addresses
- edit persistent network config (netplan)
- verify DNS resolution paths
- identify listening services and ports
- diagnose “why can’t I reach X?”

---

## 🧱 Lab Root

All Phase 8 drills run in:

- ~/lfcs-labs/phase-8

Initialize:

    mkdir -p ~/lfcs-labs/phase-8
    cd ~/lfcs-labs/phase-8
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do not destroy your active SSH connection.
- If working remotely, do NOT remove the only active interface.
- Always prefer adding secondary IPs instead of replacing primary ones.

---

## 🧪 Completion Standard

Pass Phase 8 when you can complete P8-1 through P8-15:

- in ≤ 90 minutes total
- without locking yourself out
- without breaking netplan
- and with clean verification artifacts

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P8-1 — Capture interface state

Time limit:
- 3 minutes

Task:
Save interface state to interfaces.txt.

Do:

    ip a > interfaces.txt

Verify:

    cat interfaces.txt

-------------------------------------------------------------------------------

## P8-2 — Identify default route

Time limit:
- 2 minutes

Task:
Save routing table to routes.txt.

Do:

    ip route > routes.txt

Verify:

    grep default routes.txt || cat routes.txt

-------------------------------------------------------------------------------

## P8-3 — Identify active interface by IP

Time limit:
- 4 minutes

Task:
Find which interface owns your primary IP and save its name.

Do:

    ip a > ip-all.txt
    grep -i "inet " ip-all.txt

Manually inspect, then:

    echo "<INTERFACE_NAME>" > primary-interface.txt

Verify:

    cat primary-interface.txt

-------------------------------------------------------------------------------

## P8-4 — Check DNS configuration

Time limit:
- 4 minutes

Task:
Capture resolver configuration.

Do:

    cat /etc/resolv.conf > resolv.txt

If using systemd-resolved:

    resolvectl status > resolvectl.txt || true

Verify:

    ls -l resolv.txt

-------------------------------------------------------------------------------

## P8-5 — Test connectivity

Time limit:
- 3 minutes

Task:
Prove you can reach outside.

Do:

    ping -c 3 8.8.8.8 > ping-ip.txt
    ping -c 3 google.com > ping-dns.txt

Verify:

    cat ping-ip.txt
    cat ping-dns.txt

-------------------------------------------------------------------------------

## P8-6 — Identify listening ports

Time limit:
- 4 minutes

Task:
Capture listening services.

Do:

    ss -tlnp > listening.txt

Verify:

    grep -E ":(22|80|443)" listening.txt || true

-------------------------------------------------------------------------------

## P8-7 — Add temporary IP address

Time limit:
- 6 minutes

Task:
Add a secondary IP to your main interface.

Do:

    IFACE=$(cat primary-interface.txt)
    sudo ip a add 10.99.99.50/24 dev $IFACE

Verify:

    ip a show dev $IFACE

-------------------------------------------------------------------------------

## P8-8 — Remove temporary IP address

Time limit:
- 3 minutes

Task:
Remove the IP you just added.

Do:

    IFACE=$(cat primary-interface.txt)
    sudo ip a del 10.99.99.50/24 dev $IFACE

Verify:

    ip a show dev $IFACE | grep 10.99 || echo "removed"

-------------------------------------------------------------------------------

## P8-9 — Inspect netplan configuration

Time limit:
- 5 minutes

Task:
Copy current netplan config to lab.

Do:

    sudo cp /etc/netplan/*.yaml ./ 2>/dev/null || true
    ls -l

Verify:
- You see at least one YAML file

-------------------------------------------------------------------------------

## P8-10 — Add a safe persistent secondary IP (netplan)

Time limit:
- 12 minutes

Task:
Modify netplan to add a secondary IP (do NOT remove the main one).

Do:

    sudo vi /etc/netplan/99-p8-test.yaml

Template:

    network:
      version: 2
      ethernets:
        <INTERFACE>:
          addresses:
            - <EXISTING_IP>/XX
            - 10.99.99.51/24

Apply:

    sudo chmod 600 /etc/netplan/99-p8-test.yaml
    sudo netplan apply

Verify:

    ip a show

-------------------------------------------------------------------------------

## P8-11 — Revert netplan change

Time limit:
- 5 minutes

Task:
Remove the test file.

Do:

    sudo rm -f /etc/netplan/99-p8-test.yaml
    sudo netplan apply

Verify:

    ip a | grep 10.99 || echo "clean"

-------------------------------------------------------------------------------

## P8-12 — Identify which process listens on a port

Time limit:
- 4 minutes

Task:
Find what listens on port 22.

Do:

    ss -tlnp | grep :22 > port22.txt

Verify:

    cat port22.txt

-------------------------------------------------------------------------------

## P8-13 — Prove route to a destination

Time limit:
- 4 minutes

Task:
Trace route to 8.8.8.8.

Do:

    ip route get 8.8.8.8 > route-to-8.8.8.8.txt

Verify:

    cat route-to-8.8.8.8.txt

-------------------------------------------------------------------------------

## P8-14 — Local name resolution override

Time limit:
- 6 minutes

Task:
Add a fake name mapping and test it.

Do:

    echo "127.0.0.1 p8test.local" | sudo tee -a /etc/hosts
    ping -c 1 p8test.local > hosts-test.txt

Verify:

    cat hosts-test.txt

Cleanup:

    sudo sed -i '/p8test.local/d' /etc/hosts

-------------------------------------------------------------------------------

## P8-15 — Capture final state

Time limit:
- 4 minutes

Task:
Save final network state.

Do:

    ip a > final-interfaces.txt
    ip route > final-routes.txt
    ss -tlnp > final-listening.txt

Verify:

    wc -l final-interfaces.txt
    wc -l final-routes.txt
    wc -l final-listening.txt

---

## 🏁 Phase 8 Pass Criteria

You can:

- identify interfaces, IPs, and routes
- distinguish runtime vs persistent config
- safely modify and revert netplan
- diagnose DNS vs routing vs interface failures
- identify which process owns a port
- prove connectivity path

---

## 🔒 Phase 8 Law

If you can’t answer:
- which interface?
- which IP?
- which route?
- which port?
- which process?

Then you are guessing, not operating.

---
