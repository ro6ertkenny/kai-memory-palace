# 🧬 ACLs and the ACL Mask

## 🧠 Mental Model

ACLs are a superset of traditional permissions.  
Traditional permissions are just the simplest possible ACL.

---

## 🧱 Base ACL entries

user::rwx
group::rwx
other::r-x

These correspond to:

rwxrwxr-x

- user:: = owner
- group:: = group
- other:: = everyone else

The double colon :: means:

“This is the base permission, not a named exception.”

Baseline state:

- No named users
- No named groups
- No mask line
- No default ACLs

So behavior is exactly like chmod.

---

## 🔍 Example with mask (real lab)

user::rwx
user:nobody:r-x
group::rwx        #effective:r-x
mask::r-x
other::r-x

---

## 🧠 The key idea

The mask is the maximum allowed permissions for:

- all named users
- and the group class

Effective permission = ACL entry AND mask

That’s why:

group::rwx   #effective:r-x

The mask is clamping it.

---

## 🧨 Why chmod sometimes lies

Because:

- chmod g+w might change group:: or the mask
- But named entries still exist
- And the mask may still clamp them

So:

ls -l may not show the real behavior.

---

## 🛠️ Commands

getfacl PATH
setfacl -m u:USER:PERMS PATH
setfacl -m g:GROUP:PERMS PATH
setfacl -m m:PERMS PATH

EOF

