# 🔐 Phase 17 — SSL / TLS & Certificates (OpenSSL)
*LFCS execution layer: inspect, generate, validate, and select certificates correctly.*

---

## 📌 Purpose

LFCS expects you to be able to:

- Inspect certificates
- Check expiration and subject
- Identify the **correct** cert/key among many
- Generate keys, CSRs, and self-signed certs
- Understand what file is the cert vs the key
- Remove incorrect certificates safely

You are **not** building PKI infrastructure — you are **operating** it.

---

## 🧠 Mental Model

- **Private key** = secret (never shared)
- **Certificate** = public identity
- **CSR** = request to create certificate
- **Chain** = cert + issuer(s)

Most exam tasks are:

- “Which cert is valid?”
- “Which one has CN = X?”
- “Which one expires soon?”
- “Delete the wrong ones.”

---

# 🔎 Part A — Inspect Certificates

Show full certificate details:

    openssl x509 -in my.crt -noout -text

Show subject only:

    openssl x509 -in my.crt -noout -subject

Show expiration date:

    openssl x509 -in my.crt -noout -enddate

Show public key info:

    openssl x509 -in my.crt -noout -text | grep "Public-Key"

Search multiple files:

    openssl x509 -in file1.crt -noout -subject
    openssl x509 -in file2.crt -noout -subject

Or:

    openssl x509 -in file* -noout -text

---

## 🧪 Exam Drill: Find Correct Cert

Given many certs:

    openssl x509 -in /home/bob/certs/third* -noout -text | grep "kodekloud.com"

Delete wrong ones:

    sudo rm /home/bob/certs/first*

---

# 🛠️ Part B — Generate Keys and Certificates

Generate private key + CSR:

    openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

Generate self-signed cert (no password):

    openssl req -newkey rsa:4096 -x509 -days 365 -nodes -keyout priv.key -out server.crt

Alternative form:

    openssl req -x509 -noenc -days 365 -keyout priv.key -out server.crt

---

## Verify Result

Check subject:

    openssl x509 -in server.crt -noout -subject

Check expiration:

    openssl x509 -in server.crt -noout -enddate

---

# 🧾 Part C — Understand File Roles

You must **not** confuse:

- priv.key  → private key
- server.crt → certificate
- cert.csr → request

Typical service config wants:

- cert file
- key file

---

# 🔗 Part D — Verify Certificate Chain

(If provided)

    openssl verify server.crt

Or:

    openssl verify -CAfile ca.crt server.crt

---

# ⚠️ Failure Modes

- Deleting the private key instead of wrong cert
- Editing cert instead of replacing it
- Using CSR as cert
- Using encrypted key when service can’t read it
- Forgetting -nodes when generating key for services

---

# 🧪 Phase 17 Exam Drills

You must be able to:

- Inspect cert subject
- Inspect expiration
- Identify correct CN
- Identify correct public key size
- Delete wrong certs
- Generate new cert
- Generate key + CSR
- Generate self-signed cert

---

# 🏁 Phase 17 Mastery Checklist

You can:

- Tell cert vs key vs CSR apart instantly
- Read cert contents with openssl
- Find the right cert among many
- Generate a replacement cert
- Verify expiration and subject

---

## 🧠 Exam Law

> **Most SSL tasks in LFCS are inspection and selection, not cryptography.**

---

