# 🧪 LFCS Execution Drills — Phase 2
# 🔎 Search, Parse, and Transform (find, grep, sed, awk, pipelines)

Path:
  linux/execution-drills/phase-2-search-parse-transform.md

Purpose:
  Turn Phase 2 into reflex-level ability to discover files, extract lines, transform streams, and compose multi-stage pipelines under time pressure.

Mental Mode:
  Most LFCS tasks are: find → filter → transform → sort → select → write → act

---

## 🧱 Lab Setup (Do once)

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

# A) Atomic Drills — find

## A1 — Find by name and type

    find tree -name "*.conf"
    find tree -type d
    find tree -type f

Repeat until instant.

---

## A2 — Find by size

    find . -type f -size +15k
    find . -type f -size +5k -size -30k

Verify with ls -lh.

---

## A3 — Find and exec

    find tree -type f -exec ls -l {} \;

Explain why {} and \; are needed.

---

## A4 — Safe delete pattern

Preview:

    find . -type f -name "*.log"

Then delete:

    find . -type f -name "*.log" -delete

Rule: always preview first.

---

# B) Atomic Drills — grep

## B1 — Basic, count, recursive

    grep alice data.txt
    grep -c apple words.txt
    grep -R "conf" tree

---

## B2 — Anchors and alternation

    grep '^10' data.txt
    grep '75$' data.txt
    grep -E 'alice|carol' data.txt

---

## B3 — Extract only matches

    echo "ID=54321" | grep -o '[0-9]\{5\}'

---

# C) Atomic Drills — cut / tr

## C1 — cut fields

    cut -d' ' -f1,3 data.txt
    cut -d' ' -f2 data.txt

---

## C2 — tr translate and delete

    echo "a,b,c" | tr ',' ';'
    printf "a\r\nb\r\n" | tr -d '\r'

---

# D) Atomic Drills — awk

## D1 — Print fields

    awk '{print $1, $3}' data.txt

## D2 — Filter by condition

    awk '$3 > 100 {print $2, $3}' data.txt

## D3 — Line ranges

    awk 'NR>=2 && NR<=4' data.txt

## D4 — Accumulate

    awk '{sum+=$3} END {print sum}' data.txt

---

# E) Atomic Drills — sed

## E1 — Substitute

    sed 's/alice/ALICE/' data.txt
    sed 's/a/A/g' words.txt

## E2 — In-place edit (use a copy)

    cp words.txt words.work
    sed -i 's/apple/APPLE/g' words.work
    cat words.work

## E3 — Delete lines

    sed '2d' data.txt
    sed '1,2d' data.txt

---

# F) Atomic Drills — sort / uniq / wc / head / tail

## F1 — Sort and uniq

    sort words.txt
    sort words.txt | uniq
    sort -u words.txt

## F2 — Count and select

    wc -l data.txt
    sort -nr data.txt | head -n 3
    tail -n 2 data.txt

---

# G) Timed Drills (Speed)

## G1 — Largest file in 30 seconds

    find . -type f -exec du -h {} + | sort -rh | head -n 1

Pass: identifies big2.

---

## G2 — Top consumers in 30 seconds

    sort -nr -k3 data.txt | head -n 3

---

## G3 — Count unique words in 20 seconds

    sort words.txt | uniq -c

---

# H) Failure Injection Drills

## H1 — grep vs find confusion

Try:

    grep conf tree

Explain why it fails.

Correct:

    find tree -type f -name "*.conf"

---

## H2 — sed -i regret simulation

    cp data.txt data.work
    sed -i 's/20/XXX/' data.work

Recover by recreating file from original.

Rule: always backup or work on copy.

---

## H3 — find -delete paranoia drill

Preview:

    find . -type f -name "*.txt"

Only then:

    find . -type f -name "*.txt" -delete

Explain why preview is mandatory.

---

# I) Composition Drills (Exam Style)

## I1 — Extract, transform, select

Goal: show only names where value > 100

    awk '$3 > 100 {print $2}' data.txt

---

## I2 — IP-style extraction pattern (simulate)

    printf "inet 10.0.0.1/24\ninet 192.168.1.5/24\n" | grep inet | awk '{print $2}' | cut -d/ -f1

---

## I3 — Find and copy by pattern

    mkdir -p dest
    find tree -type f -name "*.conf" -exec cp -a {} dest/ \;
    ls dest

---

## I4 — Deduplicate file

    sort words.txt | uniq > words.cleaned
    cat words.cleaned

---

## I5 — Find empty dirs and remove

    mkdir -p empty/a empty/b
    find empty -type d -empty
    find empty -type d -empty -delete

---

# J) Diagnosis Drills

## J1 — Why is this slow?

    find / -type f -name "*.conf"

Explain:
- crossing filesystems
- permissions
- missing 2>/dev/null

Fix:

    find / -type f -name "*.conf" 2>/dev/null

---

## J2 — Why is this empty?

    grep '^root' data.txt

Explain: file has no such line.

---

# ✅ Phase 2 Completion Criteria

You are Phase 2-ready when you can:

- Build 3–5 stage pipelines without hesitation
- Use find with -exec and -delete safely
- Use grep with anchors and alternation
- Use sed to replace and delete ranges
- Use awk to extract fields and filter records
- Sort, dedupe, count, and select results
- Solve “find → filter → transform → select” tasks in under 60 seconds

---

# 🔒 Phase 2 Law

If you can’t shape data flows, you can’t solve LFCS tasks fast enough.

---
