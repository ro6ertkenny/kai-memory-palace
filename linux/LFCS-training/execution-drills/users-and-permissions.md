# 🧪 Users and Permissions — Execution Drills (LFCS)

Mental mode: Identity, access, and damage control.  
Goal: Be able to **create, modify, secure, audit, and recover user access and permissions** quickly and safely.

This is not a tutorial.  
This is an **execution checklist + drill pack**.

---

## 🧰 Drill Framework (Applies to this file)

Drill types:
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — break intentionally; recover fast
- **D: Diagnosis** — interpret output; choose the correct fix
- **E: Composition** — 3–6 primitives chained (exam style)

Rules of engagement:
- Never `chmod -R` blindly on real paths
- Directories need execute bit to traverse (`x` on dirs is not “execute a file”)
- Prefer smallest required privilege (ACLs before ownership changes when possible)
- Always verify: `ls -l`, `stat`, `id`, `getent`, `getfacl`

---

## 🧱 Phase 1 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-1
    cd ~/lfcs-labs/execution-drills/phase-1

Create users and groups if they do not exist:

    sudo groupadd devs || true
    sudo useradd -m alice || true
    sudo useradd -m bob || true
    sudo usermod -aG devs alice
    sudo usermod -aG devs bob

Create sandbox:

    mkdir -p sandbox/{shared,private,links,acl,dropbox}
    touch sandbox/file1 sandbox/file2
    ls -l sandbox

---

## 👤 1) User Inspection

Checklist:

    whoami
    id
    who
    w
    last
    getent passwd
    getent group

Atomic reps:
- Pick 10 accounts (system + human). For each: state owner/group memberships and primary group.

    id root
    id alice
    id bob

---

## ➕ 2) User Creation and Deletion

Checklist:

    sudo useradd testuser
    sudo useradd -m -s /bin/bash testuser2
    sudo passwd testuser
    sudo passwd -l testuser
    sudo passwd -u testuser
    sudo userdel testuser
    sudo userdel -r testuser2

Scenario reps (build reflex):
- Create a service-style user with no login shell and a custom home:

    sudo useradd -m -d /opt/backup -s /usr/sbin/nologin backupadmin

Verify:

    getent passwd backupadmin
    ls -ld /opt/backup

---

## 🧰 3) User Modification

Checklist:

    sudo usermod -s /bin/sh testuser
    sudo usermod -d /home/newhome -m testuser
    sudo usermod -u 2001 testuser
    sudo chage -E 2026-12-31 testuser
    sudo chage -l testuser

Timed reps:
- In 30 seconds, set max age 90 days and warn at 7:

    sudo chage -M 90 -W 7 testuser
    sudo chage -l testuser

---

## 👥 4) Group Management

Checklist:

    sudo groupadd devs
    sudo groupdel devs
    sudo usermod -aG sudo testuser
    sudo gpasswd -d testuser sudo
    sudo usermod -g devs testuser
    groups testuser
    id testuser

Phase 1 drill: primary vs secondary groups
- Make `devs` primary for a user, then verify:

    sudo usermod -g devs alice
    id alice
    groups alice

---

## 🔐 5) Password Policy and Aging

Checklist:

    sudo chage -l testuser
    sudo chage -m 1 -M 90 -W 7 testuser
    sudo chage -d 0 testuser
    sudo passwd -l testuser
    sudo passwd -u testuser

Drill: expiry date (account expiration)
- Set an account expiry date and verify:

    sudo chage -E 2026-12-31 testuser
    sudo chage -l testuser

---

## 🏠 6) Skeleton Directory

Checklist:

    ls -la /etc/skel
    sudo nano /etc/skel/README
    sudo useradd -m skeltest
    ls -la /home/skeltest

Drill: create a required file for all new users
- Add a file to `/etc/skel` and verify it appears for a new user:

    sudo touch /etc/skel/NEWS
    sudo useradd -m skelnews
    ls -la /home/skelnews | grep NEWS || true

---

