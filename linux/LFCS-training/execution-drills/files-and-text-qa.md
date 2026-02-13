# 🧪 Files and Text — Execution Drills (LFCS)

Mental mode:
Most LFCS tasks are: find → filter → transform → sort → select → write → act

---

## Atomic Drills — find

### Task: Find files by name and type instantly

<details>
<summary>Answer</summary>

### Find by name and type

    find tree -name "*.conf"
    find tree -type d
    find tree -type f

Repeat until instant.

</details>

---

### Task: Find files by size and verify results

<details>
<summary>Answer</summary>

### Find by size

    find . -type f -size +15k
    find . -type f -size +5k -size -30k

Verify with:

    ls -lh big1 big2 big3

</details>

---

### Task: Execute a command on each find result

<details>
<summary>Answer</summary>

### Find and exec

    find tree -type f -exec ls -l {} \;

Explain why `{}` and `\;` are needed.

</details>

---

### Task: Perform a safe delete using preview-first workflow

<details>
<summary>Answer</summary>

### Safe delete pattern (preview first)

Preview:

    find . -type f -name "*.log"

Then delete:

    find . -type f -name "*.log" -delete

Rule: always preview first.

</details>

---

## Atomic Drills — grep

### Task: Perform basic, count, and recursive searches

<details>
<summary>Answer</summary>

### B1 — Basic, count, recursive

    grep alice data.txt
    grep -c apple words.txt
    grep -R "conf" tree

</details>

---

### Task: Use anchors and alternation in pattern matching

<details>
<summary>Answer</summary>

### Anchors and alternation

    grep '^10' data.txt
    grep '75$' data.txt
    grep -E 'alice|carol' data.txt

</details>

---

### Task: Extract only the matching portion of a line

<details>
<summary>Answer</summary>

### Extract only matches

    echo "ID=54321" | grep -o '[0-9]\{5\}'

Note:
- Prefer `grep -E` for portability
- Use basic grep escaping when needed

</details>

---

## Atomic Drills — cut / tr

### Task: Extract specific fields from structured text

<details>
<summary>Answer</summary>

### cut fields

    cut -d' ' -f1,3 data.txt
    cut -d' ' -f2 data.txt

</details>

---

### Task: Translate and delete characters in streams

<details>
<summary>Answer</summary>

### tr translate and delete

    echo "a,b,c" | tr ',' ';'
    printf "a\r\nb\r\n" | tr -d '\r'

</details>

---

## Atomic Drills — awk

### Task: Print selected fields from structured input

<details>
<summary>Answer</summary>

### Print fields

    awk '{print $1, $3}' data.txt

</details>

---

### Task: Filter records by numeric condition

<details>
<summary>Answer</summary>

### Filter by condition

    awk '$3 > 100 {print $2, $3}' data.txt

</details>

---

### Task: Select a specific line range

<details>
<summary>Answer</summary>

### Line ranges

    awk 'NR>=2 && NR<=4' data.txt

</details>

---

### Task: Accumulate values and print a computed result

<details>
<summary>Answer</summary>

### Accumulate

    awk '{sum+=$3} END {print sum}' data.txt

</details>

---

##  Atomic Drills — sed

### Task: Perform substitutions on text streams

<details>
<summary>Answer</summary>

### E1 — Substitute

    sed 's/alice/ALICE/' data.txt
    sed 's/a/A/g' words.txt

</details>

---

### Task: Perform safe in-place edits using a working copy

<details>
<summary>Answer</summary>

### In-place edit (use a copy)

    cp words.txt words.work
    sed -i 's/apple/APPLE/g' words.work
    cat words.work

</details>

---

### Task: Delete specific lines and ranges

<details>
<summary>Answer</summary>

### Delete lines and ranges

    sed '2d' data.txt
    sed '1,2d' data.txt

</details>

---

## Atomic Drills — sort / uniq / wc / head / tail

### Task: Sort input and remove duplicates

<details>
<summary>Answer</summary>

### Sort and uniq

    sort words.txt
    sort words.txt | uniq
    sort -u words.txt

