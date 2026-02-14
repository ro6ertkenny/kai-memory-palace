# Users and Groups in Linux

Linux enforces access using **numeric identities**, not names.

- UID = User ID (number)
- GID = Group ID (number)

User/group names are labels that map to these numbers.

---

## Core mental model

- Processes run as UID/GID (effective identity).
- Files store **UID/GID numbers** in metadata.
- Name resolution maps numbers ↔ names via NSS.

Show numeric ownership:

    ls -ln

---

## Identity databases

### /etc/passwd (user database)

Maps: username → UID/GID + account fields

Preferred query interface:

    getent passwd marshall

Format:

    name:x:UID:GID:comment:home:shell

Notes:
- `x` means the password hash is stored in `/etc/shadow`

### /etc/shadow (password hashes + aging)

Restricted file (root only):

    sudo ls -l /etc/shadow

Inspect password aging for a user:

    sudo chage -l marshall

### /etc/group (group database)

Maps: group name → GID + member list

Query:

    getent group sudo

Format:

    groupname:x:GID:members

---

## NSS (Name Service Switch)

Identity can come from multiple sources (files, LDAP, etc.). Always prefer `getent`.

Config:

    cat /etc/nsswitch.conf

Typical:

    passwd: files systemd
    group:  files systemd

---

## Primary vs supplementary groups

Show effective identity:

    id marshall

Primary group:
- the GID field in the passwd entry

Supplementary groups:
- memberships listed in group entries

---

## Group membership: read + change

List a user’s groups:

    id marshall
    groups marshall

Inspect a group:

    getent group sudo

Add user to supplementary group (preferred via usermod):

    sudo usermod -aG sudo marshall

Remove user from a group (Debian/Ubuntu):

    sudo gpasswd -d marshall sudo

---

## Key commands (identity resolution)

    id marshall
    getent passwd marshall
    getent group marshall
    getent group sudo
    ls -ln

---

## LFCS operator failure scenarios

### “Who owns this file?”
1. Check numeric owner/group
2. Resolve UID/GID to names

    ls -ln target
    getent passwd <UID>
    getent group <GID>

### “User appears in /etc/passwd but login fails”
Check:
- shell path
- password aging / locked status
- home directory existence

    getent passwd marshall
    sudo chage -l marshall
    sudo ls -ld /home/marshall

---

## Related drills

- Execution drills directory:
  - ../LFCS-training/execution-drills/

---

## Exam memory hook

Linux enforces ownership and permissions using **numeric IDs**, not names.

