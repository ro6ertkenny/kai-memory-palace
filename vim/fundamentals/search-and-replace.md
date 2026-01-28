# 🔎 search-and-replace.md — Vim Precision Targeting

## 🎯 Purpose
Make finding and changing text exact.

Search is how you aim.  
Replace is how you execute.

This file trains precision over speed.

---

## 🧠 Mental Rule
Search first. Act second.

If you edit without a clear target, you are guessing.

---

## 🔍 Basic Search
- /pattern → search forward
- ?pattern → search backward
- n → next match
- N → previous match

You must press enter after typing what you want to search to invoke n & N functionality



Search narrows the problem space.  
Use it constantly.

---

## 🎯 Search Discipline
- search for unique tokens
- prefer full words over fragments
- avoid generic strings when possible

Good examples:

    /apiVersion
    /metadata:

Bad examples:

    /api
    /:

---

## 🔁 Line Substitute
Replace on the current line only:

    :s/old/new/

Replace all matches on the line:

    :s/old/new/g

---

## 🌍 File-wide Substitute
Replace the first match on every line:

    :%s/old/new/

Replace all matches in the file:

    :%s/old/new/g

---

## 🛑 Safe Replace (confirmation)
Use confirmation when risk exists:

    :%s/old/new/gc

Confirmation keys:
- y → replace
- n → skip
- a → replace all
- q → quit

This is the default for YAML and config files.

---

## 🧭 Targeted Ranges
Replace only between line numbers:

    :10,20s/old/new/g

Replace only inside a visual selection:
- select lines with V
- then run:

    :s/old/new/g

---

## 🔦 Search Highlight Control
Turn on Search Highlighting

    :set hlsearch

Turn off Search Highlighting

    :set nohlsearch

Clear search highlighting:

    :noh

Do not confuse highlighting with selection.

💡 Optional (nice-to-have later)

If you want Vim to highlight as you type:

    :set incsearch

---

## 🧪 Daily Drill (5 minutes)
Open a real file.

Repeat:
- search with /pattern
- move with n and N
- replace with :s
- confirm with gc
- clear highlights with :noh

Never replace without searching first.

---

## 🧯 Common Mistakes
- replacing without confirmation
- using global replace blindly
- searching for vague patterns
- forgetting cursor position

Undo and re-aim if unsure.

---

## ✅ Exit Criteria
You are done with this file when:
- search feels automatic
- replacements feel controlled
- large files feel safe

You now edit with intent.
