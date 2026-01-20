# ⚔️ LFCS Execution Playbooks — kai-memory-palace

This artifact defines the **LFCS Execution Playbooks system** and contains the full
**Phase 01** playbooks.

It is intentionally delivered as a **single, copy-safe Markdown block**.
Split it into files as described below.

===============================================================================
FILE: linux/LFCS-execution-playbooks/README.md
===============================================================================

# ⚔️ LFCS Execution Playbooks — kai-memory-palace

Purpose:
- This directory is the PERFORMANCE engine for LFCS.
- It is not notes.
- It is not curriculum.
- It is not explanations.

Every playbook is:
- task-driven
- time-bounded
- verifiable
- resettable
- repeatable

Rule:
If you can’t verify success, you didn’t complete the playbook.

Structure:

- phase-XX/
  - index.md     (inventory + pass standards)
  - playbooks.md (the actual execution tasks)

How to use:

1) Start a timer
2) Run the playbook exactly as written
3) Run the verification commands
4) If verification fails:
   - reset immediately
   - repeat immediately

Scoring:

- Pass = all success criteria met inside time limit
- Misses that cost time and are likely to recur go into:
  linux/troubleshooting/mistakes.md

Mental mode:

These are operator playbooks, not study notes.

===============================================================================
FILE: linux/LFCS-execution-playbooks/playbook-template.md
===============================================================================

# ⚔️ Execution Playbook Template

Playbook ID:
  P#

Title:
  <short>

Time limit:
  <minutes>

Starting state:
  (exact commands to reset environment)

Task:
  (what to do, no hints)

Constraints:
- (what you may not do)
- (paths you must use)

Success criteria:
- (observable outcomes)

Verify:
  (exact commands to prove success)

Reset:
  (commands to return to start state)

Failure modes:
- (common mistakes)

Variants:
- (same muscle, different details)

===============================================================================
FILE: linux/LFCS-execution-playbooks/phase-01/index.md
===============================================================================

# ⚔️ Phase 01 — Files, Ownership, Permissions, Links, ACLs
# Execution Playbooks — Index

Goal:
- Turn permissions, ownership, links, and ACL operations into fast, mechanical reflexes.

Lab root:
- ~/lfcs-labs/phase-01

Playbooks:

- P1: Permissions (symbolic + octal)
- P2: SGID directory (group inheritance)
- P3: Sticky-bit dropbox
- P4: Hard link vs symlink (inode proof)
- P5: ACL grant without chmod/chown
- P6: Find by perms/owner (exam patterns)

Pass standard:

- Complete P1–P6 in ≤ 60 minutes total
- Every playbook must end in successful verification
- No guessing, no partial credit

===============================================================================
FILE: linux/LFCS-execution-playbooks/phase-01/playbooks.md
===============================================================================

# ⚔️ Phase 01 — Execution Playbooks
# 🗂️ Files, Ownership, Permissions, Links, ACLs

Lab setup (once):

    mkdir -p ~/lfcs-labs/phase-01
    cd ~/lfcs-labs/phase-01

-------------------------------------------------------------------------------

# P1 — Permissions: symbolic + octal

Time limit:
- 6 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p1 && mkdir p1
    cd p1
    echo 'echo OK' > runme.sh
    touch data.txt

Task:
1) Make runme.sh executable ONLY for user.
2) Make data.txt readable for user+group, no access for other.

Constraints:
- Do not use chmod -R
- Do not change ownership

Success criteria:
- runme.sh mode is 700
- data.txt mode is 640

Verify:

    stat -c "%a %n" runme.sh data.txt
    test -x runme.sh && echo "runme executable OK"

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- using 755 out of habit
- granting execute to group/other

Variants:
- repeat using ONLY symbolic chmod
- repeat using ONLY octal chmod

-------------------------------------------------------------------------------

# P2 — SGID directory: group inheritance

Time limit:
- 8 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p2 && mkdir p2
    cd p2
    sudo groupadd -f devs
    sudo useradd -m -s /bin/bash alice 2>/dev/null || true
    sudo usermod -aG devs alice

Task:
Create directory shared such that:
- group is devs
- mode is 2775
- new files inherit group devs

Verify:

    mkdir -p shared
    sudo chgrp devs shared
    chmod 2775 shared
    touch shared/proof.txt
    ls -ld shared
    ls -l shared/proof.txt

Expected:
- shared shows: drwxrwsr-x
- proof.txt group is devs

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- forgetting SGID bit (2)
- using 0775 instead of 2775

Variants:
- use 2770 to remove access for others

-------------------------------------------------------------------------------

# P3 — Sticky bit dropbox

Time limit:
- 8 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p3 && mkdir p3
    cd p3

Task:
Create dropbox directory with mode 1777.

Verify:

    mkdir -p dropbox
    chmod 1777 dropbox
    ls -ld dropbox
    stat -c "%a %n" dropbox

Expected:
- ls shows: drwxrwxrwt
- mode shows: 1777

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- using 0777 (no sticky protection)

Variants:
- create files as different users and test delete behavior

-------------------------------------------------------------------------------

# P4 — Hard link vs symlink (inode proof)

Time limit:
- 10 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p4 && mkdir p4
    cd p4
    echo "alpha" > original.txt

Task:
1) Create hard link hard.txt
2) Create symlink soft.txt
3) Delete original.txt
4) Prove:
   - hard.txt still contains data
   - soft.txt is broken

Verify:

    ln original.txt hard.txt
    ln -s original.txt soft.txt
    ls -li
    readlink soft.txt
    rm original.txt
    cat hard.txt
    ls -l soft.txt || true
    cat soft.txt || true

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- confusing ln vs ln -s
- expecting hard links across filesystems

Variants:
- recreate original.txt and observe symlink becomes valid again

-------------------------------------------------------------------------------

# P5 — ACL: grant access without chmod/chown

Time limit:
- 10 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p5 && mkdir p5
    cd p5
    sudo useradd -m -s /bin/bash charlie 2>/dev/null || true
    echo "secret" > report.log
    chmod 600 report.log

Task:
Grant user charlie read access via ACL only.
Do not change mode bits or ownership.

Verify:

    setfacl -m u:charlie:r report.log
    ls -l report.log
    getfacl report.log
    sudo -u charlie cat report.log && echo "charlie read OK"

Expected:
- ls shows trailing +
- mode remains 600

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- using chmod instead of ACL
- forgetting ACL mask exists

Variants:
- add write permission and validate

-------------------------------------------------------------------------------

# P6 — Find by permissions (exam patterns)

Time limit:
- 10 minutes

Starting state:

    cd ~/lfcs-labs/phase-01
    rm -rf p6 && mkdir p6
    cd p6
    mkdir a b c
    touch a/one b/two c/three
    chmod 666 a/one
    chmod 640 b/two
    chmod 600 c/three

Task:
1) Find world-writable files.
2) Find files with exact mode 0640.

Verify:

    find . -type f -perm -0002
    find . -type f -perm 0640

Expected:
- world-writable: ./a/one
- exact 0640: ./b/two

Reset:

    cd ~/lfcs-labs/phase-01

Failure modes:
- confusing -perm -0002 vs -perm 0002
- forgetting -type f

-------------------------------------------------------------------------------
