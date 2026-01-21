# 🧪 Service Configuration — Execution Drills (LFCS)

Mental mode: Configure and prove.  
Goal: Be able to **stand up, verify, and secure core Linux network services** that LFCS explicitly tests.

This is not a tutorial.  
This is an **execution checklist**.

Separation of concerns:
- This file = configure specific services (SSH/DNS/HTTP/Proxy/DB)
- services-and-logging.md = systemd mechanics, targets, journald, scheduling, recovery

Notes:
- Packages/services vary by distro. Each section includes “detect + install + verify”.
- If a service is not available, drill the *recognition + verification commands* anyway.
- Prefer loopback (127.0.0.1) to avoid external dependencies.

---

## 🧭 0) Detect Platform and Package Manager

- Confirm distro and init system
- Confirm apt-get and systemctl exist

    cat /etc/os-release
    uname -a
    ps -p 1 -o comm=
    command -v apt-get
    command -v systemctl

---

## 🔐 1) SSH Client + Server (Baseline)

Objectives:
- Verify SSH is installed
- Control ssh service
- Validate config safely

Detect/install:

    command -v ssh
    command -v sshd || true
    sudo apt-get update
    sudo apt-get install -y openssh-server

Verify service + port:

    systemctl status ssh --no-pager || true
    sudo systemctl enable --now ssh
    ss -lntup | grep ':22' || true

Client drills:

    ssh -V
    ssh localhost
    ssh -o PreferredAuthentications=publickey -o PasswordAuthentication=no localhost || true

Config drills (non-destructive inspection):

    sudo sshd -T | head -n 30
    sudo grep -E '^(Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication|AllowUsers|AllowGroups)' /etc/ssh/sshd_config || true

Safe change drill (choose one small change, then validate):

    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sudoedit /etc/ssh/sshd_config
    sudo sshd -t
    sudo systemctl restart ssh
    systemctl status ssh --no-pager

Rollback drill:

    sudo cp /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
    sudo sshd -t
    sudo systemctl restart ssh

---

## 🌐 2) Caching DNS Resolver (local caching)

Objective:
- Configure a caching DNS server (dnsmasq or unbound)

Preferred minimal option: dnsmasq.

Detect/install dnsmasq:

    command -v dnsmasq || true
    sudo apt-get update
    sudo apt-get install -y dnsmasq

Enable + verify port 53:

    systemctl status dnsmasq --no-pager || true
    sudo systemctl enable --now dnsmasq
    ss -lnup | grep ':53' || true

Resolver wiring:

    resolvectl status 2>/dev/null || true
    cat /etc/resolv.conf

Drill (only if /etc/resolv.conf is directly managed):

    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    printf "nameserver 127.0.0.1\n" | sudo tee /etc/resolv.conf > /dev/null

Verify resolution:

    getent hosts github.com
    dig github.com 2>/dev/null || true
    resolvectl query github.com 2>/dev/null || true

Observe dnsmasq logs:

    journalctl -u dnsmasq --since "10 minutes ago" --no-pager

Rollback:

    sudo cp /etc/resolv.conf.bak /etc/resolv.conf || true

---

## 🧾 3) DNS Zone Maintenance (authoritative DNS basics)

Objective:
- Maintain a DNS zone (BIND9)

Detect/install:

    command -v named || true
    sudo apt-get update
    sudo apt-get install -y bind9 dnsutils

Enable:

    systemctl status bind9 --no-pager || true
    sudo systemctl enable --now bind9

Create a local test zone: lab.invalid

Backup:

    sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak

Create zone file:

    sudo mkdir -p /etc/bind/zones
    sudoedit /etc/bind/zones/db.lab.invalid

Example contents:

    ;
    ; lab.invalid zone
    ;
    $TTL 86400
    @   IN  SOA ns.lab.invalid. admin.lab.invalid. (
            2026011701
            3600
            1800
            604800
            86400
        )
        IN  NS  ns.lab.invalid.

    ns  IN  A   127.0.0.1
    www IN  A   127.0.0.1

Add zone definition:

    sudoedit /etc/bind/named.conf.local

Add:

    zone "lab.invalid" {
        type master;
        file "/etc/bind/zones/db.lab.invalid";
    };

Validate:

    sudo named-checkconf
    sudo named-checkzone lab.invalid /etc/bind/zones/db.lab.invalid

Restart + query:

    sudo systemctl restart bind9
    dig @127.0.0.1 www.lab.invalid
    dig @127.0.0.1 ns.lab.invalid

Update drill:
- edit record
- bump serial
- re-checkzone
- reload

Rollback:

    sudo cp /etc/bind/named.conf.local.bak /etc/bind/named.conf.local
    sudo systemctl restart bind9

---

## ✉️ 4) Email Aliases (/etc/aliases)

Objective:
- Configure email aliases

Install minimal tools:

    sudo apt-get update
    sudo apt-get install -y bsd-mailx postfix

Inspect aliases:

    sudo test -f /etc/aliases && sudo head -n 30 /etc/aliases || true
    sudo newaliases

Create alias (example root -> your user):

    sudo cp /etc/aliases /etc/aliases.bak
    sudoedit /etc/aliases

Add line:

    root: ro6ert

Rebuild DB:

    sudo newaliases
    ls -la /etc/aliases.db 2>/dev/null || true

Send a local test mail:

    echo "alias test" | mail -s "LFCS alias test" root

Check local mail spool:

    ls -la /var/mail 2>/dev/null || true
    sudo tail -n 50 /var/mail/ro6ert 2>/dev/null || true

