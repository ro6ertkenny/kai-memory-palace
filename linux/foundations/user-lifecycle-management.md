# User Lifecycle Management

Create, modify, delete, and recover (rebirth) Linux user accounts.  
Includes safe workflows for orphaned files and password aging.

---

## Create users (useradd)

Basic:

    sudo useradd marshall

Common flags:

    -u 1001        set UID
    -g group       set primary group
    -G g1,g2       set supplementary groups
    -m             create home directory
    -d /home/name  set home directory
    -s /bin/bash   set login shell

Example:

    sudo useradd -u 1001 -m -d /home/marshall -s /bin/bash marshall

Create with explicit primary group:

    sudo groupadd marshall
    sudo useradd -g marshall -m -s /bin/bash marshall

---

## Set / change passwords (passwd)

Set a password:

    sudo passwd marshall

Lock / unlock an account:

    sudo passwd -l marshall
    sudo passwd -u marshall

---

## Password aging (chage)

Show aging:

    sudo chage -l marshall

Set max days:

    sudo chage -M 90 marshall

Force password change at next login:

    sudo chage -d 0 marshall

---

## Modify users (usermod)

Add user to supplementary group (critical: preserve existing groups):

    sudo usermod -aG sudo marshall

-a = append (do not overwrite existing groups)
-G = set supplementary groups

Change login shell:

    sudo usermod -s /bin/bash marshall

Change home directory (and move files):

    sudo usermod -d /home/marshall -m marshall

---

## Delete users (userdel)

Delete account only (files remain):

    sudo userdel marshall

Delete account and home directory:

    sudo userdel -r marshall

---

## Manage groups (groupadd/groupmod/groupdel)

Create group:

    sudo groupadd devs

Rename group:

    sudo groupmod -n engineers devs

Delete group:

    sudo groupdel engineers

---

## Manage group membership (gpasswd)

Add user to group:

    sudo gpasswd -a marshall sudo

Remove user from group:

    sudo gpasswd -d marshall sudo

---

## Defaults and templates

Defaults:

    cat /etc/default/useradd
    cat /etc/login.defs

Skeleton files copied into new home dirs when using -m:

    ls -la /etc/skel

---

## Rebirth a user with the same UID (recover ownership)

If a user was deleted but their files still exist, recreate using the old UID:

    sudo useradd -u 1001 -m -d /home/marshall marshall

This re-attaches ownership to the new account identity.

---

## Orphaned files

Find files without a valid owner or group:

    sudo find / -nouser -o -nogroup

---

## Safe workflow when removing users

1. Decide whether files should be kept
2. If keeping files, record UID before deletion
3. If deleting files, use userdel -r
4. If recreating user, reuse the old UID

---

## Key commands

    useradd
    usermod
    userdel
    groupadd
    groupmod
    groupdel
    gpasswd
    passwd
    chage
    getent passwd marshall
    id marshall
    sudo find / -nouser -o -nogroup

---

## Related drills

- Execution drills directory:
  - ../LFCS-training/execution-drills/

---

## Exam memory hook

Deleting a user does **not** delete their files unless you explicitly use `userdel -r`.

