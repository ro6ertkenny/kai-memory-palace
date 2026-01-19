# ✂️ sed — Stream Editor

*Edit text streams non-interactively*

---

## 🎯 Purpose

sed performs **transformations on a stream**:

- substitute text
- delete lines
- select lines
- rewrite output

It is:

- non-interactive
- line-oriented
- extremely fast

---

## 🧠 Mental Model

> sed answers: “How do I **rewrite** this stream?”

---

## 🧪 Most Common Use: Substitution

    sed 's/OLD/NEW/'

Examples:

    sed 's/root/admin/'
    sed 's/error/warning/g'

In pipelines:

    cat file | sed 's/foo/bar/g'

---

## 🔧 High-Value Flags

    -i   edit file in place (dangerous)
    -n   suppress automatic printing
    -E   extended regex

---

## 🧰 Deleting Lines

Delete matching lines:

    sed '/pattern/d'

Delete line 1:

    sed '1d'

Delete blank lines:

    sed '/^$/d'

---

## 🧰 Printing Specific Lines

Print only matches:

    sed -n '/pattern/p'

Print lines 5 to 10:

    sed -n '5,10p'

---

## ⚠️ Operator Warnings

- sed is not for parsing structured fields → use awk
- sed -i is destructive

---

## 🏁 One-Sentence Summary

> sed **rewrites streams** using simple editing rules.

