# 🧠 Scenario 15 — Container Networking Is Broken

## 📍 Symptom

The container runtime works.

This succeeds:

    docker run --rm alpine echo hello
    podman run --rm alpine echo hello

But any of these fail:

- Port publishing does not work:

    docker run -d -p 8080:80 nginx
    curl http://127.0.0.1:8080   → connection refused / timeout

- Or containers cannot reach the network:

    docker run --rm alpine ping -c 3 8.8.8.8   → fails
    docker run --rm alpine getent hosts google.com → fails

The host itself has working network access.

---

## 🎯 Goal

Determine:

- Whether the failure is:
  - container → host port publishing
  - container → outside world connectivity
  - DNS inside containers
  - or container network stack setup
- Whether the container is actually running and listening
- Whether the problem is:
  - runtime networking
  - firewall / policy
  - or host networking

And identify **which layer is broken** before touching anything.

---

## 🧭 Operator Rule

> **Prove where the packet dies before changing anything.**

---

## 🧪 Step 1 — Prove the Runtime Itself Works

Run:

    docker run --rm alpine echo hello
    podman run --rm alpine echo hello

Interpretation:

- If this fails → this is **not** a networking scenario → switch to:
  - scenario-14-container-runtime-down.md
  - and the container-runtime-triage playbook.

- If this works → continue.

---

## 🧪 Step 2 — Classify Which Networking Path Is Broken

### A) Test outbound connectivity from a container

    docker run --rm alpine ping -c 3 8.8.8.8
    docker run --rm alpine getent hosts google.com

Interpretation:

- If both fail → containers cannot reach the network.
- If ping works but DNS fails → container DNS is broken.
- If both work → outbound is fine → check port publishing.

---

### B) Test port publishing

    docker run -d --name web -p 8080:80 nginx
    curl http://127.0.0.1:8080

Also check:

    docker ps
    ss -lntup | grep 8080

Interpretation:

- If container is not running → this is **not** a networking problem → inspect container failure.
- If container is running but host is not listening → publish path is broken.
- If host is listening but curl fails → firewall / policy / routing path is broken.

---

## 🧠 Step 3 — Decide Which Layer Is Broken

Use this decision table:

- If containers cannot ping external IP:
  - Container → host NAT / routing is broken.

- If containers can ping IP but cannot resolve names:
  - Container DNS is broken.

- If outbound works but port publishing does not:
  - Host ↔ container bridge / NAT / firewall path is broken.

- If host is not listening on published port:
  - Runtime publish path or command is wrong.

---

## 🔎 Step 4 — Inspect Without Changing Anything

Check host networking:

    ip a
    ip route

Check listening ports:

    ss -lntup

Check firewall (one may exist):

    iptables -L
    nft list ruleset

Check container networks:

    docker network ls
    docker network inspect bridge

Or for podman:

    podman network ls
    podman network inspect podman

---

## ⚠️ Forbidden Actions

- Do not flush firewall rules blindly.
- Do not delete container networks blindly.
- Do not restart the runtime yet.
- Do not assume “Docker is broken”.

You are still **in diagnosis mode**.

---

## ✅ Success Criteria

You can explain:

- Which path is broken:
  - container → internet
  - container DNS
  - host → container port publishing
- Which layer is responsible:
  - runtime networking
  - host firewall / policy
  - host routing
- What the **correct playbook** is to continue with:
  - network-diagnosis-playbook.md
  - or container-runtime-triage-playbook.md

---

## 🏁 Operator Loop (Reinforced)

Symptom → Classify path → Prove layer → Inspect → Decide → Act → Verify

Never guess.

---

## 📎 Remediation & Reinforcement (After Action)

After you fix the issue using the appropriate playbook:

- Container runtime path:
  - linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md

- Host networking / firewall path:
  - linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md

Verify using **both**:

    docker run --rm alpine ping -c 3 8.8.8.8
    docker run -d --name web -p 8080:80 nginx
    curl http://127.0.0.1:8080

Then clean up:

    docker rm -f web

Or podman equivalents.

