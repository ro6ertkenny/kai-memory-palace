# 🧪 LFCS Execution Drills — Phase 10
# 🔐 Security Contexts, MAC (SELinux/AppArmor), and Privilege Boundaries

Path:
  linux/execution-drills/phase-10-security-contexts-selinux-apparmor.md

Purpose:
  Build reflex-level diagnosis and repair of access problems caused by SELinux/AppArmor, not classic permissions.

Mental Mode:
  If permissions look right but access is denied, assume MAC until proven otherwise.

---

## 🧱 Lab Safety Rules

⚠️ Do NOT leave the system in permissive or disabled mode.
⚠️ Always restore enforcing mode after debugging.
⚠️ Do NOT practice this on a production machine.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-10
    cd ~/lfcs-labs/execution-drills/phase-10

Install tools (if missing):

    sudo apt update
    sudo apt install -y policycoreutils selinux-utils setools setroubleshoot

Note:
- On Ubuntu, AppArmor is usually active instead of SELinux.
- On RHEL/Rocky/Alma, SELinux is active.
- These drills assume **SELinux is available**. If this system uses AppArmor, treat the SELinux parts as *conceptual* and inspect AppArmor status with aa-status.

---

# A) Determine What Is In Use

## A1 — Check MAC system

SELinux:

    getenforce || true
    sestatus || true

AppArmor:

    sudo aa-status || true

Write down:
- Which one is active?
- In what mode?

---

# B) Inspect Contexts (SELinux)

(If SELinux is not present, read only.)

## B1 — Inspect file context

    ls -Z /bin/ls || true
    ls -Z /usr/bin/sudo || true

## B2 — Inspect process context

    ps auxZ | head || true

Find sshd or systemd if available:

    ps auxZ | grep -E 'sshd|systemd' || true

Explain format:

    user:role:type:level

---

# C) Simulated Context Problem (Safe)

We will simulate using /var/www if nginx/apache is present.

## C1 — Create test content

    sudo mkdir -p /var/www/html/phase10
    echo "HELLO PHASE 10" | sudo tee /var/www/html/phase10/index.html

Check context:

    ls -Z /var/www/html/phase10/index.html || true

---

## C2 — Break the context (Temporary)

(If chcon exists)

    sudo chcon -t bin_t /var/www/html/phase10/index.html || true

Verify:

    ls -Z /var/www/html/phase10/index.html || true

This simulates “permissions look right, but access is denied”.

---

# D) Correct Fix — restorecon

## D1 — Restore default labels

    sudo restorecon -Rv /var/www/html/phase10 || true

Verify:

    ls -Z /var/www/html/phase10/index.html || true

Explain:
- This is the **preferred fix** when labels drift.

---

# E) Temporary Fix — chcon (Know Why It’s Bad)

## E1 — Break again

    sudo chcon -t bin_t /var/www/html/phase10/index.html || true

## E2 — Fix with chcon

    sudo chcon -t httpd_sys_content_t /var/www/html/phase10/index.html || true

Explain:
- This works
- But will be lost after relabel or restorecon

---

# F) Persistent Fix — semanage fcontext

## F1 — Add persistent rule

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html/phase10(/.*)?" || true

## F2 — Apply

    sudo restorecon -Rv /var/www/html/phase10 || true

List rules:

    sudo semanage fcontext -l | grep phase10 || true

Explain:
- This survives relabels and restores.

---

# G) Toggle Enforcement (Debug Only)

## G1 — Check current mode

    getenforce || true

## G2 — Set permissive

    sudo setenforce 0 || true
    getenforce || true

Explain:
- Policy still logs
- But does not block

## G3 — Set enforcing back

    sudo setenforce 1 || true
    getenforce || true

---

# H) Find Denials

## H1 — Search audit logs

    sudo ausearch -m avc || true

Or:

    sudo journalctl -t setroubleshoot || true

Or general:

    sudo journalctl -g denied || true

---

# I) AppArmor (If This System Uses It)

## I1 — Status

    sudo aa-status || true

Explain:
- Profiles
- Enforce vs complain mode

(Do not change profiles unless in a VM.)

---

# J) Timed Drills

## J1 — Check SELinux mode and save (10 seconds)

    getenforce > ~/lfcs-labs/execution-drills/phase-10/selinux-mode.txt || true

---

## J2 — Check context of binary (10 seconds)

    ls -Z /usr/bin/less || true

---

## J3 — Fix mislabeled tree (20 seconds)

    sudo restorecon -Rv /var/www || true

---

# K) Failure Injection Drills (Mental)

## K1 — “chmod didn’t fix it”

Scenario:
- Permissions are 755
- Still denied

Answer:
- Check MAC
- getenforce
- ls -Z
- logs

---

## K2 — Leaving permissive mode

Explain:
- Why this is dangerous
- Why it should only be temporary

---

## K3 — Using chcon instead of semanage

Explain:
- Why it’s not persistent
- When it’s acceptable (temporary test only)

---

# L) Composition (Exam Style)

## L1 — Diagnose invisible denial

Checklist:

    getenforce
    ls -Z <file>
    ps auxZ | grep <service>
    journalctl -g denied

Decide:
- Is this DAC or MAC?

---

## L2 — Proper fix flow

1) Identify wrong label
2) Try restorecon
3) If path is non-standard:
   - semanage fcontext
   - restorecon
4) Verify
5) Return enforcing mode

---

# ✅ Phase 10 Completion Criteria

You are Phase 10-ready when you can:

- Check whether SELinux/AppArmor is active
- Interpret security contexts
- Recognize “permissions are fine but still denied”
- Restore correct contexts with restorecon
- Create persistent rules with semanage fcontext
- Use chcon only as a temporary test
- Find AVC denials in logs
- Toggle enforcement safely for debugging and restore it

---

# 🔒 Phase 10 Law

If you don’t understand MAC, you will “fix” systems by making them less secure.

---
