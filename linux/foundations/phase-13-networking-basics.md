# 🌐 Phase 13 — Networking Fundamentals: Interfaces, Addresses, Routes, and Name Resolution
*LFCS connectivity layer: if networking is wrong, nothing else matters.*

---

## 📌 Purpose

This phase makes you **operationally competent with Linux networking**:

- Inspecting interfaces and IP addresses
- Adding temporary and persistent IPs
- Reading and modifying routes
- Verifying listening services
- Testing connectivity
- Understanding name resolution
- Knowing where configuration actually lives (netplan, resolv, hosts)

LFCS networking tasks are **diagnose + apply + verify**.

---

## 🧠 Mental Model

Think in **4 layers**:

1) Interface exists?  
2) Address assigned?  
3) Route exists?  
4) Name resolves?

If any layer is wrong → networking fails.

---

# 🔌 Part A — Inspect Interfaces and Addresses

Show all interfaces:

    ip a

Show specific interface:

    ip a show enp6s0

Filter:

    ip a | grep enp6s0

---

# 🧭 Part B — Routes

Show routes:

    ip route
    ip route show

Show default gateway:

    ip route | grep default

Save to file:

    ip route show > route.txt

---

# ➕ Part C — Temporary IP Address (Runtime Only)

Add address:

    sudo ip a add 192.168.9.3/24 dev eth1

Remove:

    sudo ip a del 192.168.9.3/24 dev eth1

⚠️ Lost on reboot.

---

# 🧱 Part D — Persistent Config (Ubuntu / Netplan)

Edit file:

    sudo vi /etc/netplan/99-custom.yaml

Example static config:

    network:
      version: 2
      ethernets:
        enp6s0:
          dhcp4: false
          dhcp6: false
          addresses:
            - 10.0.10.5/24

Permissions:

    sudo chmod 600 /etc/netplan/99-custom.yaml

Apply:

    sudo netplan apply

Test safely:

    sudo netplan try

---

# 🧭 Part E — Static Routes (Netplan)

Example:

    network:
      version: 2
      ethernets:
        enp0s10:
          dhcp4: false
          addresses:
            - 10.198.0.5/24
          routes:
            - to: 192.168.0.0/24
              via: 10.198.0.1

Apply:

    sudo netplan apply

Verify:

    ip route

---

# 🌉 Part F — Bridges and Bonds (Awareness Level)

Bridge example:

    network:
      version: 2
      renderer: networkd
      ethernets:
        eth1:
          dhcp4: no
        eth2:
          dhcp4: no
      bridges:
        bridge1:
          dhcp4: yes
          interfaces:
            - eth1
            - eth2

Bond example:

    network:
      version: 2
      renderer: networkd
      ethernets:
        eth2:
          dhcp4: no
        eth3:
          dhcp4: no
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

# 📛 Part G — Name Resolution

Local hosts file:

    /etc/hosts

DNS config (often managed):

    /etc/resolv.conf

systemd-resolved config:

    /etc/systemd/resolved.conf

Example edit:

    sudo vi /etc/systemd/resolved.conf
    DNS=8.8.8.8

Restart:

    sudo systemctl restart systemd-resolved

Test:

    ping google.com

---

# 🔎 Part H — Listening Ports

Modern:

    ss -tlnp

Old:

    sudo netstat -tulpn

Check SSH:

    ss -tlnp | grep :22

Check HTTP:

    ss -tlnp | grep :80

---

# 🧪 Canonical Exam Scenarios

Find interface owning IP:

    ip a | grep -i 10.5.5.2

Save interface name:

    ip a | grep -i 10.5.5.2 | awk '{print $NF}' > /opt/interface.txt

Add IP:

    sudo ip a add 10.5.0.1/24 dev eth1

Check DNS config:

    cat /etc/resolv.conf

Show routes:

    ip route show

---

# ⚠️ Failure Modes

- Editing netplan and forgetting to apply
- Breaking YAML indentation
- Forgetting chmod 600 on netplan files
- Confusing runtime ip commands with persistent config
- Forgetting to verify routes

---

# 🏁 Phase 13 Mastery Checklist

You must be able to:

- Inspect interfaces and IPs
- Add temporary IPs
- Configure persistent IPs with netplan
- Read and set routes
- Identify default gateway
- Check listening ports
- Understand where DNS config lives
- Diagnose connectivity failures by layer

---

## 🌐 Exam Law

> **If you can’t explain which interface, which IP, which route, and which resolver is in use — you don’t understand the network yet.**

---

