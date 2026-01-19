# 🧠 Phase 6 — Processes, Logs, and Job Scheduling
*LFCS runtime control: see what’s running, control it, prove what happened, and automate safely.*

---

## 📌 Purpose

This phase makes you **operationally decisive** with:

- Inspecting processes and resource usage
- Killing and re-prioritizing work safely
- Understanding and querying logs
- Scheduling work with cron, at, and anacron

Many LFCS tasks are:

> “Something is eating CPU / IO.”  
> “Stop it. Prove what happened. Make this run automatically.”

---

## 🧠 Mental Model

- A **process** = a running program with a PID
- The kernel schedules CPU time using **priority (nice)**
- systemd/journald records **what happened**
- Scheduling tools:
  - `cron` = recurring
  - `at` = one-time
  - `anacron` = catch-up for machines not always on

---

# 🧾 Part A — Inspecting Processes

Classic views:

    ps aux
    ps lax

By PID:

    ps u 1

Tree view:

    pstree

Top:

    top
    htop

Sort by memory:

    ps aux --sort=-%mem | head

Sort by CPU:

    ps aux --sort=-%cpu | head

---

# 🧨 Part B — Killing and Signaling

Kill by PID:

    kill 1234
    kill -9 1234

Kill by name:

    pkill nginx
    killall nginx

Send specific signal:

    kill -SIGHUP 1399

Find PID:

    pgrep nginx
    pgrep -a nginx

---

# 🎚️ Part C — Priority (nice / renice)

Start with priority:

    nice -n 10 command

Change running process:

    sudo renice 9 1234

Check priorities:

    ps -o pid,ni,comm

---

# 📂 Part D — Open Files and Ports

List open files by PID:

    sudo lsof -p 1 > /home/bob/files.txt

Who listens on a port:

    sudo lsof -i :80
    sudo ss -tlnp
    sudo netstat -tulpn

---

# 📜 Part E — Logs

Kernel log:

    dmesg | tail -50

All logs:

    journalctl

Service logs:

    journalctl -u ssh

Last 20 lines:

    journalctl -u ssh -n 20 --no-pager

Follow:

    journalctl -f

By priority:

    journalctl -p err
    journalctl -p info

Search:

    journalctl -g reboot

Inject test log:

    logger "LFCS test entry"

Save logs to file:

    journalctl -p err > /home/bob/.priority/priority.log

---

# ⏱️ Part F — cron (Recurring Jobs)

Edit user crontab:

    crontab -e

List:

    crontab -l

System-wide:

    /etc/crontab
    /etc/cron.d/

Format:

    * * * * * command

Examples:

Every day 02:15:

    15 2 * * * /usr/bin/backup.sh

Every Sunday 11:00:

    0 11 * * 0 /usr/bin/touch weekly

Every 1st and 15th at 16:00:

    0 16 1,15 * * echo Timesheets Due > /dev/console

Kill a process every minute:

    */1 * * * * pkill -u root -f scan_filesystem

Restrict cron users:

    /etc/cron.allow
    /etc/cron.deny

---

# 🕰️ Part G — at (One-Time Jobs)

Schedule:

    at 22:00
    at 15:30 Aug 20 2026

List:

    atq > /home/bob/at_jobs.txt

Remove:

    atrm 1

---

# 🔁 Part H — anacron (Catch-Up Jobs)

Run now:

    sudo anacron -n -f

Config:

    /etc/anacrontab

Example entry:

    10  5  db_cleanup  /usr/bin/touch /root/anacron_created_this

Meaning:

- Run every 5 days
- 10 minute delay
- Job name: db_cleanup

---

# 🧪 Part I — Runtime Diagnostics (IO / CPU)

Top IO:

    sudo dstat --top-io --top-bio

Per-process disk IO:

    sudo pidstat -d 1

Trace files a process uses:

    sudo lsof -p <PID>

Find filesystem backing a process:

    sudo lsof -p <PID> | awk '{print $9}' | while read f; do df "$f"; done

---

# 🧪 Canonical Exam Scenarios

Find top CPU process:

    ps aux --sort=-%cpu | head

Kill by name:

    pkill nginx

Renice a running process:

    sudo renice 9 1234

Save SSH logs:

    journalctl -u ssh -n 20 --no-pager > /home/bob/ssh.log

Create cron job:

    30 21 * * * /usr/bin/touch test_passed

Schedule at job:

    at 22:00

---

## ⚠️ Failure Modes

- Killing wrong PID
- Using -9 unnecessarily
- Forgetting cron environment is minimal
- Forgetting absolute paths in cron
- Thinking anacron runs every minute

---

## 🏁 Phase 6 Mastery Checklist

You must be able to:

- Inspect processes and resource usage
- Kill by PID and by name
- Renice processes
- Find what’s listening on ports
- Query logs with journalctl
- Create cron, at, and anacron jobs
- Restrict cron usage
- Capture logs to files

---

## 🔒 Exam Law

> **If you can’t see what’s running, you’re flying blind. If you can’t automate, you’re a bottleneck.**

---

