# 📦 Phase 3 — Archives, Compression, Backups, and Redirection
*LFCS operational muscle: move, package, preserve, and restore data safely.*

---

## 📌 Purpose

This phase makes you **reliable under pressure** with:

- Creating and extracting archives
- Choosing the right compression format
- Preserving ownership, permissions, and timestamps
- Redirecting output correctly (stdout vs stderr)
- Capturing logs, verifying results, and restoring data

Many LFCS tasks are **not** about creating archives — they are about:
> “Move this data safely, prove it worked, and don’t lose the original.”

---

## 🧠 Mental Model

- `tar` = archive (container)
- `gzip`, `bzip2`, `xz` = compression (squeeze)
- Redirection decides **where output goes**
- Backups must:
  - Preserve metadata
  - Be verifiable
  - Be restorable in the correct order

---

# 🗜️ Part A — tar (The Workhorse)

## Create archives

Create:

    tar cf archive.tar /path/to/data

Verbose:

    tar cvf archive.tar /path/to/data

Preserve permissions & ownership (default when run as root):

    tar cpf archive.tar /path/to/data

With compression:

    tar czf archive.tar.gz /path/to/data
    tar cjf archive.tar.bz2 /path/to/data
    tar cJf archive.tar.xz /path/to/data

---

## List contents

    tar tf archive.tar
    tar tzf archive.tar.gz

---

## Extract

Extract here:

    tar xf archive.tar

Extract to directory:

    tar xf archive.tar -C /restore

Extract one file:

    tar xf archive.tar path/inside/archive/file.txt

---

## Absolute paths (dangerous but sometimes required)

Create:

    tar cfP logs.tar /var/log

Extract:

    tar xfP logs.tar

---

# 🧱 Part B — gzip, bzip2, xz

Compress (keeps original with -k):

    gzip -k file.tar
    bzip2 -k file.tar
    xz -k file.tar

Decompress:

    gunzip file.tar.gz
    bunzip2 file.tar.bz2
    unxz file.tar.xz

View help:

    gzip --help
    bzip2 --help
    xz --help

---

# 🧾 Part C — zip / unzip (sometimes required)

Extract:

    unzip sample.zip -d /opt/

Create:

    zip -r archive.zip directory/

---

# 🔁 Part D — Incremental & Differential Backups (tar)

Create full backup:

    tar czf full.tgz /data

Create differential since last full:

    tar czf diff.tgz --newer-mtime="2026-01-01" /data

Restore order:

1) Restore full
2) Restore diffs in chronological order

---

# 🪞 Part E — rsync (Mirror Tool)

Mirror with deletion:

    rsync -av --delete /src/ /dest/

Dry run:

    rsync -av --delete --dry-run /src/ /dest/

Preserve everything:

    rsync -a /src/ /dest/

Copy relative paths (exam pattern):

    find /etc -name "*.conf" -exec rsync -R {} /backup \;

---

# 🧨 Part F — Raw Disk Backup (dd)

Backup disk to compressed image:

    dd if=/dev/vdb bs=4M status=progress | gzip > /backup/vdb.img.gz

Restore:

    gunzip -c /backup/vdb.img.gz | dd of=/dev/vdb bs=4M status=progress

⚠️ Extremely dangerous — double-check devices.

---

# 📤 Part G — Output Redirection (Critical Skill)

## stdout

    command > out.txt
    command >> out.txt

## stderr

    command 2> err.txt
    command 2>> err.txt

## Both

    command > all.txt 2>&1
    command 2>&1 | tee output.txt

## Discard

    command > /dev/null
    command 2> /dev/null
    command > /dev/null 2>&1

---

## Capture output of a script

Stdout only:

    ./script.sh > output.txt

Stdout + stderr:

    ./script.sh > output.txt 2>&1

With live view:

    ./script.sh 2>&1 | tee output.txt

---

# 📥 Part H — Here-Docs & Process Substitution

Here-doc:

    cat <<EOF > file.txt
    line1
    line2
    EOF

Process substitution:

    diff <(sort file1) <(sort file2)

---

# 🧪 Canonical Exam Scenarios

Extract archive into /opt:

    tar xf /mnt/backup/backup.tar.bz2 -C /opt

Create tar, then compress with bzip2 and xz but keep original:

    tar cf /opt/SAMPLE.tar /opt/SAMPLE001
    bzip2 -k /opt/SAMPLE.tar
    xz -k /opt/SAMPLE.tar

Verify original still exists:

    test -e /opt/SAMPLE.tar && echo OK

Save command output:

    grub-install /dev/vda > /home/bob/grub.txt 2>&1

Mirror directory and delete removed files:

    rsync -av --delete /data/ /backup/

---

## ⚠️ Failure Modes

- Forgetting -C when extracting
- Overwriting system paths with tar -P
- Using dd on wrong device
- Losing original tar by forgetting -k
- Mixing stdout and stderr unintentionally

---

## 🏁 Phase 3 Mastery Checklist

You must be able to:

- Create and extract tar archives in any format
- Compress and decompress with gzip/bzip2/xz
- Extract single files from archives
- Preserve metadata
- Use rsync for mirroring
- Redirect stdout and stderr correctly
- Capture logs and command output
- Use dd safely for disk images

---

## 🔒 Exam Law

> **If you can’t move and preserve data safely, you’re not an administrator — you’re a risk.**

---
