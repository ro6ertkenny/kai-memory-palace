Posted on 01.13.26
# 🗺️ LFCS Practice Scenarios — Next Steps Roadmap

## 🎯 Purpose

This file exists to:

- prevent random scenario sprawl
- preserve a deliberate learning sequence
- document **what should be added next and why**
- keep the practice wing **focused and high-signal**

---

## 🧠 Rule

> **Do not add new scenarios until the current core set is automatic.**

The current core set is:

- Scenario A — System feels slow
- Scenario B — Disk is full
- Scenario C — Service is down
- Scenario D — Process won’t die
- Scenario E — CPU is pegged

You should be able to walk through all five **without hesitation**.

---

## 🧭 Next Logical Core Expansions

When the above are truly mastered, the next scenarios to add are:

### 1) 🧠 Memory Pressure

Proposed scenario:

- “The system is swapping / OOM killing things”

Teaches:

- free vs available
- RSS vs VSZ
- OOM behavior
- memory triage and attribution

---

### 2) 📂 Inode Exhaustion

Proposed scenario:

- “Disk has space but writes still fail”

Teaches:

- df -i vs df -h
- what inodes are
- millions-of-small-files failure mode
- how to locate inode leaks

---

### 3) 🔐 Permission Denied

Proposed scenario:

- “Everything exists but nothing works”

Teaches:

- users vs groups
- ownership vs mode bits
- execute bit on directories
- sudo vs root vs service users

---

### 4) 🌐 Networking / DNS Failure

Proposed scenario:

- “The service is running but nobody can connect”

Teaches:

- is it listening?
- is the port open?
- is routing correct?
- is DNS broken?
- local vs remote failure modes

---

## ⚠️ Anti-Bloat Rule (Critical)

Before adding any new scenario, it must answer:

- “What unique failure pattern does this teach?”
- “What decision does this train that no other scenario trains?”

If the answer is “none”:

> **Do not add a new scenario. Refine an existing one.**

---

## 🏁 Philosophy

This wing is not a checklist.

It is a **decision training system**.

Fewer, deeper, automatic beats:
- more
- shallower
- forgotten

Always prefer mastery over coverage.
EOF

