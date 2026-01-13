# 🧭 Processes & Resource Management — Index

Mental mode: **Observing and shaping system activity**

Use this wing when you need to understand:
- what is running
- who owns it
- how it is behaving
- what resources it is consuming
- how to control it safely

---

## ✅ Start Here

- `README.md`  
  Purpose, mental model, scope, operational guardrails

---

## 🔍 Inspection and Visibility

- `process-inspection.md`  
  `ps`, process states, sorting by CPU/memory, extracting PIDs, verification

- `resource-monitoring.md`  
  load averages, memory pressure, disk space, inodes, directory size triage

---

## 🛑 Control and Termination

- `process-control.md`  
  signals, `kill`/`pkill`/`killall`, job control, escalation and verification

---

## 🧩 Services and Daemons

- `services-and-daemons.md`  
  `systemd` lifecycle control, status verification, logs with `journalctl`, failure patterns

---

## 🧯 Troubleshooting Patterns

- `process-troubleshooting.md`  
  zombies, D-state, respawning processes, kill escalation, when reboot is appropriate

---

## 📌 Operator Workflow

Use this sequence when the system “feels wrong”:

1. Identify symptoms (slow, high load, no disk, memory pressure, service down)
2. Inspect before acting (`ps`, `uptime`, `free`, `df`)
3. Confirm ownership and runtime (user, command, elapsed time, parent/service)
4. Apply the minimum effective action (graceful signals first)
5. Verify the impact (process gone, service healthy, load stabilizing)
6. Capture the lesson in `linux/troubleshooting/` if it was a repeatable failure

EOF

