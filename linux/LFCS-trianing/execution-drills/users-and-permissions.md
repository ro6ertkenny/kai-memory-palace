# 🧪 Users and Permissions — Execution Drills (LFCS)

Mental mode: Identity, access, and damage control.  
Goal: Be able to **create, modify, secure, audit, and recover user access and permissions** quickly and safely.

This is not a tutorial.  
This is an **execution checklist**.

---

## 👤 1) User Inspection

- Show current user
- Show user ID info
- Show logged in users
- Show last logins
- Inspect passwd and group files

    whoami
    id
    who
    w
    last
    getent passwd
    getent group

---

## ➕ 2) User Creation and Deletion

- Create user
- Create user with home
- Create user with specific shell
- Set password
- Lock user
- Unlock user
- Delete user
- Delete user and home

    sudo useradd testuser
    sudo useradd -m -s /bin/bash testuser2
    sudo passwd testuser
    sudo passwd -l testuser
    sudo passwd -u testuser
    sudo userdel testuser
    sudo userdel -r testuser2

---

## 🧰 3) User Modification

- Change shell
- Change home directory
- Change UID
- Expire account
- Show account aging

    sudo usermod -s /bin/sh testuser
    sudo usermod -d /home/newhome -m testuser
    sudo usermod -u 2001 testuser
    sudo chage -E 2026-12-31 testuser
    sudo chage -l testuser

---

## 👥 4) Group Management

- Create group
- Delete group
- Add user to group
- Remove user from group
- Set primary group
- Show group membership

    sudo groupadd devs
    sudo groupdel devs
    sudo usermod -aG sudo testuser
    sudo gpasswd -d testuser sudo
    sudo usermod -g devs testuser
    groups testuser
    id testuser

---

## 🔐 5) Password Policy and Aging

- Show password policy
- Set min/max days
- Force password change
- Lock account
- Unlock account

    sudo chage -l testuser
    sudo chage -m 1 -M 90 -W 7 testuser
    sudo chage -d 0 testuser
    sudo passwd -l testuser
    sudo passwd -u testuser

---

## 🏠 6) Skeleton Directory

- Inspect skeleton files
- Add file to skeleton
- Create new user and verify

    ls -la /etc/skel
    sudo nano /etc/skel/README
    sudo useradd -m skeltest
    ls -la /home/skeltest

---

## 📁 7) Ownership and Basic Permissions

- Show ownership
- Change owner
- Change group
- Change permissions (numeric)
- Change permissions (symbolic)
- Recursive changes

    ls -l file.txt
    sudo chown testuser file.txt
    sudo chgrp devs file.txt
    chmod 640 file.txt
    chmod u+x,g-w,o-r file.txt
    chmod -R 750 somedir

---

## 🧷 8) Special Permissions

- Set suid
- Set sgid
- Set sticky bit
- Find suid files
- Find sgid files
- Find sticky directories

    chmod u+s somebin
    chmod g+s somedir
    chmod +t /shared
    find / -perm -4000 -type f 2>/dev/null
    find / -perm -2000 -type d 2>/dev/null
    find / -perm -1000 -type d 2>/dev/null

---

## 🧠 9) umask

- Show current umask
- Set umask
- Create file and inspect permissions

    umask
    umask 027
    touch testfile
    ls -l testfile

---

## 🧪 10) Access Control Lists (ACLs)

- Check filesystem support
- Set ACL
- Get ACL
- Set default ACL
- Remove ACL

    mount | grep acl || true
    setfacl -m u:testuser:rw file.txt
    getfacl file.txt
    setfacl -d -m u:testuser:rw somedir
    setfacl -b file.txt

---

## 🔍 11) Auditing and Forensics

- Find files owned by user
- Find world-writable files
- Find files with no owner

    find / -user testuser 2>/dev/null
    find / -perm -0002 2>/dev/null
    find / -nouser -o -nogroup 2>/dev/null

---

## 👑 12) sudo and Privilege Escalation

- Check sudo access
- Edit sudoers safely
- Add user to sudo group
- Test sudo

    sudo -l
    sudo visudo
    sudo usermod -aG sudo testuser
    sudo -i

---

## 🧯 13) Account Recovery

- Boot into rescue/emergency
- Remount root rw
- Reset root password
- Reboot

    mount -o remount,rw /
    passwd
    reboot

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can rebuild users and permissions from scratch
- You never lock yourself out permanently
- You can audit and explain every permission bit you see

---
