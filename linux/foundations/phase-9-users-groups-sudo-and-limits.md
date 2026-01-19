# 👥 Phase 9 — Users, Groups, Environment, Sudo, and Resource Limits
*LFCS identity plane: who can log in, what they can do, and how much they can consume.*

---

## 📌 Purpose

This phase makes you **authoritative over identity and privilege**:

- Creating, modifying, deleting users and groups
- Controlling login shells and home directories
- Managing environment variables (system-wide and per-user)
- Granting and restricting sudo access
- Enforcing resource limits (nproc, fsize, nofile, etc.)
- Understanding skel for default user setup

Many LFCS tasks are:

> “Create this user exactly like this.”  
> “Give this group sudo without password.”  
> “Limit this user’s processes.”  
> “Fix this account so it can log in.”

---

## 🧠 Mental Model

- User identity lives in:
  - /etc/passwd
  - /etc/shadow
  - /etc/group
- Default files for new users come from:
  - /etc/skel
- Privilege escalation is controlled by:
  - /etc/sudoers (always edit with visudo)
- Resource limits are enforced via:
  - /etc/security/limits.conf
- Environment is layered:
  - /etc/environment (system-wide)
  - /etc/profile, /etc/profile.d/
  - ~/.bashrc, ~/.profile

---

# 👤 Part A — Users

Create user with home and shell:

    sudo useradd -m -s /bin/bash alice

Create with custom home:

    sudo useradd -m -d /home/school/harry harry

Set password:

    sudo passwd alice

Delete user:

    sudo userdel alice
    sudo userdel -r alice

Modify shell:

    sudo usermod -s /usr/bin/zsh alice

Change home and move data:

    sudo usermod -d /home/newalice -m alice

Lock / unlock account:

    sudo passwd -l alice
    sudo passwd -u alice

Force password change at next login:

    sudo passwd -e alice

---

# 👥 Part B — Groups

Create group:

    sudo groupadd developers

Delete group:

    sudo groupdel developers

Change primary group:

    sudo usermod -g developers alice

Add secondary group:

    sudo usermod -aG sudo,developers alice

Show memberships:

    groups alice

---

# 🏠 Part C — Skeleton Directory (/etc/skel)

Anything here appears in **new users’ home directories**.

Example: auto-create NEWS file:

    sudo touch /etc/skel/NEWS

---

# 🌍 Part D — Environment Variables

System-wide:

    sudo vi /etc/environment

Example:

    GLOBALOPTION=ON
    LFCS=Welcome

Per-user:

    vi ~/.bashrc

Example:

    export PATH="$PATH:/home/harry/binaries"

Apply:

    source ~/.bashrc

Inspect:

    env
    printenv
    echo $HOME

Save environment to file:

    env > /home/bob/env

---

# 🛡️ Part E — Sudo

Edit safely:

    sudo visudo

Grant user full sudo without password:

    alice ALL=(ALL) NOPASSWD: ALL

Grant group sudo:

    %developers ALL=(ALL) ALL

Restrict to command:

    alice ALL=(ALL) /usr/bin/mount

Allow running as another user:

    alice ALL=(sam) ALL

Check:

    sudo -l

---

# ⛓️ Part F — Resource Limits

Show current:

    ulimit -a

Config file:

    sudo vi /etc/security/limits.conf

Examples:

    alice hard nproc 30
    @salesteam soft nproc 20
    stephen hard fsize 4096
    @mail soft fsize 8192

Meaning:

- soft = warning limit
- hard = absolute ceiling

---

# 🧾 Part G — Important Identity Files

View:

    cat /etc/passwd
    cat /etc/group
    sudo cat /etc/shadow

Find user entry:

    grep '^alice:' /etc/passwd

---

# 🧪 Canonical Exam Scenarios

Create user, set shell, set home:

    sudo useradd harry -d /home/school/harry -m -G students
    sudo passwd harry
    sudo usermod -s /bin/bash harry

Give passwordless sudo:

    sudo visudo
    harry ALL=(ALL) NOPASSWD: ALL

Create group and assign directory:

    sudo groupadd computestream
    sudo mkdir -p /exam/computestream
    sudo chgrp -R computestream /exam/computestream

Force password change:

    sudo passwd -e projectadmin

Fix broken shell:

    sudo usermod devel -s /usr/bin/bash

---

## ⚠️ Failure Modes

- Forgetting -a when adding to supplementary groups
- Locking yourself out via sudoers syntax error (always use visudo)
- Setting shell to non-existent path
- Forgetting to create home directory
- Overwriting PATH instead of appending

---

## 🏁 Phase 9 Mastery Checklist

You must be able to:

- Create, modify, delete users and groups
- Set shells, homes, passwords
- Use /etc/skel for defaults
- Grant and restrict sudo safely
- Configure resource limits
- Inspect environment variables
- Lock/unlock accounts
- Force password rotation

---

## 🔒 Exam Law

> **If you don’t control identity and privilege, you don’t control the system.**

---

