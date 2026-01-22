# 🔒 TLS Triage Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/tls-triage-playbook.md`  
**Purpose:** Restore **valid, trusted TLS operation** for a service using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- A service fails to start due to **certificate errors**
- Clients reject connections due to **expired / wrong / untrusted cert**
- TLS handshake fails
- Wrong **key, cert, or chain** is configured
- A recent cert change broke the service

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/ssl-certificates.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/service-configuration.md`
- `linux/LFCS-training/execution-drills/files-and-text.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- (Future) tls-expired-cert  
- (Future) bad-chain-config

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Reproduce and observe**
2. **Identify the TLS endpoint**
3. **Inspect certificate material**
4. **Validate certificate, key, and dates**
5. **Validate chain**
6. **Verify service configuration**
7. **Apply minimal correction**
8. **Verify**
9. **Make persistent**
10. **Rollback if needed**

Never regenerate keys or certs blindly.

---

## 🧭 Global Safety Rules

- **Preserve evidence first.** Inspect before replacing files.
- **Never loosen private key permissions.**
- **Do not guess chain order.**
- **Prefer smallest, reversible change.**
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Service name
- Port
- Paths to:
  - certificate
  - private key
  - chain (if applicable)
- Exact client or service error message

---

## 1) Reproduce and Observe

Check service:

    systemctl status <service> --no-pager
    journalctl -u <service> --no-pager -n 80

Test locally:

    curl -vk https://localhost:<port>

Or:

    openssl s_client -connect localhost:<port>

Record:

- Error message
- Whether a cert is presented
- Which cert is presented

---

## 2) Identify TLS Endpoint and Files

Inspect service configuration:

    grep -R "ssl\|tls\|cert" /etc/<service>/

Or open the main config:

    vi /etc/<service>/<config>

Identify and write down paths to:

- cert file
- key file
- chain file (if any)

---

## 3) Inspect Certificate Material

Check files exist and are readable by the service:

    ls -l /path/to/cert.pem
    ls -l /path/to/key.pem
    ls -l /path/to/chain.pem

Check ownership and modes:

- Private key should usually be:
  - owned by root or service user
  - mode 600 or similarly restrictive

---

## 4) Validate Certificate and Key

Check certificate dates:

    openssl x509 -in /path/to/cert.pem -noout -dates

Check subject and issuer:

    openssl x509 -in /path/to/cert.pem -noout -subject -issuer

Check key matches cert:

    openssl x509 -noout -modulus -in /path/to/cert.pem | openssl md5
    openssl rsa  -noout -modulus -in /path/to/key.pem  | openssl md5

The hashes must match.

If:

- Cert is expired
- Or key does not match

→ Go to **Section 7**.

---

## 5) Validate Chain

If a chain file is used:

    cat /path/to/chain.pem

Test verification:

    openssl verify -CAfile /path/to/chain.pem /path/to/cert.pem

If verification fails:

- Missing intermediate
- Wrong file order
- Wrong CA file

Fix the chain file, then continue.

---

## 6) Verify Service Configuration

Confirm:

- Config points to the correct files
- No typos in paths
- No stale references to old certs

Validate config if supported:

    nginx -t
    httpd -t

Restart service:

    systemctl restart <service>

If it still fails:

- Return to **Section 1** and re-observe.

---

## 7) Replace or Fix Certificate Material

If cert is expired, wrong, or mismatched:

- Obtain or generate the correct cert (exam scope: assume provided or self-signed if instructed)
- Place files in correct paths
- Fix ownership and modes:

    chown root:root /path/to/key.pem
    chmod 600 /path/to/key.pem

Restart service:

    systemctl restart <service>

Return to **Section 1**.

---

## 8) Verification

Test locally:

    curl -vk https://localhost:<port>

Or:

    openssl s_client -connect localhost:<port>

Confirm:

- No certificate errors
- Correct certificate is presented
- Service is running:

    systemctl status <service> --no-pager

---

## 9) Persistence Check

Ensure:

- Files are in stable, non-temporary paths
- Config does not reference temp locations
- Permissions and ownership are correct

Restart test:

    systemctl restart <service>
    systemctl status <service> --no-pager

---

## 🔁 Rollback Strategy

If a new cert or config breaks things:

- Restore previous cert/key/chain
- Restore previous config
- Restart service
- Re-verify

Always keep backups of:

- cert
- key
- config

---

## ✅ Completion Criteria

- Service starts cleanly
- Clients connect without TLS errors
- Certificate:
  - is valid
  - is not expired
  - matches the private key
  - has a correct chain (if used)
- Configuration is stable

You can explain:

- What was wrong
- Why it broke TLS
- Why your fix was minimal and safe
- How you verified recovery

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
