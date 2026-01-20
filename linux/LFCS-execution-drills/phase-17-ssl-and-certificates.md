# 🧪 LFCS Execution Drills — Phase 17
# 🔐 SSL / TLS & Certificates (OpenSSL)

Path:
  linux/execution-drills/phase-17-ssl-and-certificates.md

Purpose:
  Build reflex-level skill for inspecting, identifying, generating, and replacing certificates safely.

Mental Mode:
  This phase is NOT cryptography.
  This phase IS:
  - inspection
  - selection
  - validation
  - safe replacement

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-17
    cd ~/lfcs-labs/execution-drills/phase-17

---

# 🧪 A) Certificate Inspection Drills

## A1 — Create sample certs

    openssl req -x509 -noenc -days 365 -keyout key1.key -out site1.crt -subj "/CN=example1.com"
    openssl req -x509 -noenc -days 30  -keyout key2.key -out site2.crt -subj "/CN=example2.com"
    openssl req -x509 -noenc -days 365 -keyout key3.key -out site3.crt -subj "/CN=kodekloud.com"

List:

    ls -l

---

## A2 — Inspect subject

    openssl x509 -in site1.crt -noout -subject
    openssl x509 -in site2.crt -noout -subject
    openssl x509 -in site3.crt -noout -subject

---

## A3 — Inspect expiration

    openssl x509 -in site1.crt -noout -enddate
    openssl x509 -in site2.crt -noout -enddate
    openssl x509 -in site3.crt -noout -enddate

---

## A4 — Inspect key size

    openssl x509 -in site1.crt -noout -text | grep "Public-Key"
    openssl x509 -in site2.crt -noout -text | grep "Public-Key"
    openssl x509 -in site3.crt -noout -text | grep "Public-Key"

---

# 🧪 B) Find the Correct Certificate (Exam Pattern)

## B1 — Find cert for kodekloud.com

    openssl x509 -in site*.crt -noout -subject | grep kodekloud

Expected:
- site3.crt

---

## B2 — Find cert expiring soon

    for f in site*.crt; do echo "=== $f ==="; openssl x509 -in $f -noout -enddate; done

Expected:
- site2.crt is shortest-lived

---

## B3 — Delete wrong certs (simulate exam)

    rm site1.crt site2.crt

Verify:

    ls -l

---

# 🧪 C) Understand File Roles

Create CSR:

    openssl req -newkey rsa:2048 -keyout newkey.key -out request.csr -nodes -subj "/CN=test.local"

Now you have:

- newkey.key   = private key
- request.csr = CSR
- site3.crt   = cert

Verify:

    ls -l

Inspect CSR:

    openssl req -in request.csr -noout -subject

---

# 🧪 D) Generate Self-Signed Certificate

## D1 — Generate new cert + key

    openssl req -x509 -noenc -days 365 -keyout server.key -out server.crt -subj "/CN=server.local"

Verify:

    openssl x509 -in server.crt -noout -subject
    openssl x509 -in server.crt -noout -enddate

---

# 🧪 E) Chain Verification

Self-signed (will still verify):

    openssl verify server.crt

---

# 🧪 F) Identification Drills (Timed)

## F1 — Which file is the private key?

    ls -l *.key *.crt *.csr

Rule:
- .key = private key
- .crt = certificate
- .csr = request

---

## F2 — Show subject of all certs (10 seconds)

    openssl x509 -in *.crt -noout -subject

---

## F3 — Show expiration of all certs (10 seconds)

    for f in *.crt; do openssl x509 -in $f -noout -enddate; done

---

# 💣 G) Failure Mode Drills

## G1 — Using CSR as cert (wrong)

Try:

    openssl x509 -in request.csr -noout -text

Observe:
- This is not a cert

---

## G2 — Deleting wrong file

Explain:
- Deleting .key destroys identity
- Deleting .crt can be regenerated
- Deleting .csr is harmless

---

# 🧪 H) Composition (Exam Style)

## H1 — Full scenario

1) Find cert with CN=server.local
2) Check expiration
3) Delete others
4) Generate new cert if needed

Commands:

    openssl x509 -in *.crt -noout -subject | grep server.local
    openssl x509 -in server.crt -noout -enddate

Cleanup:

    rm -f site*.crt site*.key request.csr newkey.key

---

# 🏁 Phase 17 Completion Criteria

You can:

- Instantly tell cert vs key vs CSR
- Read subject and expiration
- Find correct cert among many
- Safely delete wrong certs
- Generate new self-signed certs
- Generate key + CSR
- Verify certs

---

# 🧠 Phase 17 Law

Most SSL tasks in LFCS are inspection and selection, not cryptography.

---

# 🧹 Cleanup

    rm -f *.crt *.key *.csr

---
