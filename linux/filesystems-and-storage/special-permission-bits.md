# 🔐 Special Permission Bits — SUID, SGID, Sticky

## 🧠 Mental Model (lock this in first)

Normal permissions answer:

- “Who can read/write/execute?”

Special bits answer:

- “Under whose identity does this run?”
- “Who really owns new files?”
- “Who is allowed to delete things here?”

They modify the rules of execution and deletion, not just access.

---

## 🧱 The Three Special Bits

| Bit | Name | Affects | Meaning |
|-----|------|----------|----------|
| SUID | Set User ID | Executable files | Run as file owner |
| SGID | Set Group ID | Files / Directories | Run as file’s group / new files inherit group |
| Sticky | Sticky bit | Directories | Only owner/root can delete files |

---

## 🧠 How to READ the permission string

Example:

-rwsr-sr-t

Positions:

[user][group][other]
  s      s      t

Rules:

- s replaces x in user or group slot
- t replaces x in other slot
- Uppercase S or T = bit set but execute bit missing (misconfiguration)

---

## 🔍 Real examples

### /usr/bin/passwd (SUID)

-rwsr-xr-x 1 root root ... /usr/bin/passwd

Breakdown:

- r w s r - x r - x
  ^ ^ ^
  | | |
  | | └─ s = SUID is set (replaces user execute bit)
  | └── w = owner can write
  └──── r = owner can read

Why:

passwd must modify:

/etc/shadow

Which is only writable by root.

So:

passwd runs as root, even when you run it.

That’s SUID.

---

### /tmp (Sticky)

drwxrwxrwt ... /tmp

Breakdown:

d r w x r w x r w t
                  ^
                  └─ t = sticky bit

Meaning:

- Anyone can write to /tmp
- But only the owner of a file or root can delete it

Without sticky bit:

Any user could delete any other user’s temp files.

---

### /var/mail (SGID)

drwxrwsr-x 2 root mail ... /var/mail

Breakdown:

d r w x r w s r - x
            ^
            └─ s = SGID is set (replaces group execute bit)

Meaning:

Any file created inside inherits the directory’s group, not the user’s primary group.

Why this exists:

- Shared dirs (mail spools, logs, projects)
- Multiple users and programs
- Must share group ownership
- Without SGID → mixed groups and broken access

---

## 🧠 Key mental model

- SUID → changes who the program runs as
- SGID → changes what group new files belong to
- Sticky → changes who is allowed to delete

These are not about rwx.  
They are about identity and authority.

---

## 🔎 Find SUID programs

find /usr/bin /usr/sbin -perm -4000 2>/dev/null

Meaning:

- -perm -4000 → match files with SUID bit set
- 2>/dev/null → hide permission errors

---

## 🧠 chmod numbers (common)

Permissions digits: user / group / other  
4 = r, 2 = w, 1 = x

- 755 = rwx r-x r-x
- 775 = rwx rwx r-x
- 644 = rw- r-- r--
- 600 = rw- --- ---
- 700 = rwx --- ---
- 2775 = SGID + rwx rwx r-x
- 4755 = SUID + rwx r-x r-x
- 1777 = Sticky + rwx rwx rwx

What 755 means:

chmod 755 file
- owner: 7 = 4+2+1 = rwx
- group: 5 = 4+1   = r-x
- other: 5 = 4+1   = r-x

What 2775 means:

chmod 2775 dir
- leading 2 = SGID bit
- 775 = rwx rwx r-x

EOF

