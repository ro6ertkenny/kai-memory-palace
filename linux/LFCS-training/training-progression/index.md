# 🧱 Training Progression — Index (LFCS)

**Path:** `linux/LFCS-training/training-progression/index.md`  
Purpose: Provide the **canonical navigation surface** for the LFCS Building Blocks curriculum.

This directory defines the **only supported learning order**.

---

## 🧠 How This Directory Fits

This is the **curriculum control layer**.

- Drills live elsewhere
- Playbooks live elsewhere
- Scenarios live elsewhere

This directory defines:

- order
- dependency
- scope
- gates

---

## 🧱 The Building Blocks (Canonical Order)

You must follow these **in order**.

01  building-block-1-shell-and-safety.md  
02  building-block-2-files-and-text.md  
03  building-block-3-permissions-and-identity.md  
04  building-block-4-process-model.md  
05  building-block-5-logs-and-observation.md  
06  building-block-6-services-and-systemd.md  
07  building-block-7-service-configuration.md  
08  building-block-8-networking.md  
09  building-block-9-scheduling-and-automation.md  
10  building-block-10-storage-fundamentals.md  
11  building-block-11-storage-recovery.md  
12  building-block-12-package-management.md  
13  building-block-13-security-and-selinux.md  
14  building-block-14-tls-and-certificates.md  
15  building-block-15-containers-and-virtualization.md  
16  building-block-16-git-as-an-operator-tool.md  
17  building-block-17-incident-response.md  
18  building-block-18-exam-readiness-and-integration.md  

---

## 🧱 Contract: What Every Building Block Must Contain

Every Building Block must explicitly define:

- Linked **execution drills**
- Linked **failure scenarios**
- Linked **execution playbook(s)**
- Explicit **exit criteria**

If any of these are missing, the block is **incomplete**.

---

## 🧭 How You Advance

For each Building Block:

1) Run the referenced drills until mechanics are automatic  
2) Run the referenced playbooks end-to-end  
3) Run the referenced failure scenarios as timed exercises  
4) Pass the exit criteria  
5) Only then advance

---

## 🧠 Regression Rule

If any later block exposes weakness:

> You must return to the earlier block and re-earn the gate.

---

## 🎯 Design Goal

This progression is designed so that:

- There are no gaps
- There is no redundancy
- There is no “topic soup”
- There is only **increasing operator competence**

---

## 🧠 Core Rule

> **The order is not negotiable. The gates are not optional.**

