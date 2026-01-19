# ⚙️ Phase 5 — Boot, systemd, Targets, and Service Management
*LFCS control plane: start, stop, enable, diagnose, and recover services and boot state.*

---

## 📌 Purpose

This phase makes you **authoritative** over:

- Boot targets and boot flow
- systemd units and dependencies
- Starting, stopping, enabling, masking services
- Reading service logs
- Recovering from broken services or bad boot configs

Many LFCS tasks are:

> “Why is this service not starting?”  
> “Make it start now and at boot.”  
> “Boot once into a special mode.”

---

## 🧠 Mental Model

- systemd controls **everything**
- A **unit** is a thing systemd manages (service, socket, mount, target, timer…)
- **Targets** are boot modes (multi-user, graphical, rescue, emergency)
- **Enable** = start at boot  
- **Start** = start now  
- These are **different**

---

# 🚦 Part A — Targets (Runlevels, but modern)

Show current default target:

    systemctl get-default

Set default target:

    sudo systemctl set-default multi-user.target
    sudo systemctl set-default graphical.target

List targets:

    systemctl list-units --type=target

Boot once into rescue:

    sudo systemctl rescue

Boot once into emergency:

    sudo systemctl emergency

---

# 🧰 Part B — Service Control

Start / stop / restart:

    sudo systemctl start nginx
    sudo systemctl stop nginx
    sudo systemctl restart nginx

Status:

    systemctl status nginx

Enable at boot:

    sudo systemctl enable nginx

Disable at boot:

    sudo systemctl disable nginx

Enable and start immediately:

    sudo systemctl enable --now nginx

---

# 🛑 Part C — Masking (Hard Disable)

Mask service:

    sudo systemctl mask apache2

Unmask:

    sudo systemctl unmask apache2

Meaning:

- Masked service **cannot be started at all**
- Even manually

---

# 🔌 Part D — Socket Activation (Critical LFCS Concept)

Example: SSH on Ubuntu

Check:

    systemctl status ssh
    systemctl status ssh.socket

Typical state:

- ssh.service → disabled
- ssh.socket → enabled

Meaning:

- systemd listens on port 22
- When connection arrives → starts ssh.service on demand

This is **normal and correct**.

To force classic behavior:

    sudo systemctl enable --now ssh

📌 Exam law:

> On socket-activated services, **the socket controls availability**, not the service unit.

---

# 🧾 Part E — List and Inspect Units

List running units:

    systemctl list-units

List all unit files:

    systemctl list-unit-files

Check if enabled:

    systemctl is-enabled nginx

Check dependencies:

    systemctl list-dependencies nginx

---

# 📜 Part F — Logs (journalctl)

Show all logs:

    journalctl

Show logs for service:

    journalctl -u ssh

Last 50 lines:

    journalctl -u nginx -n 50

Follow live:

    journalctl -u nginx -f

Filter by priority:

    journalctl -p err

Search:

    journalctl -g "failed"

---

# 🧱 Part G — Custom Services

Service file location:

    /etc/systemd/system/myservice.service

Example:

    [Unit]
    Description=My Service
    After=network.target

    [Service]
    ExecStart=/usr/local/bin/myscript.sh
    Restart=always
    Type=simple

    [Install]
    WantedBy=multi-user.target

Reload unit files:

    sudo systemctl daemon-reload

Enable and start:

    sudo systemctl enable --now myservice

---

# 🧯 Part H — Bootloader (GRUB)

Edit config:

    sudo vi /etc/default/grub

Regenerate:

    sudo update-grub

Install:

    sudo grub-install /dev/vda > /root/grub.txt 2>&1

Temporarily change boot options:

- Press `e` in GRUB menu
- Edit kernel line
- Boot

---

# 🧪 Canonical Exam Scenarios

Check default boot target:

    systemctl get-default > /home/bob/boot-target.txt

Set system to graphical:

    sudo systemctl set-default graphical.target

Mask Apache:

    sudo systemctl mask apache2

Unmask Apache:

    sudo systemctl unmask apache2

Check SSH status:

    systemctl status ssh
    systemctl status ssh.socket

Show last SSH logs:

    journalctl -u ssh -n 20 --no-pager

---

## ⚠️ Failure Modes

- Confusing start vs enable
- Masking when you meant disable
- Breaking boot by editing grub incorrectly
- Thinking ssh is “broken” when it’s socket-activated
- Forgetting daemon-reload after creating unit

---

## 🏁 Phase 5 Mastery Checklist

You must be able to:

- Change default boot target
- Boot into rescue/emergency
- Start/stop/enable/disable/mask services
- Diagnose services using systemctl + journalctl
- Understand socket activation
- Create and manage a simple custom service
- Regenerate GRUB config safely

---

## 🔒 Exam Law

> **If you can’t control boot and services, you don’t control the machine.**

---
