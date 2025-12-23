# 🧩 vim-for-configs.md — Safe Editing of Structured Files

## 🎯 Purpose
Edit fragile, structured files **without breaking them**.

This file trains habits for working with:
- YAML
- system configs
- Kubernetes manifests

The goal is correctness first, speed second.

---

## 🧠 Mental Rule
Structure is sacred.

If you break structure, the system breaks — often silently.

---

## 📐 Indentation Discipline
Indentation is meaning.

Rules:
- never fix indentation in Insert mode
- always adjust indentation in Normal or Visual mode

Core commands:

    >>

Indent current line.

    <<

Outdent current line.

Visual selection:

    >

Indent selection.

    <

Outdent selection.

---

## 📦 Editing YAML Safely
Preferred workflow:
- navigate precisely
- select entire logical blocks
- shift indentation as a unit

Common patterns:
- lists
- nested maps
- multi-line values

Never “eyeball” alignment.

---

## 🧱 Block Operations (critical skill)
Use Visual Line or Visual Block mode for structure.

Visual line mode:

    V

Visual block mode:

    Ctrl+v

Common uses:
- indenting entire sections
- commenting multiple lines
- aligning keys or values

---

## 📝 Commenting Blocks
Most config formats support line comments.

Typical workflow:
- select lines
- prepend comment character using block mode
- undo cleanly if needed

Do not comment line-by-line manually.

---

## 🧪 Validate as You Go
After edits:
- scan indentation visually
- re-run search for key tokens
- undo immediately if structure looks wrong

Trust undo more than memory.

---

## 🧪 Daily Drill (5 minutes)
Open a real YAML file.

- move by blocks, not lines
- indent and outdent sections
- comment and uncomment blocks
- undo and redo deliberately

No typing. Structure only.

---

## 🧯 Common Mistakes
- fixing indentation in Insert mode
- editing one line of a block
- mixing tabs and spaces
- trusting alignment without checking

If unsure:
Undo. Re-select. Re-apply.

---

## ✅ Exit Criteria
You are done with this file when:
- YAML edits feel calm
- indentation changes are deliberate
- structure errors drop to zero

You now edit configs safely.
