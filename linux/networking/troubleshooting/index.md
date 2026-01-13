# 🧭 Troubleshooting — Master Index

This index is the entry point for Linux networking troubleshooting material in kai-memory-palace.

This directory is not for theory.
It is for:
- failure modes
- recovery playbooks
- incident reports
- real-world break/fix procedures

---

## 🧠 Core mental model

Inspect state before testing behavior.

Always walk the diagnostic ladder:

Link → Address → Route → Listener → Name

If you skip steps, you will misdiagnose.

---

## 📚 Playbooks

- 📋 network-debugging-checklist.md  
  Canonical step-by-step diagnostic flow. Start here.

- 🧯 common-mistakes.md  
  Fast recovery patterns caused by bad assumptions and skipped steps.

- 📡 wifi-not-detected.md  
  No wireless interface appears at all.

- 🔌 usb-wifi-realtek-dkms.md  
  Realtek USB adapters, DKMS, kernel upgrades, and driver recovery.

- 🏷️ interface-renaming-with-udev.md  
  Make interface names stable and human-readable (e.g., tp-link).

---

## 🗂️ Incidents

Incidents are forensic-quality writeups of real failures.
Purpose:
- build pattern recognition
- avoid repeating investigations
- capture upgrade/hardware breakage scenarios

- 📁 incidents/2026-01-usb-wifi-broken-after-upgrade.md  
  Debian 13 upgrade broke Realtek USB WiFi; DKMS + udev recovery.

---

## 🧪 How to use this section

When something breaks:

1) Start with:
   network-debugging-checklist.md

2) If the failure matches a known class:
   jump to the relevant playbook

3) If this is new or weird:
   create a new incident report in incidents/

---

## ✍️ Contribution rule

Every painful failure becomes:
- either a new playbook
- or a new incident report

Nothing is allowed to be learned twice.

---

## ✅ Exit criteria

This section is working when:
- you no longer panic during outages
- failures feel classifiable
- recovery feels procedural, not emotional

You are not fixing networks.
You are operating a diagnostic system.
EOF

