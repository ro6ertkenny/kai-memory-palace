# 🧪 LFCS Execution Drills — Phase 8
# 🌐 Networking: IP, Routing, DNS, Firewalls, SSH, and Proxies

Path:
  linux/execution-drills/phase-8-networking.md

Purpose:
  Build reflex-level control over IP configuration, routing, name resolution, firewalling, SSH behavior, and service reachability.

Mental Mode:
  When something is unreachable, always check in this order:
  interface → IP → route → DNS → firewall → service.

---

## 🧱 Lab Safety Rules

⚠️ If this is your main machine, DO NOT break your real network.
Prefer:
- a VM
- or a secondary interface
- or network namespaces

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-8
    cd ~/lfcs-labs/execution-drills/phase-8

Install tools:

    sudo apt update
    sudo apt install -y nginx ufw net-tools

Ensure nginx is running:

    sudo systemctl enable --now nginx

---

# A) Inspect Network State

## A1 — Inventory

    ip a
    ip link
    ip r
    resolvectl status
    ss -tlnp

Save routes:

    ip r > routes.txt

---

## A2 — Test connectivity

    ping -c 3 8.8.8.8
    curl -I http://127.0.0.1

---

# B) Temporary IP and Routes (DO NOT use main interface)

Use a secondary interface or dummy interface:

    sudo ip link add dummy0 type dummy
    sudo ip link set dummy0 up

Add IP:

    sudo ip a add 192.168.50.10/24 dev dummy0
    ip a show dummy0

Add route:

    sudo ip route add 10.10.0.0/16 via 192.168.50.1

List:

    ip r

Delete:

    sudo ip route del 10.10.0.0/16
    sudo ip a del 192.168.50.10/24 dev dummy0

Cleanup later:

    sudo ip link del dummy0

---

# C) DNS and Hosts

## C1 — Inspect resolution

    resolvectl status
    cat /etc/resolv.conf

---

## C2 — Local override

Edit:

    sudo vi /etc/hosts

Add:

    127.0.0.1 test.local

Test:

    ping -c 1 test.local

---

# D) Listening Services

## D1 — Who listens?

    ss -tlnp
    sudo netstat -tulpn

Find nginx (80):

    ss -tlnp | grep :80

---

# E) Firewall — ufw

## E1 — Status and rules

    sudo ufw status numbered

---

## E2 — Allow and deny

Allow SSH and HTTP:

    sudo ufw allow 22
    sudo ufw allow 80

Deny a fake subnet:

    sudo ufw insert 1 deny from 10.0.0.19

List:

    sudo ufw status numbered

Delete rule:

    sudo ufw delete 1

---

## E3 — Test firewall logic

Check nginx locally:

    curl http://127.0.0.1

---

# F) Firewall — iptables (NAT table inspection)

## F1 — List NAT table

    sudo iptables -t nat -L -n -v

Do not add real NAT rules unless in a VM.

---

# G) SSH Behavior

## G1 — Socket activation awareness

    systemctl status ssh
    systemctl status ssh.socket

Explain:
- socket may be enabled
- service may be disabled
- SSH still works

---

## G2 — Force classic behavior

    sudo systemctl enable --now ssh
    systemctl is-enabled ssh

---

## G3 — Config drill (safe edit)

Open:

    sudo vi /etc/ssh/sshd_config

Find:

    PermitRootLogin
    PasswordAuthentication

Do not lock yourself out. Just practice locating.

Restart:

    sudo systemctl restart ssh

---

# H) netplan (INSPECT ONLY unless in VM)

## H1 — View configs

    ls -l /etc/netplan
    sudo cat /etc/netplan/*.yaml

Explain structure:
- version
- ethernets
- addresses
- routes
- nameservers

---

## H2 — Syntax validation drill

    sudo netplan try

(Abort if it would break connectivity.)

---

# I) Reverse Proxy (nginx)

## I1 — Simple reverse proxy to example.com

Create file:

    sudo cat > /etc/nginx/sites-available/proxy-test <<EOF
    server {
        listen 8081;
        location / {
            proxy_pass http://example.com;
        }
    }
    EOF

Enable:

    sudo ln -s /etc/nginx/sites-available/proxy-test /etc/nginx/sites-enabled/proxy-test

Test:

    sudo nginx -t
    sudo systemctl reload nginx

Test:

    curl -I http://127.0.0.1:8081

---

# J) Timed Drills

## J1 — Show routes and save (10 seconds)

    ip r > ~/lfcs-labs/execution-drills/phase-8/routes.txt

---

## J2 — Find who listens on 80 (10 seconds)

    ss -tlnp | grep :80

---

## J3 — Allow subnet in ufw (15 seconds)

    sudo ufw allow from 10.11.12.0/24

---

# K) Failure Injection Drills

## K1 — “Why can’t I connect?”

Checklist:

- ip a
- ip r
- resolvectl status
- ss -tlnp
- ufw status

Explain what each checks.

---

## K2 — Bad netplan YAML (theory)

Explain:
- indentation breaks config
- always use:
    sudo netplan try
  before reboot.

---

## K3 — Firewall lockout scenario (theory)

Explain:
- always allow SSH before enabling firewall
- always keep a root console open

---

# L) Composition (Exam Style)

## L1 — Diagnose local service

    ss -tlnp | grep nginx
    curl http://127.0.0.1
    sudo ufw status

Explain:
- is it listening?
- is it allowed?
- is it reachable?

---

## L2 — Save evidence

    ss -tlnp > ~/lfcs-labs/execution-drills/phase-8/listening.txt
    ip a > ~/lfcs-labs/execution-drills/phase-8/ips.txt

---

# ✅ Phase 8 Completion Criteria

You are Phase 8-ready when you can:

- Inspect IPs, routes, DNS, and listeners
- Add and remove temporary IPs and routes
- Understand netplan structure and safety workflow
- Diagnose reachability issues systematically
- Open and close ports with ufw safely
- Inspect iptables NAT rules
- Understand SSH socket activation
- Verify service exposure

---

# 🔒 Phase 8 Law

If packets don’t flow correctly, nothing else matters.

---

# Cleanup (Optional)

Remove nginx proxy:

    sudo rm /etc/nginx/sites-enabled/proxy-test
    sudo rm /etc/nginx/sites-available/proxy-test
    sudo systemctl reload nginx

Remove dummy interface (if created):

    sudo ip link del dummy0

---

