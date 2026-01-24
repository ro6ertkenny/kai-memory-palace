# 🛡️ Security Triage Playbook (LFCS)

Path:
  linux/LFCS-training/execution-playbooks/security-triage-playbook.md

Mental mode: Classify DAC vs MAC → Inspect → Minimal Fix → Verify → Persist  
Purpose: Restore intended access/behavior when security controls block operations, using an exam-grade operator algorithm.

This is not a tutorial.  
This is a live-system diagnosis and recovery playbook.

---

## 🎯 When To Use This Playbook

Use this playbook when:

- A command or service fails with Permission denied
- A service runs but cannot read/write required paths
- It works as root but not as the intended user/service
- SELinux/AppArmor denials appear
- Behavior changed after file moves/restores/installs

Do not use this playbook if the first evidence points to:

- service lifecycle failure → service-recovery-playbook.md
- disk/mount/boot failure → storage-recovery-playbook.md
- network/DNS is causal → network-diagnosis-playbook.md
- resource collapse dominates → process-control-playbook.md

---

## 🧭 Scenarios That Validate This Playbook

Primary:

- linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md

If you cannot solve it cleanly and repeatably, this playbook is not fluent.

---

## 🧪 Drills Required For Fluency

You must be mechanically fluent with:

- linux/LFCS-training/execution-drills/security-and-selinux.md
- linux/LFCS-training/execution-drills/users-and-permissions.md
- linux/LFCS-training/execution-drills/files-and-text.md
- linux/LFCS-training/execution-drills/services-and-logging.md
- linux/LFCS-training/execution-drills/essential-commands.md

This playbook composes drills; it does not introduce new primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1) Reproduce and observe
2) Classify: DAC vs MAC (early gate)
3) Inspect DAC (ownership, modes, traversal, ACLs)
4) Inspect MAC (SELinux/AppArmor state + denials + contexts)
5) Apply minimal correction
6) Verify
7) Make persistent
8) Roll back if needed

Never disable security permanently to “make it work”.

---

## 🧭 Classification Buckets (Pick One Before Acting)

A) DAC block (ownership/mode/traversal/ACL/sudo)  
B) MAC block (SELinux context/policy, AppArmor profile)  
C) Mixed (DAC + MAC)  
D) Not a security problem (exit)

---

## 0) Inputs

You must know or determine:

- Actor identity (user/service)
- Path(s) involved
- Exact error message
- Whether this is local-only or remote reachability

If service-related:

    systemctl status <service> --no-pager
    journalctl -u <service> -n 100 --no-pager

---

## 1) Reproduce and Preserve Evidence (No Changes Yet)

Capture actor identity:

    whoami > triage-whoami.txt
    id > triage-id.txt

Capture target path evidence:

    ls -ld <path> > triage-path.txt 2>&1
    ls -l  <path> >> triage-path.txt 2>&1

If deep path:

    namei -l <path> > triage-namei.txt 2>&1

If service-related:

    systemctl status <service> --no-pager > triage-service-status.txt 2>&1
    journalctl -u <service> -n 120 --no-pager > triage-service-journal.txt 2>&1

---

## 2) Early Gate: MAC System Presence and Recent Denials

SELinux state (if present):

    getenforce 2>/dev/null || echo "no getenforce"
    sestatus 2>/dev/null || true

Recent AVC denials:

    sudo ausearch -m avc -ts recent 2>/dev/null || true

AppArmor state (if present):

    sudo aa-status 2>/dev/null || true
    sudo journalctl -g apparmor --no-pager 2>/dev/null | tail -n 50 || true

Decision gate:

- If SELinux is Enforcing/Permissive and AVC denials exist → Bucket B or C
- If AppArmor is enabled and logs show denies → Bucket B or C
- Otherwise → Bucket A first (DAC)

---

## 3) Bucket A: Inspect DAC (Ownership / Modes / Traversal / ACL / Sudo)

Ownership and mode:

    stat <path> 2>/dev/null || true
    ls -ld <path> 2>/dev/null || true

Traversal (most common hidden cause):

    namei -l <path> 2>/dev/null || true

ACL clue (`+` in permissions) and ACL dump:

    getfacl <path> 2>/dev/null | sed -n '1,120p' || true

Actor group membership:

    id <user> 2>/dev/null || true
    groups <user> 2>/dev/null || true

If privilege is involved:

    sudo -l 2>/dev/null || true

Decision:

