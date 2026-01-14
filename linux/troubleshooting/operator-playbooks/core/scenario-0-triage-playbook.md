# Triage Playbook — What Is The Next Step?

---

If the system is slow

- uptime
- free -h
- df -h
- df -i
- ps aux --sort=-%cpu | head
- ps aux --sort=-%mem | head

---

If disk is full

- df -h
- df -i
- du -x -sh /* | sort -h

---

If memory is low

- free -h
- ps aux --sort=-%mem | head

---

If CPU is high

- uptime
- ps aux --sort=-%cpu | head

---

If a service is down

- systemctl status servicename
- journalctl -u servicename

---

If a process is hung

- ps -o pid,stat,cmd -p PID
- Check for D-state
EOF

