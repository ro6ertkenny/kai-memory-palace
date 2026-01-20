# 🔥 Phase 14 — Firewalls, NAT, SSH, Proxies (Execution Playbook)
*LFCS traffic-control layer: prove what is listening, what is allowed, and how traffic is filtered or redirected.*

Path:
- linux/LFCS-execution-playbooks/phase-14-firewalls-nat-ssh-proxies.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- identify listening services and ports
- inspect and modify UFW rules
- inspect iptables rules (including NAT)
- add and remove firewall rules safely
- create and verify port forwarding rules
- harden SSH configuration
- understand socket-activated SSH behavior
- verify access paths end-to-end

---

## 🧱 Lab Root

All Phase 14 drills run in:

- ~/lfcs-labs/phase-14

Initialize:

    mkdir -p ~/lfcs-labs/phase-14
    cd ~/lfcs-labs/phase-14
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT block your own SSH access.
- Do NOT flush iptables on a remote system.
- Prefer adding rules rather than deleting existing ones.
- Always verify listening ports before changing firewall rules.

---

## 🧪 Completion Standard

Pass Phase 14 when you can complete P14-1 through P14-14:

- in ≤ 120 minutes
- without locking yourself out
- with proof files created
- and with test rules removed

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P14-1 — Inspect listening ports

Time limit:
- 3 minutes

Do:

    ss -tlnp > listening.txt

Verify:

    wc -l listening.txt

-------------------------------------------------------------------------------

## P14-2 — Inspect UFW status

Time limit:
- 3 minutes

Do:

    sudo ufw status numbered > ufw-status.txt 2>&1 || echo "ufw not installed" > ufw-status.txt

-------------------------------------------------------------------------------

## P14-3 — Add and remove a UFW allow rule (safe test)

Time limit:
- 6 minutes

Task:
Temporarily allow a high port (e.g., 54321), then remove it.

Do:

    sudo ufw allow 54321
    sudo ufw status numbered > ufw-after-add.txt
    sudo ufw delete allow 54321
    sudo ufw status numbered > ufw-after-del.txt

-------------------------------------------------------------------------------

## P14-4 — Insert a deny rule (safe IP)

Time limit:
- 5 minutes

Task:
Deny a documentation-only IP.

Do:

    sudo ufw insert 1 deny from 203.0.113.1
    sudo ufw status numbered > ufw-after-insert.txt
    sudo ufw delete 1

-------------------------------------------------------------------------------

## P14-5 — Inspect iptables filter table

Time limit:
- 3 minutes

Do:

    sudo iptables -L -n -v > iptables-filter.txt

-------------------------------------------------------------------------------

## P14-6 — Inspect iptables NAT table

Time limit:
- 3 minutes

Do:

    sudo iptables -t nat -L -n -v > iptables-nat.txt

-------------------------------------------------------------------------------

## P14-7 — Create and remove a test NAT rule (NO TRAFFIC DEPENDENCY)

Time limit:
- 7 minutes

Task:
Add a dummy PREROUTING rule for test port, then remove it.

Do:

    sudo iptables -t nat -A PREROUTING -p tcp --dport 65432 -j ACCEPT
    sudo iptables -t nat -L -n -v > nat-after-add.txt
    sudo iptables -t nat -D PREROUTING 1
    sudo iptables -t nat -L -n -v > nat-after-del.txt

-------------------------------------------------------------------------------

## P14-8 — Check SSH socket activation

Time limit:
- 4 minutes

Do:

    systemctl status ssh > ssh-service.txt 2>&1 || true
    systemctl status ssh.socket > ssh-socket.txt 2>&1 || true

-------------------------------------------------------------------------------

## P14-9 — Inspect SSH config

Time limit:
- 4 minutes

Do:

    sudo grep -E '^(PermitRootLogin|PasswordAuthentication|AddressFamily)' /etc/ssh/sshd_config > ssh-config.txt || true

-------------------------------------------------------------------------------

## P14-10 — Harden SSH (safe change)

Time limit:
- 7 minutes

Task:
Disable root login and password auth (only if you have key access or console).

Do:

    sudo cp /etc/ssh/sshd_config ./sshd_config.bak
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    sudo systemctl status sshd > sshd-status.txt

If this is not safe on your system:

    echo "skipped for safety" > sshd-status.txt

-------------------------------------------------------------------------------

## P14-11 — Verify SSH is still listening

Time limit:
- 3 minutes

Do:

    ss -tlnp | grep :22 > ssh-listening.txt || true

-------------------------------------------------------------------------------

## P14-12 — Restore SSH config (if changed)

Time limit:
- 6 minutes

Do:

    if [ -f ./sshd_config.bak ]; then sudo cp ./sshd_config.bak /etc/ssh/sshd_config && sudo systemctl restart sshd; fi
    echo OK > ssh-restore.txt

-------------------------------------------------------------------------------

## P14-13 — Check for proxy software

Time limit:
- 3 minutes

Do:

    dpkg -l | grep -E 'squid|nginx' > proxies.txt || echo "no proxy packages" > proxies.txt

-------------------------------------------------------------------------------

## P14-14 — Cleanup

Time limit:
- 2 minutes

Do:

    echo OK > cleanup.txt

---

## 🏁 Phase 14 Pass Criteria

You can:

- inspect listening ports
- manage UFW rules safely
- inspect iptables filter and NAT tables
- add and remove NAT rules
- diagnose SSH socket activation
- harden and restore SSH safely
- verify service reachability

---

## 🔥 Phase 14 Law

If the service is running but unreachable, **the firewall or NAT is lying to you**.

---
