# 🧭 dns-and-name-resolution.md — Understanding How Names Become Addresses

## 🎯 Purpose
Understand **how hostnames are resolved to addresses** and why name lookup fails.

This file trains habits for:
- inspecting name resolution behavior
- distinguishing DNS failures from connectivity failures
- diagnosing “it works by IP but not by name” problems
- understanding where resolution decisions come from

If names do not resolve, traffic never starts.

---

## 🧠 Mental Rule
**No name, no connection.**

If a hostname cannot be resolved, routing and ports do not matter.

---

## 🧩 What Name Resolution Is
Name resolution translates:
- hostnames → IP addresses

This process may involve:
- local files
- DNS servers
- system services
- caches

Resolution happens before any network traffic is sent.

---

## 🔎 Resolution Order
Linux resolves names according to configuration.

Common resolution sources:
- /etc/hosts
- DNS
- local caches
- system resolver services

The order matters.  
The first match wins.

---

## 📄 Local Overrides
The hosts file can override DNS.

Key properties:
- entries in /etc/hosts take precedence
- useful for testing
- dangerous if forgotten

Always check local overrides when resolution behaves oddly.

---

## 🌍 DNS Servers
DNS queries are sent to configured servers.

Things to inspect:
- which servers are configured
- whether they are reachable
- whether they respond correctly

Incorrect DNS configuration causes widespread failure.

---

## 🧪 Testing Name Resolution
After inspection, test resolution.

Common tools:
- dig
- nslookup
- getent hosts

Use these to answer:
- does the name resolve
- which address is returned
- whether multiple records exist

Test names before testing connectivity.

---

## 🔁 Caching and Staleness
Resolution results may be cached.

Common causes of confusion:
- stale DNS entries
- local resolver caches
- application-level caching

If results differ over time, caching is likely involved.

---

## 🧯 Common Resolution Failures
- DNS server unreachable
- incorrect search domains
- stale cache entries
- hosts file overrides
- split-horizon DNS behavior

Always inspect before flushing caches.

---

## 🧪 Daily Drill (5 minutes)
On a running system:

- inspect resolver configuration
- resolve a known hostname
- resolve a nonexistent hostname
- explain where the failure occurs

Do not change configuration.

---

## ✅ Exit Criteria
You are done with this file when:
- name resolution feels predictable
- IP vs name failures are obvious
- DNS issues stop masquerading as network issues

You now understand name resolution.
