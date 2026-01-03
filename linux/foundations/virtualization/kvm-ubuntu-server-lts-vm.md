# 🧰 KVM + Ubuntu Server LTS VM Setup (LFCS + CKA Lab Baseline)

Purpose: Create a clean, reproducible Ubuntu Server VM on a Linux workstation using KVM/libvirt/virt-manager for LFCS-first training (and later CKA).  
Style: minimal, predictable, snapshottable, SSH-first workflow.

---

## ✅ Target Outcome (Done Criteria)

You are “ready to practice” when:

- KVM is active (kernel modules loaded)
- libvirt is running and accessible as your user
- Ubuntu Server installs cleanly and boots without the ISO attached
- You can SSH into the VM from the host
- A snapshot named `baseline-clean` exists (internal snapshot)
- The VM is updated and has the LFCS baseline toolset installed

---

## 0) Host Pre-flight (Virtualization Support)

Check CPU virtualization flags:

    egrep -c '(vmx|svm)' /proc/cpuinfo

- 0  → virtualization not enabled (BIOS/UEFI setting)
- 1+ → OK

Optional sanity:

    lscpu | grep -i virtualization || true

---

## 1) Install KVM + libvirt + virt-manager (Host)

Install:

    sudo apt-get update
    sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils ovmf

Enable libvirt:

    sudo systemctl enable --now libvirtd
    sudo systemctl status libvirtd --no-pager

---

## 2) Fix Host Permissions (Critical)

Add your user to required groups:

    sudo usermod -aG libvirt,kvm "$USER"

IMPORTANT: log out of your desktop session fully and log back in (GUI apps require this).

Verify:

    groups | tr ' ' '\n' | egrep 'libvirt|kvm' || true

Validate libvirt connectivity:

    virsh -c qemu:///system list --all

Check KVM modules loaded:

    lsmod | grep kvm || true

---

## 3) Download Ubuntu Server LTS ISO (Hard Lesson Learned)

We hit repeated 404s due to shifting ISO paths/mirror layouts.  
The stable approach is: use the Ubuntu “noble” directory listing filename that exists now.

Recommended (Ubuntu Server 24.04.x LTS; file name may change with point releases):

    mkdir -p ~/iso
    cd ~/iso
    wget -4 https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.iso

Verify (must NOT be 0 bytes):

    ls -lh ~/iso/ubuntu-24.04.3-live-server-amd64.iso
    file ~/iso/ubuntu-24.04.3-live-server-amd64.iso

Expected:
- Size is multiple GB (not 0)
- File reports: “ISO 9660 CD-ROM filesystem data … (bootable)”

If you accidentally created a 0-byte ISO earlier, remove it:

    rm -f ~/iso/*.iso

---

## 4) Create the VM (virt-manager)

Launch:

    virt-manager

Create new VM:
- Local install media (ISO)
- Select: /home/<you>/iso/ubuntu-24.04.3-live-server-amd64.iso (or your current noble ISO)
- OS: Ubuntu 24.04 (or closest match)

Recommended resources:
- RAM: 4 GB minimum (8 GB preferred)
- CPU: 2 vCPU minimum (4 preferred)
- Disk: 25–40 GB (25 GB is sufficient; 40 GB is comfortable)
- Network: NAT (default libvirt) is fine

Before install (Customize):
- Disk bus: VirtIO
- NIC model: VirtIO
- Boot order: CDROM first (for installation)

---

## 5) Ubuntu Server Install Choices (Exam-Aligned)

Storage:
- Use entire disk
- LVM enabled
- NO LUKS encryption (avoid unnecessary friction during training)

Ubuntu Pro:
- Skip

SSH:
- Install OpenSSH server
- Allow password authentication (OK for a local lab VM)

Featured snaps:
- Install none (keep baseline clean and predictable)

---

## 6) Post-Install Boot Issue (Hard Lesson Learned)

If reboot shows:
“FAILED unmounting /cdrom” and “remove installation medium”

Cause:
- ISO still attached as virtual CDROM.

Fix:
- In virt-manager: power off VM → Details → CDROM → set to Empty / disable / remove → boot again.

This tests:
- boot media vs installed OS
- recognizing harmless systemd failures
- knowing when to detach a device

---

## 7) Snapshot Strategy (Hard Lesson Learned)

Snapshot Mode:
- Choose INTERNAL snapshots (simple, robust for training).

Snapshot plan:
1) `baseline-clean`  → immediately after first successful boot (before updates/tools)
2) `post-tools`      → after OS update + baseline tooling
3) milestone snapshots per week (e.g., `lfcs-week-2-complete`)

Why snapshot before tools:
- Preserves a “factory-fresh” rollback point to re-practice setup and recover from break/fix mistakes.

---

## 8) SSH Workflow + Host Key Reality

SSH target selection mental model:
- SSH to an IPv4 on a non-loopback interface with `scope global`.

Get VM IP (inside VM):

    ip addr

SSH from host:

    ssh ro6ert@<VM_IP>

First connect prompt:
- Accepting host authenticity prompt is normal on first connect.

If you revert snapshots and SSH warns “host identification has changed”:
- host keys changed due to rollback (expected in lab VMs).

Fix on host:

    ssh-keygen -R <VM_IP>
    ssh ro6ert@<VM_IP>

Key takeaway:
- Host keys are identity, not authentication.
- `ssh-keygen -R` removes stale identity data from `known_hosts`.

---

## 9) Phase 2 — Bring the VM Up to Date (Guest)

Inside the VM:

    sudo apt-get update
    sudo apt-get upgrade -y

If kernel updates, reboot:

    sudo reboot

---

## 10) Phase 3 — Install LFCS Baseline Toolset (Guest)

Inside the VM:

    sudo apt-get install -y \
      vim \
      curl wget \
      git \
      tree \
      jq \
      net-tools \
      dnsutils \
      iproute2 \
      iputils-ping \
      traceroute \
      tcpdump \
      unzip \
      tar gzip bzip2 xz-utils \
      ca-certificates \
      gnupg \
      lsb-release

Quick sanity:

    vim --version | head -n 1
    ip addr
    ss -lntp | head
    dig +short google.com
    systemctl status ssh --no-pager
    df -h /
    lsblk

---

## 11) Create `post-tools` Snapshot (Host)

After Phase 2 + Phase 3 complete:
- Create internal snapshot named `post-tools`.

---

## ✅ Final “Ready to Rock” Checklist

- [ ] `virsh -c qemu:///system list --all` works on host
- [ ] VM boots without ISO attached
- [ ] SSH works from host to VM
- [ ] Snapshots exist: `baseline-clean`, `post-tools`
- [ ] VM updated and baseline tools installed

---

## 📌 Where this file lives in kai-memory-palace

- linux/foundations/virtualization/kvm-ubuntu-server-lts-vm.md


