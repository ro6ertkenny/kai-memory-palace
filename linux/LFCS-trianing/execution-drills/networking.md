# 🧪 Networking — Execution Drills (LFCS)

Mental mode: Connectivity under pressure.  
Goal: Be able to **inspect, configure, test, debug, and persist networking** quickly and safely.

This is not a tutorial.  
This is an **execution checklist**.

---

## 🌐 1) Inspect Network State

- Show interfaces
- Show IP addresses
- Show routes
- Show DNS configuration
- Show listening ports

    ip link
    ip addr
    ip route
    resolvectl status || cat /etc/resolv.conf
    ss -lntup

---

## 🔌 2) Basic Connectivity Tests

- Ping local gateway
- Ping public IP
- Ping DNS name
- Trace route
- Show path MTU issues

    ping -c 3 127.0.0.1
    ping -c 3 8.8.8.8
    ping -c 3 google.com
    traceroute 8.8.8.8 || tracepath 8.8.8.8
    tracepath google.com

---

## 🧭 3) Interface Configuration (Temporary)

- Bring interface up/down
- Assign IP address
- Remove IP address
- Add default route
- Delete route

    sudo ip link set eth0 down
    sudo ip link set eth0 up
    sudo ip addr add 192.168.50.10/24 dev eth0
    sudo ip addr del 192.168.50.10/24 dev eth0
    sudo ip route add default via 192.168.50.1
    sudo ip route del default

---

## 🧾 4) DNS Resolution

- Test name resolution
- Query specific DNS server
- Flush caches (systemd-resolved)

    getent hosts google.com
    dig google.com
    dig @8.8.8.8 google.com
    sudo resolvectl flush-caches

---

## 🔍 5) Port and Service Testing

- Check if port is listening
- Test TCP connection
- Test HTTP service
- Scan ports (if available)

    ss -lntup
    nc -vz 127.0.0.1 22
    curl -I http://127.0.0.1
    nmap 127.0.0.1

---

## 🔥 6) Firewall (nftables / ufw / iptables)

- Show firewall status
- Allow a port
- Deny a port
- Reload firewall
- Verify rules

    sudo ufw status || sudo nft list ruleset || sudo iptables -L
    sudo ufw allow 22
    sudo ufw deny 1234
    sudo ufw reload
    sudo ufw status verbose

---

## 🧱 7) Packet Filtering (Explicit Drill)

Goal: Prove you can implement and verify packet filtering rules.

### Option A: nftables (preferred on modern Debian)

- Show ruleset
- Add a simple allow rule for SSH (example)
- Verify rule exists
- Remove rule

    sudo nft list ruleset

Create a temporary table/chain (lab-safe). This does not persist unless you save it:

    sudo nft add table inet lfcs_lab
    sudo nft add chain inet lfcs_lab input '{ type filter hook input priority 0; policy accept; }'
    sudo nft add rule inet lfcs_lab input tcp dport 22 accept
    sudo nft list table inet lfcs_lab

Cleanup:

    sudo nft delete table inet lfcs_lab

### Option B: ufw (simple interface)

- Enable ufw (if not enabled)
- Allow/deny ports
- Show numbered rules

    sudo ufw status verbose
    sudo ufw enable
    sudo ufw allow 22
    sudo ufw deny 1234
    sudo ufw status numbered

### Option C: iptables (legacy)

- List rules
- Add rule (example allow SSH)
- Delete rule

    sudo iptables -L -n -v
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -L -n -v
    sudo iptables -D INPUT -p tcp --dport 22 -j ACCEPT

---

## 🧩 8) Packet Inspection

- Capture packets
- Capture on specific interface
- Capture specific port
- Save capture to file

    sudo tcpdump -i any
    sudo tcpdump -i eth0
    sudo tcpdump -i eth0 port 80
    sudo tcpdump -i eth0 -w capture.pcap

---

## 🔁 9) Network Services

- Check service status
- Restart networking service
- Restart NetworkManager or systemd-networkd

    systemctl status networking || systemctl status NetworkManager
    sudo systemctl restart networking || sudo systemctl restart NetworkManager
    systemctl status systemd-networkd || true
    sudo systemctl restart systemd-networkd || true

---

## 🧠 10) Persistent Configuration (Distro Dependent)

- Netplan (Ubuntu)
- systemd-networkd
- NetworkManager

    ls /etc/netplan || true
    ls /etc/systemd/network || true
    nmcli device status || true

---

## 🧪 11) nmcli Drills (If NetworkManager Present)

- Show devices
- Show connections
- Bring connection down/up
- Set static IP
- Set DNS

    nmcli device status
    nmcli connection show
    nmcli connection down "Wired connection 1"
    nmcli connection up "Wired connection 1"
    nmcli connection modify "Wired connection 1" ipv4.method manual ipv4.addresses 192.168.50.10/24 ipv4.gateway 192.168.50.1 ipv4.dns 1.1.1.1
    nmcli connection up "Wired connection 1"

---

## 🛣️ 12) Routing Drills

- Show routing table
- Add static route
- Delete static route

    ip route
    sudo ip route add 10.10.0.0/16 via 192.168.50.1
    sudo ip route del 10.10.0.0/16

---

## ⏱️ 13) Time Synchronization (NTP / timesync)

Goal: Prove you can inspect and correct time sync behavior.

Baseline inspection:

    timedatectl
    timedatectl timesync-status 2>/dev/null || true

systemd-timesyncd (common on Debian minimal installs):

    systemctl status systemd-timesyncd --no-pager || true
    sudo systemctl enable --now systemd-timesyncd || true
    sudo systemctl restart systemd-timesyncd || true
    journalctl -u systemd-timesyncd --since "30 minutes ago" --no-pager || true

chrony (common alternative):

    sudo apt-get update
    sudo apt-get install -y chrony
    systemctl status chrony --no-pager
    chronyc sources || true
    chronyc tracking || true

Quick verification:

    date
    timedatectl

---

## 🔐 14) SSH Drills

- SSH to localhost
- SSH with key
- Copy files with scp
- Copy files with rsync

    ssh localhost
    ssh -i ~/.ssh/id_rsa user@host
    scp file.txt user@host:/tmp/
    rsync -av file.txt user@host:/tmp/

---

## 🧯 15) Emergency Network Recovery

- Bring loopback up
- Restart network stack
- Reacquire DHCP lease

    sudo ip link set lo up
    sudo systemctl restart NetworkManager || sudo systemctl restart networking
    sudo dhclient -v

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can diagnose "no network" in minutes
- You can set a static IP blindfolded
- You can prove where the breakage is: link, IP, route, DNS, firewall, or service
- You can implement and verify packet filtering rules
- You can verify time sync status and restart/fix the time sync service

---
