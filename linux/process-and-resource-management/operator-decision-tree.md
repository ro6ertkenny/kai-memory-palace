# Operator Decision Tree (Day 9)

Rule zero:

Symptoms first.
Evidence second.
Action last.
Verification always.

---

Scenario A — The system feels slow

1. Check global pressure:
   - uptime
   - free -h
   - df -h
   - df -i
2. Find top consumers:
   - ps aux --sort=-%cpu | head
   - ps aux --sort=-%mem | head
3. Decide:
   - CPU, memory, disk, or one bad process
4. Inspect before acting.

---

Scenario B — Disk is full

1. Identify which filesystem:
   - df -h
   - df -i
2. Find where space or inodes are going:
   - du -x -sh /* | sort -h
3. Drill down and decide what is safe to remove.

---

Scenario C — A service is down

1. Ask systemd:
   - systemctl status servicename
   - systemctl is-active servicename
2. Read logs:
   - journalctl -u servicename
3. Check the process:
   - systemctl show -p MainPID --value servicename
   - ps -p PID

---

Scenario D — A process will not die

1. Inspect:
   - ps -o pid,ppid,stat,etime,cmd -p PID
2. Escalate:
   - kill PID
   - verify
   - kill -9 PID
   - verify
3. If state is D:
   - Killing will not work. Fix I/O or reboot.

---

Scenario E — CPU is pegged

1. Identify:
   - ps aux --sort=-%cpu | head
2. Inspect the process.
3. Decide if it is expected or runaway.
4. Act at the service or process level.

---

Universal Loop

Symptom -> Triage -> Identify -> Inspect -> Decide -> Act -> Verify
EOF

