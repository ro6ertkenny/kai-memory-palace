# 🧪 LFCS Execution Drills — Phase 6
# 🧠 Processes, Logs, and Job Scheduling

Path:
  linux/execution-drills/phase-6-processes-logs-and-scheduling.md

Purpose:
  Build reflex-level control over running processes, priorities, logs, and scheduled automation.

Mental Mode:
  If you can’t see what’s running, you can’t control it. If you can’t automate, you don’t scale.

---

## 🧱 Lab Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-6
    cd ~/lfcs-labs/execution-drills/phase-6

Install a few tools if missing:

    sudo apt update
    sudo apt install -y htop dstat sysstat at

Ensure atd is running:

    sudo systemctl enable --now atd

---

# A) Inspecting Processes

## A1 — Classic views

    ps aux
    ps lax
    pstree
    top

Exit top with q.

---

## A2 — Sort by resource usage

Top CPU:

    ps aux --sort=-%cpu | head

Top memory:

    ps aux --sort=-%mem | head

---

## A3 — Inspect PID 1

    ps u 1

Explain what PID 1 is.

---

# B) Killing and Signaling

## B1 — Create test process

    sleep 1000 &

Find it:

    pgrep sleep
    pgrep -a sleep

Kill gently:

    kill <PID>

Verify:

    pgrep sleep || echo "killed"

---

## B2 — SIGKILL only if needed

    sleep 1000 &
    kill -9 <PID>

Explain why -9 is last resort.

---

## B3 — Kill by name

    sleep 1000 &
    pkill sleep

---

# C) Priority (nice / renice)

## C1 — Start low-priority process

    nice -n 10 sleep 1000 &

Check:

    ps -o pid,ni,comm | grep sleep

---

## C2 — Renice running process

    sudo renice 5 <PID>
    ps -o pid,ni,comm | grep sleep

Kill it when done.

---

# D) Open Files and Ports

## D1 — What files does PID 1 use?

    sudo lsof -p 1 | head

Save to file:

    sudo lsof -p 1 > files-pid1.txt

---

## D2 — Who listens on ports?

    sudo ss -tlnp
    sudo lsof -i :22

---

# E) Logs (journalctl)

## E1 — General logs

    journalctl

---

## E2 — Service logs

    journalctl -u ssh

Last 20 lines:

    journalctl -u ssh -n 20 --no-pager

Follow live (Ctrl+C to exit):

    journalctl -f

---

## E3 — Priority and search

    journalctl -p err
    journalctl -g reboot

---

## E4 — Inject test log

    logger "LFCS Phase 6 test entry"
    journalctl -g "Phase 6" -n 5 --no-pager

---

## E5 — Save logs to file

    mkdir -p ~/lfcs-labs/execution-drills/phase-6/logs
    journalctl -p err > ~/lfcs-labs/execution-drills/phase-6/logs/errors.log
    ls -l logs/errors.log

---

# F) cron (Recurring Jobs)

## F1 — List current crontab

    crontab -l || echo "no crontab yet"

---

## F2 — Create test cron job

Edit:

    crontab -e

Add:

    */2 * * * * /usr/bin/date >> /tmp/cron-test.log

Wait 5 minutes, then:

    tail /tmp/cron-test.log

Remove job afterward.

---

## F3 — Cron environment drill

Create script:

    cat > ~/lfcs-labs/execution-drills/phase-6/test.sh <<EOF
    #!/bin/bash
    date >> /tmp/cron-env.log
    env >> /tmp/cron-env.log
    EOF

    chmod +x ~/lfcs-labs/execution-drills/phase-6/test.sh

Schedule it in crontab using full path.

Inspect /tmp/cron-env.log.

---

# G) at (One-Time Jobs)

## G1 — Schedule job

    echo "date >> /tmp/at-test.log" | at now + 2 minutes

List:

    atq > at_jobs.txt
    cat at_jobs.txt

Wait 3 minutes, then:

    cat /tmp/at-test.log

---

## G2 — Remove job

Schedule another, then:

    atq
    atrm <JOBID>

---

# H) anacron

## H1 — Inspect config

    sudo cat /etc/anacrontab

---

## H2 — Force run

    sudo anacron -n -f

Explain:
- used for machines not always on
- not minute-precise like cron

---

# I) Runtime Diagnostics

## I1 — Top IO (if supported)

    sudo dstat --top-io --top-bio

Ctrl+C to stop.

---

## I2 — Per-process disk IO

    sudo pidstat -d 1

Ctrl+C to stop.

---

## I3 — What filesystem backs a process?

Start a process:

    sleep 1000 &

Find files:

    sudo lsof -p <PID> | awk '{print $9}' | while read f; do df "$f"; done

Kill process after.

---

# J) Timed Drills

## J1 — Find top CPU process in 15 seconds

    ps aux --sort=-%cpu | head

---

## J2 — Kill process by name in 10 seconds

    sleep 1000 &
    pkill sleep

---

## J3 — Save SSH logs in 15 seconds

    journalctl -u ssh -n 20 --no-pager > ~/lfcs-labs/execution-drills/phase-6/ssh.log

---

## J4 — Create cron job in 30 seconds

    crontab -e

Add:

    30 21 * * * /usr/bin/touch /tmp/test_passed

---

# K) Failure Injection Drills

## K1 — Kill wrong PID simulation

Start two sleeps:

    sleep 1000 &
    sleep 1000 &

List:

    pgrep -a sleep

Explain why you must verify before killing.

---

## K2 — Using -9 too fast

Start:

    sleep 1000 &

Kill with:

    kill -9 <PID>

Explain:
- no cleanup
- may cause corruption in real programs

---

## K3 — Cron path failure

Create cron entry using:

    test.sh

Explain why it fails:
- cron has minimal PATH
- must use full path

Fix by using full path.

---

# L) Composition (Exam Style)

## L1 — Diagnose CPU hog

    ps aux --sort=-%cpu | head
    top

Identify, then:

    kill <PID>

---

## L2 — Capture evidence

    journalctl -u ssh -n 50 --no-pager > ~/lfcs-labs/execution-drills/phase-6/ssh-evidence.log

---

## L3 — Automate cleanup

Create cron job to:

    find /tmp -type f -mtime +7 -delete

(Simulate only; do not run on real important systems.)

---

# ✅ Phase 6 Completion Criteria

You are Phase 6-ready when you can:

- Inspect and sort processes by resource usage
- Kill by PID and by name safely
- Use nice and renice correctly
- Find open files and listening ports
- Query, filter, and save logs with journalctl
- Create cron, at, and understand anacron jobs
- Understand cron environment limitations
- Capture evidence of what happened

---

# 🔒 Phase 6 Law

If you can’t see what’s running, you’re blind. If you can’t automate, you’re slow.

---
