# 🧪 LFCS Execution Drills — Phase 3
# 📦 Archives, Compression, Backups, and Redirection

Path:
  linux/execution-drills/phase-3-archives-backups-redirection.md

Purpose:
  Build reflex-level safety and precision with packaging, compressing, copying, restoring, and capturing output.

Mental Mode:
  This phase is about **not destroying data** while moving it fast.

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-3
    cd ~/lfcs-labs/execution-drills/phase-3

Create sample data:

    mkdir -p data/src/projectA data/src/projectB logs backup restore
    echo "alpha" > data/src/projectA/a.txt
    echo "beta"  > data/src/projectA/b.txt
    echo "gamma" > data/src/projectB/c.txt
    date > logs/log1.txt
    date > logs/log2.txt

Create some size:

    dd if=/dev/zero of=data/src/projectA/big1 bs=1K count=10 status=none
    dd if=/dev/zero of=data/src/projectB/big2 bs=1K count=50 status=none

---

# A) Atomic Drills — tar

## A1 — Create and list archive

    tar cf backup/a1.tar data/src
    tar tf backup/a1.tar

---

## A2 — Create compressed archives

    tar czf backup/a2.tar.gz data/src
    tar cjf backup/a2.tar.bz2 data/src
    tar cJf backup/a2.tar.xz data/src

List one:

    tar tzf backup/a2.tar.gz

---

## A3 — Extract to specific directory

    mkdir -p restore/a3
    tar xf backup/a1.tar -C restore/a3
    ls restore/a3/data/src

---

## A4 — Extract single file

    tar tf backup/a1.tar
    tar xf backup/a1.tar data/src/projectA/a.txt -C restore/a3
    cat restore/a3/data/src/projectA/a.txt

---

# B) Atomic Drills — gzip / bzip2 / xz

## B1 — Compress while keeping original

    cp backup/a1.tar backup/test.tar
    gzip -k backup/test.tar
    ls backup/test.tar*

    bzip2 -k backup/test.tar
    xz -k backup/test.tar

---

## B2 — Decompress

    gunzip backup/test.tar.gz
    bunzip2 backup/test.tar.bz2
    unxz backup/test.tar.xz

Verify original still exists.

---

# C) zip / unzip

## C1 — Create and extract zip

    zip -r backup/c1.zip data/src
    mkdir -p restore/c1
    unzip backup/c1.zip -d restore/c1
    ls restore/c1

---

# D) Incremental / Differential Concept Drill

## D1 — Full backup

    tar czf backup/full.tgz data/src

Modify data:

    echo "delta" >> data/src/projectA/a.txt

Create “since time” diff:

    date -Iseconds > backup/last_full_time.txt
    tar czf backup/diff.tgz --newer-mtime="$(cat backup/last_full_time.txt)" data/src

List:

    tar tzf backup/diff.tgz

Explain restore order:
1) restore full
2) restore diffs

---

# E) rsync Drills

## E1 — Mirror copy

    mkdir -p mirror
    rsync -av data/src/ mirror/

Modify source:

    rm data/src/projectA/b.txt
    echo "new" > data/src/projectB/new.txt

Dry run delete mirror:

    rsync -av --delete --dry-run data/src/ mirror/

Real run:

    rsync -av --delete data/src/ mirror/

Verify mirror matches.

---

## E2 — Copy relative paths (exam pattern)

    mkdir -p backup/etc-like
    find data/src -name "*.txt" -exec rsync -R {} backup/etc-like \;
    find backup/etc-like

---

# F) dd Safety Drill (SIMULATION)

⚠️ DO NOT use real disks. Use files.

## F1 — Create fake “disk” file

    dd if=/dev/zero of=fake-disk.img bs=1M count=20 status=progress

Write pattern:

    echo "HELLO" | dd of=fake-disk.img conv=notrunc

Backup and compress:

    dd if=fake-disk.img bs=4M status=progress | gzip > backup/fake-disk.img.gz

Restore to new file:

    gunzip -c backup/fake-disk.img.gz | dd of=fake-disk-restored.img bs=4M status=progress

Verify:

    cmp fake-disk.img fake-disk-restored.img && echo OK

---

# G) Redirection Drills (Critical)

## G1 — Stdout vs stderr

    ls data/src > out.txt
    ls /no/such/path 2> err.txt
    cat out.txt
    cat err.txt

---

## G2 — Capture both

    ls /no/such/path > all.txt 2>&1
    cat all.txt

---

## G3 — Live view + save

    ls -R data/src 2>&1 | tee listing.txt

---

## G4 — Discard output

    ls /no/such/path > /dev/null 2>&1

---

# H) Script Output Capture

## H1 — Simulate script

    cat > test.sh <<EOF
    #!/bin/bash
    echo "normal output"
    ls /no/such/path
    EOF

    chmod +x test.sh

Stdout only:

    ./test.sh > script.out

Both:

    ./test.sh > script.all 2>&1

Live + save:

    ./test.sh 2>&1 | tee script.tee

---

# I) Here-Doc & Process Substitution

## I1 — Here-doc

    cat <<EOF > here.txt
    line1
    line2
    EOF

    cat here.txt

---

## I2 — Process substitution

    sort logs/log1.txt > s1.txt
    sort logs/log2.txt > s2.txt
    diff <(sort logs/log1.txt) <(sort logs/log2.txt)

---

# J) Timed Drills

## J1 — Extract to /restore in 20 seconds

    tar xf backup/a2.tar.gz -C restore

---

## J2 — Create tar + bzip2 + xz while keeping original (30 seconds)

    tar cf backup/sample.tar data/src
    bzip2 -k backup/sample.tar
    xz -k backup/sample.tar
    test -e backup/sample.tar && echo OK

---

## J3 — Capture command output (15 seconds)

    ls /no/such/path > logs/capture.txt 2>&1

---

# K) Failure Injection Drills

## K1 — Forgetting -C

Extract in wrong place:

    tar xf backup/a1.tar

Cleanup, then extract properly:

    rm -rf data/src
    mkdir -p restore/proper
    tar xf backup/a1.tar -C restore/proper

Explain why -C matters.

---

## K2 — Dangerous rsync

Simulate wrong direction:

    rsync -av --delete mirror/ data/src/ --dry-run

Explain why this would destroy source.

---

## K3 — tar -P danger (DO NOT RUN ON REAL SYSTEM)

Explain:

    tar cfP root.tar /etc

Why this can overwrite system files on extract.

---

# L) Composition (Exam Style)

## L1 — Backup, verify, restore

    tar czf backup/comp.tgz data/src
    tar tzf backup/comp.tgz
    mkdir -p restore/comp
    tar xf backup/comp.tgz -C restore/comp
    diff -r data/src restore/comp/data/src

---

## L2 — Mirror and log

    rsync -av --delete data/src/ mirror/ > logs/rsync.log 2>&1
    tail -n 20 logs/rsync.log

---

# ✅ Phase 3 Completion Criteria

You are Phase 3-ready when you can:

- Create and extract tar archives in any format
- Compress/decompress while preserving originals
- Extract single files and to specific directories
- Use rsync safely with --delete and --dry-run
- Capture stdout vs stderr correctly
- Use tee for live logging
- Perform dd backups using file targets
- Never destroy the wrong data

---

# 🔒 Phase 3 Law

If you can’t move and preserve data safely, you’re a liability.

---
