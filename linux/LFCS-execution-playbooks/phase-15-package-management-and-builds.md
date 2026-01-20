# 📦 Phase 15 — Package Management & Builds (Execution Playbook)
*LFCS supply-chain control: prove what’s installed, where it came from, fix it, and remove it safely.*

Path:
- linux/LFCS-execution-playbooks/phase-15-package-management-and-builds.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- search, install, remove packages with apt
- query package ownership with dpkg
- list files installed by a package
- verify and repair packages
- add repositories and refresh metadata
- distinguish apt-managed vs manually-built binaries
- build and install from source (when provided)
- avoid corrupting the system

---

## 🧱 Lab Root

All Phase 15 drills run in:

- ~/lfcs-labs/phase-15

Initialize:

    mkdir -p ~/lfcs-labs/phase-15
    cd ~/lfcs-labs/phase-15
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT remove critical system packages.
- Prefer installing small, disposable packages (e.g., tree, sl).
- Do NOT overwrite system binaries with source builds.
- Always verify before removing.

---

## 🧪 Completion Standard

Pass Phase 15 when you can complete P15-1 through P15-14:

- in ≤ 120 minutes
- without breaking the system
- with proof files created
- and with test packages removed

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P15-1 — Update package metadata

Time limit:
- 5 minutes

Do:

    sudo apt update > apt-update.txt

Verify:

    grep -i "reading" apt-update.txt || true

-------------------------------------------------------------------------------

## P15-2 — Search for a package

Time limit:
- 3 minutes

Task:
Search for "tree".

Do:

    apt search tree > search.txt

Verify:

    grep -i tree search.txt || true

-------------------------------------------------------------------------------

## P15-3 — Install a small package

Time limit:
- 5 minutes

Task:
Install tree.

Do:

    sudo apt install -y tree > install.txt

Verify:

    which tree > which-tree.txt

-------------------------------------------------------------------------------

## P15-4 — Show package info

Time limit:
- 3 minutes

Do:

    apt show tree > tree-info.txt

Verify:

    wc -l tree-info.txt

-------------------------------------------------------------------------------

## P15-5 — Find which package owns a file

Time limit:
- 3 minutes

Task:
Find owner of /bin/ls.

Do:

    dpkg -S /bin/ls > owns-ls.txt

Verify:

    cat owns-ls.txt

-------------------------------------------------------------------------------

## P15-6 — List files in a package

Time limit:
- 4 minutes

Task:
List files in coreutils.

Do:

    dpkg-query -L coreutils > coreutils-files.txt

Verify:

    wc -l coreutils-files.txt

-------------------------------------------------------------------------------

## P15-7 — Filter package file list

Time limit:
- 4 minutes

Task:
Extract /bin files starting with "u".

Do:

    dpkg-query -L coreutils | grep '^/bin' | cut -d/ -f3 | grep '^u' > filtered.txt

Verify:

    cat filtered.txt

-------------------------------------------------------------------------------

## P15-8 — Verify package integrity

Time limit:
- 4 minutes

Task:
Verify coreutils.

Do:

    dpkg -V coreutils > verify-coreutils.txt || true

Verify:

    wc -l verify-coreutils.txt

-------------------------------------------------------------------------------

## P15-9 — Reinstall a package

Time limit:
- 4 minutes

Task:
Reinstall tree.

Do:

    sudo apt install --reinstall -y tree > reinstall.txt

Verify:

    which tree > after-reinstall.txt

-------------------------------------------------------------------------------

## P15-10 — Check where a binary came from

Time limit:
- 3 minutes

Task:
Check if tree is apt-managed.

Do:

    dpkg -S $(which tree) > tree-owner.txt

Verify:

    cat tree-owner.txt

-------------------------------------------------------------------------------

## P15-11 — Add a repository (inspection only)

Time limit:
- 4 minutes

Task:
Inspect sources list.

Do:

    cat /etc/apt/sources.list > sources.txt 2>/dev/null || true
    ls /etc/apt/sources.list.d > sources-d.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P15-12 — Simulate source build workflow (no install)

Time limit:
- 6 minutes

Task:
Simulate build steps in a temp dir.

Do:

    mkdir fake-src
    cd fake-src
    echo -e "#!/bin/sh\necho hello" > configure
    chmod +x configure
    ./configure > configure-out.txt
    cd ..

(This is just to practice the flow.)

-------------------------------------------------------------------------------

## P15-13 — Remove test package

Time limit:
- 5 minutes

Task:
Remove tree and dependencies.

Do:

    sudo apt remove --auto-remove -y tree > remove.txt

Verify:

    which tree > after-remove.txt || echo "tree removed" > after-remove.txt

-------------------------------------------------------------------------------

## P15-14 — Cleanup

Time limit:
- 2 minutes

Do:

    rm -rf fake-src
    echo OK > cleanup.txt

---

## 🏁 Phase 15 Pass Criteria

You can:

- search, install, remove packages
- query which package owns a file
- list files installed by a package
- verify and reinstall packages
- inspect repository configuration
- distinguish apt-managed vs manual binaries
- avoid damaging the system

---

## 📦 Phase 15 Law

If you don’t know **where a binary came from**, you don’t control the system.

---

