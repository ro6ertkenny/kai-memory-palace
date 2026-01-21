# 🧪 Essential Commands — Execution Drills (LFCS)

Mental mode: Muscle memory.  
Goal: Be able to execute every task below **without thinking**.

This file is not a tutorial.  
This is a **hands-on execution checklist + drill pack**.

If you need deeper redirection/pipeline reps, see:
- `linux/LFCS-training/execution-drills/files-and-text.md`

---

## 🧰 Drill Framework (Applies to this file)

Drill types:
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — break intentionally; recover fast
- **D: Diagnosis** — interpret output; choose the correct fix
- **E: Composition** — 3–6 primitives chained (exam style)

Scoring:
- ✅ Correct result
- ✅ No collateral damage
- ✅ Uses a safe/clean pattern
- ⏱️ Meets time target (when timed)

Rules of engagement:
- Prefer idempotent actions when possible
- Always know `>` vs `>>`
- Know when you need sudo and when you don’t
- Verify outcomes (don’t assume)

---

## 🧪 Phase 0 — Shell Execution + Job Control (Drill Pack)

### Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-0
    cd ~/lfcs-labs/execution-drills/phase-0

---

### A) Atomic Drills (Repetition)

#### A1 — Exit codes
Goal: read success/failure immediately.

    true
    echo $?

    false
    echo $?

Target: 10 reps, no hesitation.

#### A2 — Safe chaining with && and ||
Goal: use conditional chaining correctly.

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

Target: 10 reps.

#### A3 — Grouping and redirecting a command group
Goal: redirect output of a group (not only one command).

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

### D) Diagnosis Drills (Interpret + Choose)

#### D1 — “No matches” vs “broken command”
Goal: interpret grep exit codes correctly.

    printf "%s\n" alpha beta gamma > input.txt

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

Pass condition: you can explain:
- `grep` returns non-zero when no matches (not necessarily “error”)

---

### A4 — Job control muscle memory
Goal: manage background/foreground without confusion.

Start a long job:

    sleep 3000 &

Confirm jobs list:

    jobs

Bring to foreground, suspend, then background:

    fg %1
    (press Ctrl+Z)
    bg %1

Terminate safely:

    jobs
    kill %1

Pass condition: no confusion between job spec (`%1`) vs PID.

---

## 🔐 1) Local and Remote Login

- Switch to a TTY and log in
- Return to GUI (if present)
- SSH into localhost
- SSH into another host (or same host via IP)
- Show who is logged in

    w
    who
    tty

---

## 🔎 2) Find Files

- Find files by name
- Find files by size
- Find files by type
- Find files by owner
- Find files by permissions
- Find files modified in last N days
- Find and delete a file by inode
- Find files and run a command on them

    find . -name "*.conf"
    find . -size +10M
    find . -type f
    find . -user root
    find . -perm 777
    find . -mtime -7
    ls -i
    find . -inum 123456 -delete
    find . -type f -exec ls -lh {} +

---

## 📚 3) Locate Files Using Database

- Update locate database
- Find a file using locate

    sudo updatedb
    locate passwd

---

## 🧩 4) Globbing (Wildcard Expansion)

- Use *
- Use ?
- Use []
- Use ranges
- Use {}
- Use exclusions

    ls a*
    ls a?
    ls a[bc]
    ls a[a-c]*
    mkdir test-{1,2,3}
    ls [!a]*

---

## 💽 5) Filesystem Inspection

- Show disk usage
- Show filesystem types
- Identify filesystem on a block device

    df -h
    df -T
    lsblk -f
    file -sL /dev/sda1

---

## 📝 6) Compare and Manipulate Text

- Create files
- Compare files
- Compare directories
- Sort text
- Count lines
- Show line numbers
- Cut columns
- Translate characters
- Squeeze repeated spaces
- Show binary/octal view
- Rename files using pattern

    touch a.txt b.txt
    diff a.txt b.txt
    diff -ur dir1 dir2
    sort file.txt
    wc -l file.txt
    nl -ba file.txt
    cut -d ':' -f 1 /etc/passwd
    tr ',' ';' < file.csv
    tr -s ' ' < file.txt
    od -bc file.txt
    rename 's/foo/bar/' *.txt

---

## 🔗 7) Join, Paste, Split

- Join two files
- Paste two files side by side
- Split a file by size or lines

    join a.txt b.txt
    paste a.txt b.txt
    split -n 3 bigfile.txt

---

## 🔎 8) Regex and Text Search (grep)

- Basic grep
- Case insensitive grep
- Invert match
- Recursive grep
- Show line numbers
- Use extended regex

    grep root /etc/passwd
    grep -i root /etc/passwd
    grep -v root /etc/passwd
    grep -R "root" /etc
    grep -n root /etc/passwd
    grep -E "root|daemon" /etc/passwd

Note: Perl regex (`grep -P`) may not be available everywhere. Prefer `-E`.

---

## 🧹 9) sed Basics

- Print specific lines
- Delete lines
- Substitute text
- Substitute globally
- Use groups

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

## 🧮 10) awk Basics

- Print columns
- Filter by value
- Use BEGIN and END
- Do arithmetic

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

---

## ✅ Completion Criteria

You are **done with this file** when:

- Exit codes and chaining are automatic
- Job control is automatic (`&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill`)
- You can execute the listed command surfaces without looking anything up

---

