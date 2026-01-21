# 🧪 Services and Logging — Execution Drills (LFCS)

Mental mode: Process control and observability.  
Goal: Be able to **inspect, control, debug, persist, and audit services and logs** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

---

## ⚙️ 1) Service Inspection

- List running services
- List all service units
- Check status of a service
- Show service dependencies

    systemctl list-units --type=service
    systemctl list-unit-files --type=service
    systemctl status ssh
    systemctl list-dependencies ssh

---

## ▶️ 2) Start, Stop, Enable, Disable

- Start service
- Stop service
- Restart service
- Reload service
- Enable at boot
- Disable at boot

    sudo systemctl start ssh
    sudo systemctl stop ssh
    sudo systemctl restart ssh
    sudo systemctl reload ssh || true
    sudo systemctl enable ssh
    sudo systemctl disable ssh

---

## 🔁 3) Masking and Unmasking

- Mask service
- Try to start masked service
- Unmask service

    sudo systemctl mask telnet
    sudo systemctl start telnet || true
    sudo systemctl unmask telnet

---

## 🧠 4) Boot Targets

- Show default target
- List targets
- Set default target
- Switch target temporarily

    systemctl get-default
    systemctl list-unit-files --type=target
    sudo systemctl set-default multi-user.target
    sudo systemctl isolate multi-user.target

---

## 📜 5) Logs with journalctl

- Show all logs
- Show logs for specific service
- Follow logs
- Show logs since boot
- Show logs by priority
- Show logs in time range

    journalctl
    journalctl -u ssh
    journalctl -f
    journalctl -b
    journalctl -p err
    journalctl --since "1 hour ago"

---

## 🗂️ 6) Traditional Log Files

- List log directory
- Inspect syslog/auth logs
- Follow log file

    ls -lh /var/log
    tail -n 50 /var/log/syslog || tail -n 50 /var/log/messages
    tail -f /var/log/syslog || tail -f /var/log/messages

---

## 🔍 7) Process Inspection

- Show processes
- Show tree
- Find process by name
- Show open files
- Show listening ports

    ps aux
    pstree
    pgrep ssh
    lsof -p 1
    ss -lntup

---

## 🛑 8) Process Control

- Kill by PID
- Kill by name
- Send SIGTERM
- Send SIGKILL

    kill 1234
    pkill ssh
    kill -15 1234
    kill -9 1234

---

## ⏱️ 9) Scheduling Jobs

- View crontab
- Edit crontab
- List system cron
- Create test cron job

    crontab -l
    crontab -e
    ls /etc/cron.*
    echo "* * * * * echo test >> /tmp/cron-test" | crontab -

---

## 🕰️ 10) at and batch

- Schedule one-time job
- List jobs
- Remove job

    echo "touch /tmp/at-test" | at now + 1 minute
    atq
    atrm 1

---

## 🔄 11) Timers (systemd)

- List timers
- Inspect timer
- Show next runs

    systemctl list-timers
    systemctl cat logrotate.timer
    systemctl list-timers --all

---

## 📦 12) Log Rotation

- Inspect logrotate config
- Force logrotate run
- Debug logrotate

    ls /etc/logrotate.d
    sudo logrotate -f /etc/logrotate.conf
    sudo logrotate -d /etc/logrotate.conf

---

## 🧯 13) Boot and Failure Debugging

- Show failed units
- Show boot time breakdown
- Inspect critical chain

    systemctl --failed
    systemd-analyze
    systemd-analyze blame
    systemd-analyze critical-chain

---

## 🧪 14) Create and Manage a Custom Service

- Create simple service file
- Reload daemon
- Start service
- Enable service
- Inspect logs

    sudo nano /etc/systemd/system/test.service
    systemctl daemon-reload
    sudo systemctl start test
    sudo systemctl enable test
    journalctl -u test

---

## 🧯 15) Emergency Recovery

- Boot into rescue/emergency
- Remount root rw
- Disable broken service
- Reboot

    mount -o remount,rw /
    systemctl disable broken.service
    reboot

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can debug service failures in minutes
- You can prove where something is stuck: unit, process, dependency, or config
- You can navigate logs **instinctively**

---
