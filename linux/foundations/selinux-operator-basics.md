# 🔒 SELinux — Operator Basics (LFCS-Level)

Mental mode: Diagnose quickly, prove cause, fix labels, move on.

SELinux is **Mandatory Access Control (MAC)**. It can deny access even when normal Unix permissions (owner/group/mode) look correct.

LFCS does **not** require policy authoring. It does require **mechanical diagnosis and common fixes**.

---

## ✅ What SELinux Is (One Mental Model)

Access is allowed only if **both** layers allow it:

- Traditional permissions (user/group/mode + ACLs)
- SELinux policy (contexts/labels)

If either layer denies, the result is typically:

- `Permission denied`
- A service failing to start
- A daemon unable to read/write files

---

## 🎯 LFCS Operator Goal

You must be able to:

1) Detect SELinux is enabled/enforcing
2) Prove SELinux is the cause
3) Fix the issue correctly (usually labels)
4) Avoid leaving SELinux disabled

---

## 🔎 Minimum Command Set (Must Be Automatic)

Check state:

    getenforce
    sestatus

Inspect file contexts:

    ls -Z /path
    ps -eZ | head

Prove SELinux is the cause (temporary diagnostic step):

    sudo setenforce 0
    # re-test failing operation
    sudo setenforce 1

Common repair (restore default labels):

    sudo restorecon -Rv /path

View recent denials (quick triage):

    sudo ausearch -m avc -ts recent
    sudo journalctl -t setroubleshoot --since "10 min ago" || true

---

## 🧯 Standard Failure Pattern (Recognize It)

Symptom:

- Service fails to start, or cannot read/write a file
- Unix permissions appear correct
- Logs show `permission denied` (but nothing obvious)

Mechanical flow:

1) Confirm enforcing:

       getenforce

2) Prove it:

       sudo setenforce 0
       # re-test
       sudo setenforce 1

   If the problem disappears when permissive:
   SELinux is confirmed as the cause.

3) Fix labels (most common LFCS-level fix):

       ls -Z /path
       sudo restorecon -Rv /path

4) Re-test the service or operation.

---

## ✅ The 90% Fix: Bad Labels

If a service expects its data in a labeled directory and you place data elsewhere (or copy files), labels can be wrong.

Fix:

    sudo restorecon -Rv /var/www
    sudo restorecon -Rv /var/lib/<service>
    sudo restorecon -Rv /etc/<service>

Note: `restorecon` resets labels to the system defaults for that path.

---

## 🧪 LFCS Practice Drills (Do These Until Boring)

### Drill 1 — Prove SELinux is the cause
Goal: build reflex.

1) Pick a service that reads a config or serves files (httpd/nginx on SELinux systems).
2) Create a directory with correct Unix perms but wrong SELinux context (common when copying files).
3) Observe failure.
4) Execute:

       getenforce
       sudo setenforce 0
       # re-test
       sudo setenforce 1
       sudo restorecon -Rv /path
       # re-test

Success criteria:
- You can prove SELinux was the cause in under 2 minutes.
- You can fix it without leaving SELinux disabled.

### Drill 2 — Identify a labeled file vs unlabeled file
Goal: “read contexts” mechanically.

1) Run:

       ls -Z /etc | head
       ls -Z /var | head

2) Explain (to yourself, quickly):
- “This is a label/context. It’s another permission layer.”

Success criteria:
- You stop treating SELinux as mystical.
- You treat it like a label mismatch problem.

---

## ⛔ Operator Rules (Non-Negotiable)

- `setenforce 0` is for **diagnosis**, not a solution.
- Fix labels with `restorecon` unless you have a specific reason not to.
- If you cannot explain why something is denied, collect evidence:
  - `getenforce`, `ls -Z`, relevant logs, recent AVC events

---
