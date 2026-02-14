# 🔌 Ports and Listeners (ss) — Operator Canonical (LFCS)

Goal: prove **what is listening, where it is bound, who owns it, and whether it is reachable**.

---

## 🧠 Operator mental model

A port is reachable only if:

- a process is LISTENing
- on the correct port
- bound to the correct address
- on a usable interface
- and not blocked upstream

Binding decides exposure:

- 0.0.0.0:PORT → all IPv4 interfaces
- <server-ip>:PORT → one interface only
- 127.0.0.1:PORT → localhost only (never remotely reachable)
- [::]:PORT → all IPv6 interfaces

---

## ✅ Safe command order

    sudo ss -lntup
    sudo ss -lntup | grep -E ':(PORT)\b'
    systemctl status <service>
    journalctl -u <service> -n 50 --no-pager

Local test before firewall:

    curl http://127.0.0.1:PORT
    timeout 2 bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/PORT' && echo OK || echo FAIL

---

## 🔎 Core workflows

### List all listeners

    sudo ss -lntup

### Fast TCP state table view

    ss -tan

### Find what owns a port

    sudo ss -lntup | grep -E ':(PORT)\b'

### Show active established connections

    ss -ntp
    ss -ntp state established

Key states:

- LISTEN → waiting for connections
- ESTAB → active session
- TIME-WAIT → normal kernel cleanup

---

## 🧯 Failure-mode debugging

### Service running but remote access fails

Check bind address:

    sudo ss -lntup | grep -E ':(PORT)\b'

If 127.0.0.1 → service is local-only.

### Connection refused

Listener missing or wrong port.

### Connection timeout

Listener exists → check firewall or routing.

### No PID/program shown

Run with sudo.

---

## 🔗 Drill references

- linux/LFCS-training/execution-drills/networking-ports-and-listeners.md
- linux/LFCS-training/execution-drills/service-reachability-debug.md

---

## 🪝 Exam memory hook

Refused = no listener  
Timeout = firewall or routing

Default muscle memory:

    sudo ss -lntup

