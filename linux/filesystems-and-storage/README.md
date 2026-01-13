# 💽 Filesystems & Storage — README

## 🎯 Purpose

This wing teaches how Linux **stores data**, **finds it again**, and **fails when storage is stressed**.

Storage failures are among the **most destructive and least forgiving** classes of incidents.

This wing exists to make:
- disk behavior predictable
- space usage explainable
- mounts and filesystems non-mysterious
- storage incidents survivable

---

## 🧠 Mental Mode
**Persistence and I/O**

You should be able to:
- explain where data lives
- explain how it is mounted
- explain why something is full
- explain what is safe to delete and what is not
- recover from space pressure without breaking the system

---

## 🧭 Scope

This domain focuses on:
- filesystem hierarchy
- block devices and partitions
- mounts and mount options
- disk space and inode exhaustion
- usage inspection and triage
- safe recovery patterns

Included:
- filesystems, partitions, and mounts
- disk usage and inode usage
- finding where space went
- interpreting df and du
- space pressure failure modes

Excluded:
- filesystem internals
- performance tuning
- advanced RAID/LVM internals

---

## 📁 Directory Navigation

Core docs:

- `block-devices-and-identifiers.md`
- `mounting-and-unmounting.md`
- `fstab.md`
- `filesystem-hierarchy.md`
- `disk-usage-and-du.md`

Day 9 operator doctrine:

- `df-command.md`  
  The **filesystem pressure indicator** and first question:
  > “Which filesystem is full?”

---

## 🧪 How To Use This Wing

Use this wing when:
- something says “No space left on device”
- writes are failing
- systems behave strangely under load
- containers fail due to disk pressure
- logs stop writing

Start with:

1) `df-command.md` → which filesystem is full?  
2) `disk-usage-and-du.md` → where did the space go?

---

## ⚠️ Storage Rules

- Never delete before you know **which filesystem** is full
- Never delete before you know **which directory tree** is responsible
- Never delete system files blindly
- Always confirm free space after cleanup

---

## ✅ Outcome

You should be able to say:

I can explain where disk space is going,  
I can find what is consuming it,  
and I can recover space **without damaging the system**.

That is storage fluency.
EOF

