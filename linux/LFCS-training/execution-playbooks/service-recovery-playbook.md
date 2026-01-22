# 🛠️ Service Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
**Purpose:** Restore a Linux service to a **running, healthy, and persistent** state using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- A service is reported **down**
- A service **fails to start** or **crashes**
- A service is **running but not reachable**
- A service **starts but exits immediately**
- A service **fails after config changes**

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- `linux/LFCS-training/failure-scenarios/scenario-c-service-is-down.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Identify**
2. **Observe**
3. **Diagnose**
4. **Correct**
5. **Verify**
6. **Make persistent**
7. **Rollback if needed**

Never jump straight to editing files.

---

## 0) Inputs

You must know or be given:

- Service name (e.g. `nginx`, `sshd`, `httpd`, `crond`)
- Expected behavior:
  - Should it be running?
  - Should it be listening on a port?
  - Should it be enabled at boot?

---

## 1) Identify Service State

Check service status:

    systemctl status <service>

Branch:

- If **active (running)** → go to **Section 2**
- If **inactive / failed** → go to **Section 3**
- If **not found** → go to **Section 8**

---

## 2) Service Is Running But “Not Working”

Check if process exists:

    ps aux | grep <service>

Check if listening on expected port:

    ss -lntup
    ss -lntup | grep <port>

Check connectivity:

    curl localhost
    curl localhost:<port>

Branch:

- If **process missing** → go to **Section 3**
- If **process present but not listening** → go to **Section 4**
- If **listening but unreachable** → go to **Section 5**
- If **everything looks fine** → problem is likely **outside this host**

---

## 3) Service Is Stopped or Failed

Attempt manual start:

    systemctl start <service>

Re-check status:

    systemctl status <service>

Branch:

- If **starts successfully** → go to **Section 6**
- If **fails** → go to **Section 4**

---

## 4) Inspect Logs and Failure Reason

Check journal:

    journalctl -u <service> --no-pager -n 50

If config-related service:

    <service-binary> -t
    nginx -t
    httpd -t
    named-checkconf

Branch:

- If **config error** → go to **Section 7**
- If **permission denied** → go to **Section 9**
- If **port bind error** → go to **Section 10**
- If **binary missing / broken** → go to **Section 11**
- If **unknown crash** → continue log inspection and re-run start

---

## 5) Service Is Running But Network Fails

Check firewall:

    iptables -L
    nft list ruleset

Check listening address:

    ss -lntup

Check SELinux (if applicable):

    getenforce
    ausearch -m avc -ts recent

Branch:

- If **blocked by firewall** → fix rules → go to **Section 6**
- If **SELinux denial** → go to **Section 9**
- If **bound only to 127.0.0.1** → fix config → go to **Section 7**

---

## 6) Verify Functional Recovery

Confirm:

    systemctl status <service>
    ss -lntup | grep <port>
    curl localhost:<port>

If all OK:

- Proceed to **Section 12**

If not OK:

- Return to **Section 4**

---

## 7) Fix Configuration Errors

Edit config:

    vi /etc/<service>/<config>

Validate:

    <service-binary> -t

Restart:

    systemctl restart <service>

Return to **Section 6**

---

## 8) Service Not Found

Check package:

    rpm -q <service>
    dpkg -l | grep <service>

If missing:

    apt-get install <package>
    dnf install <package>

Then:

- Return to **Section 3**

---

## 9) Permission or SELinux Issue

Check file permissions:

    ls -l /path/to/files

Check contexts:

    ls -Z /path/to/files

Check denials:

    ausearch -m avc -ts recent

If needed:

    restorecon -Rv /path
    setenforce 0   (TEMPORARY TEST ONLY)

Then:

- Retry start → return to **Section 3**

---

## 10) Port Already In Use

Find offender:

    ss -lntup | grep <port>

Decide:

- Kill conflicting process
- Or change service port

Then:

- Restart service → return to **Section 6**

---

## 11) Broken Binary or Dependency

Check binary:

    which <service-binary>
    ldd <service-binary>

Reinstall:

    apt-get --reinstall install <package>
    dnf reinstall <package>

Then:

- Return to **Section 3**

---

## 12) Persistence Check

Ensure enabled:

    systemctl is-enabled <service>
    systemctl enable <service>

Reboot safety (if allowed):

    systemctl reboot

After reboot:

    systemctl status <service>

---

## 🔁 Rollback Strategy

If a config change caused failure:

- Restore from backup:

    cp /etc/<service>/<config>.bak /etc/<service>/<config>

- Restart:

    systemctl restart <service>

- Re-verify → Section 6

---

## ✅ Completion Criteria

- Service is **active (running)**
- Service is **reachable**
- Service is **enabled at boot**
- No active errors in:

    journalctl -u <service>

---

## 🧠 Exam Safety Rules

- Never reboot unless explicitly safe
- Never disable SELinux permanently
- Always verify after each change
- Always prefer **observe → diagnose → fix → verify**

---

## 🧱 This Playbook Composes From

- services-and-logging.md
- service-configuration.md
- processes-logs-and-scheduling.md
- networking.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

