# Ubuntu Post-Update Failure Recovery — NVIDIA + DHCP + NetworkManager
Path: linux/troubleshooting/ubuntu-post-update-nvidia-network-failure.md

# Objective

Diagnose and recover a Linux workstation after an Ubuntu update caused:

- Broken networking
- NVIDIA fallback graphics mode
- 1024x768 low-resolution display
- Failed internet access
- Failed USB tethering
- Suspected driver/kernel corruption

System:
- Ubuntu 24.04
- Kernel: 6.17.0-29-generic
- GPU: NVIDIA GeForce GTX 1080
- NIC: Intel I219-V (e1000e driver)

---

# Initial Symptoms

Observed:

- Display stuck at 1024x768
- Ethernet appeared broken
- USB tethering failed
- `apt-get` unable to reach repositories
- General suspicion of catastrophic Ubuntu update failure

Initial assumption:
- NVIDIA DKMS failure
- Kernel regression
- Secure Boot interference
- Broken NIC driver

---

# Diagnostic Flow

## 1. Verify Current Kernel

Command:

    uname -r

Result:

    6.17.0-29-generic

Purpose:
- Verify active kernel after update
- Correlate against installed NVIDIA modules

---

## 2. Check Loaded GPU/NIC Modules

Command:

    lsmod | grep -E 'nvidia|amdgpu|i915|r8169|rtl|iwlwifi'

Initial Result:
- No active NVIDIA modules shown

Interpretation:
- Suspected fallback framebuffer mode
- Suspected failed NVIDIA initialization

---

## 3. Enumerate Hardware + Drivers

Command:

    lspci -nnk

Important Findings:

### NIC

    Intel Ethernet Connection (2) I219-V
    Kernel driver in use: e1000e

Interpretation:
- NIC hardware healthy
- Correct driver loaded

### GPU

    NVIDIA GeForce GTX 1080

Interpretation:
- GPU detected by PCI subsystem
- Hardware healthy

---

## 4. Review Kernel Messages

Command:

    sudo dmesg -T | grep -Ei 'firmware|failed|nvidia|amdgpu|iwlwifi|rtl|eth|network'

Important Findings:

    e1000e: Intel(R) PRO/1000 Network Driver

Interpretation:
- NIC driver initialized successfully
- Network hardware functioning

---

# Network Isolation Process

## 5. Inspect Interfaces

Command:

    ip a

Findings:

    eno1: UP LOWER_UP

Interpretation:
- Physical Ethernet link established
- Cable + NIC functioning

---

## 6. Inspect Routing Table

Command:

    ip r

Initial Result:
- Empty output

Interpretation:
- No default route
- No DHCP lease acquired

---

## 7. Connectivity Test

Command:

    ping -c 3 8.8.8.8

Result:

    Network is unreachable

Interpretation:
- Not DNS
- No routing/gateway present

---

## 8. Inspect NetworkManager State

Command:

    nmcli device status

Result:

    eno1 ethernet connecting (getting IP configuration)

Interpretation:
- DHCP acquisition failure
- NetworkManager operational
- Driver operational
- Interface operational

Root issue narrowed to:
- DHCP lease acquisition failure

---

# Recovery Actions

## 9. Restart Networking Stack

Commands:

    sudo nmcli networking off
    sudo nmcli networking on
    sudo systemctl restart NetworkManager

Purpose:
- Reset NetworkManager state
- Force DHCP renegotiation

---

## 10. Force Interface Disconnect/Reconnect

Commands:

    sudo nmcli device disconnect eno1
    sudo nmcli device connect eno1

Initial Result:

    IP configuration could not be reserved

Interpretation:
- DHCP server not responding properly

---

## 11. Router/Modem Reboot

Physical Action:

- Power cycle modem
- Power cycle router
- Wait full boot cycle

Interpretation:
- Clear stale DHCP lease state
- Reset ARP/DHCP tables

---

## 12. Reconnect Interface Again

Command:

    sudo nmcli device connect eno1

Result:

    Device 'eno1' successfully activated

Interpretation:
- DHCP lease acquired successfully
- Network restored

---

# NVIDIA Verification

## 13. Verify NVIDIA Driver State

Command:

    nvidia-smi

Result:

    NVIDIA-SMI 580.159.03
    Driver Version: 580.159.03
    CUDA Version: 13.0

Processes:

    /usr/lib/xorg/Xorg
    /usr/bin/gnome-shell

Interpretation:

- NVIDIA kernel module loaded
- Xorg GPU acceleration active
- GNOME rendering through NVIDIA
- CUDA operational
- Driver healthy

---

# Secure Boot Verification

## 14. Verify Secure Boot Status

Command:

    mokutil --sb-state

Result:

    SecureBoot disabled
    Platform is in Setup Mode

Interpretation:
- Secure Boot not blocking NVIDIA modules
- No signature enforcement issues

---

# Package Cleanup

## 15. Remove Old Kernel/NVIDIA Artifacts

Command:

    sudo apt-get autoremove

Removed:
- old 6.17.0-22 kernel modules
- old NVIDIA 535 firmware remnants

Interpretation:
- Normal cleanup after successful upgrade
- System transitioned to NVIDIA 580 stack

---

# Final System State

## Networking

Verified:

    ping -c 3 google.com

Result:
- Internet functional
- DNS functional
- Routing functional

---

## Routing

Verified:

    ip r

Result:
- Default route restored

---

## GPU

Verified:

    nvidia-smi

Result:
- NVIDIA fully operational

---

## Installed Kernels

Verified:

    dpkg -l | grep linux-image

Installed:
- 6.17.0-23-generic
- 6.17.0-29-generic

Interpretation:
- Current kernel present
- One fallback kernel retained
- Healthy kernel management state

---

# Final Diagnosis

Primary Root Cause:

- DHCP acquisition failure after Ubuntu update/router state conflict

Secondary Symptoms:

- Temporary NVIDIA fallback graphics state
- Low-resolution display
- NetworkManager confusion
- Failed tethering attempts

NOT caused by:

- Dead GPU
- Dead NIC
- Dead motherboard
- Catastrophic kernel corruption

---

# Critical Operator Lessons

## Fast Diagnostic Commands

Use immediately during future incidents:

    nvidia-smi
    ip a
    ip r
    nmcli device status

These rapidly isolate:
- GPU state
- Interface state
- Routing state
- DHCP state
- NetworkManager state

---

# Key Observations

## LOWER_UP Meaning

From:

    ip a

Meaning:
- Physical link detected
- Cable electrically connected
- NIC hardware operational

---

## Empty `ip r` Meaning

From:

    ip r

Meaning:
- No default route
- DHCP failed
- No gateway assigned

---

## `getting IP configuration`

From:

    nmcli device status

Meaning:
- NetworkManager functioning
- DHCP negotiation failing

---

# Final Operational Conclusion

System fully recovered.

Verified healthy:

- Ubuntu kernel
- NVIDIA driver stack
- CUDA stack
- Intel NIC
- NetworkManager
- DHCP routing
- DNS
- Xorg GPU acceleration

This incident represented:
- post-update network/DHCP instability
- temporary NVIDIA initialization instability

NOT hardware failure.
