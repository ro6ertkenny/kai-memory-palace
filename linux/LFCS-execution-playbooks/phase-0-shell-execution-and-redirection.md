# ⚔️ Phase 0 — Shell Execution, Redirection, Pipelines, and Job Control (Execution Playbook)
*LFCS gatekeeper: if this is not automatic, every other phase is slower and riskier.*

Path:
- linux/LFCS-execution-playbooks/phase-0-shell-execution-and-redirection.md

Rule:
- This is not curriculum.
- This is execution under time + verification.
- No editor usage for drill steps unless the drill explicitly allows it.

---

## 📌 Purpose

Build reflex-level ability to:

- control stdout vs stderr
- use safe overwrite vs append
- generate files with exact content without editors
- build 3–6 stage pipelines
- manage foreground/background jobs
- verify success mechanically
- avoid clobbering and accidental damage

---

## 🧱 Lab Root (Local)

All Phase 0 drills run in:

- ~/lfcs-labs/phase-0

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-0
    cd ~/lfcs-labs/phase-0
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 0 when you can complete P0-1 through P0-12:

- in ≤ 35 minutes total
- with zero verification failures
- without “thinking time” on redirection syntax

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P0-1 — Separate stdout and stderr

Time limit:
- 3 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-1 && mkdir p0-1
    cd p0-1

Task:
Run a command that produces both stdout and stderr.
Save:
- stdout to out.txt
- stderr to err.txt

Command to run:

    ls /etc /doesnotexist

Do:

    ls /etc /doesnotexist > out.txt 2> err.txt

Verify:

    test -s out.txt && echo "stdout OK"
    test -s err.txt && echo "stderr OK"

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- mixing redirection order
- accidentally merging streams

-------------------------------------------------------------------------------

## P0-2 — Combine stdout and stderr

Time limit:
- 3 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-2 && mkdir p0-2
    cd p0-2

Task:
Capture both stdout and stderr into all.txt.

Do:

    ls /etc /doesnotexist > all.txt 2>&1

Verify:

    test -s all.txt && echo "combined OK"
    grep -q "doesnotexist" all.txt && echo "stderr captured OK" || true

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- writing 2>&1 in the wrong place

-------------------------------------------------------------------------------

## P0-3 — Overwrite vs append

Time limit:
- 3 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-3 && mkdir p0-3
    cd p0-3

Task:
Create file with one line, append a second line, prove 2 lines exist.

Do:

    echo first > file.txt
    echo second >> file.txt

Verify:

    wc -l file.txt
    sed -n '1,2p' file.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- using > twice (clobbers)

-------------------------------------------------------------------------------

## P0-4 — Create file with exact content (here-doc)

Time limit:
- 4 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-4 && mkdir p0-4
    cd p0-4

Task:
Create exact.txt with exactly 3 lines:

- alpha
- beta
- gamma

Do:

    cat <<EOF > exact.txt
    alpha
    beta
    gamma
    EOF

Verify:

    wc -l exact.txt
    sed -n '1,3p' exact.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- extra whitespace
- missing EOF alignment

-------------------------------------------------------------------------------

## P0-5 — Pipeline: extract → sort → unique → save

Time limit:
- 4 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-5 && mkdir p0-5
    cd p0-5

Task:
From /etc/passwd:
- extract usernames
- sort
- unique
- write to users.txt

Do:

    cut -d: -f1 /etc/passwd | sort | uniq > users.txt

Verify:

    test -s users.txt && echo "users.txt OK"
    head users.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- wrong delimiter/field
- forgetting redirect at end

-------------------------------------------------------------------------------

## P0-6 — Filter and transform: bash users

Time limit:
- 4 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-6 && mkdir p0-6
    cd p0-6

Task:
From /etc/passwd:
- select only users with shell /bin/bash
- output usernames only
- write to bash-users.txt

Do:

    grep '/bin/bash$' /etc/passwd | cut -d: -f1 > bash-users.txt

Verify:

    test -s bash-users.txt && echo "bash-users OK"
    head bash-users.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- missing $ anchor
- extracting wrong field

-------------------------------------------------------------------------------

## P0-7 — Anchors: exact root line

Time limit:
- 3 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-7 && mkdir p0-7
    cd p0-7

Task:
Write the root passwd entry to rootline.txt using an anchored match.

Do:

    grep '^root:' /etc/passwd > rootline.txt

Verify:

    cat rootline.txt
    grep -q '^root:' rootline.txt && echo "root match OK"

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- unanchored grep that matches other lines

-------------------------------------------------------------------------------

## P0-8 — Prove output matches exactly (diff)

Time limit:
- 4 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-8 && mkdir p0-8
    cd p0-8

Task:
Generate two identical sorted username lists and prove they match.

Do:

    cut -d: -f1 /etc/passwd | sort > users.sorted
    cut -d: -f1 /etc/passwd | sort > users.sorted.2
    diff users.sorted users.sorted.2

Verify:

    echo $?

Expected:
- exit code 0

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- comparing unsorted outputs

-------------------------------------------------------------------------------

## P0-9 — tee: view + save

Time limit:
- 4 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-9 && mkdir p0-9
    cd p0-9

Task:
Capture kernel messages while also viewing them, write to dmesg.txt.

Do:

    dmesg | tee dmesg.txt > /dev/null

Verify:

    test -s dmesg.txt && echo "tee OK"
    head dmesg.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- forgetting tee writes to stdout and file
- accidentally spamming terminal output in later drills

-------------------------------------------------------------------------------

## P0-10 — Jobs: background, jobs list, foreground

Time limit:
- 6 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-10 && mkdir p0-10
    cd p0-10

Task:
1) Start a long sleep in background
2) Confirm it exists via jobs
3) Bring it to foreground, then stop it safely

Do:

    sleep 300 &
    jobs
    fg %1

Then stop it with Ctrl+C.

Verify:
- jobs shows the job before fg
- after Ctrl+C, job is gone:

    jobs

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- forgetting %1
- killing the wrong PID from another terminal

-------------------------------------------------------------------------------

## P0-11 — Grouping commands with one redirection

Time limit:
- 5 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-11 && mkdir p0-11
    cd p0-11

Task:
Run 3 commands and redirect their combined stdout to report.txt.

Commands:
- date
- uptime
- whoami

Do:

    { date; uptime; whoami; } > report.txt

Verify:

    wc -l report.txt
    sed -n '1,3p' report.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- using ( ) subshell when you intended grouping
- forgetting semicolons inside { }

-------------------------------------------------------------------------------

## P0-12 — Pipeline: extract IPv4 addresses to file

Time limit:
- 6 minutes

Starting state:

    cd ~/lfcs-labs/phase-0
    rm -rf p0-12 && mkdir p0-12
    cd p0-12

Task:
From ip a output:
- extract only IPv4 addresses
- strip /mask
- write to ips.txt

One valid solution:

    ip a | grep ' inet ' | awk '{print $2}' | cut -d/ -f1 > ips.txt

Verify:

    test -s ips.txt && echo "ips OK"
    cat ips.txt

Reset:

    cd ~/lfcs-labs/phase-0

Failure modes:
- matching inet6
- extracting wrong field

---

## 🏁 Phase 0 Pass Criteria

You can:

- separate stdout/stderr reliably
- merge streams correctly
- avoid clobbering files
- create exact content without editors
- build pipelines that end in correct files
- manage foreground/background without confusion
- verify success mechanically every time

---

## 🔒 Phase 0 Law

If you can’t move data through commands safely and predictably,
you are not in control of the system.

---
