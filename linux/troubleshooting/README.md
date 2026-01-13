# 🧰 Troubleshooting — README

## 🎯 Purpose
Capture **Linux-wide troubleshooting discipline** that applies across all domains.

This directory is for:
- failure patterns that repeat across subsystems
- operational mistakes worth preventing
- fast recovery workflows that reduce panic

This directory is **not** where deep theory lives.

---

## 🧠 Mental Model
Troubleshooting is not guessing.

It is a controlled loop:

Inspect → Hypothesize → Act → Verify → Document

If you skip inspection, you are debugging your imagination.

---

## 📌 Scope
Included:
- cross-domain mistakes (permissions, ownership, disk-full, logs, DNS vs connectivity)
- short high-signal playbooks
- “rules that stop repeat failures”

Excluded:
- domain-specific troubleshooting that belongs elsewhere

Domain-specific playbooks live in their domain wings (example):
- Networking playbooks → `linux/networking/troubleshooting/`

---

## ✅ How To Use
When something breaks:

1. Start in the relevant domain wing first (networking, storage, processes, etc.).
2. If the failure is “pattern-shaped” (repeat mistake), check `common-mistakes.md`.
3. If you learn something durable, add it here as a new mistake.

---

## 📚 Key Files
- `index.md`
  The navigation map for this directory.

- `common-mistakes.md`
  High-signal mistakes worth preventing (with symptom/cause/fix/rule).

---

## ✅ Exit Criteria
This directory is working when:
- you stop repeating the same failures
- recovery becomes procedural
- “what to check first” feels automatic
EOF

