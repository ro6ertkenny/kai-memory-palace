# ⚔️ Phase 6 — Processes, Logs, and Scheduling (Execution Playbook)
*LFCS runtime-control layer: if you can’t see what’s running, stop it safely, prove what happened, and automate it, you’re flying blind.*

Path:
- linux/LFCS-execution-playbooks/phase-6-processes-logs-and-scheduling.md

Rule:
- This is not reference material.
- This is execution under time + verification.
- Every drill ends with mechanical proof.

---

## 📌 Purpose

Build reflex-level ability to:

- inspect processes and resource usage
- find PIDs by name and by port
- signal and kill processes safely
- adjust priorities with nice/renice
- identify open files and listening ports
- query and filter logs with journalctl
- schedule recurring jobs with cron
- schedule one-time jobs with at
- use anacron for catch-up jobs
- capture evidence to files

---

## 🧱 Lab Root

All Phase 6 drills run in:

- ~/lfcs-labs/phase-6

Initialize clean workspace:

    mkdir -p ~/lfcs-labs/phase-6
    cd ~/lfcs-labs/phase-6
    rm -rf ./*

---

## 🧪 Completion Standard

Pass Phase 6 when you can complete P6-1 through P6-14:

- in ≤ 75 minutes total
- with zero verification failures
- without killing the wrong process
- without forgetting absolute paths in cron

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P6-1 — Inspect processes and sort by CPU

Time limit:
- 4 minutes

Task:
Save the top 10 CPU-consuming processes to topcpu.txt.

Do:

    ps aux --sort=-%cpu | head -n 11 > topcpu.txt

Verify:

    wc -l topcpu.txt
    head topcpu.txt

-------------------------------------------------------------------------------

## P6-2 — Find PID by name and signal

Time limit:
- 4 minutes

Setup:

    sleep 3000 &
    echo $! > sleeper.pid

Task:
Find the PID using pgrep and terminate it cleanly.

Do:

    pgrep sleep
    kill $(cat sleeper.pid)

Verify:

    ps -p $(cat sleeper.pid) || echo "terminated"

-------------------------------------------------------------------------------

## P6-3 — Force kill when needed

Time limit:
- 3 minutes

Setup:

    sleep 3000 &
    echo $! > sleeper2.pid

Task:
Kill it with SIGKILL.

Do:

    kill -9 $(cat sleeper2.pid)

Verify:

    ps -p $(cat sleeper2.pid) || echo "killed"

-------------------------------------------------------------------------------

## P6-4 — Adjust priority with nice

Time limit:
- 4 minutes

Task:
Start a command with lower priority and verify.

Do:

    nice -n 10 sleep 3000 &
    ps -o pid,ni,comm | grep sleep

Verify:
- NI column shows 10

Then clean up:

    pkill sleep

-------------------------------------------------------------------------------

## P6-5 — Renice a running process

Time limit:
- 4 minutes

Setup:

    sleep 3000 &
    echo $! > sleeper3.pid

Task:
Change its nice value to 5.

Do:

    sudo renice 5 -p $(cat sleeper3.pid)

Verify:

    ps -o pid,ni,comm | grep $(cat sleeper3.pid)

Cleanup:

    kill $(cat sleeper3.pid)

-------------------------------------------------------------------------------

## P6-6 — Find who listens on a port

Time limit:
- 4 minutes

Task:
Find what (if anything) listens on port 22 and save to port22.txt.

Do:

    ss -tlnp | grep ':22' > port22.txt || true

Verify:

    cat port22.txt

-------------------------------------------------------------------------------

## P6-7 — List open files of a process

Time limit:
- 4 minutes

Task:
List open files for PID 1 and save to pid1-files.txt.

Do:

    sudo lsof -p 1 > pid1-files.txt

Verify:

    wc -l pid1-files.txt

-------------------------------------------------------------------------------

## P6-8 — Read kernel and service logs

Time limit:
- 4 minutes

Task:
Save last 20 kernel log lines to dmesg.txt.

Do:

    dmesg | tail -n 20 > dmesg.txt

Verify:

    wc -l dmesg.txt

-------------------------------------------------------------------------------

## P6-9 — Query journal by service

Time limit:
- 4 minutes

Task:
Save last 20 SSH log lines to ssh.log.

Do:

    journalctl -u ssh -n 20 --no-pager > ssh.log

Verify:

    wc -l ssh.log

-------------------------------------------------------------------------------

## P6-10 — Inject and find a log entry

Time limit:
- 4 minutes

Task:
Write a test log entry and find it.

Do:

    logger "LFCS_PHASE6_TEST"
    journalctl -g LFCS_PHASE6_TEST -n 1 --no-pager > testlog.txt

Verify:

    cat testlog.txt

-------------------------------------------------------------------------------

## P6-11 — Create a cron job

Time limit:
- 6 minutes

Task:
Create a cron job that appends date to /tmp/cron-test.txt every minute.

Do:

    crontab -l > mycron || true
    echo "* * * * * /bin/date >> /tmp/cron-test.txt" >> mycron
    crontab mycron

Verify (after waiting >60 seconds):

    test -f /tmp/cron-test.txt && tail /tmp/cron-test.txt

Cleanup:

    crontab -r

-------------------------------------------------------------------------------

## P6-12 — Use at for one-time job

Time limit:
- 6 minutes

Task:
Schedule a job 2 minutes in the future to write "hello" to /tmp/at-test.txt.

Do:

    echo "echo hello > /tmp/at-test.txt" | at now + 2 minutes

Verify:

    atq

Then wait and verify:

    cat /tmp/at-test.txt

-------------------------------------------------------------------------------

## P6-13 — Inspect anacron config

Time limit:
- 4 minutes

Task:
Open and inspect /etc/anacrontab.

Do:

    sudo cat /etc/anacrontab > anacron.txt

Verify:

    cat anacron.txt

-------------------------------------------------------------------------------

## P6-14 — Capture evidence to file

Time limit:
- 4 minutes

Task:
Save current process list to processes.txt and current listening ports to ports.txt.

Do:

    ps aux > processes.txt
    ss -tlnp > ports.txt

Verify:

    wc -l processes.txt
    wc -l ports.txt

---

## 🏁 Phase 6 Pass Criteria

You can:

- inspect and sort processes by CPU/memory
- find and signal PIDs safely
- force-kill only when necessary
- adjust and verify priorities
- identify listeners and open files
- query logs by kernel and service
- inject and search journal entries
- create and remove cron jobs safely
- schedule and verify at jobs
- inspect anacron behavior
- capture runtime state to files

---

## 🔒 Phase 6 Law

If you can’t see what’s running and prove what happened,
you are not in control of the system.

---
