# 📦 Phase 15 — Package Management, Software Installation, and Building from Source
*LFCS supply-chain layer: know what’s installed, where it came from, and how to manage it safely.*

---

## 📌 Purpose

This phase makes you **fully operational with Linux software management**:

- Searching, installing, removing packages
- Finding which package owns a file
- Listing files installed by a package
- Managing repositories
- Verifying package integrity
- Building and installing software from source

LFCS questions here are **procedural and exact**.

---

## 🧠 Mental Model

There are **two worlds**:

1) **Managed packages** (apt / dpkg)
2) **Manually built software** (configure / make / make install)

Know **which world you’re in** before you touch anything.

---

# 📦 Part A — apt Basics

Update package lists:

    sudo apt update

Search:

    sudo apt search "apache http server"

Install:

    sudo apt install apache2

Remove (keep config):

    sudo apt remove apache2

Remove completely:

    sudo apt-get remove --auto-remove -y ziptool

---

# 📜 Part B — dpkg Queries

## Find which package owns a file

    dpkg -S /bin/ls

Save name only:

    dpkg -S /bin/ls | cut -d: -f1 > package.txt

---

## List files installed by a package

    dpkg-query -L coreutils

Filter:

    dpkg-query -L coreutils | grep ^/bin

Example exam filter:

    dpkg-query -L coreutils | grep -i "/bin" | cut -d/ -f4 | grep '^u' > name.txt

---

# 🗂️ Part C — Repositories

Main config:

    /etc/apt/sources.list

Edit:

    sudo vi /etc/apt/sources.list

Example add:

    deb http://us.archive.ubuntu.com/ubuntu/ focal main

Apply:

    sudo apt update

---

# 🔍 Part D — Package Integrity

Verify package:

    dpkg -V coreutils

Reinstall if broken:

    sudo apt install --reinstall coreutils

---

# 🧰 Part E — Build and Install from Source

Canonical workflow:

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

---

## Important Consequence

Files installed this way:

- Are **not tracked by apt**
- Must be removed **manually**
- Can overwrite system binaries if careless

---

# 🧪 Part F — Hybrid Awareness

Check if command is from package or manual install:

    which tmux
    dpkg -S $(which tmux)

If dpkg says “no path found” → manually installed.

---

# 🧪 Canonical Exam Scenarios

Search and install:

    sudo apt search apache
    sudo apt install apache2

Find package owning file:

    dpkg -S /bin/ls | cut -d: -f1 > package.txt

List files in package:

    dpkg-query -L coreutils | grep ^/bin

Remove package + deps:

    sudo apt-get remove --auto-remove -y ziptool

Add repo and refresh:

    sudo vi /etc/apt/sources.list
    sudo apt update

Build from source:

    ./configure
    make
    sudo make install

---

# ⚠️ Failure Modes

- Forgetting apt update after repo change
- Mixing manual installs with apt-managed files
- Not knowing how to identify package ownership
- Overwriting system binaries with make install
- Assuming dpkg knows about source builds

---

# 🏁 Phase 15 Mastery Checklist

You must be able to:

- Search, install, remove packages
- Find which package owns a file
- List files in a package
- Edit sources.list and refresh
- Verify package integrity
- Build and install from source
- Identify manually installed binaries

---

## 📦 Exam Law

> **If you don’t know where a binary came from, you don’t control the system.**

---

