# 🐧 Linux Wing

Welcome to the **Linux Wing** of the Kai Memory Palace.

This wing documents **Linux system administration fundamentals** with a focus on
clarity, repeatability, and operational understanding. It prioritizes how the
operating system actually behaves over distribution-specific trivia.

If Kubernetes runs on top of Linux, then Linux **must be understood first**.

---

## 🎯 Purpose

The Linux Wing exists to:

- Build a solid mental model of the Linux operating system
- Document commands, workflows, and behaviors used in real systems
- Serve as a durable reference for day-to-day administration
- Support Kubernetes operations by strengthening the underlying foundation

This wing is **Linux-first**, not cloud-first and not tool-first.

---

## 🧠 Scope

Topics in this wing include, but are not limited to:

- Filesystems and directory structure
- Users, groups, and permissions
- Processes, signals, and job control
- systemd units and service management
- Networking fundamentals at the OS level
- Package management (`apt`)
- Logs, troubleshooting, and observability
- Boot process and system state
- Disk usage, mounts, and storage
- Environment variables and shells

---

## 🧭 How This Wing Is Organized

Content in this wing is organized as **focused Markdown artifacts**, typically one
concept or workflow per file.

Examples:

- `filesystem-layout.md`
- `users-and-permissions.md`
- `processes-and-signals.md`
- `systemd-basics.md`
- `package-management.md`
- `networking-basics.md`
- `troubleshooting-checklist.md`

Each artifact should be:
- Self-contained
- Clearly titled
- Easy to scan
- Written for retrieval, not narration

---

## 🧰 Command Philosophy

Commands documented here follow these principles:

- Explicit over implicit
- Readability over cleverness
- Repeatability over shortcuts
- Safety over speed

Where applicable:
- Commands are shown exactly as run
- Output is included when it adds clarity
- Side effects are explained

---

## 🧠 Relationship to Other Wings

| Wing            | Relationship to Linux |
|-----------------|----------------------|
| ☸️ Kubernetes    | Runs *on top of* Linux |
| 🌐 Networking   | Extends Linux networking concepts |
| ✍️ Vim           | Editing tool used heavily in Linux workflows |
| 🧰 Snippets     | Extracted commands from Linux workflows |
| 🤙 Kai          | Mental models applied while administering Linux |

Linux is the **substrate** that everything else depends on.

---

## 📌 Intended Audience

- The future version of yourself
- Engineers building Linux confidence
- Kubernetes practitioners strengthening fundamentals
- Recruiters evaluating system-level competence

The tone is **clear, neutral, and instructional**.

---

## 🏁 Status

🚧 Active and evolving

This wing grows as real systems are built, operated, broken, and repaired.

---

## 🧭 Navigation

- 🗺️ **[Palace Map](../map.md)**
- 🏛️ **[Entrance Hall](../README.md)**
