# Accounts Debugging Checklist (Exam-Grade)

This checklist is the exact, systematic flow to use when a user cannot log in or cannot use sudo.

---

## Step 1 — Does the user exist?

Check:

getent passwd marshall

If nothing returns, the user does not exist.

---

## Step 2 — Is the password usable or locked?

Check:

passwd -S marshall

Look for:

- P = password is set and usable
- L = account is locked

---

## Step 3 — Is the login shell valid?

Check:

getent passwd marshall

The last field should be something like:

/bin/bash

Not:

/usr/sbin/nologin

---

## Step 4 — Does the home directory exist?

Check:

ls -ld /home/marshall

Ensure:

- It exists
- It is owned by marshall
- Permissions are reasonable

---

## Step 5 — Check groups

Check:

id marshall
getent group sudo

---

## Step 6 — Check sudo privileges

Check:

sudo -l -U marshall

---

## Step 7 — Check shadow entry (root)

Check:

sudo getent shadow marshall

If the hash starts with ! or !! the account is locked.

---

## Step 8 — Try a clean login shell

Check:

su - marshall

---

## Master command set

getent passwd marshall
passwd -S marshall
id marshall
getent group sudo
sudo -l -U marshall
sudo getent shadow marshall
su - marshall

---

## Exam memory hook

Identity → Authentication → Shell → Home → Groups → Sudo

Always debug in this order.

---
