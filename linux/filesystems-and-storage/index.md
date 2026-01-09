# 🗂️ Filesystems & Storage — Index
*Operational clarity for where data lives, why it’s visible, and how to recover it safely*

---

## 📌 Purpose

This index provides the **structured navigation map** for the
`linux/filesystems-and-storage` wing.

It answers the questions:

- “Why can’t I access this path?”
- “Why did data ‘disappear’?”
- “What is mounted where — and why?”
- “How do I change filesystem state without breaking the system?”
- “How do I validate persistence and recover it safely?”

This wing builds **operational clarity**: predictable, inspectable, fixable.

---

## 🧠 Mental Model

Filesystem behavior is governed by four layers:

1) **Namespace**  
   What is mounted where (the live mount tree)

2) **Identity and policy**  
   Who is acting (user/group) and what privileges exist

3) **Object metadata**  
   Ownership, permissions, links, attributes

4) **Storage state**  
   The health of the filesystem on disk (consistency, recovery)

Most failures are explained by identifying which layer is broken.

---

## 🔁 Recommended Learning Order

Read these documents **in order** to build correct system intuition.

---

### 1️⃣ `README.md`
Defines:
- scope
- mental mode
- how this wing differs from foundations or shell content

Start here.

---

### 2️⃣ `filesystem-and-perms.md`
Defines:
- path resolution (absolute vs relative)
- ownership and permissions evaluation
- directory semantics and execute bit behavior
- sudo boundaries
- how to diagnose permission failures

This is the primary reference for access failures.

---

### 3️⃣ `mounting-and-unmounting.md`
Defines:
- the live mount tree (namespace grafting)
- device vs filesystem vs mountpoint
- inspecting mounts: mount, findmnt, /proc/self/mounts
- loop mounts (filesystem inside a file)
- “target is busy”, fuser/lsof, lazy unmount

Core mental model:

Linux is not one disk.  
It is a tree of mountpoints built from multiple filesystems.

---

### 4️⃣ `bind-mounts-and-namespace-grafting.md`
Defines:
- what a bind mount is (one directory appears at another path)
- no copying: same data, two doorways
- mounting subtrees (/dev/sda4[/subdir])
- stacked mounts and why “it’s still mounted” happens

This proves the namespace is composable.

---

### 5️⃣ `fstab-and-persistent-mounts.md`
Defines:
- /etc/fstab as the declarative boot-time plan
- UUID-based device identity
- fstab line format:
  <what> <where> <type> <options> <dump> <pass>
- dump/pass intuition (1 first, 2 later, 0 never)
- validating safely with:
  sudo findmnt --verify

Mental model:
fstab -> systemd -> mount syscalls -> live mount tree

---

### 6️⃣ `fsck-and-recovery-basics.md`
Defines:
- what fsck is and what it checks
- why it must not be run on mounted filesystems
- “offline check” workflow
- forced checks (-f)
- pass-based checks at boot

Big mental model:

fsck works on on-disk data structures.  
Mounting uses those same structures live.  
Running fsck while mounted risks corruption.

---

### 7️⃣ `filesystem-debugging-checklist.md`
Defines:
- an exam-grade workflow to debug:
  - “missing data”
  - mount failures
  - busy unmounts
  - stacked mounts
  - fstab issues
  - when to use fsck

Use this as your “runbook” under pressure.

---

## ⚠️ Common Operational Mistakes

> **⚠️ Mistake:** Debugging permissions without checking mounts  
> If the wrong filesystem is mounted, permissions are not the problem.

> **⚠️ Mistake:** Running fsck on a mounted filesystem  
> fsck and the kernel can modify the same metadata and corrupt the filesystem.

> **⚠️ Mistake:** Assuming unmount removes all layers  
> Mounts can stack. Unmount removes one layer at a time.

---

## 🔗 Relationship to Other Wings

- `linux/foundations/`  
  Explains the primitives (system state, processes, baseline permissions theory)

- Accounts + Privilege (currently in `linux/foundations/`)  
  Identity, authentication, privilege (who is acting)

- `linux/shell-and-bash/`  
  Provides the tooling and muscle memory to execute safely

- `k8s/*`  
  Kubernetes volumes and container filesystems mirror these primitives

This wing is where “storage stopped behaving” becomes explainable.

---

## ▶️ How To Use This Wing

- Learning → read top to bottom
- Debugging → start with:
  1) `findmnt /path`
  2) `lsblk -f`
  3) identity + permissions
- Recovery → verify unmounted, then fsck (offline)

---

## ✅ Outcome

After completing this wing, you should be able to say:

- I know what is mounted where and why
- I know why a path shows what it shows
- I can diagnose access failures without guessing
- I can validate persistence before reboot
- I can recover safely from common filesystem failures

That is storage fluency.

---

