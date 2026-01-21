# 🧪 Package Management — Execution Drills (LFCS)

Mental mode: Software lifecycle control.  
Goal: Be able to **search, install, remove, repair, audit, and distinguish apt-managed vs source-built software** quickly and safely.

This is not a tutorial.  
This is an **execution checklist**.

Always know:

> “Is this binary managed by apt, or by me?”

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/package-management
    cd ~/lfcs-labs/execution-drills/package-management

Ensure package metadata is fresh:

    sudo apt-get update

---

# A) Atomic Drills — apt

## A1 — Search, show, install, remove

    sudo apt-cache search tmux
    apt-cache show tmux
    sudo apt-get install -y tmux
    which tmux
    tmux -V
    sudo apt-get remove -y tmux

Repeat with another small package (e.g. htop or tree).

---

## A2 — Purge vs remove

    sudo apt-get install -y tmux
    sudo apt-get remove -y tmux
    sudo apt-get purge -y tmux

Explain to yourself:
- remove = leaves config
- purge = removes config too

---

## A3 — Auto-remove dependencies

    sudo apt-get install -y tmux
    sudo apt-get remove --auto-remove -y tmux

---

# B) Atomic Drills — dpkg

## B1 — Which package owns a file

    dpkg -S /bin/ls

---

## B2 — List files in a package

    dpkg -L coreutils
    dpkg -L coreutils | head

---

## B3 — List installed packages

    dpkg -l | head

---

# C) Repair & Verification

## C1 — Reinstall a package

    sudo apt-get install --reinstall coreutils

---

## C2 — Fix broken dependencies

(Safe to run even if nothing is broken.)

    sudo apt-get -f install

---

# D) Repository Awareness

## D1 — Inspect sources

    grep -R ^deb /etc/apt/sources.list /etc/apt/sources.list.d/

Explain:
- where repositories come from
- which files control them

---

## D2 — After-change ritual

Any time repos change:

    sudo apt-get update

---

# E) Clean Removal Scenarios

## E1 — Identify owner package (DO NOT REMOVE coreutils)

    which ls
    dpkg -S /bin/ls

Practice identification only.

---

# F) Build From Source (Safe Simulation)

We will build something small: `tmux` or `htop` from source.

## F1 — Install build dependencies

    sudo apt-get install -y build-essential autoconf automake libtool pkg-config

---

## F2 — Download source

    cd ~/lfcs-labs/execution-drills/package-management
    apt-get source tmux
    cd tmux-*

---

## F3 — Build cycle

    ./configure
    make

Do NOT install over system tmux yet.

Test local binary:

    ./tmux -V

---

## F4 — Install (optional / controlled)

If you proceed:

    sudo make install
    which tmux
    tmux -V

Explain:
- this tmux is now **outside apt control**

---

# G) Distinguish Package vs Source

## G1 — Find which tmux is running

    which tmux
    dpkg -S $(which tmux)

If dpkg says “no path found” → this is a source-installed binary.

---

# H) Timed Drills

## H1 — Install and verify in 30 seconds

    sudo apt-get install -y tree
    which tree
    tree --version || tree --help

---

## H2 — Find owning package in 15 seconds

    dpkg -S /bin/ls

---

## H3 — Remove package cleanly in 20 seconds

    sudo apt-get remove --auto-remove -y tree

---

# I) Failure Injection Drills

## I1 — Confusion between apt and source

Scenario:
- `tmux -V` shows a newer version than apt provides
- `apt-get remove tmux` does not remove it

Diagnosis:

    which tmux
    dpkg -S $(which tmux)

Explain:
- This tmux came from a source build.

---

## I2 — Forgotten apt update

    sudo apt-get install some-new-package

Explain why it may fail without:

    sudo apt-get update

---

# J) Composition (Exam Style)

## J1 — Search, install, verify, remove

    sudo apt-cache search apache
    sudo apt-get install -y apache2
    which apache2
    apache2 -v
    sudo apt-get remove --auto-remove -y apache2

---

## J2 — Find package owning file and extract name

    dpkg -S /bin/ls | cut -d: -f1 > owner.txt
    cat owner.txt

---

## J3 — List coreutils files starting with "u"

    dpkg -L coreutils | grep ^/bin | cut -d/ -f3 | grep '^u' > names.txt
    cat names.txt

---

# ✅ Completion Criteria

You are **done with this file** when:

- You can search, install, remove, and purge packages instantly
- You can repair broken installs without panic
- You can identify which package owns any file
- You can list package contents from memory
- You understand and can inspect repositories
- You can build software from source and explain the risk
- You can instantly diagnose “why apt can’t see this binary”

---

# 🔒 Law

If you don’t control the software lifecycle, you don’t control the system.

---
