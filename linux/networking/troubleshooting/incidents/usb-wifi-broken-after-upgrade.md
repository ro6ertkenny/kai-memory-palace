# 🚨 Incident Report — USB WiFi Broken After Debian 13 Upgrade (01.12.26)

## 📌 Summary

After upgrading Debian 13, the USB WiFi adapter (TP-Link Archer T4U v3 / Realtek) **disappeared from the system**:

- No `wlan` interface present
- No WiFi device in `ip link`
- No device in `iw dev`
- Adapter still visible in `lsusb`
- Network completely offline except Ethernet

Root cause: **Kernel upgrade broke the out-of-tree Realtek driver** and the wrong module was being loaded.

---

## 🖥️ Environment

- OS: Debian 13 (Trixie)
- Kernel: 6.12.x
- Adapter: TP-Link Archer T4U v3
- Chipset: Realtek (USB)
- Repo: kai-memory-palace
- Location: Home workstation

---

## 🧨 Symptoms

- `ip link` → no wlan device
- `iw dev` → empty
- `nmcli device` → no WiFi device
- `lsusb` → device present (2357:0115)
- `lsusb -t` → Driver = none
- `dmesg` → device enumerates, no network driver binds

---

## 🧠 Key Observation

USB device is present:

    lsusb

But no network interface is created:

    ip link
    iw dev

This means:

> The **driver is missing or not binding**.

---

## 🔎 Investigation Steps

### 1. Identify USB device

    lsusb
    lsusb -v -d 2357:0115

Confirmed:

- Vendor: TP-Link / Realtek
- Product: 802.11ac NIC

---

### 2. Check which drivers are loaded

    lsmod | grep -i 88
    lsmod | grep -i rtl

Found:

- Multiple Realtek DKMS drivers installed:
  - 88XXau
  - 88x2bu

---

### 3. Check DKMS status

    sudo dkms status

Found:

- Both modules were installed
- Wrong one was being used

---

### 4. Inspect DKMS output directory

    ls /lib/modules/$(uname -r)/updates/dkms/

Found:

    88XXau.ko.xz
    88x2bu.ko.xz

---

## 🔥 The Fix

### 1. Remove the wrong driver

    sudo modprobe -r 88XXau

---

### 2. Load the correct driver

    sudo modprobe 88x2bu

---

### 3. Verify

    lsmod | grep 88
    lsusb -t
    ip link
    iw dev
    nmcli device

Now shows:

- Driver: `rtl88x2bu`
- Interface appears: `wlx...`
- WiFi connects successfully

---

## 🧱 Final Stabilization

### Rename interface to stable name

Created udev rule:

    /etc/udev/rules.d/70-tplink-wifi.rules

Rule:

    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="14:eb:b6:8f:08:7a", NAME="tp-link"

After reboot:

    ip link

Shows:

    tp-link

NetworkManager:

    nmcli

Shows:

    tp-link connected

---

## 🧠 Root Cause

- Kernel upgrade invalidated or mismatched the Realtek DKMS driver
- Wrong module (`88XXau`) was loading
- Correct module is `88x2bu`
- System had **multiple Realtek drivers installed**
- The wrong one bound (or none bound)

---

## 🧯 Lessons Learned

1. USB device present ≠ driver working
2. Always check:

       lsusb -t
       lsmod
       dkms status

3. DKMS systems can accumulate **conflicting drivers**
4. Kernel upgrades frequently break **out-of-tree drivers**
5. Stable interface naming avoids future chaos

---

## 🧭 Canonical Debugging Ladder Used

1. Is the device visible? → lsusb ✅
2. Is a driver bound? → lsusb -t ❌
3. Is a module loaded? → lsmod ⚠️ (wrong one)
4. Is DKMS installed? → dkms status ⚠️ (conflict)
5. Force correct driver → modprobe 88x2bu ✅
6. Interface appears → ip link / iw dev ✅
7. Stabilize name → udev rule ✅

---

## ✅ Final State

- Interface: `tp-link`
- Driver: `rtl88x2bu`
- Autoloaded at boot
- Network stable
- Reboot safe

---

## 🏷️ Tags

- usb
- wifi
- realtek
- dkms
- debian
- kernel-upgrade
- driver
- udev
- incident

