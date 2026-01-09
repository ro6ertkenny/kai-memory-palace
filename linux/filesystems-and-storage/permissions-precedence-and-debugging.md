# 🧱 Permissions Precedence and Debugging

## 🧠 The True Evaluation Stack

Linux checks in this order:

1) Mount options (ro, noexec, nosuid, nodev)
2) Filesystem attributes (immutable, append-only)
3) ACLs (mask!)
4) Special bits (SUID, SGID, sticky)
5) Traditional rwx permissions

---

## 🧠 Rule

If something “makes no sense”:

You are debugging the wrong layer.

---

## 🧪 Symptom → Check

- Can’t delete even as root → lsattr
- chmod behaves weird → getfacl
- User can write unexpectedly → ACL
- Something runs as root → SUID
- Files look wrong → findmnt

EOF

