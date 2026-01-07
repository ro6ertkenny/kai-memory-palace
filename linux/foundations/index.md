# 🧱 Linux Foundations — Index
*Understanding how Linux actually works before attempting to control it*

---

## 📌 Purpose

This index provides the **structured navigation map** for the
`linux/foundations` wing.

It answers the question:

> “What must I understand about Linux itself before tools,
shells, services, containers, or Kubernetes make sense?”

This wing builds **mental models**, not muscle memory.

---

## 🧠 Mental Model

Linux is not:

- a collection of commands
- a product
- a black box

Linux **is**:

- a kernel managing resources
- a userspace providing interfaces
- a contract between processes, memory, files, devices, and the scheduler

Understanding Linux foundations means understanding **responsibility boundaries and state**.

---

## 🔁 Recommended Learning Order

Read these documents **in order** to establish correct system intuition.

---

### 1️⃣ `README.md`
Defines:
- scope and posture of the foundations wing
- what “understanding Linux” actually means
- how this wing differs from shell or ops content

Start here to align expectations.

---

### 2️⃣ `system-inspection.md`
Defines:
- how to observe a Linux system safely
- what information is always available
- how to answer “what state is this system in?”

This teaches **observation before action**.

---

### 3️⃣ `processes-and-services.md`
Defines:
- what a process is
- PID and PPID (who started what)
- the process tree model (parent/child)
- services vs one-shot processes

Everything running on Linux is a process.

---

### 4️⃣ `job-control-and-signals.md`
Defines:
- foreground/background execution
- jobs vs processes
- Ctrl+Z, fg, bg, jobs
- SIGTERM vs SIGKILL, STOP/CONT
- nohup and disown (surviving disconnects)

This teaches **execution control**.

---

### 5️⃣ `filesystem-access-control.md`
Defines:
- filesystem hierarchy and paths
- ownership and permissions
- directory semantics and execute bit behavior
- why “everything is a file” matters

This explains persistence, access, and isolation.

---

### 6️⃣ `advanced-filesystem-permissions.md`
Defines:
- SUID / SGID / sticky bit
- ACLs and the ACL mask
- filesystem attributes (lsattr/chattr), immutable files

This explains access behaviors that rwx alone cannot explain.

---

### 7️⃣ `files-and-metadata-inspection.md`
Defines:
- inodes, links, and file identity
- reading metadata safely (stat, etc.)
- disk/filesystem inspection tooling (df, du, lsblk, findmnt)

This teaches **inspection before change** for storage and files.

---

### 8️⃣ `archives-and-compression-tar.md`
Defines:
- creating, listing, extracting archives
- gzip vs xz basics
- safe archive habits for exams and ops work

This teaches **packaging and recovery workflows**.

---

## ⚠️ Common Conceptual Mistakes

> **⚠️ Mistake:** Treating Linux as “the terminal”  
> The terminal is just one interface to the OS.

> **⚠️ Mistake:** Fixing problems before understanding system state  
> Observation is always cheaper than recovery.

> **⚠️ Mistake:** Treating files as “just data”  
> Files are metadata + permissions + links + storage + policy.

---

## 🔗 Relationship to Other Wings

- `linux/shell-and-bash/`  
  Uses these concepts to control the system

- `linux/filesystems-and-storage/`  
  Builds on the file and resource models defined here

- `linux/networking/`  
  Builds on process and resource understanding

- `k8s/foundations/`  
  Kubernetes abstractions mirror Linux primitives

Linux foundations are **upstream of everything**.

---

## ▶️ How To Use This Wing

- New to Linux → read top to bottom
- Rusty fundamentals → start at system inspection
- Debugging weird behavior → return here before touching anything

If you understand Linux foundations, higher-level systems stop feeling magical.

---

