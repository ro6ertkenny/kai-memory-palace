# Users and Groups in Linux

This document explains what users and groups really are in Linux, how identity is resolved, and why names like marshall are just labels over numeric IDs.

---

## Core concept

Linux does not care about usernames.
It cares about numeric identities:

- UID = User ID (number)
- GID = Group ID (number)

User and group names (root, marshall, sudo) are human-friendly labels mapped to those numbers.

---

## UID and GID vs names

- Every process runs as a UID and GID
- Files store numbers, not names
- The system resolves numbers to names using name service sources

To view numeric owners/groups:

ls -ln

---

## /etc/passwd

The passwd database maps username -> UID/GID and other account fields.

Query safely with getent:

getent passwd marshall

Field layout:

name:x:UID:GID:comment:home:shell

Notes:
- The x means the password hash is stored elsewhere (see /etc/shadow)

---

## /etc/group

The group database maps group name -> GID and supplementary members.

Query:

getent group marshall
getent group sudo

Field layout:

groupname:x:GID:members

---

## getent is the correct interface

Do not rely on reading /etc/passwd and /etc/group directly in automation.
Use getent because identity may come from multiple sources.

Examples:

getent passwd marshall
getent group sudo

---

## NSS (Name Service Switch)

NSS controls where identity data is sourced and in what order.

Config file:

/etc/nsswitch.conf

Typical entries:

passwd: files systemd
group:  files systemd

---

## Primary vs supplementary groups

Check effective identity:

id marshall

Primary group:
- The GID field in the passwd entry

Supplementary groups:
- Memberships listed in group entries

---

## Why you see: marshall : marshall sudo

Because the user marshall has:
- primary group marshall
- supplementary group sudo

Verify:

id marshall
getent group sudo

---

## Key commands

id marshall
getent passwd marshall
getent group marshall
getent group sudo

---

## Exam memory hook

Linux enforces ownership and permissions using numeric IDs, not names
