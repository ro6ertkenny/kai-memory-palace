# 🧯 Scenario 3 — A Service Is Down (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if disk/log pressure is causal)

---

## 📌 Incident Brief (Symptom-First)

A user reports:

> “The web app / API is not responding.”

You do **not** yet know whether:

- the service is stopped
- the service is failing to start
- the service is in a restart loop
- the service is running but broken
- the problem is not actually a service problem (network, dependency, or resource issue)

Your job is to **classify the failure**, choose the correct route, and restore service **with proof**.

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- State whether the service is:
  - stopped
  - failed
  - restarting
  - running but unhealthy
- Explain **why** using logs and evidence
- Apply the **minimal safe fix**
- Prove:
  - the unit is stable
  - the process is correct
  - the external symptom is resolved

---

## 🧠 Operator Rule

> **Ask the supervisor first. Then verify reality.**  
> systemd tells you intent. The process table tells you truth.

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Service lifecycle failure** (won’t start, failed, start-limit hit)
2) **Crash loop** (restarting repeatedly)
3) **Service running but dependency broken** (port, file, permission, network)
4) **Process exists but is unhealthy / wedged**
5) **Resource-induced failure** (disk full, memory pressure, OOM)
6) **Not a service problem at all** (routing, firewall, DNS, etc.)

---

## 🧪 Required Evidence (Supervisor View)

Always start with the supervisor:

  systemctl status servicename --no-pager
  systemctl is-active servicename
  systemctl --failed

Interpretation anchors:

- `status`
  - shows active/inactive/failed
  - shows recent log lines
  - often shows Main PID
- `is-active`
  - scriptable state check
- `--failed`
  - reveals related broken units

Decision gate:

- If **inactive/failed** → go to logs.
- If **active** → verify the actual process and behavior.

---

## 🔎 Required Evidence (Logs)

Read the unit’s logs:

  journalctl -u servicename -b --no-pager | tail -n 200

Look for:

- config parse errors
- missing files or permissions
- missing ports or sockets
- start-limit hit
- repeated crash signatures
- resource errors (“no space left”, OOM, etc.)

---

## 🧩 Verify Reality (Process View)

Get the main PID:

  systemctl show -p MainPID --value servicename

Interpretation:

- PID = 0 → no main process (service is not actually running)
- PID > 0 → verify:

  ps -p PID

If systemd claims active but the process is gone or wrong → **unit is lying or misconfigured**.

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Service failed to start
Signals:
- `systemctl status` shows failed
- logs show config or dependency error
Route:
- `service-recovery-playbook.md`
Goal:
- fix config or dependency
- restart cleanly
Proof:
- unit is active
- logs are clean
- external symptom gone

### Fork B — Crash loop / restart storm
Signals:
- repeated restarts in journal
- start-limit warnings
Route:
- `service-recovery-playbook.md`
- possibly `process-control-playbook.md`
Goal:
- stop the loop
- fix root cause
Proof:
- restarts stop
- service remains stable over time

### Fork C — Service active but broken
Signals:
- systemd says active
- external symptom persists
- process exists but app is unhealthy
Route:
- `service-recovery-playbook.md`
- or `network-diagnosis-playbook.md` / `security-triage-playbook.md`
Goal:
- identify broken dependency or policy block
Proof:
- functional checks succeed
- logs stop reporting errors

### Fork D — Resource-induced failure
Signals:
- logs show disk full, OOM, or memory pressure
Route:
- `storage-recovery-playbook.md` or `process-control-playbook.md`
Then:
- return to `service-recovery-playbook.md`
Proof:
- resources stabilized
- service stays up

### Fork E — Not actually a service problem
Signals:
- service healthy locally
- problem is reachability, firewall, DNS, or routing
Route:
- `network-diagnosis-playbook.md` or `security-triage-playbook.md`
Proof:
- client can reach service again

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not restart blindly.
- Do not kill random PIDs.
- Do not “try fixes” before reading logs.
- Do not reboot before classification.

A blind restart **destroys evidence**.

---

## 🧯 Recovery Principles

- Fix the **cause**, not the symptom.
- Make the **smallest change** that restores health.
- If a service is crashing:
  - stop it
  - fix root cause
  - then start it cleanly

---

## ✅ Verification (Required Proof)

  systemctl is-active servicename
  systemctl --failed

  systemctl status servicename --no-pager
  journalctl -u servicename -b --no-pager | tail -n 50

If the service exposes a port:

  ss -lntp | rg servicename || true

From a client or locally:

  curl / health-check / functional probe (as appropriate)

Define “healthy” as:

- unit is active
- no restart loop
- logs are clean or stable
- external symptom is gone

---

## 🧾 Post-Incident Debrief

Answer:

- What did systemd think?
- What was actually running?
- What did the logs prove?
- Which failure bucket was this?
- What was the minimal safe fix?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Restarting before reading logs
- Trusting `systemctl` without checking the process
- Treating all failures as “service bugs”
- Ignoring resource exhaustion signals
- Declaring success because “it started once”

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you hesitated on systemd state vs reality:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If you misread logs or missed the root cause:
- Drill:
  - `linux/LFCS-training/execution-drills/files-and-text.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-5-logs-and-observation.md`

### If this was actually a resource or process issue:
- Drill:
  - `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- tighten classification speed
- reinforce evidence-first behavior
- prevent recurrence

---