## 📁 7) Ownership and Basic Permissions

Checklist:

    ls -l file.txt
    sudo chown testuser file.txt
    sudo chgrp devs file.txt
    chmod 640 file.txt
    chmod u+x,g-w,o-r file.txt
    chmod -R 750 somedir

### A) Atomic Drills (Precision & Repetition)

#### A1 — Read permissions instantly
Pick 10 different paths. For each: say owner/group/mode/meaning.

    ls -l /etc/passwd
    ls -ld /tmp
    stat /etc/passwd

#### A2 — Symbolic chmod
Repeat 10 times.

    touch a2.txt
    chmod u+x a2.txt
    chmod g-w a2.txt
    chmod o= a2.txt
    ls -l a2.txt

Reset:

    chmod 644 a2.txt

#### A3 — Octal chmod
Repeat until instant.

    chmod 755 a2.txt
    ls -l a2.txt
    chmod 640 a2.txt
    ls -l a2.txt
    chmod 700 a2.txt
    ls -l a2.txt

#### A4 — Ownership changes
Practice user and group ownership changes safely.

    sudo chown alice a2.txt
    ls -l a2.txt
    sudo chown alice:devs a2.txt
    ls -l a2.txt
    sudo chgrp devs a2.txt
    ls -l a2.txt

#### A5 — Umask behavior (predict then verify)
Observe current umask result:

    umask
    rm -f umask.txt
    touch umask.txt
    ls -l umask.txt

Temporary change:

    umask 027
    rm -f umask2.txt
    touch umask2.txt
    ls -l umask2.txt

Reset (example):

    umask 022

---

## 🧷 8) Special Permissions

Checklist:

    chmod u+s somebin
    chmod g+s somedir
    chmod +t /shared
    find / -perm -4000 -type f 2>/dev/null
    find / -perm -2000 -type d 2>/dev/null
    find / -perm -1000 -type d 2>/dev/null

### C) Special Bits (Behavior Drills)

#### C1 — SGID directory behavior (group inheritance)
Set group + SGID:

    sudo chgrp devs sandbox/shared
    chmod 2775 sandbox/shared
    ls -ld sandbox/shared

Create as alice:

    sudo -u alice touch sandbox/shared/from-alice.txt
    ls -l sandbox/shared

Pass condition: new file is group-owned by `devs`.

#### C2 — Sticky bit behavior (delete control)
Set sticky:

    chmod 1777 sandbox/shared
    ls -ld sandbox/shared

Create files as different users and test delete behavior.

#### C3 — Find special bits (muscle memory)
Practice and interpret:

    find /usr -type f -perm -4000 | head
    find / -type d -perm -2000 | head
    find / -type d -perm -1000 | head

---

## 🔗 9) Links (Hard vs Soft)

#### L1 — Hard link behavior (inode shared)
    echo "DATA" > sandbox/links/original.txt
    ln sandbox/links/original.txt sandbox/links/hard.txt
    ls -li sandbox/links

Delete original:

    rm sandbox/links/original.txt
    cat sandbox/links/hard.txt

Pass condition: explain why data still exists (same inode, link count).

#### L2 — Symlink behavior (path reference)
    echo "DATA" > sandbox/links/real.txt
    ln -s sandbox/links/real.txt sandbox/links/sym.txt
    ls -l sandbox/links

Delete target:

    rm sandbox/links/real.txt
    ls -l sandbox/links
    cat sandbox/links/sym.txt

Pass condition: explain why it breaks (symlink points to missing path).

#### L3 — readlink
    readlink sandbox/links/sym.txt

---

## 🧠 10) umask

Checklist:

    umask
    umask 027
    touch testfile
    ls -l testfile

Drill note:
- Practice predicting the created mode before you run `touch`.

---

## 🧪 11) Access Control Lists (ACLs)

Checklist:

    mount | grep acl || true
    setfacl -m u:testuser:rw file.txt
    getfacl file.txt
    setfacl -d -m u:testuser:rw somedir
    setfacl -b file.txt

