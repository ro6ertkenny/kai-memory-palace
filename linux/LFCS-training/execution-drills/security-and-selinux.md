# 🧪 Security and SELinux — Execution Drills (LFCS)

Mental mode: Defense, containment, and proof.  
Goal: Be able to **audit access, harden a system, control services, manage firewalling, and diagnose SELinux denials** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

Notes:
- Some systems use **SELinux** (RHEL, Rocky, Alma, Fedora). Others use **AppArmor** (Ubuntu, Debian).
- Do the SELinux sections if SELinux exists; otherwise still practice the command recognition.

---

## 🔎 1) Baseline Security Inspection

- Show logged-in users
- Show last logins
- Show listening ports
- Show open network services
- Show running processes as root

    who
    w
    last
    ss -lntup
    ps aux | head -n 20

---

## 🔐 2) Account and Authentication Hardening

- Lock a user
- Unlock a user
- Expire a user
- Force password change
- Show password aging

    sudo passwd -l testuser
    sudo passwd -u testuser
    sudo chage -E 2026-12-31 testuser
    sudo chage -d 0 testuser
    sudo chage -l testuser

---

## 🧱 3) File Permission Audits

- Find world-writable files
- Find world-writable directories
- Find SUID files
- Find SGID files
- Find files with no owner

    find / -perm -0002 -type f 2>/dev/null
    find / -perm -0002 -type d 2>/dev/null
    find / -perm -4000 -type f 2>/dev/null
    find / -perm -2000 -type d 2>/dev/null
    find / -nouser -o -nogroup 2>/dev/null

---

## 🧷 4) ACL Auditing and Control

- Show ACLs
- Set ACL
- Remove ACL
- Set default ACL on directory

    getfacl file.txt
    setfacl -m u:testuser:r-- file.txt
    getfacl file.txt
    setfacl -b file.txt
    setfacl -d -m u:testuser:rw somedir

---

## 🔥 5) Firewall Basics (ufw / nftables / iptables)

- Show firewall status
- List rules
- Allow a port
- Deny a port
- Reload firewall
- Verify open port

ufw (if present):

    sudo ufw status verbose
    sudo ufw allow 22
    sudo ufw deny 1234
    sudo ufw reload
    ss -lntup | grep 22 || true

nftables (if present):

    sudo nft list ruleset
    sudo nft list tables

iptables (legacy systems):

    sudo iptables -L -n -v

---

## 🌐 6) Service Exposure Control

- Check if a service is listening
- Stop service
- Disable service at boot
- Mask service

    ss -lntup | grep 80 || true
    sudo systemctl stop nginx || true
    sudo systemctl disable nginx || true
    sudo systemctl mask nginx || true

---

## 🧠 7) sudo Policy Inspection

- Show your sudo privileges
- Edit sudoers safely
- Add user to sudo group

    sudo -l
    sudo visudo
    sudo usermod -aG sudo testuser

---

## 🧪 8) Integrity and Package Trust

- Verify package files (if rpm)
- Verify deb package integrity (if deb)
- Show file hashes

RPM-based:

    rpm -Va | head -n 20

DEB-based:

    debsums -s 2>/dev/null || true

Hashes:

    sha256sum /bin/ls
    sha256sum /bin/ls > /tmp/ls.sha256
    sha256sum -c /tmp/ls.sha256

---

## 🧱 9) SELinux Status and Modes (If Present)

- Show SELinux status
- Show current mode
- Set permissive mode
- Set enforcing mode

    sestatus || true
    getenforce || true
    sudo setenforce 0 || true
    getenforce || true
    sudo setenforce 1 || true
    getenforce || true

---

## 🏷️ 10) SELinux Context Inspection

- Show file contexts
- Show process contexts
- Show port contexts

    ls -Z /var/www || true
    ps -eZ | head -n 10 || true
    semanage port -l 2>/dev/null | head -n 20 || true

---

## 🔧 11) Fixing Common SELinux Denials (Label Issues)

- Restore default contexts
- Restore recursively
- Check what would change (dry run)

    sudo restorecon -v /var/www/html || true
    sudo restorecon -Rv /var/www || true
    sudo restorecon -nRv /var/www || true

---

## 🚧 12) Allowing Services on Non-Standard Ports (SELinux)

- Show current allowed ports
- Add new allowed port
- Verify change
- Remove port rule

    semanage port -l | grep http || true
    sudo semanage port -a -t http_port_t -p tcp 8081 || true
    semanage port -l | grep 8081 || true
    sudo semanage port -d -t http_port_t -p tcp 8081 || true

---

## 🧾 13) Diagnosing SELinux Denials

- Search audit log
- Use ausearch
- Use sealert (if present)

    sudo grep -i denied /var/log/audit/audit.log 2>/dev/null | tail -n 20 || true
    sudo ausearch -m avc -ts recent 2>/dev/null || true
    sudo sealert -a /var/log/audit/audit.log 2>/dev/null || true

---

## 🧯 14) Emergency Access Recovery

- Boot into rescue/emergency
- Remount root rw
- Fix permissions or SELinux
- Reboot

    mount -o remount,rw /
    restorecon -Rv / || true
    reboot

---

## 🛡️ 15) Quick Hardening Checklist

- Disable unused services
- Close unused ports
- Remove SUID where not needed
- Verify root login policy
- Verify SSH config

    systemctl --failed
    ss -lntup
    find / -perm -4000 -type f 2>/dev/null
    grep -i '^PermitRootLogin' /etc/ssh/sshd_config || true
    grep -i '^PasswordAuthentication' /etc/ssh/sshd_config || true

---

## ✅ Completion Criteria

You are done with this file when:

- You can quickly prove whether a problem is permissions, firewall, service, or SELinux
- You can fix mislabeled files in seconds
- You can safely open or close ports and services
- You can explain why access is denied, not just guess

---
