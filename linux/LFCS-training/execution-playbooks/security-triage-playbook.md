# 🛡️ Security Triage Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`  
**Purpose:** Restore **intended access and behavior** when security controls (permissions, ownership, SELinux) block operations, using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- A command or service fails with **Permission denied**
- A service runs but **cannot access files**
- An operation works as root but **not as a user**
- SELinux **silently blocks** or logs denials
- Behavior changed after **file moves, restores, or package installs**

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- (Future) selinux-denial-breaks-service  
- (Future) permissions-regression-after-restore

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Reproduce and observe**
2. **Classify: DAC vs MAC**
3. **Inspect DAC (ownership / permissions)**
4. **Inspect MAC (SELinux)**
5. **Apply minimal correction**
6. **Verify**
7. **Make persistent**
8. **Rollback if needed**

Never disable security permanently to “make it work”.

---

## 🧭 Global Safety Rules

- **Preserve evidence first.** Read errors and logs before changing anything.
- **Decide DAC vs MAC early.** Do not mix fixes blindly.
- **Prefer minimal, targeted changes.**
- **Never leave SELinux disabled.**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- The failing command or service
- The exact error message
- The file or path involved (if any)
- Whether the failure is **user-only** or **system-wide**

---

## 1) Reproduce and Observe

Re-run the failing action and capture the error.

If service-related:

    systemctl status <service> --no-pager
    journalctl -u <service> --no-pager -n 80

If command-line:

    <command>

Record:

- Path being accessed
- User identity
- Exact wording of the error

---

## 2) Classify: DAC vs MAC

Check SELinux mode:

    getenforce

Interpretation:

- Enforcing → both DAC and MAC may apply
- Permissive → only DAC blocks, but MAC denials are logged
- Disabled → only DAC applies

Check for SELinux denials:

    ausearch -m avc -ts recent

Branch:

- If **AVC denials exist** → go to **Section 5**
- If **no AVC denials or SELinux disabled** → go to **Section 3**

---

## 3) Inspect Ownership and Permissions (DAC)

Inspect the target path:

    ls -ld /path
    ls -l /path

Walk the tree if needed:

    namei -l /path/to/file

Check:

- Owner
- Group
- Mode bits
- Execute bit on all parent directories

If service-related, confirm runtime user:

    ps -eo pid,user,comm | grep <service>

Branch:

- If **ownership/mode is incorrect** → go to **Section 4**
- If **ownership/mode looks correct** → go to **Section 5**

---

## 4) Correct DAC (Ownership / Mode)

Fix owner/group:

    chown user:group /path
    chown -R user:group /path

Fix modes (be minimal):

    chmod 755 /dir
    chmod 644 /file

Re-test the failing action.

- If fixed → go to **Section 7**
- If still failing → go to **Section 5**

---

## 5) Inspect and Correct SELinux (MAC)

Check context:

    ls -Z /path
    ls -Z /path/to/file

Check recent denials:

    ausearch -m avc -ts recent

If files were moved or restored, reset to defaults:

    restorecon -Rv /path

If a path requires a custom context, inspect existing rules:

    semanage fcontext -l | grep /path

Temporary diagnostic ONLY (never leave it this way):

    setenforce 0

Re-test the action.

If it works in permissive:

- Re-enable enforcing:

    setenforce 1

- Fix contexts properly using `restorecon` or a precise `semanage fcontext` rule.

If it still does not work:

- Return to **Section 3** and re-evaluate DAC.

---

## 6) Service-Specific Checks

If a service still fails:

    systemctl status <service> --no-pager
    journalctl -u <service> --no-pager -n 100

Common causes:

- Data directory context wrong
- Log directory not writable
- Socket or PID directory wrong owner/context

Fix with:

    chown
    chmod
    restorecon

Then restart:

    systemctl restart <service>

Return to **Section 7**.

---

## 7) Verification

Re-test:

- The original command or workflow
- The service, if applicable:

    systemctl status <service> --no-pager

Confirm:

- No new AVC denials:

    ausearch -m avc -ts recent

- No permission errors appear

---

## 8) Persistence Check

Ensure:

- Fix survives reboot
- No temporary hacks remain:
  - SELinux is Enforcing (if applicable)
  - No over-broad modes (e.g., 777)
  - No unnecessary ownership changes

If custom fcontext rules were added, confirm:

    semanage fcontext -l | grep /path

---

## 🔁 Rollback Strategy

If you over-loosened permissions:

- Restore tighter modes and ownership
- Re-apply defaults:

    restorecon -Rv /path

If SELinux changes cause new issues:

- Remove the custom fcontext rule
- Re-apply default contexts

---

## ✅ Completion Criteria

- Operation or service works
- Permissions are **minimal and correct**
- SELinux is **Enforcing** (if applicable)
- No new denials appear
- Behavior is stable

You can explain:

- Whether the block was DAC or MAC
- What specifically was wrong
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Never leave SELinux disabled
- Never use `chmod 777` as a “solution”
- Always classify DAC vs MAC first
- Prefer `restorecon` before inventing new contexts
- Verify after every change

---

## 🧱 This Playbook Composes From

- security-and-selinux.md
- users-and-permissions.md
- files-and-text.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---

