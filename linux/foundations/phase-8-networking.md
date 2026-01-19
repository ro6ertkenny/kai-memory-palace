# 🌐 Phase 8 — Networking: IP, Routing, DNS, Firewalls, SSH, and Proxies
*LFCS control of connectivity: make packets go where they should — and nowhere else.*

---

## 📌 Purpose

This phase makes you **network-operational** with:

- Inspecting and configuring IP addresses
- Setting routes (temporary and persistent)
- Managing DNS and hostname resolution
- Verifying listening ports and services
- Configuring firewalls (ufw / iptables)
- Understanding SSH behavior and configuration
- Basic reverse proxy / load balancer patterns (nginx)
- Bridges and bonds (netplan)

Many LFCS tasks are:

> “Why can’t I reach this?”  
> “Make this reachable — but only from here.”  
> “Persist it.”  

---

## 🧠 Mental Model

- Interface has **addresses**
- Kernel has a **routing table**
- Name resolution uses:
  - /etc/hosts
  - /etc/resolv.conf / systemd-resolved
- Firewalls filter **packets**
- Services listen on **ports**
- SSH may be **socket-activated** (important!)

---

# 🔎 Part A — Inspect Network State

Interfaces:

    ip a
    ip link

Routes:

    ip route
    ip r

DNS:

    resolvectl status
    cat /etc/resolv.conf

Listening ports:

    ss -tlnp
    sudo netstat -tulpn

Test connectivity:

    ping 8.8.8.8
    curl http://127.0.0.1:8080

---

# 🧭 Part B — Temporary IP Configuration

Add address:

    sudo ip a add 192.168.9.3/24 dev eth1

Remove:

    sudo ip a del 192.168.9.3/24 dev eth1

Add route:

    sudo ip route add 10.0.0.0/24 via 192.168.1.1

Delete:

    sudo ip route del 10.0.0.0/24

---

# 🧾 Part C — Persistent Network Config (netplan / Ubuntu)

Edit:

    sudo vi /etc/netplan/99-custom.yaml

Example:

    network:
      version: 2
      ethernets:
        enp6s0:
          dhcp4: false
          dhcp6: false
          addresses:
            - 10.0.10.5/24
          routes:
            - to: 0.0.0.0/0
              via: 10.0.10.1
          nameservers:
            addresses:
              - 8.8.8.8
              - 1.1.1.1

Permissions:

    sudo chmod 600 /etc/netplan/99-custom.yaml

Apply:

    sudo netplan apply
    sudo netplan try

Verify:

    ip a
    ip r

---

# 🧩 Part D — Bridges and Bonds (netplan)

Bridge example:

    network:
      version: 2
      renderer: networkd
      ethernets:
        eth1: { dhcp4: no }
        eth2: { dhcp4: no }
      bridges:
        br0:
          dhcp4: yes
          interfaces:
            - eth1
            - eth2

Bond example:

    bonds:
      bond0:
        dhcp4: yes
        interfaces:
          - eth2
          - eth3
        parameters:
          mode: active-backup
          primary: eth3

Apply:

    sudo netplan apply

---

# 🧱 Part E — Hostname and Name Resolution

Set hostname:

    hostnamectl set-hostname newname

Local mapping:

    sudo vi /etc/hosts

Example:

    192.168.1.20 server1.lab server1

systemd-resolved:

    sudo vi /etc/systemd/resolved.conf
    DNS=8.8.8.8

Restart:

    sudo systemctl restart systemd-resolved

---

# 🔐 Part F — SSH (Client & Server)

Check status:

    systemctl status ssh
    systemctl status ssh.socket

Remember:

- ssh.service may be disabled
- ssh.socket enabled
- SSH still works (socket activation)

Force classic enable:

    sudo systemctl enable --now ssh

Config:

    sudo vi /etc/ssh/sshd_config

Common options:

    PermitRootLogin no
    PasswordAuthentication no
    AddressFamily inet

Per-user override:

    Match User bob
        PasswordAuthentication yes

Restart:

    sudo systemctl restart sshd

Test:

    ssh -v user@host

---

# 🔥 Part G — Firewall (ufw)

Status:

    sudo ufw status numbered

Allow:

    sudo ufw allow 22
    sudo ufw allow from 10.11.12.0/24

Deny:

    sudo ufw insert 1 deny from 10.0.0.19

Delete rule:

    sudo ufw delete 5

---

# 🧨 Part H — Firewall (iptables / NAT)

Port forwarding:

    sudo iptables -t nat -A PREROUTING -p tcp -s 10.5.5.0/24 --dport 81 -j DNAT --to-destination 192.168.5.2:80
    sudo iptables -t nat -A POSTROUTING -s 10.5.5.0/24 -j MASQUERADE

List:

    sudo iptables -t nat -L -n -v

Persist:

    sudo apt install iptables-persistent

---

# 🌐 Part I — Reverse Proxy / Load Balancer (nginx)

Reverse proxy snippet:

    server {
        location / {
            proxy_pass http://google.com;
        }
    }

Load balancer snippet:

    upstream backend {
        server 10.0.0.1 weight=3;
        server 10.0.0.2;
    }

    server {
        location / {
            proxy_pass http://backend;
        }
    }

Test and reload:

    sudo nginx -t
    sudo systemctl reload nginx

---

# 🧪 Canonical Exam Scenarios

Show routes and save:

    ip r > route.txt

Check which interface has IP:

    ip a | grep enp6s0

Check who listens on 8080:

    ss -tlnp | grep 8080

Allow subnet:

    sudo ufw allow from 10.11.12.0/24

Disable SSH password except one user:

    PasswordAuthentication no
    Match User john
        PasswordAuthentication yes

---

## ⚠️ Failure Modes

- Forgetting netplan apply
- Bad YAML indentation
- Locking yourself out with firewall
- Restarting ssh instead of sshd
- Misunderstanding socket activation

---

## 🏁 Phase 8 Mastery Checklist

You must be able to:

- Inspect IPs, routes, DNS
- Add temporary and persistent IP config
- Configure netplan (addresses, routes, DNS)
- Build bridges and bonds
- Understand SSH socket activation
- Configure SSH securely
- Open/close ports with ufw
- Do basic NAT with iptables
- Verify listening services

---

## 🔒 Exam Law

> **If packets don’t flow correctly, nothing else matters.**

---
