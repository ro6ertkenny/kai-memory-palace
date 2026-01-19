# 📦 Phase 4 — Package Management, Repositories, and Building from Source
*LFCS reliability layer: install, verify, remove, and recover software correctly.*

---

## 📌 Purpose

This phase makes you **operationally safe** with:

- Searching for packages
- Installing and removing software
- Inspecting which package owns which file
- Listing files installed by a package
- Managing repositories
- Building and installing software from source

Many LFCS tasks are variations of:

> “Install X, verify it, fix it, or remove it cleanly.”

---

## 🧠 Mental Model

There are **two worlds**:

1) **Package manager world** (apt, dpkg)
   - Knows what is installed
   - Tracks files
   - Handles upgrades and removal

2) **Source build world** (./configure, make, make install)
   - Bypasses package manager
   - You must manage it yourself
   - Used when package not available or specific version required

---

# 📚 Part A — apt (High-Level Package Manager)

Update package lists:

    sudo apt update

Search:

    sudo apt search apache
    sudo apt search "apache http server"

Install:

    sudo apt install apache2
    sudo apt install tmux

Remove:

    sudo apt remove apache2

Remove including unused dependencies:

    sudo apt remove --auto-remove apache2

Purge (remove config too):

    sudo apt purge apache2

Show package info:

    apt show apache2

---

# 📦 Part B — dpkg (Low-Level Package Manager)

Which package owns a file:

    dpkg -S /bin/ls

List files in a package:

    dpkg -L coreutils

Alternative:

    dpkg-query -L coreutils

List installed packages:

    dpkg -l

---

# 🧭 Part C — Repositories

Edit sources:

    sudo vi /etc/apt/sources.list

Or files in:

    /etc/apt/sources.list.d/

After change:

    sudo apt update

Example repo line:

    deb http://us.archive.ubuntu.com/ubuntu focal main

---

# 🧪 Part D — Verify Package Integrity

Reinstall to fix broken files:

    sudo apt install --reinstall coreutils

Check dependencies:

    sudo apt -f install

---

# 🛠️ Part E — Build and Install from Source

Typical workflow:

    ./autogen.sh
    ./configure
    make
    sudo make install

Example (tmux):

    cd tmux
    sudo ./autogen.sh
    sudo ./configure
    sudo make
    sudo make install

Check where it installed:

    which tmux
    tmux -V

---

## ⚠️ Source Build Warning

- Files installed by make install are **not tracked by apt**
- Removal may require:
  - make uninstall (if available)
  - Or manual deletion

---

# 🧰 Part F — Validate Installed Software

Check binary exists:

    which nginx
    which tmux

Check version:

    nginx -v
    tmux -V

Check service files:

    systemctl status nginx

---

# 🧹 Part G — Clean Removal Scenarios (Exam)

Find which package owns a file and remove it:

    dpkg -S /usr/bin/somebinary
    sudo apt remove packagename

Remove package and dependencies:

    sudo apt remove --auto-remove packagename

---

# 🧪 Canonical Exam Scenarios

Search and install Apache:

    sudo apt search apache
    sudo apt install apache2

Find package owning /bin/ls:

    dpkg -S /bin/ls | cut -d: -f1 > package.txt

List coreutils files starting with u:

    dpkg -L coreutils | grep ^/bin | cut -d/ -f3 | grep '^u' > name.txt

Remove ziptool and dependencies:

    sudo apt-get remove --auto-remove -y ziptool

Build and install software from source:

    ./configure
    make
    sudo make install

---

## ⚠️ Failure Modes

- Forgetting apt update
- Installing wrong package name
- Mixing source builds with package builds unknowingly
- Not knowing how to identify owning package
- Leaving broken dependencies

---

## 🏁 Phase 4 Mastery Checklist

You must be able to:

- Search, install, remove packages
- Find which package owns a file
- List files from a package
- Edit repositories and refresh metadata
- Reinstall or repair packages
- Build and install from source
- Verify installation via binaries and services

---

## 🔒 Exam Law

> **If you can’t control software lifecycle, you can’t control system state.**

---
