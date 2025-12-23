# 🧯 mistakes.md — Fast Recovery from Common Vim Errors

## 🎯 Purpose
Recover quickly when something goes wrong.

This file exists to:
- stop panic
- restore control
- get you back to work fast

Mistakes are normal. Slow recovery is not.

---

## 🧠 Mental Rule
Pause. Undo. Reorient.

Do not keep typing when things feel wrong.

---

## 🚪 Mode Confusion
Symptom:
- keys type letters
- commands don’t work

Fix:
- press Esc (once or twice)
- confirm you are in Normal mode

If unsure, always Esc first.

---

## ✂️ Accidental Deletes
Symptom:
- a line or block disappears

Fix:
- undo immediately

    u

Undo is safe and reversible.

---

## 🔁 Too Many Changes
Symptom:
- file feels messy
- edits went too far

Fix:
- undo step-by-step

    u

Redo if needed:

    Ctrl+r

Do not try to “fix the fix.”

---

## 🧱 Broken Indentation
Symptom:
- YAML or config looks misaligned

Fix:
- undo
- reselect the full block
- reapply indentation using > or <

Never fix structure in Insert mode.

---

## 🧵 Lost Your Place
Symptom:
- you don’t know where you are in the file

Fix:
- jump to top or bottom

    gg
    G

Then re-search for your target.

---

## 🧪 Stuck in Visual Mode
Symptom:
- unexpected selections
- commands behave oddly

Fix:
- exit Visual mode

    Esc

Reset before continuing.

---

## 🧠 Panic Typing
Symptom:
- typing random keys hoping it fixes things

Fix:
- stop
- Esc
- undo
- reassess

Speed comes from control, not reaction.

---

## 🧪 Daily Drill (2 minutes)
Intentionally make a mistake.

- delete a line
- undo it
- enter Visual mode
- exit cleanly
- reindent a block
- undo and redo

Train recovery, not perfection.

---

## ✅ Exit Criteria
You are done with this file when:
- mistakes no longer cause stress
- undo feels automatic
- recovery is faster than avoidance

You now fail safely.
