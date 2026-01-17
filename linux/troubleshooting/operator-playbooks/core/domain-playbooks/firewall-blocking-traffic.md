# 🔥 Firewall Blocking Traffic — Domain Playbook

Mental mode: Prove the service, prove reachability path, isolate firewall, apply minimal allow rule, verify.

Use this playbook when:

- A service works locally but not remotely
- A port is listening but clients cannot connect
- You suspect firewall rules are blocking traffic

---

## 🎯 Objective

1) Prove the service is actually listening
2) Prove whether the block is local firewall vs routing vs upstream
3) Apply the smallest safe allow rule
4) Verify end-to-end connectivity
5) Avoid SSH lockout

---

## 🧪 Entry Conditions

- Local access works (curl localhost succeeds)
- Remote access fails (timeout/refused)
- Or the host is supposed to accept inbound connections

---

## 🔎 Step 1 — Confirm Listener (No Guessing)

Check listening sockets:

    ss -lntup
    ss -lnup

Confirm specific port (example TCP 8080):

    ss -lntp | grep ':8080 '

If the service is not listening:

- Exit this playbook
- Use service/process troubleshooting instead

---

## 🧭 Step 2 — Test Locally

Test loopback:

    curl -sS http://127.0.0.1:8080/ | head

If local fails:

- This is not a firewall problem
- Fix the service first

---

## 🌐 Step 3 — Test From Remote (If Possible)

From another host:

- curl http://<host-ip>:8080
- or nc -vz <host-ip> 8080

Interpretation:

- Timeout: likely firewall drop, routing, or upstream path issue
- Refused: typically no listener or local reject policy

---

## 🔎 Step 4 — Check Basic Routing / IP

On the target host:

    ip addr
    ip route

Confirm:

- Correct IP is present
- Default route exists (if needed)
- You are testing the correct IP

---

## 🧱 Step 5 — Identify Firewall Tooling

    command -v nft && echo "nftables"
    command -v iptables && echo "iptables"
    command -v ufw && echo "ufw"
    command -v firewall-cmd && echo "firewalld"

Proceed with nftables if present, otherwise iptables.

---

## 🧱 Step 6 — Inspect Rules

### nftables

    sudo nft list ruleset

Focus on:

- `inet filter input` chain
- default policy (drop/reject)
- rules allowing or denying your port

To inspect with handles:

    sudo nft -a list chain inet filter input

---

### iptables

    sudo iptables -L -n -v
    sudo iptables -S

Look for:

- DROP/REJECT rules
- default policy
- missing allow rule for your port

---

## 🛡️ Step 7 — Apply Minimal Safe Fix

### Safety first: ensure SSH is allowed (if remote)

If you are connected over SSH, confirm port 22 is allowed before changing anything.

nftables (insert at top if necessary):

    sudo nft insert rule inet filter input position 0 tcp dport 22 ct state new,established accept

iptables:

    sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

---

### Allow the target port (example TCP 8080)

nftables:

    sudo nft add rule inet filter input tcp dport 8080 ct state new,established accept

iptables:

    sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT

---

## 🧪 Step 8 — Verify

On target host:

1) Confirm listener still exists:

       ss -lntp | grep ':8080 '

2) Confirm local access:

       curl -sS http://127.0.0.1:8080/ | head

From remote host:

- curl http://<host-ip>:8080

If remote still fails:

- firewall is not the only problem
- check routing, upstream ACLs, or wrong IP/port

---

## 💾 Step 9 — Persistence (Only After Success)

If exam task requires persistence:

- nftables: update /etc/nftables.conf and enable nftables service (distro-dependent)
- iptables: use iptables-save/restore or distro persistence tooling

Do not persist until functionality is proven.

---

## 🧯 Step 10 — Cleanup / Rollback

### nftables rollback

List with handles:

    sudo nft -a list chain inet filter input

Delete rule by handle:

    sudo nft delete rule inet filter input handle <HANDLE>

---

### iptables rollback

List with line numbers:

    sudo iptables -L INPUT -n --line-numbers

Delete by line number:

    sudo iptables -D INPUT <N>

---

## ⛔ Operator Rules

- Never blame firewall before proving the listener exists.
- If local works and remote fails, firewall is a prime suspect.
- Always protect SSH first when remote.
- Make the smallest allow change.
- Verify end-to-end before persisting.

---

## 🔁 Exit Criteria

- Service is reachable remotely on the intended IP:port
- Firewall rules are minimal and understood
- SSH access is intact

