# 🔐 Phase 10 — Security Contexts, SELinux / AppArmor (Execution Playbook)
*LFCS MAC layer: diagnose “permissions look right but it still fails”, fix labels, and prove enforcement state.*

Path:
- linux/LFCS-execution-playbooks/phase-10-security-contexts-selinux-apparmor.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- detect whether SELinux/AppArmor is in use
- inspect security contexts
- recognize MAC vs DAC failures
- restore correct labels
- apply persistent context rules
- safely toggle enforcement for diagnosis
- prove fixes using logs and context inspection

---

## 🧱 Lab Root

All Phase 10 drills run in:

- ~/lfcs-labs/phase-10

Initialize:

    mkdir -p ~/lfcs-labs/phase-10
    cd ~/lfcs-labs/phase-10
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT leave system in permissive/disabled mode.
- Do NOT “fix” MAC problems with chmod/chown.
- Always restore enforcing mode at the end.
- These drills assume SELinux or AppArmor is present. If only AppArmor exists, perform the status/inspection parts that apply.

---

## 🧪 Completion Standard

Pass Phase 10 when you can complete P10-1 through P10-12:

- in ≤ 90 minutes
- without disabling security permanently
- with proof files created
- and with SELinux/AppArmor returned to enforcing/enabled

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P10-1 — Identify security system and mode

Time limit:
- 3 minutes

Task:
Capture MAC system status.

Do:

    getenforce > selinux-mode.txt 2>/dev/null || echo "no getenforce" > selinux-mode.txt
    sestatus > sestatus.txt 2>/dev/null || true
    sudo aa-status > apparmor-status.txt 2>/dev/null || true

Verify:

    ls -l selinux-mode.txt

-------------------------------------------------------------------------------

## P10-2 — Inspect file context

Time limit:
- 3 minutes

Task:
Inspect context of a system binary.

Do:

    ls -Z /bin/ls > ls-context.txt 2>/dev/null || echo "ls -Z not supported" > ls-context.txt

Verify:

    wc -l ls-context.txt

-------------------------------------------------------------------------------

## P10-3 — Inspect process contexts

Time limit:
- 3 minutes

Task:
Capture contexts of sshd or another system service.

Do:

    ps auxZ > processes-contexts.txt 2>/dev/null || ps aux > processes-contexts.txt

Verify:

    wc -l processes-contexts.txt

-------------------------------------------------------------------------------

## P10-4 — Create test web directory

Time limit:
- 4 minutes

Task:
Create fake web root.

Do:

    sudo mkdir -p /var/www/p10test
    echo "P10 TEST" | sudo tee /var/www/p10test/index.html
    ls -l /var/www/p10test > webdir.txt

-------------------------------------------------------------------------------

## P10-5 — Break context intentionally

Time limit:
- 4 minutes

Task:
Change context to something wrong (if SELinux present).

Do:

    sudo chcon -t user_home_t /var/www/p10test/index.html 2>/dev/null || true
    ls -Z /var/www/p10test/index.html > broken-context.txt 2>/dev/null || echo "no SELinux" > broken-context.txt

-------------------------------------------------------------------------------

## P10-6 — Restore default context

Time limit:
- 4 minutes

Task:
Fix the label properly.

Do:

    sudo restorecon -Rv /var/www/p10test 2>/dev/null || true
    ls -Z /var/www/p10test/index.html > restored-context.txt 2>/dev/null || echo "no SELinux" > restored-context.txt

-------------------------------------------------------------------------------

## P10-7 — Verify difference

Time limit:
- 2 minutes

Task:
Show that label changed.

Do:

    diff broken-context.txt restored-context.txt || true
    echo OK > restore-proof.txt

-------------------------------------------------------------------------------

## P10-8 — Create persistent context rule

Time limit:
- 6 minutes

Task:
Make /var/www/p10test permanently web-readable (SELinux).

Do:

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/p10test(/.*)?" 2>/dev/null || true
    sudo restorecon -Rv /var/www/p10test 2>/dev/null || true
    ls -Z /var/www/p10test/index.html > persistent-context.txt 2>/dev/null || echo "no SELinux" > persistent-context.txt

-------------------------------------------------------------------------------

## P10-9 — Find denial logs

Time limit:
- 4 minutes

Task:
Search for AVC or denial messages.

Do:

    sudo ausearch -m avc > avc.txt 2>/dev/null || sudo journalctl | grep -i denied > avc.txt || true

Verify:

    wc -l avc.txt

-------------------------------------------------------------------------------

## P10-10 — Toggle enforcement (temporary)

Time limit:
- 4 minutes

Task:
Set permissive and return to enforcing.

Do:

    getenforce > before-enforce.txt 2>/dev/null || echo "no SELinux" > before-enforce.txt
    sudo setenforce 0 2>/dev/null || true
    getenforce > during-enforce.txt 2>/dev/null || true
    sudo setenforce 1 2>/dev/null || true
    getenforce > after-enforce.txt 2>/dev/null || true

-------------------------------------------------------------------------------

## P10-11 — Prove MAC vs DAC difference

Time limit:
- 5 minutes

Task:
Show permissions and context of file.

Do:

    ls -l /var/www/p10test/index.html > dac.txt
    ls -Z /var/www/p10test/index.html > mac.txt 2>/dev/null || echo "no SELinux" > mac.txt

-------------------------------------------------------------------------------

## P10-12 — Cleanup

Time limit:
- 4 minutes

Task:
Remove lab artifacts.

Do:

    sudo rm -rf /var/www/p10test
    echo OK > cleanup.txt

---

## 🏁 Phase 10 Pass Criteria

You can:

- identify MAC system and mode
- inspect file and process contexts
- diagnose “permissions look right but it fails”
- restore correct labels
- create persistent labeling rules
- find denial logs
- safely toggle enforcement for diagnosis

---

## 🔒 Phase 10 Law

If chmod doesn’t fix it, **it’s not a permissions problem**.

---

