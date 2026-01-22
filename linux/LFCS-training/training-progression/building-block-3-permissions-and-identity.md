# 🧱 Building Block 3 — Permissions and Identity

**Path:** `linux/LFCS-training/training-progression/building-block-3-permissions-and-identity.md`  
**Purpose:** Build a **correct mental model of identity and access control (DAC)** and the operational ability to **restore or restrict access safely**.

---

## 🎯 What This Block Builds

You are building:

- A precise understanding of:
  - users
  - groups
  - ownership
  - permission bits
- The ability to:
  - predict whether an action will succeed or fail
  - explain *why*
  - fix access problems **without weakening security**

This block turns “permission denied” from a mystery into a **mechanical diagnosis**.

---

## 🧠 Mental Models You Must Own

- Every filesystem access is evaluated as:
  1) who you are (UID, GID, supplementary groups)
  2) who owns the object
  3) what the mode bits allow
- Permissions are checked:
  - on the file
  - and on **every directory in the path**
- Root is not “magic”:
  - it bypasses some checks
  - but bad ownership and modes still cause breakage in services and users
- Groups exist to:
  - share access safely
  - not to avoid thinking about permissions

Invariants:

- “I can predict whether this access should succeed before I try it.”
- “If it fails, I know exactly where to look in the path.”
- “I never fix access by making things world-writable.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

Rule:

> You should be able to reason about ownership and permissions **in your head** before touching the system.

---

## 🧪 Canonical Failure Scenarios

These are exercised later, but this block prepares you for:

- Access failures
- “Works as root, fails as user”
- Services unable to read/write their own files

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/account-access-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (DAC portion)

Rule:

> You should be able to follow these playbooks **without being surprised by any permission outcome**.

---

## 🧭 Required Capabilities

You must be able to:

### Identity Management
- Create, modify, and inspect:
  - users
  - groups
- Understand:
  - primary group
  - supplementary groups
  - effective identity in a session

### Ownership and Modes
- Inspect and interpret:
  - owner
  - group
  - mode bits
- Predict:
  - read
  - write
  - execute
  - directory traversal behavior

### Path Permission Reasoning
- Walk a path and explain:
  - which directory blocks access
  - which file mode blocks access
- Use inspection tools to:
  - verify each component in the path

### Safe Fixes
- Fix access by:
  - changing owner
  - changing group
  - changing mode
- Not by:
  - making things world-writable
  - bypassing the model

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given any file path and a user, you can:
  - predict whether access should work
  - explain the result
- You can:
  - restore a user’s access without loosening global security
  - explain why your fix is minimal and correct
- You never:
  - use `chmod 777` as a “solution”
  - guess and retry blindly

Concrete tests:

- Given a failing access:
  - you can identify **exactly** which path component blocks it
- Given a service that fails due to permissions:
  - you can fix ownership/modes so it runs as its intended user

---

## 🔁 Regression Rule

If later you:

- are surprised by a permission result
- “try a few chmods” until it works
- break access for other users while fixing one

You must:

> Return here and re-run `users-and-permissions.md` until the model is automatic again.

---

## 🧠 Operator Rule (Carry Forward)

> **Never change permissions until you can explain why access is failing.**

---

## 🧱 This Block Enables

- Account recovery
- Service access fixes
- Secure multi-user operation
- Correct SELinux reasoning later (DAC vs MAC)

Without this block, **everything security-related becomes guesswork**.

---
