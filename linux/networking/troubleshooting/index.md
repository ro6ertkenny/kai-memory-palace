# 🧭 Troubleshooting — Master Index

This index is the **entry point** for all Linux networking troubleshooting
material in the kai-memory-palace.

This directory is not for theory.

It is for:
- failure modes
- recovery playbooks
- incident reports
- real-world break/fix procedures

---

## 🧠 Core Mental Model

> **Inspect state before testing behavior.**

Always walk the diagnostic ladder:

Link → Address → Route → Listener → Name

If you skip steps, you will misdiagnose.

---

## 📚 Playbooks

These are **structured recovery guides** for common real-world failures.

- 📋 `network-debugging-checklist.md`  
  The canonical step-by-step diagnostic flow. Start here.

- 🧯 `common-mistakes.md`  
  Patterns of failure caused by bad assumptions and skipped steps.

- 📡 `wifi-not-detected.md`  
  What to do when no wireless interface appears at all.

- 🔌 `usb-wifi-realtek-dkms.md`  
  Realtek USB adapters, DKMS, kernel upgrades, and driver recovery.

- 🏷️ `interface-renaming-with-udev.md`  
  Making interface names stable and human-readable (e.g., `tp-link`).

---

## 🗂️ Incidents

This directory contains **forensic-quality writeups** of real failures.

Purpose:
- build pattern recognition
- avoid repeating the same investigation twice
- capture upgrade and hardware breakage scenarios

- 📁 `incidents/2026-01-usb-wifi-broken-after-upgrade.md`  
  Debian 13 kernel upgrade broke Realtek USB WiFi; DKMS + udev recovery.

---

## 🧪 How To Use This Section

When something breaks:

1. Start with:
   → `network-debugging-checklist.md`

2. If the failure matches a known class:
   → Go to the relevant playbook

3. If this is new or weird:
   → Create a new incident report in `incidents/`

---

## ✍️ Contribution Rule

Every painful failure becomes:

- either a new playbook
- or a new incident report

Nothing is allowed to be “learned twice”.

---

## ✅ Exit Criteria

This section is working when:

- you no longer panic during outages
- failures feel classifiable
- recovery feels procedural, not emotional

You are not fixing networks.

You are **operating a diagnostic system**.
EOF

