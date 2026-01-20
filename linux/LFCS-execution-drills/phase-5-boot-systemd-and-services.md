# 🧪 LFCS Execution Drills — Phase 5
# ⚙️ Boot, systemd, Targets, and Service Management

Path:
  linux/execution-drills/phase-5-boot-systemd-and-services.md

Purpose:
  Build reflex-level control over boot targets, services, socket activation, logs, and recovery actions.

Mental Mode:
  systemd is the control plane. If you control it, you control the machine.

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-5
    cd ~/lfcs-labs/execution-drills/phase-5

Install a couple of safe services to practice with:

    sudo apt update
    sudo apt install -y nginx apache2

---

# A) Targets (Boot Modes)

## A1 — Inspect current default target

    systemctl get-default

List all targets:

    systemctl list-units --type=target

---

## A2 — Change default target (and revert)

Set to multi-user:

    sudo systemctl set-default multi-user.target
    systemctl get-default

Set back (if system has GUI):

    sudo systemctl set-default graphical.target
    systemctl get-default

Explain difference:
- default target = next boot
- does not change current session

---

## A3 — One-time rescue / emergency (DO NOT REBOOT NOW)

Dry run understanding:

    systemctl rescue
    systemctl emergency

Explain:
- rescue = minimal, single-user, with mounts
- emergency = even more minimal, almost nothing mounted

(Do not actually reboot unless you intend to.)

---

# B) Service Control (Start vs Enable)

## B1 — Start/stop/restart/status

    sudo systemctl start nginx
    systemctl status nginx
    sudo systemctl stop nginx
    sudo systemctl restart nginx
    systemctl status nginx

---

## B2 — Enable vs start

Stop and disable:

    sudo systemctl stop nginx
    sudo systemctl disable nginx

Check:

    systemctl is-enabled nginx

Start without enabling:

    sudo systemctl start nginx
    systemctl is-enabled nginx

Reboot would not start it.

---

## B3 — Enable and start at once

    sudo systemctl enable --now nginx
    systemctl is-enabled nginx
    systemctl status nginx

---

# C) Masking (Hard Disable)

## C1 — Mask a service

    sudo systemctl mask apache2
    sudo systemctl start apache2

Observe:
- It must fail.

Check:

    systemctl status apache2

---

## C2 — Unmask and restore

    sudo systemctl unmask apache2
    sudo systemctl start apache2
    systemctl status apache2

---

# D) Socket Activation (Critical Concept)

## D1 — Inspect SSH

    systemctl status ssh
    systemctl status ssh.socket

Explain:
- socket may be enabled
- service may be disabled
- system still accepts connections

---

## D2 — Force classic behavior

    sudo systemctl enable --now ssh
    systemctl is-enabled ssh
    systemctl status ssh

Explain difference between:
- socket-controlled
- service-controlled

---

# E) Listing & Inspecting Units

## E1 — List running units

    systemctl list-units

---

## E2 — List unit files

    systemctl list-unit-files | head

---

## E3 — Dependencies

    systemctl list-dependencies nginx

---

# F) Logs with journalctl

## F1 — All logs (paged)

    journalctl

---

## F2 — Service logs

    journalctl -u nginx

Last 20 lines, no pager:

    journalctl -u nginx -n 20 --no-pager

Follow live:

    journalctl -u nginx -f

---

## F3 — Priority and search

    journalctl -p err
    journalctl -g "failed"

---

# G) Custom Service

## G1 — Create simple script

    cat > /usr/local/bin/phase5-test.sh <<EOF
    #!/bin/bash
    echo "Phase 5 test service running at $(date)" >> /tmp/phase5-test.log
    sleep 5
    EOF

    sudo chmod +x /usr/local/bin/phase5-test.sh

---

## G2 — Create unit file

    sudo cat > /etc/systemd/system/phase5-test.service <<EOF
    [Unit]
    Description=Phase 5 Test Service
    After=network.target

    [Service]
    ExecStart=/usr/local/bin/phase5-test.sh
    Type=simple

    [Install]
    WantedBy=multi-user.target
    EOF

---

## G3 — Reload and run

    sudo systemctl daemon-reload
    sudo systemctl start phase5-test
    sudo systemctl status phase5-test
    cat /tmp/phase5-test.log

---

## G4 — Enable at boot

    sudo systemctl enable phase5-test
    systemctl is-enabled phase5-test

---

# H) Bootloader (GRUB) — Safe Drills

## H1 — Inspect config

    sudo grep ^GRUB_TIMEOUT /etc/default/grub
    sudo grep ^GRUB_CMDLINE_LINUX /etc/default/grub

---

## H2 — Regenerate config (no changes)

    sudo update-grub

---

## H3 — Install and capture output (DO NOT CHANGE DISK)

(Simulate by capturing output; do not actually overwrite disks)

    sudo grub-install /dev/vda > ~/lfcs-labs/execution-drills/phase-5/grub.txt 2>&1

Review:

    less ~/lfcs-labs/execution-drills/phase-5/grub.txt

---

# I) Timed Drills

## I1 — Enable and start in 20 seconds

    sudo systemctl enable --now nginx
    systemctl status nginx

---

## I2 — Find why service failed in 30 seconds

Break it:

    sudo systemctl stop nginx
    sudo chmod 000 /var/www/html

Start:

    sudo systemctl start nginx

Diagnose:

    systemctl status nginx
    journalctl -u nginx -n 20 --no-pager

Fix:

    sudo chmod 755 /var/www/html
    sudo systemctl start nginx

---

## I3 — Check boot target and write to file (15 seconds)

    systemctl get-default > ~/lfcs-labs/execution-drills/phase-5/boot-target.txt
    cat ~/lfcs-labs/execution-drills/phase-5/boot-target.txt

---

# J) Failure Injection Drills

## J1 — start vs enable confusion

    sudo systemctl stop apache2
    sudo systemctl disable apache2
    sudo systemctl start apache2

Reboot would not start it. Explain why.

---

## J2 — Forgot daemon-reload

Edit unit file (add a comment), then:

    sudo systemctl restart phase5-test

Observe:
- change not picked up

Fix:

    sudo systemctl daemon-reload
    sudo systemctl restart phase5-test

---

## J3 — Mask vs disable mistake

    sudo systemctl mask nginx
    sudo systemctl start nginx

Explain why disable would not have blocked manual start.

Fix:

    sudo systemctl unmask nginx
    sudo systemctl start nginx

---

# K) Composition (Exam Style)

## K1 — Diagnose and fix service

    systemctl status nginx
    journalctl -u nginx -n 50 --no-pager
    sudo systemctl enable --now nginx

---

## K2 — Socket confusion check

    systemctl status ssh
    systemctl status ssh.socket

Explain which one controls availability.

---

## K3 — Create service, enable, verify log

    sudo systemctl start phase5-test
    sudo systemctl enable phase5-test
    cat /tmp/phase5-test.log

---

# ✅ Phase 5 Completion Criteria

You are Phase 5-ready when you can:

- Change and inspect boot targets
- Explain and use start vs enable vs mask
- Diagnose services using systemctl + journalctl
- Understand and explain socket activation
- Create, reload, enable, and manage a custom unit
- Safely regenerate GRUB config
- Recover from broken services quickly

---

# 🔒 Phase 5 Law

If you can’t control boot and services, you don’t control the machine.

---
