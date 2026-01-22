# 🧪 SSL Certificates — Execution Drills (LFCS)

Mental mode: Inspection, selection, and safe replacement.  
Goal: Be able to **identify, inspect, validate, select, and replace certificates** under time pressure.

This is not cryptography.  
This is an **execution checklist**.

Core law:

> Most LFCS SSL tasks are about **finding the right cert, checking dates/names, and wiring the correct files**.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/ssl
    cd ~/lfcs-labs/execution-drills/ssl

Verify openssl exists:

    openssl version

---

# =========================
# 🔎 1) Create Sample Certificates (Lab Data)
# =========================

    openssl req -x509 -noenc -days 365 -keyout key1.key -out site1.crt -subj "/CN=example1.com"
    openssl req -x509 -noenc -days 30  -keyout key2.key -out site2.crt -subj "/CN=example2.com"
    openssl req -x509 -noenc -days 365 -keyout key3.key -out site3.crt -subj "/CN=kodekloud.com"

List:

    ls -l

---

# =========================
# 🧾 2) Identify File Types
# =========================

Rules:
- `.key` = private key
- `.crt` / `.pem` = certificate
- `.csr` = certificate signing request

List:

    ls -l *.key *.crt

---

# =========================
# 🔍 3) Inspect Certificates
# =========================

## 3.1 Show subject (who it is for)

    openssl x509 -in site1.crt -noout -subject
    openssl x509 -in site2.crt -noout -subject
    openssl x509 -in site3.crt -noout -subject

## 3.2 Show expiration

    openssl x509 -in site1.crt -noout -enddate
    openssl x509 -in site2.crt -noout -enddate
    openssl x509 -in site3.crt -noout -enddate

## 3.3 Show key size

    openssl x509 -in site1.crt -noout -text | grep "Public-Key"
    openssl x509 -in site2.crt -noout -text | grep "Public-Key"
    openssl x509 -in site3.crt -noout -text | grep "Public-Key"

---

# =========================
# 🧠 4) Selection Drills (Exam Pattern)
# =========================

## 4.1 Find cert for kodekloud.com

    openssl x509 -in site*.crt -noout -subject | grep kodekloud

Expected:
- site3.crt

## 4.2 Find cert expiring soon

    for f in site*.crt; do echo "=== $f ==="; openssl x509 -in $f -noout -enddate; done

Expected:
- site2.crt

## 4.3 Delete wrong certs (simulation)

    rm site1.crt site2.crt

Verify:

    ls -l

---

# =========================
# 🔑 5) Key vs CSR vs Cert
# =========================

Create CSR:

    openssl req -newkey rsa:2048 -keyout newkey.key -out request.csr -nodes -subj "/CN=test.local"

Now you have:
- newkey.key   = private key
- request.csr = CSR
- site3.crt   = certificate

Inspect CSR:

    openssl req -in request.csr -noout -subject

---

# =========================
# 🏗️ 6) Generate New Self-Signed Cert
# =========================

    openssl req -x509 -noenc -days 365 -keyout server.key -out server.crt -subj "/CN=server.local"

Verify:

    openssl x509 -in server.crt -noout -subject
    openssl x509 -in server.crt -noout -enddate

---

# =========================
# 🔗 7) Verification
# =========================

Self-signed still verifies locally:

    openssl verify server.crt

---

# =========================
# ⏱️ 8) Timed Drills
# =========================

## 8.1 Show subject of all certs (10 seconds)

    openssl x509 -in *.crt -noout -subject

## 8.2 Show expiration of all certs (10 seconds)

    for f in *.crt; do openssl x509 -in $f -noout -enddate; done

## 8.3 Identify private key instantly

    ls -l *.key

---

# =========================
# 💣 9) Failure Mode Recognition
# =========================

## 9.1 Using CSR as cert (wrong)

    openssl x509 -in request.csr -noout -text

Explain:
- This is not a certificate

## 9.2 Deleting wrong file

Rules:
- Deleting `.key` = identity lost
- Deleting `.crt` = can regenerate
- Deleting `.csr` = harmless

---

# =========================
# 🧠 10) Composition (Exam Style)
# =========================

Scenario:
- Many certs exist
- You must find correct one, check date, replace if needed

Commands:

    openssl x509 -in *.crt -noout -subject | grep server.local
    openssl x509 -in server.crt -noout -enddate

If expired:

    openssl req -x509 -noenc -days 365 -keyout server.key -out server.crt -subj "/CN=server.local"

---

# =========================
# ✅ Completion Criteria
# =========================

You are done when you can:

- Instantly identify key vs cert vs CSR
- Read subject and expiration without thinking
- Find the correct cert among many
- Detect expiring certs quickly
- Generate replacement certs safely
- Never confuse CSR and cert
- Never delete private keys accidentally

---

# 🧠 Final Law

LFCS SSL work is **file identification and selection under pressure**, not cryptography.

---

# 🧹 Cleanup

    cd ~
    rm -rf ~/lfcs-labs/execution-drills/ssl || true

---

