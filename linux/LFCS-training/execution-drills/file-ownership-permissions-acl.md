# ⚙️ Execution Drills — Files, Ownership, Permissions, Links, and ACLs
*LFCS muscle-memory surface: most “mystery failures” reduce to ownership/permissions/ACLs or link semantics.*

**Path:** `linux/LFCS-training/execution-drills/files-ownership-permissions-links-acl.md`

This document is **execution-drills**:
- drills = mechanical fluency under time + verification
- playbooks = decision + procedure algorithms

---

## 🔗 Related Operator Playbooks (Consumers of These Primitives)

Use these when the problem is a **live-system incident**, not practice:

- `linux/LFCS-training/execution-playbooks/account-access-playbook.md`
  - home directory access, path traversal, `.ssh` permissions, ACL surprises
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
  - DAC vs MAC classification; SELinux denials; labeling fixes (`restorecon`)
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`
  - missing/unmounted `/home`, read-only mounts, boot/emergency-mode fallout
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
  - service users can’t read/write required paths; permissions after deployments/restores

---

## 🧭 Routing Rule (Drills vs Playbooks)

If you observe any of the following on a real system:

- AVC denials, SELinux enforcing, or labeling suspicion → exit to `security-triage-playbook.md`
- `/home` missing/unmounted/read-only or mount identity issues → exit to `storage-recovery-playbook.md`
- access break is specifically login/sudo/ssh/user home → `account-access-playbook.md`
- service fails due to permission/path ownership → `service-recovery-playbook.md` then `security-triage-playbook.md` if policy is involved

This drill file remains focused on **mechanical execution**.

---

## 📌 Purpose

Build reflex-level ability to:

- read permissions instantly
- use symbolic and octal chmod without guessing
- change ownership and groups safely
- set and verify SUID, SGID, sticky
- reason about hard vs symlinks
- use ACLs to grant precise access
- find files by ownership and permission patterns
- recover from broken permissions on a tree

---

## 🧱 Lab Root

All drills run in:

- `~/lfcs-labs/drills/files-perms`

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/drills/files-perms
    cd ~/lfcs-labs/drills/files-perms
    rm -rf ./*

---

## 🧪 Completion Standard

Pass when you can complete D1-1 through D1-14:

- in ≤ 60 minutes total
- with zero verification failures
- without guessing chmod values (you can explain symbolic ↔ octal)

---

## 🧠 Drill Discipline (enforced)

- Always verify with `ls -l` and `stat` (and `getfacl` when ACLs exist).
- When fixing trees, separate directories vs files unless the intent is truly uniform.
- Do not apply recursive fixes to system paths. Only fix scoped lab trees here.

---

# ⚙️ Drills

-------------------------------------------------------------------------------

## D1-1 — Read permissions and explain them

Time limit:
- 3 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-1 && mkdir d1-1
    cd d1-1
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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-2 — Symbolic chmod

Time limit:
- 3 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-2 && mkdir d1-2
    cd d1-2
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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-3 — Octal chmod reflex

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-3 && mkdir d1-3
    cd d1-3
    touch file.txt

Task:
Set permissions to:

- rwxr-xr--

Do:

    chmod 754 file.txt

Verify:

    ls -l file.txt

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-4 — Recursive permission fix (uniform)

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-4 && mkdir -p d1-4/dir/sub
    cd d1-4
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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-5 — Ownership and group change

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-5 && mkdir d1-5
    cd d1-5
    touch file.txt

Task:
Change owner to root and group to root.

Do:

    sudo chown root:root file.txt

Verify:

    ls -l file.txt

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-6 — SGID directory behavior

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-6 && mkdir d1-6
    cd d1-6
    sudo chgrp "$(id -gn)" .
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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-7 — Sticky bit behavior

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-7 && mkdir d1-7
    cd d1-7
    chmod 1777 .

Task:
Prove sticky bit is set.

Verify:

    ls -ld .

Expected:
- drwxrwxrwt

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-8 — SUID discovery

Time limit:
- 4 minutes

Task:
Find at least one SUID binary and save to file.

Do:

    cd ~/lfcs-labs/drills/files-perms
    find /usr -type f -perm -4000 > suid.txt

Verify:

    test -s suid.txt && head suid.txt

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-9 — Hard link behavior

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-9 && mkdir d1-9
    cd d1-9
    echo hello > original.txt
    ln original.txt hardlink.txt

Task:
Prove:
- link count is 2
- deleting one does not delete data

Do:

    ls -li
    rm original.txt
    cat hardlink.txt

Verify:

    ls -li hardlink.txt

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-10 — Symlink behavior

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-10 && mkdir d1-10
    cd d1-10
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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-11 — Find by permission pattern

Time limit:
- 5 minutes

Task:
Find world-writable files in /tmp.

Do:

    cd ~/lfcs-labs/drills/files-perms
    find /tmp -type f -perm -0002 > worldwrite.txt

Verify:

    wc -l worldwrite.txt
    head worldwrite.txt || true

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-12 — ACL: grant user access

Time limit:
- 7 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-12 && mkdir d1-12
    cd d1-12
    echo secret > data.txt
    chmod 600 data.txt

Task:
Grant another user read access using ACL.

Do (use an existing user; example uses root):

    sudo setfacl -m u:root:r data.txt

Verify:

    getfacl data.txt
    ls -l data.txt

Expected:
- plus sign at end of ls -l
- ACL entry present

Reset:

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-13 — Remove ACLs cleanly

Time limit:
- 4 minutes

Setup:
(continue from D1-12)

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

    cd ~/lfcs-labs/drills/files-perms

-------------------------------------------------------------------------------

## D1-14 — Permission recovery scenario

Time limit:
- 10 minutes

Setup:

    cd ~/lfcs-labs/drills/files-perms
    rm -rf d1-14 && mkdir -p d1-14/project/sub
    cd d1-14
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

    cd ~/lfcs-labs/drills/files-perms

---

## 🏁 Pass Criteria

You can:

- read permissions instantly
- convert symbolic ↔ octal in your head
- set and recognize special bits
- reason about links correctly
- grant and remove ACL access safely
- recover a broken tree without panic
- find files by ownership and permissions

---

## 🔒 Operator Law

If you do not control ownership and permissions precisely,
you do not control the system.

---
