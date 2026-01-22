# 🧱 Building Block 14 — TLS and Certificates

**Path:** `linux/LFCS-training/training-progression/building-block-14-tls-and-certificates.md`  
**Purpose:** Build the ability to **reason about trust**, **inspect certificate material**, and **restore TLS service operation** without exposing private keys or weakening security.

---

## 🎯 What This Block Builds

You are building:

- A correct mental model of:
  - certificates
  - private keys
  - chains of trust
- The ability to:
  - diagnose why a TLS endpoint fails
  - prove whether a cert is expired, wrong, or mismatched
  - restore service using **the right files in the right places**

This block turns “SSL is broken” into a **mechanical, verifiable repair**.

---

## 🧠 Mental Models You Must Own

- TLS is:
  - identity (certificate)
  - plus secrecy (private key)
  - plus trust (chain)
- A certificate alone is useless without:
  - the matching private key
- Most TLS failures come from:
  - expired certs
  - wrong file paths
  - wrong chain
  - cert/key mismatch
- File permissions on keys are:
  - part of the security boundary
  - not optional

Invariants:

- “I can prove which cert is being served.”
- “I can prove whether it is valid and matches its key.”
- “I never make private keys world-readable.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/ssl-certificates.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`

Rule:

> You should be able to inspect certs, keys, and chains **without guessing**.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- “Service fails to start due to cert error”
- “Client rejects connection due to expired or wrong cert”
- “Wrong cert served after config change”

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`
- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (when TLS prevents startup)

Rule:

> You should always follow the TLS triage playbook before regenerating or replacing anything.

---

## 🧭 Required Capabilities

You must be able to:

### Inspect Certificate Material

- Determine:
  - subject
  - issuer
  - validity dates
- Verify:
  - which cert a service is actually serving

### Verify Key Match

- Prove:
  - cert matches key
  - using modulus or equivalent fingerprint comparison

### Validate Chains

- Determine:
  - whether intermediates are present
  - whether the chain verifies
- Recognize:
  - wrong order
  - missing intermediate

### Fix Safely

- Replace:
  - cert
  - key
  - chain
- Set:
  - correct ownership
  - correct permissions
- Restart and:
  - verify with client tools

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- Given a TLS failure, you can:
  - identify whether the problem is:
    - expiration
    - mismatch
    - chain
    - config path
- You can:
  - fix the problem without exposing private keys
  - prove the fix using inspection tools
- You do not:
  - guess at cert files
  - regenerate keys unless explicitly required

Concrete tests:

- You can:
  - recover a service broken by an expired cert
  - detect and fix a cert/key mismatch
  - fix a missing or wrong chain

---

## 🔁 Regression Rule

If later you:

- expose private keys with loose permissions
- replace certs without understanding the failure
- cannot explain which cert is being served

You must:

> Return here and re-run `ssl-certificates.md` and the TLS triage playbook until trust reasoning is automatic again.

---

## 🧠 Operator Rule (Carry Forward)

> **Never touch TLS files until you can prove what is broken.**

---

## 🧱 This Block Enables

- Secure service operation
- Confident handling of cert renewals and breakage
- Trustworthy client/server communication
- Safe production-like TLS workflows

Without this block, **TLS incidents become panic-driven and risky**.

---