</details>

---

### Task: Count records and select top or bottom results

<details>
<summary>Answer</summary>

### Count and select

    wc -l data.txt
    sort -nr data.txt | head -n 3
    tail -n 2 data.txt

</details>

---

## Timed Drills (Speed)

### Task: Identify the largest file within 30 seconds

<details>
<summary>Answer</summary>

### Largest file in 30 seconds

    find . -type f -exec du -h {} + | sort -rh | head -n 1

Pass: identifies `big2`.

</details>

---

### Task: Show the top numeric consumers within 30 seconds

<details>
<summary>Answer</summary>

### Top consumers in 30 seconds

    sort -nr -k3 data.txt | head -n 3

</details>

---

### Task: Count unique words within 20 seconds

<details>
<summary>Answer</summary>

### Count unique words in 20 seconds

    sort words.txt | uniq -c

</details>

---

## Failure Injection Drills

### Task: Diagnose grep vs find misuse

<details>
<summary>Answer</summary>

### grep vs find confusion

Try:

    grep conf tree

Explain why it fails (grep needs file input; directory needs `-R` or a file list).

Correct answers:

    grep -R conf tree
    find tree -type f -name "*.conf"

</details>

---

### Task: Recover from an unsafe in-place sed operation

<details>
<summary>Answer</summary>

### sed -i regret simulation

    cp data.txt data.work
    sed -i 's/20/XXX/' data.work

Recover by recreating file from original.

Rule: always backup or work on copy.

</details>

---

### Task: Perform a safe delete with find using preview-first discipline

<details>
<summary>Answer</summary>

### find -delete paranoia drill

Preview:

    find . -type f -name "*.txt"

Only then:

    find . -type f -name "*.txt" -delete

Explain why preview is mandatory.

</details>

---

## Composition Drills (Exam Style)

### Task: Extract names where the value field is greater than 100

<details>
<summary>Answer</summary>

### Extract, transform, select
Goal: show only names where value > 100

    awk '$3 > 100 {print $2}' data.txt

</details>

---

### Task: Extract IP-style addresses from structured output

<details>
<summary>Answer</summary>

### IP-style extraction pattern (simulate)

    printf "inet 10.0.0.1/24\ninet 192.168.1.5/24\n" | grep inet | awk '{print $2}' | cut -d/ -f1

</details>

---

### Task: Find files by pattern and copy them while preserving attributes

<details>
<summary>Answer</summary>

### Find and copy by pattern

    mkdir -p dest
    find tree -type f -name "*.conf" -exec cp -a {} dest/ \;
    ls dest

</details>

---

### Task: Deduplicate a file and write the cleaned output

<details>
<summary>Answer</summary>

### Deduplicate file

    sort words.txt | uniq > words.cleaned
    cat words.cleaned

</details>

---

### Task: Find and remove empty directories

<details>
<summary>Answer</summary>

### Find empty dirs and remove

    mkdir -p empty/a empty/b
    find empty -type d -empty
    find empty -type d -empty -delete

</details>

---

## Diagnosis Drills

### Task: Diagnose a slow find command and apply the correct fix

<details>
<summary>Answer</summary>

### Why is this slow?

    find / -type f -name "*.conf"

Explain:
- crossing filesystems
- permissions noise
- missing `2>/dev/null`

Fix:

    find / -type f -name "*.conf" 2>/dev/null

</details>

---

### Task: Diagnose empty grep output correctly

<details>
<summary>Answer</summary>

### Why is this empty?

    grep '^root' data.txt

Explain: file has no such line.

</details>

---

## ✅ Completion Criteria

You are done with this file when:

- You use find with `-exec` and `-delete` safely (preview-first habit)
- You can use grep anchors/alternation instinctively
- You can use sed to replace and delete ranges safely (copy-before-`-i` habit)
- You can use awk to extract fields and filter records
- You can sort, dedupe, count, and select results quickly
- You can solve “find → filter → transform → select” tasks in under 60 seconds

---

