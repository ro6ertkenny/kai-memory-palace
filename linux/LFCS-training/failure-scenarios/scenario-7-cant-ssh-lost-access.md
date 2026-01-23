# ❗ Scenario 7 — Can’t SSH / Lost Access (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-7-cant-ssh-lost-access.md`  
Mental mode: **Pressure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/account-access-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md`
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md` (rare; only if you discover TLS/SSH CA or cert integration)

---

## 📌 Incident Brief (Symptom-First)

You attempt to SSH into a host that you are responsible for:

- `ssh user@server`

You get one of these outcomes:

- **Timeout / hangs**
- **Connection refused**
- **No route to host**
- **Permission denied (publickey)**
- **Permission denied (password)**
- **Disconnected / too many authentication failures**
- **Host key verification failed**

You must restore access safely and prove the system is healthy.

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Re-establish reliable admin access (SSH or emergency console path)
- Explain the failure class (network vs service vs auth vs policy vs resource)
- Show evidence that supports your classification
- Apply the correct recovery (minimal changes)
- Verify:
  - sshd is healthy
  - access is stable
  - the root cause is addressed (not just masked)
- Ensure persistence (if the fix must survive reboot) or rollback if change was unsafe

---

## 🧭 First Decision: Do You Have Any Access Path?

### A) You still have local access (console / VM console / physical)
Proceed with **local diagnosis** and restore remote access.

### B) You have no local access (pure remote)
Treat this as **remote-only triage**:
- classify from client-side signals first
- gather evidence from network reachability
- escalate to out-of-band access if required (in real ops)
For LFCS practice, assume you can gain console access via the lab environment if needed.

---

## 🧠 Classification Matrix (Use This Before Touching Anything)

You must classify the failure into one of these buckets:

1) **Network path failure**
2) **Port blocked**
3) **sshd service failure**
4) **Authentication failure**
5) **Policy denial**
6) **Resource collapse**
7) **Trust / identity mismatch**

Route to the correct playbook based on the bucket.

---

## 🧪 Evidence You Are Allowed to Collect (Client Side)

Collect **at least one** hard signal before acting.

  nslookup server || true
  getent hosts server || true
  ping -c 2 server || true
  ssh -vvv user@server
  nc -vz server 22 || true

Record:
- What IP you actually reached
- Whether TCP/22 is reachable
- The SSH error class (timeout vs refused vs auth vs host key)

---

## 🧩 Local Evidence (If You Have Console)

  ss -lntp | rg ':22\b' || true
  systemctl status sshd --no-pager || systemctl status ssh --no-pager
  journalctl -u sshd -b --no-pager | tail -n 200 || true
  journalctl -u ssh -b --no-pager | tail -n 200 || true

  df -h
  df -i
  free -h
  dmesg -T | tail -n 200

  sestatus || true
  sudo ausearch -m avc -ts recent || true

---

## 🧯 Scenario Setup (Training Injection Options)

Pick **one** variant per run.

### Variant 7.1 — Port 22 filtered
### Variant 7.2 — sshd down or misconfigured
### Variant 7.3 — Authentication / account locked
### Variant 7.4 — Host key mismatch
### Variant 7.5 — Resource collapse breaks SSH

(Details intentionally omitted here to preserve diagnostic pressure.)

---

## 🧭 Required Workflow

1) Classify from **client signal**
2) Choose the **correct playbook immediately**
3) Execute **minimal recovery**
4) Prove health
5) Ensure persistence or rollback unsafe change

---

## ✅ Verification Checklist

From server:

  systemctl is-active sshd || systemctl is-active ssh
  ss -lntp | rg ':22\b'

From client:

  ssh -o ConnectTimeout=5 user@server 'id; uptime; whoami'

---

## 🧾 Post-Incident Debrief

Answer:

- What was the first reliable signal?
- What class of failure was it?
- Which playbook did you choose and why?
- What was the minimal fix?
- What would prevent recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Blindly editing sshd_config
- Disabling firewall or SELinux first
- Deleting known_hosts without identity verification
- Rebooting before classification
- “Trying fixes” without evidence

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** you have restored access and proved system health.

Do **not** use this section while solving the incident.

### If this failure was primarily about reachability or ports:
- Review drill:
  - `linux/LFCS-training/execution-drills/networking.md`
- Review building block:
  - `linux/LFCS-training/training-progression/building-block-8-networking.md`

### If this failure was primarily about services or sshd:
- Review drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Review building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If this failure was primarily about authentication or accounts:
- Review drill:
  - `linux/LFCS-training/execution-drills/users-and-permissions.md`
- Review building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If this failure involved SELinux or security policy:
- Review drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Review building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If this failure was caused by resource exhaustion:
- Review drill:
  - `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- Review building block:
  - `linux/LFCS-training/training-progression/building-block-11-storage-recovery.md`

Purpose of this section:
- Close skill gaps exposed by the incident
- Reinforce the mental model you misapplied
- Prevent recurrence

---
