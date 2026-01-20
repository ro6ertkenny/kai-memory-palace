# ⚔️ Phase 2 — Search, Parse, and Transform (Execution Playbook)
*LFCS speed layer: if you can’t shape data streams fast and precisely, you will time out.*

Path:
- linux/LFCS-execution-playbooks/phase-2-search-parse-transform.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- find files precisely with find
- extract lines with grep
- extract fields with cut and awk
- transform streams with sed
- shape results with sort, uniq, wc, head, tail
- build 3–6 stage pipelines without thinking
- never destroy data accidentally

---

## 🧱 Lab Root

All Phase 2 drills run in:

- ~/lfcs-labs/phase-2

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-2
    cd ~/lfcs-labs/phase-2
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 2 when you can complete P2-1 through P2-14:

- in ≤ 75 minutes total
- with zero verification failures
- without trial-and-error pipelines

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P2-1 — Find by name and type

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-1 && mkdir -p p2-1/dir/sub
    cd p2-1
    touch a.txt b.log dir/c.txt dir/sub/d.txt

Task:
Find all .txt files and save to result.txt

Do:

    find . -type f -name "*.txt" > result.txt

Verify:

    wc -l result.txt
    sort result.txt

Expected:
- 3 entries

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-2 — Find by size

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-2 && mkdir p2-2
    cd p2-2
    dd if=/dev/zero of=small.bin bs=1K count=1
    dd if=/dev/zero of=big.bin bs=1M count=2

Task:
Find files larger than 1M and save to bigfiles.txt

Do:

    find . -type f -size +1M > bigfiles.txt

Verify:

    cat bigfiles.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-3 — Find and exec

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-3 && mkdir p2-3
    cd p2-3
    touch a.conf b.conf c.txt

Task:
List only .conf files using find -exec and save to list.txt

Do:

    find . -type f -name "*.conf" -exec ls -l {} + > list.txt

Verify:

    wc -l list.txt
    cat list.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-4 — Grep with anchors

Time limit:
- 4 minutes

Task:
From /etc/passwd extract only the line starting with root and save to root.txt

Do:

    grep '^root:' /etc/passwd > root.txt

Verify:

    cat root.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-5 — Field extraction with cut

Time limit:
- 4 minutes

Task:
Extract usernames from /etc/passwd and save to users.txt

Do:

    cut -d: -f1 /etc/passwd > users.txt

Verify:

    wc -l users.txt
    head users.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-6 — Filter + extract

Time limit:
- 5 minutes

Task:
From /etc/passwd:
- keep only users with /bin/bash
- extract only usernames
- save to bash-users.txt

Do:

    grep '/bin/bash$' /etc/passwd | cut -d: -f1 > bash-users.txt

Verify:

    wc -l bash-users.txt
    head bash-users.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-7 — Sort and unique

Time limit:
- 4 minutes

Task:
Sort users.txt and remove duplicates into users.sorted

Do:

    sort users.txt | uniq > users.sorted

Verify:

    wc -l users.sorted
    head users.sorted

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-8 — Count matches

Time limit:
- 3 minutes

Task:
Count how many bash users exist and save number to count.txt

Do:

    wc -l bash-users.txt | awk '{print $1}' > count.txt

Verify:

    cat count.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-9 — Sed replace (in-place)

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-9 && mkdir p2-9
    cd p2-9
    printf "a,b,c\nd,e,f\n" > data.csv

Task:
Replace commas with semicolons in-place.

Do:

    sed -i 's/,/;/g' data.csv

Verify:

    cat data.csv

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-10 — Sed delete range

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-10 && mkdir p2-10
    cd p2-10
    seq 1 100 > numbers.txt

Task:
Delete lines 1–50 and save remaining to out.txt

Do:

    sed '1,50d' numbers.txt > out.txt

Verify:

    head out.txt
    wc -l out.txt

Expected:
- first line = 51
- line count = 50

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-11 — Awk field selection

Time limit:
- 4 minutes

Task:
From /etc/passwd extract:
- username
- uid
Save to user_uids.txt

Do:

    awk -F: '{print $1, $3}' /etc/passwd > user_uids.txt

Verify:

    head user_uids.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-12 — Pipeline shaping

Time limit:
- 6 minutes

Task:
From:

    ip a

Extract:
- only IPv4 addresses
- without mask
- save to ips.txt

One valid solution:

    ip a | grep ' inet ' | awk '{print $2}' | cut -d/ -f1 > ips.txt

Verify:

    cat ips.txt

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-13 — Largest file pipeline

Time limit:
- 7 minutes

Task:
Find the largest file under /usr and print only its path to largest.txt

One valid solution:

    find /usr -type f -exec du -b {} + | sort -n | tail -1 | awk '{print $2}' > largest.txt

Verify:

    cat largest.txt
    test -e "$(cat largest.txt)" && echo OK

Reset:

    cd ~/lfcs-labs/phase-2

-------------------------------------------------------------------------------

## P2-14 — Safe delete drill

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/phase-2
    rm -rf p2-14 && mkdir p2-14
    cd p2-14
    touch a.tmp b.tmp c.log

Task:
Delete only *.tmp using find (not rm *.tmp).

Do:

    find . -type f -name "*.tmp" -delete

Verify:

    ls

Expected:
- only c.log remains

Reset:

    cd ~/lfcs-labs/phase-2

---

## 🏁 Phase 2 Pass Criteria

You can:

- build 3–6 stage pipelines without hesitation
- use find with predicates and -exec correctly
- use grep anchors and filters correctly
- extract fields with cut and awk
- transform streams with sed
- sort, deduplicate, count, and select results
- shape data safely without destroying it

---

## 🔒 Phase 2 Law

If you can’t shape data flows quickly and precisely,
you will not finish the LFCS exam in time.

---
