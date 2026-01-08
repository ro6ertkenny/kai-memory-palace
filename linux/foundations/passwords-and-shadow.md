# Passwords and /etc/shadow

This document explains how Linux stores passwords, why /etc/passwd contains an x, how account locking works, and how to diagnose authentication problems.

---

## The two files

Linux splits identity and secrets:

- /etc/passwd = public account database (identity, UID, GID, shell, home)
- /etc/shadow = private authentication database (password hashes, aging, lock state)

Permissions:

/etc/passwd  = world-readable
/etc/shadow  = root or shadow group only

---

## Why /etc/passwd has an x

Example entry:

marshall:x:1001:1001::/home/marshall:/bin/bash

The x means:

The real password hash is stored in /etc/shadow.

Historically, hashes were in /etc/passwd. That was removed for security reasons.

---

## Hashes, not plaintext

Linux never stores plaintext passwords.

It stores:

- one-way cryptographic hashes
- with salt
- not reversible

You cannot recover a password, only replace it.

---

## Inspect password status

Check account status:

passwd -S marshall

Typical output contains:

- P = password is set and usable
- L = account is locked

---

## Locking and unlocking accounts

Lock account:

sudo passwd -l marshall

Unlock account:

sudo passwd -u marshall

This works by:

- Adding or removing a ! in front of the hash in /etc/shadow

---

## Why "password changed" appears

Locking or unlocking modifies the shadow entry.

So the system reports:

password changed

Even though you did not set a new password.

---

## Inspect shadow entry (root only)

sudo getent shadow marshall

If the hash starts with ! or !! the account is locked.

---

## Why a user cannot log in (common causes)

- Account locked in /etc/shadow
- No valid shell in /etc/passwd
- Expired password
- Home directory missing or wrong permissions

---

## Key commands

passwd -S marshall
sudo passwd -l marshall
sudo passwd -u marshall
sudo getent shadow marshall

---

## Exam memory hook

/etc/passwd holds identity. /etc/shadow holds secrets.

