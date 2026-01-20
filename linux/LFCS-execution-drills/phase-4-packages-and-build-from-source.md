# 🧪 LFCS Execution Drills — Phase 4
# 📦 Package Management, Repositories, and Building from Source

Path:
  linux/execution-drills/phase-4-packages-and-build-from-source.md

Purpose:
  Build reflex-level safety and speed with apt, dpkg, repositories, package repair, and source builds.

Mental Mode:
  Always know: “Is this managed by apt or by me?”

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-4
    cd ~/lfcs-labs/execution-drills/phase-4

Ensure package metadata is fresh:

    sudo apt update

---

# A) Atomic Drills — apt

## A1 — Search, show, install, remove

    sudo apt search tmux
    apt show tmux
    sudo apt install -y tmux
    which tmux
    tmux -V
    sudo apt remove -y tmux

Repeat with another small package (e.g., htop or tree).

---

## A2 — Purge vs remove

    sudo apt install -y tmux
    sudo apt remove -y tmux
    sudo apt purge -y tmux

Explain difference.

---

## A3 — Auto-remove dependencies

    sudo apt install -y tmux
    sudo apt remove --auto-remove -y tmux

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

    sudo apt install --reinstall coreutils

---

## C2 — Fix broken dependencies

(Simulate by interrupting install or just run safely:)

    sudo apt -f install

---

# D) Repository Awareness

## D1 — Inspect sources

    grep -R ^deb /etc/apt/sources.list /etc/apt/sources.list.d/

Explain where repos come from.

---

## D2 — After change ritual (do not actually break system)

    sudo apt update

---

# E) Clean Removal Scenarios

## E1 — Identify and remove owner package

Pick a real binary:

    which ls
    dpkg -S /bin/ls

DO NOT REMOVE coreutils. Just practice identification.

---

# F) Build From Source (Safe Simulation)

We will build something small: `htop` or `tmux` from source.

## F1 — Install build dependencies

    sudo apt install -y build-essential autoconf automake libtool pkg-config

---

## F2 — Download source (example: tmux)

    cd ~/lfcs-labs/execution-drills/phase-4
    apt source tmux
    cd tmux-*

---

## F3 — Build cycle

    ./configure
    make

Do NOT install over system tmux yet.

Check binary:

    ./tmux -V

---

## F4 — Install (optional / controlled)

If you proceed:

    sudo make install
    which tmux
    tmux -V

Discuss:
- this tmux is now outside apt control

---

# G) Distinguish Package vs Source

## G1 — Find which tmux is running

    which tmux
    dpkg -S $(which tmux)

If dpkg says “no path found” → this is a source-installed binary.

---

# H) Timed Drills

## H1 — Install and verify in 30 seconds

    sudo apt install -y tree
    which tree
    tree --version || tree --help

---

## H2 — Find owning package in 15 seconds

    dpkg -S /bin/ls

---

## H3 — Remove package cleanly in 20 seconds

    sudo apt remove --auto-remove -y tree

---

# I) Failure Injection Drills

## I1 — Confusion between apt and source

Scenario:
- You run `tmux -V`
- It shows a newer version than apt provides
- `apt remove tmux` does not remove it

Diagnosis steps:

    which tmux
    dpkg -S $(which tmux)

Explain:
- This tmux came from source build.

---

## I2 — Forgotten apt update

    sudo apt install some-new-package

Explain why it might fail without:

    sudo apt update

---

# J) Composition (Exam Style)

## J1 — Search, install, verify, remove

    sudo apt search apache
    sudo apt install -y apache2
    which apache2
    apache2 -v
    sudo apt remove --auto-remove -y apache2

---

## J2 — Find package owning file and extract name

    dpkg -S /bin/ls | cut -d: -f1 > owner.txt
    cat owner.txt

---

## J3 — List coreutils files starting with u

    dpkg -L coreutils | grep ^/bin | cut -d/ -f3 | grep '^u' > names.txt
    cat names.txt

---

# ✅ Phase 4 Completion Criteria

You are Phase 4-ready when you can:

- Search, install, remove, and purge packages
- Repair broken installs
- Identify which package owns a file
- List package contents
- Understand and inspect repositories
- Build software from source and explain its risks
- Diagnose “why apt can’t see this binary”

---

# 🔒 Phase 4 Law

If you can’t control the software lifecycle, you can’t control the system.

---
