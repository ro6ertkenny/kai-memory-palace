# 🔒 SELinux Denials — Domain Playbook

Mental mode: Prove, confirm, fix labels, restore enforcement, move on.

This playbook is used when:

- A service will not start
- A process cannot read/write a file
- You see `Permission denied`
- And Unix permissions / ownership look correct

---

## 🎯 Objective

1) Determine whether SELinux is involved
2) Prove it
3) Fix the cause (usually labels)
4) Restore enforcing mode
5) Verify service or operation works

No guessing. No permanent disabling.

---

## 🧠 Core Model

Access is allowed only if:

- Unix permissions allow it
- AND SELinux policy allows it

Either layer can deny.

---

## 🧪 Entry Conditions (When To Use This Playbook)

- Service fails to start or crashes immediately
- Logs show `permission denied`
- File ownership and modes appear correct
- Or a container/process cannot access a path that “should work”

---

## 🔎 Step 1 — Check SELinux State

    getenforce

If result is:

- Enforcing → continue
- Permissive or Disabled → SELinux is not blocking (use other playbooks)

---

## 🧯 Step 2 — Prove SELinux Is The Cause (Diagnostic Only)

    sudo setenforce 0
    # retry the failing operation or start the service
    sudo setenforce 1

If the problem **disappears** when permissive:

> SELinux is confirmed as the cause.

If nothing changes:

> SELinux is not the cause. Exit this playbook.

---

## 🔍 Step 3 — Inspect Contexts

Check the affected path:

    ls -Z /path
    ls -Zd /path

Optionally inspect the process:

    ps -eZ | head

You are looking for:

- Unexpected or obviously wrong labels
- Files copied into places they “don’t belong”

---

## 🛠️ Step 4 — The 90% Fix: Restore Default Labels

    sudo restorecon -Rv /path

Common targets:

    sudo restorecon -Rv /var/www
    sudo restorecon -Rv /var/lib/<service>
    sudo restorecon -Rv /etc/<service>

This resets labels to what the system expects for that path.

---

## 🧪 Step 5 — Re-test

- Restart the service
- Or re-run the failing command

If it works:

> You are done.

---

## 🧾 Step 6 — If It Still Fails (Evidence Collection)

Collect denial evidence:

    sudo ausearch -m avc -ts recent
    sudo journalctl -t setroubleshoot --since "10 min ago" || true

At LFCS level, this usually still points to:

- Wrong file location
- Wrong label
- Or missing restorecon on a tree

---

## ⛔ Operator Rules

- `setenforce 0` is **never** the final fix.
- Do not leave SELinux disabled.
- Fix labels, then verify in enforcing mode.
- If labels look correct and it still fails, escalate to deeper analysis (outside LFCS scope).

---

## 🔁 Exit Criteria

- SELinux is back in enforcing mode:

      getenforce

- Service or operation works correctly
- No remaining denials in logs

---

## 🔗 Related Playbooks / Docs

- Service will not start
- Permission denied but perms look correct
- Container cannot access mounted files
- SELinux operator basics (foundations)

