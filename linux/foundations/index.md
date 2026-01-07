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

### 0️⃣ `README.md`
Defines:

- the scope and posture of the foundations wing
- what “understanding Linux” actually means
- how this wing differs from shell, ops, storage, and k8s content

Start here to align expectations.

---

### 1️⃣ `system-inspection.md`
Defines:

- how to observe a Linux system safely
- how to build situational awareness
- how to answer “what state is this system in?”

This teaches **observation before action**.

---

### 2️⃣ `files-and-metadata-inspection.md`
Defines:

- what a file really is (inodes, metadata)
- hard links vs symlinks
- how to interpret `ls -l` and `stat`
- how filenames relate to data and metadata

This teaches **what the filesystem objects actually are**.

---

### 3️⃣ `filesystem-access-control.md`
Defines:

- ownership and groups
- permission bits and execute semantics
- directory permission behavior
- sudo boundaries
- why commands succeed or fail

This teaches **who is allowed to do what and why**.

---

### 4️⃣ `archives-and-compression-tar.md`
Defines:

- what an archive is vs compression
- how to package and unpack file trees
- how metadata is preserved
- safe inspection-first restore workflows

This teaches **how files are packaged, moved, and restored**.

---

### 5️⃣ `processes-and-services.md` (future)
Will define:

- what a process is
- PID relationships
- process lifecycle
- services vs one-shot programs

Everything running on Linux is a process.

---

### 6️⃣ `package-management.md` (future)
Will define:

- how software is installed
- where it comes from
- dependency resolution
- trust and signatures

This teaches **where software actually comes from**.

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

