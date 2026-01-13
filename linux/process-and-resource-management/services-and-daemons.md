# 🧩 Services and Daemons (systemd, LFCS)

Mental mode: **Control long-running system behavior**

This document covers how to inspect, control, verify, and troubleshoot services (daemons) using `systemd`.

---

## 🎯 Goals

You must be able to:
- list running services
- inspect a service’s status
- start, stop, restart, enable, and disable services
- verify a service is actually running
- find the service’s main PID
- inspect logs using `journalctl`
- reason about failures

---

## 🧠 Core Concept: What Is a Service?

A service (daemon) is a long-running background process started and supervised by `systemd`.

Examples:
- `cron`
- `sshd`
- `docker`
- `containerd`
- `kubelet`

---

## 📋 Listing Services

Running services:

    systemctl list-units --type=service --state=running

Failed services:

    systemctl --failed

---

## 🔍 Inspecting a Service

    systemctl status cron

No pager (better for scripts and copy/paste):

    systemctl status cron --no-pager

This shows:
- active state
- main PID
- recent log lines
- unit file location

---

## ▶️ Starting / Stopping / Restarting

    sudo systemctl start cron
    sudo systemctl stop cron
    sudo systemctl restart cron

---

## 🔁 Enable / Disable at Boot

    sudo systemctl enable cron
    sudo systemctl disable cron

Enable = start automatically at boot  
Disable = do not start at boot

---

## ✅ Verifying a Service Is Actually Running

Method 1: is-active

    systemctl is-active cron

Method 2: MainPID

    systemctl show -p MainPID --value cron

Then verify the PID exists:

    ps -p $(systemctl show -p MainPID --value cron)

---

## 🧾 Logs with journalctl

Recent logs for a service:

    journalctl -u cron

Last 20 lines:

    journalctl -u cron -n 20

Follow (tail -f style):

    journalctl -u cron -f

Errors only:

    journalctl -p err

No pager:

    journalctl -u cron --no-pager

---

## 🔐 Permissions Note

If you see:
- “You are currently not seeing messages from other users…”

Use:

    sudo journalctl -u cron

Or ensure appropriate group membership (`adm`, `systemd-journal`) depending on distro policy.

---

## 📁 Where Unit Files Live

Common locations:
- `/usr/lib/systemd/system/` (vendor units)
- `/lib/systemd/system/` (some distros)
- `/etc/systemd/system/` (overrides and custom units)

---

## 🔁 Common Failure Patterns

- service is running but the port is not open (wrong bind address, firewall, config)
- service is enabled but not started (expected on-demand behavior, or failure at boot)
- restart loop due to configuration error
- dependency failure (another unit is failing)

Operator workflow:
1) `systemctl status <service>`
2) `journalctl -u <service> -n 50 --no-pager`
3) fix config
4) restart
5) verify health

---

## 🧠 Relationship to Processes

Services are processes with a manager:
- you still inspect them with `ps`
- you still send signals when needed
- but the preferred control surface is `systemctl`

If you kill a managed process directly, `systemd` may restart it.

EOF

