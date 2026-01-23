# 🛡️ Security Triage Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`  
Mental mode: **Classify DAC vs MAC → Inspect → Minimal Fix → Verify → Persist**  
Purpose: Restore **intended access and behavior** when security controls (permissions, ownership, SELinux) block operations, using a **safe, exam-grade operator algorithm**.

This is **not** a tutorial.  
This is a **live-system diagnosis and recovery playbook**.

---

## 🧠 When To Use This Playbook

Use this playbook when:

- A command or service fails with **Permission denied**
- A service runs but cannot read/write required paths
- An operation works as root but not as the intended user
- SELinux blocks behavior (denials, unexpected failures)
- Behavior changed after file moves, restores, or package installs

Do **not** use this playbook if the **first evidence** points to:

- the service is not running (lifecycle failure) → `service-recovery-playbook.md`
- disk/mount/boot state is broken → `storage-recovery-playbook.md`
- network reachability or DNS is causal → `network-diagnosis-playbook.md`
- process storm/resource collapse dominates → `process-control-playbook.md`

---

## 🧭 Scenarios That Validate This Playbook

This playbook is exercised by:

- `linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md`

If you cannot solve that scenario **cleanly and repeatably**, this playbook is not yet fluent.

---

## 🧪 Drills Required For Fluency

You should be mechanically fluent with:

- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md` (for service-impact recovery)

This playbook is a **composition layer**, not a source of primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1. Reproduce and observe
2. Classify: **DAC vs MAC**
3. Inspect DAC (ownership, modes, path traversal)
4. Inspect MAC (SELinux)
5. Apply minimal correction
6. Verify
7. Make persistent
8. Roll back if needed

> **Never disable security permanently to “make it work”.**

---

## 🧭 Global Safety Rules

- Preserve evidence first.
- Decide DAC vs MAC early; do not mix fixes blindly.
- Prefer minimal, targeted changes.
- Never leave SELinux disabled.
- Every action requires verification.

---

## 🧭 Classification Buckets (Pick One Before Acting)

You must place the incident into **exactly one** bucket:

A) DAC block (ownership/mode/path traversal)  
B) MAC block (SELinux context/policy)  
C) Mixed (DAC + MAC)  
D) Not a security problem (exit playbook)

---

## 🧪 Phase 1 — Reproduce and Observe

Capture the failing symptom and context:

- The exact error message
- The path being accessed
- The identity of the actor (user/service)

If service-related:

  systemctl status <service> --no-pager  
  journalctl -u <service> --no-pager -n 80  

If command-line:

  <command>  

Record:

- user identity (`id`, `whoami`)
- path(s) involved
- whether the failure is user-only or system-wide

---

## 🧪 Phase 2 — Classify DAC vs MAC (Early Gate)

Check SELinux mode:

  getenforce || true  

Check for recent denials:

  ausearch -m avc -ts recent || true  

Decision gate:

- If AVC denials exist and SELinux is Enforcing/Permissive → Bucket B or C
- If no AVC denials (or SELinux disabled) → Bucket A (DAC first)

---

## 🧪 Phase 3 — Inspect DAC (Ownership / Modes / Path Traversal)

Inspect the target path and parents:

  ls -ld /path  
  ls -l /path  

If file deep in tree:

  namei -l /path/to/file  

Check:

- owner and group
- mode bits
- execute bit on all parent directories
- whether the actor is in the required group(s)

If service-related, confirm runtime identity:

  ps -eo pid,user,comm | grep <service> || true  

Decision:

- If ownership/modes/path traversal is wrong → Phase 4
- If DAC looks correct → Phase 5 (MAC)

---

## 🧪 Phase 4 — Minimal DAC Correction

Fix owner/group (targeted):

  chown user:group /path  
  chown -R user:group /path  

Fix modes (minimal):

  chmod 755 /dir  
  chmod 644 /file  

Re-test the failing action.

If fixed → Phase 7  
If still failing → Phase 5

---

## 🧪 Phase 5 — Inspect and Correct SELinux (MAC)

Check contexts:

  ls -Z /path || true  
  ls -Z /path/to/file || true  

Re-check denials:

  ausearch -m avc -ts recent || true  

If files were moved/restored or look mislabeled:

  restorecon -Rv /path  

If a custom context is required, inspect rules:

  semanage fcontext -l | grep /path || true  

Temporary diagnostic only:

  setenforce 0  

Re-test the failing action.

If it works in permissive:

- Re-enable enforcing:

  setenforce 1  

- Fix contexts properly using `restorecon` or a precise `semanage fcontext` rule.

If it still does not work:

- Return to Phase 3 and re-evaluate DAC (mixed case likely).

If policy design is required beyond labeling:

- Exit to `security-triage-playbook.md` is already the correct surface
- Keep changes minimal and evidence-driven

---

## 🧪 Phase 6 — Service-Specific Security Checks

If a service still fails, re-check evidence:

  systemctl status <service> --no-pager  
  journalctl -u <service> --no-pager -n 100  

Common security blockers:

- data directory wrong owner or context
- log directory not writable
- runtime socket/pid directory wrong owner or context

Fix with minimal:

  chown  
  chmod  
  restorecon  

Then:

  systemctl restart <service>  

Proceed to Phase 7.

---

## 🧪 Phase 7 — Verification Gate

Verify the original workflow is restored.

If service-related:

  systemctl status <service> --no-pager  

Confirm no new denials:

  ausearch -m avc -ts recent || true  

Confirm no permission errors recur in logs.

---

## 🧪 Phase 8 — Persistence Check

Ensure:

- SELinux is Enforcing (if applicable)
- no broad permissions remain (avoid 777)
- ownership changes are intentional
- any fcontext rules are correct and minimal

If custom fcontext rules were added:

  semanage fcontext -l | grep /path || true  

---

## 🔁 Rollback Strategy

If you over-loosened DAC:

- restore tighter ownership/modes
- re-test immediately

If SELinux labeling changes went wrong:

- remove custom fcontext rules (if added)
- re-apply defaults:

  restorecon -Rv /path  

---

## 🚫 Anti-Patterns (Auto-Fail)

- Disabling SELinux and leaving it that way
- Using `chmod 777` as a “solution”
- Changing both DAC and MAC without classification
- Restarting services repeatedly without inspecting logs
- Fixing symptoms without confirming the actor identity

---

## 🧭 Exit Conditions

Exit this playbook if you discover:

- service lifecycle failure → `service-recovery-playbook.md`
- storage/mount/boot failure → `storage-recovery-playbook.md`
- network/DNS root cause → `network-diagnosis-playbook.md`
- process storm/resource collapse → `process-control-playbook.md`

---

## ✅ Completion Criteria

- Operation or service works
- Permissions are minimal and correct
- SELinux is Enforcing (if applicable)
- No new denials appear
- Behavior is stable and repeatable

You can explain:

- whether the block was DAC or MAC
- what specifically was wrong
- why your fix was minimal and safe
- how you verified recovery

---

## 🧠 Exam Safety Rules

- Never leave SELinux disabled
- Never “solve” with 777
- Always classify DAC vs MAC first
- Prefer `restorecon` before inventing contexts
- Verify after every change

---
