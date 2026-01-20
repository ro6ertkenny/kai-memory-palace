# 🧪 LFCS Execution Drills — Phase 1
# 🗂️ Files, Ownership, Permissions, Links, and ACLs

Path:
  linux/execution-drills/phase-1-files-ownership-permissions-links-acl.md

Purpose:
  Turn Phase 1 into reflex-level operational skill under time pressure and failure conditions.

Mental Mode:
  You must be able to change, inspect, and repair permissions and ownership **without breaking the system**.

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-1
    cd ~/lfcs-labs/execution-drills/phase-1

Create users and groups if they do not exist:

    sudo groupadd devs || true
    sudo useradd -m alice || true
    sudo useradd -m bob || true
    sudo usermod -aG devs alice
    sudo usermod -aG devs bob

Create sandbox:

    mkdir -p sandbox/{shared,private,links,acl}
    touch sandbox/file1 sandbox/file2
    ls -l sandbox

---

# A) Atomic Drills (Precision & Repetition)

## A1 — Read permissions instantly

    ls -l /etc/passwd
    ls -ld /tmp
    stat /etc/passwd

Say out loud:
- owner
- group
- mode
- meaning

Repeat on 10 different files.

---

## A2 — Symbolic chmod

    touch a2.txt
    chmod u+x a2.txt
    chmod g-w a2.txt
    chmod o= a2.txt
    ls -l a2.txt

Reset:

    chmod 644 a2.txt

Repeat 10 times.

---

## A3 — Octal chmod

    chmod 755 a2.txt
    ls -l a2.txt
    chmod 640 a2.txt
    ls -l a2.txt
    chmod 700 a2.txt
    ls -l a2.txt

Repeat until instant.

---

## A4 — Ownership changes

    sudo chown alice a2.txt
    ls -l a2.txt
    sudo chown alice:devs a2.txt
    ls -l a2.txt
    sudo chgrp devs a2.txt
    ls -l a2.txt

---

## A5 — Umask behavior

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

# B) Links (Hard vs Soft)

## B1 — Hard link behavior

    echo "DATA" > sandbox/links/original.txt
    ln sandbox/links/original.txt sandbox/links/hard.txt
    ls -li sandbox/links

Delete original:

    rm sandbox/links/original.txt
    cat sandbox/links/hard.txt

Explain why data still exists.

---

## B2 — Symlink behavior

    echo "DATA" > sandbox/links/real.txt
    ln -s sandbox/links/real.txt sandbox/links/sym.txt
    ls -l sandbox/links

Delete target:

    rm sandbox/links/real.txt
    ls -l sandbox/links
    cat sandbox/links/sym.txt

Explain why it is broken.

---

## B3 — readlink

    readlink sandbox/links/sym.txt

---

# C) Special Bits

## C1 — SGID directory behavior

    sudo chgrp devs sandbox/shared
    chmod 2775 sandbox/shared
    ls -ld sandbox/shared

As alice:

    sudo -u alice touch sandbox/shared/from-alice.txt
    ls -l sandbox/shared

Confirm group inheritance.

---

## C2 — Sticky bit behavior

    chmod 1777 sandbox/shared
    ls -ld sandbox/shared

Create files as different users and test delete behavior.

---

## C3 — Find special bits

    find /usr -type f -perm -4000 | head
    find / -type d -perm -2000 | head
    find / -type d -perm -1000 | head

---

# D) ACL Drills

## D1 — View ACL

    getfacl sandbox/file1

## D2 — Grant user access

    setfacl -m u:alice:rw sandbox/file1
    getfacl sandbox/file1
    ls -l sandbox/file1

Observe the "+" in ls.

---

## D3 — Mask behavior

    setfacl -m m::r sandbox/file1
    getfacl sandbox/file1

Explain why effective permissions changed.

---

## D4 — Remove ACLs

    setfacl -b sandbox/file1
    getfacl sandbox/file1

---

# E) Find by Ownership & Mode

## E1 — Find not owned by root

    find /etc -type f ! -user root | head

## E2 — Find world writable

    find / -type f -perm -0002 2>/dev/null | head

## E3 — Find exact mode

    find sandbox -type f -perm 0644

---

# F) Timed Drills (Speed)

## F1 — Fix tree permissions (30 seconds)

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

---

## F2 — Shared directory setup (30 seconds)

Goal:
- group = devs
- SGID
- rwxrwsr-x

    chgrp devs sandbox/shared
    chmod 2775 sandbox/shared
    ls -ld sandbox/shared

---

## F3 — Grant user access without changing ownership (20 seconds)

    setfacl -m u:bob:rw sandbox/file2
    getfacl sandbox/file2

---

# G) Failure Injection Drills

## G1 — Lock yourself out (controlled)

    mkdir sandbox/lockme
    chmod 600 sandbox/lockme
    ls sandbox/lockme

Fix:

    chmod 700 sandbox/lockme

Explain: directories need execute bit.

---

## G2 — Break symlink target

    ln -s /no/such/path sandbox/links/broken
    ls -l sandbox/links

Diagnose using:

    readlink sandbox/links/broken

---

# H) Composition (Exam Style)

## H1 — Secure shared dropbox

Requirements:
- anyone can write
- only owner can delete

    mkdir sandbox/dropbox
    chmod 1777 sandbox/dropbox
    ls -ld sandbox/dropbox

---

## H2 — Give alice access to log without changing owner

    sudo touch /tmp/app.log
    sudo chown root:root /tmp/app.log
    sudo chmod 640 /tmp/app.log
    sudo setfacl -m u:alice:rw /tmp/app.log
    getfacl /tmp/app.log

---

# ✅ Phase 1 Completion Criteria

You are Phase 1-ready when you can:

- Read permissions instantly
- Convert symbolic <-> octal without thinking
- Fix broken directory trees safely
- Explain and use SUID, SGID, sticky
- Explain and predict hard vs symlink behavior
- Use ACLs and understand mask effects
- Find files by owner, group, and mode
- Never chmod -R blindly again

---

# 🔒 Phase 1 Law

If you do not control **who can touch what**, you do not control the system.

---

