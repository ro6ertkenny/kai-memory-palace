# 🧪 Processes, Logs, and Scheduling — Execution Drills (LFCS)

Mental mode: Control and observability.  
Goal: Be able to **see what’s running, control it safely, capture evidence, and automate tasks** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

Scope:
- processes (inspect, signal, kill safely)
- priorities (nice/renice)
- open files and ports (lsof/ss)
- logs (journalctl evidence patterns)
- scheduling (cron/at/anacron)

Related file (service management + logrotate + timers):
- `services-and-logging.md`

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/processes-logs-and-scheduling
    cd ~/lfcs-labs/execution-drills/processes-logs-and-scheduling

Install tools if missing (Debian/Ubuntu):

    sudo apt-get update
    sudo apt-get install -y htop sysstat at lsof

Ensure atd is running:

    sudo systemctl enable --now atd

---

## 🧠 1) Inspecting Processes

- Show all processes (classic views)
- Show process tree
- Identify PID 1
- Sort by CPU and memory

    ps aux
    ps lax
    pstree
    ps u 1

Top CPU:

    ps aux --sort=-%cpu | head

Top memory:

    ps aux --sort=-%mem | head

---

## 🛑 2) Signaling and Killing (Safe Discipline)

### 2.1 Create a test process

    sleep 1000 &

Find it:

    pgrep sleep
    pgrep -a sleep

### 2.2 Terminate gracefully (preferred)

    kill <PID>
    pgrep sleep || echo "killed"

### 2.3 Kill by name (use with care)

    sleep 1000 &
    pkill sleep

### 2.4 SIGKILL only as last resort

    sleep 1000 &
    kill -9 <PID>

Rule:
- `-9` prevents cleanup; in real services it can cause corruption.

---

## 🎛️ 3) Priority Control (nice / renice)

Start a low-priority process:

    nice -n 10 sleep 1000 &

Check niceness:

    ps -o pid,ni,comm | grep sleep

Renice a running process:

    sudo renice 5 <PID>
    ps -o pid,ni,comm | grep sleep

Cleanup:

    pkill sleep || true

---

## 🔎 4) Open Files and Listening Ports (Evidence)

### 4.1 What files does a process have open?

PID 1 (system manager) preview:

    sudo lsof -p 1 | head

Save evidence:

    sudo lsof -p 1 > pid1-open-files.txt
    ls -la pid1-open-files.txt

### 4.2 What is listening on the machine?

    sudo ss -tlnp
    sudo lsof -i :22

---

## 📜 5) Journald Evidence Capture (journalctl)

General logs (paged):

    journalctl

Service logs:

    journalctl -u ssh

Last 20 lines, no pager:

    journalctl -u ssh -n 20 --no-pager

Follow live (Ctrl+C to exit):

    journalctl -f

Priority filtering:

    journalctl -p err

Search (boots, keywords, etc.):

    journalctl -g reboot

### 5.1 Inject a test log entry

    logger "LFCS drill: processes/logs/scheduling entry"
    journalctl -g "LFCS drill" -n 5 --no-pager

### 5.2 Save logs to a file (evidence pattern)

    mkdir -p logs
    journalctl -p err > logs/errors.log
    journalctl -u ssh -n 50 --no-pager > logs/ssh-evidence.log
    ls -la logs

---

## ⏱️ 6) cron (Recurring Jobs)

List crontab:

    crontab -l || echo "no crontab yet"

Create a safe test job (edit crontab):

    crontab -e

Add:

    */2 * * * * /usr/bin/date >> /tmp/cron-test.log

Verify after a few minutes:

    tail -n 5 /tmp/cron-test.log

Remove the entry afterward.

### 6.1 Cron environment drill (PATH will bite you)

Create script:

    cat > ~/lfcs-labs/execution-drills/processes-logs-and-scheduling/cron-env.sh <<'EOT'
#!/bin/bash
date >> /tmp/cron-env.log
env >> /tmp/cron-env.log
EOT

    chmod +x ~/lfcs-labs/execution-drills/processes-logs-and-scheduling/cron-env.sh

Schedule using the FULL PATH (in crontab):

    */5 * * * * /home/ro6ert/lfcs-labs/execution-drills/processes-logs-and-scheduling/cron-env.sh

Inspect output:

    tail -n 30 /tmp/cron-env.log

Rule:
- Cron has a minimal environment. Always use full paths.

---

## 🕰️ 7) at (One-Time Jobs)

Schedule a job:

    echo "date >> /tmp/at-test.log" | at now + 2 minutes

List jobs:

    atq

Wait, then verify:

    cat /tmp/at-test.log

Remove a job:

    atq
    atrm <JOBID>

---

## 🗓️ 8) anacron (Not Always-On Machines)

Inspect config:

    sudo cat /etc/anacrontab

Force run (safe awareness drill):

    sudo anacron -n -f

Concept:
- anacron is for jobs that should run even if the machine was off
- not minute-precise like cron

---

## 🧰 9) Runtime Diagnostics (Lightweight, High-Signal)

Per-process IO (1 second interval):

    sudo pidstat -d 1

Ctrl+C to stop.

---

## ⏱️ 10) Timed Drills

Top CPU process (15 seconds):

    ps aux --sort=-%cpu | head

Kill by name (10 seconds):

    sleep 1000 &
    pkill sleep

Capture SSH evidence (15 seconds):

    journalctl -u ssh -n 20 --no-pager > logs/ssh-last20.log

---

## 💥 11) Failure Injection Drills

### 11.1 Kill wrong PID simulation

    sleep 1000 &
    sleep 1000 &
    pgrep -a sleep

Rule:
- verify target before kill

Cleanup:

    pkill sleep || true

### 11.2 Cron path failure

Bad crontab entry:

    */5 * * * * cron-env.sh

Why it fails:
- cron PATH is minimal
- must use full path to script and commands

Fix:
- full path to script
- inside script, full paths if needed

---

## 🧩 12) Composition (Exam Style)

### 12.1 Diagnose + act

    ps aux --sort=-%cpu | head
    top

Identify hog, then:

    kill <PID>

### 12.2 Capture evidence bundle

    mkdir -p evidence
    ps aux > evidence/ps-aux.txt
    sudo ss -tlnp > evidence/ss-listeners.txt
    journalctl -p err > evidence/journal-errors.txt
    ls -la evidence

---

## ✅ Completion Criteria

You are done with this file when you can:

- identify top CPU/mem quickly
- kill by PID and name safely (no guesswork)
- use nice/renice correctly
- map process → open files → ports
- capture journald evidence into files fast
- create cron + at jobs correctly (full paths)
- explain when anacron applies

---

## 🔒 Law

If you can’t see what’s running, you’re blind.  
If you can’t automate cleanly, you’re slow.
EOF

---

# 2) Add it to the execution-drills index

Edit `linux/LFCS-training/execution-drills/index.md` and add a bullet like this in the list:

- `processes-logs-and-scheduling.md` — processes, journalctl evidence patterns, cron/at/anacron

(Keep naming consistent with the rest of that index.)

---
