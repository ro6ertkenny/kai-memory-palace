i# 🔐 SSL Certificates — Operator Basics
*LFCS-ready inspection, verification, and trust-store mechanics (no theory expansion)*

---

## 🎯 Purpose
Operate TLS endpoints and certificates mechanically:

- inspect certificate files (PEM/DER)
- inspect remote certificate chains
- verify names, dates, and issuers
- understand trust-store behavior
- diagnose the common TLS failure modes quickly

This file is about execution under time pressure.

---

## 🧠 Mental Model (Operator)
TLS failures are usually one of these:

1) **Name mismatch**
- The certificate does not match the hostname you are connecting to.

2) **Expired / not yet valid**
- The certificate is outside its validity window.

3) **Untrusted chain**
- Missing intermediate(s) or unknown root CA.

4) **Protocol / cipher mismatch**
- Client and server cannot agree on protocol or cipher suite.

5) **Application-layer auth**
- TLS succeeds, then the app denies access (not a TLS failure).

Always separate:
- “Did TLS handshake succeed?” from
- “Did the application allow the request?”

---

## ✅ File Types and Encodings
Common certificate artifacts you will see:

- `.pem` (base64, human-readable container)
- `.crt` (often PEM, sometimes DER)
- `.cer` (often DER)
- `.key` (private key, PEM)
- `.p12` / `.pfx` (PKCS#12 bundle: cert + key + chain)
- “DER” means binary encoding (not human-readable)

---

## 🔎 Inspect a Certificate File (Local)

### 1) Display human-readable certificate details (PEM)
    openssl x509 -in server.crt -text -noout

### 2) Show only validity dates
    openssl x509 -in server.crt -noout -dates

### 3) Show subject and issuer
    openssl x509 -in server.crt -noout -subject -issuer

### 4) Show SANs (Subject Alternative Names)
    openssl x509 -in server.crt -text -noout | grep -n "Subject Alternative Name" -A 2

Operator rule:
- For modern TLS, hostname matching is based on SANs (not the CN).

---

## 🌐 Inspect a Remote TLS Endpoint (Handshake + Chain)

### 1) View the server certificate and chain
    openssl s_client -connect example.com:443 -servername example.com -showcerts </dev/null

Notes:
- `-servername` sets SNI (required for many hosts)
- `-showcerts` prints the chain the server provides
- Output is noisy; use targeted parsing below

### 2) Extract and inspect the leaf certificate quickly
    openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null \
      | openssl x509 -noout -subject -issuer -dates

### 3) Extract SANs from the remote leaf certificate
    openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null \
      | openssl x509 -noout -text \
      | grep -n "Subject Alternative Name" -A 2

### 4) Quick check: does verification succeed?
    openssl s_client -connect example.com:443 -servername example.com -verify_return_error </dev/null

Look for:
- `Verify return code: 0 (ok)`  => chain trusted by your system trust store
- non-zero codes => trust/chain problem

---

## 🧾 Convert Certificate Formats

### DER (.cer/.crt binary) → PEM
    openssl x509 -inform DER -in cert.cer -out cert.pem

### PEM → DER
    openssl x509 -outform DER -in cert.pem -out cert.der

### Inspect a PKCS#12 bundle (.p12/.pfx)
    openssl pkcs12 -in bundle.p12 -info -noout

Extract certs (no keys):
    openssl pkcs12 -in bundle.p12 -clcerts -nokeys -out leaf-cert.pem

Extract keys (be careful; private material):
    openssl pkcs12 -in bundle.p12 -nocerts -out private-key.pem

Operator warning:
- Private keys must be protected (permissions, storage, handling).

---

## 🧰 Trust Store Locations (Linux)

### Debian/Ubuntu family
Typical paths:
- CA bundle: `/etc/ssl/certs/ca-certificates.crt`
- CA directory: `/etc/ssl/certs/`
- Local CAs: `/usr/local/share/ca-certificates/`

Add a new CA (local org CA):
1) Copy PEM CA cert to:
    /usr/local/share/ca-certificates/my-org-ca.crt
2) Update:
    sudo update-ca-certificates
3) Verify it is linked under `/etc/ssl/certs/` and included in bundle.

### RHEL/Fedora family (reference only)
Typical:
- update tool: `update-ca-trust`
- anchors: `/etc/pki/ca-trust/source/anchors/`

---

## 🧪 Verify Name Matching (Operator Checks)

### What name is the client using?
- If you connect to `example.com`, the cert must include `example.com` in SANs.
- If you connect by IP, the cert must include that IP as an IP SAN (rare).

Check SANs:
    openssl x509 -in server.crt -noout -text | grep -n "Subject Alternative Name" -A 2

Typical failure indicator:
- Browser/curl says hostname mismatch
- `openssl s_client` handshake may still succeed but name check fails at client layer

---

## 🔧 Curl: Fast Practical TLS Checks

### Show TLS handshake summary (verbose)
    curl -v https://example.com/

### Force a specific TLS version (when debugging protocol issues)
    curl -v --tlsv1.2 https://example.com/
    curl -v --tlsv1.3 https://example.com/

### Test with a specific CA bundle (bypass system trust)
    curl --cacert my-ca.pem https://example.com/

### Ignore trust errors (diagnostic only; do not normalize this)
    curl -k -v https://example.com/

Operator rule:
- `-k` is for isolating trust-store issues, not for “fixing” production.

---

## 🧯 Common TLS Failures → Mechanical Diagnosis

### 1) Expired certificate
Symptoms:
- “certificate has expired”
Checks:
    openssl x509 -in server.crt -noout -dates
Remote:
    openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null \
      | openssl x509 -noout -dates

### 2) Not yet valid
Symptoms:
- time skew, wrong clock
Checks:
    date
    timedatectl status
Then re-check dates on cert.

### 3) Untrusted issuer / missing intermediate
Symptoms:
- “unable to get local issuer certificate”
- “unable to verify the first certificate”
Checks:
    openssl s_client -connect example.com:443 -servername example.com -showcerts </dev/null
Actions:
- confirm server sends full chain (leaf + intermediate(s))
- confirm your client trust store includes the root CA (or add org CA if private)

### 4) Hostname mismatch
Symptoms:
- “no alternative certificate subject name matches”
Checks:
- inspect SANs (must contain the hostname used)

### 5) Protocol/cipher mismatch
Symptoms:
- handshake fails early
Actions:
- try TLS 1.2 vs 1.3 with curl
- inspect server config (outside LFCS scope, but recognition matters)

---

## ✅ Drill Set (LFCS Execution)

Drill 1: Inspect a local cert file
- print subject/issuer
- print dates
- print SANs

Drill 2: Inspect a remote endpoint
- show chain
- extract leaf and print subject/issuer/dates
- check verify return code

Drill 3: Trust store update (Debian)
- add local CA under `/usr/local/share/ca-certificates/`
- run update
- confirm verify return code becomes 0 for a test endpoint (or confirm CA is installed)

---
