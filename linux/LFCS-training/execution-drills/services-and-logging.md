# 🧪 Services and Logging — Execution Drills (LFCS)

Mental mode: Process control and observability.  
Goal: Be able to **inspect, control, debug, persist, and audit services and logs** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

Separation of concerns:
- This file = **systemd control plane + journald + scheduling + recovery**
- service-configuration.md = **configure specific network services (SSH/DNS/HTTP/etc.)**

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/services-and-logging
    cd ~/lfcs-labs/execution-drills/services-and-logging

Install a safe service or two to practice with:

    sudo apt-get update
    sudo apt-get install -y nginx apache2

Optional convenience variable (pick one you actually have):

    export LFCS_SVC=nginx

---

## 🧾 Proof Capture Rule (Exam Habit)

When you need **mechanical proof** (or the prompt asks you to “save output”):

- Capture with `>` and verify the file is non-empty
- Prefer `--no-pager` for `systemctl` output
- When capturing mixed output, include stderr

Patterns:

    systemctl status "$LFCS_SVC" --no-pager > status.txt 2>&1
    test -s status.txt && tail -n 30 status.txt

    journalctl -u "$LFCS_SVC" -n 50 --no-pager > svc.log
    test -s svc.log && tail -n 20 svc.log

---

## ⚙️ 1) Service Inspection

- List running services
- List all service units
- Check status of a service
- Show service dependencies
- Inspect unit contents

    systemctl list-units --type=service
    systemctl list-unit-files --type=service
    systemctl status ssh --no-pager
    systemctl list-dependencies ssh
    systemctl cat ssh

Proof-capture reps (Phase-5 style):

    systemctl list-unit-files > unit-files.txt
    systemctl list-units > running-units.txt
    wc -l unit-files.txt
    wc -l running-units.txt

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

Core law:
- start/stop affects *now*
- enable/disable affects *next boot*

---

## 🔒 3) Masking and Unmasking

- Mask service (hard block)
- Try to start masked service (must fail)
- Unmask service

    sudo systemctl mask telnet || true
    sudo systemctl start telnet || true
    sudo systemctl unmask telnet || true

Mask law:
- disable can still allow manual start
- mask prevents start entirely

---

## 🧠 4) Boot Targets (runlevels)

- Show default target
- List targets
- Set default target
- Switch target temporarily

    systemctl get-default
    systemctl list-units --type=target
    systemctl list-unit-files --type=target
    sudo systemctl set-default multi-user.target
    sudo systemctl isolate multi-user.target

Target law:
- set-default affects next boot
- isolate changes current session

Proof-capture rep (Phase-5 style):

    systemctl get-default > boot-target.txt
    cat boot-target.txt

---

## 🧩 5) Socket Activation (Recognition Drill)

- Recognize socket-activated services
- Understand: socket may accept connections even if service is “disabled”

    systemctl status ssh --no-pager || true
    systemctl status ssh.socket --no-pager || true
    systemctl is-enabled ssh || true
    systemctl is-enabled ssh.socket || true

Proof-capture rep (Phase-5 style):

    systemctl status ssh --no-pager > ssh-units.txt 2>&1
    systemctl status ssh.socket --no-pager >> ssh-units.txt 2>&1
    test -s ssh-units.txt && tail -n 40 ssh-units.txt

---

## 📜 6) Logs with journalctl (Core)

- Show all logs
- Show logs for a specific unit
- Follow logs
- Logs since boot
- Filter by priority
- Time-range query
- Search within journal

    journalctl
    journalctl -u ssh
    journalctl -u ssh -n 50 --no-pager
    journalctl -u ssh -f
    journalctl -b
    journalctl -p err
    journalctl --since "1 hour ago"
    journalctl -g "failed"

Proof-capture rep (Phase-5 style):

    journalctl -u ssh -n 20 --no-pager > ssh.log
    test -s ssh.log && wc -l ssh.log

---

## 🗂️ 7) Traditional Log Files (Recognition Drill)

- Inspect /var/log
- Follow syslog/messages (distro dependent)

    ls -lh /var/log
    tail -n 50 /var/log/syslog 2>/dev/null || tail -n 50 /var/log/messages 2>/dev/null || true
    tail -f /var/log/syslog 2>/dev/null || tail -f /var/log/messages 2>/dev/null || true

---

## 🔍 8) Process Inspection (Observability)

- Show processes
- Show tree
- Find process by name
- Show open files
- Show listening ports

    ps aux
    pstree
    pgrep ssh || true
    lsof -p 1
    ss -lntup

---

## 🛑 9) Process Control (Damage Control)

- Kill by PID
- Kill by name
- SIGTERM vs SIGKILL

    kill 1234
    pkill ssh || true
    kill -15 1234
    kill -9 1234

---

## ⏱️ 10) Scheduling Jobs (cron)

