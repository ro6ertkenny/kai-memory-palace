# 🔥 Phase 14 — Networking Security: Firewalls, NAT, Port Forwarding, Proxies, and SSH Hardening
*LFCS traffic-control layer: decide what is allowed in, what goes out, and how it is redirected.*

---

## 📌 Purpose

This phase makes you **operational with network traffic control**:

- Inspecting listening ports and services
- Using UFW and iptables for filtering
- Implementing NAT and port forwarding
- Allowing / denying by IP or subnet
- Hardening SSH
- Understanding simple proxy / reverse proxy scenarios

LFCS tasks here are **mechanical and precise**.

---

## 🧠 Mental Model

Traffic control has **three questions**:

1) Is the service listening?
2) Is the firewall allowing it?
3) Is traffic being redirected or translated (NAT)?

If any layer is wrong → it looks “down”.

---

# 🔎 Part A — See What Is Listening

Modern:

    ss -tlnp

Old:

    sudo netstat -tulpn

Check SSH:

    ss -tlnp | grep :22

Check HTTP:

    ss -tlnp | grep :80

---

# 🧱 Part B — UFW (Simple Firewall)

Check status:

    sudo ufw status numbered

Allow IP:

    sudo ufw allow from 207.45.232.181

Allow subnet:

    sudo ufw allow from 10.11.12.0/24

Deny IP with priority:

    sudo ufw insert 1 deny from 10.0.0.19

Delete rule:

    sudo ufw delete 5

---

# 🔥 Part C — iptables (Direct Control)

List rules:

    sudo iptables -L -n -v
    sudo iptables -t nat -L -n -v

---

## NAT Port Forwarding Example

Forward port 81 → 192.168.5.2:80:

    sudo iptables -t nat -A PREROUTING -p tcp -s 10.5.5.0/24 --dport 81 -j DNAT --to-destination 192.168.5.2:80
    sudo iptables -t nat -A POSTROUTING -s 10.5.5.0/24 -j MASQUERADE

Another example:

    sudo iptables -t nat -A PREROUTING -p tcp -s 10.9.9.0/24 --dport 80 -j DNAT --to-destination 10.100.0.8:80
    sudo iptables -t nat -A POSTROUTING -s 10.9.9.0/24 -j MASQUERADE

---

## Persist Rules

Install helper:

    sudo apt install iptables-persistent

---

# 🔐 Part D — SSH Hardening

Config file:

    /etc/ssh/sshd_config

View:

    cat /etc/ssh/sshd_config

Disable password auth:

    PasswordAuthentication no

Disable root login:

    PermitRootLogin no

IPv4 only:

    AddressFamily inet

Per-user exception:

    Match User john
      PasswordAuthentication yes

Restart:

    sudo systemctl restart sshd

---

## 🧠 Important: Socket Activation (Ubuntu)

SSH may show:

    ssh.service → disabled
    ssh.socket  → enabled

This is **normal**. The socket starts the service on demand.

Enable classic mode (only if asked):

    sudo systemctl enable --now ssh

---

# 🧱 Part E — Simple Proxy / Reverse Proxy (nginx / squid awareness)

## Squid (Forward Proxy)

Install:

    sudo apt install squid -y

Start:

    sudo systemctl start squid

Edit:

    sudo vi /etc/squid/squid.conf

Deny localnet:

    http_access deny localnet

Allow VPN IP:

    acl vpn src 203.0.110.5
    http_access allow vpn

Block Facebook:

    acl facebook dstdomain .facebook.com
    http_access deny facebook

Restart:

    sudo systemctl restart squid

---

## nginx Reverse Proxy / Load Balancer (Awareness)

Reverse proxy example:

    proxy_pass http://google.com;

Reload:

    sudo systemctl reload nginx

Load balancer example:

    server ip_addr weight=3;

Test config:

    sudo nginx -t

---

# 🧪 Canonical Exam Scenarios

Check UFW and remove rule:

    sudo ufw status numbered
    sudo ufw delete 5

Create NAT rule:

    sudo iptables -t nat -A PREROUTING -p tcp --dport 81 -j DNAT --to-destination 192.168.5.2:80
    sudo iptables -t nat -A POSTROUTING -j MASQUERADE

Disable SSH password auth:

    sudo vi /etc/ssh/sshd_config
    PasswordAuthentication no
    sudo systemctl restart sshd

Check what listens on 80:

    ss -tlnp | grep :80

---

# ⚠️ Failure Modes

- Forgetting to restart sshd after config change
- Adding firewall rule but forgetting NAT POSTROUTING
- Blocking yourself out via UFW/iptables
- Assuming ssh.service must be enabled (socket activation!)
- Not verifying listening ports

---

# 🏁 Phase 14 Mastery Checklist

You must be able to:

- Check listening ports
- Use UFW to allow/deny IPs and subnets
- Read and add iptables NAT rules
- Understand PREROUTING vs POSTROUTING
- Harden SSH (password, root, per-user)
- Understand socket-activated SSH behavior
- Recognize proxy and reverse proxy patterns

---

## 🔥 Exam Law

> **If the service is running but unreachable, the firewall or NAT is lying to you.**

---

