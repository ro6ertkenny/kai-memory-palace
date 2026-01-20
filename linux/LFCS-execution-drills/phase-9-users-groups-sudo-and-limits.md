# 🧪 LFCS Execution Drills — Phase 9
# 👥 Users, Groups, Environment, Sudo, and Resource Limits

Path:
  linux/execution-drills/phase-9-users-groups-sudo-and-limits.md

Purpose:
  Build reflex-level authority over identity, privilege, environment, and resource control.

Mental Mode:
  Identity mistakes lock people out. Sudo mistakes lock YOU out. Limits mistakes break production.

---

## 🧱 Lab Safety Rules

⚠️ Do NOT modify or delete your own user.
⚠️ Always keep one root-capable session open when editing sudoers.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-9
    cd ~/lfcs-labs/execution-drills/phase-9

Create test groups and users (if not already present):

    sudo groupadd students || true
    sudo groupadd developers || true

    sudo useradd -m -s /bin/bash alice || true
    sudo useradd -m -s /bin/bash bob || true

Set passwords:

    sudo passwd alice
    sudo passwd bob

---

# A) Users

## A1 — Create user with custom home and shell

    sudo useradd -m -d /home/school/harry -s /bin/bash harry
    ls -ld /home/school/harry
    getent passwd harry

---

## A2 — Modify shell and home

    sudo usermod -s /usr/bin/bash harry
    sudo usermod -d /home/newharry -m harry
    getent passwd harry
    ls -ld /home/newharry

---

## A3 — Lock and unlock

    sudo passwd -l harry
    sudo passwd -u harry

---

## A4 — Force password change

    sudo passwd -e harry

---

## A5 — Delete user (practice only)

    sudo useradd -m tempuser
    sudo userdel -r tempuser

---

# B) Groups

## B1 — Create and delete group

    sudo groupadd testgroup
    getent group testgroup
    sudo groupdel testgroup

---

## B2 — Primary vs supplementary groups

Set primary:

    sudo usermod -g students alice

Add supplementary (IMPORTANT: use -aG):

    sudo usermod -aG developers,sudo alice

Check:

    groups alice

---

# C) /etc/skel

## C1 — Skeleton propagation test

    sudo touch /etc/skel/NEWS

Create new user:

    sudo useradd -m skeltest
    ls -l /home/skeltest

Remove:

    sudo userdel -r skeltest

---

# D) Environment Variables

## D1 — System-wide variable

Edit:

    sudo vi /etc/environment

Add:

    LFCS_PHASE9=ACTIVE

Log out/in or:

    source /etc/environment
    printenv LFCS_PHASE9

---

## D2 — Per-user variable

As your user:

    echo 'export MYTESTVAR=hello' >> ~/.bashrc
    source ~/.bashrc
    echo $MYTESTVAR

---

## D3 — Save environment to file

    env > env.txt
    ls -l env.txt

---

# E) Sudo

## E1 — Always use visudo

    sudo visudo

---

## E2 — Give user passwordless sudo

Add:

    harry ALL=(ALL) NOPASSWD: ALL

Test (as harry):

    sudo -l

---

## E3 — Group sudo

Add:

    %developers ALL=(ALL) ALL

Test:

    sudo -l

---

## E4 — Restrict to one command

Add:

    harry ALL=(ALL) /usr/bin/mount

Test:

    sudo -l

---

## E5 — Run as specific user

Add:

    harry ALL=(sam) ALL

Explain meaning.

---

# F) Resource Limits

## F1 — View current limits

    ulimit -a

---

## F2 — Configure limits

Edit:

    sudo vi /etc/security/limits.conf

Add:

    harry hard nproc 30
    harry soft nproc 20

Log out and log back in as harry, then:

    ulimit -a

---

# G) Identity Files

## G1 — Inspect core files

    cat /etc/passwd | head
    cat /etc/group | head
    sudo cat /etc/shadow | head

---

## G2 — Find specific user entry

    grep '^harry:' /etc/passwd

---

# H) Timed Drills

## H1 — Create user exactly (30 seconds)

Requirements:
- name: examuser
- home: /home/exam/examuser
- shell: /bin/bash
- group: students

Commands:

    sudo useradd examuser -d /home/exam/examuser -m -s /bin/bash -g students
    getent passwd examuser

---

## H2 — Give passwordless sudo (20 seconds)

    sudo visudo
    examuser ALL=(ALL) NOPASSWD: ALL

Test:

    sudo -l

---

## H3 — Force password change (10 seconds)

    sudo passwd -e examuser

---

# I) Failure Injection Drills

## I1 — Forgetting -a with -G

Simulate:

    sudo usermod -G developers alice

Check:

    groups alice

Explain:
- it overwrote supplementary groups

Fix:

    sudo usermod -aG developers,sudo alice

---

## I2 — Bad shell path

Set:

    sudo usermod -s /bin/notreal harry

Explain:
- user cannot log in

Fix:

    sudo usermod -s /bin/bash harry

---

## I3 — Sudoers syntax error (theory)

Explain:
- why visudo exists
- how it prevents lockout

---

# J) Composition (Exam Style)

## J1 — Full user provisioning

Goal:
- Create user: projectadmin
- Home: /home/projects/projectadmin
- Shell: /bin/bash
- Group: developers
- Passwordless sudo
- Force password change on next login

Commands:

    sudo useradd projectadmin -d /home/projects/projectadmin -m -s /bin/bash -g developers
    sudo passwd projectadmin
    sudo visudo
    projectadmin ALL=(ALL) NOPASSWD: ALL
    sudo passwd -e projectadmin

Verify:

    getent passwd projectadmin

---

## J2 — Limit user resources

Add to /etc/security/limits.conf:

    projectadmin hard nproc 50

Have user log in again and verify:

    ulimit -a

---

# ✅ Phase 9 Completion Criteria

You are Phase 9-ready when you can:

- Create, modify, and delete users and groups correctly
- Set homes, shells, and passwords precisely
- Use /etc/skel intentionally
- Grant and restrict sudo safely with visudo
- Configure and explain resource limits
- Inspect and reason about /etc/passwd, /etc/group, /etc/shadow
- Avoid the classic -aG mistake
- Never lock yourself out

---

# 🔒 Phase 9 Law

If you don’t control identity and privilege, you don’t control the system.

---

# Cleanup (Optional)

    sudo userdel -r harry
    sudo userdel -r examuser
    sudo userdel -r projectadmin

---