- View user crontab
- Edit user crontab
- List system cron surfaces
- Create test cron job

    crontab -l
    crontab -e
    ls /etc/cron.*
    echo "* * * * * echo test >> /tmp/cron-test" | crontab -

---

## 🕰️ 11) One-time jobs (at)

- Schedule one-time job
- List jobs
- Remove job

    echo "touch /tmp/at-test" | at now + 1 minute
    atq
    atrm 1

---

## 🔄 12) Timers (systemd)

- List timers
- Inspect a timer
- Show next runs

    systemctl list-timers
    systemctl cat logrotate.timer
    systemctl list-timers --all

---

## 📦 13) Log Rotation

- Inspect logrotate config
- Force logrotate run
- Debug logrotate

    ls /etc/logrotate.d
    sudo logrotate -f /etc/logrotate.conf
    sudo logrotate -d /etc/logrotate.conf

---

## 🧯 14) Boot and Failure Debugging

- Show failed units
- Boot time breakdown
- Inspect critical chain

    systemctl --failed
    systemd-analyze
    systemd-analyze blame
    systemd-analyze critical-chain

---

## 🧪 15) Create and Manage a Custom Service (High-signal)

Create a script:

    sudo mkdir -p /usr/local/bin
    sudo cat > /usr/local/bin/lfcs-test-service.sh <<'EOS'
    #!/bin/bash
    echo "LFCS test service ran at $(date)" >> /tmp/lfcs-test-service.log
    exit 0
EOS
    sudo chmod +x /usr/local/bin/lfcs-test-service.sh

Create unit file:

    sudo cat > /etc/systemd/system/lfcs-test.service <<'EOS'
    [Unit]
    Description=LFCS Test Service
    After=network.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/bin/lfcs-test-service.sh

    [Install]
    WantedBy=multi-user.target
EOS

Reload + run:

    sudo systemctl daemon-reload
    sudo systemctl start lfcs-test
    systemctl status lfcs-test --no-pager
    cat /tmp/lfcs-test-service.log

Enable:

    sudo systemctl enable lfcs-test
    systemctl is-enabled lfcs-test

Disable + remove (cleanup):

    sudo systemctl disable lfcs-test || true
    sudo rm -f /etc/systemd/system/lfcs-test.service
    sudo systemctl daemon-reload
    rm -f /tmp/lfcs-test-service.log

---

## 🧯 16) Emergency Recovery (Recognition)

- Boot into rescue/emergency (recognize what it does)
- Remount root rw
- Disable broken service
- Reboot

    mount -o remount,rw /
    systemctl disable broken.service
    reboot

---

## 🧰 17) GRUB (Safe Drills)

- Inspect GRUB defaults
- Regenerate config (safe)
- Capture output (safe)
- Recognition only for grub-install; do not overwrite real disks

Inspect:

    sudo grep ^GRUB_TIMEOUT /etc/default/grub || true
    sudo grep ^GRUB_CMDLINE_LINUX /etc/default/grub || true

Regenerate config:

    sudo update-grub

Proof-capture rep (Phase-5 style):

    sudo update-grub > grub.txt 2>&1
    test -s grub.txt && tail -n 40 grub.txt

Recognition (do not run destructive install):

    sudo grub-install --version 2>/dev/null || true

---

## ⏱️ 18) Timed Drills (Speed)

### T1 — Enable and start service in 20 seconds

    sudo systemctl enable --now nginx
    systemctl status nginx --no-pager

### T2 — Find why service failed in 30 seconds

Break something (lab-safe example):

    sudo systemctl stop nginx
    sudo chmod 000 /var/www/html
    sudo systemctl start nginx || true

Diagnose:

    systemctl status nginx --no-pager
    journalctl -u nginx -n 20 --no-pager

Fix:

    sudo chmod 755 /var/www/html
    sudo systemctl start nginx
    systemctl status nginx --no-pager

### T3 — Default target to file in 15 seconds

    systemctl get-default > ~/lfcs-labs/execution-drills/services-and-logging/boot-target.txt
    cat ~/lfcs-labs/execution-drills/services-and-logging/boot-target.txt

---

## 🧨 19) Failure Injection Drills (Common Mistakes)

### F1 — Start vs enable confusion

    sudo systemctl stop apache2
    sudo systemctl disable apache2
    sudo systemctl start apache2

Explain:
- it starts now, but will not start on reboot

### F2 — Forgot daemon-reload

Edit unit file (add a comment), then:

    sudo systemctl restart lfcs-test

Fix:

    sudo systemctl daemon-reload
    sudo systemctl restart lfcs-test

### F3 — Mask vs disable mistake

    sudo systemctl mask nginx
    sudo systemctl start nginx || true

Fix:

    sudo systemctl unmask nginx
    sudo systemctl start nginx

---
