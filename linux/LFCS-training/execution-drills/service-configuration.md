# 🧪 Service Configuration — Execution Drills (LFCS)

Mental mode: Configure and prove.  
Goal: Be able to **stand up, verify, and secure core Linux network services** that LFCS explicitly tests.

This is not a tutorial.  
This is an **execution checklist**.

Notes:
- Packages/services vary by distro. Each section includes “detect + install + verify”.
- If a service is not available on your system, you still drill the *recognition + verification commands*.
- Use loopback (127.0.0.1) when possible to avoid external dependencies.

---

## 🧭 0) Detect Platform and Package Manager

- Confirm distro and init system
- Confirm you’re using apt-get (Debian/Ubuntu)

    cat /etc/os-release
    uname -a
    ps -p 1 -o comm=
    command -v apt-get
    command -v systemctl

---

## 🔐 1) SSH Client + Server (Baseline Service Control)

Objectives:
- Configure SSH servers and clients
- Verify configuration and access

Detect/install:

    command -v ssh
    command -v sshd || command -v sshd_config || true
    sudo apt-get update
    sudo apt-get install -y openssh-server

Service control:

    systemctl status ssh
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

---

## 🌐 2) Caching DNS Resolver (local caching)

Objective:
- Configure a caching DNS server

Preferred minimal option for Debian-based systems: dnsmasq.
Alternative: unbound (also valid).

Detect/install dnsmasq:

    command -v dnsmasq || true
    sudo apt-get update
    sudo apt-get install -y dnsmasq

Service and port:

    systemctl status dnsmasq || true
    sudo systemctl enable --now dnsmasq
    ss -lnup | grep ':53' || true

Resolver wiring (systemd-resolved vs resolv.conf):

    resolvectl status || true
    cat /etc/resolv.conf

Drill: point resolver at local cache (choose one approach based on your system)

If /etc/resolv.conf is directly managed:

    sudo cp /etc/resolv.conf /etc/resolv.conf.bak
    printf "nameserver 127.0.0.1\n" | sudo tee /etc/resolv.conf

Verify cached resolution:

    getent hosts github.com
    dig github.com 2>/dev/null || true
    resolvectl query github.com 2>/dev/null || true

Drill: observe dnsmasq logs (journal):

    journalctl -u dnsmasq --since "10 minutes ago" --no-pager

Rollback drill:

    sudo cp /etc/resolv.conf.bak /etc/resolv.conf || true

---

## 🧾 3) DNS Zone Maintenance (authoritative DNS basics)

Objective:
- Maintain a DNS zone

This is typically BIND9 (named). You don’t need the internet; use a local test zone.

Detect/install bind9:

    command -v named || true
    sudo apt-get update
    sudo apt-get install -y bind9 dnsutils

Service control:

    systemctl status bind9
    sudo systemctl enable --now bind9

Create a simple local zone (lab.invalid) and validate config.
Paths may differ; Debian typically uses /etc/bind.

Backup configs:

    sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak

Create zone file:

    sudo mkdir -p /etc/bind/zones
    sudoedit /etc/bind/zones/db.lab.invalid

Example zone contents (write in the file):

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

Validate BIND config:

    sudo named-checkconf
    sudo named-checkzone lab.invalid /etc/bind/zones/db.lab.invalid

Restart and query locally:

    sudo systemctl restart bind9
    dig @127.0.0.1 www.lab.invalid
    dig @127.0.0.1 ns.lab.invalid

Drill: update record and bump serial:

    sudoedit /etc/bind/zones/db.lab.invalid
    sudo named-checkzone lab.invalid /etc/bind/zones/db.lab.invalid
    sudo systemctl reload bind9

Rollback:

    sudo cp /etc/bind/named.conf.local.bak /etc/bind/named.conf.local
    sudo systemctl restart bind9

---

## ✉️ 4) Email Aliases (/etc/aliases)

Objective:
- Configure email aliases

Even without a full MTA, you can drill aliases management.

Detect/install minimal tools:

    sudo apt-get update
    sudo apt-get install -y bsd-mailx postfix

Inspect aliases:

    sudo test -f /etc/aliases && sudo head -n 30 /etc/aliases || true
    sudo newaliases

Create an alias (example: root -> your user):

    sudo cp /etc/aliases /etc/aliases.bak
    sudoedit /etc/aliases

Add line:

    root: ro6ert

Rebuild aliases DB:

    sudo newaliases

Verify alias DB exists:

    ls -la /etc/aliases.db || true

Drill: send a local test mail:

    echo "alias test" | mail -s "LFCS alias test" root

Check local mail spool (path varies):

    ls -la /var/mail || true
    sudo ls -la /var/mail/root 2>/dev/null || true
    sudo tail -n 50 /var/mail/ro6ert 2>/dev/null || true

Rollback:

    sudo cp /etc/aliases.bak /etc/aliases
    sudo newaliases

---

## 🧭 5) HTTP Proxy Restrictions (Squid)

Objective:
- Restrict access to an HTTP proxy server

Detect/install squid:

    sudo apt-get update
    sudo apt-get install -y squid

Service control:

    systemctl status squid
    sudo systemctl enable --now squid
    ss -lntup | grep ':3128' || true

Baseline proxy test (may require curl supports proxy):

    curl -I -x http://127.0.0.1:3128 http://example.com 2>/dev/null | head -n 5 || true

Restrict proxy to localhost only (simple, high-signal drill):

    sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak
    sudoedit /etc/squid/squid.conf

Add or modify rules near the top (order matters). Ensure:
- allow localhost
- deny all others

