# 🧪 Essential Commands — Execution Drills (LFCS)

Mental mode: Muscle memory.  
Goal: Be able to execute every task below **without thinking**.

This file is not a tutorial.  
This is a **hands-on execution checklist + drill pack**.

---

## 🧰 Drill Framework

Drill types:
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — break intentionally; recover fast
- **D: Diagnosis** — interpret output; choose the correct fix
- **E: Composition** — 3–6 primitives chained (exam style)

Rules:
- Prefer idempotent actions
- Always know `>` vs `>>`
- Know when you need sudo
- Always verify outcomes

---

# 🧪 Phase 0 — Shell Execution + Job Control

## Setup (once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-0
    cd ~/lfcs-labs/execution-drills/phase-0

---

# A) Atomic Drills

## A1 — Exit codes

    true
    echo $?

    false
    echo $?

Target: 10 reps.

---

## A2 — Safe chaining

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

Target: 10 reps.

---

## A3 — Grouping + redirection

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

# B) Diagnosis Drills

## B1 — grep exit codes

    printf "%s\n" alpha beta gamma > input.txt

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

Pass: you can explain the difference in exit codes.

---

# C) Job Control

    sleep 3000 &
    jobs

    fg %1
    (Ctrl+Z)
    bg %1

    jobs
    kill %1

Pass: no confusion between job number and PID.

---

# 🔐 Local and Remote Login

    w
    who
    tty

(Also practice switching TTYs and SSH to localhost / another host.)

---

# 🔎 Find Files

## Find patterns

    find . -name "*.conf"
    find . -size +10M
    find . -type f
    find . -user root
    find . -perm 777
    find . -mtime -7

## Inode deletion

    ls -i
    find . -inum 123456 -ls
    find . -inum 123456 -delete

## Exec

    find . -type f -exec ls -lh {} +
    find . -type f -exec ls -lh {} \;

---

# 📚 Locate

    sudo updatedb
    locate passwd

---

# 🧩 Globbing

    ls a*
    ls a?
    ls a[bc]
    ls a[a-c]*
    mkdir test-{1,2,3}
    ls [!a]*

---

# 💽 Filesystem Inspection

    df -h
    df -T
    lsblk -f
    file -sL /dev/sda1

---

# 📝 Text & File Manipulation

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

# 🔗 Join / Paste / Split

    join a.txt b.txt
    paste a.txt b.txt
    split -n 3 bigfile.txt

---

# 🔎 grep

    grep root /etc/passwd
    grep -i root /etc/passwd
    grep -v root /etc/passwd
    grep -R "root" /etc
    grep -n root /etc/passwd
    grep -E "root|daemon" /etc/passwd

---

# 🧹 sed

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

# 🧮 awk

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

---

# ✅ Completion Criteria

You are done when:

- Exit codes and chaining are automatic
- Job control is automatic
- You can execute every command here without looking anything up

