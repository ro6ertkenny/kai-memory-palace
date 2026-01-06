# 🧪 LFCS Day 1 — Storage, Files, Archives, Inspection

## 🎯 Scope

This day covered:

- Files, permissions, inodes, links
- Filesystem inspection and disk usage
- Archives and compression with tar
- Filesystem layout and mounts
- Low-level vs human-readable inspection tools

Mental mode: **Inspect → Understand → Verify**

---

## 📁 Files, Inodes, and Links

### Inodes
- An **inode** is the metadata record for a file (owner, perms, timestamps, pointers to data).
- Filenames point to inodes; the inode points to the data.

### Show inode number
```bash
ls -li file.txt
```

### Hard vs Soft (Symbolic) Links

- **Hard link**: another name for the same inode (same data, same inode number).
- **Symbolic link**: a pointer to a pathname (different inode, can break).

Recognize symlink:
```bash
ls -l
# starts with: l
# shows: linkname -> target
```

Check link target:
```bash
readlink linkname
```

Broken symlink:
- `ls` shows it in red (or with a warning)
- `stat` fails on the target

Deleting the link does **not** delete the target.

---

## 📄 Understanding `ls -l` Columns

Example:
```
-rw-rw-r-- 1 ro6ert ro6ert 7061 Jan 5 09:19 bash-basics.md
```

Left to right:

1. `-` or `d` or `l` → type (file, dir, symlink)
2. `rw-rw-r--` → permissions (user, group, others)
3. `1` → **link count** (hard links to this inode)
4. `ro6ert` → owner
5. `ro6ert` → group
6. `7061` → file size (bytes)
7. date/time → timestamps
8. name → filename

---

## 🔐 Permissions and Numbers

Memory hook:
```
r = 4
w = 2
x = 1
```

So:
```
664 = rw- rw- r--
755 = rwx r-x r-x
```

Set permissions:
```bash
chmod 664 file.txt
chmod +x script.sh
```

A file is executable if:
- it has the `x` bit
- and (for scripts) a **shebang** exists:
```bash
#!/usr/bin/env bash
```

---

## 🧠 `stat` — File Metadata

```bash
stat file.txt
```

Key fields:

- **Size**: file size in bytes
- **Blocks**: how many 512-byte blocks are allocated on disk
- **IO Block**: filesystem block size (usually 4096)
- **Device 8,4**: major/minor device number
- **Inode**: inode number
- **Links**: hard link count
- **Access/Modify/Change/Birth**:
  - Access = read
  - Modify = content changed
  - Change = metadata changed
  - Birth = creation time (may change after copy/restore)

Filesystem view:
```bash
stat -f /home
```
Shows:
- block size
- total blocks
- free blocks
- inode counts
- name length limit (`Namelen` = max filename length, usually 255)

> `stat` is intentionally **not human-readable**. Use `df -h` or `du -h` for that.

---

## 📊 Disk Usage vs Filesystem Usage

### Filesystem capacity:
```bash
df -h
df -hi   # inode usage
```

### Directory usage:
```bash
du -sh /path
```

### Block devices:
```bash
lsblk
lsblk -f
```

Important columns to understand:

From `lsblk`:
- NAME
- SIZE
- TYPE (disk, part)
- MOUNTPOINTS

From `lsblk -f`:
- FSTYPE
- UUID
- FSAVAIL
- FSUSE%
- MOUNTPOINTS

---

## 💾 Mounts and `findmnt`

```bash
findmnt
```

Key ideas:
- `/home` is `rw` → user-writable
- `/boot/efi` is `vfat` with masks → intentionally restricted

Common mount flags:
- `rw` = read/write
- `ro` = read-only
- `noexec` = cannot execute binaries
- `nosuid` = ignore SUID bits
- `nodev` = ignore device files

---

## 🧱 UEFI (Exam Definition)

**UEFI (Unified Extensible Firmware Interface)** is the modern firmware that initializes hardware and hands control to the OS, replacing legacy BIOS.  
It uses a dedicated **EFI System Partition** (usually `/boot/efi`) and supports GPT, Secure Boot, and faster startup.

---

## 📦 Archives with `tar`

Create archive:
```bash
tar -cf input.tar input/
```

List contents:
```bash
tar -tf input.tar
```

Extract:
```bash
tar -xf input.tar
tar -xf input.tar -C /some/dir
```

Compression:
```bash
tar -czf input.tar.gz input/   # gzip
tar -cJf input.tar.xz input/   # xz
```

List compressed:
```bash
ls -lh *.tar*
```

Key flags:
- `c` = create
- `t` = list
- `x` = extract
- `f` = file
- `z` = gzip
- `J` = xz

---

## 🧭 Navigation Shortcuts

```bash
cd /        # go to root
cd ~        # go to home
cd -        # go to previous directory
cd ../../.. # go up multiple levels
```

---

## 🧠 Exam Rules

- Use `df -h` for space
- Use `df -hi` for inodes
- Use `lsblk` for layout
- Use `findmnt` for truth
- Use `stat` for metadata
- Never guess — inspect first

