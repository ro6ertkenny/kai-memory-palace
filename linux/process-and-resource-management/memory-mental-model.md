# 🧠 Memory Mental Model

## 🎯 Purpose

This document explains **how Linux actually uses memory**.

Not:
- myths
- Windows mental models
- “free memory good, used memory bad”

But:
- how the kernel treats RAM
- what is reclaimable
- what is not
- and what “memory pressure” really means

---

## 🧠 The Core Truth

> **Unused memory is wasted memory.**

Linux will aggressively use RAM for:

- page cache
- buffers
- filesystem metadata
- performance optimization

This is **good**.

Low “free” memory is **normal**.

---

## 🧱 The Three Big Buckets

Linux memory is conceptually split into:

1) Application memory
2) Cache / buffers
3) Free memory

But the **important distinction** is:

- Reclaimable memory
- Unreclaimable memory

---

## 🧠 Reclaimable vs Unreclaimable

### Reclaimable memory

This includes:

- page cache
- buffers
- filesystem cache

The kernel can:

- drop it
- reuse it
- give it back to applications

This memory is **not a problem** under pressure.

---

### Unreclaimable memory

This includes:

- application heap
- stack
- pinned kernel memory
- some shared memory

The kernel **cannot** take this back.

If this grows too large:

- the system starts swapping
- or the OOM killer runs

---

## 🔍 Why “Free” Memory Being Low Is Normal

Run:

    free -h

You will often see:

- free is small
- used is large

This does **not** mean:

- you are low on memory
- you are in trouble

What matters is:

- available

Available ≈ how much memory the kernel can still give to programs **without pain**.

---

## 🧠 Mental Model: Memory Is a Cache First

Think of RAM as:

- first: a giant cache
- second: application memory

Linux prefers:

- to keep things in RAM
- because RAM is fast
- and can be reclaimed if needed

---

## 🔁 What Happens Under Pressure

When applications ask for more memory:

1) Kernel tries to reclaim cache
2) Kernel tries to drop buffers
3) Kernel may start swapping
4) If still insufficient → OOM killer runs

OOM is **last resort**.

---

## 🧠 Swap Is Not “More RAM”

Swap is:

- an emergency pressure valve
- a way to avoid immediate OOM
- a performance disaster if used heavily

A swapping system is a **sick system**.

---

## 🧠 The Operator Question

When you look at memory, always ask:

- Is this memory reclaimable?
- Or is it unreclaimable?

If reclaimable is high → system is healthy.

If unreclaimable is high and growing → you are approaching failure.

---

## 🧭 Practical Interpretation Checklist

When you run:

    free -h

You should think:

- Is available healthy?
- Is swap being used?
- Is swap growing?
- Does this look stable or trending toward pressure?

---

## ⚠️ Common Myths

- “Free memory should be large” → false
- “Linux is using too much memory” → false
- “Cache is waste” → false
- “Swap is fine” → only in small amounts

---

## 🏁 Outcome

You should now be able to explain:

- Why low free memory is normal
- What reclaimable memory is
- What unreclaimable memory is
- What memory pressure actually means
- Why OOM happens
- Why swap is a warning sign, not a solution

This is the foundation for all memory operations.
EOF

