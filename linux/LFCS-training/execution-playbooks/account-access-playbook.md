# 🔐 Account Access Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/account-access-playbook.md`  
**Purpose:** Restore **legitimate user access** (login, sudo, SSH) using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- User **cannot log in**
- **Root or sudo** access is broken
- **SSH access** fails
- Account is **locked / expired**
- Permissions or ownership prevent access

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- (Future) no-access / broken-auth scenario

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Identify access path**
2. **Observe failure mode**
3. **Verify account state**
4. **Verify auth mechanism**
5. **Apply minimal correction**
6. **Verify**
7. **Make persistent**
8. **Rollback if needed**

Never start by editing config blindly.

---

## 🧭 Global Safety Rules

- **Never lock yourself out of root.**
- **Always keep one recovery path available.**
- **Prefer minimal, reversible changes.**
- **Use `visudo` for sudoers.**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Username
- Access method:
  - console
  - SSH
  - sudo
- What *used to* work vs what fails now

---

## 1) Identify Failure Mode

Attempt login or sudo and observe the exact error:

- “Permission denied”
- “Account locked”
- “Authentication failure”
- “This account is currently not available”
- “sudo: user is not in the sudoers file”

Branch:

- If **cannot log in at all** → go to **Section 2**
- If **can log in but no sudo** → go to **Section 5**
- If **SSH only fails** → go to **Section 7**
- If **root access lost** → go to **Section 6**

---

## 2) Verify Account Exists and Is Usable

Check existence:

    getent passwd <user>

Check login shell:

    getent passwd <user> | cut -d: -f7

If shell is:

- `/sbin/nologin` or `/bin/false` → fix shell → go to **Section 4**

Check lock / expiry:

    passwd -S <user>
    chage -l <user>

If locked or expired → go to **Section 3**

If account looks normal → continue to **Section 8** to test access.

---

## 3) Unlock or Unexpire Account

Unlock:

    passwd -u <user>

Set new password:

    passwd <user>

Remove expiry:

    chage -E -1 <user>

Return to **Section 8**.

---

## 4) Fix Shell or Home Directory

Fix shell:

    chsh -s /bin/bash <user>

Check home directory:

    ls -ld /home/<user>

If missing:

    mkdir /home/<user>
    chown <user>:<user> /home/<user>
    chmod 700 /home/<user>

Return to **Section 8**.

---

## 5) Fix sudo Access

Check groups:

    groups <user>

Check sudo groups:

    getent group sudo
    getent group wheel

Add user to appropriate group:

    usermod -aG sudo <user>
    usermod -aG wheel <user>

Or edit sudoers safely:

    visudo

Add line if required:

    <user> ALL=(ALL) ALL

Return to **Section 8**.

---

## 6) Root Access Lost (Emergency Path)

Boot to single-user / recovery mode.

Remount root read-write:

    mount -o remount,rw /

Then perform one of:

- Reset root password
- Fix sudoers via `visudo`
- Unlock the required account

Then reboot.

---

## 7) SSH-Specific Failure

Check SSH service:

    systemctl status sshd --no-pager

Check config syntax:

    sshd -t

Check relevant settings:

    grep -E "PermitRootLogin|PasswordAuthentication" /etc/ssh/sshd_config

Check permissions:

    ls -ld /home/<user>
    ls -ld /home/<user>/.ssh
    ls -l /home/<user>/.ssh/authorized_keys

Fix:

    chmod 700 /home/<user>/.ssh
    chmod 600 /home/<user>/.ssh/authorized_keys
    chown -R <user>:<user> /home/<user>/.ssh

Restart SSH:

    systemctl restart sshd

Return to **Section 8**.

---

## 8) Verify Access

Test:

    su - <user>
    sudo -l
    ssh <user>@localhost

If all required paths work:

- Proceed to **Section 9**

If not:

- Return to the relevant section.

---

## 9) Persistence Check

Confirm:

    getent passwd <user>
    passwd -S <user>
    groups <user>

Ensure:

- No temporary hacks remain
- No unsafe sudoers changes remain
- No insecure permission changes remain

---

## 🔁 Rollback Strategy

If sudoers is broken:

- Use recovery shell
- Run:

    visudo

Restore from backup if needed.

If SSH config breaks access:

- Revert config
- Restart sshd

---

## ✅ Completion Criteria

- User can log in
- User can sudo (if intended)
- SSH works (if required)
- Account is not locked or expired
- Home directory and shell are valid

You can explain:

- What blocked access
- Why it blocked access
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Never lock yourself out of root
- Always keep one working root path
- Always test in a second session if possible
- Never hand-edit sudoers without `visudo`

---

## 🧱 This Playbook Composes From

- users-and-permissions.md
- files-and-text.md
- security-and-selinux.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
