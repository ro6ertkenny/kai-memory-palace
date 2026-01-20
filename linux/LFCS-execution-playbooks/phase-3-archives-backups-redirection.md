# ⚔️ Phase 3 — Archives, Backups, and Redirection (Execution Playbook)
*LFCS data-safety layer: if you can’t package, move, restore, and log data safely, you will destroy systems under pressure.*

Path:
- linux/LFCS-execution-playbooks/phase-3-archives-backups-redirection.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- create and extract tar archives in any format
- preserve ownership, permissions, and timestamps
- extract single files from archives
- use gzip, bzip2, xz correctly
- mirror data with rsync safely
- capture stdout and stderr correctly
- prove backups worked
- restore data in the correct order
- avoid destroying data with tar or dd

---

## 🧱 Lab Root

All Phase 3 drills run in:

- ~/lfcs-labs/phase-3

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-3
    cd ~/lfcs-labs/phase-3
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 3 when you can complete P3-1 through P3-14:

- in ≤ 75 minutes total
- with zero verification failures
- without guessing tar flags
- without overwriting the wrong paths

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P3-1 — Create a tar archive

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-1 && mkdir p3-1
    cd p3-1
    mkdir data
    echo a > data/a.txt
    echo b > data/b.txt

Task:
Create archive.tar containing data/

Do:

    tar cf archive.tar data

Verify:

    tar tf archive.tar

Expected:
- data/
- data/a.txt
- data/b.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-2 — Create compressed archives

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-2 && mkdir p3-2
    cd p3-2
    mkdir data
    echo x > data/x.txt

Task:
Create:
- data.tar.gz
- data.tar.bz2
- data.tar.xz

Do:

    tar czf data.tar.gz data
    tar cjf data.tar.bz2 data
    tar cJf data.tar.xz data

Verify:

    ls -l *.tar*

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-3 — List archive contents without extracting

Time limit:
- 3 minutes

Task:
List contents of data.tar.gz from P3-2.

Do:

    tar tzf data.tar.gz

Verify:
- output shows data/x.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-4 — Extract to specific directory

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-4 && mkdir p3-4
    cd p3-4
    mkdir src dst
    echo hello > src/hello.txt
    tar czf src.tgz src

Task:
Extract into dst/.

Do:

    tar xzf src.tgz -C dst

Verify:

    ls -R dst

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-5 — Extract single file from archive

Time limit:
- 4 minutes

Task:
Extract only src/hello.txt from src.tgz.

Do:

    tar xzf src.tgz src/hello.txt

Verify:

    test -f src/hello.txt && echo OK

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-6 — Preserve permissions and ownership

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-6 && mkdir p3-6
    cd p3-6
    mkdir data
    echo secret > data/file.txt
    chmod 600 data/file.txt
    tar cpf backup.tar data
    rm -rf data

Task:
Restore and prove permissions preserved.

Do:

    tar xpf backup.tar

Verify:

    ls -l data/file.txt

Expected:
- -rw-------

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-7 — gzip, bzip2, xz standalone

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-7 && mkdir p3-7
    cd p3-7
    echo data > file.tar

Task:
Compress file.tar with:
- gzip -k
- bzip2 -k
- xz -k

Do:

    gzip -k file.tar
    bzip2 -k file.tar
    xz -k file.tar

Verify:

    ls -l

Expected:
- file.tar
- file.tar.gz
- file.tar.bz2
- file.tar.xz

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-8 — Mirror directory with rsync

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-8 && mkdir p3-8
    cd p3-8
    mkdir src dst
    echo a > src/a.txt
    echo b > src/b.txt

Task:
Mirror src/ to dst/.

Do:

    rsync -av src/ dst/

Verify:

    ls dst

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-9 — Mirror with deletion

Time limit:
- 6 minutes

Setup:
(continue from P3-8)

Do:

    rm src/b.txt
    rsync -av --delete src/ dst/

Verify:

    ls dst

Expected:
- only a.txt remains

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-10 — Capture stdout only

Time limit:
- 3 minutes

Task:
Save output of:

    ls /etc

to out.txt.

Do:

    ls /etc > out.txt

Verify:

    test -s out.txt && wc -l out.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-11 — Capture stderr only

Time limit:
- 3 minutes

Task:
Run:

    ls /no/such/path

Save error to err.txt.

Do:

    ls /no/such/path 2> err.txt

Verify:

    test -s err.txt && cat err.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-12 — Capture both stdout and stderr

Time limit:
- 4 minutes

Task:
Run:

    ls /etc /no/such/path

Save both streams to all.txt.

Do:

    ls /etc /no/such/path > all.txt 2>&1

Verify:

    test -s all.txt && wc -l all.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-13 — Capture with live view (tee)

Time limit:
- 4 minutes

Task:
Run:

    dmesg

Save output to dmesg.txt and still see it.

Do:

    dmesg | tee dmesg.txt

Verify:

    test -s dmesg.txt && wc -l dmesg.txt

Reset:

    cd ~/lfcs-labs/phase-3

-------------------------------------------------------------------------------

## P3-14 — Raw backup simulation (safe file)

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/phase-3
    rm -rf p3-14 && mkdir p3-14
    cd p3-14
    dd if=/dev/zero of=disk.img bs=1M count=10

Task:
Create compressed backup and restore it.

Do:

    dd if=disk.img bs=1M status=progress | gzip > disk.img.gz
    rm disk.img
    gunzip -c disk.img.gz | dd of=disk.img bs=1M status=progress

Verify:

    ls -lh disk.img
    test -f disk.img && echo OK

Reset:

    cd ~/lfcs-labs/phase-3

---

## 🏁 Phase 3 Pass Criteria

You can:

- create and extract tar archives in any format
- extract single files from archives
- preserve metadata
- use gzip/bzip2/xz correctly
- mirror data safely with rsync
- capture stdout, stderr, or both on demand
- log command output with tee
- perform safe raw backups and restores

---

## 🔒 Phase 3 Law

If you cannot move and preserve data safely,
you are a liability, not an administrator.

---
