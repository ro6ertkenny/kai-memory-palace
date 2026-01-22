# 🔒 TLS Triage Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`  
**Purpose:** Restore **valid, trusted TLS operation** for a service using a **safe, exam-ready operator flow**.

---

## 🎯 Scope

Use this playbook when:

- A service fails to start due to **certificate errors**
- Clients reject connections due to **expired / wrong / untrusted cert**
- TLS handshake fails
- Wrong **key, cert, or chain** is configured
- A recent cert change broke the service

This playbook orchestrates the following canonical drill surfaces:

- `linux/LFCS-training/execution-drills/ssl-certificates.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (for practice validation):

- (Future) tls-expired-cert
- (Future) bad-chain-config

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Reproduce and observe**
2. **Identify the TLS endpoint**
3. **Inspect certificate material**
4. **Validate chain and dates**
5. **Verify service configuration**
6. **Correct minimally**
7. **Verify**
8. **Make persistent**
9. **Rollback if needed**

Never regenerate keys or certs blindly.

---

## 0) Inputs

You must know or determine:

- Service name
- Port
- Path to:
  - certificate
  - private key
  - chain (if applicable)
- Exact client or service error message

---

## 1) Reproduce and Observe

Check service:

    systemctl status <service>
    journalctl -u <service> --no-pager -n 50

Test locally:

    curl -vk https://localhost:<port>

Or:

    openssl s_client -connect localhost:<port>

Capture:

- Error message
- Which cert is presented (if any)

---

## 2) Identify TLS Endpoint and Files

Inspect service config:

    grep -R "ssl\|tls\|cert" /etc/<service>/

Or open config directly:

    vi /etc/<service>/<config>

Note paths to:

- cert file
- key file
- chain file (if any)

---

## 3) Inspect Certificate Material

Check files exist and are readable:

    ls -l /path/to/cert.pem
    ls -l /path/to/key.pem
    ls -l /path/to/chain.pem

Check ownership and modes:

- Key should usually be readable only by service user/root

---

## 4) Validate Certificate and Key

Check cert dates:

    openssl x509 -in /path/to/cert.pem -noout -dates

Check subject and issuer:

    openssl x509 -in /path/to/cert.pem -noout -subject -issuer

Check key matches cert:

    openssl x509 -noout -modulus -in /path/to/cert.pem | openssl md5
    openssl rsa  -noout -modulus -in /path/to/key.pem  | openssl md5

The hashes must match.

If expired or mismatched → go to **Section 7**.

---

## 5) Validate Chain

If a chain file is used:

    cat /path/to/chain.pem

Test verification:

    openssl verify -CAfile /path/to/chain.pem /path/to/cert.pem

If verification fails:

- Wrong chain
- Missing intermediate
- Wrong file order

Correct chain and continue.

---

## 6) Verify Service Configuration

Check:

- Config points to the correct files
- No typos in paths
- No stale paths to old certs

Validate service config if supported:

    nginx -t
    httpd -t

Restart service:

    systemctl restart <service>

If it still fails → return to **Section 1**.

---

## 7) Replace or Fix Certificate Material

If cert is expired or wrong:

- Obtain or generate correct cert (exam scope: assume provided or self-signed if instructed)
- Place files in correct paths
- Fix ownership and modes:

    chown root:root /path/to/key.pem
    chmod 600 /path/to/key.pem

Then:

    systemctl restart <service>

Return to **Section 1**.

---

## 8) Verification

Test locally:

    curl -vk https://localhost:<port>

Or:

    openssl s_client -connect localhost:<port>

Confirm:

- No cert errors
- Correct cert is presented
- Service is running:

    systemctl status <service>

---

## 9) Persistence Check

Ensure:

- Files are in stable paths
- Config does not reference temp locations
- Permissions and ownership are correct
- Service survives restart:

    systemctl restart <service>
    systemctl status <service>

---

## 🔁 Rollback Strategy

If a new cert breaks things:

- Restore previous cert and config paths
- Restart service
- Re-verify

Keep backups of:

- cert
- key
- config

---

## ✅ Completion Criteria

- Service starts cleanly
- Clients connect without TLS errors
- Certificate is:
  - valid
  - not expired
  - matches key
  - has correct chain
- Configuration is clean and stable

---

## 🧠 Exam Safety Rules

- Never expose private keys with loose permissions
- Never guess at chain order
- Always verify dates and key match
- Always test with curl or openssl after changes

---

## 🧱 This Playbook Composes From

- ssl-certificates.md
- services-and-logging.md
- service-configuration.md
- files-and-text.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---
