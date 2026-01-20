# 🧪 LFCS Execution Drills — Phase 15
# 📦 Package Management, Software Installation, and Building from Source

Path:
  linux/execution-drills/phase-15-package-management-and-builds.md

Purpose:
  Build reflex-level control over apt/dpkg, repositories, package integrity, and source builds.

Mental Mode:
  Always ask first:
  “Is this managed by apt, or was it installed manually?”

---

## 🧱 Lab Safety Rules

⚠️ Do this in a VM or lab machine.
⚠️ Do NOT overwrite core system binaries with source builds.
⚠️ Do NOT remove essential packages (e.g., coreutils, systemd, apt).

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-15
    cd ~/lfcs-labs/execution-drills/phase-15

Refresh package lists:

    sudo apt update

---

# A) apt — Core Workflow

## A1 — Search, show, install, remove

    sudo apt search apache
    apt show apache2
    sudo apt install -y apache2
    which apache2
    apache2 -v
    sudo apt remove -y apache2

---

## A2 — Remove including dependencies

    sudo apt install -y tree
    sudo apt remove --auto-remove -y tree

---

## A3 — Purge vs remove

    sudo apt install -y tmux
    sudo apt remove -y tmux
    sudo apt purge -y tmux

Explain:
- remove = keeps config
- purge  = removes config

---

# B) dpkg — Ownership and Contents

## B1 — Find which package owns a file

    dpkg -S /bin/ls

Save just the package name:

    dpkg -S /bin/ls | cut -d: -f1 > package.txt
    cat package.txt

---

## B2 — List files in a package

    dpkg-query -L coreutils | head

Filter to /bin:

    dpkg-query -L coreutils | grep ^/bin

Exam-style filter:

    dpkg-query -L coreutils | grep -i "/bin" | cut -d/ -f4 | grep '^u' > names.txt
    cat names.txt

---

## B3 — List installed packages

    dpkg -l | head

---

# C) Repositories

## C1 — Inspect sources

    grep -R ^deb /etc/apt/sources.list /etc/apt/sources.list.d/

---

## C2 — Edit and refresh (do not break system)

Open:

    sudo vi /etc/apt/sources.list

(Do not change unless you know what you are doing.)

Refresh:

    sudo apt update

---

# D) Package Integrity

## D1 — Verify a package

    dpkg -V coreutils

Explain:
- Output = modified files
- No output = clean

---

## D2 — Reinstall to fix

    sudo apt install --reinstall coreutils

---

# E) Build and Install from Source (Safe Flow)

We will build something **without installing over system paths**.

## E1 — Install build tools

    sudo apt install -y build-essential autoconf automake libtool pkg-config

---

## E2 — Fetch source (example: tmux)

    apt source tmux
    cd tmux-*

---

## E3 — Build cycle

    ./configure
    make

Test local binary (if produced):

    ./tmux -V || true

Do NOT install yet.

---

## E4 — Optional controlled install

If you choose to install:

    sudo make install

Check which tmux is used:

    which tmux
    tmux -V

---

# F) Hybrid Awareness — Package vs Source

## F1 — Identify origin of a binary

    which tmux
    dpkg -S $(which tmux) || echo "Not owned by any package"

Explain:
- If dpkg reports “no path found” → it came from source build.

---

# G) Removal Scenarios

## G1 — Remove package cleanly

    sudo apt install -y htop
    sudo apt remove --auto-remove -y htop

---

## G2 — Source-installed binary

Explain:
- apt cannot remove it
- You must:
  - use make uninstall (if provided), or
  - delete files manually

---

# H) Timed Drills

## H1 — Find package owning /bin/ls (10 seconds)

    dpkg -S /bin/ls

---

## H2 — List coreutils files in /bin (15 seconds)

    dpkg-query -L coreutils | grep ^/bin

---

## H3 — Install and verify a package (20 seconds)

    sudo apt install -y tree
    which tree
    tree --version || tree --help

Cleanup:

    sudo apt remove --auto-remove -y tree

---

# I) Failure Injection Drills

## I1 — Forgot apt update

Scenario:
- You add or change repos
- Install fails

Fix:

    sudo apt update

---

## I2 — Mixed source and apt installs

Scenario:
- apt remove tmux
- tmux still exists

Diagnosis:

    which tmux
    dpkg -S $(which tmux)

Conclusion:
- It was installed from source.

---

## I3 — Overwriting system binary (theory)

Explain:
- Why this is dangerous
- Why /usr/local is safer than /usr

---

# J) Composition (Exam Style)

## J1 — Full lifecycle

    sudo apt search apache
    sudo apt install -y apache2
    which apache2
    dpkg -S $(which apache2)
    sudo apt remove --auto-remove -y apache2

---

## J2 — Ownership and listing

    dpkg -S /bin/ls | cut -d: -f1 > package.txt
    dpkg-query -L coreutils | grep ^/bin > files.txt

---

## J3 — Source awareness

    which tmux
    dpkg -S $(which tmux) || echo "Manual install"

---

# ✅ Phase 15 Completion Criteria

You are Phase 15-ready when you can:

- Search, install, remove, and purge packages
- Find which package owns a file
- List files installed by a package
- Inspect and understand repositories
- Verify and repair packages
- Build software from source safely
- Identify whether a binary is package-managed or manual
- Avoid mixing the two worlds accidentally

---

# 📦 Phase 15 Law

If you don’t know where a binary came from, you don’t control the system.

---

# Cleanup (Optional)

    cd ~
    rm -rf ~/tmux-* || true

---
