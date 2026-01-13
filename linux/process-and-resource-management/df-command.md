# df — Disk Free

df historically means “disk free”.

It reports filesystem-level usage, not directory usage.

---

What it tells you

- total size
- used space
- available space
- percentage used
- mount point

---

Two critical modes

df -h  -> space usage  
df -i  -> inode usage

You can run out of inodes even with free space.

---

Mental Model

df answers:

Which filesystem is full?

du answers:

Which directory is using the space?
EOF

