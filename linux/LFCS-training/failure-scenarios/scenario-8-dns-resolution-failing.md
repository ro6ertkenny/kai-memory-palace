# 🧯 Scenario 8 — DNS / Name Resolution Is Failing (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-8-dns-resolution-failing.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if firewall/SELinux blocks DNS)
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if local resolver service is broken)

---

## 📌 Incident Brief (Symptom-First)

Users report:

- “The site is down.”
- “`apt` / `dnf` can’t reach mirrors.”
- “Pings by IP work, but names don’t.”
- Applications time out on hostnames.

You suspect **name resolution**.

Your job is to:
- prove whether DNS is actually the failure
- classify **where** the break is (local config, local resolver, upstream, or network)
- route to the correct fix
- restore resolution
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Prove whether **name resolution** is the failure or not
- Classify the failure as:
  - local client config
  - local resolver service
  - upstream DNS reachability
  - firewall/SELinux policy
- Apply the **minimal safe fix**
- Prove:
  - names resolve
  - dependent tools (curl, package manager) work again
  - no hidden policy blocks remain

---

## 🧠 Operator Rule

> **Always test IP connectivity before blaming DNS.**  
> **Never assume “network is down” until you separate routing from resolution.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Not a DNS problem** (routing or general network is broken)
2) **Local resolver config error** (`/etc/resolv.conf`, stub, search domains)
3) **Local resolver service failure** (systemd-resolved, named, dnsmasq, etc.)
4) **Upstream DNS unreachable** (network path, firewall, or provider)
5) **Policy block** (firewall or SELinux preventing DNS)
6) **Partial resolution** (some names work, others don’t)

---

## 🧪 Required Evidence (Separate Routing from Resolution)

First, prove raw IP connectivity:

  ip route
  ping -c 3 1.1.1.1 || true
  ping -c 3 8.8.8.8 || true

Interpretation gate:

- If **IP ping fails** → this is **not a DNS incident**.  
  Route to network diagnosis.

- If **IP ping works** → proceed to test name resolution.

---

## 🧪 Required Evidence (Test Name Resolution)

Test with multiple tools:

  getent hosts example.com || true
  getent hosts google.com || true

  ping -c 3 example.com || true

If available:

  resolvectl status || true
  resolvectl query example.com || true

Or:

  dig example.com || true
  nslookup example.com || true

Interpretation anchors:

- If **all name lookups fail** but IP works → DNS path is broken.
- If **some names work and others don’t** → upstream or domain-specific issue.
- If **tools disagree** → local resolver layer is suspect.

---

## 🧩 Inspect Local Resolver Configuration

Check:

  cat /etc/resolv.conf

If systemd-resolved is used:

  ls -l /etc/resolv.conf
  resolvectl status || true

Interpretation anchors:

- Is `/etc/resolv.conf`:
  - empty?
  - pointing to 127.0.0.53 but the stub isn’t working?
  - pointing to dead or unreachable servers?
- Are there **zero** nameservers?
- Are search domains or options clearly wrong?

---

## 🧭 Check Resolver Service (If Present)

If using systemd-resolved:

  systemctl status systemd-resolved --no-pager || true

If using named/dnsmasq:

  systemctl status named --no-pager || true
  systemctl status dnsmasq --no-pager || true

Check logs:

  journalctl -u systemd-resolved -b --no-pager | tail -n 80 || true
  journalctl -u named -b --no-pager | tail -n 80 || true
  journalctl -u dnsmasq -b --no-pager | tail -n 80 || true

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Not a DNS problem
Signals:
- IP ping fails
- routing table is wrong
Route:
- `network-diagnosis-playbook.md`
Proof:
- IP connectivity restored first, then DNS works

### Fork B — Local config error
Signals:
- `/etc/resolv.conf` empty or wrong
- nameservers unreachable or invalid
Route:
- `network-diagnosis-playbook.md`
Goal:
- fix resolver configuration
Proof:
- `getent hosts example.com` works

### Fork C — Local resolver service broken
Signals:
- `/etc/resolv.conf` points to stub (127.0.0.53) but queries fail
- resolver service inactive or erroring
Route:
- `service-recovery-playbook.md`
Goal:
- restore resolver service or bypass stub safely
Proof:
- queries succeed via stub

### Fork D — Upstream DNS unreachable
Signals:
- resolver is configured
- service is running
- but queries to nameservers time out
Route:
- `network-diagnosis-playbook.md`
Goal:
- restore path to upstream DNS (routing/firewall)
Proof:
- `dig @<server> example.com` works

### Fork E — Policy block (firewall / SELinux)
Signals:
- packets blocked
- logs show denies
Route:
- `security-triage-playbook.md`
Goal:
- permit DNS traffic intentionally
Proof:
- DNS works without broad policy weakening

### Fork F — Partial resolution
Signals:
- some domains resolve, others do not
Route:
- `network-diagnosis-playbook.md`
Goal:
- identify upstream or split-DNS issue
Proof:
- target domains resolve correctly

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not “just restart networking” blindly.
- Do not overwrite `/etc/resolv.conf` without understanding ownership.
- Do not assume “internet is down” before testing IP vs DNS.
- Do not disable security controls without evidence.

---

## 🧯 Recovery Principles

- Fix the **layer that is broken**:
  - routing
  - resolver config
  - resolver service
  - upstream reachability
  - policy
- Make the **smallest change** that restores resolution.
- Prefer:
  - repairing config or service
  - not hardcoding random public resolvers (unless this is a deliberate, temporary fix)

---

## ✅ Verification (Required Proof)

After intervention:

  getent hosts example.com
  getent hosts google.com

  ping -c 3 example.com || true

If package management was broken:

  apt-get update || true
  dnf makecache || true

If using systemd-resolved:

  resolvectl query example.com || true

Define “healthy” as:

- names resolve consistently
- dependent tools work
- no policy violations or hidden failures remain

---

## 🧾 Post-Incident Debrief

Answer:

- Was this actually DNS?
- Which layer was broken?
- Which classification bucket was this?
- What was the minimal safe fix?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Confusing routing failure with DNS failure
- Overwriting resolver config without understanding the manager
- Restarting random services until it “works”
- Disabling firewall/SELinux blindly
- Hardcoding public DNS as a permanent “fix”

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misclassified routing vs DNS:
- Drill:
  - `linux/LFCS-training/execution-drills/networking.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-8-networking.md`

### If the failure was resolver config or stub-related:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If policy blocked DNS:
- Drill:
  - `linux/LFCS-training/execution-drills/security-and-selinux.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

Purpose of this section:
- sharpen layer separation (routing vs resolution)
- improve first-hop classification
- prevent “random fix” behavior

---
