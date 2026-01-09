## 🪨 Filesystem Attributes — chattr and lsattr

## 🧠 Mental model

+i = nothing can change it  
+a = you can only append  

Both are:

Below permissions, below ACLs, below ownership  
Enforced by the filesystem itself.

---

## 🧱 The rule (lock this in)

Filesystem attributes override:

- rwx permissions
- ACLs
- ownership
- even root (unless root removes the attribute)

---

## 🛠️ Commands

sudo chattr +i file   → set immutable  
sudo chattr -i file   → remove immutable  

sudo chattr +a file   → set append-only  
sudo chattr -a file   → remove append-only  

lsattr file           → list attributes

---

## 🔒 Immutable behavior

- Cannot delete
- Cannot modify
- Cannot append
- Cannot rename

Even root is blocked until the attribute is removed.

---

## 🧾 Append-only behavior

- Cannot overwrite
- Cannot delete
- Can only append using >>

EOF

