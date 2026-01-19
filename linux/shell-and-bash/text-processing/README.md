# 🧰 Text Processing — Linux Shell & Bash

*The Unix filter toolchain: transforming data in pipelines*

---

## 🎯 Purpose

This directory covers the **core Unix text processing tools** used in pipelines:

- grep
- sed
- awk
- cut
- sort
- uniq
- tr

These tools are:

- Not Bash
- Not scripting languages
- **Filters** that:
  - read from stdin
  - transform text
  - write to stdout

They are the **data transformation engines** of Unix.

---

## 🧠 Mental Model

> Bash controls **flow**.  
> These tools transform **data**.

Typical pattern:

    command | filter | filter | filter > output

Example:

    ps aux | grep root | awk '{print $2}' | sort -n

Each tool does **one job well**.

---

## 🧱 The Canonical Filters

| Tool  | Role |
|-------|------|
| grep  | Select lines |
| sed   | Edit stream |
| awk   | Structured text processing |
| cut   | Column extraction |
| sort  | Ordering |
| uniq  | Deduplication |
| tr    | Character translation |

---

## 🧭 How LFCS Uses These

You will be expected to:

- Search logs
- Extract fields
- Reformat output
- Deduplicate data
- Count things
- Chain tools together
- Do it **without writing scripts**

---

## 📚 Files In This Directory

- grep.md — line selection and pattern matching
- sed.md — stream editing
- awk.md — field-oriented processing
- cut-sort-uniq-tr.md — classic small filters

---

## 🧠 Operator Rule

> If you are writing a script to do what a pipeline can do, you are doing it wrong.

---

## 🏁 Outcome

You should be able to:

- Read any pipeline
- Construct pipelines quickly
- Debug broken pipelines
- Transform text under pressure

This is **core Unix literacy**.

