# 🧪 Files and Text — Execution Drills (LFCS)

Mental mode: Precision and speed.  
Goal: Be able to **create, inspect, search, transform, and pipeline text + files** without hesitation.

This is not a tutorial.  
This is an **execution checklist + drill packs**.

This file contains two drill packs:
- **Phase 0**: redirection + pipelines (muscle memory)
- **Phase 2**: search / parse / transform (find, grep, sed, awk, cut, tr, sort, uniq)

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
- Always preview before `-delete`
- Prefer working on copies for destructive transforms (`sed -i` on a copy)

---

# 🧪 Phase 0 Drill Pack — Redirection + Pipelines

## 🧱 Setup (Do once)

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

## A) Atomic Drills (Repetition)

### A1 — Redirect STDOUT overwrite vs append

    echo "one" > out.txt
    echo "two" >> out.txt
    cat out.txt

Target: 10 reps.

### A2 — Redirect STDERR only

    ls /no/such/path 2> err.txt
    cat err.txt

Target: 10 reps.

### A3 — Redirect both: classic vs modern

Classic:

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Modern:

    ls /no/such/path &> all.txt
    cat all.txt

Target: 10 reps each.

### A4 — /dev/null patterns

    ls /no/such/path 2> /dev/null
    ls /etc > /dev/null
    ls /no/such/path &> /dev/null

Target: 10 reps.

### A5 — tee (view + save)

    dmesg | head -n 5 | tee out.txt
    cat out.txt

Append mode:

    echo "append-test" | tee -a out.txt
    tail -n 3 out.txt

Target: 10 reps.

### A6 — Pipes (simple)

    cat input.txt | wc -l
    cat input.txt | grep -c beta

Target: 10 reps.

### A7 — Here-doc file creation

    cat > file.txt <<EOF
    line1
    line2
    EOF

Verify:

    cat file.txt

Target: 10 reps.

### A8 — Grouping for redirection

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

## B) Timed Drills (Speed)

### B1 — Capture everything in 15 seconds

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Pass condition: correct ordering (`> all.txt 2>&1`).

### B2 — 3-command pipeline in 20 seconds

    cat input.txt | sort | uniq -c

Pass condition: correct output, no syntax stumbles.

### B3 — find + sort + head in 30 seconds

    mkdir -p data
    dd if=/dev/zero of=data/a bs=1K count=10 status=none
    dd if=/dev/zero of=data/b bs=1K count=50 status=none
    dd if=/dev/zero of=data/c bs=1K count=20 status=none

    find data -type f -exec du -h {} + | sort -rh | head -n 1

Pass condition: `b` is largest.

---

## C) Failure Injection Drills (Break & Recover)

### C1 — Misordered redirection

Break:

    ls /no/such/path 2>&1 > all.txt

Fix:

    ls /no/such/path > all.txt 2>&1

Pass condition: you can state the rule:
- `2>&1` copies stderr to wherever stdout points at that moment.

### C2 — Accidental clobber prevention

    echo "DO NOT LOSE THIS" > important.txt
    echo "oops" > important.txt

Recover:

    echo "DO NOT LOSE THIS" > important.txt
    cat important.txt

Pass condition: you stop clobbering files in real systems.

---

## E) Composition Drills (Exam style)

