# 🔍 grep — Line Selection

*Select lines that match (or do not match) a pattern*

---

## 🎯 Purpose

grep filters **lines** based on patterns.

It does **not** edit text.  
It **selects or rejects** lines.

---

## 🧠 Mental Model

> grep answers: “Which lines do I keep?”

---

## 🧪 Basic Usage

    grep PATTERN file
    command | grep PATTERN

Examples:

    grep root /etc/passwd
    ps aux | grep nginx

---

## 🔧 High-Value Flags

    -i   ignore case
    -v   invert match (select non-matching lines)
    -r   recursive
    -n   show line numbers
    -E   extended regex
    -F   fixed string (no regex)
    -w   match whole word

Examples:

    grep -i error logfile
    grep -v '^#' config.conf
    grep -r ssh /etc
    grep -E 'error|fail|panic' logfile

---

## 🧠 Exit Codes (Important in Scripts)

- 0 = match found
- 1 = no match
- 2 = error

---

## 🧰 Common Patterns

Find processes:

    ps aux | grep nginx

Exclude grep itself:

    ps aux | grep nginx | grep -v grep

Filter logs:

    journalctl | grep -i error

---

## ⚠️ Operator Warnings

- grep works on **lines**, not fields.
- For column-aware work, use awk.

---

## 🏁 One-Sentence Summary

> grep keeps or removes **entire lines** based on patterns.