Rollback:

    sudo cp /etc/aliases.bak /etc/aliases
    sudo newaliases

---

## 🧭 5) HTTP Proxy Restrictions (Squid)

Objective:
- Restrict access to an HTTP proxy server

Install:

    sudo apt-get update
    sudo apt-get install -y squid

Enable + verify port:

    systemctl status squid --no-pager || true
    sudo systemctl enable --now squid
    ss -lntup | grep ':3128' || true

Baseline proxy test (may fail without outbound access; still drill the command):

    curl -I -x http://127.0.0.1:3128 http://example.com 2>/dev/null | head -n 5 || true

Restrict proxy to localhost only:

    sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
    sudoedit /etc/squid/squid.conf

Ensure ordering allows localhost and denies all others:

    acl localnet src 127.0.0.1/32
    http_access allow localnet
    http_access deny all

Validate + restart:

    sudo squid -k parse
    sudo systemctl restart squid
    systemctl status squid --no-pager

Rollback:

    sudo cp /etc/squid/squid.conf.bak /etc/squid/squid.conf
    sudo systemctl restart squid

---

## 🌍 6) HTTP Server + Log Files (nginx or apache2)

Objectives:
- Configure HTTP server
- Configure log files
- Prove service is reachable locally

Choose one: nginx (lightweight) or apache2.

### Option A: nginx

Install + enable:

    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl enable --now nginx
    ss -lntup | grep ':80' || true
    curl -I http://127.0.0.1 | head -n 5

Inspect logs:

    sudo ls -la /var/log/nginx 2>/dev/null || true
    sudo tail -n 50 /var/log/nginx/access.log 2>/dev/null || true
    sudo tail -n 50 /var/log/nginx/error.log 2>/dev/null || true

Custom logs drill:

    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
    sudoedit /etc/nginx/sites-available/default

Inside server block add:

    access_log /var/log/nginx/lab_access.log;
    error_log  /var/log/nginx/lab_error.log;

Validate + reload:

    sudo nginx -t
    sudo systemctl reload nginx
    curl -I http://127.0.0.1 | head -n 5
    sudo tail -n 20 /var/log/nginx/lab_access.log 2>/dev/null || true

Rollback:

    sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
    sudo nginx -t
    sudo systemctl reload nginx

### Option B: apache2

Install + enable:

    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl enable --now apache2
    ss -lntup | grep ':80' || true
    curl -I http://127.0.0.1 | head -n 5

Inspect logs:

    sudo ls -la /var/log/apache2 2>/dev/null || true
    sudo tail -n 50 /var/log/apache2/access.log 2>/dev/null || true
    sudo tail -n 50 /var/log/apache2/error.log 2>/dev/null || true

Config test + reload:

    sudo apache2ctl -t
    sudo systemctl reload apache2

---

## 🔒 7) Restrict Access to a Web Page (Basic Auth)

Objective:
- Restrict access to a web page (nginx pattern)

Install auth tools:

    sudo apt-get update
    sudo apt-get install -y apache2-utils

Create password file:

    sudo mkdir -p /etc/nginx/auth
    sudo htpasswd -c /etc/nginx/auth/lab.htpasswd labuser

Protect /private:

    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.authbak
    sudoedit /etc/nginx/sites-available/default

Inside server block add:

    location /private {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/auth/lab.htpasswd;
        try_files $uri =404;
    }

Create protected content:

    sudo mkdir -p /var/www/html/private
    echo "restricted" | sudo tee /var/www/html/private/index.html > /dev/null

Validate + reload:

    sudo nginx -t
    sudo systemctl reload nginx

Verify:

    curl -I http://127.0.0.1/private/ | head -n 5

Rollback:

    sudo cp /etc/nginx/sites-available/default.authbak /etc/nginx/sites-available/default
    sudo nginx -t
    sudo systemctl reload nginx

---

## 🗄️ 8) Database Server (Basic Operations)

Objective:
- Configure a database server (MariaDB or PostgreSQL)

### Option A: MariaDB

    sudo apt-get update
    sudo apt-get install -y mariadb-server
    sudo systemctl enable --now mariadb
    systemctl status mariadb --no-pager
    ss -lntup | grep ':3306' || true

SQL drills:

    sudo mysql -e "SELECT VERSION();"
    sudo mysql -e "CREATE DATABASE lfcs_lab;"
    sudo mysql -e "SHOW DATABASES;"
    sudo mysql -e "DROP DATABASE lfcs_lab;"

### Option B: PostgreSQL

    sudo apt-get update
    sudo apt-get install -y postgresql
    sudo systemctl enable --now postgresql
    systemctl status postgresql --no-pager
    ss -lntup | grep ':5432' || true

SQL drills:

    sudo -u postgres psql -c "SELECT version();"
    sudo -u postgres createdb lfcs_lab
    sudo -u postgres psql -l | head -n 20
    sudo -u postgres dropdb lfcs_lab

---

## 🧪 9) Containers and Virtual Machines (Domain Tie-In)

Objective:
- Recognize container and virtualization surfaces

You already have a dedicated drill file:
- execution-drills/containers-and-virtualization.md

Verification:

    test -f linux/LFCS-training/execution-drills/containers-and-virtualization.md && echo "containers drill present"

Virtualization awareness:

    systemd-detect-virt
    lscpu | grep -i virtualization || true
    ls -l /dev/kvm 2>/dev/null || true

---

## ✅ Completion Criteria

You are done with this file when:

- You can stand up and validate core services quickly
- You can verify each service via: ports, config test, status, and client query
- You can roll back safely using backups + reloads/restarts (no panic edits)

---
EOF

---
