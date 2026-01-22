# 🧱 Building Block 7 — Service Configuration

**Path:** `linux/LFCS-training/training-progression/building-block-7-service-configuration.md`  
**Purpose:** Build the discipline to **edit service configuration safely**, **validate before restart**, and **rollback cleanly** when changes break behavior.

---

## 🎯 What This Block Builds

You are building:

- A safe workflow for:
  - locating the correct config file
  - understanding effective vs commented settings
  - making minimal, reversible changes
- The habit of:
  - validating syntax (when possible)
  - restarting only after inspection
  - verifying behavior after change

This block turns “edit and pray” into a **controlled change procedure**.

---

## 🧠 Mental Models You Must Own

- Configuration is:
  - just text
  - but it **controls running behavior**
- A service failure after a change is:
  - evidence
  - not a surprise
- Most config breakage comes from:
  - typos
  - wrong file
  - wrong directive scope
- Restarting a service is:
  - a test
  - not a fix

Invariants:

- “I always know which file is authoritative.”
- “I can explain what I changed and why.”
- “I can revert to the last known-good state quickly.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`

Rule:

> You should be able to locate, edit, validate, and test configs **without guessing**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md` (when caused by config errors)

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`

Rule:

> You should be able to use this playbook to recover from **your own broken config change**.

---

## 🧭 Required Capabilities

You must be able to:

### Locate the Effective Configuration

- Determine:
  - which file(s) are actually read
  - include / drop-in behavior
  - overrides vs defaults

### Edit Safely

- Before editing:
  - inspect the current file
  - understand which directives are active
- During editing:
  - change the minimum necessary lines
  - keep formatting readable
- After editing:
  - save without truncation or corruption

### Validate Before Restart

- When supported by the service:
  - run a config test command
- Otherwise:
  - re-read the file carefully
  - confirm no obvious syntax or path errors

### Restart and Verify

- Restart the service
- Immediately:
  - check status
  - check logs
- Confirm:
  - service is running
  - behavior matches intent

### Rollback Cleanly

- Restore:
  - previous file
  - or previous settings
- Restart again
- Verify return to known-good state

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a service, you can:
  - find its real config file
  - identify which settings are in effect
- You can:
  - make a change
  - validate it
  - restart safely
  - confirm the result
- You can:
  - intentionally break a config
  - and recover the service using logs and rollback

Concrete tests:

- You can:
  - explain a startup failure caused by a bad directive
  - fix it without touching unrelated settings
- You never:
  - edit multiple things “just in case”
  - restart without checking logs after a failure

---

## 🔁 Regression Rule

If later you:

- break a service and don’t know what you changed
- edit the wrong file
- lose track of the last known-good state

You must:

> Return here and re-run `service-configuration.md` until safe change discipline is automatic.

---

## 🧠 Operator Rule (Carry Forward)

> **Every config change must be reversible and verified.**

---

## 🧱 This Block Enables

- Safe service tuning
- Confident incident response after config mistakes
- All production-like change workflows
- Reliable use of service recovery playbooks

Without this block, **every config change is a gamble**.

---