Example minimal ACL logic:

    acl localnet src 127.0.0.1/32
    http_access allow localnet
    http_access deny all

Validate and restart:

    sudo squid -k parse
    sudo systemctl restart squid
    systemctl status squid --no-pager

Verify blocked behavior (from non-localhost host if available) and allowed from localhost.

Rollback:

    sudo cp /etc/squid/squid.conf.bak /etc/squid/squid.conf
    sudo systemctl restart squid

---

## 🌍 6) HTTP Server + Log Files (nginx or apache2)

Objectives:
- Configure an HTTP server
- Configure HTTP server log files
- Restrict access to a web page

Choose one: nginx (lightweight) or apache2.

### Option A: nginx

Install and enable:

    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl enable --now nginx
    ss -lntup | grep ':80' || true
    curl -I http://127.0.0.1 | head -n 5

Inspect logs:

    sudo ls -ლა /var/log/nginx 2>/dev/null || ls -la /var/log/nginx
    sudo tail -n 50 /var/log/nginx/access.log 2>/dev/null || true
    sudo tail -n 50 /var/log/nginx/error.log 2>/dev/null || true

Configure custom access/error logs (site config):

    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
    sudoedit /etc/nginx/sites-available/default

Add inside the server block:

    access_log /var/log/nginx/lab_access.log;
    error_log  /var/log/nginx/lab_error.log;

Validate and reload:

    sudo nginx -t
    sudo systemctl reload nginx
    curl -I http://127.0.0.1 | head -n 5
    sudo tail -n 20 /var/log/nginx/lab_access.log 2>/dev/null || true

Rollback:

    sudo cp /etc/nginx/sites-available/default.bak /etc/nginx/sites-available/default
    sudo nginx -t
    sudo systemctl reload nginx

### Option B: apache2

Install and enable:

    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl enable --now apache2
    ss -lntup | grep ':80' || true
    curl -I http://127.0.0.1 | head -n 5

Inspect logs:

    sudo ls -la /var/log/apache2 2>/dev/null || true
    sudo tail -n 50 /var/log/apache2/access.log 2>/dev/null || true
    sudo tail -n 50 /var/log/apache2/error.log 2>/dev/null || true

Custom logs via vhost (drill):

    sudo apache2ctl -t
    sudo systemctl reload apache2

---

## 🔒 7) Restrict Access to a Web Page (Basic Auth)

Objective:
- Restrict access to a web page

This drill uses nginx + basic auth (high-signal) and tests end-to-end.

Install auth tools:

    sudo apt-get update
    sudo apt-get install -y apache2-utils

Create password file:

    sudo mkdir -p /etc/nginx/auth
    sudo htpasswd -c /etc/nginx/auth/lab.htpasswd labuser

Configure a protected location (nginx default site example):

    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.authbak
    sudoedit /etc/nginx/sites-available/default

Add inside server block:

    location /private {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/auth/lab.htpasswd;
        try_files $uri =404;
    }

Create protected content:

    sudo mkdir -p /var/www/html/private
    echo "restricted" | sudo tee /var/www/html/private/index.html

Validate and reload:

    sudo nginx -t
    sudo systemctl reload nginx

Verify behavior:

    curl -I http://127.0.0.1/private/ | head -n 5
    curl -u labuser:password http://127.0.0.1/private/ 2>/dev/null || true

Rollback:

    sudo cp /etc/nginx/sites-available/default.authbak /etc/nginx/sites-available/default
    sudo nginx -t
    sudo systemctl reload nginx

---

## 🗄️ 8) Database Server (Basic Operations)

Objective:
- Configure a database server

Choose one: MariaDB (MySQL) or PostgreSQL.

### Option A: MariaDB

Install and enable:

    sudo apt-get update
    sudo apt-get install -y mariadb-server
    sudo systemctl enable --now mariadb
    systemctl status mariadb --no-pager

Secure baseline (interactive):

    sudo mysql_secure_installation

Basic SQL drills:

    sudo mysql -e "SELECT VERSION();"
    sudo mysql -e "CREATE DATABASE lfcs_lab;"
    sudo mysql -e "SHOW DATABASES;"
    sudo mysql -e "DROP DATABASE lfcs_lab;"

Confirm listening socket/port:

    ss -lntup | grep ':3306' || true

### Option B: PostgreSQL

Install and enable:

    sudo apt-get update
    sudo apt-get install -y postgresql
    sudo systemctl enable --now postgresql
    systemctl status postgresql --no-pager

Basic SQL drills:

    sudo -u postgres psql -c "SELECT version();"
    sudo -u postgres createdb lfcs_lab
    sudo -u postgres psql -l | head -n 20
    sudo -u postgres dropdb lfcs_lab

Confirm listening port:

    ss -lntup | grep ':5432' || true

---

## 🧪 9) Containers and Virtual Machines (Service Domain Tie-In)

Objective:
- Manage and configure containers
- Manage and configure virtual machines

You already have a dedicated execution drill file:
- execution-drills/containers-and-virtualization.md

Verification drill:

    test -f linux/LFCS-training/execution-drills/containers-and-virtualization.md && echo "containers drill present"

Virtualization awareness drill:

    systemd-detect-virt
    lscpu | grep -i virtualization || true
    ls -l /dev/kvm 2>/dev/null || true

---

## ✅ Completion Criteria

You are done with this file when:

- You can bring up SSH, DNS cache, a DNS zone, squid restrictions, HTTP logs, basic auth, and a DB service quickly
- You can validate each service via: ports, config test, status, and a client query
- You can roll back safely with backups and reloads (no panic edits)

---
