# Login Shell and Environment

This document explains the difference between login and non-login shells, how environments are initialized, and why su and su - behave differently.

---

## su vs su -

su marshall
- Switches user
- Keeps current environment
- Does NOT start a login shell

su - marshall
- Switches user
- Starts a full login shell
- Re-reads login startup files

---

## Why the prompt sometimes does not change

If you use:

su marshall

You keep the old environment, including PS1 and PATH.

So the prompt may still look like the previous user.

---

## The shell field in /etc/passwd

Check:

getent passwd marshall

The last field is the login shell, for example:

/bin/bash

If it is set to:

/usr/sbin/nologin

The user cannot log in.

---

## Login vs non-login shells

Login shell:
- Reads /etc/profile
- Reads ~/.profile (or ~/.bash_profile, ~/.bash_login)

Non-login interactive shell:
- Reads ~/.bashrc

---

## Common startup files

System-wide:
- /etc/profile

Per-user:
- ~/.profile
- ~/.bashrc

---

## Why ~/.local exists

Many tools install user-local binaries into:

~/.local/bin

This directory is often added to PATH by default in modern distributions.

---

## How to check what kind of shell you are in

Print shell name:

echo $0

Check if it is a login shell:

shopt -q login_shell && echo login shell || echo not login shell

---

## Debugging environment problems

1. Check the user's shell in /etc/passwd
2. Check which startup files are being read
3. Try:
   su - marshall

---

## Key commands

su marshall
su - marshall
getent passwd marshall
echo $0
shopt -q login_shell

---

## Exam memory hook

su and su - are not the same. Login shells reinitialize the environment.

---
