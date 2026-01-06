# 🧩 Services and Daemons (systemd, LFCS)

Mental mode: **Control long-running system behavior**

This document covers how to **inspect, control, verify, and troubleshoot services (daemons)** using `systemd`.  
These skills are **core LFCS exam material** and represent real-world operational work.

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

A **service (daemon)** is a **long-running background process** started and supervised by `systemd`.

Examples:
- `cron`
- `sshd`
- `docker`
- `containerd`
- `kubelet`

---

## 📋 Listing Running Services

```bash
systemctl list-units --type=service --state=running
```

This shows **currently active services**.

---

## 🔍 Inspecting a Service

```bash
systemctl status cron
```

Better for scripts / no pager:

```bash
systemctl status cron --no-pager
```

This shows:
- whether it’s running
- main PID
- recent log lines
- unit file path

---

## ▶️ Starting / Stopping / Restarting

```bash
sudo systemctl start cron
sudo systemctl stop cron
sudo systemctl restart cron
```

---

## 🔁 Enable / Disable at Boot

```bash
sudo systemctl enable cron
sudo systemctl disable cron
```

Enable = start automatically at boot  
Disable = do not start at boot

---

## 🧪 Verifying a Service Is Actually Running

### Method 1: systemctl

```bash
systemctl is-active cron
```

### Method 2: Get Main PID

```bash
systemctl show -p MainPID --value cron
```

Then:

```bash
ps -p $(systemctl show -p MainPID --value cron)
```

You did **exactly this** during your lab.

---

## 🧾 Logs with journalctl

### Show recent logs for a service:

```bash
journalctl -u cron
```

### Last 20 lines:

```bash
journalctl -u cron -n 20
```

### Show only errors:

```bash
journalctl -p err
```

### No pager:

```bash
journalctl -u cron --no-pager
```

---

## 🔐 Permissions Note

If you see:

> You are currently not seeing messages from other users...

You need either:
- `sudo`
- or membership in `adm` or `systemd-journal`

So:

```bash
sudo journalctl -u cron
```

---

## 🧯 Restart Recovery Drill (You Did This)

1. Stop the service:
```bash
sudo systemctl stop cron
```

2. Verify it’s gone:
```bash
systemctl is-active cron
```

3. Start it again:
```bash
sudo systemctl start cron
```

4. Verify PID:
```bash
ps -p $(systemctl show -p MainPID --value cron)
```

---

## 📁 Where Service Files Live

Usually:

```bash
/usr/lib/systemd/system/
```

Override configs:

```bash
/etc/systemd/system/
```

---

## 🧠 Relationship to Processes

- systemd **starts** the process
- systemd **monitors** the process
- systemd **restarts** it if configured
- systemd **tracks** the PID

---

## 🧪 If a Service Fails

```bash
systemctl status servicename
journalctl -u servicename
```

These two commands solve **80% of service problems**.

---

## 🧭 LFCS What You Must Be Able To Do

- List running services
- Check service status
- Start/stop/restart services
- Enable/disable at boot
- Verify PID is running
- Inspect logs with journalctl
- Recognize failed services

---

## 🏁 Mental Model

> **systemctl controls the service**  
> **journalctl explains the service**

---

## 🔁 Exam Workflow

1. Check status:
```bash
systemctl status name
```

2. Check logs:
```bash
journalctl -u name
```

3. Restart:
```bash
sudo systemctl restart name
```

4. Verify:
```bash
ps -p $(systemctl show -p MainPID --value name)
```

---

## 🧠 Remember

A service is just a **process with a supervisor**.

systemd is that supervisor.

---

