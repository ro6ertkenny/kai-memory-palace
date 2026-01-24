# 🧪 Archives, Backups, and Redirection — Execution Drills (LFCS)

**Path:** `linux/LFCS-training/execution-drills/archives-backups-redirection.md`  
Mental mode: **Data safety + repeatable packaging/restore + correct logging**  
Goal: Be able to **package, move, restore, and capture output safely** under LFCS time pressure.

This is not a tutorial.  
This is an **execution checklist + timed drill pack**.

---

## ✅ Mapping Decision (Legacy Phase 3 → LFCS-training)

This legacy file is **execution-drills**, not an operator playbook.

Why:
- it is time-boxed command reps + verification
- it trains “hands” (tar/rsync/dd/redirect), not incident classification algorithms

Related drill packs already exist:
- Redirection/tee reps already live in `linux/LFCS-training/execution-drills/files-and-text.md` (Phase 0 pack)

Related operator playbooks (consumers of these primitives):
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (when restore fails due to mounts/RO/full disk)
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (when restore breaks permissions/ownership/SELinux)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (when service configs/data are restored and service won’t start)

---

## 🧭 Safety Rules (Non-Negotiable)

- Never extract archives into unknown paths.
- Always list archive contents before extraction.
- Prefer extracting into an empty target directory.
- For destructive transforms, work on copies.
- For `rsync --delete`, preview intent and validate source/target are correct.
- For `dd`, only operate on lab files; always prove input/output file names.

---

## 🧱 Lab Root

All drills run in:

- `~/lfcs-labs/execution-drills/phase-3`

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/execution-drills/phase-3
    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf ./*

---

## 🧪 Completion Standard

Pass this file when you can complete D3-1 through D3-14:

- in ≤ 75 minutes total
- with zero verification failures
- without guessing tar flags
- without overwriting the wrong paths

---

# 🧪 Phase 3 Drill Pack — Archives, Backups, Redirection

-------------------------------------------------------------------------------

## D3-1 — Create a tar archive

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-1 && mkdir d3-1
    cd d3-1
    mkdir data
    echo a > data/a.txt
    echo b > data/b.txt

Task:
Create `archive.tar` containing `data/`.

Do:

    tar cf archive.tar data

Verify:

    tar tf archive.tar

Expected:
- data/
- data/a.txt
- data/b.txt

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-2 — Create compressed archives (.gz, .bz2, .xz)

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-2 && mkdir d3-2
    cd d3-2
    mkdir data
    echo x > data/x.txt

Task:
Create:
- `data.tar.gz`
- `data.tar.bz2`
- `data.tar.xz`

Do:

    tar czf data.tar.gz data
    tar cjf data.tar.bz2 data
    tar cJf data.tar.xz data

Verify:

    ls -l *.tar*

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-3 — List archive contents without extracting

Time limit:
- 3 minutes

Setup:
(continue from D3-2)

Task:
List contents of `data.tar.gz`.

Do:

    tar tzf data.tar.gz

Verify:
- output shows `data/x.txt`

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-4 — Extract to a specific directory (safe target)

Time limit:
- 4 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-4 && mkdir d3-4
    cd d3-4
    mkdir src dst
    echo hello > src/hello.txt
    tar czf src.tgz src

Task:
Extract into `dst/`.

Do:

    tar xzf src.tgz -C dst

Verify:

    ls -R dst

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-5 — Extract a single file from an archive

Time limit:
- 4 minutes

Setup:
(continue from D3-4)

Task:
Extract only `src/hello.txt` from `src.tgz`.

Do:

    rm -rf src
    tar xzf src.tgz src/hello.txt

Verify:

    test -f src/hello.txt && echo OK

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-6 — Preserve permissions (and ownership when applicable)

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-6 && mkdir d3-6
    cd d3-6
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

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-7 — gzip, bzip2, xz standalone (keep original)

Time limit:
- 5 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-7 && mkdir d3-7
    cd d3-7
    echo data > file.tar

Task:
Compress `file.tar` with:
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

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-8 — Mirror directory with rsync (copy mode)

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-8 && mkdir d3-8
    cd d3-8
    mkdir src dst
    echo a > src/a.txt
    echo b > src/b.txt

Task:
Mirror `src/` to `dst/`.

Do:

    rsync -av src/ dst/

Verify:

    ls dst
    diff -ur src dst

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-9 — Mirror with deletion (danger flag)

Time limit:
- 6 minutes

Setup:
(continue from D3-8)

Task:
Remove `src/b.txt`, then mirror with `--delete` so dst matches src.

Do:

    rm src/b.txt
    rsync -av --delete src/ dst/

Verify:

    ls dst

Expected:
- only a.txt remains

Rule:
- Never use `--delete` unless you are absolutely sure src/ is the truth source.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-10 — Capture stdout only

Time limit:
- 3 minutes

Task:
Save output of `ls /etc` to out.txt.

Do:

    cd ~/lfcs-labs/execution-drills/phase-3
    ls /etc > out.txt

Verify:

    test -s out.txt && wc -l out.txt

Note:
- This is also drilled in `files-and-text.md` Phase 0.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-11 — Capture stderr only

Time limit:
- 3 minutes

Task:
Run `ls /no/such/path` and save error to err.txt.

Do:

    cd ~/lfcs-labs/execution-drills/phase-3
    ls /no/such/path 2> err.txt

Verify:

    test -s err.txt && cat err.txt

Note:
- This is also drilled in `files-and-text.md` Phase 0.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-12 — Capture both stdout and stderr (correct ordering)

Time limit:
- 4 minutes

Task:
Run `ls /etc /no/such/path` and save both streams to all.txt.

Do:

    cd ~/lfcs-labs/execution-drills/phase-3
    ls /etc /no/such/path > all.txt 2>&1

Verify:

    test -s all.txt && wc -l all.txt

Pass condition:
- You can state the rule: `2>&1` must come after stdout is redirected.

Note:
- This is also drilled in `files-and-text.md` Phase 0.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-13 — Capture with live view (tee)

Time limit:
- 4 minutes

Task:
Run `dmesg`, save to `dmesg.txt`, and still see output.

Do:

    cd ~/lfcs-labs/execution-drills/phase-3
    dmesg | tee dmesg.txt

Verify:

    test -s dmesg.txt && wc -l dmesg.txt

Note:
- This is also drilled in `files-and-text.md` Phase 0.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

-------------------------------------------------------------------------------

## D3-14 — Raw backup simulation (safe file only)

Time limit:
- 6 minutes

Setup:

    cd ~/lfcs-labs/execution-drills/phase-3
    rm -rf d3-14 && mkdir d3-14
    cd d3-14
    dd if=/dev/zero of=disk.img bs=1M count=10 status=progress

Task:
Create compressed backup and restore it.

Do:

    dd if=disk.img bs=1M status=progress | gzip > disk.img.gz
    rm disk.img
    gunzip -c disk.img.gz | dd of=disk.img bs=1M status=progress

Verify:

    ls -lh disk.img
    test -f disk.img && echo OK

Rules:
- Never run `dd` against real block devices in drills.
- Always verify filenames and current working directory.

Reset:

    cd ~/lfcs-labs/execution-drills/phase-3

---

## 🏁 Pass Criteria

You can:

- create and extract tar archives in any format
- extract single files from archives
- preserve metadata correctly
- use gzip/bzip2/xz correctly
- mirror data safely with rsync (and understand `--delete`)
- capture stdout, stderr, or both on demand
- log command output with tee
- perform safe raw backups and restores

---

## 🔒 Operator Law

If you cannot move and preserve data safely,
you are a liability, not an administrator.

---
