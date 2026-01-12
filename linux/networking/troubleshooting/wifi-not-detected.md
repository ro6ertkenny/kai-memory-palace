# 📡 wifi-not-detected.md
When WiFi “disappears” (no wireless interface shows up)

---

## 🎯 Purpose

Recover when WiFi is not available because the wireless interface does not exist
(or exists but does not look like WiFi).

This covers failures like:

- “WiFi is gone after an update”
- nmcli device shows no wifi device
- ip link shows no wl* interface
- iw dev prints nothing
- USB dongle is plugged in but “nothing happens”

---

## 🧠 Mental Model

A “WiFi problem” is often not a WiFi problem.

It is usually one of these:

1. Hardware not detected (USB/PCI not enumerated)
2. Driver not loaded (kernel module missing)
3. Firmware missing (driver loads but device never comes up)
4. Interface blocked (rfkill / airplane mode)
5. NetworkManager not managing the device

Your job is to identify which layer is broken.

---

## ✅ Fast Triage (2 minutes)

### 1) Do we see a WiFi interface?

    ip -br link

Expected:
- you should see something like wlan0 or wlx<MAC> or a renamed interface (e.g., tp-link)

If you do NOT see any wireless-looking interface:
continue.

### 2) Does the kernel think any WiFi exists?

    sudo iw dev

Expected:
- At least one phy#... section and an Interface ... entry

If iw dev prints nothing:
this strongly suggests “no device (driver) is registered as wireless”.

---

## 🧱 Step 1 — Confirm the hardware is detected

### USB WiFi dongle

    lsusb
    lsusb -t

What you’re looking for:
- your adapter appears in lsusb
- in lsusb -t, the adapter should eventually show a Driver=... (not [none])

If you see your adapter but Driver=[none]:
that means hardware is present but the driver is not bound.

### Internal PCI WiFi

    lspci -k | grep -i -A3 -E 'network|wireless'

What you’re looking for:
- a “Network controller” device
- a “Kernel driver in use: ...” line

If you see the device but no “driver in use”:
the driver is missing or not binding.

---

## 🧱 Step 2 — Identify what driver SHOULD be used

Get vendor:product ID:

    lsusb

Example:
- 2357:0115

Then inspect:

    sudo lsusb -v -d 2357:0115 | head -n 80

---

## 🧱 Step 3 — Check whether the driver module is loaded

    lsmod | grep -E 'iwl|ath|rtl|rtw|brcm|mt76|cfg80211|mac80211'

If you already know the module:

    lsmod | grep -i <module-name>

---

## 🧱 Step 4 — Try loading the driver

    sudo modprobe <module-name>

Then re-check:

    sudo iw dev
    ip -br link
    nmcli device

---

## 🧱 Step 5 — Firmware check (very common after upgrades)

    sudo dmesg | grep -i -E 'firmware|iwlwifi|rtl|rtw|ath|brcm|mt76' | tail -n 200

If you see firmware load failures:
install the proper firmware package and reboot.

---

## 🧱 Step 6 — rfkill (device present but blocked)

Install if missing:

    sudo apt-get install -y rfkill

Check:

    rfkill list

Unblock:

    sudo rfkill unblock all

---

## 🧱 Step 7 — NetworkManager ownership

    nmcli device

If device shows unmanaged:

    nmcli device show <iface> | sed -n '1,120p'

---

## 🧪 Verification Checklist

    lsusb
    lsusb -t
    sudo iw dev
    ip -br link
    nmcli device

You should see:
- adapter detected
- driver bound
- interface exists
- NetworkManager sees wifi

---

## 🧯 Most Common Root Causes

- Kernel upgrade broke DKMS driver
- Wrong Realtek module loaded
- Firmware missing
- rfkill blocked
- Driver bound but not creating netdev

---

## 🔁 The “What changed?” Rule

Always ask:

- Did the kernel change?
- Did DKMS rebuild?
- Did the module name change?
- Did the interface name change?

---

## ✅ Exit Criteria

You are done when:

- sudo iw dev shows an interface
- nmcli device shows wifi
- You can connect and get an IP

EOF

