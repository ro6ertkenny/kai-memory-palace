# 🪟 buffers-windows-tabs.md — Vim Situational Awareness

## 🎯 Purpose
Work confidently with more than one file.

This file trains awareness of:
- what is open
- where you are
- how to move without losing context

Editing multiple files should feel controlled, not chaotic.

---

## 🧠 Mental Rule
Buffers are the truth.  
Windows are views.  
Tabs are optional.

If you confuse these, you lose orientation.

---

## 📦 Buffers (files in memory)
A buffer is a file loaded into Vim, whether visible or not.

Common buffer commands:

    :ls

List all buffers.

    :bnext
    :bprev

Move between buffers.

    :buffer N

Jump directly to buffer number N.

    :bd

Delete the current buffer.

Rule:
Deleting a buffer does not exit Vim.

---

## 🪟 Windows (views into buffers)
Windows are splits showing buffers.

Create splits:

    :split

Horizontal split.

    :vsplit

Vertical split.

Move between windows:

    Ctrl+w h
    Ctrl+w j
    Ctrl+w k
    Ctrl+w l

Close current window:

    :q

Rule:
Splits are for comparison and context, not permanence.

---

## 🧭 Typical Split Workflow
Edit two related files side by side:

- YAML manifest on one side
- README or config reference on the other

Vertical splits are preferred for code and YAML.

---

## 📑 Tabs (use sparingly)
Tabs are collections of windows.

Create a tab:

    :tabnew

Move between tabs:

    gt
    gT

Close a tab:

    :tabclose

Rule:
If you don’t know why you need a tab, you don’t need one.

---

## 🧪 Daily Drill (5 minutes)
Open two files.

- create a vertical split
- move between windows without thinking
- switch buffers using :ls and :b
- close a buffer without closing Vim

No mouse. No arrows.

---

## 🧯 Common Mistakes
- opening too many tabs
- forgetting buffers exist
- closing Vim instead of a buffer
- getting lost and restarting unnecessarily

If lost:
List buffers. Reorient. Continue.

---

## ✅ Exit Criteria
You are done with this file when:
- you always know what files are open
- you move between them deliberately
- multi-file edits feel calm

You now control context.
