# 📦 Package Management — README

## 🎯 Purpose
Build **safe, predictable control** over software installed on a Linux system.

This domain exists to make package state:
- inspectable
- intentional
- reversible

Most system instability comes from unmanaged or misunderstood package changes.

---

## 🧠 Mental Mode
**Managing system software deliberately**

- know what is installed
- know where it came from
- know what will change before it changes
- know how to recover when it goes wrong

Package management is not “installing things.”  
It is **controlling system state**.

---

## 🧭 Scope
This domain focuses on **day-to-day package operations** required for Linux administration and certification exams.

Included:
- querying installed packages
- installing and removing software
- updating package indexes
- upgrading packages safely
- understanding dependencies
- identifying package ownership of files

Excluded:
- building packages from source
- custom repositories (advanced)
- distribution internals
- container image builds

If it changes what software exists on the system, it belongs here.

---

## 📁 Directory Layout

### `package-management/README.md`
This file.
- defines scope
- sets mental model
- explains how to use this domain

---

### Package management content files
This domain will contain focused operational guides such as:
- inspecting installed packages
- installing and removing software
- upgrades and updates
- dependency behavior
- common package failures

Each file should emphasize:
- inspection before action
- predictable outcomes
- safe recovery

---

## 🧪 How to Use This Domain
Use this directory when:
- a command is missing
- a service fails after an upgrade
- dependencies block installation
- a file exists but its package is unknown
- the system behaves differently after updates

Always inspect before modifying package state.

---

## 🔎 Diagnostic First Principle
Before changing anything, you should be able to answer:
- what package is involved
- whether it is already installed
- what version is present
- what dependencies are affected
- what will change if you proceed

If you cannot explain the impact, pause.

---

## ⚠️ Operational Guardrails
- avoid blind upgrades
- refresh package indexes intentionally
- confirm package names before removal
- understand dependency chains
- verify changes after installation

Package mistakes can destabilize the system quickly.

---

## 🔗 Relationship to Other Linux Domains
- **Shell & Bash**  
  Package tools are driven from the command line

- **Filesystems & Storage**  
  Packages install files across the filesystem

- **Processes & Resource Management**  
  Installed packages often introduce services

- **Troubleshooting**  
  Many failures trace back to package state changes

Package management touches every part of the system.

---

## ✅ Outcome
You should be able to say:

I know what software is installed,  
I know how it got there,  
and I know how to change it safely.

That is package management fluency.

