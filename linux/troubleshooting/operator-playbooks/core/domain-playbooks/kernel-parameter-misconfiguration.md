# ⚙️ Kernel Parameter Misconfiguration — Domain Playbook

Mental mode: Identify bad tunable, prove impact, revert safely, persist correctly.

This playbook is used when:

- Networking suddenly breaks (routing/forwarding weirdness)
- Performance suddenly degrades
- Memory behavior is pathological
- A recent tuning change is suspected
- Or a system behaves differently after reboot

---

## 🎯 Objective

1) Determine whether a kernel parameter change is involved
2) Identify the active value
3) Revert or correct it
4) Make persistence match intent
5) Verify system behavior

---

## 🧠 Core Model

Kernel parameters exist in:

- Live memory (/proc/sys/*)
- Persistent config (/etc/sysctl.conf, /etc/sysctl.d/*.conf)

Either layer can be wrong.

---

## 🧪 Entry Conditions

- “Something changed” and now behavior is wrong
- Or a service / network / memory subsystem behaves unexpectedly
- Or tuning was recently applied

---

## 🔎 Step 1 — Inspect Relevant Live Values

Examples:

    sysctl -a | less
    sysctl vm.swappiness
    sysctl net.ipv4.ip_forward

Or:

    cat /proc/sys/vm/swappiness

---

## 🔍 Step 2 — Check What Is Being Loaded Persistently

    sudo sysctl --system --dry-run

Look for:

- Which files are applied
- In what order
- Which value overrides which

---

## 🧯 Step 3 — Identify the Offending Setting

Check:

    /etc/sysctl.conf
    /etc/sysctl.d/*.conf

Search:

    grep -RIn . /etc/sysctl.conf /etc/sysctl.d/

---

## 🛠️ Step 4 — Revert or Correct

Edit the offending file and:

- Remove or comment the bad setting
- Or correct it

Apply:

    sudo sysctl --system

---

## 🧪 Step 5 — Verify Live State

    sysctl <key>

Re-test the affected subsystem.

---

## 🧯 Emergency Rollback

If the system is badly broken:

- Remove the custom file in /etc/sysctl.d/
- Re-run:

      sudo sysctl --system

Or reboot.

---

## ⛔ Operator Rules

- Never assume live values match config files
- Always check both layers
- Prefer your own file in /etc/sysctl.d/ for changes
- Always verify the active value

---

## 🔁 Exit Criteria

- Live value matches intended value
- Persistent config matches intended value
- System behavior is restored

