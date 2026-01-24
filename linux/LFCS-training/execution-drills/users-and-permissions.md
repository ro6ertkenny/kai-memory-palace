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
⚠️ Always use `visudo` (or `visudo -f` for files under `/etc/sudoers.d/`).  
⚠️ Prefer `/etc/sudoers.d/` and `/etc/security/limits.d/` over editing monolithic files.

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

NSS lookup (preferred over grepping files):

    getent passwd
    getent group
    getent passwd alice
    getent group developers

Account state (fast signal):

    sudo passwd -S alice
    sudo chage -l alice | sed -n '1,120p'

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
    sudo chage -l harry | sed -n '1,120p'

Lock and unlock:

    sudo passwd -l harry
    sudo passwd -S harry
    sudo passwd -u harry
    sudo passwd -S harry

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

    echo "Welcome to the lab" | sudo tee /etc/skel/WELCOME.txt > /dev/null

Create user:

    sudo useradd -m -s /bin/bash skeltest
    sudo passwd skeltest

Verify:

    ls -l /home/skeltest/WELCOME.txt

Cleanup:

    sudo userdel -r skeltest
    sudo rm -f /etc/skel/WELCOME.txt

---

## 🌱 7) Environment Variables

### 7.1 System-wide (/etc/environment)

Edit:

    sudo vi /etc/environment

Add:

    LFCS_USERS_PHASE=ACTIVE

Proof (capture inside a login shell):

    su - alice -c 'echo "LFCS_USERS_PHASE=$LFCS_USERS_PHASE" > ~/lfcs-users-phase-proof.txt'
    sudo cat /home/alice/lfcs-users-phase-proof.txt

### 7.2 Per-user (~/.bashrc)

    echo 'export MYTESTVAR=hello' >> ~/.bashrc
    . ~/.bashrc
    echo "$MYTESTVAR"

Capture environment:

    env > env.txt
    ls -l env.txt

---

## 🔐 8) sudo (Privilege Control)

### Preferred workflow: /etc/sudoers.d + visudo -f

Create a dedicated sudoers drop-in:

    sudo visudo -f /etc/sudoers.d/harry

Add:

    harry ALL=(ALL) NOPASSWD: ALL

Validate (never skip):

    sudo visudo -cf /etc/sudoers
    sudo visudo -cf /etc/sudoers.d/harry

Test as harry:

    su - harry
    sudo -l
    exit

### 8.2 Group sudo

    sudo visudo -f /etc/sudoers.d/developers

Add:

    %developers ALL=(ALL) ALL

### 8.3 Restrict to one command

    sudo visudo -f /etc/sudoers.d/harry-restrict

Add:

    harry ALL=(ALL) /usr/bin/mount

---

## 📏 9) Resource Limits

View current:

    ulimit -a

Preferred workflow: a dedicated limits file:

    sudo vi /etc/security/limits.d/harry.conf

Add:

    harry soft nproc 20
    harry hard nproc 30

Re-login and verify:

    su - harry -c 'ulimit -a > ~/harry-ulimit.txt'
    sudo cat /home/newharry/harry-ulimit.txt 2>/dev/null || sudo cat /home/harry/harry-ulimit.txt

---

## 🗃️ 10) Identity Databases (Recognition)

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

    sudo visudo -f /etc/sudoers.d/examuser

Add:

    examuser ALL=(ALL) NOPASSWD: ALL

Validate + test:

    sudo visudo -cf /etc/sudoers
    su - examuser
    sudo -l
    exit

### 11.3 Force password change (10 seconds)

    sudo passwd -e examuser

---

## 🧨 12) Failure Injection Drills

### 12.1 Forgot -a with -G (group wipe)

Simulate:

    sudo usermod -G developers alice

Check:

    groups alice

Explain:
- It overwrote supplementary groups.

Fix:

    sudo usermod -aG developers,sudo alice

---

### 12.2 Bad shell path (login breaks)

Break:

    sudo usermod -s /bin/notreal harry

Fix:

    sudo usermod -s /bin/bash harry

---

### 12.3 Sudoers syntax error (practice workflow)

Do NOT break your real sudoers.

Practice the recovery method:

    sudo visudo -cf /etc/sudoers

Explain:
- visudo prevents total lockout by validating syntax before install/save.

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

    sudo visudo -f /etc/sudoers.d/projectadmin
    projectadmin ALL=(ALL) NOPASSWD: ALL

    sudo passwd -e projectadmin
    getent passwd projectadmin

### 13.2 Apply resource limit

    sudo vi /etc/security/limits.d/projectadmin.conf

Add:

    projectadmin hard nproc 50

Re-login and verify:

    su - projectadmin -c 'ulimit -a | grep -i nproc || true'

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
- You can explain and apply resource limits (and verify after re-login)
- You can reason about /etc/passwd, /etc/group, /etc/shadow
- You can recover from identity or sudo breakage

---

## 🔒 Law

If you don’t control identity and privilege, you don’t control the system.

---

## 🧹 Cleanup (Optional)

    sudo userdel -r harry 2>/dev/null || true
    sudo userdel -r examuser 2>/dev/null || true
    sudo userdel -r projectadmin 2>/dev/null || true

