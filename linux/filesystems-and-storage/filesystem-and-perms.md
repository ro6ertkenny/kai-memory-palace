# 🗂️ Filesystem & Permissions
## Understanding why commands succeed or fail

Mental mode: Controlling the system through ownership, paths, and access.

This document explains how Linux decides:
- what a path resolves to
- who owns a file or directory
- who is allowed to read, write, or execute it

Most operational failures are filesystem or permission failures.

---

## Purpose
You should be able to answer, without guessing:
- Why did this command fail?
- Which user actually executed it?
- What does this path resolve to?
- Why does it work with sudo but not without it?

---

## The Linux Filesystem (Mental Model)

Linux exposes one unified filesystem tree.

/
├── bin
├── etc
├── home
│   └── <user>
├── root
├── usr
├── var
└── tmp

Rules:
- Everything starts at /
- No drive letters
- Devices and mounts appear inside the tree

---

## Paths: Absolute vs Relative

Absolute paths start from /  
Relative paths start from the current directory

Examples:
- /etc/ssh/sshd_config
- ./script.sh
- ../logs/output.txt

Commands to orient yourself:
- pwd
- ls
- ls -l
- ls -la

---

## Users, Groups, Ownership

Every file has:
- an owner
- a group
- permissions

Interpreting ls -l output:
-rw-r----- 1 rob admins 1234 Jan 1 12:00 file.txt

Order of evaluation:
1. owner
2. group
3. others

---

## Permissions: Read, Write, Execute

Symbolic form:
rwxr-x---

Numeric meaning:
- read = 4
- write = 2
- execute = 1

Example:
chmod 750 script.sh

Meaning:
- owner: rwx
- group: r-x
- others: ---

---

## The Execute Bit

A file can exist and still fail to run.

If ./script.sh returns permission denied:
- the execute bit is missing

Fix:
- chmod +x script.sh

Verify with ls -l.

---

## Changing Ownership

Ownership controls authority.

Common operations:
- chown user file
- chown user:group file
- chown -R user:group directory (use carefully)

Prefer fixing ownership over loosening permissions.

---

## Directories Behave Differently

For directories:
- read allows listing
- write allows creation and deletion
- execute allows access to contents

This explains “I can see it but can’t use it” failures.

Inspect with:
- ls -ld directory

---

## Diagnosing Permission Problems

Always check in this order:
1. whoami
2. pwd
3. ls -l
4. ls -ld parent-directory

Helpful inspections:
- id
- realpath file
- find / -user <user> (suppress errors)

---

## sudo Is a Boundary

sudo runs commands as root.
It does not fix ownership automatically.

Common mistake:
Editing files with sudo creates root-owned files.

Result:
Future edits fail without sudo.

---

## Operational Rules

- Fix ownership before chmod
- Avoid recursive chmod
- Never use chmod -R 777
- When confused, inspect before acting

---

## Practice

Create a directory and file.
Change permissions.
Explain out loud:
- who can read
- who can write
- who cannot access it

If you can explain it without guessing, you have control.

---

## Outcome

You should be able to say:

This failed because of filesystem state,  
and I know exactly how to fix it.

That is operational fluency.
