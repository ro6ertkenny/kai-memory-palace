# 🧪 Security and SELinux — Execution Drills (LFCS)

Mental mode: Defense, containment, and proof.  
Goal: Be able to **audit access, harden a system, control services, manage firewalling, and diagnose MAC (SELinux/AppArmor) denials** under time pressure.

This is not a tutorial.  
This is an **execution checklist**.

Notes:
- Some systems use **SELinux** (RHEL, Rocky, Alma, Fedora).
- Others use **AppArmor** (Ubuntu, Debian).
- If SELinux is not present, **still practice command recognition and AppArmor inspection**.

Core law:

> If permissions look right but access is denied, assume MAC until proven otherwise.

---

## 🔎 1) Baseline Security Inspection

    who
    w
    last
    ss -lntup
    ps aux | head -n 20

---

## 🔐 2) Account and Authentication Hardening

    sudo passwd -l testuser
    sudo passwd -u testuser
    sudo chage -E 2026-12-31 testuser
    sudo chage -d 0 testuser
    sudo chage -l testuser

---

## 🧱 3) File Permission Audits

    find / -perm -0002 -type f 2>/dev/null
    find / -perm -0002 -type d 2>/dev/null
    find / -perm -4000 -type f 2>/dev/null
    find / -perm -2000 -type d 2>/dev/null
    find / -nouser -o -nogroup 2>/dev/null

---

## 🧷 4) ACL Auditing and Control

    getfacl file.txt
    setfacl -m u:testuser:r-- file.txt
    getfacl file.txt
    setfacl -b file.txt
    setfacl -d -m u:testuser:rw somedir

---

## 🔥 5) Firewall Basics (ufw / nftables / iptables)

    sudo ufw status verbose || sudo nft list ruleset || sudo iptables -L
    sudo ufw allow 22 || true
    sudo ufw deny 1234 || true
    sudo ufw reload || true
    ss -lntup | grep 22 || true

nftables:

    sudo nft list ruleset
    sudo nft list tables

iptables:

    sudo iptables -L -n -v

---

## 🌐 6) Service Exposure Control

    ss -lntup | grep 80 || true
    sudo systemctl stop nginx || true
    sudo systemctl disable nginx || true
    sudo systemctl mask nginx || true

---

## 🧠 7) sudo Policy Inspection

    sudo -l
    sudo visudo
    sudo usermod -aG sudo testuser

---

## 🧪 8) Integrity and Package Trust

RPM:

    rpm -Va | head -n 20 || true

DEB:

    debsums -s 2>/dev/null || true

Hashes:

    sha256sum /bin/ls
    sha256sum /bin/ls > /tmp/ls.sha256
    sha256sum -c /tmp/ls.sha256

---

# =========================
# 🔐 MAC: SELinux / AppArmor
# =========================

## 🧱 9) Determine What Is In Use

SELinux:

    getenforce || true
    sestatus || true

AppArmor:

    sudo aa-status || true

Write down:
- Which one is active?
- In what mode?

---

## 🏷️ 10) SELinux Context Inspection (If Present)

    ls -Z /bin/ls || true
    ls -Z /usr/bin/sudo || true
    ps auxZ | head || true
    ps auxZ | grep -E 'sshd|systemd' || true

Format reminder:

    user:role:type:level

---

## 🧱 11) SELinux Modes (Debug Only)

    getenforce || true
    sudo setenforce 0 || true
    getenforce || true
    sudo setenforce 1 || true
    getenforce || true

Rule:
- Never leave system in permissive.

---

## 🔧 12) Fixing Label Problems (Correct Way)

Preferred fix:

    sudo restorecon -v /var/www/html || true
    sudo restorecon -Rv /var/www || true
    sudo restorecon -nRv /var/www || true

---

## 🚧 13) Persistent Fix — semanage fcontext

    sudo semanage fcontext -l | head || true
    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html/custom(/.*)?" || true
    sudo restorecon -Rv /var/www/html/custom || true

---

## ⚠️ 14) Temporary Fix — chcon (Know Why This Is Bad)

    sudo chcon -t httpd_sys_content_t /var/www/html/index.html || true
    ls -Z /var/www/html/index.html || true

Law:
- chcon is temporary
- will be lost after relabel or restorecon

---

## 🧾 15) Diagnosing SELinux Denials

    sudo grep -i denied /var/log/audit/audit.log 2>/dev/null | tail -n 20 || true
    sudo ausearch -m avc 2>/dev/null || true
    sudo journalctl -g denied || true
    sudo sealert -a /var/log/audit/audit.log 2>/dev/null || true

---

## 🧱 16) Allowing Services on Non-Standard Ports (SELinux)

    semanage port -l | grep http || true
    sudo semanage port -a -t http_port_t -p tcp 8081 || true
    semanage port -l | grep 8081 || true
    sudo semanage port -d -t http_port_t -p tcp 8081 || true

---

## 🧯 17) Emergency Access Recovery

    mount -o remount,rw /
    restorecon -Rv / || true
    reboot

---

## 🛡️ 18) Quick Hardening Checklist

    systemctl --failed
    ss -lntup
    find / -perm -4000 -type f 2>/dev/null
    grep -i '^PermitRootLogin' /etc/ssh/sshd_config || true
    grep -i '^PasswordAuthentication' /etc/ssh/sshd_config || true

---

## 🧠 19) Failure Recognition Drills (Mental)

Scenarios:
- chmod didn’t fix it → check MAC
- Permissions 755 but still denied → ls -Z, getenforce, logs
- Someone set permissive and left it → fix immediately
- Someone used chcon instead of semanage → relabel will break it again

---

## 🧪 20) Timed Drills

    getenforce > /tmp/selinux-mode.txt || true
    ls -Z /usr/bin/less || true
    sudo restorecon -Rv /var/www || true

---

## 🔒 Final Law

If you don’t understand MAC, you will “fix” systems by making them less secure.

---

## ✅ Completion Criteria

You are done with this file when:

- You can prove whether a failure is DAC or MAC
- You can fix mislabeled files in seconds
- You can create persistent SELinux rules correctly
- You never leave systems in permissive mode
- You can explain *why* access is denied, not guess

