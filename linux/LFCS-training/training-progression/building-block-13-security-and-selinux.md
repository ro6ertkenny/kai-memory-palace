# 🧱 Building Block 13 — Security and SELinux

**Path:** `linux/LFCS-training/training-progression/building-block-13-security-and-selinux.md`  
**Purpose:** Build the ability to **distinguish DAC vs MAC**, diagnose **SELinux denials**, and restore **intended access** without weakening system security.

---

## 🎯 What This Block Builds

You are building:

- A clear separation between:
  - **DAC** (traditional permissions: users, groups, modes)
  - **MAC** (SELinux policy and contexts)
- The ability to:
  - recognize when SELinux is the blocker
  - prove it with evidence
  - fix the **context**, not the security posture

This block turns “permission denied but perms look fine” into a **mechanical, evidence-based fix**.

---

## 🧠 Mental Models You Must Own

- Access is evaluated in layers:
  1) DAC (ownership + mode bits)
  2) MAC (SELinux)
- If DAC allows but access still fails:
  - SELinux is a prime suspect
- SELinux is:
  - not optional noise
  - not a thing to disable
  - a policy engine enforcing **intended behavior**
- Most SELinux breakage comes from:
  - files moved to the wrong path
  - restores from backup
  - wrong contexts on data or sockets

Invariants:

- “I always identify whether the block is DAC or MAC first.”
- “I never disable SELinux to ‘make it work’.”
- “I prefer restoring correct contexts over inventing new ones.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

Rule:

> You should be able to classify access failures as DAC or MAC **without guessing**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- “Service fails to start after data directory move”
- “Works in permissive, fails in enforcing”
- “Permission denied but modes look correct”

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (when SELinux blocks startup)

Rule:

> You should always follow the security triage playbook before touching policies or modes.

---

## 🧭 Required Capabilities

You must be able to:

### Classify the Block

- Determine:
  - SELinux mode (enforcing/permissive/disabled)
- Check:
  - for recent AVC denials
- Decide:
  - whether the failure is DAC or MAC

### Inspect and Fix Contexts

- Inspect:
  - file and directory contexts
- Restore:
  - default contexts for a path
- Understand:
  - when a file is in the wrong place for its role

### Validate Safely

- Temporarily test:
  - permissive mode **only for diagnosis**
- Re-enable:
  - enforcing mode after fix
- Verify:
  - no new denials appear
  - service or command now works

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a “permission denied”, you can:
  - determine whether it is DAC or MAC
  - prove it using inspection tools
- You can:
  - fix a broken SELinux context using restore methods
  - without changing global policy or disabling SELinux
- You do not:
  - leave SELinux disabled
  - chmod/chown blindly when MAC is the real problem

Concrete tests:

- You can:
  - recover a service blocked by wrong file context
  - explain why it was blocked
  - explain why your fix is correct and minimal

---

## 🔁 Regression Rule

If later you:

- disable SELinux to get things working
- chmod/chown your way out of a MAC problem
- cannot explain why access is denied

You must:

> Return here and re-run `security-and-selinux.md` and the security triage playbook until classification is automatic again.

---

## 🧠 Operator Rule (Carry Forward)

> **Always classify DAC vs MAC before changing anything.**

---

## 🧱 This Block Enables

- Safe service recovery under SELinux
- Correct security triage
- Confident handling of “mysterious” permission failures
- A security posture that stays intact under pressure

Without this block, **you will eventually break security to fix availability**.

---

