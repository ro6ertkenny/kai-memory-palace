# 🧩 Services and Daemons (systemd, LFCS)

Mental mode: **Control long-running system behavior**

This document covers how to inspect, control, verify, and troubleshoot services (daemons) using `systemd`.

---

## 🎯 Goals

You must be able to:
- list running services
- inspect a service’s status
- start, stop, restart, reload services
- enable, disable, mask services
- verify a service is actually running
- find the service’s main PID
- inspect logs using `journalctl`
- reason about failures
- understand common scheduling surfaces (cron/anacron/at)
- schedule shutdown/reboot safely

---

## 🧠 Core Concept: What Is a Service?

A service (daemon) is a long-running background process started and supervised by `systemd`.

Examples:
- `cron` / `crond`
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

All installed service unit files (enabled/disabled status):

    systemctl list-unit-files --type=service

---

## 🔍 Inspecting a Service

    systemctl status cron

No pager (better for scripts and copy/paste):

    systemctl status cron --no-pager

This shows:
- active state
- main PID
- recent log lines
- unit file location (often indirectly; see FragmentPath below)

---

## ▶️ Starting / Stopping / Restarting / Reloading

    sudo systemctl start cron
    sudo systemctl stop cron
    sudo systemctl restart cron

Reload (preferred when supported; reloads config without full restart):

    sudo systemctl reload cron

If reload is unsupported, systemctl will report it.

---

## 🔁 Enable / Disable at Boot

    sudo systemctl enable cron
    sudo systemctl disable cron

Enable = start automatically at boot  
Disable = do not start at boot

Check enabled state:

    systemctl is-enabled cron

---

## 🧱 Mask / Unmask (Hard Block)

Mask prevents a service from being started (even manually) until unmasked.

    sudo systemctl mask cron
    sudo systemctl unmask cron

Use mask when you must guarantee it cannot start.

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

Errors only (system-wide):

    journalctl -p err --no-pager

No pager:

    journalctl -u cron --no-pager

Current boot only (useful after reboot issues):

    journalctl -u cron -b --no-pager

---

## 🔐 Permissions Note

If you see:
- “You are currently not seeing messages from other users…”

Use:

    sudo journalctl -u cron

(Some distros gate logs behind groups like `adm` or `systemd-journal`.)

---

## 📁 Where Unit Files Live

Common locations:
- `/usr/lib/systemd/system/` (vendor units on many distros)
- `/lib/systemd/system/` (some distros)
- `/etc/systemd/system/` (overrides and custom units)

Show the exact unit content systemd is using:

    systemctl cat cron

Show the resolved unit file path (FragmentPath):

    systemctl show -p FragmentPath --value cron

---

## 🔄 When You Edit Units: daemon-reload

If you change a unit file or add a drop-in override, you must reload systemd’s unit cache:

    sudo systemctl daemon-reload

Then restart or reload the service:

    sudo systemctl restart <unit>

---

## 🧩 Dependencies and Targets (KodeKloud/LFCS)

List dependencies (useful when a service fails due to a dependency):

    systemctl list-dependencies <unit>

Show the system default boot target:

    systemctl get-default

Set the default target (be careful; changes boot behavior):

    sudo systemctl set-default multi-user.target
    sudo systemctl set-default graphical.target

Switch the current system to a target immediately:

    sudo systemctl isolate multi-user.target

---

## 🧠 Relationship to Processes

Services are processes with a manager:
- you still inspect them with `ps`
- you still send signals when needed
- but the preferred control surface is `systemctl`

If you kill a managed process directly, `systemd` may restart it.

---

## 🔁 Common Failure Patterns

- service is running but the port is not open (wrong bind address, firewall, config)
- service is enabled but not started (expected on-demand behavior, or failure at boot)
- restart loop due to configuration error
- dependency failure (another unit is failing)
- unit changed but not reloaded (forgot daemon-reload)

Operator workflow:
1) `systemctl status <service>`
2) `journalctl -u <service> -n 50 --no-pager`
3) fix config
4) `sudo systemctl daemon-reload` (if unit changed)
5) restart or reload
6) verify health

---

## 🧭 Shutdown / Reboot Scheduling (LFCS)

Power off now:

    sudo systemctl poweroff

Reboot now:

    sudo systemctl reboot

Schedule shutdown in 10 minutes:

    sudo shutdown -h +10

Schedule reboot at a time (example 23:00):

    sudo shutdown -r 23:00

Cancel a scheduled shutdown/reboot:

    sudo shutdown -c

---

## 🗓️ Scheduling Coverage (cron / anacron / at)

These are “running system” scheduling surfaces.

### cron (recurring)

Edit your user crontab:

    crontab -e

List your user crontab:

    crontab -l

System cron surfaces to inspect:

    ls -l /etc/crontab /etc/cron.* 2>/dev/null

Cron service unit name varies by distro:

    systemctl status cron --no-pager
    systemctl status crond --no-pager

### anacron (catch-up jobs)

Anacron runs scheduled jobs that were missed while the system was off.

Common config/state locations:

    ls -l /etc/anacrontab 2>/dev/null
    ls -l /var/spool/anacron 2>/dev/null

### at (one-time jobs)

Queue a one-time job (non-interactive):

    echo 'echo hello > /tmp/at-test' | at now + 2 minutes

List queued jobs:

    atq

Remove a job:

    atrm <jobid>

---

## 🔧 Operator workflow (LFCS execution)

### Service triage (fast, safe order)

1) Status:

    systemctl status <unit> --no-pager

2) Logs:

    journalctl -u <unit> -n 50 --no-pager

3) If config/unit changed:

    sudo systemctl daemon-reload

4) Restart:

    sudo systemctl restart <unit>

5) Verify:

    systemctl is-active <unit>
    systemctl show -p MainPID --value <unit>

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/systemctl-drills.md`
- `linux/LFCS-training/execution-drills/journalctl-drills.md`
- `linux/LFCS-training/execution-drills/scheduling-cron-at-anacron-drills.md`
- `linux/LFCS-training/execution-drills/shutdown-reboot-drills.md`

---

## 🪝 Exam memory hook

Default service triage:

    systemctl status <unit> --no-pager
    journalctl -u <unit> -n 50 --no-pager
    sudo systemctl restart <unit>
    systemctl is-active <unit>

