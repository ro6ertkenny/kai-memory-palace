# 🌐 dns-and-name-resolution.md — How Names Become Addresses

## 🎯 Purpose

Understand **how Linux turns names into IP addresses**.

This file trains you to:

- read `/etc/resolv.conf`
- understand what DNS servers are being used
- use `getent` to test the real resolver path
- understand **NSS** (Name Service Switch)
- diagnose “IP works but names don’t” failures

On the exam: if `ping 8.8.8.8` works but `ping google.com` fails — this is where you debug.

---

## 🧠 Mental Model

> Applications do **not** talk to DNS directly.  
> They talk to **NSS**.  
> NSS decides **where to look** (files, DNS, etc).

---

## 🔎 Core Commands

- `cat /etc/resolv.conf` → see configured DNS servers
- `getent hosts google.com` → test the **real resolver path**
- `ping google.com` → test resolution + connectivity
- `curl https://example.com` → test name + TCP + TLS

---

# 🧱 Part 1 — `/etc/resolv.conf`

Example from your system:

    search attlocal.net
    nameserver 1.1.1.1
    nameserver 8.8.8.8
    nameserver 2600:1700:ff00:5a80::1

Meaning:

- `search` = domain suffix automatically tried
- `nameserver` = DNS servers to query (in order)

---

## 🧠 Important Truth

> This file controls **which DNS servers** are used.  
> It does **not** control the whole resolution logic.

That is NSS.

---

# 🧱 Part 2 — What Is `getent` (NT)

`getent` means:

> **get entries**

It queries the **Name Service Switch** exactly the same way real programs do.

Run:

    getent hosts google.com

Example output:

    2607:f8b0:4002:c05::71 google.com
    2607:f8b0:4002:c05::8a google.com
    ...

Meaning:

- name resolution is working
- NSS + DNS path is working
- IPv6 answers are being returned

---

## 🧠 Why `getent` Is Exam-Gold

> If `getent hosts name` fails, **the system cannot resolve names**.

It tests:

- NSS
- `/etc/nsswitch.conf`
- `/etc/hosts`
- DNS
- resolver config

All in one.

---

# 🧱 Part 3 — NSS (Name Service Switch) (NT)

NSS is configured in:

    /etc/nsswitch.conf

Look for:

    hosts: files dns

Meaning:

> When resolving hostnames:
> 1) check `/etc/hosts`
> 2) then ask DNS

Other possible sources:

- ldap
- mdns
- myhostname
- etc

---

## 🧠 The Real Resolution Flow

When a program wants to resolve a name:

1. It asks NSS
2. NSS consults `/etc/nsswitch.conf`
3. NSS tries sources in order:
   - files (`/etc/hosts`)
   - dns
4. DNS servers come from `/etc/resolv.conf`

---

# 🧱 Part 4 — `/etc/hosts`

This is **local override**.

Example:

    127.0.0.1 mytest

Now:

    getent hosts mytest

Will resolve **without DNS**.

---

# 🧱 Part 5 — Failure Patterns (Exam Grade)

## Case 1: IP works, names do not

Test:

    ping 1.1.1.1   # works
    ping google.com # fails

Check:

- `/etc/resolv.conf`
- `getent hosts google.com`

---

## Case 2: `ping` fails but `getent` works

This means:

> DNS is working. Network or firewall is the problem.

---

## Case 3: `getent` fails immediately

This means:

> NSS / resolver path is broken.

Check:

- `/etc/nsswitch.conf`
- `/etc/resolv.conf`

---

# 🧱 Part 6 — IPv4 vs IPv6 Surprises

Your system prefers IPv6 if available.

Example:

    ping google.com

Returns:

    PING google.com (2607:f8b0:...)

That is normal.

If IPv6 is broken, you may see:

- name resolves
- but connections fail

Test IPv4 explicitly:

    ping -4 google.com

---

# 🧪 Exam Debug Flow

1. `ping 1.1.1.1`
2. `getent hosts google.com`
3. `ping google.com`
4. `cat /etc/resolv.conf`
5. `cat /etc/nsswitch.conf | grep hosts`

---

# 🧪 Practical Drills

Run:

    getent hosts google.com
    getent hosts localhost
    cat /etc/resolv.conf

Add a temporary entry to `/etc/hosts` and test resolution.

---

## ✅ Exit Criteria

You are done with this file when:

- you understand what `getent` really tests
- you understand NSS
- you can diagnose name resolution failures **systematically**

You now understand **DNS and name resolution**.
EOF

