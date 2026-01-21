# 🧪 Files and Text — Execution Drills (LFCS)

Mental mode: Precision and speed.  
Goal: Be able to **create, inspect, transform, and analyze text and files** without hesitation.

This is not a tutorial.  
This is an **execution checklist + drill pack**.

---

## 🧰 Drill Framework (Applies to this file)

Drill types:
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — break intentionally; recover fast
- **D: Diagnosis** — interpret output; choose the correct fix
- **E: Composition** — 3–6 primitives chained (exam style)

Rules of engagement:
- Always know `>` vs `>>`
- When capturing errors, verify `2>&1` ordering
- Verify results; do not assume

---

## 🧪 Phase 0 — Redirection + Pipelines (Drill Pack)

### Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-0
    cd ~/lfcs-labs/execution-drills/phase-0
    rm -f out.txt err.txt all.txt report.txt input.txt file.txt important.txt

Create reproducible input:

    cat > input.txt <<EOF
    alpha
    beta
    gamma
    beta
    delta
    EOF

---

### A) Atomic Drills (Repetition)

#### A1 — Redirect STDOUT overwrite vs append
Goal: never clobber by accident.

    echo "one" > out.txt
    echo "two" >> out.txt
    cat out.txt

Target: 10 reps.

#### A2 — Redirect STDERR only
Goal: capture errors without mixing stdout.

    ls /no/such/path 2> err.txt
    cat err.txt

Target: 10 reps.

#### A3 — Redirect both: classic vs modern
Goal: know equivalence and when to use.

Classic:

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Modern:

    ls /no/such/path &> all.txt
    cat all.txt

Target: 10 reps each.

#### A4 — /dev/null patterns
Goal: silence output intentionally.

    ls /no/such/path 2> /dev/null
    ls /etc > /dev/null
    ls /no/such/path &> /dev/null

Target: 10 reps.

#### A5 — tee (view + save)
Goal: capture output while observing it.

    dmesg | head -n 5 | tee out.txt
    cat out.txt

Append mode:

    echo "append-test" | tee -a out.txt
    tail -n 3 out.txt

Target: 10 reps.

#### A6 — Pipes (simple)
Goal: route stdout into next tool.

    cat input.txt | wc -l
    cat input.txt | grep -c beta

Target: 10 reps.

#### A7 — Here-doc file creation
Goal: create files without an editor.

    cat > file.txt <<EOF
    line1
    line2
    EOF

Verify:

    cat file.txt

Target: 10 reps.

#### A8 — Grouping for redirection
Goal: redirect a group (not only one command).

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

### B) Timed Drills (Speed)

#### B1 — Capture everything in 15 seconds
Run a failing command, capture all output to `all.txt`, then show the file.

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Pass condition: correct ordering (`> all.txt 2>&1`).

#### B2 — 3-command pipeline in 20 seconds
Count unique lines from `input.txt`:

    cat input.txt | sort | uniq -c

Pass condition: correct output, no syntax stumbles.

#### B3 — find + sort + head in 30 seconds
Create test files, then find the largest.

    mkdir -p data
    dd if=/dev/zero of=data/a bs=1K count=10 status=none
    dd if=/dev/zero of=data/b bs=1K count=50 status=none
    dd if=/dev/zero of=data/c bs=1K count=20 status=none

Find biggest:

    find data -type f -exec du -h {} + | sort -rh | head -n 1

Pass condition: `b` is largest.

---

### C) Failure Injection Drills (Break & Recover)

#### C1 — Misordered redirection
Break:

    ls /no/such/path 2>&1 > all.txt

Explain (to yourself) why it’s wrong, then fix:

    ls /no/such/path > all.txt 2>&1

Pass condition: you can state the rule:
- `2>&1` copies stderr to wherever stdout points at that moment.

#### C2 — Accidental clobber prevention (feel the pain)
Simulate a risky write:

    echo "DO NOT LOSE THIS" > important.txt

Overwrite it (intentionally):

    echo "oops" > important.txt

Recovery practice:

    echo "DO NOT LOSE THIS" > important.txt
    cat important.txt

Pass condition: you stop clobbering files in real systems.

---

### E) Composition Drills (Exam style)

#### E1 — Live filter + capture
Goal: watch and save errors from a noisy command.

    (ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"

Pass condition:
- you see filtered line(s)
- `all.txt` contains full output

---

## 📄 1) Create and Inspect Files

    touch a.txt b.txt
    echo "hello world" > a.txt
    printf "one\ntwo\nthree\n" > b.txt
    file a.txt
    ls -lh a.txt
    stat a.txt
    cat a.txt
    less a.txt
    nl -ba a.txt

---

## 📏 2) Counting and Measuring

    wc a.txt
    wc -l a.txt
    wc -w a.txt
    wc -c a.txt

---

## 🧭 3) Head, Tail, and Following Files

    head -n 5 /etc/passwd
    tail -n 5 /etc/passwd
    tail -f /var/log/syslog
    tail -F /var/log/syslog

---

## 🔍 4) Searching Text with grep

    grep root /etc/passwd
    grep -i root /etc/passwd
    grep -v root /etc/passwd
    grep -R root /etc
    grep -n root /etc/passwd
    grep -l root /etc/*
    grep -w root /etc/passwd
    grep -x root somefile.txt

---

## 🧠 5) Regular Expression Drills

    grep '^root' /etc/passwd
    grep 'bash$' /etc/passwd
    grep '[0-9][0-9][0-9]' somefile.txt
    grep '[a-z][a-z][a-z]' somefile.txt
    grep -E '(ha){2,}' laugh.txt

Note: Perl regex (`grep -P`) may not be available everywhere. Prefer `-E`.

---

## ✂️ 6) Cutting and Field Extraction

    cut -d ':' -f 1 /etc/passwd
    cut -d ':' -f 1,3,7 /etc/passwd
    cut -d ',' -f 2,3 file.csv

---

## 🔄 7) Translating and Cleaning Text (tr)

    tr ',' ';' < file.csv
    tr -d ':' < /etc/passwd
    tr -s ' ' < messy.txt
    tr 'A-Z' 'a-z' < UPPER.txt

---

## 🧱 8) Sorting and Uniqueness

    sort file.txt
    sort -n numbers.txt
    sort -r file.txt
    uniq file.txt
    sort file.txt | uniq
    sort file.txt | uniq -c

---

## 🔗 9) Joining and Pasting Files

    paste a.txt b.txt
    join file1.txt file2.txt
    join -1 2 -2 1 file1.txt file2.txt

---

## 🧩 10) Splitting Files

    split -n 3 bigfile.txt
    split -b 1M bigfile.txt
    split -l 100 bigfile.txt

---

## 🧹 11) sed Editing Drills

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed 's/foo/bar/2' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

## 🧮 12) awk Drills

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk -F: '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'
    ps aux | awk '{printf "%-10s %s\n", $1, $11}'

---

## 🧪 13) Binary and Encoding Inspection

    od -bc file.txt
    hexdump -C file.txt

---

## 🏷️ 14) Renaming Files in Bulk

    rename -n 's/foo/bar/' *.txt
    rename 's/foo/bar/' *.txt

---

## ✅ Completion Criteria

You are done with this file when:

- You can do all redirection patterns correctly without thinking
- You never misorder `2>&1`
- You can build 3–5 command pipelines reliably under time pressure
- You can create files via here-docs without hesitating
- You can use `tee` to observe and capture output cleanly

---

