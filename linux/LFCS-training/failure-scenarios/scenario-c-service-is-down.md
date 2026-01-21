# 🧠 Scenario C — A Service Is Down

## 📍 Symptom

A web app isn’t responding.

You do not yet know if this is:
- the service is stopped
- the service is crashing
- the service is restarting
- the service is running but broken
- or not a service problem at all

---

## 🎯 Goal

Determine:

- Is the service running?
- If not, why did it stop?
- If it is running, is it healthy?
- Is it in a restart loop?
- Is the problem a service issue or a process issue?

---

## 🧭 Operator Rule

> **Ask the supervisor, then verify reality.**
>
> systemctl tells you what systemd thinks.
> ps proves what is actually running.

---

## 🧪 Step 1 — Ask systemd (Supervisor View)

Run:

    systemctl status servicename --no-pager
    systemctl is-active servicename
    systemctl --failed

Interpretation:

- status shows:
  - active/inactive/failed
  - recent log lines
  - Main PID (often)
- is-active gives a script-friendly state
- --failed shows other broken units that may be related

Decision:

- If inactive/failed → go to Step 2 (logs).
- If active → go to Step 3 (verify process and behavior).

---

## 🔎 Step 2 — Read Logs (Why It Failed)

Run:

    sudo journalctl -u servicename -n 80 --no-pager

If it is flapping (restarting), you will often see repeated patterns:
- exited with code
- failed with result
- start request repeated
- start-limit hit

Decision:

- If config error → fix config, then restart.
- If dependency missing (port, file, permissions) → fix dependency.
- If resource pressure (disk full, memory) → go to the appropriate incident playbook.

---

## ✅ Step 3 — Verify The Actual Process (Reality View)

Get the PID:

    systemctl show -p MainPID --value servicename

If PID is 0, the service has no running main process.

If PID is non-zero, verify:

    ps -p PID

Interpretation:

- If systemctl says active but PID is gone → service is lying or misconfigured.
- If PID exists → inspect whether it is the expected command.

---

## 🔁 Step 4 — Is It Being Restarted?

Check restart policy:

    systemctl show -p Restart,RestartSec,StartLimitIntervalUSec,StartLimitBurst servicename

Interpretation:

- Restart=always or on-failure means it may respawn automatically.
- StartLimit* means systemd may stop trying after repeated failures.

If the service is constantly restarting:
- do not keep restarting blindly
- logs first, then fix root cause

---

## 🧠 Step 5 — Decide: Service Problem or Process Problem?

Use this decision table:

- If systemd reports failed/inactive:
  - it is a service lifecycle failure
  - logs explain why

- If systemd reports active but behavior is broken:
  - it may be an app-level fault
  - or a dependency fault (port not open, wrong config, permissions)

- If the process is present but unresponsive:
  - inspect the process state
  - inspect logs
  - check resource pressure

---

## ⚠️ Forbidden Actions

- Do not restart blindly.
- Do not kill random PIDs.
- Do not “fix” without logs.

A restart without diagnosis destroys evidence.

---

## ✅ Success Criteria

You can explain:

- whether the service is running
- whether it is healthy
- whether it is restarting
- what the logs say about cause
- the minimum safe next action
- how you will verify the fix

---

## 🏁 Operator Loop (Reinforced)

Symptom → Supervisor view → Logs → Reality view → Decide → Act → Verify
EOF

