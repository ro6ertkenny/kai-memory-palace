# 🧯 Scenario 11 — SELinux Denial Breaks a Service (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbooks:
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if access is to a network resource)
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if access is to storage paths)

---

## 📌 Incident Brief (Symptom-First)

A service that **should work**:

- fails to start, or
- starts but immediately errors, or
- runs but cannot access a file, socket, or port

Logs show messages like:

- “permission denied”
- “AVC denied”
- “SELinux is preventing …”

Disabling SELinux “fixes” it.

Your job is to:
- **prove** this is an SELinux policy problem
- classify **what kind of denial this is**
- fix it **without weakening security**
- restore the service
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Prove SELinux is the blocker (not UNIX permissions, not missing files)
- Identify:
  - what domain the service runs in
  - what object/class is being denied
- Apply the **minimal safe policy or labeling fix**
- Prove:
  - the service works with SELinux enforcing
  - no broad or unsafe policy change was made

---

## 🧠 Operator Rule

> **Never “fix” SELinux by turning it off.**  
> **Never use permissive as a solution—only as a diagnostic tool.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Wrong file context / mislabeled path**
2) **Service accessing a path it is not allowed to**
3) **Missing boolean or disabled allow rule**
4) **Custom app or new path requiring a local policy**
5) **Not actually SELinux (classic UNIX permissions or missing file)**

---

## 🧪 Required Evidence (Is SELinux Enforcing?)

First confirm SELinux state:

  getenforce
  sestatus

If it is **Disabled** → this is not an SELinux incident.

If **Enforcing** → proceed.

---

## 🧪 Capture the Actual Denial

From logs:

  ausearch -m avc -ts recent || true
  journalctl -t setroubleshoot --no-pager || true
  journalctl | rg -i "avc|selinux|denied" || true

If available:

  sealert -a /var/log/audit/audit.log || true

You are looking for:

- source context (scontext)
- target context (tcontext)
- class (file, dir, tcp_socket, etc.)
- denied operation (read, write, name_connect, etc.)

---

## 🧩 Identify the Service Domain

Find the service’s domain:

  ps -eZ | rg servicename || true

Or:

  systemctl status servicename --no-pager

Now you know:

- what domain is trying to access what

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Wrong file context / mislabeled path
Signals:
- service tries to access a file under a custom or new directory
- context does not match expected type
Route:
- `security-triage-playbook.md`
Goal:
- restore or assign correct label
Proof:
- access works without policy changes

### Fork B — Missing boolean
Signals:
- denial is common and documented
- boolean exists for this behavior
Route:
- `security-triage-playbook.md`
Goal:
- enable the correct boolean intentionally
Proof:
- denial disappears and service works

### Fork C — Service accessing forbidden path
Signals:
- path is truly outside allowed scope
Route:
- `security-triage-playbook.md`
Goal:
- move data to an allowed location **or**
- explicitly authorize via local policy
Proof:
- service works with SELinux still enforcing

### Fork D — Custom app / new behavior
Signals:
- no existing rule or boolean fits
Route:
- `security-triage-playbook.md`
Goal:
- generate and install **minimal** local policy
Proof:
- denial gone, no other access widened

### Fork E — Not SELinux
Signals:
- no AVCs
- denial is classic permission or missing file
Route:
- `service-recovery-playbook.md` or filesystem fix
Proof:
- service works without touching SELinux

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not set SELinux to Disabled as a “fix”.
- Do not leave the system in Permissive mode.
- Do not use broad allow rules.
- Do not relabel the entire filesystem.

---

## 🧯 Recovery Principles

- Always:
  - fix **labels**, **booleans**, or **minimal policy**
- Prefer:
  - correct labeling over new policy
  - booleans over custom rules
  - minimal local policy over broad allow

---

## ✅ Verification (Required Proof)

- SELinux is **Enforcing**:

  getenforce

- Service is healthy:

  systemctl status servicename --no-pager

- No new AVC denials appear:

  ausearch -m avc -ts recent || true

- Functional test of the service succeeds.

---

## 🧾 Post-Incident Debrief

Answer:

- What was the source domain?
- What was the target object and class?
- Which bucket was this?
- What was the minimal safe fix?
- Why is this better than disabling SELinux?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Turning SELinux off
- Leaving the system in Permissive mode
- Adding broad allow rules
- Ignoring AVC details
- Treating SELinux as “random breakage”

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you struggled reading AVCs and contexts:
- Drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If you misused labels or booleans:
- Drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If you jumped to disabling SELinux:
- Drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- eliminate fear-driven SELinux handling
- strengthen minimal-change discipline
- reinforce evidence-based security fixes

---
