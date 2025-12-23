# 🧭 movement.md — Vim Navigation Fundamentals

## 🎯 Purpose
Make **navigation automatic**.

Movement is the foundation of Vim.  
If you cannot reach text without thinking, nothing else matters.

This file trains **reflex**, not knowledge.

---

## 🧠 Mental Rule
**Move first. Edit second.**

If you edit before you position the cursor precisely, you are guessing.

---

## 🧱 Core Movement Keys (non-negotiable)

Character-wise movement:
- `h` → left
- `j` → down
- `k` → up
- `l` → right

Arrow keys are forbidden.

---

## 🧩 Word Movement
- `w` → next word start
- `b` → previous word start
- `e` → end of word

**Drill rule:**  
Use words, not characters, whenever possible.

---

## 🧵 Line Movement
- `0` → start of line
- `^` → first non-whitespace character
- `$` → end of line

YAML work depends on **line precision**.

---

## 🔍 Character Find (surgical movement)
- `f<char>` → find forward on line
- `t<char>` → move before character
- `;` → repeat last find
- `,` → reverse last find

Examples:
- `f:`
- `t,`

Use this instead of spamming `l`.

---

## 📄 Screen Movement
- `Ctrl + f` → page down
- `Ctrl + b` → page up
- `Ctrl + d` → half-page down
- `Ctrl + u` → half-page up

Half-page movement is preferred.

---

## 🧭 File Extremes
- `gg` → top of file
- `G` → bottom of file
- `:N` → go to line N

Example:
- `:42`

---

## 🧱 Paragraph / Block Movement
- `}` → next paragraph
- `{` → previous paragraph

Useful for:
- config blocks
- Markdown sections
- YAML objects

---

## 🧪 Daily Drill (5 minutes)
Open **any file**.

Repeat continuously:
- `gg`
- `G`
- `w b e`
- `0 ^ $`
- `f<char> t<char> ; ,`
- `Ctrl + d` / `Ctrl + u`

No editing. Only movement.

---

## 🧯 Common Mistakes
- Using arrow keys
- Overusing `hjkl` instead of word motion
- Editing before positioning
- Scrolling instead of navigating

If you catch any of these, slow down.

---

## ✅ Exit Criteria
You are done with this file when:
- movement no longer requires thought
- the cursor lands where you expect
- arrow keys feel wrong

Movement is now muscle memory.
