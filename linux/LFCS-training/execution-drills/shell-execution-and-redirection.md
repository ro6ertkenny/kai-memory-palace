# 🧪 Shell Execution, Redirection, Pipelines, and Job Control (LFCS)

**Path:** `linux/LFCS-training/execution-drills/shell-execution-and-redirection.md`

Mental mode: **Pure mechanics, speed, correctness**  
Purpose: Eliminate **all hesitation and all mistakes** around:

- exit codes
- chaining (`&&`, `||`)
- redirection (`>`, `>>`, `2>`, `2>&1`, `&>`)
- pipelines
- grouping
- `tee`
- job control

If you are weak here, **everything else in Linux becomes slow and dangerous**.

This is a **muscle-memory drill pack**.

---

## 🧱 Drill Framework (How to Use This File)

Drill types used here:

- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — intentionally break something; recover fast
- **D: Diagnosis** — interpret output/exit codes, choose correct meaning
- **E: Composition** — chain multiple primitives together (exam style)

Rules:

- Type everything. No copy/paste.
- Always verify output and files.
- Prefer idempotent actions.
- Always know whether you are writing with `>` or `>>`.
- Always be conscious of `2>&1` ordering.
- Keep a scratch directory.

---

## 🧪 Setup (Do Once Per Session)

    mkdir -p ~/lfcs-labs/execution-drills/shell
    cd ~/lfcs-labs/execution-drills/shell
    rm -f out.txt err.txt all.txt report.txt input.txt file.txt important.txt
    rm -rf data

Create a reproducible input file:

    cat > input.txt <<EOF
    alpha
    beta
    gamma
    beta
    delta
    EOF

---

# A) Atomic Drills (Repetition Until Automatic)

## A1 — Exit codes

Goal: Read success/failure immediately.

    true
    echo $?
    false
    echo $?

Target: 10 reps, no hesitation.

---

## A2 — Safe chaining with && and ||

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

Target: 10 reps.

---

## A3 — Redirect STDOUT overwrite vs append

    echo "one" > out.txt
    echo "two" >> out.txt
    cat out.txt

Target: 10 reps. Always inspect the file.

---

## A4 — Redirect STDERR only

    ls /no/such/path 2> err.txt
    cat err.txt

Target: 10 reps.

---

## A5 — Redirect both: classic vs modern

Classic:

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Modern:

    ls /no/such/path &> all.txt
    cat all.txt

Target: 10 reps each.

---

## A6 — /dev/null patterns

    ls /no/such/path 2> /dev/null
    ls /etc > /dev/null
    ls /no/such/path &> /dev/null

Target: 10 reps.

---

## A7 — tee: view + save

    dmesg | head -n 5 | tee out.txt
    cat out.txt

Append:

    echo "append-test" | tee -a out.txt
    tail -n 3 out.txt

Target: 10 reps.

---

## A8 — Pipes (simple)

    cat input.txt | wc -l
    cat input.txt | grep -c beta

Target: 10 reps.

---

## A9 — Here-doc file creation

    cat > file.txt <<EOF
    line1
    line2
    EOF

Verify:

    cat file.txt

Target: 10 reps.

---

## A10 — Grouping for redirection

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

# B) Timed Drills (Speed)

## B1 — “Capture everything” in 15 seconds

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Pass condition: ordering must be correct (`> all.txt 2>&1`).

---

## B2 — 3-command pipeline in 20 seconds

    cat input.txt | sort | uniq -c

Pass condition: correct output, no stumbles.

---

## B3 — Find + sort + head in 30 seconds

Setup:

    mkdir -p data
    dd if=/dev/zero of=data/a bs=1K count=10 status=none
    dd if=/dev/zero of=data/b bs=1K count=50 status=none
    dd if=/dev/zero of=data/c bs=1K count=20 status=none

Find biggest:

    find data -type f -exec du -h {} + | sort -rh | head -n 1

Pass condition: file `b` is largest.

---

# C) Failure Injection Drills (Break & Recover)

## C1 — Misordered redirection

Break it:

    ls /no/such/path 2>&1 > all.txt

Explain to yourself why it is wrong.

Fix it:

    ls /no/such/path > all.txt 2>&1

Rule you must be able to say out loud:

- `2>&1` copies STDERR to wherever STDOUT is pointing **at that moment**.

---

## C2 — Accidental clobber prevention

Simulate risk:

    echo "DO NOT LOSE THIS" > important.txt

Destroy it:

    echo "oops" > important.txt

Recover:

    echo "DO NOT LOSE THIS" > important.txt
    cat important.txt

Pass condition: you feel the danger and never forget it.

---

# D) Diagnosis Drills (Interpret Output + Exit Codes)

## D1 — Pipeline vs grep exit code

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

Pass condition: you can explain the difference between:
- “no matches”
- “command failure”

---

## D2 — Job control muscle memory

    sleep 3000 &

    jobs

Bring to foreground:

    fg %1

Suspend with Ctrl+Z.

Background again:

    bg %1

Kill safely:

    jobs
    kill %1

Pass condition: no confusion between PID and job spec.

---

# E) Composition Drills (Exam Style)

## E1 — “Live filter + capture”

    (ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"

Pass condition:
- You see filtered output
- `all.txt` contains full output

---

## E2 — “Report generator”

    {
      echo "=== DATE ==="
      date
      echo
      echo "=== UPTIME ==="
      uptime
      echo
      echo "=== TOP 5 PROCESSES BY MEM ==="
      ps aux --sort=-%mem | head -n 6
    } > report.txt

Pass condition:
- File is readable
- You can regenerate it from memory

---

# ✅ Completion Criteria (Gate)

You are done with this file when **all** of the following are true:

- You never hesitate on:
  - `>`, `>>`, `2>`, `2>&1`, `&>`
- You never mis-order redirection
- You use `tee` naturally
- You can build 3–5 command pipelines without trial-and-error
- You can use grouping `{ ...; }` for redirection
- You are fluent with:
  - `&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill %job`
- You can build:

    find | du | sort | head

…without thinking.

---

## 🧠 Operator Rule (Carry Forward Everywhere)

> **If you do not control redirection and pipelines perfectly, you do not control Linux.**

This file is **non-negotiable foundation**.

