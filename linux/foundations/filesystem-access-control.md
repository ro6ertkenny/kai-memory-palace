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


🔐 Permissions = rwx (the core)
r = read
w = write
x = execute
🧠 The structure (ALWAYS this order)
rwx  rwx  rwx
│    │    │
│    │    └─ others
│    └────── group
└────────── owner

So:

-rwxr-xr--

means:

owner  → rwx
group  → r-x
others → r--
📁 What they actually DO (this is what people miss)
For FILES
Permission	Meaning
r	can read file contents
w	can modify file
x	can run it (script/program)
For DIRECTORIES (VERY IMPORTANT for LFCS)
Permission	Meaning
r	can list files (ls)
w	can create/delete files
x	can enter directory (cd)

🔥 Key insight:

x on directory = access (cd into it)

Without x, even if you have r, you can’t enter it.

🔢 Numeric (octal) representation

Each permission has a value:

r = 4
w = 2
x = 1

Add them:

Permissions	Value
rwx	7 (4+2+1)
rw-	6 (4+2)
r-x	5 (4+1)
r--	4
---	0
Example
chmod 755 file

Means:

7 5 5
│ │ │
│ │ └─ others = r-x
│ └──── group  = r-x
└────── owner  = rwx

So:

rwxr-xr-x
⚡ Common real-world combos
755 (VERY common)
rwxr-xr-x

owner can do everything

others can read + execute

used for scripts, directories

644 (VERY common)
rw-r--r--

owner can edit

others can read only

used for config files

700
rwx------

only owner has access

🛠 Commands you'll use constantly
Change permissions
chmod 755 file
Symbolic way
chmod u+x file     # add execute to user
chmod g-w file     # remove write from group
chmod o+r file     # add read to others
🧠 Mental shortcut (this makes it click fast)

Think:

r = see
w = change
x = enter/run

For directories:

r = see names
w = change contents
x = enter
⚡ 5-second LFCS decoding trick

See this:

drwxr-x---

Break it instantly:

d         → directory
rwx       → owner full
r-x       → group read + enter
---       → others nothing
🧠 Final memory anchor
rwx = 421
owner-group-others
directories need x to enter

🔐 The 3 special bits
SUID   → user (owner)
SGID   → group
Sticky → others (directory control)

Think:

top row = special powers layered ON TOP of rwx
🧠 Where they show up

Normal:

-rwxr-xr-x

With special bits:

-rwsr-xr-x   (SUID)
-rwxr-sr-x   (SGID)
drwxrwxrwt   (Sticky)

Notice:

x → becomes s or t
1️⃣ SUID (Set User ID)
What it means
Run the file AS the owner (not the user running it)
Example
ls -l /usr/bin/passwd

You’ll see:

-rwsr-xr-x

That s means:

Runs as root (owner), even if you are a normal user
Why this exists

Changing passwords requires root access.

So:

You run passwd → it temporarily runs as root → updates /etc/shadow
Set it
chmod u+s file

Numeric:

chmod 4755 file
4 = SUID
2️⃣ SGID (Set Group ID)
What it means (files)
Run as the file’s group
What it means (directories) 🔥 IMPORTANT
New files inherit the directory’s group
Example (directory)
chmod g+s shared_dir

Now:

all new files inside → inherit group of shared_dir
Set it
chmod g+s dir

Numeric:

chmod 2755 dir
2 = SGID
3️⃣ Sticky Bit (most tested for LFCS)
What it means
Only the OWNER can delete their files (even in shared dirs)
Example
ls -ld /tmp
drwxrwxrwt

That t means:

Everyone can write, BUT only owner can delete their own files
Why this exists

Without it:

any user could delete anyone else's files in /tmp
Set it
chmod +t dir

Numeric:

chmod 1777 dir
1 = sticky
🔥 Lowercase vs uppercase (IMPORTANT)
s / t → execute bit is ON
S / T → execute bit is OFF

Example:

-rwsr-xr-x  ✅ normal
-rwSr-xr-x  ⚠️ execute missing (rare/misconfig)
🔢 Full numeric breakdown
4 = SUID
2 = SGID
1 = Sticky

So:

Value	Meaning
4755	SUID
2755	SGID
1755	Sticky
🧠 Memory trick (this is the one to keep)
SUID   → run as owner
SGID   → inherit group
Sticky → protect deletes
⚡ Real-world mental examples
SUID
passwd → needs root → SUID
SGID
shared dev folder → same group ownership
Sticky
/tmp → everyone writes, no one deletes others' files
⚡ 5-second decode trick

See this:

drwxrwxrwt

Break it:

d        → directory
rwx      → owner full
rwx      → group full
rwt      → others (write BUT sticky protected)
🧠 Final anchor
4 2 1
│ │ │
│ │ └─ Sticky (delete protection)
│ └── SGID (group inheritance)
└──── SUID (run as owner)


🧠 SCENARIO 1 — Shared Team Directory
Situation

You have a directory:

/shared/dev

Multiple developers:

must create files

must collaborate

must all use the same group (dev)

files must automatically inherit the group

❓ What do you use?
SGID
✅ Solution
chown :dev /shared/dev
chmod 2775 /shared/dev
🔍 Why
2 → SGID

Effect:

All new files → inherit group = dev
💡 Without SGID
files get user's default group → breaks collaboration
🧠 SCENARIO 2 — Public Temp Directory
Situation

Directory:

/shared/tmp

Requirements:

everyone can create files

everyone can read/write

BUT users must NOT delete each other’s files

❓ What do you use?
Sticky bit
✅ Solution
chmod 1777 /shared/tmp
🔍 Why
1 → sticky

Effect:

Only file owner can delete their own files
💡 Real-world example
/tmp

Always:

drwxrwxrwt
🧠 SCENARIO 3 — Privileged Command
Situation

You create a script:

/usr/local/bin/reset-password

It must:

modify system files

be usable by normal users

run with root privileges

❓ What do you use?
SUID
✅ Solution
chown root:root /usr/local/bin/reset-password
chmod 4755 /usr/local/bin/reset-password
🔍 Why
4 → SUID

Effect:

script runs as root (owner), not the user
⚠️ VERY IMPORTANT (LFCS awareness)
SUID is dangerous

Only use when absolutely required.

🧠 SCENARIO 4 — Trick Question (COMMON)
Situation

Shared directory:

/shared/dev

You set:

chmod 777 /shared/dev

Users complain:

"My files keep getting deleted"
❓ What’s missing?
Sticky bit
✅ Fix
chmod 1777 /shared/dev
🧠 SCENARIO 5 — Another Trick (VERY COMMON)
Situation

You set:

chmod 775 /shared/dev

But group ownership is inconsistent.

❓ What’s missing?
SGID
✅ Fix
chmod 2775 /shared/dev
⚡ Decision Table (LOCK THIS IN)
Situation	Use
Run as owner (root)	SUID (4)
Shared group directory	SGID (2)
Prevent file deletion	Sticky (1)
🧠 Ultra-fast mental model
SUID   → privilege escalation
SGID   → group consistency
Sticky → deletion protection
⚡ Exam shortcut (this saves time)

If you see:

shared directory + collaboration

👉 SGID

If you see:

public write directory + prevent deletion

👉 Sticky

If you see:

normal user needs root-level action

👉 SUID

🧠 Final compression (this is the one to remember)
4 → run as owner
2 → inherit group
1 → protect deletes
