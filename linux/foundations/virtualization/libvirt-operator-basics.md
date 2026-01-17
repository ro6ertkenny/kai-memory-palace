# 🖥️ libvirt & KVM — Operator Basics (LFCS-Level)

Mental mode: Check service, list VMs, start/stop, inspect, verify networking, move on.

LFCS does not test virtualization architecture. It tests **basic operational control** of libvirt/KVM:

- Is libvirt running?
- Can you list VMs?
- Can you start/stop them?
- Can you confirm their state and console?
- Can you confirm they have networking?

---

## 🧠 The One Mental Model

libvirt is:

- A **service** (libvirtd / virtqemud depending on distro)
- Managing **hypervisors** (KVM/QEMU)
- Controlled primarily with:

    virsh

If libvirt is down, nothing works.

---

## 🎯 LFCS Operator Goals

You must be able to:

- Check libvirt service status
- List all VMs
- Start and stop a VM
- Check VM state
- Access console
- Confirm basic networking mode (usually NAT)
- Set or check autostart

---

## 🔎 Core Commands (Must Be Automatic)

Check service:

    systemctl status libvirtd || systemctl status virtqemud

List VMs:

    virsh list --all

Start / stop:

    virsh start <vm>
    virsh shutdown <vm>
    virsh destroy <vm>   # hard power-off (last resort)

Check VM state:

    virsh domstate <vm>
    virsh dominfo <vm>

Console access:

    virsh console <vm>
    # exit console with: Ctrl + ]

Autostart:

    virsh autostart <vm>
    virsh autostart --disable <vm>

---

## 🗂️ Connection URI (When Needed)

On some systems you must specify the system connection:

    virsh -c qemu:///system list --all

If plain `virsh` fails, retry with the URI.

---

## 🧪 Standard Operator Workflow

### Step 1 — Is libvirt running?

    systemctl status libvirtd || systemctl status virtqemud

If not running:

    sudo systemctl start libvirtd || sudo systemctl start virtqemud

---

### Step 2 — Can you see the VMs?

    virsh list --all

If this fails, try:

    virsh -c qemu:///system list --all

---

### Step 3 — Start a VM

    virsh start <vm>

Verify:

    virsh list

---

### Step 4 — Check state

    virsh domstate <vm>
    virsh dominfo <vm>

---

### Step 5 — Access console (if needed)

    virsh console <vm>

Exit:

    Ctrl + ]

---

### Step 6 — Shutdown cleanly

    virsh shutdown <vm>

If it is stuck:

    virsh destroy <vm>

---

## 🌐 Basic Networking Reality (LFCS Level)

Most default setups use **NAT** via libvirt’s default network.

You should be able to verify:

    virsh net-list --all

And inspect:

    virsh net-info default

Inside the VM, networking is checked using normal Linux tools:

    ip a
    ip r

---

## 🧯 Common Failure Patterns

### 1) virsh cannot connect

Symptoms:

- Permission denied
- Cannot connect to hypervisor

Checks:

    groups | grep -E 'libvirt|kvm'
    systemctl status libvirtd || systemctl status virtqemud

Fix:

- Ensure user is in libvirt/kvm group
- Ensure service is running
- Re-login after group change

---

### 2) VM will not start

Checks:

    virsh dominfo <vm>
    journalctl -u libvirtd --since "10 min ago" || true
    journalctl -u virtqemud --since "10 min ago" || true

At LFCS level, this is usually:

- Storage path missing
- Permission issue
- libvirt service issue

---

## 🔗 Relationship To Your Existing Docs

- This file is the **operator control surface**
- The build procedure lives in:

      linux/foundations/virtualization/kvm-ubuntu-server-lts-vm.md

Use that file to create VMs.
Use this file to **operate** them.

---

## 🧪 LFCS Practice Drills

### Drill 1 — Cold control

1) List all VMs
2) Start one
3) Check state
4) Access console
5) Shutdown cleanly

You should be able to do this **without thinking**.

---

### Drill 2 — Service dependency

1) Stop libvirt service
2) Observe virsh failure
3) Start service
4) Re-run virsh commands

Goal: build reflex that libvirt is just another service dependency.

---

## ⛔ Operator Rules

- Prefer `shutdown` over `destroy`
- Treat `destroy` like pulling the power cord
- Always verify state with `virsh domstate` or `virsh list`
- If virsh cannot connect, suspect:
  - Service down
  - Permission/group issue
  - Wrong connection URI

---

## 🏁 Exit Criteria (You Are Done When)

- You can control any existing VM with:
  - list, start, stop, inspect, console
- You know where to look when virsh cannot connect
- You understand that this is **service + tooling**, not magic

