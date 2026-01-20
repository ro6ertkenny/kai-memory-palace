# ⚔️ Phase 9 — Users, Groups, Sudo, Environment, and Limits (Execution Playbook)
*LFCS identity plane: create accounts, grant power, restrict damage, and prove who can do what.*

Path:
- linux/LFCS-execution-playbooks/phase-9-users-groups-sudo-and-limits.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- create, modify, delete users and groups
- control shells and home directories
- manage supplementary groups
- grant and verify sudo rights (safely)
- control environment variables
- enforce resource limits
- diagnose broken logins

---

## 🧱 Lab Root

All Phase 9 drills run in:

- ~/lfcs-labs/phase-9

Initialize:

    mkdir -p ~/lfcs-labs/phase-9
    cd ~/lfcs-labs/phase-9
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT break your own sudo access.
- Always keep at least one root-capable account.
- Always use visudo for sudoers.

---

## 🧪 Completion Standard

Pass Phase 9 when you can complete P9-1 through P9-16:

- in ≤ 90 minutes
- without locking yourself out
- without breaking sudo
- with proof files created

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P9-1 — Inspect identity database

Time limit:
- 4 minutes

Task:
Capture identity files.

Do:

    cp /etc/passwd passwd.txt
    cp /etc/group group.txt

Verify:

    ls -l passwd.txt group.txt

-------------------------------------------------------------------------------

## P9-2 — Create user with home and shell

Time limit:
- 4 minutes

Task:
Create user `p9alice` with bash shell.

Do:

    sudo useradd -m -s /bin/bash p9alice
    sudo passwd p9alice

Verify:

    grep '^p9alice:' /etc/passwd

-------------------------------------------------------------------------------

## P9-3 — Create user with custom home

Time limit:
- 4 minutes

Task:
Create user `p9bob` with home `/home/students/p9bob`.

Do:

    sudo mkdir -p /home/students
    sudo useradd -m -d /home/students/p9bob -s /bin/bash p9bob
    sudo passwd p9bob

Verify:

    ls -ld /home/students/p9bob

-------------------------------------------------------------------------------

## P9-4 — Create group and assign users

Time limit:
- 4 minutes

Task:
Create group `p9devs` and add both users.

Do:

    sudo groupadd p9devs
    sudo usermod -aG p9devs p9alice
    sudo usermod -aG p9devs p9bob

Verify:

    groups p9alice
    groups p9bob

-------------------------------------------------------------------------------

## P9-5 — Change primary group

Time limit:
- 3 minutes

Task:
Make `p9devs` primary group for p9bob.

Do:

    sudo usermod -g p9devs p9bob

Verify:

    id p9bob > p9bob-id.txt

-------------------------------------------------------------------------------

## P9-6 — Lock and unlock account

Time limit:
- 3 minutes

Task:
Lock and unlock p9alice.

Do:

    sudo passwd -l p9alice
    sudo passwd -u p9alice

Verify:

    sudo passwd -S p9alice > p9alice-status.txt

-------------------------------------------------------------------------------

## P9-7 — Force password change

Time limit:
- 3 minutes

Task:
Expire p9bob password.

Do:

    sudo passwd -e p9bob

Verify:

    sudo chage -l p9bob > p9bob-aging.txt

-------------------------------------------------------------------------------

## P9-8 — Skeleton test

Time limit:
- 6 minutes

Task:
Add a file to /etc/skel and create a new user.

Do:

    echo "Welcome P9" | sudo tee /etc/skel/WELCOME.txt
    sudo useradd -m -s /bin/bash p9charlie
    sudo passwd p9charlie

Verify:

    ls /home/p9charlie/WELCOME.txt > skel-proof.txt

-------------------------------------------------------------------------------

## P9-9 — Environment variable (system-wide)

Time limit:
- 6 minutes

Task:
Add system-wide variable P9LAB=ON.

Do:

    sudo vi /etc/environment

Add:

    P9LAB=ON

Re-login or test via:

    su - p9alice
    echo $P9LAB
    exit

Save proof:

    echo "P9LAB=$P9LAB" > env-proof.txt

-------------------------------------------------------------------------------

## P9-10 — Grant sudo to user (password required)

Time limit:
- 5 minutes

Task:
Give p9alice sudo rights.

Do:

    sudo visudo

Add:

    p9alice ALL=(ALL) ALL

Verify:

    su - p9alice
    sudo -l > /home/p9alice/sudo-check.txt
    exit

-------------------------------------------------------------------------------

## P9-11 — Grant sudo to group (no password)

Time limit:
- 5 minutes

Task:
Give group p9devs passwordless sudo.

Do:

    sudo visudo

Add:

    %p9devs ALL=(ALL) NOPASSWD: ALL

Verify:

    su - p9bob
    sudo id > /home/students/p9bob/sudo-id.txt
    exit

-------------------------------------------------------------------------------

## P9-12 — Restrict sudo to one command

Time limit:
- 5 minutes

Task:
Allow p9charlie to run only /usr/bin/id.

Do:

    sudo visudo

Add:

    p9charlie ALL=(ALL) /usr/bin/id

Verify:

    su - p9charlie
    sudo id
    sudo ls || echo "ls blocked" > /home/p9charlie/restrict-proof.txt
    exit

-------------------------------------------------------------------------------

## P9-13 — Inspect limits

Time limit:
- 3 minutes

Task:
Capture limits.

Do:

    ulimit -a > limits.txt

Verify:

    wc -l limits.txt

-------------------------------------------------------------------------------

## P9-14 — Apply user process limit

Time limit:
- 6 minutes

Task:
Limit p9bob to 50 processes.

Do:

    sudo vi /etc/security/limits.conf

Add:

    p9bob hard nproc 50

Save proof:

    grep p9bob /etc/security/limits.conf > limits-rule.txt

-------------------------------------------------------------------------------

## P9-15 — Diagnose broken shell

Time limit:
- 4 minutes

Task:
Break and fix p9charlie shell.

Do:

    sudo usermod -s /bin/false p9charlie
    grep p9charlie /etc/passwd > broken-shell.txt

Fix:

    sudo usermod -s /bin/bash p9charlie
    grep p9charlie /etc/passwd > fixed-shell.txt

-------------------------------------------------------------------------------

## P9-16 — Cleanup

Time limit:
- 6 minutes

Task:
Remove lab users and group.

Do:

    sudo userdel -r p9alice
    sudo userdel -r p9bob
    sudo userdel -r p9charlie
    sudo groupdel p9devs

Verify:

    grep p9 /etc/passwd || echo "users gone" > cleanup.txt

---

## 🏁 Phase 9 Pass Criteria

You can:

- create and destroy users and groups
- manage shells and home directories
- grant and restrict sudo safely
- control environment defaults
- apply and reason about limits
- fix broken logins

---

## 🔒 Phase 9 Law

If you can’t control **who** can do **what**, you don’t control the system.

---
