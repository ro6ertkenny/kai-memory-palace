# 🔐 SSH — Operator Basics (LFCS-Level)

Mental mode: Prove the path, prove the service, prove auth, fix the smallest thing, verify.

LFCS does not test SSH theory. It tests **basic operational control**:

- Can you connect?
- Is the service running and listening?
- Is the port reachable?
- Is authentication configured correctly?
- Can you fix the common failure modes without guessing?

---

## 🧠 The One Mental Model

An SSH login requires **all** of these to be true:

1) Network path works (IP, route, firewall)
2) sshd service is running
3) sshd is listening on the expected port
4) The client is allowed to connect
5) Authentication succeeds (key or password)

If any layer fails, the login fails.

---

## 🎯 LFCS Operator Goals

You must be able to:

- Check sshd service state
- Check listening port(s)
- Test local vs remote connectivity
- Read ssh client error messages
- Read sshd logs
- Fix:
  - service down
  - wrong port
  - firewall block
  - bad permissions on keys
  - bad sshd_config options

---

## 🔎 Core Commands (Must Be Automatic)

Service:

    systemctl status sshd || systemctl status ssh
    sudo systemctl start sshd || sudo systemctl start ssh

Listening sockets:

    ss -lntup | grep ssh

Client test:

    ssh user@host
    ssh -v user@host

Logs:

    journalctl -u sshd --since "10 min ago" || journalctl -u ssh --since "10 min ago"

Config test (before restart):

    sudo sshd -t

---

## 🧪 Standard Operator Workflow

### Step 1 — Is sshd running?

    systemctl status sshd || systemctl status ssh

If not:

    sudo systemctl start sshd || sudo systemctl start ssh

---

### Step 2 — Is it listening?

    ss -lntup | grep ':22 '

If not listening:

- Check config
- Check service logs

---

### Step 3 — Test locally

From the same machine:

    ssh localhost

If localhost fails:

- This is not a firewall or routing problem
- Fix service/config first

---

### Step 4 — Test remotely (with verbosity)

From another machine:

    ssh -v user@host

Look for:

- Connection refused → service not listening or wrong port
- Timeout → firewall or routing
- Permission denied → auth problem

---

## 🧯 Common Failure Patterns

---

### 1) Service is down

Symptoms:

- Connection refused
- No listener on port

Fix:

    sudo systemctl start sshd || sudo systemctl start ssh

Check logs:

    journalctl -u sshd --since "10 min ago" || journalctl -u ssh --since "10 min ago"

---

### 2) Wrong port

Symptoms:

- ssh hangs or refuses
- ss shows sshd on a different port

Check:

    ss -lntup | grep ssh
    grep -E '^Port' /etc/ssh/sshd_config

Connect with:

    ssh -p <port> user@host

---

### 3) Firewall blocking

Symptoms:

- Local ssh works, remote times out

Checks:

- Confirm listener exists
- Use firewall playbook:
  - firewall-operator-basics.md
  - firewall-blocking-traffic.md

---

### 4) Permission denied (keys or password)

Symptoms:

- ssh says: Permission denied (publickey) or (password)

Checks:

On client:

    ssh -v user@host

On server:

    ls -ld /home/user /home/user/.ssh /home/user/.ssh

