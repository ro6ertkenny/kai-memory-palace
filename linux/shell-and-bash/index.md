# 🐚 Shell & Bash — Index

## 🎯 Purpose
This index is the **navigation and learning map** for the
`linux/shell-and-bash` wing.

It answers one question:

How do I control a Linux system confidently from the command line,
without copy-paste or guesswork?

The shell is treated as an **execution environment**, not a command launcher.

---

## 🧠 Mental Model
The shell is the primary interface between you and Linux.

Shell fluency means understanding:
- how commands are parsed
- how processes are started
- how input and output flow
- how the environment affects behavior
- how failures surface

Most Linux and Kubernetes problems are **shell-visible first**.

---

## 🔁 Recommended Learning Order
Follow this order to build durable command-line intuition.

---

### 1. `README.md`
Defines:
- scope and posture
- what “shell fluency” means
- why the shell comes before deeper Linux topics

Start here.

---

### 2. `bash/README.md`
Defines:
- what Bash is and is not
- when Bash-specific behavior matters
- how Bash fits into Linux operations

This frames Bash as a tool, not an identity.

---

### 3. `bash/bash-basics.md`
Covers:
- command structure
- arguments and flags
- quoting and escaping
- exit codes

This is the foundation of correctness.

---

### 4. `bash/bash-pipelines.md`
Covers:
- stdin, stdout, stderr
- pipes and redirection
- chaining commands safely

This explains how commands communicate.

---

### 5. `bash/bash-expansion.md`
Covers:
- globbing
- variable expansion
- command substitution

Many subtle bugs originate here.

---

### 6. `bash/bash-history-and-job-control.md`
Covers:
- command history
- foreground vs background jobs
- signals and interruption

This improves speed without sacrificing safety.

---

### 7. `bash/mistakes.md`
Catalogs:
- common Bash errors
- destructive patterns
- subtle footguns

Revisit this regularly.

---

## ⚠️ Common Shell Traps
- treating the shell as a command launcher instead of an interpreter
- memorizing commands without understanding data flow
- ignoring exit codes and redirection

These mistakes compound quickly.

---

## 🔗 Relationship to Other Wings
- `vim/`  
  Editing must be frictionless for shell work to be effective

- `linux/foundations/`  
  Explains what the shell is controlling

- `linux/networking/`  
  Shell tools expose networking state

- `k8s/ops+provisioning/`  
  Most cluster operations begin in a shell

Shell fluency multiplies every other skill.

---

## ▶️ How to Use This Wing
- new to Linux → follow top to bottom
- rusty with Bash → focus on pipelines and expansion
- debugging → inspect exit codes and redirection first

When you understand how the shell executes commands,
Linux behavior becomes predictable.
