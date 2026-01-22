# 🔐 Account Access Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/account-access-playbook.md`  
**Purpose:** Restore **legitimate user access** (login, sudo, SSH) using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- User **cannot log in**
- **Root or sudo** access is broken
- **SSH access** fails
- Account is **locked / expired**
- Permissions or ownership prevent access

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- (Future) no-access / broken-auth scenario

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Identify access path**
2. **Observe failure mode**
3. **Verify account state**
4. **Verify auth mechanism**
5. **Correct**
6. **Verify**
7. **Make persistent**
8. **Rollback if needed**

Never start by editing config blindly.

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

Attempt login or sudo and observe:

- “Permission denied”
- “Account locked”
- “Authentication failure”
- “This account is currently not available”
- “sudo: user is not in the sudoers file”

Branch:

- If **cannot log in at all** → go to **Section 2**
- If **can log in but no sudo** → go to **Section 5**
- If **SSH only fails** → go to **Section 7**

---

## 2) Verify Account Exists and Is Usable

Check:

    getent passwd <user>

Check shell:

    getent passwd <user> | cut -d: -f7

If shell is:

- `/sbin/nologin` or `/bin/false` → fix shell → go to **Section 4**

Check lock / expiry:

    passwd -S <user>
    chage -l <user>

If locked or expired → go to **Section 3**

---

## 3) Unlock or Unexpire Account

Unlock:

    passwd -u <user>

Set new password:

    passwd <user>

Check expiry:

    chage -E -1 <user>

Return to **Section 8**

---

## 4) Fix Shell or Home Directory

Fix shell:

    chsh -s /bin/bash <user>

Check home:

    ls -ld /home/<user>

If missing:

    mkdir /home/<user>
    chown <user>:<user> /home/<user>
    chmod 700 /home/<user>

Return to **Section 8**

---

## 5) Fix sudo Access

Check groups:

    groups <user>

Check sudoers:

    getent group sudo
    getent group wheel

Add user to group:

    usermod -aG sudo <user>
    usermod -aG wheel <user>

Or via visudo:

    visudo

Add line:

    <user> ALL=(ALL) ALL

Return to **Section 8**

---

## 6) Root Access Lost (Emergency)

Boot to single-user / recovery mode.

Remount root RW:

    mount -o remount,rw /

Then:

- Reset root password
- Or fix sudoers
- Or unlock account

Then reboot.

---

## 7) SSH-Specific Failure

Check SSH service:

    systemctl status sshd

Check config:

    sshd -t

Check:

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

Return to **Section 8**

---

## 8) Verify Access

Test:

    su - <user>
    sudo -l
    ssh <user>@localhost

If all work:

- Proceed to **Section 9**

If not:

- Return to relevant section

---

## 9) Persistence Check

Confirm:

    getent passwd <user>
    passwd -S <user>
    groups <user>

Ensure no temporary hacks remain.

---

## 🔁 Rollback Strategy

If sudoers broken:

- Use recovery shell
- Run:

    visudo

Restore from backup if needed.

If SSH broken:

- Revert config
- Restart sshd

---

## ✅ Completion Criteria

- User can log in
- User can sudo (if intended)
- SSH works (if required)
- Account is not locked or expired
- Home and shell are valid

---

## 🧠 Exam Safety Rules

- Never lock yourself out of root
- Always keep one working root path
- Always test in a second session if possible
- Never hand-edit sudoers without visudo

---

## 🧱 This Playbook Composes From

- users-and-permissions.md
- files-and-text.md
- security-and-selinux.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

