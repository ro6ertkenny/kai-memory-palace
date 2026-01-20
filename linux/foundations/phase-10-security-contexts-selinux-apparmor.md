# 🔐 Phase 10 — Security Contexts, MAC (SELinux/AppArmor), and Privilege Boundaries
*LFCS safety layer: even root should be constrained, and labels matter.*

---

## 📌 Purpose

This phase makes you **competent with Mandatory Access Control (MAC)** and security boundaries:

- Inspecting SELinux/AppArmor status
- Understanding security contexts (labels)
- Fixing broken access caused by wrong labels
- Temporarily changing contexts vs restoring defaults
- Knowing when DAC (permissions) is not the problem
- Safely toggling enforcement modes

Many LFCS tasks look like:

> “Permissions are correct, but it still can’t access.”  
> “Fix it without disabling security.”  

---

## 🧠 Mental Model

There are **two layers** of access control:

1) **DAC** (Discretionary Access Control)  
   - Classic: owner/group/other, ACLs

2) **MAC** (Mandatory Access Control)  
   - SELinux or AppArmor
   - Enforces **policy + labels**
   - Even root is constrained

If SELinux/AppArmor denies access, **chmod will not fix it**.

---

# 🧭 Part A — Determine What Is In Use

SELinux status:

    getenforce
    sestatus

AppArmor status (if applicable):

    sudo aa-status

Interpret SELinux modes:

- Enforcing  → policy is enforced
- Permissive → policy logs but does not block
- Disabled   → MAC off

---

# 🏷️ Part B — Inspect Contexts (SELinux)

View context of file:

    ls -Z /var/www/index.html

View context of process:

    ps auxZ | grep sshd

Typical context format:

    system_u:system_r:httpd_t:s0

Meaning:

    user:role:type:level

The **type** is usually what matters most (e.g., httpd_t).

---

# 🔁 Part C — Fixing Context Problems (Correct Way)

Restore default context:

    sudo restorecon -Rv /var/www/

Restore single file:

    sudo restorecon /var/www/index.html

This is the **preferred fix** if labels drifted.

---

# ✏️ Part D — Temporary Context Change (Not Persistent)

Change type temporarily:

    sudo chcon -t httpd_sys_content_t /var/www/index.html

⚠️ This will be lost if relabeled or restored.

---

# 🧱 Part E — Persistent Context Rules

Add rule:

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"

Apply:

    sudo restorecon -Rv /var/www/

List rules:

    sudo semanage fcontext -l

---

# 🚦 Part F — Toggle Enforcement (For Debug Only)

Set permissive:

    sudo setenforce 0

Set enforcing:

    sudo setenforce 1

Persist change:

    sudo vi /etc/selinux/config

    SELINUX=enforcing
    SELINUX=permissive
    SELINUX=disabled

---

# 🔍 Part G — Find Denials

Check audit logs:

    sudo ausearch -m avc
    sudo journalctl -t setroubleshoot

Live view:

    sudo journalctl -f

---

# 🧪 Part H — Common Service Types

Web content:

    httpd_sys_content_t

SSH:

    sshd_t

System binaries:

    bin_t

Check:

    ls -Z /bin/sudo

---

# 🧪 Canonical Exam Scenarios

Check SELinux mode and save to file:

    getenforce > /opt/selinuxmode.txt

Check context of binary:

    ls -Z /usr/bin/less

Fix broken web access:

    sudo restorecon -Rv /var/www/

Temporarily disable enforcement (debug):

    sudo setenforce 0

Set persistent rule for /var/www:

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"
    sudo restorecon -Rv /var/www/

---

## ⚠️ Failure Modes

- Trying to fix MAC issues with chmod/chown
- Leaving system in permissive or disabled mode
- Using chcon instead of semanage + restorecon
- Not checking logs for AVC denials
- Breaking labels by copying files incorrectly

---

## 🏁 Phase 10 Mastery Checklist

You must be able to:

- Check SELinux/AppArmor status
- Interpret security contexts
- Diagnose “permissions look right but access denied”
- Restore correct contexts
- Apply persistent context rules
- Toggle enforcement safely for debugging
- Verify contexts of files and processes

---

## 🔒 Exam Law

> **If you don’t understand MAC, you will misdiagnose real failures and make systems less secure while “fixing” them.**

---

