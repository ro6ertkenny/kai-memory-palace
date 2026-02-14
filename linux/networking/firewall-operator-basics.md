# 🔥 Firewall Operator Basics (UFW) — Operator Canonical (LFCS)

Goal: prove **whether the firewall is involved and allow only what is required**.

Firewall is never step one.

---

## 🧠 Operator mental model

Listener → address → route → firewall.

Timeout → firewall/routing  
Refused → no listener

---

## ✅ Safe command order

Verify listener first:

    sudo ss -lntup | grep -E ':(PORT)\b'

Check firewall:

    sudo ufw status verbose

Allow SSH before enabling remotely:

    sudo ufw allow OpenSSH

---

## 🔎 Core workflows

### Enable firewall safely

    sudo ufw allow OpenSSH
    sudo ufw enable

### Allow a TCP port

    sudo ufw allow PORT/tcp

### Allow from specific subnet

    sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp

### Deny a port

    sudo ufw deny PORT/tcp

### Delete a rule

    sudo ufw status numbered
    sudo ufw delete <N>

---

## 🧪 Verification workflow

    sudo ufw status verbose
    sudo ss -lntup | grep -E ':(PORT)\b'
    curl http://127.0.0.1:PORT

Remote test from client:

    nc -vz <server-ip> PORT

---

## 🧯 Failure-mode debugging

UFW inactive but traffic blocked:

→ another firewall system exists.

Rule present but still failing:

→ service bound to 127.0.0.1 or routing issue.

Locked out of SSH:

    sudo ufw allow OpenSSH
    sudo ufw reload

---

## 🔗 Drill references

- linux/LFCS-training/execution-drills/firewall-ufw-basics.md
- linux/LFCS-training/execution-drills/service-reachability-debug.md

---

## 🪝 Exam memory hook

Always:

    sudo ss -lntup
    ip -br a
    ip route
    sudo ufw status

