# Bind Mounts and Namespace Grafting

This document explains what a bind mount is and why it proves that mounting is about the namespace, not just disks.

---

## What a bind mount is (simple definition)

A bind mount makes one directory appear at another path.

No copying.
Same files.
Two doorways to the same room.

---

## Syntax

mount --bind <source_dir> <target_dir>

Both directories must already exist.

---

## What is really happening

You are not mounting a new filesystem.

You are exposing a subtree of an existing filesystem at another path.

That is why findmnt shows:

/dev/sda4[/some/subdir]

It means:
"A subdirectory of this filesystem is mounted here."

---

## Stacked mounts (layers)

Mounts stack.

If you bind-mount again on the same target, you get multiple layers.

Unmount removes one layer at a time.

This is why sometimes people say:

"I unmounted it, but it's still mounted!"

Answer:

There was more than one layer.

---

## Why this matters in real life

This exact situation happens in:

- Containers
- systemd mount units
- Kubernetes
- chroots
- recovery environments

Understanding stacking prevents serious confusion during debugging.

---

## Mental model

Bind mounts prove:

The Linux filesystem is a composable namespace, not just a set of disks.

---
