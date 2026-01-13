# 🧯 common-mistakes.md — Fast Recovery from Common Networking Errors

## 🎯 Purpose
Recover quickly from **recurring networking mistakes** without guessing.

This file exists to:
- stop trial-and-error fixes
- restore diagnostic order
- prevent repeat failures

Networking errors are common. Slow recovery is optional.

---

## 🧠 Mental Rule
Inspect the ladder. Do not skip steps.

Link → Address → Route → Listener → Name

If you jump ahead, you will misdiagnose.

---

## 🚫 Skipping Link State
Symptom:
- nothing works
- commands time out immediately

Mistake:
- debugging routes or DNS while the interface is down

Fix:
- inspect interfaces and link state
- confirm the expected interface is UP

No link means no traffic.

---

## 📭 Address Assumptions
Symptom:
- host reachable sometimes
- traffic behaves inconsistently

Mistake:
- assuming the host has the expected IP
- ignoring IPv6 or secondary addresses

Fix:
- inspect all assigned addresses
- confirm subnet and scope
- explain which address should be used

Addresses define identity.

---

## 🧭 Missing or Wrong Default Route
Symptom:
- local traffic works
- remote traffic fails

Mistake:
- assuming a default route exists
- ignoring route metrics or overrides

Fix:
- inspect the routing table
- identify the active default route
- confirm gateway and interface

No route means nowhere to go.

---

## 🔊 Listener Confusion
Symptom:
- connection refused
- port appears open but service is unreachable

Mistake:
- assuming a service is listening
- confusing local-only listeners with remote ones

Fix:
- inspect listening ports
- map ports to processes
- confirm bind address

A route without a listener still fails.

---

## 🌍 DNS Blame (Too Early)
Symptom:
- “it must be DNS” instinct

Mistake:
- blaming DNS before checking connectivity
- flushing caches prematurely

Fix:
- test by IP first
- inspect resolver configuration
- confirm name resolution independently

DNS is common, but not first.

---

## 🔁 Firewall Assumptions
Symptom:
- traffic blocked unexpectedly

Mistake:
- assuming a firewall is the cause
- changing rules without evidence

Fix:
- confirm listener and route first
- verify whether traffic reaches the host at all
- inspect firewall state only after evidence

Firewalls block traffic. They do not create it.

---

## 🧪 Testing Before Inspecting
Symptom:
- many commands run
- no clear conclusions

Mistake:
- pinging, curling, and tracing without context

Fix:
- inspect state first
- predict the outcome
- then test once

Tests confirm hypotheses. They do not create them.

---

## 🔌 Driver / Device Binding Assumptions (CRITICAL FOR WIFI & USB)

Symptom:
- device appears in lsusb or lspci
- but no interface shows up in ip link / nmcli / iw
- or the interface appears only sometimes

Mistake:
- assuming “the device is broken”
- assuming “the kernel update broke WiFi”
- assuming “the driver is loaded” just because lsmod shows something
- installing multiple DKMS drivers for the same chipset

Fix:
- inspect the binding chain in order:

  1) Is the device visible?
     - lsusb
     - lspci

  2) Did a driver bind to it?
     - lsusb -t
     - lspci -k

  3) Is the module actually loaded?
     - lsmod | grep -i <driver>

  4) Did the driver create a netdev?
     - ip link
     - iw dev
     - nmcli device

If there is no interface, the driver is not actually attached.

---

## 🧨 Multiple Drivers for One Chipset
Symptom:
- driver is “installed”
- module loads
- but device never appears or behaves inconsistently

Mistake:
- installing two competing DKMS drivers
- leaving an old module around
- assuming the newest one is the one actually bound

Fix:
- inspect:

  - /lib/modules/$(uname -r)/updates/dkms/
  - dkms status
  - lsusb -t (this shows the real binding)

The device can only bind to **one** driver. The wrong one silently wins.

---

## 🧠 Trusting lsmod Too Much
Symptom:
- lsmod shows the module
- but no interface exists

Mistake:
- assuming “module loaded = device working”

Fix:
- lsmod only means “code is in memory”
- you must confirm:
  - the device is bound to that module
  - and the module created a netdev

Always check lsusb -t or lspci -k.

---

## 🧪 The WiFi-Specific Ladder

For USB / PCI WiFi devices, the real ladder is:

Device present  
→ Driver bound  
→ Module loaded  
→ Netdev created  
→ Interface UP  
→ Associated to AP  
→ Has IP  
→ Has route  

Skipping any step leads to superstition-based debugging.

---

## 🧪 Daily Drill (2 minutes)
Intentionally misdiagnose a problem.

- pretend a failure is DNS
- walk the ladder instead
- identify the real failure point

Train recovery, not speed.

---

## ✅ Exit Criteria
You are done with this file when:
- mistakes feel familiar
- recovery steps are automatic
- networking failures feel explainable

You now fail safely in networking.
EOF

