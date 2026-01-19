# 🧠 awk — Field-Oriented Text Processing

*Structured text processing and reporting*

---

## 🎯 Purpose

awk works on:

- records (lines)
- fields (columns)

It is a **mini programming language** for text.

---

## 🧠 Mental Model

> awk answers: “How do I **compute and format fields**?”

---

## 🧪 Basic Structure

    awk 'PATTERN { ACTION }'

Default fields:

    $1 $2 $3 ... $NF

---

## 🧰 Common Examples

Print first column:

    awk '{print $1}'

Print 1st and 3rd:

    awk '{print $1, $3}'

Filter by value:

    awk '$3 > 100 {print $1, $3}'

---

## 🧰 Field Separator

Default: whitespace

Custom separator:

    awk -F: '{print $1}' /etc/passwd

---

## 🧰 Built-in Variables

    NF   number of fields
    NR   record number
    $0   whole line

Example:

    awk '{print NR, NF, $0}'

---

## 🧰 Summation Example

    awk '{sum += $1} END {print sum}'

---

## ⚠️ Operator Warnings

- awk replaces:
  - cut
  - many sed uses
  - many ad-hoc scripts
- But is more complex → use when structure matters

---

## 🏁 One-Sentence Summary

> awk is **programmable, column-aware text processing**.

