# Day 9 — Operator Readiness Checklist

You should be able to do all of the following without hesitation.

---

1) Global Triage (System Feels “Weird” or “Slow”)

You can:

Run a full triage snapshot:
- uptime
- free -h
- df -h
- df -i
- ps aux --sort=-%cpu | head
- ps aux --sort=-%mem | head

Explain what each one tells you.

Decide whether the problem is:
- CPU
- memory
- disk
- or one bad process

---

2) Disk Full Incidents

You can:

- Distinguish space exhaustion vs inode exhaustion
- Identify which filesystem is full
- Use du to find which directory tree is responsible
- Drill down methodically
- Explain why deleting blindly is dangerous

---

3) Process Inspection

You can:

- Explain what ps is and what it shows
- Read:
  - PID
  - PPID
  - STAT
  - ELAPSED
  - CMD
- Explain process states:
  - R, S, D, T, Z
- Explain modifiers:
  - +, s, l, <, N
- Explain why most processes are S (sleeping) and that this is normal

---

4) Job Control vs System Processes

You can:

- Explain the difference between:
  - shell jobs (jobs, fg, bg, %1)
  - system processes (ps, kill, PID)
- Start a job in background
- Stop it with Ctrl+Z
- Resume with bg / fg
- Kill by job number
- Kill by PID
- Explain why the shell prints messages AND ps shows results (two layers)

---

5) Signal Discipline

You can:

- Explain what a signal is
- Explain:
  - SIGTERM (15) = polite
  - SIGKILL (9) = forced, uncatchable
- Use this escalation path:
  - kill PID
  - verify
  - kill -9 PID
  - verify
- Explain why SIGKILL is not magic

---

6) Hung / Unkillable Processes

You can:

- Inspect STAT and recognize:
  - D-state = uninterruptible sleep
- Explain:
  - Why kill -9 does not work on D-state
  - That the real problem is I/O or kernel
- Know when:
  - You must fix storage
  - Or reboot

---

7) Services vs Processes (systemd)

You can:

- Explain the difference between:
  - A process
  - A service
- Use:
  - systemctl status
  - systemctl is-active
- Find:
  - MainPID
- Verify with:
  - ps -p PID
- Inspect logs with:
  - journalctl -u service

---

8) Supervisor / Respawn Model

You can:

- Explain:
  - Killing a PID is not the same as stopping a service
- Explain:
  - systemd may respawn services
- Inspect restart policy
- Prove respawn safely using:
  - systemctl restart
  - comparing MainPID before and after
- Explain start-limit protection

---

9) Kubernetes / Containers Mental Integration

You can:

- Explain why:
  - kubelet is visible in ps
  - but not in systemctl (in kind)
- Explain:
  - Not every important process is a systemd service
  - Some are inside containers or other supervisors

---

10) Operator Decision Tree

You can talk through these without guessing:

- System is slow
- Disk is full
- Service is down
- Process will not die
- CPU is pegged

And for each one you can explain:

- What you check first
- Why
- What decision you are making
- What the minimum safe action is

---

Day 9 Graduation Standard

If you can do all of the above:

You are no longer running Linux commands.
You are operating a Linux system.

You now think in:

Symptom -> Evidence -> Decision -> Action -> Verification
EOF

