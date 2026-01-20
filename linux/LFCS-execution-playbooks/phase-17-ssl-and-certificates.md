# 🔐 Phase 17 — SSL / TLS & Certificates (Execution Playbook)
*LFCS crypto-ops layer: inspect, select, generate, validate, and replace certificates under time pressure.*

Path:
- linux/LFCS-execution-playbooks/phase-17-ssl-and-certificates.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- inspect certificates (subject, expiration, key size)
- distinguish cert vs key vs CSR instantly
- select the correct cert among many
- delete the wrong certs safely
- generate keys, CSRs, and self-signed certs
- verify chains (when provided)
- avoid common service-breaking mistakes

---

## 🧱 Lab Root

All Phase 17 drills run in:

- ~/lfcs-labs/phase-17

Initialize:

    mkdir -p ~/lfcs-labs/phase-17
    cd ~/lfcs-labs/phase-17
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT delete system certificates.
- Operate only inside the lab directory.
- Never overwrite keys or certs without a backup.
- Always prove before deleting.

---

## 🧪 Completion Standard

Pass Phase 17 when you can complete P17-1 through P17-14:

- in ≤ 120 minutes
- without touching system cert stores
- with proof files created
- and with correct artifacts produced

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P17-1 — Verify openssl exists

Time limit:
- 2 minutes

Do:

    openssl version > openssl-version.txt

Verify:

    cat openssl-version.txt

-------------------------------------------------------------------------------

## P17-2 — Create lab cert directory

Time limit:
- 2 minutes

Do:

    mkdir certs
    cd certs

-------------------------------------------------------------------------------

## P17-3 — Generate private key + CSR

Time limit:
- 5 minutes

Do:

    openssl req -newkey rsa:2048 -nodes -keyout lab.key -out lab.csr -subj "/CN=lab.local"
    ls -l > files-after-csr.txt

Verify:

    test -f lab.key
    test -f lab.csr

-------------------------------------------------------------------------------

## P17-4 — Generate self-signed certificate

Time limit:
- 4 minutes

Do:

    openssl req -x509 -noenc -days 365 -keyout lab2.key -out lab2.crt -subj "/CN=lab2.local"
    ls -l > files-after-selfsigned.txt

Verify:

    test -f lab2.key
    test -f lab2.crt

-------------------------------------------------------------------------------

## P17-5 — Inspect certificate subject

Time limit:
- 3 minutes

Do:

    openssl x509 -in lab2.crt -noout -subject > subject.txt

Verify:

    cat subject.txt

-------------------------------------------------------------------------------

## P17-6 — Inspect expiration date

Time limit:
- 3 minutes

Do:

    openssl x509 -in lab2.crt -noout -enddate > enddate.txt

Verify:

    cat enddate.txt

-------------------------------------------------------------------------------

## P17-7 — Inspect key size

Time limit:
- 3 minutes

Do:

    openssl x509 -in lab2.crt -noout -text | grep "Public-Key" > keysize.txt

Verify:

    cat keysize.txt

-------------------------------------------------------------------------------

## P17-8 — Create multiple dummy certs

Time limit:
- 6 minutes

Do:

    openssl req -x509 -noenc -days 30  -keyout a.key -out a.crt -subj "/CN=wrong.local"
    openssl req -x509 -noenc -days 365 -keyout b.key -out b.crt -subj "/CN=correct.local"
    openssl req -x509 -noenc -days 10  -keyout c.key -out c.crt -subj "/CN=old.local"
    ls *.crt > all-certs.txt

-------------------------------------------------------------------------------

## P17-9 — Find cert with correct CN

Time limit:
- 5 minutes

Task:
Find cert whose CN is "correct.local".

Do:

    for f in *.crt; do openssl x509 -in "$f" -noout -subject; done > subjects.txt
    grep "correct.local" subjects.txt > correct.txt

-------------------------------------------------------------------------------

## P17-10 — Find cert expiring soon

Time limit:
- 5 minutes

Task:
Check end dates.

Do:

    for f in *.crt; do echo "== $f =="; openssl x509 -in "$f" -noout -enddate; done > expirations.txt

-------------------------------------------------------------------------------

## P17-11 — Delete wrong certs (keep only correct)

Time limit:
- 5 minutes

Task:
Keep only cert with CN=correct.local.

Do:

    openssl x509 -in b.crt -noout -subject > keep-proof.txt
    rm -f a.crt c.crt

Verify:

    ls *.crt > remaining.txt

-------------------------------------------------------------------------------

## P17-12 — Verify cert vs key vs CSR

Time limit:
- 4 minutes

Do:

    echo "CERT:" > types.txt
    openssl x509 -in b.crt -noout -subject >> types.txt
    echo "KEY:" >> types.txt
    openssl pkey -in b.key -noout -text | head -n 5 >> types.txt
    echo "CSR:" >> types.txt
    openssl req -in lab.csr -noout -subject >> types.txt

-------------------------------------------------------------------------------

## P17-13 — Verify cert chain (if applicable)

Time limit:
- Note-only

Do:

    openssl verify b.crt > verify.txt || true

(If no CA chain, this may fail — that is acceptable for the drill.)

-------------------------------------------------------------------------------

## P17-14 — Cleanup

Time limit:
- 3 minutes

Do:

    cd ..
    echo OK > cleanup.txt

---

## 🏁 Phase 17 Pass Criteria

You can:

- inspect cert subject, expiration, and key size
- distinguish cert vs key vs CSR instantly
- select the correct cert among many
- delete wrong certs safely
- generate keys, CSRs, and self-signed certs
- verify certificates with openssl

---

## 🧠 Phase 17 Law

Most SSL tasks are **inspection and selection**, not cryptography.

---
