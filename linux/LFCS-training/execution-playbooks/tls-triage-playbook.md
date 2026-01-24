# 🔐 TLS / SSL Certificate Triage Playbook
*Operational doctrine for diagnosing, selecting, validating, and repairing TLS certificates under time pressure.*

Path:
- linux/LFCS-training/execution-playbooks/tls-triage-playbook.md

Mental mode:
- Incident response
- “Service is down / browser says cert is bad / chain is broken / wrong cert deployed”

This is **not** a crypto tutorial.  
This is **execution under pressure**.

---

## 📌 Scope

This playbook covers:

- Identifying cert vs key vs CSR instantly
- Inspecting subject, SAN, expiration, and key size
- Verifying which cert a service is actually serving
- Selecting the correct cert among many
- Detecting expired / wrong / weak certs
- Verifying certificate chains
- Generating replacement keys, CSRs, and certs
- Avoiding service-breaking mistakes

---

## 🧱 Laws of TLS Triage

1. Most TLS failures are **selection and deployment mistakes**, not crypto.
2. Always answer first:
   - Which cert is the service serving?
   - Which cert should it be serving?
3. Never overwrite keys or certs without a backup.
4. Never delete before you prove.

---

## 🧭 Quick Identification (File Types)

Identify file types immediately:

    openssl x509 -in file.crt -noout -subject      # certificate
    openssl pkey -in file.key -noout -text         # private key
    openssl req  -in file.csr -noout -subject      # CSR

If one of these errors:
- “unable to load certificate” → it’s not a cert
- “unable to load key” → it’s not a key

---

## 🔍 Inspect a Certificate (Core Signals)

Subject and SAN:

    openssl x509 -in server.crt -noout -subject
    openssl x509 -in server.crt -noout -text | grep -A1 "Subject Alternative Name"

Expiration:

    openssl x509 -in server.crt -noout -enddate

Key size:

    openssl x509 -in server.crt -noout -text | grep "Public-Key"

Issuer:

    openssl x509 -in server.crt -noout -issuer

---

## 🌐 Inspect What a Service Is Actually Serving

Direct socket check:

    openssl s_client -connect example.com:443 -servername example.com

Then inspect the presented cert:

    openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null | openssl x509 -noout -subject -enddate -issuer

This answers:

- Which cert is live
- Whether it is expired
- Who issued it

---

## 🧬 Verify Certificate Chain

Given a cert file:

    openssl verify server.crt

With explicit CA bundle:

    openssl verify -CAfile chain.pem server.crt

If this fails:
- You have a missing or wrong intermediate
- Or the wrong cert entirely

---

## 🧹 Selecting the Right Cert Among Many

Enumerate:

    for f in *.crt; do echo "==== $f ===="; openssl x509 -in "$f" -noout -subject -enddate; done

Find:
- Correct CN / SAN
- Not expired
- Correct issuer
- Correct key size

Only then consider deleting others.

---

## 🗑️ Safe Deletion Rule

Before deleting anything:

    openssl x509 -in correct.crt -noout -subject > keep-proof.txt

Then:

    rm -f wrong1.crt wrong2.crt old.crt

Always leave proof.

---

## 🛠️ Generate New Key + CSR

    openssl req -newkey rsa:2048 -nodes -keyout server.key -out server.csr -subj "/CN=example.com"

Verify:

    openssl req -in server.csr -noout -subject

---

## 🧪 Generate Temporary Self-Signed Cert (Testing Only)

    openssl req -x509 -noenc -days 365 -keyout test.key -out test.crt -subj "/CN=test.local"

Inspect:

    openssl x509 -in test.crt -noout -subject -enddate

---

## 🔁 Check That Cert Matches Key

    openssl x509 -noout -modulus -in server.crt | openssl md5
    openssl pkey -noout -modulus -in server.key | openssl md5

These must match.

---

## 🧯 Common Failure Patterns

- Cert not expired, but:
  - Wrong CN / SAN
  - Wrong cert file configured
  - Missing intermediate chain
  - Key does not match cert
- “It works in curl but not in browser” → chain problem
- “It worked yesterday” → expiration or renewal deployed incorrectly

---

## 🧠 Operator Checklist

When TLS is broken:

- [ ] What cert is being served?
- [ ] Is it expired?
- [ ] Is the name correct?
- [ ] Does the key match?
- [ ] Is the chain complete?
- [ ] Is the service pointing at the correct files?

---

## 🏁 Success Criteria

You can:

- Identify cert vs key vs CSR instantly
- Inspect subject, SAN, expiration, and key size
- Verify what a service is serving
- Verify chains
- Select the correct cert among many
- Generate replacement keys and CSRs safely
- Avoid deleting the wrong thing

---

## 🔒 Final Law

Most TLS outages are **file selection mistakes**, not cryptography problems.

