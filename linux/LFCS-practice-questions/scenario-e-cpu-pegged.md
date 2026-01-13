# 🧠 Scenario E — CPU Is Pegged

## 📍 Symptom

The system feels hot and slow.

Fans are loud.

Load or CPU usage is near 100%.

---

## 🎯 Goal

Determine:

- Which process is consuming CPU
- Whether this is expected or pathological
- Whether this is a workload problem or a runaway process
- What the minimum safe action is

---

## 🧭 Operator Rule

> **High CPU is not automatically a bug. First decide if it is doing useful work.**

---

## 🧪 Step 1 — Identify the Culprit

Run:

    ps aux --sort=-%cpu | head

Interpretation:

- The top entry is your primary suspect.
- Note:
  - user
  - PID
  - command
  - %CPU

---

## 🔎 Step 2 — Inspect the Process

Run:

    ps -o pid,user,stat,etime,%cpu,%mem,cmd -p PID

Ask:

- Who owns it?
- How long has it been running?
- Is this a known workload?
- Is it managed by a service?

If managed by systemd:

    systemctl status servicename --no-pager

---

## 🧠 Step 3 — Decide If This Is Expected

Decision table:

- Expected:
  - compiler
  - backup
  - scan
  - encode
  - indexing
  → Leave it alone.

- Unexpected:
  - tight loop
  - runaway process
  - bug
  - fork bomb
  → Investigate further.

---

## 🧪 Step 4 — If It Is Unexpected

Check:

- Logs (if a service):

    sudo journalctl -u servicename -n 80 --no-pager

- Parent process:

    ps -o pid,ppid,cmd -p PID

Ask:

- Why is it running?
- What started it?
- Should it be running now?

---

## 🗡️ Step 5 — Act Conservatively

If action is needed:

1) Try graceful stop (service or process)
2) Verify impact
3) Escalate only if necessary

Never kill blindly.

---

## ✅ Step 6 — Verify

After action:

    uptime
    ps aux --sort=-%cpu | head

Confirm:

- CPU pressure is reduced
- The correct process was affected
- No new failures appeared

---

## ⚠️ Forbidden Actions

- Do not kill something just because it is using CPU.
- Do not confuse “busy” with “broken”.
- Do not take action without understanding ownership.

---

## 🏁 Success Criteria

You can explain:

- Which process caused the load
- Whether it was expected or not
- Why your action was safe
- That the system is stable again

---

## 🧠 Operator Loop (Reinforced)

Symptom → Identify → Inspect → Decide → Act → Verify
EOF
