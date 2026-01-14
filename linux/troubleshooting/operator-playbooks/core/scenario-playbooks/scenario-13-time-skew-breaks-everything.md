# 🧰 Operator Playbook — Scenario 13: “Time Skew Breaks Everything”

**Primary domain:** Time & Clock Failures  
**Domain playbook:** core/domain-playbooks/time-and-clock-failures-playbook.md  
**Why this domain:** The incident is caused by clock skew breaking trust, authentication, or coordination between systems.

---

## 🎯 The Symptom

You may see:

- TLS errors:
  - “certificate not yet valid”
  - “certificate expired”
- Auth failures:
  - OAuth / JWT tokens rejected
  - “token used before issued”
- Kubernetes / etcd / API weirdness
- Logs out of order
- Make, apt, or builds behaving strangely
- Cluster nodes disagreeing about state

Often described as:

> “Everything broke at once and nothing makes sense.”

---

## 🧠 The Critical Mental Model

> **Time is part of correctness.**

If clocks disagree:

- Security breaks
- Consensus breaks
- Caching breaks
- Debugging becomes impossible

Distributed systems **require** roughly synchronized clocks.

---

## 🧪 Phase 1 — Prove Whether Time Is Wrong

### 1) Check local time

    date
    date -u

### 2) Check hardware clock

    hwclock

### 3) Check systemd time status

    timedatectl

Look for:

- System clock synchronized: yes/no
- NTP service: active/inactive
- Time zone correct?

---

## 🧪 Phase 2 — Look for Drift or Skew

### 1) Compare to a trusted source

    curl -I https://google.com | grep -i date

Compare that Date: header to:

    date -u

If they differ by more than a few seconds → **time is wrong**.

---

### 2) On clusters: compare nodes

On multiple machines:

    date -u

If they disagree → **distributed failure guaranteed**.

---

## 🔍 Phase 3 — Check Time Sync System

### 1) Is systemd-timesyncd or chrony running?

    systemctl status systemd-timesyncd
    systemctl status chronyd
    systemctl status ntpd

One of these should be active.

---

### 2) Check sync sources

    timedatectl show-timesync --all

Or (chrony):

    chronyc tracking
    chronyc sources

---

## 🛠️ Phase 4 — Fix the Time

### 1) Enable time sync

    sudo timedatectl set-ntp true

Or start your service:

    sudo systemctl start systemd-timesyncd
    sudo systemctl start chronyd

---

### 2) Force correction (if badly wrong)

    sudo timedatectl set-time "2026-01-14 15:30:00"

Then re-enable NTP sync:

    sudo timedatectl set-ntp true

---

### 3) Fix timezone if needed

    timedatectl list-timezones
    sudo timedatectl set-timezone America/New_York

---

## 🔥 Phase 5 — Verify Recovery

    date
    timedatectl

Confirm:

- Correct time
- NTP synchronized: yes

Now re-test:

- TLS
- Auth
- Services
- Kubernetes components

Many “mysterious” failures will vanish instantly.

---

## 📊 The Decision Matrix

| What you see | What it means | What you do |
|--------------|---------------|-------------|
| Cert “not yet valid” | Clock is in the past | Fix time |
| Cert “expired” but shouldn’t be | Clock is in the future | Fix time |
| Tokens rejected everywhere | Time skew | Fix time on all nodes |
| Logs out of order | Time drift | Fix sync |
| timedatectl says unsynchronized | No NTP | Enable it |

---

## ⚠️ Operator Warnings

- Never ignore time errors
- Never debug TLS/auth before checking time
- Never assume VMs have correct clocks
- Suspend/resume often breaks clocks
- Bad CMOS batteries cause drift

---

## 🧠 The Universal Rule

> **If security, auth, or distributed systems break in strange ways, check time first.**

---

## 🧠 One-Sentence Operator Summary

> “When TLS, auth, or cluster behavior suddenly breaks everywhere, immediately verify and fix system time before debugging anything else.”

---

## 🧾 The Minimal Proof Commands

    date
    timedatectl
    curl -I https://google.com | grep -i date
    systemctl status systemd-timesyncd || systemctl status chronyd

