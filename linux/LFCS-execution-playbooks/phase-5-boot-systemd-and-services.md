# ⚔️ Phase 5 — Boot, systemd, Targets, and Service Management (Execution Playbook)
*LFCS control-plane layer: if you can’t control boot and services, you don’t control the machine.*

Path:
- linux/LFCS-execution-playbooks/phase-5-boot-systemd-and-services.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- inspect and change boot targets
- start, stop, restart, enable, disable, and mask services
- understand and verify socket activation
- inspect unit dependencies and enablement state
- read service logs with journalctl
- create and manage a simple custom systemd service
- regenerate bootloader config safely
- recover from “service not starting” scenarios

---

## 🧱 Lab Root

All Phase 5 drills run in:

- ~/lfcs-labs/phase-5

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-5
    cd ~/lfcs-labs/phase-5
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 5 when you can complete P5-1 through P5-14:

- in ≤ 75 minutes total
- with zero verification failures
- without confusing start vs enable vs mask
- without breaking boot

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P5-1 — Inspect default boot target

Time limit:
- 3 minutes

Task:
Save the default target to default-target.txt.

Do:

    systemctl get-default > default-target.txt

Verify:

    cat default-target.txt

-------------------------------------------------------------------------------

## P5-2 — Change default target (and revert)

Time limit:
- 5 minutes

Task:
Set default target to multi-user, verify, then set back to graphical (or original).

Do:

    systemctl get-default
    sudo systemctl set-default multi-user.target
    systemctl get-default

Then revert to previous value you recorded.

Verify:

    systemctl get-default

-------------------------------------------------------------------------------

## P5-3 — Start and stop a service

Time limit:
- 4 minutes

Task:
Pick a safe service (e.g., cron or ssh) and:

- start it
- stop it
- check status

Do:

    sudo systemctl start cron
    sudo systemctl status cron
    sudo systemctl stop cron
    sudo systemctl status cron

Verify:
- status output changes appropriately

-------------------------------------------------------------------------------

## P5-4 — Enable and disable a service

Time limit:
- 4 minutes

Task:
Enable cron at boot, verify, then disable it.

Do:

    sudo systemctl enable cron
    systemctl is-enabled cron
    sudo systemctl disable cron
    systemctl is-enabled cron

Verify:
- is-enabled shows enabled then disabled

-------------------------------------------------------------------------------

## P5-5 — Enable and start in one step

Time limit:
- 3 minutes

Task:
Enable and start cron in one command.

Do:

    sudo systemctl enable --now cron

Verify:

    systemctl is-enabled cron
    systemctl status cron

-------------------------------------------------------------------------------

## P5-6 — Mask and unmask a service

Time limit:
- 5 minutes

Task:
Mask cron, prove it cannot be started, then unmask it.

Do:

    sudo systemctl mask cron
    sudo systemctl start cron || true
    sudo systemctl unmask cron

Verify:

    systemctl status cron

-------------------------------------------------------------------------------

## P5-7 — Understand socket activation (SSH)

Time limit:
- 6 minutes

Task:
Check ssh.service and ssh.socket states and save to ssh-units.txt.

Do:

    systemctl status ssh > ssh-units.txt 2>&1
    systemctl status ssh.socket >> ssh-units.txt 2>&1

Verify:

    cat ssh-units.txt

-------------------------------------------------------------------------------

## P5-8 — List unit files and running units

Time limit:
- 4 minutes

Task:
Save list of all unit files to unit-files.txt and running units to running-units.txt.

Do:

    systemctl list-unit-files > unit-files.txt
    systemctl list-units > running-units.txt

Verify:

    wc -l unit-files.txt
    wc -l running-units.txt

-------------------------------------------------------------------------------

## P5-9 — Inspect dependencies

Time limit:
- 4 minutes

Task:
Show dependencies of cron and save to cron-deps.txt.

Do:

    systemctl list-dependencies cron > cron-deps.txt

Verify:

    head cron-deps.txt

-------------------------------------------------------------------------------

## P5-10 — Read service logs

Time limit:
- 4 minutes

Task:
Save last 20 log lines of cron to cron.log.

Do:

    journalctl -u cron -n 20 --no-pager > cron.log

Verify:

    test -s cron.log && wc -l cron.log

-------------------------------------------------------------------------------

## P5-11 — Create a simple custom service

Time limit:
- 10 minutes

Setup:

    cd ~/lfcs-labs/phase-5
    rm -rf p5-11 && mkdir p5-11
    cd p5-11
    cat > hello.sh <<EOF
    #!/bin/bash
    echo "hello from systemd" >> /tmp/hello-systemd.log
    EOF
    chmod +x hello.sh

Create service file:

    sudo cat > /etc/systemd/system/hello-test.service <<EOF
    [Unit]
    Description=Hello Test Service

    [Service]
    Type=oneshot
    ExecStart=/home/$USER/lfcs-labs/phase-5/p5-11/hello.sh

    [Install]
    WantedBy=multi-user.target
    EOF

Reload and run:

    sudo systemctl daemon-reload
    sudo systemctl start hello-test

Verify:

    cat /tmp/hello-systemd.log

-------------------------------------------------------------------------------

## P5-12 — Enable custom service at boot

Time limit:
- 4 minutes

Task:
Enable hello-test and verify it is enabled.

Do:

    sudo systemctl enable hello-test
    systemctl is-enabled hello-test

Verify:
- is-enabled prints enabled

-------------------------------------------------------------------------------

## P5-13 — Remove custom service cleanly

Time limit:
- 5 minutes

Task:
Disable and remove hello-test service.

Do:

    sudo systemctl disable hello-test
    sudo rm /etc/systemd/system/hello-test.service
    sudo systemctl daemon-reload

Verify:

    systemctl status hello-test || echo "removed"

-------------------------------------------------------------------------------

## P5-14 — Bootloader config regeneration (safe)

Time limit:
- 5 minutes

Task:
Regenerate grub config and save output to grub.txt.

Do:

    sudo update-grub > grub.txt 2>&1

Verify:

    test -s grub.txt && tail grub.txt

---

## 🏁 Phase 5 Pass Criteria

You can:

- inspect and change default boot targets
- start, stop, enable, disable, and mask services correctly
- understand socket activation vs service state
- list units and unit files
- inspect dependencies
- read service logs
- create, enable, and remove a custom service safely
- regenerate bootloader config without breaking the system

---

## 🔒 Phase 5 Law

If you can’t control boot and services,
you don’t control the machine.

---
