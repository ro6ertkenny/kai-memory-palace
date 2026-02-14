# 🔒 SELinux — Operator Basics (LFCS-Level)

Mental mode: Diagnose quickly, prove cause, fix labels, move on.

SELinux is **Mandatory Access Control (MAC)**. It can deny access even when normal Unix permissions (owner/group/mode) look correct.

LFCS does **not** require policy authoring. It does require **mechanical diagnosis and common fixes**:
- inspect contexts
- confirm enforcing/permissive
- fix labels (restore defaults)
- apply/adjust contexts (chcon / semanage)
- return to enforcing

---

## ✅ What SELinux Is (One Mental Model)

Access is allowed only if **both** layers allow it:

- Traditional permissions (user/group/mode + ACLs)
- SELinux policy (contexts/labels)

If either layer denies, the result is typically:

- Permission denied
- A service failing to start
- A daemon unable to read/write files

---

## 🎯 LFCS Operator Goal

You must be able to:

1) Detect SELinux is enabled/enforcing
2) Prove SELinux is the cause (diagnostic)
3) Fix the issue correctly (usually labels)
4) Avoid leaving SELinux disabled

---

## 🔎 Minimum Command Set (Must Be Automatic)

Check state:

    getenforce
    sestatus

Inspect contexts:

    ls -Z /path
    ps -eZ | head

Toggle enforcement (diagnostic step):

    sudo setenforce 0
    sudo setenforce 1

Restore default labels:

    sudo restorecon -Rv /path

Set context temporarily:

    sudo chcon -t <type> /path

Set context persistently:

    sudo semanage fcontext -a -t <type> '/path(/.*)?'
    sudo restorecon -Rv /path

View recent denials (quick triage on SELinux systems):

    sudo ausearch -m avc -ts recent
    sudo journalctl -t setroubleshoot --since "10 min ago" || true

---

## 🧠 Contexts, quickly (what ls -Z is showing)

SELinux labels are often displayed as:

    user:role:type:level

For LFCS operator mechanics, the key field is usually:

- type

Because policy decisions often hinge on:
- file type label
- process type label

---

## 🧱 Standard failure pattern (recognize it)

Symptom:
- Service fails to start, or cannot read/write a file
- Unix permissions appear correct
- Logs show permission denied, but nothing obvious

Mechanical flow:

1) Confirm enforcing:

    getenforce

2) Prove it (temporary):

    sudo setenforce 0
    # re-test failing operation
    sudo setenforce 1

If the problem disappears when permissive:
- SELinux is confirmed as the cause

3) Fix labels (most common LFCS-level fix):

    ls -Z /path
    sudo restorecon -Rv /path

4) Re-test the service or operation.

---

## ✅ The 90% fix: restore default labels (restorecon)

Label drift happens when you:
- copy files into a protected tree
- move content to non-standard locations
- restore backups without preserving xattrs

Reset to defaults for the path:

    sudo restorecon -Rv /var/www
    sudo restorecon -Rv /var/lib/<service>
    sudo restorecon -Rv /etc/<service>

Mental model:
- restorecon sets labels to what the system policy expects for that path

---

## 🧪 Temporary label change (chcon) — use intentionally

`chcon` changes the label immediately, but it is not necessarily persistent across full relabel operations.

View current label:

    ls -Z /path

Change type (example pattern):

    sudo chcon -t <type> /path

Recursive:

    sudo chcon -R -t <type> /path

Use this for:
- quick test
- short-lived fix
- immediate unblocking while you plan the persistent rule

---

## ✅ Persistent label change (semanage + restorecon)

Use semanage when:
- you need a non-default path to carry a specific SELinux type
- you want the fix to survive restorecon/relabel

Add a persistent file context rule:

    sudo semanage fcontext -a -t <type> '/path(/.*)?'

Apply the rule by relabeling:

    sudo restorecon -Rv /path

List custom fcontext rules (useful for auditing):

    sudo semanage fcontext -l | head

Remove a custom fcontext rule (pattern-based):

    sudo semanage fcontext -d '/path(/.*)?'
    sudo restorecon -Rv /path

Note:
- semanage may not be installed by default in minimal images
- if missing, install the package that provides it (distro-specific)

---

## 🧭 setenforce (diagnostic, not a solution)

Permissive mode allows actions but logs denials.
Enforcing blocks actions according to policy.

Temporary toggle:

    sudo setenforce 0
    sudo setenforce 1

Operator rule:
- If you use permissive to prove the cause, you must return to enforcing after fixing.

---

## 🔍 Evidence collection (when unsure)

Capture these quickly:

    getenforce
    ls -Z /path
    ps -eZ | head
    sudo ausearch -m avc -ts recent

If a service is involved:

    systemctl status <service> --no-pager
    journalctl -u <service> -n 50 --no-pager

---

## ⛔ Operator Rules (Non-Negotiable)

- `setenforce 0` is for diagnosis, not the final state.
- Fix labels with `restorecon` unless you have a specific reason not to.
- Use `chcon` for temporary changes; use `semanage fcontext` for persistent intent.
- If you cannot explain why something is denied, collect evidence before changing policy.

---

## 🔗 Drill references (not duplicated here)

- `linux/LFCS-training/execution-drills/selinux-diagnose-and-fix.md`

---

## 🪝 Exam memory hook

Prove → fix → enforce:

    getenforce
    sudo setenforce 0
    sudo setenforce 1
    sudo restorecon -Rv /path

Persistent fix pattern:

    sudo semanage fcontext -a -t <type> '/path(/.*)?'
    sudo restorecon -Rv /path

