# 🔤 interface-renaming-with-udev.md — Pinning Stable Network Interface Names

## 🎯 Purpose

Ensure **critical network interfaces always have predictable, stable names**.

This file exists to:
- stop interface names from changing across reboots or kernel updates
- prevent config breakage due to renamed devices
- teach how udev actually names interfaces
- show how to pin a name using MAC address rules
- make interface identity **explicit and controlled**

If an interface name changes, your system did not change — your **assumptions** did.

---

## 🧠 Mental Model

The kernel does not care about human-friendly names.

Interface naming is done by:

- udev
- systemd link rules
- predictable naming schemes
- and finally, your custom overrides

You are not renaming an interface.

You are **declaring identity rules**.

---

## 🧱 The Problem This Solves

Symptoms:
- Your WiFi was `wlan0`, then `wlx14ebb68f087a`
- After an update, the name changes again
- NetworkManager profiles stop working
- Scripts break
- You start debugging the wrong layer

Root cause:
- The name is **derived**, not guaranteed.

---

## 🧬 Where Interface Names Come From

Modern Linux prefers **predictable names** based on:

- PCI path
- USB path
- MAC address

Examples:
- enp0s31f6
- enx7085c2a260cd
- wlx14ebb68f087a

These are **descriptions**, not contracts.

---

## 🔍 Inspect the Current Interface

Find the real interface name:

    ip link

Or:

    nmcli device

Or:

    iw dev

You will see something like:

    wlx14ebb68f087a

That long name is derived from the MAC address.

---

## 🧱 The Only Stable Identifier

The **MAC address** is what you pin to.

Get it with:

    ip link

Or:

    nmcli device show

Or:

    cat /sys/class/net/<iface>/address

Example:

    14:eb:b6:8f:08:7a

This is the identity anchor.

---

## 🛠️ The udev Rule

Create a rule file:

    sudo nano /etc/udev/rules.d/70-tplink-wifi.rules

Rule format:

    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="14:eb:b6:8f:08:7a", NAME="tp-link"

Important:
- The MAC goes in the quotes
- No trailing colon
- NAME is the new interface name you want

---

## 🔁 Apply the Rule

Reload rules:

    sudo udevadm control --reload-rules

Trigger:

    sudo udevadm trigger

Or just reboot.

---

## ✅ Verify

After reboot or replug:

    ip link

You should see:

    tp-link

And:

    nmcli device

Should show:

    tp-link   wifi   connected

---

## 🧪 Debugging When It Does Not Apply

Test the rule:

    sudo udevadm test /sys/class/net/<oldname>

Common mistakes:
- Wrong MAC address
- Trailing colon in MAC
- Wrong SUBSYSTEM
- Rule file name not ending in .rules
- NAME already taken by another device

---

## ⚠️ Important Systemd Note

Some systems also use:

    /usr/lib/systemd/network/*.link

Your udev rule still works, but:

- udev rules run first
- systemd link files can override if higher priority

If needed, create:

    /etc/systemd/network/10-tplink.link

But **udev is sufficient in most cases**.

---

## 🧠 The Real Lesson

Interface names are **not identities**.

MAC addresses are identities.

udev rules are **identity policy**.

---

## 🧱 When You Should Do This

Do this for:
- USB WiFi adapters
- Critical NICs
- Lab machines
- Servers
- Anything referenced in scripts, docs, or configs

Do not rely on auto-generated names.

---

## ✅ Exit Criteria

You are done when:

- The interface keeps the same name across reboots
- NetworkManager reconnects automatically
- No configs depend on volatile names
- You trust the name again

---

## 🧠 One-Line Summary

If the name matters, **pin it**.

Let the system describe devices.

You decide their identity.

