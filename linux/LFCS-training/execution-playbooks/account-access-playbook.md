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
- Permissions, ownership, ACLs, or path traversal prevent access

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/users-and-permissions.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/security-and-selinux.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`
- `linux/LFCS-training/execution-drills/files-ownership-permissions-links-acl.md`

Related playbooks (cross-routes, not duplicates):

- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (DAC vs MAC classification authority)
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if home paths or mounts are missing/RO)

Related scenarios (practice inputs):

- `linux/LFCS-training/failure-scenarios/scenario-7-cant-ssh-lost-access.md` (primary)
- `linux/LFCS-training/failure-scenarios/scenario-8-dns-resolution-failing.md` (secondary, when SSH by hostname fails)
- `linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md` (secondary, when MAC/DAC blocks sshd or home dirs)

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
- **Use `visudo` for sudoers** (prefer `/etc/sudoers.d/` + validation).
- **Every action requires verification.**
- **Classify DAC vs MAC early** (route to `security-triage-playbook.md` when needed).

---

## 0) Inputs

You must know or determine:

- Username
- Access method:
  - console
  - SSH
  - sudo
- What used to work vs what fails now
- Whether the system storage state is healthy (home dirs mounted, not read-only)

Fast storage sanity check (do not deep-dive here):

    findmnt / /home 2>/dev/null || true
    mount | grep -E " on / | on /home " || true
    df -h / /home 2>/dev/null || true

Decision gate:
- If `/home` is missing, wrong, or read-only → exit to `storage-recovery-playbook.md`

---

## 1) Identify Failure Mode

Attempt login or sudo and observe the exact error:

- “Permission denied”
- “Account locked”
- “Authentication failure”
- “This account is currently not available”
- “sudo: user is not in the sudoers file”
- “Could not chdir to home directory … Permission denied”

Branch:

- If **cannot log in at all** → go to **Section 2**
- If **can log in but no sudo** → go to **Section 5**
- If **SSH only fails** → go to **Section 7**
- If **root access lost** → go to **Section 6**
- If the symptom is **Permission denied / home dir / .ssh** → go to **Section 8 (Permissions / Ownership / ACL Gate)**

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

If account looks normal → continue to **Section 8** to test access (and catch permission/ACL blocks).

---

## 3) Unlock or Unexpire Account

Unlock:

    passwd -u <user>

Set new password:

    passwd <user>

Remove expiry:

    chage -E -1 <user>

Return to **Section 9 (Verify Access)**.

---

## 4) Fix Shell or Home Directory

Fix shell:

    chsh -s /bin/bash <user>

Check home directory path from passwd:

    getent passwd <user> | cut -d: -f6

Inspect it:

    ls -ld /home/<user> || true

If missing:

    mkdir -p /home/<user>
    chown <user>:<user> /home/<user>
    chmod 700 /home/<user>

Return to **Section 9 (Verify Access)**.

---

## 5) Fix sudo Access

### 5.1 Identify the correct admin group

Check what exists:

    getent group sudo 2>/dev/null || true
    getent group wheel 2>/dev/null || true

Decision:
- If `sudo` group exists → prefer it
- Else if `wheel` exists → use it
- Else → use sudoers.d entry

### 5.2 Group-based fix (preferred)

    usermod -aG sudo <user> 2>/dev/null || true
    usermod -aG wheel <user> 2>/dev/null || true

Verify:

    groups <user>

Return to **Section 9 (Verify Access)**.

### 5.3 sudoers fix (when required)

Create a drop-in:

    visudo -f /etc/sudoers.d/<user>

Add:

    <user> ALL=(ALL) ALL

Validate:

    visudo -cf /etc/sudoers
    visudo -cf /etc/sudoers.d/<user>

Return to **Section 9 (Verify Access)**.

---

## 6) Root Access Lost (Emergency Path)

Boot to single-user / recovery mode.

Remount root read-write:

    mount -o remount,rw /

Then perform one of:

- Reset root password
- Fix sudoers via `visudo`
- Unlock the required account
- Fix broken home dir ownership/modes (Section 8)

Then reboot.

---

## 7) SSH-Specific Failure

Check SSH service:

    systemctl status sshd --no-pager || systemctl status ssh --no-pager

Check config syntax:

    sshd -t

If connecting by hostname, confirm DNS first (or temporarily try by IP):

    getent hosts <hostname>

Check relevant settings:

    grep -nE "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AllowUsers|AllowGroups|Match" /etc/ssh/sshd_config

If SSH fails with “Permission denied” or key auth fails, do the **permissions gate** for `.ssh`:

- Go to **Section 8**, then return here.

After corrections, restart SSH:

    systemctl restart sshd 2>/dev/null || systemctl restart ssh

Return to **Section 9 (Verify Access)**.

---

## 8) Permissions / Ownership / ACL Gate (Operator-Grade)

Use this gate when:
- login fails with “Permission denied”
- home directory cannot be entered
- `.ssh` key auth fails unexpectedly
- a service-like user cannot read/write its expected home/data path

### 8.1 Classify early: DAC vs MAC

Check SELinux mode and denials:

    getenforce 2>/dev/null || true
    ausearch -m avc -ts recent 2>/dev/null || true

Decision gate:
- If SELinux is Enforcing/Permissive AND AVC denials appear → exit to `security-triage-playbook.md`
- Otherwise proceed with DAC checks below

### 8.2 Identify the *actual* home directory and path traversal

Get home directory from NSS:

    home_dir="$(getent passwd <user> | cut -d: -f6)"
    echo "$home_dir"

Inspect traversal permissions across the path:

    namei -l "$home_dir"

Decision gate:
- If any parent directory lacks execute (`x`) for the actor (user or group) → fix the minimal missing execute bit(s)
- If home dir does not exist or is on missing mount → exit to `storage-recovery-playbook.md`

### 8.3 Verify ownership and mode on home directory

Inspect:

    ls -ld "$home_dir"
    stat "$home_dir"

Typical safe baseline (interactive user home):
- owner: `<user>`
- group: `<user>` (or a consistent primary group)
- mode: `700` or `750` depending on policy

Minimal corrections:

    chown <user>:<user> "$home_dir"
    chmod 700 "$home_dir"

Re-test:

    su - <user>

### 8.4 Detect and correct ACL surprises

If `ls -l` shows `+` or you suspect ACLs:

    getfacl "$home_dir" | sed -n '1,120p'
    getfacl "$home_dir/.ssh" 2>/dev/null | sed -n '1,120p' || true

Decision gate:
- If ACL blocks traversal or read access → remove/adjust minimally (do not broad-grant)

Remove ACLs (only when you intentionally want to revert to classic DAC):

    setfacl -b "$home_dir"
    setfacl -b "$home_dir/.ssh" 2>/dev/null || true

Re-verify:

    getfacl "$home_dir" | sed -n '1,80p'
    ls -ld "$home_dir"

### 8.5 SSH key auth permissions (.ssh and authorized_keys)

Inspect:

    ls -ld "$home_dir"
    ls -ld "$home_dir/.ssh" 2>/dev/null || true
    ls -l  "$home_dir/.ssh/authorized_keys" 2>/dev/null || true

Required baseline (for OpenSSH strict modes):
- `$home_dir` not group/world writable
- `.ssh` = `700`
- `authorized_keys` = `600`
- ownership = `<user>:<user>` for `.ssh` subtree

Fix:

    mkdir -p "$home_dir/.ssh"
    chown -R <user>:<user> "$home_dir/.ssh"
    chmod 700 "$home_dir/.ssh"
    chmod 600 "$home_dir/.ssh/authorized_keys" 2>/dev/null || true

If the issue is still present and SELinux exists, exit to:
- `security-triage-playbook.md` (labeling via `restorecon` etc.)

Return to **Section 9 (Verify Access)**.

---

## 9) Verify Access

Test (choose what applies):

    su - <user>
    sudo -l
    ssh <user>@localhost

If SSH involves hostname resolution:

    getent hosts <hostname>

If all required paths work:
- Proceed to **Section 10**

If not:
- Return to the relevant section (2/5/7/8) or route to another playbook.

---

## 10) Persistence Check

Confirm:

    getent passwd <user>
    passwd -S <user>
    groups <user>
    ls -ld /home/<user> 2>/dev/null || true

Ensure:

- No temporary hacks remain
- No unsafe sudoers changes remain
- No insecure permission changes remain
- SELinux (if present) is enforcing and contexts are correct (via `security-triage-playbook.md`)

---

## 🔁 Rollback Strategy

If sudoers is broken:

- Use recovery shell
- Validate:

    visudo -cf /etc/sudoers

Then fix with:

    visudo

Restore from backup if needed.

If SSH config breaks access:

- Revert config
- Restart sshd

If you over-loosened permissions:

- Restore minimal baseline:
  - home: `700`
  - `.ssh`: `700`
  - `authorized_keys`: `600`

---

## ✅ Completion Criteria

- User can log in
- User can sudo (if intended)
- SSH works (if required)
- Account is not locked or expired
- Home directory and shell are valid
- No excess permissions/ACLs remain

You can explain:

- What blocked access (account state vs sudo vs SSH vs DAC vs MAC)
- Why it blocked access
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Never lock yourself out of root
- Always keep one working root path
- Always test in a second session if possible
- Never hand-edit sudoers without `visudo`
- Always classify DAC vs MAC before mixing fixes

---

## 🧱 This Playbook Composes From

- users-and-permissions.md
- files-and-text.md
- security-and-selinux.md
- essential-commands.md
- files-ownership-permissions-links-acl.md

This is a **composition layer**, not a source of primitives.

---

