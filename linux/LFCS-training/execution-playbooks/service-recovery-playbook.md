# 🛠️ Service Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
**Purpose:** Restore a Linux service to a **running, healthy, and persistent** state using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- A service is reported **down**
- A service **fails to start** or **crashes**
- A service is **running but not reachable**
- A service **starts but exits immediately**
- A service **fails after config changes**

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenario (practice input):

- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Identify**
2. **Observe**
3. **Inspect logs**
4. **Classify failure**
5. **Stabilize (minimum safe action)**
6. **Correct root cause**
7. **Verify**
8. **Make persistent**
9. **Rollback if needed**

Never jump straight to editing files.

---

## 🧭 Global Safety Rules

- **Preserve evidence first.** Read status and logs before changing anything.
- **Prefer systemd controls** over killing PIDs.
- **Do not restart in a loop.** Every restart must be preceded by new evidence.
- **Smallest change first.**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Service name (e.g. `nginx`, `sshd`, `httpd`, `crond`)
- Expected behavior:
  - Should it be running?
  - Should it be listening on a port?
  - Should it be enabled at boot?

---

## 1) Identify Service State

Check authoritative state:

    systemctl status <service> --no-pager

Branch:

- If **active (running)** → go to **Section 2**
- If **inactive / failed** → go to **Section 3**
- If **not found** → go to **Section 8**

---

## 2) Service Is Running But “Not Working”

Confirm process and listener:

    ss -lntup
    ss -lntup | grep <port>

Basic local check:

    curl localhost
    curl localhost:<port>

Branch:

- If **no listener** → go to **Section 4**
- If **listening but unreachable** → go to **Section 5**
- If **everything looks correct locally** → problem is likely **outside this host** (stop this playbook)

---

## 3) Service Is Stopped or Failed

Attempt controlled start:

    systemctl start <service>

Re-check:

    systemctl status <service> --no-pager

Branch:

- If **starts successfully** → go to **Section 6**
- If **fails** → go to **Section 4**

---

## 4) Inspect Logs and Failure Reason (Mandatory)

Read recent logs:

    journalctl -u <service> --no-pager -n 80

If the service supports config testing, run it (examples):

    <service-binary> -t
    nginx -t
    httpd -t
    named-checkconf

Classify:

- If **config error / parse error** → go to **Section 7**
- If **permission denied / SELinux** → go to **Section 9**
- If **address already in use / bind error** → go to **Section 10**
- If **binary missing / dependency error** → go to **Section 11**
- If **unknown crash** → continue log inspection, do not loop restarts

---

## 5) Service Is Running But Network Fails

Confirm local policy and binding:

    ss -lntup

Check firewall (one of these may exist):

    iptables -L
    nft list ruleset

Check SELinux state and recent denials (if applicable):

    getenforce
    ausearch -m avc -ts recent

Branch:

- If **blocked by firewall** → fix rules → go to **Section 6**
- If **SELinux denial** → go to **Section 9**
- If **bound only to 127.0.0.1** → fix config → go to **Section 7**

---

## 6) Verify Functional Recovery (Gate)

Confirm:

    systemctl status <service> --no-pager
    ss -lntup | grep <port>
    curl localhost:<port>

If OK:

- Proceed to **Section 12**

If not OK:

- Return to **Section 4** (logs) and re-classify

---

## 7) Fix Configuration Errors

Edit the correct config file (verify path first):

    vi /etc/<service>/<config>

Validate:

    <service-binary> -t

Restart:

    systemctl restart <service>

Return to **Section 6**

---

## 8) Service Not Found

Check package presence:

    rpm -q <service>
    dpkg -l | grep <service>

If missing:

    apt-get install <package>
    dnf install <package>

Then:

- Return to **Section 3**

---

## 9) Permission or SELinux Issue

Inspect file ownership and modes:

    ls -l /path/to/files

Inspect contexts (if applicable):

    ls -Z /path/to/files

Check denials:

    ausearch -m avc -ts recent

Preferred fix:

    restorecon -Rv /path

Temporary diagnostic only (never leave it this way):

    setenforce 0

Then:

- Retry start → return to **Section 3**
- Re-enable enforcing after fix:

    setenforce 1

---

## 10) Port Already In Use

Find offender:

    ss -lntup | grep <port>

Decide:

- Stop the conflicting service/process
- Or change this service’s port (config change → Section 7)

Then:

- Restart service → return to **Section 6**

---

## 11) Broken Binary or Dependency

Check binary and linkages:

    which <service-binary>
    ldd <service-binary>

Reinstall:

    apt-get --reinstall install <package>
    dnf reinstall <package>

Then:

- Return to **Section 3**

---

## 12) Persistence Check

Ensure correct boot behavior:

    systemctl is-enabled <service>
    systemctl enable <service>

Reboot test only if allowed and safe:

    systemctl reboot

After reboot:

    systemctl status <service> --no-pager

---

## 🔁 Rollback Strategy

If a config change caused failure:

- Restore known-good copy:

    cp /etc/<service>/<config>.bak /etc/<service>/<config>

- Restart:

    systemctl restart <service>

- Re-verify → **Section 6**

---

## ✅ Completion Criteria

- Service is **active (running)**
- Service is **reachable**
- Service is **enabled at boot**
- No active errors in:

    journalctl -u <service> --no-pager

You can explain:

- What failed
- Why it failed
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Never reboot unless explicitly safe and necessary
- Never disable SELinux permanently
- Never loop restarts without reading logs
- Always follow: **observe → inspect → fix →

