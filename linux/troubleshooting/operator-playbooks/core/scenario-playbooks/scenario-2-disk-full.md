# 🧰 Operator Playbook — Scenario 2: “Disk Is Full” (No space left on device)

**Primary domain:** Disk Exhaustion  
**Domain playbook:** core/domain-playbooks/disk-exhaustion-playbook.md  
**Why this domain:** The failure is an allocation failure (no blocks or inodes available), not a performance or scheduling problem.

**Goal:** Restore write capability safely by proving *what* is full (blocks vs inodes), *where*, and *why*.

---

## 🧠 Mental Model

A “disk full” incident is usually one of these:

1) **Blocks full** (actual space used)  
2) **Inodes full** (too many files)  
3) **Wrong filesystem** (you’re filling `/` but you think it’s `/home`)  
4) **Hidden growth** (logs, container layers, temp dirs, runaway writes, deleted-but-open files)

---

## 🧭 Phases (Operator Loop)

### Phase 1 — Symptom
**Questions**
- What failed exactly? (which command / service)
- Which path was it writing to?

**Play**
- Capture the error message and the path (don’t change anything yet).

---

### Phase 2 — Evidence (Global)
**Questions**
- Is it **space** or **inodes**?
- Which filesystem is impacted?

**Play**
- Check block usage:
  
  df -h

- Check inode usage:
  
  df -i

**Decisions**
- If `Use%` is 100% in `df -h` → blocks are exhausted → continue.
- If `IUse%` is 100% in `df -i` → inode exhaustion → jump to **Scenario 2B: inode exhaustion** (next planned scenario).
- If neither is near full → you might be looking at the wrong filesystem or a transient path.

---

### Phase 3 — Identify (Where is it?)
**Questions**
- Which top-level directory tree is consuming space *on that filesystem*?

**Play (fast sweep on the same filesystem)**
- Use `du -x` so you don’t cross mounts:

  sudo du -x -sh /* 2>/dev/null | sort -h

**Drill down (common hotspots)**
- If `/var` is large:

  sudo du -x -sh /var/* 2>/dev/null | sort -h

- If logs look large:

  sudo du -x -sh /var/log/* 2>/dev/null | sort -h

- If `/home` is large:

  sudo du -x -sh /home/* 2>/dev/null | sort -h

**Container / image storage suspects**
- Docker (if installed):

  sudo du -x -sh /var/lib/docker 2>/dev/null

- containerd (if used by Kubernetes / containers):

  sudo du -x -sh /var/lib/containerd 2>/dev/null

---

### Phase 4 — Inspect (What is causing growth?)
**Questions**
- Is it logs, caches, temp files, or application data?
- Is it *active growth right now*?

**Play**
- Find recently modified large files (example: /var/log):

  sudo find /var/log -type f -size +100M -printf '%TY-%Tm-%Td %TH:%TM  %s  %p\n' 2>/dev/null | sort

- Check for “deleted but still open” files (classic hidden usage):
  
  sudo lsof +L1 2>/dev/null | head

**Interpretation**
- If you see huge files with `(deleted)` in `lsof +L1` output:
  - Disk space won’t come back until the owning process is restarted (or closed).
  - This is a **process/service** issue, not just a filesystem issue.

---

### Phase 5 — Decide (Minimum safe action)
Pick the smallest action that restores space *and* fixes the cause.

#### Option A — Logs are the cause
**Safe actions**
- Identify which log file is huge.
- Prefer proper log rotation (best).
- If you must free space immediately, truncate (does not remove file permissions/ownership):

  sudo truncate -s 0 /path/to/huge.log

Then investigate why it grew:
- noisy service?
- debug logging enabled?
- repeated crash loop?

#### Option B — Cache directories are the cause
**Examples**
- `/var/cache/*`, application caches, browser caches, build caches

**Safe actions**
- Remove only known cache paths (not random system dirs).
- For package cache (Debian):
  
  sudo apt-get clean

#### Option C — Temp dirs are the cause
**Examples**
- `/tmp`, `/var/tmp`

**Safe actions**
- Remove only obviously stale files (careful on shared systems).
- Confirm what’s writing there.

#### Option D — Container storage is the cause
**Safe actions**
- Identify unused images/containers/volumes via the container toolchain you use.
- Don’t delete live layers blindly.
- If you’re in Kubernetes, inspect pod logs + image churn.

---

### Phase 6 — Act
Execute the chosen minimal action.

Guardrails:
- Prefer “truncate + root cause fix” over “rm -rf random directories”.
- Make one change at a time.

---

### Phase 7 — Verify
**Must-haves**
- Confirm free space returned:

  df -h
  df -i

- Confirm the failing command/service works again.
- If you touched logs or services, confirm they’re healthy:

  systemctl status <service> --no-pager
  sudo journalctl -u <service> -n 50 --no-pager

---

## 🚨 Red Flags (Do NOT do these)
- Do not `rm -rf /var/log` (you will break the system).
- Do not delete unknown files under `/var/lib/*` unless you know the owning system.
- Do not “cleanup” across mounts without `-x` (you’ll chase the wrong root cause).

---

## ✅ Quick Decision Cheatsheet

- `df -h` full → **blocks** → use `du -x` to find culprit path
- `df -i` full → **inodes** → too many small files (different play)
- Space not returning after deletes → check `lsof +L1` (deleted-but-open)
- `/var/log` huge → truncate (fast), then fix logging/rotation
- `/var/lib/containerd` huge → container/image churn; fix workload/tooling

---

## 🏁 One-Sentence Operator Summary

“When disk is full, first prove whether it’s blocks or inodes with `df`, then locate the responsible tree with `du -x`, then fix the cause (logs/caches/container storage) with the minimum safe action, and verify with `df`.”

---
