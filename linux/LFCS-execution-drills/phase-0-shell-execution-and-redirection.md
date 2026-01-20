# 🧪 LFCS Execution Drills — Framework + Phase 0 Drill Pack
*Execution drills are performance training: speed, correctness, and diagnosis under pressure.*

This file defines:
- the **drill framework** used for all phases
- the **Phase 0 drill pack** (Shell execution, redirection, pipelines, job control)

Path suggestion:
- `linux/execution-drills/phase-0-shell-execution-and-redirection.md`

---

## 🧱 Drill Framework (Used for ALL phases)

### Drill Types
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — intentionally break something; recover fast
- **D: Diagnosis** — interpret output/logs, choose correct fix
- **E: Composition** — 3–6 primitives chained together (exam style)

### Scoring
- ✅ Correct output
- ✅ No collateral damage (no clobbering files, no killing wrong PID, etc.)
- ✅ Uses the safest/cleanest pattern
- ⏱️ Time target met (when timed)

### Rules of Engagement
- Prefer **idempotent** actions when possible.
- Always know whether you’re writing with `>` vs `>>`.
- When capturing errors, always verify `2>&1` ordering.
- Confirm with `echo $?` (or observe command behavior) when appropriate.
- Keep a scratch lab directory for drills:
  - `~/lfcs-labs/execution-drills/phase-0/`

---

## 🐚 Phase 0 — Drill Pack
*Shell execution, redirection, pipelines, and job control*

### Setup (Do once)
    mkdir -p ~/lfcs-labs/execution-drills/phase-0
    cd ~/lfcs-labs/execution-drills/phase-0
    rm -f out.txt err.txt all.txt report.txt input.txt file.txt

Create a reproducible input file:
    cat > input.txt <<EOF
    alpha
    beta
    gamma
    beta
    delta
    EOF

---

## A) Atomic Drills (Repetition)

### A1 — Exit codes
Goal: prove you can read success/failure immediately.

    true
    echo $?
    false
    echo $?

Target: 10 reps, no hesitation.

### A2 — Safe chaining
Goal: use `&&` and `||` correctly.

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

Target: 10 reps.

### A3 — Redirect STDOUT overwrite vs append
Goal: never clobber by accident.

    echo "one" > out.txt
    echo "two" >> out.txt
    cat out.txt

Target: 10 reps. Confirm file contents each time.

### A4 — Redirect STDERR only
Goal: capture errors without mixing output.

    ls /no/such/path 2> err.txt
    cat err.txt

Target: 10 reps.

### A5 — Redirect both classic vs modern
Goal: know equivalence and when to use.

Classic:
    ls /no/such/path > all.txt 2>&1
    cat all.txt

Modern:
    ls /no/such/path &> all.txt
    cat all.txt

Target: 10 reps each.

### A6 — /dev/null patterns
Goal: silence outputs intentionally.

    ls /no/such/path 2> /dev/null
    ls /etc > /dev/null
    ls /no/such/path &> /dev/null

Target: 10 reps.

### A7 — tee view + save
Goal: capture output while observing it.

    dmesg | head -n 5 | tee out.txt
    cat out.txt

Append mode:
    echo "append-test" | tee -a out.txt
    tail -n 3 out.txt

Target: 10 reps.

### A8 — Pipes (simple)
Goal: route STDOUT into next tool.

    cat input.txt | wc -l
    cat input.txt | grep -c beta

Target: 10 reps.

### A9 — Here-doc (file creation)
Goal: generate files without editor.

    cat > file.txt <<EOF
    line1
    line2
    EOF

Verify:
    cat file.txt

Target: 10 reps.

### A10 — Grouping for redirection
Goal: redirect output of a group, not only one command.

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

## B) Timed Drills (Speed)

### B1 — “Capture everything” in 15 seconds
Run a command that fails and capture all output to `all.txt`, then show the file.

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Pass condition: correct ordering (must be `> all.txt 2>&1`).

### B2 — 3-command pipeline in 20 seconds
Count unique sorted words from `input.txt`:

    cat input.txt | sort | uniq -c

Pass condition: correct output, no syntax stumbles.

### B3 — Find + sort + head in 30 seconds
Create test files, then find largest.

    mkdir -p data
    dd if=/dev/zero of=data/a bs=1K count=10 status=none
    dd if=/dev/zero of=data/b bs=1K count=50 status=none
    dd if=/dev/zero of=data/c bs=1K count=20 status=none

Find biggest (human readable):
    find data -type f -exec du -h {} + | sort -rh | head -n 1

Pass condition: `b` is largest.

---

## C) Failure Injection Drills (Break & Recover)

### C1 — Misordered redirection
Break:
    ls /no/such/path 2>&1 > all.txt

Explain (to yourself) why it’s wrong, then fix:
    ls /no/such/path > all.txt 2>&1

Pass condition: you can state the rule:
- `2>&1` copies STDERR to wherever STDOUT is pointing *at that moment*

### C2 — Accidental clobber prevention
Simulate a risky write:
    echo "DO NOT LOSE THIS" > important.txt

Now “accidentally” overwrite (intentionally):
    echo "oops" > important.txt

Recovery practice: restore content quickly (recreate expected file):
    echo "DO NOT LOSE THIS" > important.txt
    cat important.txt

Pass condition: you feel the pain, and you stop doing it in real systems.

---

## D) Diagnosis Drills (Interpret + Choose)

### D1 — Pipeline success vs grep success
Run:
    cat input.txt | grep zzz
    echo $?

Then:
    cat input.txt | grep beta
    echo $?

Pass condition: you can interpret exit codes and not confuse “no matches” with “broken command.”

### D2 — jobs control muscle memory
Start a long job:
    sleep 3000 &

Confirm:
    jobs

Bring to foreground then suspend (Ctrl+Z), then background it:
    fg %1
    (press Ctrl+Z)
    bg %1

Kill it safely:
    jobs
    kill %1

Pass condition: no confusion between PID vs job spec.

---

## E) Composition Drills (Exam style)

### E1 — “Live filter + capture”
Goal: watch and save errors from a noisy command.

    (ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"

Pass condition: you see filtered line(s) and `all.txt` contains full output.

### E2 — “Report generator”
Goal: generate a report file with multiple sections.

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

Pass condition: report is readable, and you can regenerate it at will.

---

## ✅ Phase 0 Completion Criteria
You are Phase 0-ready when you can do ALL without hesitation:

- Correct `&&` / `||` chaining
- Correct `2>&1` ordering
- Use `tee` (overwrite + append)
- Build 3–5 command pipelines reliably
- Create files with here-docs
- Manage jobs: `&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill`
- Build `find | du | sort | head` patterns

---

