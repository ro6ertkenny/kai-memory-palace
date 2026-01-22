# 🧪 Networking — Execution Drills (LFCS)

Path:
  linux/LFCS-training/execution-drills/networking.md

Mental mode: Connectivity + reachability under pressure.  
Goal: Be able to **inspect, test, debug, and (when required) make safe temporary changes** to networking and exposure under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

Primary debug order (unreachable systems):

    interface → IP → route → DNS → firewall → service

Exposure debug order (service “up” but unreachable):

    listener → firewall → NAT/forwarding

---

## 🧱 Lab Setup (Safe Mode)

⚠️ If this is your primary machine, avoid touching your real interface config.  
Prefer: a VM, or use a dummy interface / network namespace.

Install common tools (Debian/Ubuntu):

    sudo apt-get update
    sudo apt-get install -y iproute2 iputils-ping dnsutils curl net-tools ufw tcpdump traceroute iptables

Optional tools:

    sudo apt-get install -y nmap

If you want a local service to test reachability:

    sudo apt-get install -y nginx
    sudo systemctl enable --now nginx

---

## 1) Inspect Network State (Baseline)

- Show interfaces
- Show IP addresses
- Show routes
- Show DNS configuration
- Show listeners

    ip link
    ip addr
    ip route
    resolvectl status 2>/dev/null || cat /etc/resolv.conf
    ss -lntup

Save evidence (exam habit):

    ip addr > ips.txt
    ip route > routes.txt
    ss -lntup > listening.txt

---

## 2) Basic Connectivity Tests

- Local TCP/IP stack
- Reach public IP (routing)
- Reach DNS name (DNS + routing)
- Trace path

    ping -c 3 127.0.0.1
    ping -c 3 8.8.8.8
    ping -c 3 google.com
    traceroute 8.8.8.8 || tracepath 8.8.8.8
    tracepath google.com || true

HTTP service check (local):

    curl -I http://127.0.0.1 2>/dev/null | head -n 5 || true

---

## 3) Temporary IP and Routes (Do NOT use main interface)

Use a dummy interface (safe drill):

    sudo ip link add dummy0 type dummy
    sudo ip link set dummy0 up

Add an IP:

    sudo ip addr add 192.168.50.10/24 dev dummy0
    ip addr show dummy0

Add a temporary route (example):

    sudo ip route add 10.10.0.0/16 via 192.168.50.1
    ip route

Delete the route and IP:

    sudo ip route del 10.10.0.0/16
    sudo ip addr del 192.168.50.10/24 dev dummy0

Cleanup:

    sudo ip link del dummy0

Rule:
- Do NOT run `ip link set eth0 down` on a real machine you’re using.

---

## 4) DNS and Hosts

Inspect resolver wiring:

    resolvectl status 2>/dev/null || true
    cat /etc/resolv.conf

Name resolution tests:

    getent hosts google.com
    dig google.com
    dig @8.8.8.8 google.com

Local override drill (/etc/hosts):

    sudo vi /etc/hosts

Add:

    127.0.0.1 test.local

Test:

    ping -c 1 test.local

Flush caches (systemd-resolved, if present):

    sudo resolvectl flush-caches 2>/dev/null || true

---

## 5) Listening Services and Port Testing

Who is listening:

    ss -tlnp
    sudo netstat -tulpn

Test local TCP ports:

    nc -vz 127.0.0.1 22 2>/dev/null || true
    nc -vz 127.0.0.1 80 2>/dev/null || true

Identify what is on port 80:

    ss -tlnp | grep ':80' || true

Operator rule:
- If the service is not listening, firewall/NAT changes will not help.

---

## 6) Firewall — UFW (Simple Operator Surface)

⚠️ Keep one root-capable session open when touching firewall on remote hosts.  
⚠️ Always allow SSH before enabling a firewall on remote systems.

Status and numbered rules:

    sudo ufw status numbered

Allow SSH and HTTP (safe baseline):

    sudo ufw allow 22
    sudo ufw allow 80

Allow a subnet:

    sudo ufw allow from 10.11.12.0/24

Insert a deny rule (simulation pattern):

    sudo ufw insert 1 deny from 10.0.0.19

Verify rules:

    sudo ufw status numbered

Delete rule by number:

    sudo ufw delete 1

Reality note:
- Local loopback tests (127.0.0.1) often won’t prove UFW behavior for external clients.
- For true verification, test from another host when possible.

---

## 7) Firewall — nftables / iptables (Inspection + Minimal Drills)

nftables ruleset inspection (modern Debian):

    sudo nft list ruleset 2>/dev/null || true

iptables list (legacy/compatible):

    sudo iptables -L -n -v 2>/dev/null || true
    sudo iptables -S 2>/dev/null || true

NAT table inspection (read-only drill):

    sudo iptables -t nat -L -n -v 2>/dev/null || true
    sudo iptables -t nat -S 2>/dev/null || true

Rule:
- Do not add real NAT rules unless in a disposable VM.

---

## 8) NAT / Port Forwarding (VM-Only Drill)

Goal: Understand PREROUTING vs POSTROUTING, and prove you can add/remove a simple port-forward safely.

⚠️ VM/lab only. Do not do this on your primary machine.

Forward TCP 81 → local TCP 80 (DNAT to self):

    sudo iptables -t nat -A PREROUTING -p tcp --dport 81 -j DNAT --to-destination 127.0.0.1:80
    sudo iptables -t nat -A POSTROUTING -p tcp -d 127.0.0.1 --dport 80 -j MASQUERADE

Test:

    curl -I http://127.0.0.1:81 2>/dev/null | head -n 5 || true

List NAT:

    sudo iptables -t nat -L -n -v

Cleanup (remove rules):

