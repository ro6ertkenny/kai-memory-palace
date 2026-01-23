# 🧠 Scenario 16 — Image Pull Fails

## 📍 Symptom

The container runtime works.

This succeeds:

    docker run --rm alpine echo hello
    podman run --rm alpine echo hello

But pulling images fails:

    docker pull nginx
    podman pull nginx

Errors may include:

- timeout
- connection refused
- DNS lookup failed
- TLS / certificate error
- authentication required
- manifest not found

The host **may or may not** have working network access.

---

## 🎯 Goal

Determine:

- Whether this is:
  - host networking
  - DNS
  - TLS / certificate trust
  - registry access / auth
  - or container runtime config
- Whether the failure is:
  - general (all images)
  - or specific (one registry or one image)
- Which **layer is actually broken** before changing anything.

---

## 🧭 Operator Rule

> **Prove whether the host can reach the registry before blaming the runtime.**

---

## 🧪 Step 1 — Prove the Runtime Itself Works

Run:

    docker run --rm alpine echo hello
    podman run --rm alpine echo hello

Interpretation:

- If this fails → this is **not** an image pull problem → switch to:
  - scenario-14-container-runtime-down.md
  - and the container-runtime-triage playbook.

- If this works → continue.

---

## 🧪 Step 2 — Reproduce and Capture the Exact Error

Run:

    docker pull alpine
    docker pull nginx

Or:

    podman pull alpine
    podman pull nginx

Observe carefully:

- Is the error:
  - DNS related?
  - timeout / connection?
  - TLS / certificate?
  - authentication?
  - “manifest not found”?

---

## 🧠 Step 3 — Classify the Failure

Use this decision table:

- If **all pulls fail**:
  - Likely host networking, DNS, or TLS trust.

- If **one registry fails but others work**:
  - Likely registry access, auth, or TLS trust.

- If **error mentions DNS**:
  - DNS path is broken.

- If **error mentions x509 / certificate / TLS**:
  - Trust store or TLS path is broken.

- If **error mentions authentication**:
  - Registry auth is required or broken.

---

## 🧪 Step 4 — Prove Host Connectivity (Without Containers)

Test raw network:

    ip a
    ip route
    ping -c 3 8.8.8.8

Test DNS:

    getent hosts registry-1.docker.io
    getent hosts google.com

Test TLS path (basic):

    curl -I https://registry-1.docker.io

Interpretation:

- If host cannot reach IP or resolve names:
  - This is **not** a container problem.
  - Use network-diagnosis-playbook.md.

- If host cannot establish TLS:
  - This is **not** a container problem.
  - Use tls-triage-playbook.md.

- If host works but container pull fails:
  - This is likely runtime config or auth.

---

## 🔎 Step 5 — Check Runtime Registry Configuration

For Docker:

    cat /etc/docker/daemon.json 2>/dev/null

For Podman:

    cat /etc/containers/registries.conf 2>/dev/null
    cat /etc/containers/registries.conf.d/*.conf 2>/dev/null

Look for:

- custom registries
- blocked registries
- mirrors
- insecure registry config
- corporate proxy config

---

## 🧠 Step 6 — Decide What You Are Actually Fixing

Decision table:

- Host network broken:
  → This is **not** a container scenario → use network-diagnosis-playbook.md

- Host TLS broken:
  → This is **not** a container scenario → use tls-triage-playbook.md

- Runtime config blocks registry:
  → This is a **container runtime config** issue

- Auth required:
  → This is a **registry auth** issue

---

## ⚠️ Forbidden Actions

- Do not reinstall Docker/Podman.
- Do not delete container storage.
- Do not disable TLS verification.
- Do not randomly edit registry config.

You are still **in diagnosis mode**.

---

## ✅ Success Criteria

You can explain:

- Why image pulls fail:
  - network
  - DNS
  - TLS
  - auth
  - or runtime config
- Which layer is responsible:
  - host OS
  - or container runtime
- Which **playbook** is correct to continue with:
  - network-diagnosis-playbook.md
  - tls-triage-playbook.md
  - or container-runtime-triage-playbook.md

---

## 🏁 Operator Loop (Reinforced)

Symptom → Reproduce → Classify → Prove host path → Inspect runtime config → Decide → Act → Verify

Never guess.

---

## 📎 Remediation & Reinforcement (After Action)

After fixing the issue using the correct playbook:

- Runtime path:
  - linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md

- Host network path:
  - linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md

- TLS / trust path:
  - linux/LFCS-training/execution-playbooks/tls-triage-playbook.md

Verify using:

    docker pull alpine
    docker pull nginx

Or podman equivalents.

Then verify runtime still works:

    docker run --rm alpine echo hello

