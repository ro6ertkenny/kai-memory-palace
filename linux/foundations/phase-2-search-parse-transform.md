# 🔎 Phase 2 — Search, Parse, and Transform (find, grep, sed, awk, pipelines)
*LFCS superpower: turn the filesystem and text streams into precise answers, fast.*

---

## 📌 Purpose

This phase makes you **dangerous (in a good way)** with:

- Finding the **right files**
- Extracting the **right lines**
- Transforming text **safely and repeatably**
- Building **multi-stage pipelines** that solve exam tasks in seconds

Most LFCS tasks are **not** “run one command”. They are:

> find → filter → transform → sort → select → write → act

---

## 🧠 Mental Model

- `find` discovers **files**
- `grep`/`egrep` discovers **lines**
- `sed` edits **streams**
- `awk` selects **fields/records**
- `sort/uniq/wc/head/tail` **shape results**
- Pipes glue everything together

---

# 🗺️ Part A — find (Filesystem Search Engine)

## 🔍 Core Patterns

Find by name:

    find /etc -name "ssh*"
    find / -iname "*.conf"

Find by type:

    find /var -type f
    find /var -type d

Find by size:

    find /usr -type f -size +100M
    find /usr -type f -size +5M -size -10M

Find by time:

    find /var/log -type f -mmin -60
    find /home -type f -mtime +30

Find by owner/group:

    find /etc -type f ! -user root
    find /data -type f -group developers

Find by permissions:

    find /usr -type f -perm -4000
    find /var -type f -perm -0020 ! -perm -0002
    find /home -type f -perm 0640

---

## ⚙️ Actions

Print safely:

    find /data -type f -print

Execute command:

    find /data -type f -exec ls -l {} \;

Delete (use with extreme care):

    find /tmp -type f -mtime +7 -delete

Copy preserving tree:

    find /src -type f -name "*.conf" -exec rsync -R {} /dest \;

Custom output:

    find /srv -type f -name "*.tar" -printf "./%P\n"

---

## 🧪 Exam Patterns (find)

Find largest file and delete it:

    find /data -type f -exec du -h {} + | sort -rh | head -n 1

Find SUID binaries:

    find /usr -type f -perm -4000

Find files by inode and delete:

    find / -inum 123456 -delete

---

# 🧾 Part B — grep / egrep (Line Search)

## 🔍 Core Usage

Basic:

    grep root /etc/passwd

Case-insensitive:

    grep -i error /var/log/syslog

Whole word:

    grep -w ssh /etc/services

Count:

    grep -c FAILED /var/log/auth.log

Recursive:

    grep -R "PermitRootLogin" /etc/ssh

---

## 🧬 Regex Anchors

Start of line:

    grep '^root' /etc/passwd

End of line:

    grep 'bash$' /etc/passwd

Either/or:

    grep -E 'error|fail' logfile

---

## 🎯 Extract Only Matches

Print only matching part:

    grep -o '[0-9]\{5\}' file
    grep -oP '\b[A-Z][a-z]{2,}\b' /etc/nsswitch.conf

---

# ✂️ Part C — cut / tr

Cut fields:

    cut -d: -f1 /etc/passwd
    cut -d, -f2,5 data.csv

Translate characters:

    tr ',' ';' < file.csv > file.scsv

Delete characters:

    tr -d '\r' < dosfile.txt > unixfile.txt

---

# 🧮 Part D — awk (Field & Record Engine)

Print fields:

    awk '{print $1, $5}' file

Filter lines:

    awk '$3 > 100 {print $1, $3}' data.txt

By line number:

    awk 'NR>=500 && NR<=2000' bigfile.txt

Count:

    awk '{sum+=$1} END {print sum}' numbers.txt

---

# ✏️ Part E — sed (Stream Editor)

Replace globally:

    sed 's/enabled/disabled/g' file

In-place edit:

    sed -i 's/old/new/g' file

Delete line:

    sed -i '37d' file

Delete range:

    sed '1,1000d' file

Complex delimiter:

    sed 's@/old/path@/new/path@g' file

Use capture groups:

    sed -E 's/(eth)([0-9]+)/\1X\2/g' file

---

# 📊 Part F — sort / uniq / wc / head / tail

Sort numeric reverse:

    sort -nr sizes.txt

Unique:

    sort file | uniq
    sort -u file

Count lines:

    wc -l file

Top N:

    sort -nr sizes.txt | head -n 10

Bottom N:

    tail -n 50 logfile

---

# 🔗 Part G — diff

Compare files:

    diff file1 file2

Compare trees:

    diff -r dir1 dir2

---

# 🧵 Part H — Building Pipelines (Where the Power Is)

Examples:

Count failed logins:

    grep FAILED /var/log/auth.log | wc -l

Find files and save list:

    find /usr -type f -size +4M > /root/big-files.txt

Find and copy by owner:

    find /etc -type f ! -user root -exec cp -a {} /root/other_users/ \;

Extract and transform:

    ip a | grep inet | awk '{print $2}' | cut -d/ -f1

---

# 🧪 Canonical Exam Scenarios

Find files modified in last hour:

    find /var -type f -mmin -60

Find all empty dirs and remove:

    find /srv/data -type d -empty -delete

Replace commas with semicolons in-place:

    sed -i 's/,/;/g' file.csv

Remove duplicate lines:

    sort file | uniq > file.cleaned

Join two files by key (simple case):

    join file1 file2

Show only lines starting with “this” or “That” (case-insensitive):

    grep -iE '^(this|that)' file

---

## ⚠️ Failure Modes

- Running `-delete` before verifying results
- Forgetting quotes around patterns
- Using grep when tool needs filenames (use find)
- Using sed -i without backup
- Misunderstanding field separators

---

## 🏁 Phase 2 Mastery Checklist

You must be able to:

- Build 3–5 stage pipelines
- Use find + -exec correctly
- Use grep with anchors and alternation
- Use sed to delete, replace, and transform
- Use awk to extract columns and ranges
- Sort, deduplicate, count, and select results
- Redirect outputs to files reliably

---

## 🔒 Exam Law

> **If you can’t *shape data flows*, you can’t solve LFCS tasks fast enough.**

This phase is where speed comes from.

---
