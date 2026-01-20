# 🔐 Phase 12 — Security: Sudo, MAC, Contexts, and Privilege Boundaries (SELinux / AppArmor)
*LFCS execution layer: control who can do what, and ensure files and services run with correct security contexts.*

---

## 📌 Purpose

This phase makes you **operational with Linux security controls**:

- Granting and auditing sudo access (safely)
- Understanding Mandatory Access Control (MAC)
- Inspecting and fixing SELinux contexts
- Restoring broken labels
- Recognizing when enforcement blocks services

LFCS focuses on **practical actions**, not theory.

---

## 🧠 Mental Model

Linux security has **layers**:

1) **DAC** — Discretionary Access Control (chmod/chown/ACL)
2) **Sudo** — Controlled privilege escalation
3) **MAC** — Mandatory Access Control (SELinux / AppArmor)

If something “looks permitted” but still fails → **MAC is blocking it**.

---

# 🧑‍⚖️ Part A — Sudo (Privilege Delegation)

## Always edit sudoers safely

    sudo visudo

Never edit `/etc/sudoers` directly.

---

## Give user full sudo (password required)

    username ALL=(ALL) ALL

---

## Give user full sudo (no password)

    username ALL=(ALL) NOPASSWD: ALL

---

## Give group sudo

    %students ALL=(ALL) ALL

---

## Restrict to one command

    trinity ALL=(ALL) /usr/bin/mount

---

## Switch user and test

    su - harry
    sudo id

---

# 🧪 Canonical Exam Scenarios (Sudo)

Give user passwordless sudo:

    sudo visudo
    username ALL=(ALL) NOPASSWD: ALL

Give group sudo:

    sudo visudo
    %salesteam ALL=(ALL) ALL

---

# 🧱 Part B — SELinux Basics

## Check status

    getenforce
    sestatus

Modes:

- Enforcing
- Permissive
- Disabled

---

## List context of file

    ls -Z /usr/bin/less

Format:

    user:role:type:level

Example:

    system_u:object_r:bin_t:s0

---

## List process contexts

    ps auxZ | grep sshd

---

## Restore default context

    sudo restorecon /usr/bin/less

Recursive:

    sudo restorecon -Rv /var/log/

---

## Temporarily change context

    sudo chcon -t httpd_sys_content_t /var/index.html

⚠️ This is **not persistent** across relabels.

---

## Make persistent rule

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"
    sudo restorecon -Rv /var/www/

---

## Set permissive mode (temporary)

    sudo setenforce 0

Back to enforcing:

    sudo setenforce 1

---

# 🧪 Canonical Exam Scenarios (SELinux)

Write SELinux mode to file:

    getenforce > /opt/selinuxmode.txt

Restore broken context:

    sudo restorecon /usr/bin/less

Label web content correctly:

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"
    sudo restorecon -Rv /var/www/

---

# 🧰 Part C — Kernel Security Knobs (sysctl)

## View all

    sysctl -a

---

## Set temporary

    sudo sysctl -w vm.swappiness=10

---

## Make persistent

Edit:

    /etc/sysctl.conf

Add:

    vm.swappiness=10

Apply:

    sudo sysctl -p

Or:

    sudo sysctl --system

---

## Example: Disable kernel module loading

    sudo sysctl -w kernel.modules_disabled=1

---

# 🧪 Canonical Exam Scenarios (sysctl)

Set swappiness:

    sudo sysctl -w vm.swappiness=30
    sudo vi /etc/sysctl.conf
    vm.swappiness=30
    sudo sysctl -p

Enable IPv6 forwarding:

    sudo vi /etc/sysctl.conf
    net.ipv6.conf.all.forwarding = 1
    sudo sysctl --system

---

# ⚠️ Failure Modes

- Editing `/etc/sudoers` without visudo
- Using chcon instead of semanage for permanent fixes
- Forgetting restorecon after defining rule
- Forgetting to persist sysctl settings
- Blaming permissions when SELinux is the blocker

---

# 🏁 Phase 12 Mastery Checklist

You must be able to:

- Safely grant sudo rights (user and group)
- Grant passwordless sudo
- Inspect SELinux mode and contexts
- Restore default contexts
- Apply persistent context rules
- Temporarily and permanently set sysctl values
- Diagnose “it should work but doesn’t” as MAC issues

---

## 🔒 Exam Law

> **If permissions look right but access is denied, check MAC. Always.**

---

