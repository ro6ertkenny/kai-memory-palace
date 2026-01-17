# 💽 Filesystems & Storage — README
*Understanding where data lives, how it’s exposed, and how it fails*

---

## 🎯 Purpose

This wing teaches how Linux:

- **stores data**
- **exposes it through a mount namespace**
- **runs out of space**
- **lies about space**
- **breaks**
- and **recovers**

Storage failures are among the **most destructive and least forgiving** classes of incidents.

This wing exists to make:

- disk behavior predictable
- space usage explainable
- mounts non-mysterious
- storage incidents survivable

---

## 🧠 Mental Mode

**Persistence, layering, and recovery**

You should be able to:

- explain where data lives
- explain how it is mounted
- explain why something is full
- explain why something “disappeared”
- explain what is safe to delete and what is not
- recover from storage failures without guessing

---

## 🧭 Scope

This wing focuses on **operator-level storage reality**:

- block devices and partitions
- filesystems and mount trees
- fstab and persistence
- disk space vs inode exhaustion
- virtual filesystems (/proc, /sys, tmpfs, cgroup, overlay)
- network block devices (iSCSI, NBD)
- LVM layering and growth
- filesystem checking and recovery

Included:

- mounts and mount namespaces
- disk and inode pressure
- fsck and recovery workflows
- LVM inspection and extension
- virtual and network-backed storage

Excluded:

- filesystem internals
- performance tuning
- advanced RAID internals

---

## 🗺️ How This Wing Is Organized

The canonical navigation order lives in:

> `index.md`

Conceptually, the flow is:

1) Namespace (what is mounted where)
2) Filesystem (what is stored there)
3) Space & inodes (why it is “full”)
4) Virtual filesystems (what is not real storage)
5) LVM (how disks become flexible)
6) Recovery (fsck, unmount, repair)

---

## 🧪 When To Use This Wing

Use this wing when:

- something says “No space left on device”
- writes start failing
- systems go read-only
- containers fail due to disk pressure
- mounts behave strangely
- reboots break the system

Start with:

1) `df-command.md` → which filesystem is full?  
2) `filesystem-debugging-checklist.md` → follow the runbook

---

## ⚠️ Storage Rules

- Never delete before you know **which filesystem** is full
- Never delete before you know **which directory tree** is responsible
- Never run fsck on a mounted filesystem
- Never assume “disk full” means “disk problem”
- Always verify free space after cleanup

---

## 🧱 Relationship to Other Wings

- `linux/foundations/` explains identity and permissions
- `linux/process-and-resource-management/` explains swap and memory pressure
- `linux/networking/` explains network filesystems and paths
- `k8s/*` uses these same primitives under different names

---

## ✅ Outcome

You should be able to say:

- I can explain where data lives
- I can explain why space is gone
- I can reason about mounts, LVM, and virtual filesystems
- I can recover from storage failures **without making them worse**

That is **storage operator fluency**.

