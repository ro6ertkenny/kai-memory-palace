# 📖 man-basics — How to Read Linux Man Pages

## 🎯 Purpose

Man pages are the **authoritative reference** during LFCS.

You must be able to:
- find options
- decode SYNOPSIS
- understand argument patterns
- page, search, and quit efficiently

---

## 🧭 Opening a Man Page

```bash
man ls
man stat
man tar
```

---

## 📚 Sections You Care About

- **NAME** → what it is
- **SYNOPSIS** → how to call it
- **DESCRIPTION** → what it does
- **OPTIONS** → flags
- **EXAMPLES** → patterns (gold)

---

## 🔎 The SYNOPSIS Pattern

Example:
```
cp [OPTION]... SOURCE DEST
cp [OPTION]... SOURCE... DIRECTORY
cp [OPTION]... -t DIRECTORY SOURCE...
```

How to read this:

- `[OPTION]...` → zero or more options
- `SOURCE...` → one or more sources
- `DEST` / `DIRECTORY` → required argument
- `-t DIRECTORY` → flag that changes argument order

Brackets `[]` = optional  
Ellipsis `...` = repeatable

---

## 🧠 Example Flags Explained

From `cp`:

- `-T` → treat DEST as a normal file, not directory
- `-t DIR` → specify target directory first

---

## 📖 What is a Pager?

A **pager** is a program that lets you scroll output one screen at a time.

Common pagers:
- `less` (most common)
- `more`

Man uses a pager internally.

Pager controls:
- `Space` / `PgDn` → forward
- `b` / `PgUp` → back
- `/word` → search
- `n` → next match
- `q` → quit

---

## 🧠 Reading Strategy (LFCS)

1. Skim NAME
2. Jump to SYNOPSIS
3. Jump to OPTIONS
4. Search for what you need:
```bash
/manword
```

---

## 🧱 Golden Rule

> **Man pages are not books. They are lookup tables.**

