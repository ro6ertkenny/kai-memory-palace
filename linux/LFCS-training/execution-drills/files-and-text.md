i# 🧪 Files and Text — Execution Drills (LFCS)

Mental mode: Precision and speed.  
Goal: Be able to **create, inspect, transform, and analyze text and files** without hesitation.

This is not a tutorial.  
This is an **execution checklist**.

---

## 📄 1) Create and Inspect Files

- Create empty files
- Create files with content
- Show file type
- Show file size
- Show file metadata
- Show file content in multiple ways

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

- Count lines
- Count words
- Count bytes
- Show only totals

    wc a.txt
    wc -l a.txt
    wc -w a.txt
    wc -c a.txt

---

## 🧭 3) Head, Tail, and Following Files

- Show first N lines
- Show last N lines
- Follow a growing file
- Follow with retry

    head -n 5 /etc/passwd
    tail -n 5 /etc/passwd
    tail -f /var/log/syslog
    tail -F /var/log/syslog

---

## 🔍 4) Searching Text with grep

- Basic search
- Case-insensitive search
- Invert match
- Recursive search
- Show line numbers
- Show only filenames
- Match whole words
- Match whole lines

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

- Match beginning of line
- Match end of line
- Match digits
- Match ranges
- Match repeated patterns
- Extract with Perl regex

    grep '^root' /etc/passwd
    grep 'bash$' /etc/passwd
    grep '[0-9][0-9][0-9]' somefile.txt
    grep '[a-z][a-z][a-z]' somefile.txt
    grep -E '(ha){2,}' laugh.txt
    grep -P '(?<=root).*' /etc/passwd

---

## ✂️ 6) Cutting and Field Extraction

- Cut by delimiter
- Extract specific fields
- Change delimiter

    cut -d ':' -f 1 /etc/passwd
    cut -d ':' -f 1,3,7 /etc/passwd
    cut -d ',' -f 2,3 file.csv

---

## 🔄 7) Translating and Cleaning Text (tr)

- Replace characters
- Delete characters
- Squeeze repeats
- Uppercase to lowercase

    tr ',' ';' < file.csv
    tr -d ':' < /etc/passwd
    tr -s ' ' < messy.txt
    tr 'A-Z' 'a-z' < UPPER.txt

---

## 🧱 8) Sorting and Uniqueness

- Sort alphabetically
- Sort numerically
- Reverse sort
- Unique lines
- Count duplicates

    sort file.txt
    sort -n numbers.txt
    sort -r file.txt
    uniq file.txt
    sort file.txt | uniq
    sort file.txt | uniq -c

---

## 🔗 9) Joining and Pasting Files

- Paste side-by-side
- Join on first field
- Join on specific fields

    paste a.txt b.txt
    join file1.txt file2.txt
    join -1 2 -2 1 file1.txt file2.txt

---

## 🧩 10) Splitting Files

- Split by number of chunks
- Split by size
- Split by lines

    split -n 3 bigfile.txt
    split -b 1M bigfile.txt
    split -l 100 bigfile.txt

---

## 🧹 11) sed Editing Drills

- Print specific lines
- Delete lines
- Substitute once
- Substitute globally
- Substitute only Nth occurrence
- Use groups

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed 's/foo/bar/2' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

## 🧮 12) awk Drills

- Print columns
- Use field separator
- Filter by numeric value
- Use BEGIN and END
- Do arithmetic aggregation

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk -F: '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'
    ps aux | awk '{printf "%-10s %s\n", $1, $11}'

---

## 🧪 13) Binary and Encoding Inspection

- Show octal/char view
- Show hex dump

    od -bc file.txt
    hexdump -C file.txt

---

## 🏷️ 14) Renaming Files in Bulk

- Dry run rename
- Actual rename

    rename -n 's/foo/bar/' *.txt
    rename 's/foo/bar/' *.txt

---

## 🔁 15) Redirection and Pipelines

- Pipe output into another command
- Save output to file
- Append output
- Redirect stderr
- Redirect both
- Use here-doc

    ps aux | grep root
    ls -l > out.txt
    echo test >> out.txt
    ls /nope 2> err.txt
    ls /nope > all.txt 2>&1
    cat << EOF
    hello
    world
    EOF

---

## ✅ Completion Criteria

You are **done with this file** when:

- You can perform all tasks without references
- You can chain tools together instinctively
- You can inspect and transform text **under time pressure**

---
