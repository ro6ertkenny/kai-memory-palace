# 🔗 Bridge & Bonding — Operator Basics (LFCS-Level)

Mental mode: Identify the role, inspect current state, make the smallest correct change, verify.

LFCS does not test advanced network engineering. It tests **basic operational competence**:

- Can you recognize when a bridge is being used?
- Can you inspect a bridge and its ports?
- Can you add/remove an interface from a bridge?
- Do you understand what bonding is for and how to verify it exists?
- Can you confirm which interface actually carries traffic?

---

## 🧠 The One Mental Model

- **Bridge** = software switch
  - Joins multiple interfaces into one L2 domain
  - Commonly used for:
    - virtualization
    - containers
    - host-as-a-switch setups

- **Bond** = multiple NICs acting as one
  - For:
    - redundancy
    - throughput
  - Traffic goes through the bond, not the slave interfaces

---

## 🎯 LFCS Operator Goals

You must be able to:

- Recognize:
  - Is this system using a bridge?
  - Is this system using a bond?
- Inspect:
  - Which interfaces are attached?
  - Which interface is actually carrying the IP?
- Make basic changes:
  - Add/remove an interface to/from a bridge
- Verify:
  - Link state
  - Addressing
  - Traffic flow

---

## 🔎 Core Inspection Commands (Must Be Automatic)

Show links:

    ip link

Show addresses:

    ip addr

Show bridges:

    bridge link
    bridge vlan

Show detailed link info:

    ip -d link show

Show routing:

    ip route

---

## 🧱 Bridges — Operator View

### How to recognize a bridge

In:

    ip link

You’ll see something like:

- br0
- virbr0
- cni0
- docker0

And interfaces will show:

- master br0

Example:

    ip link show

Look for:

    eth0: ... master br0
    br0: ...

---

### Inspect bridge membership

    bridge link

Or:

    ip -d link show br0

---

### Where does the IP live?

Usually:

- The **bridge** has the IP
- The **member interfaces do not**

Check:

    ip addr show br0
    ip addr show eth0

---

### Add an interface to a bridge (runtime)

Example:

    sudo ip link set eth1 master br0

Bring it up:

    sudo ip link set eth1 up

---

### Remove an interface from a bridge

    sudo ip link set eth1 nomaster

---

### Verify traffic path

Check routes:

    ip route

Check which interface is used:

    ip route get 1.1.1.1

---

## 🧯 Common Bridge Failure Patterns

---

### 1) Interface has no IP

Cause:

- IP is on the bridge, not the interface

Fix:

- Inspect bridge device, not slave interface

---

### 2) Interface added but no traffic

Check:

    ip link show eth1
    bridge link

Make sure:

- Interface is UP
- Bridge is UP

---

### 3) Service bound to wrong interface

Check:

    ss -lntup

Make sure:

- Service listens on 0.0.0.0 or bridge IP, not a removed interface

---

## 🧱 Bonding — Operator View

### What bonding looks like

In:

    ip link

You’ll see:

- bond0 (or similar)
- eth0, eth1 as slaves

Check:

    ip -d link show bond0

---

### Kernel view of bond state

Check:

    cat /proc/net/bonding/bond0

This shows:

- mode
- active slave
- link status

---

### Where does the IP live?

- The **bond** has the IP
- The **slave interfaces do not**

Check:

    ip addr show bond0
    ip addr show eth0
    ip addr show eth1

---

### Verify routing uses the bond

    ip route
    ip route get 1.1.1.1

It should show:

- dev bond0

---

## 🧯 Common Bonding Failure Patterns

---

### 1) Only one NIC carries traffic

This is normal in:

- active-backup mode

Check:

    cat /proc/net/bonding/bond0

---

### 2) Link down on one slave

Check:

    ip link
    cat /proc/net/bonding/bond0

Fix:

- Physical link or driver issue, not logical config

---

## 🧪 LFCS Practice Drills

### Drill 1 — Bridge recognition

1) Run:

       ip link
       bridge link

2) Identify:
   - Which device is the bridge
   - Which interfaces are enslaved

3) Find:
   - Where the IP actually lives

---

### Drill 2 — Traffic path

1) Run:

       ip route get 1.1.1.1

2) Explain:
   - Which device traffic leaves through
   - Whether it’s a bridge, bond, or normal NIC

---

### Drill 3 — Bond inspection (if present)

1) If bond exists:

       cat /proc/net/bonding/bond0

2) Identify:
   - mode
   - active slave
   - link state

---

## ⛔ Operator Rules

- Never assume the interface with the cable has the IP.
- Always check where the IP is assigned.
- Always check `ip route get` to see the real egress device.
- Bridges and bonds are **plumbing**, not magic.

---

## 🔗 Cross-Links

- interface-and-addressing.md
- routes-and-reachability.md
- ports-and-listeners.md
- network-debugging-checklist.md

---

## 🏁 Exit Criteria (You Are Done When)

- You can recognize a bridge or bond instantly
- You can explain where the IP lives
- You can explain which device actually carries traffic
- You can verify the traffic path without guessing