### E1 — Live filter + capture

    (ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"

Pass condition:
- filtered line appears
- `all.txt` contains full output

---

# 🔎 Phase 2 Drill Pack — Search, Parse, Transform

Mental mode:
Most LFCS tasks are: find → filter → transform → sort → select → write → act

## 🧱 Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-2
    cd ~/lfcs-labs/execution-drills/phase-2

Create test data:

    cat > data.txt <<EOF
    10 alice 200
    20 bob 50
    30 carol 300
    40 dave 120
    50 eve 75
    EOF

    cat > words.txt <<EOF
    apple
    banana
    apple
    pear
    banana
    apple
    EOF

    mkdir -p tree/a tree/b tree/c
    touch tree/a/a.conf tree/a/a.log tree/b/b.conf tree/c/c.txt
    dd if=/dev/zero of=big1 bs=1K count=10 status=none
    dd if=/dev/zero of=big2 bs=1K count=50 status=none
    dd if=/dev/zero of=big3 bs=1K count=20 status=none

---

## A) Atomic Drills — find

### A1 — Find by name and type

    find tree -name "*.conf"
    find tree -type d
    find tree -type f

Repeat until instant.

### A2 — Find by size

    find . -type f -size +15k
    find . -type f -size +5k -size -30k

Verify with:

    ls -lh big1 big2 big3

### A3 — Find and exec

    find tree -type f -exec ls -l {} \;

Explain why `{}` and `\;` are needed.

### A4 — Safe delete pattern (preview first)

Preview:

    find . -type f -name "*.log"

Then delete:

    find . -type f -name "*.log" -delete

Rule: always preview first.

---

## B) Atomic Drills — grep

### B1 — Basic, count, recursive

    grep alice data.txt
    grep -c apple words.txt
    grep -R "conf" tree

### B2 — Anchors and alternation

    grep '^10' data.txt
    grep '75$' data.txt
    grep -E 'alice|carol' data.txt

### B3 — Extract only matches

    echo "ID=54321" | grep -o '[0-9]\{5\}'

Note:
- Prefer `grep -E` for portability
- Use basic grep escaping when needed

---

## C) Atomic Drills — cut / tr

### C1 — cut fields

    cut -d' ' -f1,3 data.txt
    cut -d' ' -f2 data.txt

### C2 — tr translate and delete

    echo "a,b,c" | tr ',' ';'
    printf "a\r\nb\r\n" | tr -d '\r'

---

## D) Atomic Drills — awk

### D1 — Print fields

    awk '{print $1, $3}' data.txt

### D2 — Filter by condition

    awk '$3 > 100 {print $2, $3}' data.txt

### D3 — Line ranges

    awk 'NR>=2 && NR<=4' data.txt

### D4 — Accumulate

    awk '{sum+=$3} END {print sum}' data.txt

---

## E) Atomic Drills — sed

### E1 — Substitute

    sed 's/alice/ALICE/' data.txt
    sed 's/a/A/g' words.txt

### E2 — In-place edit (use a copy)

    cp words.txt words.work
    sed -i 's/apple/APPLE/g' words.work
    cat words.work

### E3 — Delete lines and ranges

    sed '2d' data.txt
    sed '1,2d' data.txt

---

## F) Atomic Drills — sort / uniq / wc / head / tail

### F1 — Sort and uniq

    sort words.txt
    sort words.txt | uniq
    sort -u words.txt

### F2 — Count and select

    wc -l data.txt
    sort -nr data.txt | head -n 3
    tail -n 2 data.txt

---

## G) Timed Drills (Speed)

### G1 — Largest file in 30 seconds

    find . -type f -exec du -h {} + | sort -rh | head -n 1

Pass: identifies `big2`.

### G2 — Top consumers in 30 seconds

    sort -nr -k3 data.txt | head -n 3

### G3 — Count unique words in 20 seconds

    sort words.txt | uniq -c

---

## H) Failure Injection Drills

### H1 — grep vs find confusion

Try:

    grep conf tree

Explain why it fails (grep needs file input; directory needs `-R` or a file list).

Correct answers:

    grep -R conf tree
    find tree -type f -name "*.conf"

### H2 — sed -i regret simulation

    cp data.txt data.work
    sed -i 's/20/XXX/' data.work

Recover by recreating file from original.

Rule: always backup or work on copy.

### H3 — find -delete paranoia drill

Preview:

    find . -type f -name "*.txt"

Only then:

    find . -type f -name "*.txt" -delete

Explain why preview is mandatory.

---

## I) Composition Drills (Exam Style)

### I1 — Extract, transform, select
Goal: show only names where value > 100

    awk '$3 > 100 {print $2}' data.txt

### I2 — IP-style extraction pattern (simulate)

    printf "inet 10.0.0.1/24\ninet 192.168.1.5/24\n" | grep inet | awk '{print $2}' | cut -d/ -f1

### I3 — Find and copy by pattern

    mkdir -p dest
    find tree -type f -name "*.conf" -exec cp -a {} dest/ \;
    ls dest

### I4 — Deduplicate file

    sort words.txt | uniq > words.cleaned
    cat words.cleaned

### I5 — Find empty dirs and remove

    mkdir -p empty/a empty/b
    find empty -type d -empty
    find empty -type d -empty -delete

---

## J) Diagnosis Drills

### J1 — Why is this slow?

    find / -type f -name "*.conf"

Explain:
- crossing filesystems
- permissions noise
- missing `2>/dev/null`

Fix:

    find / -type f -name "*.conf" 2>/dev/null

### J2 — Why is this empty?

    grep '^root' data.txt

Explain: file has no such line.

---

## ✅ Completion Criteria

You are done with this file when:

- You never misorder `2>&1`
- You can build 3–5 stage pipelines without hesitation
- You use find with `-exec` and `-delete` safely (preview-first habit)
- You can use grep anchors/alternation instinctively
- You can use sed to replace and delete ranges safely (copy-before-`-i` habit)
- You can use awk to extract fields and filter records
- You can sort, dedupe, count, and select results quickly
- You can solve “find → filter → transform → select” tasks in under 60 seconds

---

