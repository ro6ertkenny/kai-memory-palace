# ⚠️ Mistakes
## High-signal Linux mistakes worth documenting

Mental mode: Preventing repeat failures.

This file is intentionally short.
Only include mistakes that:
- you actually made
- cost time
- are likely to recur
- teach a durable operational rule

Do not turn this into a diary.

---

## Rule: Document sparingly
A mistake belongs here only if:
- it burned you more than once, or
- it is dangerous enough to prevent proactively

---

## Mistake: Editing files with sudo creates root-owned artifacts
Symptom:
- future edits fail without sudo
- tools behave inconsistently

Cause:
- you wrote files as root

Fix:
- repair ownership using chown
- prefer editing with correct permissions instead of escalating blindly

Operational rule:
- fix ownership before loosening permissions

---

## Mistake: chmod -R or chmod 777 as a “quick fix”
Symptom:
- things work temporarily
- security and stability degrade

Cause:
- permissions were changed without understanding ownership and directory semantics

Fix:
- inspect ownership and permissions first
- prefer targeted changes
- avoid recursion unless you know what will be affected

Operational rule:
- never use recursive chmod as troubleshooting

---

## Mistake: Restarting services without reading logs
Symptom:
- issue “goes away” briefly
- root cause persists
- failures return

Cause:
- you treated restart as diagnosis

Fix:
- inspect status
- read journal logs
- then restart
- then verify

Operational rule:
- inspection precedes action

---

## Mistake: Confusing connectivity with DNS
Symptom:
- IP ping works
- domain name fails
- applications report network errors

Cause:
- DNS resolution broken, not routing

Fix:
- test IP reachability
- test name resolution separately
- inspect resolver configuration

Operational rule:
- always split network tests into IP and DNS

---

## Mistake: Filling disk and chasing unrelated errors
Symptom:
- services fail unexpectedly
- writes fail
- package operations break

Cause:
- disk full causes cascading failures

Fix:
- check df early
- identify large directories
- clean responsibly

Operational rule:
- check disk space early in troubleshooting

---

## Mistake: Acting before verifying current state
Symptom:
- changes make the situation worse
- you lose evidence of the original failure

Cause:
- no baseline inspection

Fix:
- capture current state first
- then act deliberately

Operational rule:
- inspect → act → verify

---

## Add New Mistakes Here
When you add a new item, include:
- Symptom
- Cause
- Fix
- Operational rule
