# ⚔️ Phase 4 — Packages, Repositories, and Build from Source (Execution Playbook)
*LFCS software-control layer: if you can’t install, verify, repair, or remove software cleanly, you don’t control system state.*

Path:
- linux/LFCS-execution-playbooks/phase-4-packages-and-build-from-source.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- search, install, remove, and purge packages with apt
- identify which package owns a file
- list files installed by a package
- repair broken packages
- edit repositories and refresh metadata
- verify package integrity
- distinguish apt-managed vs manually installed binaries
- build and install software from source and verify it

---

## 🧱 Lab Root

All Phase 4 drills run in:

- ~/lfcs-labs/phase-4

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-4
    cd ~/lfcs-labs/phase-4
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 4 when you can complete P4-1 through P4-14:

- in ≤ 75 minutes total
- with zero verification failures
- without guessing package names or commands
- without confusing apt-managed vs manual installs

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P4-1 — Refresh metadata and search

Time limit:
- 4 minutes

Task:
Update package lists and search for apache.

Do:

    sudo apt update
    apt search apache

Verify:
- output contains apache2

-------------------------------------------------------------------------------

## P4-2 — Install and verify a package

Time limit:
- 5 minutes

Task:
Install tmux and verify it exists.

Do:

    sudo apt install -y tmux
    which tmux
    tmux -V

Verify:
- which prints a path
- version prints

-------------------------------------------------------------------------------

## P4-3 — Find which package owns a file

Time limit:
- 4 minutes

Task:
Find which package owns /bin/ls and save package name to owner.txt

Do:

    dpkg -S /bin/ls | cut -d: -f1 > owner.txt

Verify:

    cat owner.txt

-------------------------------------------------------------------------------

## P4-4 — List files installed by a package

Time limit:
- 4 minutes

Task:
List all files installed by coreutils and save to coreutils.files

Do:

    dpkg-query -L coreutils > coreutils.files

Verify:

    wc -l coreutils.files
    head coreutils.files

-------------------------------------------------------------------------------

## P4-5 — Filter installed file list

Time limit:
- 4 minutes

Task:
From coreutils.files, extract only files under /bin and save to binfiles.txt

Do:

    grep '^/bin' coreutils.files > binfiles.txt

Verify:

    wc -l binfiles.txt
    head binfiles.txt

-------------------------------------------------------------------------------

## P4-6 — Reinstall a package to repair it

Time limit:
- 4 minutes

Task:
Reinstall coreutils.

Do:

    sudo apt install --reinstall -y coreutils

Verify:
- command completes without error

-------------------------------------------------------------------------------

## P4-7 — Remove a package safely

Time limit:
- 4 minutes

Task:
Remove tmux but keep config (if any).

Do:

    sudo apt remove -y tmux

Verify:

    which tmux || echo "tmux removed"

-------------------------------------------------------------------------------

## P4-8 — Purge a package

Time limit:
- 4 minutes

Task:
Install tmux again, then purge it completely.

Do:

    sudo apt install -y tmux
    sudo apt purge -y tmux

Verify:

    which tmux || echo "tmux purged"

-------------------------------------------------------------------------------

## P4-9 — Auto-remove unused dependencies

Time limit:
- 3 minutes

Task:
Run auto-remove cleanup.

Do:

    sudo apt autoremove -y

Verify:
- command completes

-------------------------------------------------------------------------------

## P4-10 — Identify manual vs apt-managed binary

Time limit:
- 5 minutes

Task:
Check whether /usr/bin/vi is apt-managed.

Do:

    dpkg -S /usr/bin/vi || echo "not apt managed"

Verify:
- dpkg returns owning package or message

-------------------------------------------------------------------------------

## P4-11 — Add a test repository entry (no breakage)

Time limit:
- 6 minutes

Task:
Open sources list and inspect entries.

Do:

    sudo vi /etc/apt/sources.list

Verify:
- you can identify deb lines

Note:
- Do not break your system.
- Exit without changes unless instructed in exam.

-------------------------------------------------------------------------------

## P4-12 — Verify package integrity

Time limit:
- 4 minutes

Task:
Verify coreutils package.

Do:

    dpkg -V coreutils || true

Verify:
- command runs and reports nothing or warnings

-------------------------------------------------------------------------------

## P4-13 — Build from source (simulation)

Time limit:
- 10 minutes

Setup:

    cd ~/lfcs-labs/phase-4
    rm -rf p4-13 && mkdir p4-13
    cd p4-13
    mkdir hello && cd hello
    cat > hello.c <<EOF
    #include <stdio.h>
    int main() { printf("hello\n"); return 0; }
    EOF

Task:
Compile and install manually to /usr/local/bin/hello.

Do:

    gcc hello.c -o hello
    sudo cp hello /usr/local/bin/hello

Verify:

    which hello
    hello

Expected:
- prints hello

-------------------------------------------------------------------------------

## P4-14 — Prove manual install is not tracked by dpkg

Time limit:
- 4 minutes

Task:
Prove dpkg does not know about hello.

Do:

    dpkg -S $(which hello) || echo "not tracked"

Verify:
- shows not tracked

---

## 🏁 Phase 4 Pass Criteria

You can:

- search, install, remove, purge packages
- identify package owners of files
- list files in packages and filter them
- repair packages via reinstall
- clean unused dependencies
- verify package integrity
- distinguish apt-managed vs manual installs
- build and install a binary manually and reason about it

---

## 🔒 Phase 4 Law

If you don’t know where a binary came from,
you don’t control the system.

---
