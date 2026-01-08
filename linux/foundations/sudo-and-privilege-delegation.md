# sudo and Privilege Delegation

This document explains how Linux delegates administrative privileges, how sudo works, how to inspect and control access, and how to debug privilege problems.

---

## sudo vs su

su:
- Switches to another user (usually root)
- Starts a shell as that user
- No per-command auditing by default

sudo:
- Executes a single command as another user (usually root)
- Enforces policy
- Logs usage
- Is the standard administrative access mechanism on modern systems

---

## What can I run with sudo?

Check your permissions:

sudo -l

Check another user:

sudo -l -U marshall

---

## Where sudo rules live

Main file:

/etc/sudoers

Drop-in directory:

/etc/sudoers.d/

Files in /etc/sudoers.d/ are read in addition to the main file.

---

## Always use visudo

Never edit sudoers with a normal editor.

Use:

sudo visudo

visudo:
- Checks syntax before saving
- Prevents locking yourself out of sudo

---

## Why we prefer drop-in files

- Safer than editing the main file
- Cleaner separation of concerns
- Easy to audit
- Easy to remove
- Package-friendly

---

## Creating a sudo rule with tee and heredoc

Example: give marshall full sudo

sudo tee /etc/sudoers.d/marshall <<'EOF'
marshall ALL=(ALL) ALL
EOF

Then fix permissions:

sudo chmod 440 /etc/sudoers.d/marshall

---

## File permissions matter

sudoers files must be:

- Owned by root
- Mode 440

Otherwise sudo will refuse to work.

---

## Command-restricted sudo (example)

Allow only apt-get:

marshall ALL=(ALL) /usr/bin/apt-get

This allows:

sudo apt-get update

But not:

sudo bash

---

## Group-based sudo

On Debian/Ubuntu systems:

- Members of group sudo get sudo access

Check:

getent group sudo

Remove user from sudo group:

sudo gpasswd -d marshall sudo

---

## Why marshall had full sudo

Because:

- He was in the sudo group
- Or had a rule in /etc/sudoers.d/

---

## Debugging sudo problems

1. Check group membership:
   id marshall
   getent group sudo

2. Check explicit rules:
   sudo -l -U marshall

3. Check files in:
   /etc/sudoers.d/

---

## Key commands

sudo -l
sudo -l -U marshall
visudo
getent group sudo
gpasswd -d marshall sudo

---

## Exam memory hook

sudo is policy-driven command delegation, not just "become root".

---
