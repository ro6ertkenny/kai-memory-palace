# 🧯 Scenario 10 — TLS Certificate Failure (LFCS)

**File:** `linux/LFCS-training/failure-scenarios/scenario-10-tls-certificate-failure.md`  
Mental mode: **Pressure → measure → classify → route → recover → prove**  
Primary playbook: `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`  
Secondary playbooks (as needed):
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the service must be reloaded/restarted)
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if policy blocks access to cert/key paths)
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if this is actually a reachability or SNI routing issue)

---

## 📌 Incident Brief (Symptom-First)

Users report:

- Browser shows certificate warning
- Clients fail with:
  - “certificate has expired”
  - “unable to verify first certificate”
  - “certificate verify failed”
  - “hostname mismatch”
- `curl https://…` fails but `curl http://…` works

The service is **up**, but **TLS is broken**.

Your job is to:
- classify **what kind of TLS failure this is**
- fix it **without weakening security**
- restore trusted access
- prove the system is healthy

---

## 🎯 Objectives (What “Done” Means)

You are done when you can:

- Identify which failure class this is:
  - expired cert
  - wrong hostname (SAN/CN)
  - missing or wrong chain
  - wrong cert/key pair
  - permission / access issue
  - client trust store problem
- Apply the **minimal safe fix**
- Prove:
  - clients connect without warnings
  - the correct certificate is being served
  - the service remains stable

---

## 🧠 Operator Rule

> **Never bypass TLS verification to “make it work.”**  
> **Always fix the trust chain or identity, not the client.**

---

## 🧭 Classification Buckets

You must place the incident into one bucket before acting:

1) **Expired certificate**
2) **Hostname mismatch (CN/SAN)**
3) **Incomplete or wrong chain**
4) **Wrong certificate or key configured**
5) **File permission / access denial**
6) **Client trust store issue**
7) **Not actually TLS (routing / SNI / proxy issue)**

---

## 🧪 Required Evidence (What Is the Server Presenting?)

From the affected host or a client:

  openssl s_client -connect host:443 -servername host < /dev/null

Or:

  echo | openssl s_client -connect host:443 -servername host

Capture:

- Subject
- Issuer
- Not Before / Not After
- Chain depth and errors

Also:

  curl -v https://host/ || true

Look for:

- “certificate expired”
- “self signed”
- “unable to get local issuer”
- “hostname mismatch”

---

## 🧩 Inspect the Certificate on Disk (Server Side)

Identify the configured paths (from service config):

- cert file
- key file
- chain / bundle file

Inspect:

  openssl x509 -in /path/to/cert.pem -noout -text

Verify:

- CN / SAN matches hostname
- validity dates are current
- issuer is correct

Check key matches cert:

  openssl x509 -noout -modulus -in /path/to/cert.pem | openssl md5
  openssl rsa  -noout -modulus -in /path/to/key.pem  | openssl md5

The hashes must match.

---

## 🧪 Check Permissions and Policy

Verify:

  ls -l /path/to/cert.pem /path/to/key.pem

If access is denied in logs:

- check ownership and mode
- check SELinux contexts (if applicable)

---

## 🧭 Decision Forks (Evidence → Classification)

### Fork A — Expired certificate
Signals:
- `Not After` is in the past
Route:
- `tls-triage-playbook.md`
Goal:
- renew or replace cert
- reload service
Proof:
- new expiry date visible via `openssl s_client`

### Fork B — Hostname mismatch
Signals:
- CN/SAN does not include the hostname
Route:
- `tls-triage-playbook.md`
Goal:
- install correct cert for this name
Proof:
- client connects without warnings

### Fork C — Incomplete / wrong chain
Signals:
- errors like “unable to get local issuer”
- chain depth issues in `openssl s_client`
Route:
- `tls-triage-playbook.md`
Goal:
- install proper full chain / bundle
Proof:
- chain verifies cleanly

### Fork D — Wrong cert/key pair
Signals:
- modulus mismatch
- service fails to start or presents wrong identity
Route:
- `tls-triage-playbook.md`
Goal:
- pair the correct cert and key
Proof:
- service starts and presents expected cert

### Fork E — Permission / policy block
Signals:
- service logs show permission denied
Route:
- `security-triage-playbook.md` or `service-recovery-playbook.md`
Goal:
- fix access without broadening policy
Proof:
- service can read cert/key and start

### Fork F — Client trust issue
Signals:
- server presents valid chain
- some clients fail, others succeed
Route:
- `tls-triage-playbook.md`
Goal:
- fix client trust store or deployment issue
Proof:
- affected clients connect cleanly

### Fork G — Not actually TLS
Signals:
- wrong backend via proxy/SNI
- connecting to the wrong service
Route:
- `network-diagnosis-playbook.md`
Proof:
- correct routing restores valid cert

---

## 🚫 Forbidden Actions (Diagnosis Phase)

- Do not disable certificate verification.
- Do not switch clients to `-k` / `--insecure` as a “fix”.
- Do not install random certificates.
- Do not overwrite working certs without backup.

---

## 🧯 Recovery Principles

- Fix **identity and trust**, not symptoms.
- Prefer:
  - replacing or correcting certs
  - reloading services
- Keep changes:
  - minimal
  - auditable
  - reversible

---

## ✅ Verification (Required Proof)

From a client:

  openssl s_client -connect host:443 -servername host < /dev/null
  curl https://host/

Confirm:

- no verification errors
- correct CN/SAN
- correct expiry date
- correct chain

On the server:

- service is active
- logs are clean

---

## 🧾 Post-Incident Debrief

Answer:

- Which TLS failure bucket was this?
- What evidence proved it?
- What exactly was wrong (expired, chain, name, key, perms)?
- What was the minimal safe fix?
- What prevents recurrence?

---

## 🧠 Anti-Patterns (Auto-Fail)

- Disabling TLS verification
- Accepting self-signed certs as “temporary” fixes
- Replacing certs without checking names or chains
- Fixing clients instead of the server
- Ignoring permission or policy errors

---

## 📎 Remediation & Reinforcement (After Action)

Only complete this section **after** recovery and verification.

Do **not** use this section while solving the incident.

### If you misread certificate contents or chains:
- Drill:
  - `linux/LFCS-training/execution-drills/ssl-certificates.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-17-incident-response.md`

### If you struggled mapping certs to services:
- Drill:
  - `linux/LFCS-training/execution-drills/services-and-logging.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-6-services-and-systemd.md`

### If this was actually routing/SNI:
- Drill:
  - `linux/LFCS-training/execution-drills/networking.md`
- Building block:
  - `linux/LFCS-training/training-progression/building-block-8-networking.md`

Purpose of this section:
- prevent insecure “bypass” fixes
- improve trust-chain reasoning
- strengthen identity-first thinking

---

