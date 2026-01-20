# 🔐 Phase 12 — Security: Sudo, MAC, Contexts, sysctl (Execution Playbook)
*LFCS privilege & kernel control: prove who can do what, fix MAC issues, and set kernel knobs safely.*

Path:
- linux/LFCS-execution-playbooks/phase-12-security-sudo-mac-contexts.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- safely edit sudoers and grant/restrict privileges
- verify sudo access
- inspect and fix MAC contexts (SELinux/AppArmor)
- recognize when MAC, not permissions, is blocking
- restore labels correctly
- modify sysctl values temporarily and persistently
- prove kernel parameter state

---

## 🧱 Lab Root

All Phase 12 drills run in:

- ~/lfcs-labs/phase-12

Initialize:

    mkdir -p ~/lfcs-labs/phase-12
    cd ~/lfcs-labs/phase-12
    rm -rf ./*

---

## ⚠️ Safety Contract

- ALWAYS use visudo. Never edit /etc/sudoers directly.
- Do NOT leave system in permissive/disabled MAC mode.
- Do NOT break your own sudo access.
- Restore enforcing mode and original sysctl values at the end.

---

## 🧪 Completion Standard

Pass Phase 12 when you can complete P12-1 through P12-14:

- in ≤ 120 minutes
- without locking yourself out
- with proof files created
- and system returned to safe state

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P12-1 — Verify sudo access

Time limit:
- 2 minutes

Do:

    sudo -l > sudo-before.txt

Verify:

    wc -l sudo-before.txt

-------------------------------------------------------------------------------

## P12-2 — Create test user

Time limit:
- 4 minutes

Do:

    sudo useradd -m p12user
    echo "p12user:Passw0rd!" | sudo chpasswd
    id p12user > user.txt

-------------------------------------------------------------------------------

## P12-3 — Grant sudo to user (password required)

Time limit:
- 5 minutes

Do:

    sudo visudo

Add line:

    p12user ALL=(ALL) ALL

Then:

    sudo -l -U p12user > sudo-user.txt

-------------------------------------------------------------------------------

## P12-4 — Grant passwordless sudo

Time limit:
- 4 minutes

Do:

    sudo visudo

Change line to:

    p12user ALL=(ALL) NOPASSWD: ALL

Then:

    sudo -l -U p12user > sudo-user-nopass.txt

-------------------------------------------------------------------------------

## P12-5 — Test sudo as user

Time limit:
- 4 minutes

Do:

    su - p12user
    sudo id > /tmp/p12-sudo-test.txt
    exit

Then:

    cat /tmp/p12-sudo-test.txt > sudo-test-proof.txt

-------------------------------------------------------------------------------

## P12-6 — Inspect MAC system

Time limit:
- 3 minutes

Do:

    getenforce > selinux-mode.txt 2>/dev/null || echo "no getenforce" > selinux-mode.txt
    sestatus > sestatus.txt 2>/dev/null || true
    sudo aa-status > apparmor-status.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P12-7 — Inspect file context

Time limit:
- 3 minutes

Do:

    ls -Z /bin/ls > bin-context.txt 2>/dev/null || echo "no SELinux" > bin-context.txt

-------------------------------------------------------------------------------

## P12-8 — Create and break test file context

Time limit:
- 5 minutes

Do:

    sudo mkdir -p /var/p12test
    echo TEST | sudo tee /var/p12test/file.txt
    sudo chcon -t user_home_t /var/p12test/file.txt 2>/dev/null || true
    ls -Z /var/p12test/file.txt > broken-context.txt 2>/dev/null || echo "no SELinux" > broken-context.txt

-------------------------------------------------------------------------------

## P12-9 — Restore context properly

Time limit:
- 4 minutes

Do:

    sudo restorecon -Rv /var/p12test 2>/dev/null || true
    ls -Z /var/p12test/file.txt > restored-context.txt 2>/dev/null || echo "no SELinux" > restored-context.txt

-------------------------------------------------------------------------------

## P12-10 — Create persistent context rule

Time limit:
- 6 minutes

Do:

    sudo semanage fcontext -a -t etc_t "/var/p12test(/.*)?" 2>/dev/null || true
    sudo restorecon -Rv /var/p12test 2>/dev/null || true
    ls -Z /var/p12test/file.txt > persistent-context.txt 2>/dev/null || echo "no SELinux" > persistent-context.txt

-------------------------------------------------------------------------------

## P12-11 — Toggle enforcement (temporary)

Time limit:
- 4 minutes

Do:

    getenforce > before-enforce.txt 2>/dev/null || echo "no SELinux" > before-enforce.txt
    sudo setenforce 0 2>/dev/null || true
    getenforce > during-enforce.txt 2>/dev/null || true
    sudo setenforce 1 2>/dev/null || true
    getenforce > after-enforce.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P12-12 — Inspect sysctl

Time limit:
- 3 minutes

Do:

    sysctl vm.swappiness > swappiness-before.txt

-------------------------------------------------------------------------------

## P12-13 — Change sysctl temporarily and persistently

Time limit:
- 6 minutes

Do:

    sudo sysctl -w vm.swappiness=30 > swappiness-set.txt
    sysctl vm.swappiness > swappiness-now.txt

Persist:

    echo "vm.swappiness=30" | sudo tee /etc/sysctl.d/99-p12.conf
    sudo sysctl --system > sysctl-reload.txt

Verify:

    sysctl vm.swappiness > swappiness-persist.txt

-------------------------------------------------------------------------------

## P12-14 — Cleanup

Time limit:
- 5 minutes

Do:

    sudo userdel -r p12user
    sudo rm -rf /var/p12test
    sudo rm -f /etc/sysctl.d/99-p12.conf
    sudo sysctl --system > sysctl-reset.txt
    echo OK > cleanup.txt

---

## 🏁 Phase 12 Pass Criteria

You can:

- safely grant and test sudo access
- grant passwordless sudo
- inspect and fix MAC contexts
- create persistent context rules
- toggle enforcement for diagnosis and restore it
- inspect, set, and persist sysctl values
- cleanly revert changes

---

## 🔒 Phase 12 Law

If access “should work” but doesn’t, **check MAC first**.  
If kernel behavior is odd, **check sysctl**.

---
