# 🧠 Scenario 8 — “Permission Denied but Everything Looks Correct”

**Mental mode:** Linux security layers  
**Failure class:** Permissions, ownership, or execution context mismatch  
**Goal:** Systematically find *which* permission layer is blocking access

---

## 🎯 The Symptom

You see errors like:

    Permission denied

But:

- File permissions look correct
- Ownership looks correct
- The path exists
- You are “the right user”
- It *should* work

Common cases:

- Service can’t read a file
- Script can’t execute
- App can’t write to a directory
- Container can’t access a mounted path

---

## 🧠 The Critical Mental Model

> Linux access is a **stack of gates**.  
> You must pass **all of them**.

Possible blockers:

- File permissions (rwx)
- Ownership (user / group)
- Directory **execute** bit
- Parent directory permissions
- SELinux / AppArmor
- Mount flags (ro, noexec, nosuid)
- Capabilities
- Different user context (systemd / container)

---

## 🧪 Phase 1 — Prove the Exact Failing Operation

### 1) Reproduce it directly

Try:

    cat /path/to/file
    touch /path/to/file
    cd /path/to/dir
    ./script.sh

Note:
- Is it read, write, or execute that fails?

---

## 🔍 Phase 2 — Check the Full Path (Not Just the File)

### 1) Inspect the file

    ls -l /path/to/file

Check:
- Owner
- Group
- Permissions

---

### 2) Inspect every parent directory

This is **the most common mistake**.

    namei -l /path/to/file

Or manually:

    ls -ld /path
    ls -ld /path/to
    ls -ld /path/to/dir

Remember:

> To access a file, you need **execute (x)** on every directory in the path.

---

## 🧱 Phase 3 — Check the Actual User Context

### 1) Who are you?

    id

### 2) Who is the service running as?

    systemctl status servicename

Or:

    ps aux | grep servicename

> Root working ≠ service user working.

---

## 🧨 Phase 4 — Check Mount Flags (Sneaky One)

### 1) Check how the filesystem is mounted

    mount | grep /path

Look for:

- ro
- noexec
- nosuid

Examples:

- noexec → binaries and scripts cannot run
- ro → cannot write

---

## 🧯 Phase 5 — Check SELinux / AppArmor (If Present)

### 1) Is SELinux enforcing?

    getenforce

If:

    Enforcing

Check audit logs:

    sudo journalctl -t setroubleshoot
    sudo ausearch -m avc -ts recent

Or:

    sudo dmesg | grep -i denied

> SELinux can deny access **even when permissions look perfect**.

---

## 🧠 Phase 6 — Check Capabilities (Advanced, But Real)

Some operations require capabilities even as root.

Check:

    getcap /path/to/binary

Or:

    capsh --print

---

## 🧩 Phase 7 — The “But It Works in Shell” Trap

If:

- Works in your shell
- Fails in systemd / container / cron

Then:

> You are running in **different user, different cgroup, different mount namespace, or different security context**.

Check:

    systemctl show servicename | grep -i user
    systemctl show servicename | grep -i rootdirectory
    systemctl show servicename | grep -i protect

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| File perms wrong | Simple permission issue | chmod / chown |
| Parent dir missing x | Path traversal blocked | Fix directory perms |
| Works as root only | User mismatch | Fix ownership or service user |
| noexec mount | Exec blocked by mount | Remount or move file |
| SELinux denies | MAC policy block | Fix context or policy |
| Works in shell, not in service | Different execution context | Inspect systemd unit |

---

## ⚠️ Operator Warnings

- chmod 777 is **not** a fix.
- Root working does **not** prove correctness.
- Always ask:

> “Which security layer is denying me?”

---

## 🏁 The Operator Rule

> Permissions are a **stack**, not a single check.

---

## 🧠 One-Sentence Operator Summary

> “When permissions look right but access is denied, walk the entire path, the user context, the mount flags, and the security policy — one of them is blocking you.”

---

## 🧾 The Minimal Proof Commands

    id
    ls -l /path/to/file
    namei -l /path/to/file
    mount | grep /path
    systemctl status servicename
    getenforce
    dmesg | grep -i denied

