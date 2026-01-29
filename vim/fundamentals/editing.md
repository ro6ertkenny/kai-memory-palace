# ✍️ editing.md — Vim Editing Fundamentals

## 🎯 Purpose

Make **editing mechanical**

You should not think about *how* to change text —  
only *what* needs to change

This file trains **editing reflexes**

---

## 🧠 Mental Rule

**Move → Edit → Stop**

- move with intent
- apply the edit once
- return to Normal mode immediately

Lingering in Insert mode is failure

---

## ✋ Modes (only what matters)

- **Normal** → default state (operate)
- **Insert** → type text
- **Visual** → select text
- **Command-line** → `:` commands

Rule:
> If you are not actively typing characters, you should be in **Normal mode**

---

## ⌨️ Entering Insert Mode (controlled)

Use the **smallest entry point possible**

- `i` → insert before cursor
- `a` → insert after cursor
- `o` → new line below
- `O` → new line above

Exit Insert mode immediately with `Esc`

#### 🧠 Is Esc the only way to leave Insert mode?

No — but it’s the main way

You can leave Insert mode with:

Esc ✅ (standard, works everywhere)

Ctrl + [ ✅ (exact same as Esc, very useful if Esc is far away)

#### On the LFCS exam, use Esc. It’s universal and reliable

---

## ✂️ Delete (destructive edits)

Deletes place text into Vim’s buffer

- `x` → delete character
- `dw` → delete word
- `dd` → delete line
- `D` → delete to end of line

Delete is intentional  
Never delete blindly

---

## 🔄 Change (preferred over delete)

Change = delete + insert (faster, safer)

- `cw` → change word
- `cc` → change line
- `C` → change to end of line

✅ The correct Vim way (change)

####    cw newname<Esc>

This:

deletes the word

puts you directly into Insert mode

in one action

#### 🎯 When to use change instead of delete

Anytime your intent is “replace this with something else”, use c not d

Examples:

Replace a word → cw

Replace a line → cc

Replace to end of line → c$

Replace inside quotes → ci"

#### 🔒 Why this matters

Fewer keystrokes

Fewer mistakes

Faster

Keeps your brain in “editing” mode instead of “surgery mode”

#### 🧠 One-sentence memory hook

If you’re going to type something new, use c, not d
If you plan to type after deleting, use **change**, not delete

---

## 📋 Yank (copy) y = yank operator → it needs a motion

- `yy` → yank line
- `yw` → yank word
- `y$` → yank to end of line
-  y}  → yank paragraph
- `y` in Visual mode → yank selection

Yank does **not** modify the file

---

🗑️ “Can I delete what I yanked from the buffer?”

You can’t “clear” the yank buffer directly, but you can:

Option A — overwrite it - just yank or delete something else:

yy or dd

Now the old yank is gone

Option B — use the black hole register (advanced, but useful) ... delete without overwriting what you yanked:

####  "_dd

This deletes the line but does not change your yank buffer

" means: “I’m about to specify a register” — the leading " is required

“Delete this line into the black hole register (throw it away), and don’t touch my yank buffer”

  _ = black hole register (discard)

 dd = delete line

--- 

## 📌 Paste (put)
- `p` → paste after cursor / below line
- `P` → paste before cursor / above line

Use `p` / `P` deliberately to control placement

### 🧠 Explicitly pasting from the yank register

You can be explicit:

####  "0p

"0 = yank register (last yank, not delete)

p = paste

This is useful when:

You yanked something

Then you deleted something else

And you want the original yank back

### 🗂️ See what’s in your registers

####  :reg

🧠 One-sentence memory hook

####  " chooses the register, "_ throws away, "0 is your safe yank

---

## 🔎 Visual Mode (precision edits)

Enter:
- `v` → character selection
- `V` → line selection
- `Ctrl + v` → block selection

So if you’re stuck in line selection v will switch it to character selection

Common uses:
- yank blocks
- delete blocks
- shift indentation
- column edits

Exit with `Esc`

---

## ↔️ Indentation (YAML-critical)

- `>>` → indent line
- `<<` → outdent line
- `>` → indent Visual selection
- `<` → outdent Visual selection

Never fix YAML indentation in Insert mode

---

## ↩️ Undo / Redo

- `u` → undo
- `Ctrl + r` → redo

Undo is infinite  
Use it aggressively

---

## 🧪 Daily Drill (5 minutes)

Open a real file

Repeat:
- `cw` / `cc`
- `dd` / `yy`
- `p` / `P`
- `V` → `>` / `<`
- `u` / `Ctrl + r`

Always return to Normal mode

---

## 🧠 LFCS-grade memory hook

Ctrl+g = “Where am I and what file is this?”

---

## 🧯 Common Mistakes

- staying in Insert mode too long
- deleting when change is better
- fixing indentation manually
- panicking instead of undoing

If it feels messy, stop and reset

---

## ✅ Exit Criteria

You are done with this file when:
- edits feel mechanical
- Insert mode is brief
- undo feels safe and instinctive

Editing is now muscle memory
