# 🧪 LFCS Execution Drills — Phase 12
# 🔐 Security: Sudo, MAC, Contexts, and Privilege Boundaries (SELinux / AppArmor + sysctl)

Path:
  linux/execution-drills/phase-12-security-sudo-mac-contexts.md

Purpose:
  Build reflex-level control over sudo delegation, MAC context diagnosis/fixes, and kernel security knobs.

Mental Mode:
  If something “should work” but doesn’t:
  1) Check DAC (chmod/chown/ACL)
  2) Check Sudo
  3) Check MAC (SELinux/AppArmor)
  4) Check sysctl

---

## 🧱 Lab Safety Rules

⚠️ Always keep one root-capable session open when editing sudoers.
⚠️ Do NOT leave SELinux/AppArmor in permissive or disabled mode.
⚠️ Do NOT practice on production machines.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-12
    cd ~/lfcs-labs/execution-drills/phase-12

Install tools if missing (Debian/Ubuntu; ignore failures if already present):

    sudo apt update
    sudo apt install -y policycoreutils selinux-utils setools setroubleshoot

Note:
- On Ubuntu, AppArmor is usually active.
- On RHEL/Rocky/Alma, SELinux is active.
- Perform SELinux drills if available; otherwise, inspect AppArmor and treat SELinux steps as conceptual.

---

# A) Sudo — Safe Privilege Delegation

## A1 — Always edit with visudo

    sudo visudo

(Do not change anything yet. Just verify it opens and validates.)

---

## A2 — Create test user (if needed)

    sudo useradd -m -s /bin/bash harry || true
    sudo passwd harry

---

## A3 — Grant full sudo (password required)

Open:

    sudo visudo

Add:

    harry ALL=(ALL) ALL

Test (as harry):

    su - harry
    sudo id
    exit

---

## A4 — Grant full sudo (no password)

Edit:

    sudo visudo

Change line to:

    harry ALL=(ALL) NOPASSWD: ALL

Test:

    su - harry
    sudo id
    exit

---

## A5 — Grant group sudo

Create group and add user:

    sudo groupadd students || true
    sudo usermod -aG students harry

Edit:

    sudo visudo

Add:

    %students ALL=(ALL) ALL

Test again as harry:

    su - harry
    sudo -l
    exit

---

## A6 — Restrict to one command

Edit:

    sudo visudo

Add:

    harry ALL=(ALL) /usr/bin/mount

Test:

    su - harry
    sudo -l
    sudo mount || true
    sudo id || true
    exit

Explain:
- Only the listed command should be permitted.

---

# B) MAC — Determine What Is In Use

## B1 — Check SELinux

    getenforce || true
    sestatus || true

## B2 — Check AppArmor

    sudo aa-status || true

Write down:
- Which one is active?
- In what mode?

---

# C) SELinux — Inspect Contexts (If Available)

## C1 — File context

    ls -Z /usr/bin/less || true
    ls -Z /bin/ls || true

## C2 — Process context

    ps auxZ | head || true
    ps auxZ | grep -E 'sshd|systemd' || true

Explain format:

    user:role:type:level

Type is usually what matters most.

---

# D) Simulated Context Problem (Safe)

(If SELinux tools exist.)

## D1 — Create test web content

    sudo mkdir -p /var/www/html/phase12
    echo "PHASE 12 TEST" | sudo tee /var/www/html/phase12/index.html

Check context:

    ls -Z /var/www/html/phase12/index.html || true

---

## D2 — Break context temporarily

    sudo chcon -t bin_t /var/www/html/phase12/index.html || true

Verify:

    ls -Z /var/www/html/phase12/index.html || true

Explain:
- Permissions still look fine
- MAC will block access

---

# E) Correct Fix — restorecon

## E1 — Restore defaults

    sudo restorecon -Rv /var/www/html/phase12 || true

Verify:

    ls -Z /var/www/html/phase12/index.html || true

Explain:
- This is the FIRST thing to try when labels drift.

---

# F) Temporary Fix — chcon (Know Why It’s Bad)

## F1 — Break again

    sudo chcon -t bin_t /var/www/html/phase12/index.html || true