List with line numbers:

    sudo iptables -t nat -L --line-numbers

Delete (adjust numbers if needed):

    sudo iptables -t nat -D PREROUTING 1
    sudo iptables -t nat -D POSTROUTING 1

Mental model:
- PREROUTING changes destination (DNAT)
- POSTROUTING changes source/egress (SNAT/MASQUERADE)
- If DNAT exists but return path isn’t handled, clients will fail mysteriously.

---

## 9) Packet Capture (Evidence)

Capture on all interfaces:

    sudo tcpdump -i any

Capture specific ports:

    sudo tcpdump -i any port 53
    sudo tcpdump -i any port 22
    sudo tcpdump -i any port 80

Save capture to file:

    sudo tcpdump -i any -w capture.pcap

---

## 10) SSH Hardening (Do Not Lock Yourself Out)

⚠️ Keep a root console open.  
⚠️ Verify config before restart.

Inspect relevant config lines:

    sudo grep -E '^(#)?(PermitRootLogin|PasswordAuthentication|AddressFamily)' /etc/ssh/sshd_config

Edit carefully:

    sudo vi /etc/ssh/sshd_config

Common hardening targets:

    PermitRootLogin no
    PasswordAuthentication no
    AddressFamily inet

Validate config:

    sudo sshd -t

Restart service (varies by distro):

    sudo systemctl restart sshd 2>/dev/null || sudo systemctl restart ssh 2>/dev/null || true
    systemctl status sshd 2>/dev/null || systemctl status ssh 2>/dev/null || true

Socket activation awareness (Ubuntu pattern):

    systemctl status ssh 2>/dev/null || true
    systemctl status ssh.socket 2>/dev/null || true

Explain:
- ssh.socket may accept connections even if ssh.service is not “enabled” the way you expect.

Force classic behavior (when appropriate):

    sudo systemctl enable --now ssh 2>/dev/null || true

---

## 11) netplan (Inspect + Safety Workflow)

If present (Ubuntu commonly):

    ls -l /etc/netplan 2>/dev/null || true
    sudo cat /etc/netplan/*.yaml 2>/dev/null || true

Safety validation drill (do not accept changes that break connectivity):

    sudo netplan try

Rule:
- Use `netplan try` before rebooting after netplan changes.

---

## 12) Persistent Configuration Surfaces (Distro Dependent)

systemd-networkd:

    ls /etc/systemd/network 2>/dev/null || true
    systemctl status systemd-networkd --no-pager 2>/dev/null || true

NetworkManager:

    nmcli device status 2>/dev/null || true
    nmcli connection show 2>/dev/null || true

---

## 13) Reverse Proxy (nginx) — Disposable Drill

Goal: Stand up a simple reverse proxy listener and prove it responds.

Create a site config:

    sudo sh -c 'cat > /etc/nginx/sites-available/proxy-test <<EOF
    server {
        listen 8081;
        location / {
            proxy_pass http://example.com;
        }
    }
    EOF'

Enable it:

    sudo ln -s /etc/nginx/sites-available/proxy-test /etc/nginx/sites-enabled/proxy-test

Validate and reload:

    sudo nginx -t
    sudo systemctl reload nginx

Test:

    curl -I http://127.0.0.1:8081 2>/dev/null | head -n 5 || true

Cleanup:

    sudo rm -f /etc/nginx/sites-enabled/proxy-test
    sudo rm -f /etc/nginx/sites-available/proxy-test
    sudo systemctl reload nginx

Proxy concept rule:
- Reverse proxy = inbound traffic to backend services
- Forward proxy = outbound client access control (conceptual awareness only)

---

## 14) Timed Drills (Speed)

Save routes (10 seconds):

    ip route > routes.txt
    wc -l routes.txt

Find who listens on 80 (10 seconds):

    ss -tlnp | grep ':80' || true

Allow subnet in UFW (15 seconds):

    sudo ufw allow from 10.11.12.0/24
    sudo ufw status numbered

Show NAT table (10 seconds):

    sudo iptables -t nat -L -n -v

---

## 15) Failure Injection Drills (Diagnosis Reflex)

Unreachable checklist (run in order):

    ip link
    ip addr
    ip route
    resolvectl status 2>/dev/null || cat /etc/resolv.conf
    ss -tlnp
    sudo ufw status numbered 2>/dev/null || true
    sudo nft list ruleset 2>/dev/null || true
    sudo iptables -L -n -v 2>/dev/null || true
    sudo iptables -t nat -L -n -v 2>/dev/null || true

Explain what each checks:
- link state (interface)
- addressing
- routing
- resolver wiring
- service listening
- firewall policy
- NAT/forwarding translations (when relevant)

Firewall/SSH lockout rules:
- Always keep a root console open when changing firewall rules.
- Always validate sshd config with `sshd -t` before restarting.
- Always ensure port 22 is allowed before enabling a firewall on remote systems.

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can diagnose “no network” in minutes using the fixed order
- You can prove where the breakage is: link, IP, route, DNS, firewall, or service
- You can safely add/remove temporary IPs and routes without breaking your main interface
- You can open/close ports with UFW and verify the effective rules
- You can inspect nftables/iptables (including NAT table) and explain what you’re seeing
- You can explain PREROUTING vs POSTROUTING and why half-configured NAT breaks returns
- You can harden SSH without locking yourself out and can prove config validity
- You can prove reachability using listeners + curl/nc + evidence files

---

## 🧹 Cleanup (Optional)

If you installed nginx just for drills:

    sudo systemctl disable --now nginx 2>/dev/null || true

If you created dummy0 earlier:

    sudo ip link del dummy0 2>/dev/null || true

If you created NAT rules in a VM:
- Ensure you removed PREROUTING/POSTROUTING entries (see NAT section)

---

