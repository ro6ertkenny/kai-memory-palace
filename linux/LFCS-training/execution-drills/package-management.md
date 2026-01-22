# 🧪 Package Management — Execution Drills (LFCS)

Mental mode: Software lifecycle control.  
Goal: Be able to **search, install, remove, purge, repair, audit, verify integrity, manage repos, and distinguish apt-managed vs source-built software** quickly and safely.

This is not a tutorial.  
This is an **execution checklist**.

Core law:

> “Is this binary managed by apt, or by me?”

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/package-management
    cd ~/lfcs-labs/execution-drills/package-management

Refresh package metadata:

    sudo apt-get update

---

# A) Atomic Drills — apt-get

## A1 — Search, show, install, verify, remove

Search:

    apt-cache search tmux

Show package metadata:

    apt-cache show tmux

Install:

    sudo apt-get install -y tmux

Verify:

    which tmux
    tmux -V

Remove:

    sudo apt-get remove -y tmux

Repeat with another small package (e.g., tree or htop).

---

## A2 — Remove vs purge (configs)

Install:

    sudo apt-get install -y tmux

Remove (keeps config):

    sudo apt-get remove -y tmux

Purge (removes config):

    sudo apt-get purge -y tmux

Explain to yourself:
- remove = keeps config files
- purge  = removes config files too

---

## A3 — Auto-remove dependencies

Install a small package:

    sudo apt-get install -y tree

Remove and also remove unneeded deps:

    sudo apt-get remove --auto-remove -y tree

---

## A4 — Reinstall a package (repair by replacement)

Reinstall known package:

    sudo apt-get install --reinstall -y coreutils

---

## A5 — Fix broken dependencies

Safe to run even if nothing is broken:

    sudo apt-get -f install

---

# B) Atomic Drills — dpkg Ownership, Contents, Inventory

## B1 — Which package owns a file

Example:

    dpkg -S /bin/ls

Save only the package name:

    dpkg -S /bin/ls | cut -d: -f1 > owner.txt
    cat owner.txt

---

## B2 — List files in a package

List all files:

    dpkg -L coreutils

Show just a preview:

    dpkg -L coreutils | head

Filter to /bin:

    dpkg -L coreutils | grep '^/bin/'

Alt (query form is equivalent on many systems):

    dpkg-query -L coreutils | head
    dpkg-query -L coreutils | grep '^/bin/'

---

## B3 — List installed packages

Quick peek:

    dpkg -l | head

Optional: search installed packages (pattern):

    dpkg -l | grep -i tmux || true

---

# C) Integrity Verification (Package Trust)

## C1 — Verify package files (detect local modifications)

Verify (no output usually means clean):

    dpkg -V coreutils

Explain:
- output = files differ from package expectations
- no output = clean

---

## C2 — Repair modified package quickly

Reinstall the package:

    sudo apt-get install --reinstall -y coreutils

---

# D) Repository Awareness (Do Not Break Your System)

## D1 — Inspect sources (where repos are defined)

List deb lines:

    grep -R '^deb ' /etc/apt/sources.list /etc/apt/sources.list.d/ || true

Explain:
- repos live in:
  - /etc/apt/sources.list
  - /etc/apt/sources.list.d/*.list

---

## D2 — After-change ritual (mandatory)

Any time repos change:

    sudo apt-get update

---

## D3 — Editing sources (awareness only)

Open (read carefully; do not change unless you know what you’re doing):

    sudo vi /etc/apt/sources.list

Then refresh:

    sudo apt-get update

---

# E) Build From Source (Safe Flow)

Rule:
- Do NOT overwrite core system binaries with source builds.
- Prefer building + testing locally first.
- If you install, be aware it may land in /usr/local and become outside apt control.

## E1 — Install build tools

    sudo apt-get install -y build-essential autoconf automake libtool pkg-config

---

## E2 — Fetch source (example: tmux)

From your lab directory:

    cd ~/lfcs-labs/execution-drills/package-management
    apt-get source tmux
    cd tmux-*

---

## E3 — Build cycle (no install yet)

    ./configure
    make

Test local binary (if produced):

    ./tmux -V || true

---

## E4 — Optional controlled install (know the consequence)

If you choose to install:

    sudo make install

Then verify which tmux you’re running:

    which tmux
    tmux -V

---

# F) Distinguish apt-managed vs Source-installed

## F1 — Identify origin of a binary

Example for tmux:

    which tmux
    dpkg -S "$(which tmux)" || echo "Not owned by any package (likely manual/source install)"

Interpretation:
- If dpkg reports “no path found” → it is not owned by a Debian package.

---

# G) Removal Scenarios

## G1 — Remove package cleanly

    sudo apt-get install -y htop
    sudo apt-get remove --auto-remove -y htop

---

## G2 — Source-installed binary awareness

Explain:
- apt cannot remove a manually installed binary
- removal is usually:
  - make uninstall (if supported), or
  - delete installed files manually (last resort)

---

# H) Timed Drills (Speed)

## H1 — Find package owning /bin/ls (10 seconds)

    dpkg -S /bin/ls

---

## H2 — List coreutils files under /bin (15 seconds)

    dpkg -L coreutils | grep '^/bin/'

---

## H3 — Install and verify a package (20 seconds)

    sudo apt-get install -y tree
    which tree
    tree --version || tree --help

Cleanup:

    sudo apt-get remove --auto-remove -y tree

---

# I) Failure Injection Drills

## I1 — Forgot apt-get update

Scenario:
- Repos changed or system was offline a long time
- install fails / package not found

Fix:

    sudo apt-get update

---

## I2 — Mixed source and apt installs

Scenario:
- apt-get remove tmux
- tmux still exists

Diagnosis:

    which tmux
    dpkg -S "$(which tmux)" || echo "Manual/source install"

Conclusion:
- It was installed outside apt.

---

## I3 — Overwriting system binaries (theory)

Explain:
- overwriting system-managed binaries risks breaking upgrades and dependencies
- /usr/local is typically safer than /usr for manual installs

---

# J) Composition (Exam Style)

## J1 — Full lifecycle

    apt-cache search apache
    sudo apt-get install -y apache2
    which apache2
    apache2 -v
    dpkg -S "$(which apache2)"
    sudo apt-get remove --auto-remove -y apache2

---

## J2 — Ownership extraction + file listing

    dpkg -S /bin/ls | cut -d: -f1 > owner.txt
    cat owner.txt

    dpkg -L coreutils | grep '^/bin/' > files.txt
    head files.txt

---

## J3 — Integrity check + repair

    dpkg -V coreutils || true
    sudo apt-get install --reinstall -y coreutils

---

# ✅ Completion Criteria

You are **done with this file** when:

- You can search, install, remove, and purge packages instantly
- You can fix broken installs without panic (`apt-get -f install`)
- You can identify which package owns any file (`dpkg -S`)
- You can list package contents from memory (`dpkg -L`)
- You can verify package integrity (`dpkg -V`) and repair via reinstall
- You can inspect where repos come from and follow the after-change ritual
- You can build software from source safely and explain the risk
- You can instantly diagnose “why apt can’t see this binary”

---

# 🔒 Law

If you don’t control the software lifecycle, you don’t control the system.

---

## 🧹 Cleanup (Optional)

    cd ~
    rm -rf ~/lfcs-labs/execution-drills/package-management/tmux-* || true

---