## F2 — Fix temporarily

    sudo chcon -t httpd_sys_content_t /var/www/html/phase12/index.html || true

Explain:
- Works now
- Will be lost after restorecon or relabel

---

# G) Persistent Fix — semanage fcontext

## G1 — Add rule

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html/phase12(/.*)?" || true

## G2 — Apply

    sudo restorecon -Rv /var/www/html/phase12 || true

Verify:

    ls -Z /var/www/html/phase12/index.html || true

List rules:

    sudo semanage fcontext -l | grep phase12 || true

---

# H) Toggle Enforcement (Debug Only)

## H1 — Check mode

    getenforce || true

## H2 — Set permissive

    sudo setenforce 0 || true
    getenforce || true

Explain:
- Policy logs
- Does not block

## H3 — Set enforcing back

    sudo setenforce 1 || true
    getenforce || true

---

# I) Find Denials

## I1 — Search logs

    sudo ausearch -m avc || true
    sudo journalctl -t setroubleshoot || true
    sudo journalctl -g denied || true

---

# J) sysctl — Kernel Security Knobs

## J1 — View all

    sysctl -a | head

---

## J2 — Set temporary value

    sudo sysctl -w vm.swappiness=10
    sysctl vm.swappiness

---

## J3 — Make persistent

Edit:

    sudo vi /etc/sysctl.conf

Add:

    vm.swappiness=10

Apply:

    sudo sysctl -p

Or:

    sudo sysctl --system

Verify:

    sysctl vm.swappiness

---

## J4 — Another example (IPv6 forwarding)

Edit:

    sudo vi /etc/sysctl.conf

Add:

    net.ipv6.conf.all.forwarding = 1

Apply:

    sudo sysctl --system

Check:

    sysctl net.ipv6.conf.all.forwarding

---

# K) Timed Drills

## K1 — Write SELinux mode to file (10 seconds)

    getenforce > ~/lfcs-labs/execution-drills/phase-12/selinux-mode.txt || true

---

## K2 — Restore mislabeled tree (15 seconds)

    sudo restorecon -Rv /var/www || true

---

## K3 — Set and persist sysctl (20 seconds)

    sudo sysctl -w vm.swappiness=30
    sudo sed -i 's/^vm.swappiness.*/vm.swappiness=30/' /etc/sysctl.conf || echo "vm.swappiness=30" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

---

# L) Failure Injection Drills (Mental)

## L1 — chmod didn’t fix it

Checklist:

    getenforce
    ls -Z <file>
    ps auxZ | grep <service>
    journalctl -g denied

Conclusion:
- This is MAC, not DAC.

---

## L2 — Used chcon and it broke again later

Explain:
- chcon is not persistent
- Need semanage fcontext + restorecon

---

## L3 — Edited sudoers with vi and broke sudo

Explain:
- Why visudo exists
- Why syntax validation matters

---

# M) Composition (Exam Style)

## M1 — Sudo + MAC combined

Goal:
- Give user harry passwordless sudo
- Fix mislabeled web tree properly
- Verify enforcing mode is active

Flow:

    sudo visudo
    harry ALL=(ALL) NOPASSWD: ALL

    getenforce
    sudo restorecon -Rv /var/www
    getenforce

---

## M2 — sysctl hardening

Goal:
- Set vm.swappiness=20 temporarily and persistently

Commands:

    sudo sysctl -w vm.swappiness=20
    sudo vi /etc/sysctl.conf
    vm.swappiness=20
    sudo sysctl -p

---

# ✅ Phase 12 Completion Criteria

You are Phase 12-ready when you can:

- Safely grant sudo (user and group, with or without password)
- Restrict sudo to specific commands
- Check whether SELinux/AppArmor is active and in what mode
- Inspect file and process contexts
- Restore labels correctly with restorecon
- Create persistent rules with semanage fcontext
- Use chcon only as a temporary test
- Find MAC denials in logs
- Set sysctl values temporarily and persistently

---

# 🔒 Phase 12 Law

If permissions look right but access is denied, check MAC. Always.

---

# Cleanup (Optional)

    sudo userdel -r harry || true

---
