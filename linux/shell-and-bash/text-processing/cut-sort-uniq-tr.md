# 🧱 cut, sort, uniq, tr — The Small Powerful Filters

*The classic Unix text-shaping tools*

---

## ✂️ cut — Column Extraction

Extract by field:

    cut -d: -f1 /etc/passwd

Extract by character position:

    cut -c1-10 file

---

## 🔃 sort — Ordering

Sort lines:

    sort file

Numeric sort:

    sort -n

Reverse:

    sort -r

By column:

    sort -k 2

---

## 🧬 uniq — Deduplication

Remove duplicates (requires sorted input):

    sort file | uniq

Count duplicates:

    sort file | uniq -c

---

## 🔤 tr — Character Translation

Lower to upper:

    tr 'a-z' 'A-Z'

Delete characters:

    tr -d ':'

Squeeze repeats:

    tr -s ' '

---

## 🧠 Canonical Pipelines

Count unique IPs:

    awk '{print $1}' access.log | sort | uniq -c | sort -n

Extract usernames:

    cut -d: -f1 /etc/passwd

---

## ⚠️ Operator Warnings

- uniq only works on **adjacent** duplicates → sort first
- cut is dumb → awk is smarter

---

## 🏁 One-Sentence Summary

> These are **simple, fast building blocks** for shaping text in pipelines.