### D) ACL Drills (Phase 1)

#### D1 — View ACL
    getfacl sandbox/file1

#### D2 — Grant user access (without changing owner)
    setfacl -m u:alice:rw sandbox/file1
    getfacl sandbox/file1
    ls -l sandbox/file1

Pass condition: observe the `+` in `ls -l`.

#### D3 — Mask behavior (effective rights)
    setfacl -m m::r sandbox/file1
    getfacl sandbox/file1

Pass condition: explain why effective permissions changed (mask limits named users/groups).

#### D4 — Remove ACLs
    setfacl -b sandbox/file1
    getfacl sandbox/file1

---

## 🔍 12) Auditing and Forensics

Checklist:

    find / -user testuser 2>/dev/null
    find / -perm -0002 2>/dev/null
    find / -nouser -o -nogroup 2>/dev/null

Phase 1 drills: find by ownership & mode
- Find not owned by root (practice interpreting results):

    find /etc -type f ! -user root | head

- Find world writable (silence errors):

    find / -type f -perm -0002 2>/dev/null | head

- Find exact mode in sandbox:

    find sandbox -type f -perm 0644

---

## 👑 13) sudo and Privilege Escalation

Checklist:

    sudo -l
    sudo visudo
    sudo usermod -aG sudo testuser
    sudo -i

Drill: least-privilege sudo rule (one command only)
- Allow a user to run one specific systemctl command without password (practice editing safely):

    sudo visudo

Verify:

    sudo -l -U testuser

---

## 🧯 14) Account Recovery

Checklist:

    mount -o remount,rw /
    passwd
    reboot

---

## ⏱️ Timed Drills (Speed)

### T1 — Fix a broken tree (30 seconds)
Broken tree:

    mkdir -p broken/dir
    touch broken/dir/file
    chmod -R 777 broken

Fix to:
- directories: 755
- files: 644

Target commands:

    find broken -type d -exec chmod 755 {} +
    find broken -type f -exec chmod 644 {} +

### T2 — Shared directory setup (30 seconds)
Goal:
- group = devs
- SGID
- rwxrwsr-x

    chgrp devs sandbox/shared
    chmod 2775 sandbox/shared
    ls -ld sandbox/shared

### T3 — Grant user access without changing ownership (20 seconds)
    setfacl -m u:bob:rw sandbox/file2
    getfacl sandbox/file2

---

## 🧨 Failure Injection Drills (Break & Recover)

### F1 — Lock yourself out (controlled)
Break:

    mkdir -p sandbox/lockme
    chmod 600 sandbox/lockme
    ls sandbox/lockme

Fix:

    chmod 700 sandbox/lockme

Pass condition: explain why directories need execute bit.

### F2 — Break symlink target and diagnose
Break:

    ln -s /no/such/path sandbox/links/broken
    ls -l sandbox/links

Diagnose:

    readlink sandbox/links/broken

---

## 🧩 Composition Drills (Exam Style)

### E1 — Secure shared dropbox
Requirements:
- anyone can write
- only owner can delete

    mkdir -p sandbox/dropbox
    chmod 1777 sandbox/dropbox
    ls -ld sandbox/dropbox

### E2 — Give alice access to a log without changing owner
    sudo touch /tmp/app.log
    sudo chown root:root /tmp/app.log
    sudo chmod 640 /tmp/app.log
    sudo setfacl -m u:alice:rw /tmp/app.log
    getfacl /tmp/app.log

---

## ✅ Completion Criteria

You are done with this file when:

- You can read permissions instantly and explain them
- You can convert symbolic <-> octal without thinking
- You can fix broken directory trees safely under time pressure
- You can explain and use SUID, SGID, sticky (including directory inheritance)
- You can explain and predict hard vs symlink behavior
- You can use ACLs and explain mask effects
- You can find files by owner, group, and mode reliably
- You never lock yourself out permanently and you can recover cleanly

---

## 🔒 Law

If you do not control **who can touch what**, you do not control the system.

---

