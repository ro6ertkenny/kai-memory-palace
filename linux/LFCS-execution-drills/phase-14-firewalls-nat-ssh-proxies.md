# 🧪 LFCS Execution Drills — Phase 14
# 🔥 Networking Security: Firewalls, NAT, Port Forwarding, Proxies, and SSH Hardening

Path:
  linux/execution-drills/phase-14-firewalls-nat-ssh-proxies.md

Purpose:
  Build reflex-level control over traffic filtering, NAT/port-forwarding, SSH hardening, and reachability diagnosis.

Mental Mode:
  Always answer these in order:
  1) Is the service listening?
  2) Is the firewall allowing it?
  3) Is NAT/forwarding translating it?

---

## 🧱 Lab Safety Rules

⚠️ Prefer a VM or lab machine.
⚠️ Keep one root session open when touching firewall or SSH.
⚠️ Do NOT lock yourself out of SSH.
⚠️ If using your main machine, keep changes minimal and revert them.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-14
    cd ~/lfcs-labs/execution-drills/phase-14

Install tools (if missing):

    sudo apt update
    sudo apt install -y ufw iptables-persistent nginx net-tools

Ensure nginx is running (for port 80 tests):

    sudo systemctl enable --now nginx

Verify:

    ss -tlnp | grep :80 || true

---

# A) What Is Listening?

## A1 — Inventory listeners

    ss -tlnp
    sudo netstat -tulpn

Save:

    ss -tlnp > listening.txt

---

## A2 — Check common ports

    ss -tlnp | grep :22 || true
    ss -tlnp | grep :80 || true

---

# B) UFW — Simple Firewall

## B1 — Status

    sudo ufw status numbered

If disabled and you want to test:

    sudo ufw enable

(Only if you are on a safe machine.)

---

## B2 — Allow and deny rules

Allow SSH and HTTP:

    sudo ufw allow 22
    sudo ufw allow 80

Allow a subnet:

    sudo ufw allow from 10.11.12.0/24

Insert a deny at top:

    sudo ufw insert 1 deny from 10.0.0.19

List:

    sudo ufw status numbered

Delete a rule by number:

    sudo ufw delete 1

---

## B3 — Verify effect

Test locally:

    curl -I http://127.0.0.1

Explain:
- Local connections usually bypass UFW
- External reachability is what UFW controls

---

# C) iptables — Inspect and NAT

## C1 — List filter and NAT tables

    sudo iptables -L -n -v
    sudo iptables -t nat -L -n -v

---

## C2 — Add a SAFE NAT example (lab only)

⚠️ This is conceptual unless you have multiple interfaces/VM networking.

Forward port 81 to local 80 (DNAT to self):

    sudo iptables -t nat -A PREROUTING -p tcp --dport 81 -j DNAT --to-destination 127.0.0.1:80
    sudo iptables -t nat -A POSTROUTING -p tcp -d 127.0.0.1 --dport 80 -j MASQUERADE

Test:

    curl -I http://127.0.0.1:81

List NAT:

    sudo iptables -t nat -L -n -v

---

## C3 — Remove the rules (cleanup)

List with line numbers:

    sudo iptables -t nat -L --line-numbers

Delete (adjust numbers if needed):

    sudo iptables -t nat -D PREROUTING 1
    sudo iptables -t nat -D POSTROUTING 1

---

## C4 — Persist rules (awareness)

    sudo dpkg -l | grep iptables-persistent || true

If needed:

    sudo apt install iptables-persistent

Explain:
- Runtime iptables rules are lost on reboot without persistence.

---

# D) SSH Hardening

## D1 — Inspect config

    sudo grep -E '^(#)?(PermitRootLogin|PasswordAuthentication|AddressFamily)' /etc/ssh/sshd_config

---

## D2 — Apply hardening (DO CAREFULLY)

Open:

    sudo vi /etc/ssh/sshd_config

Set:

    PermitRootLogin no
    PasswordAuthentication no
    AddressFamily inet

(Optional per-user exception):

    Match User harry
        PasswordAuthentication yes

Restart:

    sudo systemctl restart sshd

Check status:

    systemctl status sshd

---

## D3 — Socket activation awareness (Ubuntu)

Check:

    systemctl status ssh
    systemctl status ssh.socket

Explain:
- ssh.socket may be enabled
- ssh.service may be disabled
- SSH still works (socket-activated)

Force classic mode (only if asked):

    sudo systemctl enable --now ssh

---

# E) Simple Proxy / Reverse Proxy (Awareness)

## E1 — nginx reverse proxy snippet (lab)

Create:

    sudo cat > /etc/nginx/sites-available/proxy14 <<EOF
    server {
        listen 8084;
        location / {
            proxy_pass http://example.com;
        }
    }
    EOF

Enable:

    sudo ln -s /etc/nginx/sites-available/proxy14 /etc/nginx/sites-enabled/proxy14

Test and reload:

    sudo nginx -t
    sudo systemctl reload nginx

Test:

    curl -I http://127.0.0.1:8084

Cleanup later.

---

## E2 — Squid (forward proxy) awareness

(Install only if you want to explore.)

    sudo apt install -y squid
    sudo systemctl start squid
    sudo systemctl status squid

Explain:
- Forward proxy controls outbound client access
- Not usually heavily tested, but concepts appear

---

# F) Timed Drills

## F1 — Find what listens on 80 (10 seconds)

    ss -tlnp | grep :80

---

## F2 — Allow a subnet in UFW (15 seconds)

    sudo ufw allow from 10.11.12.0/24

---

## F3 — Show NAT table (10 seconds)

    sudo iptables -t nat -L -n -v

---

# G) Failure Injection Drills (Mental)

## G1 — “Service running but unreachable”

Checklist:

    ss -tlnp
    sudo ufw status
    sudo iptables -L -n -v
    sudo iptables -t nat -L -n -v

Conclusion:
- Listener?
- Firewall block?
- NAT missing?

---

## G2 — NAT only half configured

Explain:
- If PREROUTING exists but no POSTROUTING MASQUERADE, return traffic breaks.

---

## G3 — SSH change didn’t work

Checklist:

    sudo sshd -t
    sudo systemctl restart sshd
    systemctl status sshd

---

# H) Composition (Exam Style)

## H1 — Diagnose HTTP unreachable

Run:

    ss -tlnp | grep :80
    sudo ufw status
    sudo iptables -L -n -v

Decide:
- Is nginx running?
- Is firewall blocking?
- Is traffic redirected?

---

## H2 — Lock down SSH

Goal:
- Disable root login
- Disable password auth

Steps:

    sudo vi /etc/ssh/sshd_config
    PermitRootLogin no
    PasswordAuthentication no
    sudo systemctl restart sshd

Verify:

    sudo sshd -t

---

# I) Cleanup

## I1 — Remove proxy config

    sudo rm /etc/nginx/sites-enabled/proxy14
    sudo rm /etc/nginx/sites-available/proxy14
    sudo systemctl reload nginx

---

# ✅ Phase 14 Completion Criteria

You are Phase 14-ready when you can:

- Prove whether a service is listening
- Use UFW to allow/deny IPs and subnets
- Inspect iptables filter and NAT tables
- Explain PREROUTING vs POSTROUTING
- Create and remove simple NAT port-forwards
- Harden SSH safely and verify config
- Understand socket-activated SSH
- Recognize proxy vs reverse proxy patterns
- Diagnose “service is up but unreachable” systematically

---

# 🔥 Phase 14 Law

If the service is running but unreachable, the firewall or NAT is lying to you.

---
