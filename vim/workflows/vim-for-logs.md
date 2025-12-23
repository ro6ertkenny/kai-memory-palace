# 📜 vim-for-logs.md — Read-Only Efficiency

## 🎯 Purpose
Read large, noisy files **without editing them**.

This file trains habits for:
- scanning logs quickly
- finding signal in noise
- moving without losing your place

Logs are for reading, not modifying.

---

## 🧠 Mental Rule
Logs are evidence.

Do not edit.  
Do not “fix.”  
Observe, search, and move.

---

## 🔒 Open Logs Safely
Open files in read-only mode when possible:

    vim -R logfile.log

If already open, enforce read-only:

    :set readonly

Accidental edits are failure.

---

## 🔍 Search-Driven Reading
Logs are never read top to bottom.

Primary tools:
- /pattern
- ?pattern
- n
- N

Search for:
- timestamps
- error levels
- component names
- request IDs

Movement follows search, not scrolling.

---

## 🧭 Jumping by Structure
Use large movements to reorient:

- gg → top of file
- G → bottom of file
- Ctrl+d → half-page down
- Ctrl+u → half-page up

Avoid line-by-line navigation.

---

## 🧠 Pattern Strategy
Refine searches as you go.

Example flow:
- search for ERROR
- narrow to a component
- jump between occurrences
- backtrack with N when needed

Let patterns guide you.

---

## 🧪 Temporary Visual Focus
Use visual selection only to orient, not edit.

Example uses:
- marking a block to understand scope
- tracking start and end of an event

Exit visual mode immediately when done.

---

## 🧪 Daily Drill (5 minutes)
Open a real log file.

- jump to bottom
- search backward for an error
- move between matches
- reorient to top
- clear highlights

No edits. No typing.

---

## 🧯 Common Mistakes
- scrolling instead of searching
- losing place after a jump
- accidentally entering Insert mode
- trying to “clean up” logs

If you type, you failed the drill.

---

## ✅ Exit Criteria
You are done with this file when:
- logs feel navigable, not overwhelming
- search replaces scrolling
- you never modify log files

You now read logs with intent.
