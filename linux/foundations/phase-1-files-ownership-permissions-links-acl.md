# 🗂️ Phase 1 — Files, Ownership, Permissions, Links, and ACLs
*LFCS core substrate: almost every task touches files, identities, or access bits.*

---

## 📌 Purpose

This phase makes you **precise and safe** with:

- Who owns what
- Who can read/write/execute what
- How links really work
- How special bits and ACLs modify access

Most LFCS failures happen because someone:
- deletes the wrong file
- breaks permissions
- misunderstands a link
- or fixes access in a way that causes a bigger outage

---

## 🧠 Mental Model

Every filesystem object has:

- Owner (user)
- Group
- Mode bits (rwx for user/group/other)
- Possibly:
  - Special bits (SUID, SGID, sticky)
  - ACLs (extended access rules)

Access checks happen in this order:

1) If ACL exists → ACL rules are evaluated  
2) Else → classic permissions (u/g/o) are used

---

## 📁 Core File Operations (Safety First)

List with details:

    ls -la
    ls -l --full-time

Copy / move / remove:

    cp file1 file2
    cp -a dir1 dir2
    mv old new
    rm file
    rm -rf dir

Show metadata:

    stat file
    file file

---

## 👤 Ownership

Change owner:

    chown alice file
    chown alice:developers file

Change group:

    chgrp developers file

Recursive:

    chown -R alice:developers /data/project

---

## 🔐 Permissions (Classic)

View:

    ls -l file

Format:

    -rwxr-xr--

Meaning:

- user: rwx
- group: r-x
- other: r--

Change using symbolic:

    chmod u+x file
    chmod g-w file
    chmod o= file
    chmod u=rwx,g=rx,o= file

Change using octal:

    chmod 755 file
    chmod 640 file
    chmod 700 file

Octal mapping:

- r = 4
- w = 2
- x = 1

So:

- 7 = rwx
- 6 = rw-
- 5 = r-x
- 4 = r--

---

## 🧱 Umask

Show current:

    umask

Create file and observe default:

    touch testfile
    ls -l testfile

Temporarily change:

    umask 027

---

## 🧲 Special Permission Bits

### SUID (run as file owner)

Set:

    chmod u+s /usr/bin/someprog

Find all SUID files:

    find /usr -type f -perm -4000

### SGID

On file: run as file’s group  
On directory: new files inherit directory group

Set:

    chmod g+s /shared

Find all SGID:

    find /usr -type f -perm -2000
    find / -type d -perm -2000

### Sticky Bit (protect shared dirs)

Set:

    chmod +t /shared

Find sticky dirs:

    find / -type d -perm -1000

Meaning:

- Only owner of file (or root) can delete their own file in that directory

---

## 🔗 Links

### Hard Links

- Point to same inode
- Cannot cross filesystems
- Cannot link directories (normally)

Create:

    ln original hardlink

Check link count:

    ls -l

Find files with link count > 1:

    find / -type f -links +1

### Symbolic Links (Soft)

- Separate file pointing to a path
- Can cross filesystems
- Can break

Create:

    ln -s /path/to/target symlink

Inspect:

    ls -l symlink
    readlink symlink

---

## ⚠️ Link Safety Rules

- Removing original file:
  - Hard link: data still exists
  - Symlink: broken link
- Editing via any hard link edits the same data

---

## 🧾 Access Control Lists (ACL)

When classic permissions are not enough.

View:

    getfacl file

Grant user access:

    setfacl -m u:john:rw file

Grant group access:

    setfacl -m g:mail:rx file

Remove ACL entry:

    setfacl -x u:john file

Remove all ACLs:

    setfacl -b file

Recursive:

    setfacl -R -m u:john:rwx /data/collection

---

## 🧠 ACL vs Classic Permissions

- ACLs **extend** permissions
- Mask entry limits maximum effective permissions
- If ACL exists, `ls -l` shows a `+` at end:

    -rw-rw----+ 1 root root file

---

## 🔍 Find by Ownership & Permissions (Exam Patterns)

Find files not owned by root:

    find /etc -type f ! -user root

Find world-writable files:

    find / -type f -perm -0002

Find group-writable but not world-writable:

    find /var/log -type f -perm -0020 ! -perm -0002

Find files with exact mode:

    find /home -type f -perm 0640

Find dirs with SGID:

    find / -type d -perm -2000

---

## 🧪 Canonical Exam Scenarios

Fix broken permissions on a directory tree:

    chmod -R 755 /data/project

Make shared directory where all new files inherit group:

    chgrp developers /shared
    chmod 2775 /shared

Give user access without changing ownership:

    setfacl -m u:alice:rw /var/log/app.log

Find all SUID binaries:

    find / -type f -perm -4000

Protect shared dropbox:

    chmod 1777 /shared

---

## ⚠️ Failure Modes

- Using chmod -R blindly
- Breaking /usr/bin or /etc permissions
- Confusing symlink target vs link
- Forgetting ACL mask
- Removing execute bit from directories (locks everyone out)

---

## 🏁 Phase 1 Mastery Checklist

You must be able to:

- Read permissions instantly
- Convert between symbolic and octal
- Set SUID, SGID, sticky correctly
- Explain hard vs soft links
- Find files by owner/group/perms
- Use ACLs to grant targeted access
- Diagnose why access is denied

---

## 🔒 Exam Law

> **If you don’t control ownership and permissions precisely, you don’t control the system.**

Almost every LFCS task depends on this phase.

---
