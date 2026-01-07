# 🔐 Advanced Filesystem Permissions

## 🎯 Purpose

This document explains **all access-control mechanisms beyond basic chmod**:

- Special permission bits: **SUID, SGID, Sticky**
- **ACLs** (Access Control Lists) and the **mask**
- **Filesystem attributes** (`chattr`, `lsattr`) like **immutable**

These mechanisms explain **why files sometimes behave in ways that rwx cannot explain**.

If “chmod looks right but access still fails”, the answer is usually here.

---

## 🧠 Mental Model

Linux enforces access using **multiple layers**:

1. Basic permissions (rwx, owner, group, others)
2. Special permission bits (SUID, SGID, Sticky)
3. ACLs (per-user/per-group exceptions)
4. Filesystem attributes (immutable, append-only, etc.)

Higher layers can **override or block** lower layers.

---

# 🧱 Part 1 — Special Permission Bits

Special bits appear in `ls -l` output as **s** or **t**.

Example:

-rwsr-xr-x  
drwxrwxrwt  
drwxr-s---

---

## 🧨 SUID — Set User ID

When a file has **SUID**, it runs **as the file’s owner**, not as the user who launched it.

Example:

    ls -l /usr/bin/passwd

You will see:

    -rwsr-xr-x

The `s` replaces the owner’s `x`.

Some programs must perform **privileged actions** for normal users.

`passwd` must write to `/etc/shadow`, which is root-owned.

Important truth:

- The program runs as **whoever owns the file**
- Often that is `root`, but **not always**

---

## 🔎 Finding SUID files

    find /usr/bin /bin /sbin -perm -4000 2>/dev/null | head

- `-perm -4000` = files with SUID bit
- `2>/dev/null` = discard permission errors

---

### Breaking down the command

Command:

    find /usr/bin /bin /sbin -perm -4000 2>/dev/null | head

Meaning, piece by piece:

- find /usr/bin /bin /sbin
  Search these directories recursively.

- -perm -4000
  Match files that have the SUID bit set.
  4000 is the numeric value of the SUID permission bit.

- 2>/dev/null
  Discard permission-denied errors (many system directories are not readable).

- | head
  Show only the first few results so the output is short and readable.

Full meaning:

Search common system binary directories for files that have the SUID bit set, ignore permission errors, and show only a few results.


## 🧱 SGID — Set Group ID

On directories: new files **inherit the directory’s group**.

Example:

    find / -type d -perm -2000 2>/dev/null | head

Example:

    ls -ld /etc/chatscripts

    drwxr-s--- 2 root dip 4096 Dec  8 17:10 /etc/chatscripts

Meaning:

- Group = dip
- `s` = SGID
- New files inherit group dip

---

### Finding SGID directories

Command:

    find / -type d -perm -2000 2>/dev/null | head

Meaning, piece by piece:

- find /
  Search the filesystem recursively starting at root.

- -type d
  Limit results to directories only.

- -perm -2000
  Match directories that have the SGID bit set.
  2000 is the numeric value of the SGID permission bit.

- 2>/dev/null
  Discard permission-denied errors from protected directories.

- | head
  Show only the first few matches to keep output readable.

Full meaning:

Search the filesystem for directories with the SGID bit set, ignore permission errors, and display only a small sample of results.
 
---

## 🧱 Sticky Bit

Example:

    ls -ld /tmp

    drwxrwxrwt

`t` means:

Only file owner or directory owner can delete files.

---

## 🧠 Summary

- `s` in owner = SUID
- `s` in group = SGID
- `t` in others = Sticky

---

### s vs S and t vs T in ls -l

In permission strings, the special bits replace the execute (x) position.

Examples:

- s or S appears in the owner or group execute position
- t or T appears in the others execute position

Meaning:

- s = special bit is set AND execute bit is set
- S = special bit is set BUT execute bit is NOT set

- t = sticky bit is set AND execute bit is set
- T = sticky bit is set BUT execute bit is NOT set

Examples:

- -rwsr-xr-x
  SUID is set and executable (normal for programs)

- -rwSr--r--
  SUID is set but not executable (usually a misconfiguration)

- drwxrwxrwt
  Sticky bit is set and directory is accessible (normal for /tmp)

- drwxrwxr-T
  Sticky bit is set but directory is not accessible (usually broken)

Rule of thumb:

Lowercase (s, t) = special bit + execute bit set  
Uppercase (S, T) = special bit set but execute bit missing (usually wrong)

---

# 🧱 Part 2 — ACLs

Inspect:

    getfacl file.txt

Add:

    setfacl -m u:marshall:r file.txt

Mask = **maximum allowed permission** for named users/groups:

    setfacl -m m:r file.txt

### Important: What the mask actually does

The ACL mask is not just another entry.

It acts as a **global maximum permission limit** for:

- all named users
- all named groups
- the owning group (when ACLs are present)

Even if an ACL entry says:

user:marshall:rwx

If the mask is:

mask::r--

Then the **effective** permission is:

r--

In other words:

The mask **clips** or **limits** all ACL-granted permissions.

This is the most common reason people think:

“ACLs don’t work” or “permissions look right but access is still denied.”


Remove all ACLs:

    setfacl -b file.txt

---

# 🧱 Part 3 — Filesystem Attributes

Inspect:

    lsattr file.txt

`e` = extents (normal)

### What these flags actually mean

- e = extents  
  This means the file is stored using extents (a modern, efficient on-disk layout).
  This is normal on ext4 and similar filesystems and is set automatically by the filesystem.
  You usually ignore this flag.

- i = immutable  
  This means the file cannot be:
  - modified
  - deleted
  - renamed

Even root cannot change or delete an immutable file until the flag is removed.

### Breaking down the command

    sudo chattr +i file.txt

Meaning:

- chattr = change file attributes
- +i = add the immutable attribute
- file.txt = the target file

So the command means:

Mark this file as immutable so nothing (including root) can change or delete it.

To remove it:

    sudo chattr -i file.txt


Make immutable:

    sudo chattr +i file.txt

Remove:

    sudo chattr -i file.txt

Immutable means:

- cannot modify
- cannot delete
- cannot rename

Even root is blocked until removed.

---

# 🧠 Precedence (Simplified)

1. chattr attributes
2. ACL mask
3. ACL entries
4. SUID/SGID/Sticky
5. rwx

---

## ⚠️ Rules

- If root can’t delete → check lsattr
- If chmod looks right but fails → check getfacl
- If program runs weird → check for `s`

---
