# 🧭 Operator Playbooks — Index

## 📌 What This Is
This index is the **authoritative navigation map** for operator playbooks.

Playbooks are organized as:

- **Core** → daily drills (high-frequency incidents)
- **Advanced** → reference scenarios (rarer / specialized)

---

## ✅ Start Here
- `core/triage-playbook.md` — universal triage workflow and command set

---

## ✅ Core Playbooks
Daily drills. The default set you repeat until automatic.

Scenarios:
- `core/scenario-0-triage-playbook.md`
- `core/scenario-1-system-feels-slow.md`
- `core/scenario-2-disk-is-full.md`
- `core/scenario-3-service-is-down.md`
- `core/scenario-4-process-wont-die.md`
- `core/scenario-5-cpu-pegged.md`
- `core/scenario-6-memory-keeps-growing.md`
- `core/scenario-7-inodes-exhausted.md`
- `core/scenario-8-permissions-denied.md`
- `core/scenario-9-dns-intermittent.md`
- `core/scenario-10-service-restart-loop.md`
- `core/scenario-11-deleted-but-open-files.md`
- `core/scenario-12-io-wait.md`
- `core/scenario-13-time-wrong-tls-breaks.md`

---

## 🧠 Advanced Playbooks
Reference patterns. Add here only when the scenario teaches something unique.

- `advanced/README.md`

---

## 🧱 Rules That Prevent Bloat
A scenario is allowed only if it teaches a **unique failure pattern** and trains a
decision no other scenario trains.

If a new scenario overlaps:
- merge it into an existing scenario
- or retire one

Core stays small.
Advanced can grow, but must remain organized.

EOF

