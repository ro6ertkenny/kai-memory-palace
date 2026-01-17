# ⚖️ Load Balancer — Operator Basics (nginx / HAProxy, LFCS-Level)

Mental mode: Prove backends, configure minimal proxy, verify distribution, diagnose partial failure.

LFCS does not test HA design or tuning. It tests **basic operational competence**:

- Can you set up a simple reverse proxy / load balancer?
- Can you verify traffic reaches backends?
- Can you tell when one backend is broken?
- Can you fix the smallest thing and move on?

---

## 🧠 The One Mental Model

A load balancer is:

- A **front door**
- That forwards requests to **one of several backends**

If something fails, it is almost always:

- The backend is down
- The backend is unreachable
- The LB is pointing at the wrong place
- The service is not listening

---

## 🎯 LFCS Operator Goals

You must be able to:

- Recognize when a system is acting as a reverse proxy / LB
- Configure a **minimal** load balancer
- Verify which backend handled a request
- Detect:
  - one backend down
  - all backends down
  - LB misconfiguration
- Prove where the failure is: client, LB, or backend

---

## 🔎 Core Inspection Commands

Check listeners:

    ss -lntup

Check backend reachability:

    curl http://<backend-ip>:<port>

Check routing path:

    ip route get <backend-ip>

Check logs:

    journalctl -u nginx || journalctl -u haproxy

---

## 🧱 Option A — nginx as Load Balancer (Most Common LFCS Pattern)

### Minimal example topology

- Backends:
  - 10.0.0.11:80
  - 10.0.0.12:80
- LB listens on:
  - 0.0.0.0:8080

---

### Install nginx

    sudo apt-get install -y nginx || sudo dnf install -y nginx

---

### Minimal config

Create or edit:

    /etc/nginx/conf.d/lb.conf

Example:

    upstream backend_pool {
        server 10.0.0.11:80;
        server 10.0.0.12:80;
    }

    server {
        listen 8080;

        location / {
            proxy_pass http://backend_pool;
        }
    }

---

### Test config and reload

    sudo nginx -t
    sudo systemctl reload nginx

---

### Verify listener

    ss -lntp | grep ':8080 '

---

### Verify behavior

From client:

    curl http://<lb-ip>:8080

Run multiple times and observe responses.

Tip: make each backend return a different hostname so you can see which one answered.

---

## 🧱 Option B — HAProxy (If Present)

### Minimal config location

    /etc/haproxy/haproxy.cfg

Minimal pattern:

    frontend http_front
        bind *:8080
        default_backend http_back

    backend http_back
        balance roundrobin
        server s1 10.0.0.11:80 check
        server s2 10.0.0.12:80 check

Check and reload:

    haproxy -c -f /etc/haproxy/haproxy.cfg
    sudo systemctl reload haproxy

---

## 🧪 Verification Checklist

1) Is the LB listening?

       ss -lntup | grep ':8080 '

2) Can you reach backends directly?

       curl http://10.0.0.11:80
       curl http://10.0.0.12:80

3) Can you reach through the LB?

       curl http://<lb-ip>:8080

---

## 🧯 Common Failure Patterns

---

### 1) All requests fail

Check:

- Is LB service running?
- Is it listening?
- Do backends respond directly?

Commands:

    systemctl status nginx || systemctl status haproxy
    ss -lntup | grep ':8080 '
    curl http://<backend-ip>:<port>

---

### 2) Some requests work, some fail

This means:

- One backend is broken
- One backend is unreachable

Test each backend directly.

Remove or fix the broken one.

---

### 3) LB works locally but not remotely

Think:

- Firewall
- Wrong bind address

Check:

    ss -lntup
    ip addr
    firewall-operator-basics.md

---

### 4) 502 / 504 errors

Means:

- LB cannot reach backend
- Or backend is crashing

Check:

    journalctl -u nginx || journalctl -u haproxy
    curl backend directly

---

## 🧪 LFCS Practice Drills

### Drill 1 — Two backends

1) Set up two simple web servers (even with python -m http.server)
2) Put LB in front
3) Verify both answer

---

### Drill 2 — Kill one backend

1) Stop one backend
2) Observe:
   - Some requests fail or all fail (depending on config)
3) Prove which backend is broken
4) Fix or remove it

---

### Drill 3 — Misconfigure

1) Point LB to wrong port
2) Observe error
3) Read logs
4) Fix config
5) Reload

---

## ⛔ Operator Rules

- Always test backends directly first.
- If LB is broken, prove whether backends are healthy before touching config.
- Always run config test before reload:
  
      nginx -t
      haproxy -c -f ...

- If some requests work and some don’t, think: **partial backend failure**.

---

## 🔗 Cross-Links

- ports-and-listeners.md
- firewall-operator-basics.md
- network-debugging-checklist.md
- scenario-9-dns-or-networking-intermittent.md

---

## 🏁 Exit Criteria (You Are Done When)

- You can set up a minimal LB in under 5 minutes
- You can prove which backend handled a request
- You can detect and explain partial backend failure
- You can fix misconfiguration without guessing

