# 🧪 Users, Groups, Sudo, Environment, and Limits — Execution Drills (LFCS)

Path:
  linux/LFCS-training/execution-drills/users-and-permissions.md

Mental mode: Identity and privilege control.  
Goal: Be able to **create, modify, secure, audit, and recover users, groups, sudo access, environments, and limits** quickly and safely.

This is not a tutorial.  
This is an **execution checklist**.

Always remember:

- Identity mistakes lock users out.
- Sudo mistakes lock **you** out.
- Limits mistakes break systems under load.

---

## 🧱 Safety Rules

⚠️ Do NOT modify or delete your own active user.  
⚠️ Always keep one root-capable session open when editing sudoers.  
⚠️ Always use `visudo`.

---

## 🧱 Lab Setup (Once)

    mkdir -p ~/lfcs-labs/execution-drills/users
    cd ~/lfcs-labs/execution-drills/users

Create lab groups and users (ignore errors if they exist):

    sudo groupadd students || true
    sudo groupadd developers || true

    sudo useradd -m -s /bin/bash alice || true
    sudo useradd -m -s /bin/bash bob || true

Set passwords:

    sudo passwd alice
    sudo passwd bob

---

## 👤 1) User Inspection

- Show current user
- Show user ID info
- Show logged-in users
- Show last logins
- Inspect passwd and group databases

    whoami
    id
    who
    w
    last
    getent passwd
    getent group

---

## ➕ 2) User Creation

Create user with custom home and shell:

    sudo useradd -m -d /home/school/harry -s /bin/bash harry
    ls -ld /home/school/harry
    getent passwd harry

Create temp user:

    sudo useradd -m tempuser
    getent passwd tempuser

---

## 🧰 3) User Modification

Change shell:

    sudo usermod -s /bin/bash harry

Change home (and move it):

    sudo usermod -d /home/newharry -m harry
    ls -ld /home/newharry

Expire password (force change on next login):

    sudo passwd -e harry

Lock and unlock:

    sudo passwd -l harry
    sudo passwd -u harry

---

## ❌ 4) User Deletion

Delete user and home:

    sudo userdel -r tempuser

---

## 👥 5) Groups

Create and delete group:

    sudo groupadd testgroup
    getent group testgroup
    sudo groupdel testgroup

Primary vs supplementary groups:

Set primary:

    sudo usermod -g students alice

Add supplementary (CRITICAL: use -aG):

    sudo usermod -aG developers,sudo alice

Check:

    groups alice
    id alice

---

## 🏠 6) /etc/skel

Add file to skeleton:

    sudo touch /etc/skel/NEWS

Create user:

    sudo useradd -m skeltest
    ls -l /home/skeltest

Cleanup:

    sudo userdel -r skeltest
    sudo rm -f /etc/skel/NEWS

---

## 🌱 7) Environment Variables

System-wide:

Edit:

    sudo vi /etc/environment

Add:

    LFCS_USERS_PHASE=ACTIVE

Reload or re-login:

    source /etc/environment
    printenv LFCS_USERS_PHASE

Per-user:

    echo 'export MYTESTVAR=hello' >> ~/.bashrc
    source ~/.bashrc
    echo $MYTESTVAR

Capture environment:

    env > env.txt
    ls -l env.txt

---

## 🔐 8) sudo (Privilege Control)

Always use:

    sudo visudo

### 8.1 Passwordless sudo for user

Add:

    harry ALL=(ALL) NOPASSWD: ALL

Test as harry:

    sudo -l

### 8.2 Group sudo

Add:

    %developers ALL=(ALL) ALL

### 8.3 Restrict to one command

Add:

    harry ALL=(ALL) /usr/bin/mount

### 8.4 Run as specific user

Add:

    harry ALL=(sam) ALL

Explain:
- harry can run commands as user sam.

---

## 📏 9) Resource Limits

View current:

    ulimit -a

Edit limits:

    sudo vi /etc/security/limits.conf

Add:

    harry soft nproc 20
    harry hard nproc 30

Log out and log back in as harry, then:

    ulimit -a

---

## 🗃️ 10) Identity Databases

Inspect:

    head /etc/passwd
    head /etc/group
    sudo head /etc/shadow

Find specific user:

    grep '^harry:' /etc/passwd

---

## ⏱️ 11) Timed Drills

### 11.1 Create exact user (30 seconds)

Requirements:
- user: examuser
- home: /home/exam/examuser
- shell: /bin/bash
- group: students

    sudo useradd examuser -d /home/exam/examuser -m -s /bin/bash -g students
    getent passwd examuser

### 11.2 Passwordless sudo (20 seconds)

    sudo visudo

Add:

    examuser ALL=(ALL) NOPASSWD: ALL

Test:

    sudo -l

### 11.3 Force password change (10 seconds)

    sudo passwd -e examuser

---

## 🧨 12) Failure Injection Drills

### 12.1 Forgot -a with -G

Simulate:

    sudo usermod -G developers alice

Check:

    groups alice

Explain:
- It overwrote supplementary groups.

Fix:

    sudo usermod -aG developers,sudo alice

---

### 12.2 Bad shell path

Break:

    sudo usermod -s /bin/notreal harry

Explain:
- User cannot log in.

Fix:

    sudo usermod -s /bin/bash harry

---

### 12.3 Sudoers syntax error (theory)

Explain:
- Why visudo exists
- How it prevents total lockout

---

## 🧩 13) Composition (Exam Style)

### 13.1 Full user provisioning

Goal:
- user: projectadmin
- home: /home/projects/projectadmin
- shell: /bin/bash
- group: developers
- passwordless sudo
- force password change

    sudo useradd projectadmin -d /home/projects/projectadmin -m -s /bin/bash -g developers
    sudo passwd projectadmin
    sudo visudo

Add:

    projectadmin ALL=(ALL) NOPASSWD: ALL

Then:

    sudo passwd -e projectadmin
    getent passwd projectadmin

---

### 13.2 Apply resource limit

Add to /etc/security/limits.conf:

    projectadmin hard nproc 50

Re-login and verify:

    ulimit -a

---

## 🧯 14) Account Recovery (Awareness)

- Boot into rescue/emergency
- Remount root rw
- Fix passwd/shadow/sudoers
- Reboot

    mount -o remount,rw /
    visudo
    reboot

---

## ✅ Completion Criteria

You are done when:

- You can create users with exact homes, shells, and groups
- You never break supplementary groups accidentally
- You can lock/unlock and expire accounts safely
- You can grant and restrict sudo without locking yourself out
- You can explain and apply resource limits
- You can reason about /etc/passwd, /etc/group, /etc/shadow
- You can recover from identity or sudo breakage

---

## 🔒 Law

If you don’t control identity and privilege, you don’t control the system.

---

## 🧹 Cleanup (Optional)

    sudo userdel -r harry
    sudo userdel -r examuser
    sudo userdel -r projectadmin

