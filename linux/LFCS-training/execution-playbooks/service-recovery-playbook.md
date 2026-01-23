# 🛠️ Service Recovery Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`  
Mental mode: **Classify → Inspect → Fix → Verify → Persist**  
Purpose: Restore a Linux service to a **running, healthy, and persistent** state using a **safe, exam-grade operator algorithm**.

This is **not** a tutorial.  
This is a **live-system decision and recovery playbook**.

---

## 🧠 When To Use This Playbook

Use this playbook when:

- A service is reported **down**
- A service **fails to start** or **crashes**
- A service **starts but exits immediately**
- A service is **running but not reachable**
- A service fails after **configuration changes**
- A service is blocking **boot or other services**

Do **not** use this playbook if the **first evidence** points to:

- disk, mount, or I/O failure → `storage-recovery-playbook.md`
- process runaway or storm → `process-control-playbook.md`
- network or DNS root cause → `network-diagnosis-playbook.md`
- SELinux or policy root cause → `security-triage-playbook.md`

---

## 🧭 Scenarios That Validate This Playbook

This playbook is exercised by:

- `linux/LFCS-training/failure-scenarios/scenario-3-service-is-down.md`
- `linux/LFCS-training/failure-scenarios/scenario-10-tls-certificate-failure.md`
- `linux/LFCS-training/failure-scenarios/scenario-11-selinux-denial-breaks-service.md`
- `linux/LFCS-training/failure-scenarios/scenario-12-filesystem-wont-mount.md`
- `linux/LFCS-training/failure-scenarios/scenario-13-system-wont-boot.md`

If you cannot solve those scenarios **cleanly and repeatably**, this playbook is not yet fluent.

---

## 🧪 Drills Required For Fluency

You should be mechanically fluent with:

- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

This playbook is a **composition layer**, not a source of primitives.

---

## 🧠 Operator Contract

Always proceed in this order:

1. Identify the service and symptom
2. Observe supervisor state
3. Inspect logs
4. Classify failure
5. Stabilize (minimum safe action)
6. Correct root cause
7. Verify function
8. Make persistent
9. Roll back if needed

> **Never jump straight to editing files or restarting in a loop.**

---

## 🧭 Global Safety Rules

- Preserve evidence first: status and logs before changes.
- Prefer systemd controls over killing PIDs.
- Never loop restarts without new evidence.
- Make the **smallest safe change** first.
- Every action requires verification.

---

## 🧪 Phase 1 — Identify Service State (Supervisor View)

Check authoritative state:

  systemctl status <service> --no-pager  

Branch:

- If **active (running)** → go to **Phase 2**
- If **inactive / failed** → go to **Phase 3**
- If **unit not found** → go to **Phase 8**

---

## 🧪 Phase 2 — Service Is Running But “Not Working”

Confirm binding and basic behavior:

  ss -lntup  
  ss -lntup | grep <port>  

Local test (if applicable):

  curl localhost  
  curl localhost:<port>  

Branch:

- If **no listener** → go to **Phase 4**
- If **listening but unreachable** → go to **Phase 5**
- If **everything works locally** → this is likely **outside this host** → exit playbook

---

## 🧪 Phase 3 — Service Is Stopped or Failed

Attempt controlled start:

  systemctl start <service>  

Re-check:

  systemctl status <service> --no-pager  

Branch:

- If **starts successfully** → go to **Phase 6**
- If **fails** → go to **Phase 4**

---

## 🧪 Phase 4 — Inspect Logs and Failure Reason (Mandatory)

Read recent logs:

  journalctl -u <service> --no-pager -n 80  

If supported, validate configuration:

  <service-binary> -t  
  nginx -t  
  httpd -t  
  named-checkconf  

Classify:

- config / parse error → Phase 7  
- permission / SELinux → Phase 9  
- address already in use → Phase 10  
- binary missing / dependency → Phase 11  
- storage / mount error → exit to `storage-recovery-playbook.md`  
- unknown crash → continue log inspection, do not loop restarts

---

## 🧪 Phase 5 — Service Is Running But Network Fails

Check local binding:

  ss -lntup  

Check firewall (one may exist):

  iptables -L  
  nft list ruleset  

Check SELinux:

  getenforce  
  ausearch -m avc -ts recent || true  

Branch:

- firewall block → fix → Phase 6  
- SELinux denial → Phase 9  
- bound only to 127.0.0.1 → Phase 7  

---

## 🧪 Phase 6 — Verification Gate

Confirm:

  systemctl status <service> --no-pager  
  ss -lntup | grep <port>  
  curl localhost:<port>  

If OK → proceed to **Phase 12**  
If not OK → return to **Phase 4**

---

## 🧪 Phase 7 — Fix Configuration Errors

Edit the correct config file (verify path first):

  vi /etc/<service>/<config>  

Validate:

  <service-binary> -t  

Restart:

  systemctl restart <service>  

Return to **Phase 6**

---

## 🧪 Phase 8 — Service Not Found

Check package presence:

  rpm -q <service>  
  dpkg -l | grep <service>  

If missing:

  apt-get install <package>  
  dnf install <package>  

Return to **Phase 3**

---

## 🧪 Phase 9 — Permission or SELinux Issue

Inspect ownership and modes:

  ls -l /path  

Inspect contexts:

  ls -Z /path  

Check denials:

  ausearch -m avc -ts recent || true  

Preferred fix:

  restorecon -Rv /path  

Temporary diagnostic only:

  setenforce 0  

Then:

- Retry start → Phase 3  
- Re-enable enforcing:

  setenforce 1  

If policy work is required → exit to `security-triage-playbook.md`

---

## 🧪 Phase 10 — Port Already In Use

Find offender:

  ss -lntup | grep <port>  

Decide:

- stop conflicting service/process  
- or change this service’s port → Phase 7  

Then:

- Restart → Phase 6

---

## 🧪 Phase 11 — Broken Binary or Dependency

Check binary and linkages:

  which <service-binary>  
  ldd <service-binary>  

Reinstall:

  apt-get --reinstall install <package>  
  dnf reinstall <package>  

Return to **Phase 3**

---

## 🧪 Phase 12 — Persistence Check

Ensure correct boot behavior:

  systemctl is-enabled <service>  
  systemctl enable <service>  

Reboot test only if safe and allowed:

  reboot  

After reboot:

  systemctl status <service> --no-pager  

---

## 🔁 Rollback Strategy

If a config change caused failure:

  cp /etc/<service>/<config>.bak /etc/<service>/<config>  
  systemctl restart <service>  

Return to **Phase 6**

---

## 🚫 Anti-Patterns (Auto-Fail)

- Restarting in a loop without reading logs
- Editing config before checking logs
- Killing service PIDs instead of using systemd
- Disabling SELinux permanently
- Assuming network problems are always firewall

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

## 🧠 Operator Loop (Reinforced)

Symptom → Identify → Inspect → Classify → Fix → Verify → Persist

Never skip log inspection.

---

## 🧭 Exit Conditions

Exit this playbook if you discover:

- storage or mount failure → `storage-recovery-playbook.md`
- process storm or runaway → `process-control-playbook.md`
- SELinux policy design issue → `security-triage-playbook.md`
- network or DNS root cause → `network-diagnosis-playbook.md`

---
