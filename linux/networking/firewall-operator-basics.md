i# 🔥 Firewall Operator Basics (nftables / iptables) — LFCS-Level

Mental mode: Prove whether firewall is involved, list rules, make the smallest change, persist if required, verify.

LFCS expects you to operate at the level of:

- list active rules
- open/close a port
- allow SSH (avoid locking yourself out)
- verify listeners and reachability
- persist changes (when applicable)

This guide is distro-agnostic:

- Prefer **nftables** when present
- Fall back to **iptables** when that’s what exists

---

## 🎯 Operator Goals

You must be able to:

- Determine what firewall tooling exists
- Determine whether traffic is being blocked locally
- Allow inbound to a known port (TCP/UDP)
- Allow SSH safely
- Persist the change (if required by the system)
- Verify with `ss`, `curl`, and remote tests

---

## 🧭 First Principle: Don’t Guess

If a service is listening but remote clients cannot connect:

1) Confirm it is listening locally
2) Confirm you are testing the right address and port
3) Then check firewall rules

---

## 🔎 Identify Which Firewall Tooling Exists

Run:

    command -v nft && echo "nftables available"
    command -v iptables && echo "iptables available"
    command -v ufw && echo "ufw available"
    command -v firewall-cmd && echo "firewalld available"

For LFCS, the safest baseline is:

- nftables or iptables

If ufw/firewalld exist, they may be a higher-level interface over nftables/iptables.

---

## ✅ Verify The Service Is Listening (Before Touching Firewall)

List listeners:

    ss -lntup
    ss -lnup

Examples:

- TCP 80:

      ss -lntp | grep ':80 '

- TCP 22 (SSH):

      ss -lntp | grep ':22 '

If the service is not listening, firewall changes will not help.

---

## 🧱 nftables — Core Operator Commands

List ruleset:

    sudo nft list ruleset

List tables:

    sudo nft list tables

List a specific table/chain (common pattern):

    sudo nft list table inet filter
    sudo nft list chain inet filter input

Common tables:

- `inet filter` (covers IPv4+IPv6)
- `ip filter` / `ip6 filter`

---

## 🧱 iptables — Core Operator Commands

List rules:

    sudo iptables -L -n -v
    sudo iptables -S

List NAT table (if relevant):

    sudo iptables -t nat -L -n -v
    sudo iptables -t nat -S

For IPv6 (if needed):

    sudo ip6tables -L -n -v
    sudo ip6tables -S

---

## 🛡️ Safe Rule Changes (LFCS-Level)

### Rule strategy (operator-safe)

- Allow a specific port (TCP/UDP)
- Prefer minimal scope (port + protocol)
- Verify immediately
- Persist only after success

---

## ✅ Allow SSH (avoid lockout)

### nftables (typical inet filter)

Add an allow rule for SSH:

    sudo nft add rule inet filter input tcp dport 22 ct state new,established accept

If you also need return traffic:

    sudo nft add rule inet filter input ct state established,related accept

Note: Ordering matters. If there is a default drop earlier, insert instead of add.

Insert at top (position 0) when needed:

    sudo nft insert rule inet filter input position 0 tcp dport 22 ct state new,established accept

---

### iptables

Allow SSH:

    sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT

If established traffic isn’t already permitted (often it is), add:

    sudo iptables -I INPUT 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

---

## ✅ Allow a TCP Port (example: 8080)

### nftables

    sudo nft add rule inet filter input tcp dport 8080 ct state new,established accept

---

### iptables

    sudo iptables -I INPUT 1 -p tcp --dport 8080 -j ACCEPT

---

## ✅ Allow a UDP Port (example: 53)

### nftables

    sudo nft add rule inet filter input udp dport 53 accept

---

### iptables

    sudo iptables -I INPUT 1 -p udp --dport 53 -j ACCEPT

---

## 🧪 Verification Checklist (Must Do Every Time)

Local verification:

1) Listening:

       ss -lntup | grep ':8080 '

2) Local request:

       curl -sS http://127.0.0.1:8080/ | head

Remote verification (from another machine, if available):

- curl / nc to the host IP:port

If local works but remote doesn’t:

- firewall or routing is likely involved

---

## 💾 Persistence (Distro-Dependent)

LFCS systems may persist rules via different mechanisms.

### nftables persistence (common pattern)

If `/etc/nftables.conf` exists:

- Save your intended ruleset there (careful: replace with known-good config)
- Ensure nftables service is enabled

Check:

    systemctl status nftables || true

Enable:

    sudo systemctl enable --now nftables

Note: Persistence details vary by distro. If unsure, keep the change minimal and verify functionality.

---

### iptables persistence (common pattern)

Some distros require an iptables persistence service/package.

At LFCS level:

- It is acceptable to make the change and verify in the running system
- If persistence is required, look for:

    /etc/iptables/
    iptables-save
    iptables-restore

Example (if applicable):

    sudo iptables-save | sudo tee /etc/iptables/rules.v4

---

## ⛔ Operator Rules

- Never change firewall rules before confirming the service is listening.
- Always allow SSH before experimenting remotely.
- Insert allow rules at the top when a default-drop policy exists.
- Verify with `ss` + `curl` every time.
- Keep changes minimal and reversible.

---

## 🔁 Reversal / Cleanup (Know How To Undo)

### nftables

List with handles (so you can delete a specific rule):

    sudo nft -a list chain inet filter input

Delete by handle:

    sudo nft delete rule inet filter input handle <HANDLE>

---

### iptables

List with line numbers:

    sudo iptables -L INPUT -n --line-numbers

Delete by line number:

    sudo iptables -D INPUT <N>

---

## 🔗 Cross-Links

- Networking debugging checklist
- Ports and listeners
- Network and DNS failures playbook

---

## 🏁 Exit Criteria

You are done when:

- You can identify the firewall toolchain quickly
- You can list rules
- You can open a port safely without breaking SSH
- You can verify end-to-end connectivity

