# 🧯 Networking Troubleshooting — README
Systematic recovery when the network is broken

---

## 🎯 Purpose

This directory exists for failure mode.

Not for learning how networking works.
Not for configuration tutorials.

This is for:

“Something is broken. How do I recover correctly and fast?”

It provides:
- diagnostic order
- proven checklists
- failure pattern recognition
- real recovery playbooks

---

## 🧠 Mental Mode

State-first, hypothesis-driven debugging.

You do not guess.
You do not randomly try commands.
You do not skip layers.

You:

Inspect → Explain → Predict → Fix → Verify

---

## 🪜 The Diagnostic Ladder

All networking failures reduce to a broken rung somewhere in this ladder:

1. Link — does the interface exist and is it up?
2. Address — does it have the expected IP?
3. Route — does traffic know where to go?
4. Listener — is something actually listening?
5. Name — does DNS resolve correctly?

You never skip rungs.
You never debug higher layers before lower ones.

---

## 🗂️ What Belongs Here

This directory contains:

- Checklists  
  Step-by-step recovery flows

- Failure Playbooks  
  “If WiFi disappears after update, do this.”

- Pattern Libraries  
  “This symptom usually means this layer is broken.”

- Case Studies  
  Real incidents, real fixes, real lessons

---

## 🚫 What Does NOT Belong Here

This directory is not for:

- conceptual networking explanations
- how routing works
- what DNS is
- what an interface is

Those live in:

linux/networking/

This directory is strictly:

“It’s broken. Fix it.”

---

## 🧱 Relationship to Other Wings

- linux/networking/  
  Explains how networking works

- linux/foundations/  
  Explains processes, files, permissions, state

- linux/filesystems-and-storage/  
  Explains storage and mount state (often involved in failures)

Troubleshooting sits on top of all of them.

---

## ▶️ How To Use This Directory

When something is broken:

1. Start with:
   - network-debugging-checklist.md
2. Identify the failing layer
3. Jump to the relevant playbook:
   - WiFi
   - USB devices
   - Drivers
   - Routing
   - Naming
4. Follow the steps in order
5. Do not improvise

---

## ✅ Outcome

You are done with this directory when:

- failures feel explainable
- recovery feels systematic
- “weird networking issues” stop being mysterious
- you always know what to check next

That is operational confidence.

---
EOF

