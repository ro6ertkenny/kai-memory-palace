# ✍️ editing.md — Vim Editing Fundamentals

## 🎯 Purpose
Make **editing mechanical**.

You should not think about *how* to change text —  
only *what* needs to change.

This file trains **editing reflexes**.

---

## 🧠 Mental Rule
**Move → Edit → Stop**

- move with intent
- apply the edit once
- return to Normal mode immediately

Lingering in Insert mode is failure.

---

## ✋ Modes (only what matters)

- **Normal** → default state (operate)
- **Insert** → type text
- **Visual** → select text
- **Command-line** → `:` commands

Rule:
> If you are not actively typing characters, you should be in **Normal mode**.

---

## ⌨️ Entering Insert Mode (controlled)
Use the **smallest entry point possible**.

- `i` → insert before cursor
- `a` → insert after cursor
- `o` → new line below
- `O` → new line above

Exit Insert mode immediately with `Esc`.

---

## ✂️ Delete (destructive edits)
Deletes place text into Vim’s buffer.

- `x` → delete character
- `dw` → delete word
- `dd` → delete line
- `D` → delete to end of line

Delete is intentional.  
Never delete blindly.

---

## 🔄 Change (preferred over delete)
Change = delete + insert (faster, safer).

- `cw` → change word
- `cc` → change line
- `C` → change to end of line

If you plan to type after deleting, use **change**, not delete.

---

## 📋 Yank (copy)
- `yy` → yank line
- `yw` → yank word
- `y$` → yank to end of line
- `y` in Visual mode → yank selection

Yank does **not** modify the file.

---

## 📌 Paste (put)
- `p` → paste after cursor / below line
- `P` → paste before cursor / above line

Use `p` / `P` deliberately to control placement.

---

## 🔎 Visual Mode (precision edits)

Enter:
- `v` → character selection
- `V` → line selection
- `Ctrl + v` → block selection

Common uses:
- yank blocks
- delete blocks
- shift indentation
- column edits

Exit with `Esc`.

---

## ↔️ Indentation (YAML-critical)

- `>>` → indent line
- `<<` → outdent line
- `>` → indent Visual selection
- `<` → outdent Visual selection

Never fix YAML indentation in Insert mode.

---

## ↩️ Undo / Redo
- `u` → undo
- `Ctrl + r` → redo

Undo is infinite.  
Use it aggressively.

---

## 🧪 Daily Drill (5 minutes)
Open a real file.

Repeat:
- `cw` / `cc`
- `dd` / `yy`
- `p` / `P`
- `V` → `>` / `<`
- `u` / `Ctrl + r`

Always return to Normal mode.

---

## 🧯 Common Mistakes
- staying in Insert mode too long
- deleting when change is better
- fixing indentation manually
- panicking instead of undoing

If it feels messy, stop and reset.

---

## ✅ Exit Criteria
You are done with this file when:
- edits feel mechanical
- Insert mode is brief
- undo feels safe and instinctive

Editing is now muscle memory.
