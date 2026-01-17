# ⚙️ Kernel Parameters & sysctl — Operator Basics (LFCS-Level)

Mental mode: Inspect, change safely, persist correctly, verify, move on.

Kernel parameters control **runtime behavior** of the Linux kernel. They live under `/proc/sys/*` and are managed primarily with `sysctl`.

LFCS does not test kernel development. It tests **safe operational tuning and diagnosis**.

---

## 🧠 The One Mental Model

Kernel parameters exist in three layers:

1) **Live values** (in memory, under `/proc/sys/*`)
2) **Temporary changes** (via `sysctl -w` or writing to `/proc/sys`)
3) **Persistent configuration** (via `/etc/sysctl.conf` and `/etc/sysctl.d/*.conf`)

Rules:

- Changing `/proc/sys/*` or `sysctl -w` affects **only the running system**
- Persistence requires files in:
  - `/etc/sysctl.conf`
  - `/etc/sysctl.d/*.conf`

---

## 🎯 LFCS Operator Goals

You must be able to:

- Inspect current kernel parameters
- Change a parameter temporarily
- Make a parameter persistent
- Reload parameters safely
- Verify what is actually active
- Roll back a bad change

---

## 🔎 Core Commands (Must Be Automatic)

Inspect:

    sysctl -a
    sysctl vm.swappiness
    cat /proc/sys/vm/swappiness

Set temporarily:

    sudo sysctl -w vm.swappiness=10

Or:

    echo 10 | sudo tee /proc/sys/vm/swappiness

Load persistent config:

    sudo sysctl -p
    sudo sysctl --system

List what files are being loaded:

    sudo sysctl --system --dry-run

---

## 🗂️ Where Persistent Settings Live

Common locations:

- `/etc/sysctl.conf`  (legacy, still valid)
- `/etc/sysctl.d/*.conf`  (preferred, modular)

Example file:

    /etc/sysctl.d/99-custom.conf

With contents:

    vm.swappiness = 10
    net.ipv4.ip_forward = 1

Apply:

    sudo sysctl --system

---

## 🧪 Standard Operator Workflow

### Step 1 — Inspect current value

    sysctl vm.swappiness

Or:

    cat /proc/sys/vm/swappiness

### Step 2 — Change temporarily (for testing)

    sudo sysctl -w vm.swappiness=10

### Step 3 — Verify behavior

- Re-check value
- Re-test the workload or symptom

### Step 4 — Make persistent (if change is correct)

    sudo vi /etc/sysctl.d/99-custom.conf

Add:

    vm.swappiness = 10

Apply:

    sudo sysctl --system

### Step 5 — Verify final state

    sysctl vm.swappiness

---

## 🧯 Rollback Strategy

If you break something:

- Remove or comment the line in:

      /etc/sysctl.conf
      /etc/sysctl.d/*.conf

- Reapply:

      sudo sysctl --system

Or reboot.

---

## 📁 Mapping Between Names

Kernel parameters map like this:

- sysctl name:        vm.swappiness
- procfs path:        /proc/sys/vm/swappiness

Rule:

> Replace dots with slashes and prepend /proc/sys/

Example:

- net.ipv4.ip_forward → /proc/sys/net/ipv4/ip_forward

---

## 🧰 High-Signal LFCS-Relevant Parameters (Know These Exist)

Memory:

- vm.swappiness
- vm.dirty_ratio
- vm.dirty_background_ratio

Networking:

- net.ipv4.ip_forward
- net.ipv4.tcp_syncookies
- net.ipv4.conf.all.rp_filter

Filesystem:

- fs.file-max

You do not need to memorize values. You need to know **how to inspect and change them safely**.

---

## 🧪 LFCS Practice Drills

### Drill 1 — Temporary change

Goal: prove you can change and revert safely.

1) Check:

       sysctl vm.swappiness

2) Change:

       sudo sysctl -w vm.swappiness=5

3) Verify:

       sysctl vm.swappiness

4) Reboot or restore original value.

Success criteria:
- You understand the change is temporary.

---

### Drill 2 — Persistent change

Goal: make a change survive reboot.

1) Create:

       sudo vi /etc/sysctl.d/99-test.conf

2) Add:

       vm.swappiness = 10

3) Apply:

       sudo sysctl --system

4) Verify:

       sysctl vm.swappiness

Success criteria:
- You know exactly where persistence comes from.

---

### Drill 3 — Inspect what is actually loaded

Goal: remove ambiguity.

Run:

    sudo sysctl --system --dry-run

Observe:

- Which files are read
- In what order
- Which values are applied

---

## ⛔ Operator Rules

- Do not edit random files under `/usr/lib/sysctl.d` unless you mean to override distro defaults.
- Prefer your own file in `/etc/sysctl.d/`.
- Never assume a value is persistent unless it is in a config file.
- Always verify with `sysctl <key>`.

---

## 🔗 Cross-Links

This topic supports:

- Memory pressure analysis
- Networking behavior (routing, forwarding)
- Filesystem limits
- Performance tuning and diagnosis

It is commonly used during:

- Performance incidents
- Network forwarding tasks
- Capacity and pressure debugging

---

## 🏁 Exit Criteria (You Are Done When)

- You can inspect any kernel parameter
- You can change it temporarily
- You can persist it correctly
- You can explain exactly where the active value comes from

