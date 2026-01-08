# User Lifecycle Management

This document covers how to create, modify, delete, and recover (rebirth) Linux user accounts, and how to handle orphaned files safely.

---

## Creating users with useradd

Basic form:

sudo useradd marshall

Common useful flags:

- -u 1001   = specify UID
- -m        = create home directory
- -d /home/marshall = specify home path
- -s /bin/bash = specify login shell

Example:

sudo useradd -u 1001 -m -d /home/marshall -s /bin/bash marshall

---

## Deleting users with userdel

Delete account only:

sudo userdel marshall

Delete account and home directory:

sudo userdel -r marshall

Note:
Deleting a user does not automatically delete their files unless -r is used.

---

## Modifying users with usermod

Add user to supplementary group:

sudo usermod -aG sudo marshall

Important:
Always use -a with -G or you will overwrite existing groups.

---

## Default settings

System-wide defaults:

/etc/default/useradd
/etc/login.defs

These control:

- default shell
- UID ranges
- home directory base path
- password aging defaults

---

## /etc/skel

Files in:

/etc/skel

Are copied into a new user's home directory when -m is used.

Typically includes:

.bashrc
.profile
.bash_logout

---

## Rebirth a user with the same UID

If a user was deleted but their files still exist:

sudo useradd -u 1001 -m -d /home/marshall marshall

This re-attaches the old files to the new account.

---

## Orphaned files

Files whose owner no longer exists:

sudo find / -nouser -o -nogroup

This often happens after deleting users without cleaning up.

---

## Safe workflow when removing users

1. Decide whether files should be kept
2. If keeping files, record UID before deletion
3. If deleting files, use userdel -r
4. If recreating user, reuse the old UID

---

## Key commands

useradd
userdel
usermod
getent passwd marshall
id marshall
find / -nouser -o -nogroup

---

## Exam memory hook

Deleting a user does not delete their files unless you explicitly tell Linux to do so.

---