- If traversal or mode is wrong → Phase 4 (minimal DAC correction)
- If DAC looks correct → Bucket B (MAC)

---

## 4) Bucket A: Minimal DAC Correction (Targeted)

Fix only the minimal defect.

Examples:

    sudo chown <user>:<group> <path>
    sudo chmod 755 <dir>
    sudo chmod 644 <file>

ACL revert (only when you intend to return to classic DAC):

    sudo setfacl -b <path>

Re-test the original operation.

If fixed → Phase 7  
If not fixed → Bucket B (MAC) or Bucket C (Mixed)

---

## 5) Bucket B: Inspect MAC and Correct Properly

### 5.1 SELinux: contexts + denials

Inspect file context:

    ls -Z <path> 2>/dev/null || true

Inspect process contexts (find domain):

    ps -eZ 2>/dev/null | grep -E "<service>|sshd|httpd|nginx" || true

Re-check denials after reproducing:

    sudo ausearch -m avc -ts recent 2>/dev/null || true

Correct mislabeled trees first:

    sudo restorecon -Rv <path> 2>/dev/null || true

If the path is intentionally non-standard and needs persistent labeling:

    sudo semanage fcontext -l 2>/dev/null | grep -F "<path>" || true
    sudo semanage fcontext -a -t <type> "<path>(/.*)?" 2>/dev/null || true
    sudo restorecon -Rv <path> 2>/dev/null || true

Diagnostic gate only (never leave permissive):

    getenforce 2>/dev/null || true
    sudo setenforce 0 2>/dev/null || true
    <re-test operation>
    sudo setenforce 1 2>/dev/null || true
    getenforce 2>/dev/null || true

Interpretation:
- If it works only in permissive → it is MAC-causal. Fix via restorecon / fcontext / boolean / minimal policy.
- If it still fails → re-check DAC; you likely have a Mixed incident.

### 5.2 AppArmor: status + denial evidence

Prove AppArmor is active:

    sudo aa-status 2>/dev/null || true

Find denial evidence:

    sudo journalctl -g apparmor --no-pager 2>/dev/null | tail -n 80 || true
    sudo grep -i apparmor /var/log/syslog 2>/dev/null | tail -n 80 || true

Operator rule:
- For LFCS, treat AppArmor primarily as “recognize + gather evidence + route.”
- Corrective action is typically restoring expected paths/configs or adjusting service behavior (minimal change).

---

## 6) Bucket C: Mixed (DAC + MAC)

When you suspect both:

- Fix traversal/ownership/modes first (DAC)
- Then restorecon and re-check denials (MAC)
- Verify after each single change

Never change both layers at once without a re-test.

---

## 7) Verification Gate (Required Proof)

Confirm:

- The original operation works
- No new denials appear
- MAC is enforcing/enabled (when present)

SELinux proof:

    getenforce 2>/dev/null || true
    sudo ausearch -m avc -ts recent 2>/dev/null || true

Service proof:

    systemctl status <service> --no-pager 2>/dev/null || true
    journalctl -u <service> -n 80 --no-pager 2>/dev/null || true

---

## 8) Persistence Check

Ensure:

- SELinux is Enforcing (if present)
- No broad permissions were left behind (no 777)
- Any fcontext rules are minimal and correct
- AppArmor state is unchanged unless explicitly required

SELinux fcontext proof (if used):

    sudo semanage fcontext -l 2>/dev/null | grep -F "<path>" || true

---

## 🔁 Rollback Strategy

If you loosened DAC too far:

- restore tighter modes/ownership
- re-test immediately

If SELinux labeling changes went wrong:

- remove custom fcontext rules if you added the wrong one
- restore defaults:

    sudo restorecon -Rv <path> 2>/dev/null || true

If you changed a firewall or service setting accidentally:

- exit to the correct playbook:
  - service-recovery-playbook.md
  - network-diagnosis-playbook.md

---

## 🚫 Anti-Patterns (Auto-Fail)

- Leaving SELinux permissive/disabled
- Solving with chmod 777
- Mixing DAC + MAC changes without classification
- Restarting services repeatedly without reading logs
- “Fixing” by weakening security instead of proving cause

---

## ✅ Completion Criteria

- Operation/service works
- Permissions are minimal and correct
- SELinux is enforcing (if applicable)
- AppArmor evidence is understood (if applicable)
- No new denials appear
- Behavior is stable and repeatable

You can explain:

- DAC vs MAC vs Mixed
- what evidence proved it
- what minimal fix you applied
- how you verified recovery

---

