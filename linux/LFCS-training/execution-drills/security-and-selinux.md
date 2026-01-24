# 🧪 Security and SELinux / AppArmor — Execution Drills (LFCS)

Path:
  linux/LFCS-training/execution-drills/security-and-selinux.md

Mental mode: Defense, containment, and proof.  
Goal: Audit access, harden services, control exposure, and diagnose **DAC vs MAC** failures under time pressure.

This is not a tutorial.  
This is an execution checklist.

Core law:

If permissions look right but access is denied, assume MAC until proven otherwise.

---

## 🧱 Lab Root (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/security
    cd ~/lfcs-labs/execution-drills/security

---

## 🔎 1) Baseline Security Snapshot

Capture “what is happening” first.

    who > who.txt
    w > w.txt
    last | head -n 50 > last.txt
    ss -lntup > listeners.txt 2>/dev/null || true
    ps aux --sort=-%cpu | head -n 30 > topcpu.txt
    id > identity.txt

Verify:

    ls -l *.txt

---

## 🧱 2) File Permission Audits (High-signal Finds)

World-writable files/dirs:

    sudo find / -xdev -perm -0002 -type f 2>/dev/null | head
    sudo find / -xdev -perm -0002 -type d 2>/dev/null | head

SUID/SGID:

    sudo find / -xdev -perm -4000 -type f 2>/dev/null | head
    sudo find / -xdev -perm -2000 -type d 2>/dev/null | head

Orphans:

    sudo find / -xdev -nouser -o -nogroup 2>/dev/null | head

Rule:
- Use `-xdev` to avoid traversing other mounts during drills.

---

## 🧷 3) ACL Auditing and Control

Inspect (note the `+` in `ls -l` as a clue):

    getfacl file.txt 2>/dev/null || true

Add an ACL:

    setfacl -m u:testuser:r-- file.txt 2>/dev/null || true
    getfacl file.txt 2>/dev/null || true

Remove ACLs (revert to classic DAC):

    setfacl -b file.txt 2>/dev/null || true
    getfacl file.txt 2>/dev/null || true

Default ACL (directory inheritance):

    mkdir -p somedir
    setfacl -d -m u:testuser:rw somedir 2>/dev/null || true
    getfacl somedir 2>/dev/null || true

---

## 🔥 4) Firewall Inspection (UFW / nftables / iptables)

Status (one may exist; you are proving what is active):

    sudo ufw status verbose 2>/dev/null || true
    sudo nft list ruleset 2>/dev/null || true
    sudo iptables -L -n -v 2>/dev/null || true

UFW minimal drill (do not do this remotely without a console):

    sudo ufw allow 22 2>/dev/null || true
    sudo ufw reload 2>/dev/null || true
    sudo ufw status numbered 2>/dev/null || true

---

## 🌐 5) Service Exposure Control (Control Plane)

Prove listener → then act.

    ss -lntup | grep -E ':(22|80|443)\b' || true
    sudo systemctl status nginx --no-pager 2>/dev/null || true

Stop/disable/mask (lab-safe service only):

    sudo systemctl stop nginx 2>/dev/null || true
    sudo systemctl disable nginx 2>/dev/null || true
    sudo systemctl mask nginx 2>/dev/null || true

Verify:

    systemctl is-enabled nginx 2>/dev/null || true
    systemctl status nginx --no-pager 2>/dev/null || true

---

## 🧠 6) sudo Policy Inspection (Safe Workflow)

Rule:
- Always keep one root-capable session open.
- Always edit with `visudo`.

Inspect your effective privileges:

    sudo -l

Edit sudoers safely:

    sudo visudo

---

## 🧪 7) Integrity and Package Trust (Recognition + Minimal Proof)

DEB (optional; may not be installed):

    command -v debsums 2>/dev/null || true
    debsums -s 2>/dev/null || true

RPM (if applicable):

    rpm -Va | head -n 20 2>/dev/null || true

Hash proof pattern:

    sha256sum /bin/ls > ls.sha256
    sha256sum -c ls.sha256

---

# =========================
# 🔐 MAC: SELinux / AppArmor
# =========================

## 🧭 8) Determine What Is In Use (Prove MAC System)

SELinux (RHEL/Fedora family often):

    getenforce 2>/dev/null || echo "no getenforce"
    sestatus 2>/dev/null || true

AppArmor (Debian/Ubuntu often):

    sudo aa-status 2>/dev/null || echo "no aa-status"

Write down:
- SELinux: Enforcing / Permissive / Disabled / Not installed
- AppArmor: enabled + which profiles are enforcing/complain

---

## 🏷️ 9) SELinux Context Inspection (If Present)

File contexts:

    ls -Z /bin/ls 2>/dev/null || true
    ls -Z /usr/bin/sudo 2>/dev/null || true

Process contexts:

    ps auxZ | head 2>/dev/null || true
    ps -eZ | grep -E 'sshd|systemd' 2>/dev/null || true

Format reminder:

    user:role:type:level

---

## 🧱 10) SELinux Modes (Diagnostic Only)

Rule:
- Never leave the system permissive.

    getenforce 2>/dev/null || true
    sudo setenforce 0 2>/dev/null || true
    getenforce 2>/dev/null || true
    sudo setenforce 1 2>/dev/null || true
    getenforce 2>/dev/null || true

---

## 🧩 11) AppArmor Inspection (If Present)

