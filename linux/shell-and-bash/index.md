# 🐚 Shell & Bash — Index
*Command-line fluency, execution models, and safe control of Linux systems*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`linux/shell-and-bash` wing.

It answers the question:

> “How do I control a Linux system confidently from the command line,
without relying on copy-paste or guesswork?”

This wing treats the shell as a **language and execution environment**,
not just a place to type commands.

---

## 🧠 Mental Model

The shell is the **primary interface** between you and Linux.

Understanding the shell means understanding:

- how commands are parsed
- how processes are started
- how input and output flow
- how the environment influences behavior
- how failures propagate

Most Linux and Kubernetes errors are **shell-visible first**.

---

## 🔁 Recommended Learning Order

Read these documents **in order** to build durable command-line intuition.

---

### 1️⃣ `README.md`
Defines:
- scope and learning posture
- what “shell fluency” actually means
- why the shell comes *before* deeper Linux topics

Start here to align expectations.

---

### 2️⃣ `bash/README.md`
Defines:
- what Bash is (and is not)
- how it differs from other shells
- when Bash behavior matters operationally

This frames Bash as a **tool**, not an identity.

---

### 3️⃣ `bash/bash-basics.md`
Defines:
- command structure
- arguments and flags
- quoting and escaping
- exit codes

This is the foundation of correctness.

---

### 4️⃣ `bash/bash-pipelines.md`
Defines:
- stdin, stdout, stderr
- pipes and redirection
- chaining commands safely

This explains *how commands talk to each other*.

---

### 5️⃣ `bash/bash-expansion.md`
Defines:
- globbing
- variable expansion
- command substitution

Many “mystery bugs” originate here.

---

### 6️⃣ `bash/bash-history-and-job-control.md`
Defines:
- command history
- background vs foreground jobs
- signals and interruption

This improves speed **without sacrificing safety**.

---

### 7️⃣ `bash/mistakes.md`
Catalogs:
- common Bash errors
- destructive patterns
- subtle footguns

Revisit this often.

---

## ⚠️ Common Shell Traps (Callout)

> **⚠️ Mistake:** Treating the shell as a command launcher  
> The shell is an interpreter. Misunderstanding this causes subtle bugs.

> **⚠️ Mistake:** Memorizing commands without understanding flow  
> Pipes, redirection, and exit codes matter more than flags.

---

## 🔗 Relationship to Other Wings

- `vim/`  
  The shell is useless if editing is painful

- `linux/foundations/`  
  Explains what the shell is controlling

- `linux/networking/`  
  Shell tools expose networking state

- `k8s/ops+provisioning/`  
  Most cluster operations begin in a shell

Shell fluency multiplies every other skill.

---

## ▶️ How to Use This Wing

- New to Linux → read top to bottom
- Rusty with Bash → focus on expansion and pipelines
- Debugging failures → inspect exit codes and redirection

If you understand how the shell executes commands,
Linux behavior becomes predictable.

---
