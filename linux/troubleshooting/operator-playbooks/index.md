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
- `core/scenario-00-triage-playbook.md`
- `core/scenario-01-system-feels-slow.md`
- `core/scenario-02-disk-is-full.md`
- `core/scenario-03-service-is-down.md`
- `core/scenario-04-process-wont-die.md`
- `core/scenario-05-cpu-pegged.md`
- `core/scenario-06-memory-keeps-growing.md`
- `core/scenario-07-inodes-exhausted.md`
- `core/scenario-08-permissions-denied.md`
- `core/scenario-09-dns-intermittent.md`
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