Prove it is active and identify profiles:

    sudo aa-status 2>/dev/null || true
    sudo aa-status 2>/dev/null | head -n 80 || true

Find loaded profiles (kernel interface):

    ls -l /sys/kernel/security/apparmor 2>/dev/null || true
    sudo cat /sys/kernel/security/apparmor/profiles 2>/dev/null | head -n 40 || true

Evidence for denials (varies by distro):

    sudo journalctl -g apparmor --no-pager 2>/dev/null | tail -n 50 || true
    sudo grep -i apparmor /var/log/syslog 2>/dev/null | tail -n 50 || true

Rule:
- LFCS expectation is usually recognition + evidence gathering, not full profile authoring.

---

## 🧪 12) Canonical SELinux Label Drill (Break → Prove → Restore → Persist)

This is the “Phase 10 core” absorbed into the canonical drill.

### 12.1 Create lab web tree

    sudo mkdir -p /var/www/lfcs-mac-lab
    echo "LFCS MAC LAB" | sudo tee /var/www/lfcs-mac-lab/index.html > /dev/null
    ls -l /var/www/lfcs-mac-lab/index.html > mac-lab-dac.txt

### 12.2 Capture current context (if SELinux exists)

    ls -Z /var/www/lfcs-mac-lab/index.html > mac-lab-before.txt 2>/dev/null || echo "no SELinux" > mac-lab-before.txt

### 12.3 Break label (temporary) using chcon (if possible)

    sudo chcon -t user_home_t /var/www/lfcs-mac-lab/index.html 2>/dev/null || true
    ls -Z /var/www/lfcs-mac-lab/index.html > mac-lab-broken.txt 2>/dev/null || echo "no SELinux" > mac-lab-broken.txt

### 12.4 Restore correct label using restorecon (correct fix)

    sudo restorecon -Rv /var/www/lfcs-mac-lab 2>/dev/null || true
    ls -Z /var/www/lfcs-mac-lab/index.html > mac-lab-restored.txt 2>/dev/null || echo "no SELinux" > mac-lab-restored.txt

### 12.5 Prove difference

    diff mac-lab-broken.txt mac-lab-restored.txt > mac-lab-diff.txt 2>/dev/null || true
    ls -l mac-lab-*.txt

Law:
- chcon is temporary
- restorecon is the correct fix for mislabeled files

---

## 🚧 13) Persistent SELinux Fix — semanage fcontext (When Path Is Legit But Non-Standard)

Recognition:

    sudo semanage fcontext -l 2>/dev/null | head || true

Example persistent rule pattern:

    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/lfcs-mac-lab(/.*)?" 2>/dev/null || true
    sudo restorecon -Rv /var/www/lfcs-mac-lab 2>/dev/null || true
    ls -Z /var/www/lfcs-mac-lab/index.html 2>/dev/null || true

Rule:
- Use semanage only when the path is intentionally non-default and must persist.

---

## 🧾 14) Diagnosing SELinux Denials (Evidence)

Audit log (if present):

    sudo ausearch -m avc -ts recent 2>/dev/null || true

Journal fallback:

    sudo journalctl -g denied --no-pager 2>/dev/null | tail -n 50 || true
    sudo journalctl -g avc --no-pager 2>/dev/null | tail -n 50 || true

Optional helper (if present):

    sudo sealert -a /var/log/audit/audit.log 2>/dev/null || true

---

## 🧱 15) SELinux Non-Standard Port Allow (Recognition Drill)

List existing:

    semanage port -l 2>/dev/null | grep -E 'http|http_port_t' || true

Add and remove example port:

    sudo semanage port -a -t http_port_t -p tcp 8081 2>/dev/null || true
    semanage port -l 2>/dev/null | grep 8081 || true
    sudo semanage port -d -t http_port_t -p tcp 8081 2>/dev/null || true

---

## 🧰 16) sysctl — Kernel Security Knobs (Inspect, Set, Persist)

Inspect:

    sysctl -a | head

Read one key:

    sysctl vm.swappiness

Set temporarily:

    sudo sysctl -w vm.swappiness=10
    sysctl vm.swappiness

Persist (preferred: drop-in file):

    echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-lfcs.conf > /dev/null
    sudo sysctl --system
    sysctl vm.swappiness

Rollback (lab):

    sudo rm -f /etc/sysctl.d/99-lfcs.conf
    sudo sysctl --system

---

## ⏱️ 17) Timed Drills (Speed)

MAC status to files (10 seconds):

    getenforce > selinux-mode.txt 2>/dev/null || echo "no getenforce" > selinux-mode.txt
    sudo aa-status > apparmor-status.txt 2>/dev/null || echo "no aa-status" > apparmor-status.txt

Fix mislabeled tree (15 seconds):

    sudo restorecon -Rv /var/www 2>/dev/null || true

---

## ✅ Completion Criteria

You are done with this file when:

- You can classify DAC vs MAC quickly
- You can prove SELinux/AppArmor state with evidence
- You can fix mislabeled files using restorecon (not chmod)
- You can apply persistent fcontext rules correctly (semanage + restorecon)
- You can find denial evidence in logs
- You never leave SELinux permissive

---

## 🧹 Cleanup (Optional)

Remove MAC lab tree:

    sudo rm -rf /var/www/lfcs-mac-lab

Remove sysctl drop-in:

    sudo rm -f /etc/sysctl.d/99-lfcs.conf
    sudo sysctl --system

