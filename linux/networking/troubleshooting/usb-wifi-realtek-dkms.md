# 📶 usb-wifi-realtek-dkms.md
USB Realtek WiFi adapters on Debian using DKMS (repair + persistence)

---

## 🎯 Purpose

Recover when a **USB WiFi dongle** is detected by USB, but WiFi is missing after:

- a kernel upgrade
- a distro upgrade
- a reboot that removed the working driver

This doc focuses on **Realtek USB chipsets** that require **DKMS** drivers.

---

## 🧠 Mental Model

USB WiFi has a layered dependency chain:

1. USB enumerates the device (hardware exists)
2. A kernel module binds to it (driver attaches)
3. The driver registers a wireless PHY (cfg80211/mac80211)
4. A netdev interface appears (wlan0 / wlx<MAC> / renamed)
5. NetworkManager manages it (nmcli shows wifi)

If any link breaks, WiFi “disappears”.

---

## ✅ Identify the adapter (hardware present?)

### 1) Confirm it shows up on USB

    lsusb

Example (TP-Link Archer T4U v3):

    Bus 001 Device 003: ID 2357:0115 TP-Link Archer T4U ver.3

Record:
- idVendor:idProduct (example: 2357:0115)
- manufacturer / product strings (often show Realtek)

### 2) Confirm whether a driver is bound

    lsusb -t

Interpretation:

- Driver=[none]  → device exists, **no driver bound**
- Driver=rtl88x2bu (or similar) → driver bound successfully

---

## ✅ Check whether WiFi exists at the kernel level

### 1) Do we have a wireless interface?

    ip -br link

You want to see:
- wlan0
- wlx<MAC>
- or a renamed interface (example: tp-link)

### 2) Does the kernel see a WiFi PHY?

    sudo iw dev

If this prints nothing:
- the driver is not registering as wireless (no PHY)

---

## ✅ Typical Realtek DKMS outcomes

Realtek USB drivers often show up as one of these module names:

- 88XXau (common for 8812au/8821au family)
- 88x2bu / rtl88x2bu (common for 8812bu/8822bu family)

You can see which DKMS modules exist:

    sudo dkms status

Example interpretation:
- installed for this kernel version → should be loadable
- installed for an older kernel only → must rebuild

---

## 🧱 DKMS prerequisites (must be present)

    sudo apt-get update
    sudo apt-get install -y dkms git build-essential linux-headers-$(uname -r)

If headers are missing, DKMS will not build.

---

## 🧱 Verify the built module exists for THIS kernel

List DKMS-built modules for the running kernel:

    ls /lib/modules/$(uname -r)/updates/dkms/

You should see files such as:
- 88XXau.ko.xz
- 88x2bu.ko.xz

If this directory is empty:
- DKMS did not install into this kernel
- rebuild is required

---

## 🧱 Load the module correctly (module names matter)

Common mistake:
- modprobe 8812au
- modprobe rtl8812au

Those names often do NOT exist as loadable module names.

Instead, load the module that matches the built .ko file.

### 1) Load AU-family driver

    sudo modprobe 88XXau

### 2) Load BU-family driver

    sudo modprobe 88x2bu

Confirm it loaded:

    lsmod | grep -E '88XXau|88x2bu'

Then confirm WiFi appears:

    sudo iw dev
    ip -br link
    nmcli device

---

## 🧱 If you need to switch drivers (AU vs BU)

Unload the wrong one:

    sudo modprobe -r 88XXau || true
    sudo modprobe -r 88x2bu || true

Then load the other.

Important:
- only one should be active for the same device
- choose the one that binds in lsusb -t

---

## 🧪 Binding verification (the definitive proof)

    lsusb -t

You want to see your dongle with a driver:

- Driver=rtl88x2bu
- or Driver=rtl88XXau

If it stays Driver=[none]:
- wrong driver
- driver failed to bind
- device needs a different chipset driver

---

## 🧱 Rebuild DKMS after a kernel upgrade

Kernel upgrades frequently cause the working WiFi to vanish until DKMS rebuilds.

Rebuild all modules:

    sudo dkms autoinstall

Or rebuild a specific module/version (example format):

    sudo dkms install -m 88x2bu -v <version>

Then:

    sudo depmod -a
    sudo reboot

---

## 🧱 Persistent autoload at boot

If the module loads manually but not after reboot,
create a modules-load file.

Example for BU:

    echo 88x2bu | sudo tee /etc/modules-load.d/usb-wifi.conf

Example for AU:

    echo 88XXau | sudo tee /etc/modules-load.d/usb-wifi.conf

Reboot and verify:

    lsmod | grep -E '88XXau|88x2bu'
    nmcli device

---

## 🧯 Common failure patterns

### “DKMS says installed but modprobe fails”
Often:
- wrong module name used
- built module file name differs from dkms module name

Always prefer:
- the module name in the .ko filename under updates/dkms

### “Driver loads but no WiFi interface”
Check:

    sudo iw dev

If empty:
- driver loaded but not registering wireless
- wrong module for the chipset

### “WiFi exists but NetworkManager doesn’t show it”
Check:

    nmcli device

If unmanaged:
- check NM config and udev rules
- check interface renaming issues

---

## ✅ Exit Criteria

You are done when:

- lsusb -t shows Driver=rtl88x2bu (or rtl88XXau)
- sudo iw dev shows a phy# and an Interface
- ip link shows a WiFi netdev
- nmcli device shows wifi connected

EOF

