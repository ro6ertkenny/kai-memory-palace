# 🖥️ libvirt VM Failures — Domain Playbook

Mental mode: Check service, check connectivity, inspect VM, check logs, fix cause.

This playbook is used when:

- virsh cannot connect
- A VM will not start
- A VM is stuck or unresponsive
- VM state is not what you expect

---

## 🎯 Objective

1) Confirm libvirt service is running
2) Confirm you can talk to the hypervisor
3) Inspect VM state
4) Identify why it will not start or run
5) Restore normal operation

---

## 🧠 Core Model

libvirt is:

- A service
- Managing VMs
- Controlled by virsh

If the service is down or you cannot connect, nothing else matters.

---

## 🧪 Entry Conditions

- virsh fails
- VM will not start
- VM is stuck
- VM state is unknown

---

## 🔎 Step 1 — Check libvirt Service

    systemctl status libvirtd || systemctl status virtqemud

If not running:

    sudo systemctl start libvirtd || sudo systemctl start virtqemud

---

## 🔌 Step 2 — Check virsh Connectivity

    virsh list --all

If that fails:

    virsh -c qemu:///system list --all

If still fails:

- Check groups:

      groups | grep -E 'libvirt|kvm'

- Re-login if needed

---

## 🧾 Step 3 — Inspect VM State

    virsh domstate <vm>
    virsh dominfo <vm>

---

## 🧯 Step 4 — If VM Will Not Start

Try:

    virsh start <vm>

If it fails, inspect logs:

    journalctl -u libvirtd --since "10 min ago" || true
    journalctl -u virtqemud --since "10 min ago" || true

Common LFCS-level causes:

- Storage path missing
- Permission issue
- libvirt service issue

---

## 🧨 Step 5 — If VM Is Stuck

Attempt clean shutdown:

    virsh shutdown <vm>

If unresponsive:

    virsh destroy <vm>

Then restart:

    virsh start <vm>

---

## ⛔ Operator Rules

- Always check the service first
- Prefer shutdown over destroy
- Treat destroy like pulling the power cord
- If virsh cannot connect, suspect service or permissions

---

## 🔁 Exit Criteria

- virsh can list VMs
- VM reaches running state
- Console or network access works
