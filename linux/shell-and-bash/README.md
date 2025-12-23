# 🐚 Shell & Bash — README

## 🎯 Purpose
Build **command-line fluency** for Linux systems.

This directory exists to make interacting with Linux **intentional, predictable, and efficient** through the shell, with Bash as the primary interface.

The shell is not a topic to memorize.  
It is the environment through which Linux is operated.

---

## 🧠 Mental Mode
**Issuing intent through commands**

- think before typing
- understand what will execute
- verify what actually happened

You are not “trying commands.”  
You are **directing the system**.

---

## 🧩 Shell vs Bash (Explicit)
This directory intentionally combines both concepts.

- **Shell**: core ideas  
  - commands
  - arguments
  - streams (stdin, stdout, stderr)
  - processes and job control
  - redirection and pipelines

- **Bash**: the primary implementation  
  - interactive usage
  - expansions
  - history
  - job control
  - scripting primitives

Bash is how you *practice* shell concepts day to day.

---

## 🧭 Scope
This directory focuses on **practical, durable shell usage** needed for:

- Linux administration
- Kubernetes work
- SSH-only environments
- exams (LFCS, CKA)

Included:
- interactive Bash usage
- pipelines and redirection
- expansions and quoting
- job control
- command composition
- safe recovery from mistakes

Excluded:
- shell history and theory
- exotic shells
- advanced scripting patterns (for now)
- GUI tooling

If it does not help you operate a Linux system at the terminal, it does not belong here.

---

## 📁 Directory Layout

### `shell-and-bash/README.md`
This file.
- defines scope
- sets mental model
- explains structure

---

### `shell-and-bash/index.md`
Practice navigation.
- what to work on
- in what order
- when to revisit fundamentals

This is the daily entry point.

---

### `shell-and-bash/bash/`
Bash-specific mechanics.

This directory contains focused files for:
- Bash basics
- pipelines and redirection
- expansion and quoting
- history and job control
- common Bash mistakes

These files are **hands-on and drillable**.

---

## ⏱️ Practice Discipline
Practice mirrors the Vim wing.

- short sessions
- real commands
- no copy/paste dependence
- verify output every time

Commands are learned by **use**, not reading.

---

## 🧪 Operating Rule
Before running a command, you should know:
- what it targets
- what it outputs
- what state it may change

If you cannot answer those, pause.

---

## ✅ Outcome
The terminal stops feeling fragile.

You type commands.  
The system responds.  
You observe, adjust, and proceed.
