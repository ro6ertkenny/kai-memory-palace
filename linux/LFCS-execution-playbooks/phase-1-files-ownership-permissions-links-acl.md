# ⚔️ Phase 1 — Files, Ownership, Permissions, Links, and ACLs (Execution Playbook)
*LFCS control surface: almost every real failure is a permissions or ownership failure.*

Path:
- linux/LFCS-execution-playbooks/phase-1-files-ownership-permissions-links-acl.md

Rule:
- This is not curriculum.
- This is execution under time + verification.
- Every drill must end with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- read permissions instantly
- change ownership and groups safely
- use symbolic and octal chmod without thinking
- set and verify SUID, SGID, sticky
- reason about hard vs symlinks
- use ACLs to grant precise access
- find files by ownership and permission patterns
- recover from broken permissions

---

## 🧱 Lab Root

All Phase 1 drills run in:

- ~/lfcs-labs/phase-1

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-1
    cd ~/lfcs-labs/phase-1
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 1 when you can complete P1-1 through P1-14:

- in ≤ 60 minutes total
- with zero verification failures
- without guessing chmod values

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P1-1 — Read permissions and explain them

Time limit:
- 3 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-1 && mkdir p1-1
    cd p1-1
    touch file.txt
    chmod 640 file.txt

Task:
Identify:
- owner perms
- group perms
- other perms

Verify:

    ls -l file.txt
    stat file.txt

Expected:
- -rw-r-----
- owner: rw
- group: r
- other: none

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-2 — Symbolic chmod

Time limit:
- 3 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-2 && mkdir p1-2
    cd p1-2
    touch file.txt
    chmod 600 file.txt

Task:
- add execute to user
- remove write from user
- give group read

Do:

    chmod u+x,u-w,g+r file.txt

Verify:

    ls -l file.txt

Expected:
- -r-xr-----

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-3 — Octal chmod reflex

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-3 && mkdir p1-3
    cd p1-3
    touch file.txt

Task:
Set permissions to:

- rwxr-xr--

Do:

    chmod 754 file.txt

Verify:

    ls -l file.txt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-4 — Recursive permission fix

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-4 && mkdir -p p1-4/dir/sub
    cd p1-4
    touch dir/a dir/sub/b
    chmod -R 000 dir

Task:
Restore everything to 755.

Do:

    chmod -R 755 dir

Verify:

    find dir -type f -exec ls -l {} +
    find dir -type d -exec ls -ld {} +

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-5 — Ownership and group change

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-5 && mkdir p1-5
    cd p1-5
    touch file.txt

Task:
Change owner to root and group to root.

Do:

    sudo chown root:root file.txt

Verify:

    ls -l file.txt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-6 — SGID directory behavior

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-6 && mkdir p1-6
    cd p1-6
    sudo chgrp $(id -gn) .
    chmod 2775 .

Task:
Create a file and prove it inherits group.

Do:

    touch testfile

Verify:

    ls -l testfile
    ls -ld .

Expected:
- directory has s in group bit
- file group == directory group

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-7 — Sticky bit behavior

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-7 && mkdir p1-7
    cd p1-7
    chmod 1777 .

Task:
Prove sticky bit is set.

Verify:

    ls -ld .

Expected:
- drwxrwxrwt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-8 — SUID discovery

Time limit:
- 4 minutes

Task:
Find at least one SUID binary and save to file.

Do:

    find /usr -type f -perm -4000 > suid.txt

Verify:

    test -s suid.txt && head suid.txt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-9 — Hard link behavior

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-9 && mkdir p1-9
    cd p1-9
    echo hello > original.txt
    ln original.txt hardlink.txt

Task:
Prove:
- link count is 2
- deleting one does not delete data

Do:

    ls -l
    rm original.txt
    cat hardlink.txt

Verify:

    ls -l hardlink.txt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-10 — Symlink behavior

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-10 && mkdir p1-10
    cd p1-10
    echo hello > original.txt
    ln -s original.txt symlink.txt

Task:
Prove:
- deleting original breaks symlink

Do:

    rm original.txt
    ls -l
    cat symlink.txt || true

Verify:

    ls -l symlink.txt

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-11 — Find by permission pattern

Time limit:
- 5 minutes

Task:
Find world-writable files in /tmp.

Do:

    find /tmp -type f -perm -0002 > worldwrite.txt

Verify:

    wc -l worldwrite.txt
    head worldwrite.txt || true

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-12 — ACL: grant user access

Time limit:
- 7 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-12 && mkdir p1-12
    cd p1-12
    echo secret > data.txt
    chmod 600 data.txt

Task:
Grant another user read access using ACL.

Do (replace bob with a real user if needed):

    sudo setfacl -m u:root:r data.txt

Verify:

    getfacl data.txt
    ls -l data.txt

Expected:
- plus sign at end of ls -l
- ACL entry present

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-13 — Remove ACLs cleanly

Time limit:
- 4 minutes

Setup:
(continue from P1-12)

Task:
Remove all ACLs.

Do:

    sudo setfacl -b data.txt

Verify:

    getfacl data.txt
    ls -l data.txt

Expected:
- no extended ACL entries
- no + in ls -l

Reset:

    cd ~/lfcs-labs/phase-1

-------------------------------------------------------------------------------

## P1-14 — Permission recovery scenario

Time limit:
- 10 minutes

Setup:

    cd ~/lfcs-labs/phase-1
    rm -rf p1-14 && mkdir -p p1-14/project/sub
    cd p1-14
    touch project/a project/sub/b
    chmod -R 000 project

Task:
Restore:
- directories: 755
- files: 644

One valid solution:

    find project -type d -exec chmod 755 {} +
    find project -type f -exec chmod 644 {} +

Verify:

    find project -exec ls -l {} +

Reset:

    cd ~/lfcs-labs/phase-1

---

## 🏁 Phase 1 Pass Criteria

You can:

- read permissions instantly
- convert symbolic ↔ octal in your head
- set and recognize special bits
- reason about links correctly
- grant and remove ACL access safely
- recover a broken tree without panic
- find files by ownership and permissions

---

## 🔒 Phase 1 Law

If you do not control ownership and permissions precisely,
you do not control the system.

---
