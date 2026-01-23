# 🧠 Scenario — Container Runtime Is Down

**Path:** `linux/LFCS-training/failure-scenarios/scenario-14-container-runtime-down.md`  
Mental mode: **Diagnosis, recovery, and proof**.  
Purpose: Restore **basic container capability** when the runtime/daemon is not usable.

This is not a tutorial.  
This is **simulate → diagnose → fix → verify**.

---

## 📍 Symptom

You run a container command and it fails immediately.

Examples:

- `docker ps` fails with “Cannot connect to the Docker daemon…”
- `docker run …` fails with a daemon/socket error
- `podman ps` fails (rootless or service-related)
- `nerdctl ps` fails (containerd-facing tool)
- A task prompt says: “Containers won’t run on this host.”

You do not know yet whether this is:

- runtime/daemon down
- permissions/socket issue
- package/tooling mismatch
- dependency failure (storage/network) causing runtime to fail

---

## 🎯 Goal

Prove:

- what container tool/runtime exists on the host
- whether the runtime service is **active or failed**
- what the failure reason is (logs)
- the minimum safe correction
- that containers run again using a known-good verification

---

## 🧭 Operator Rule

> **Detect first. Fix second. Verify with a known-good container.**

Never start by reinstalling or deleting runtime state.

---

## 🧪 Step 1 — Detect What Exists (No Changes)

Run:

    command -v docker || true
    command -v podman || true
    command -v nerdctl || true
    command -v ctr || true

If `docker` exists:

    docker --version 2>/dev/null || true

If `podman` exists:

    podman --version 2>/dev/null || true

Interpretation:

- You must not assume Docker is present.
- You must not assume systemd-managed Docker is the intended runtime.
- Your next steps depend on what you detect.

---

## 🧪 Step 2 — Confirm Runtime Service State (Supervisor View)

If Docker is present:

    systemctl status docker --no-pager 2>/dev/null || true
    systemctl status containerd --no-pager 2>/dev/null || true

If containerd-only tooling exists:

    systemctl status containerd --no-pager 2>/dev/null || true

If Podman is present:

    systemctl status podman --no-pager 2>/dev/null || true

Interpretation:

- If the expected service is **inactive/failed** → this is a service recovery problem.
- If the service is **active** but tooling errors → likely permissions/socket/config mismatch.

---

## 🔎 Step 3 — Capture Evidence (Logs) Before Touching Anything

If Docker is expected:

    sudo journalctl -u docker --no-pager -n 120 2>/dev/null || true
    sudo journalctl -u containerd --no-pager -n 120 2>/dev/null || true

If containerd is expected:

    sudo journalctl -u containerd --no-pager -n 120 2>/dev/null || true

If Podman is expected:

    sudo journalctl -u podman --no-pager -n 120 2>/dev/null || true

Interpretation:

- You are looking for the reason it fails:
  - missing/corrupt config
  - permission denied
  - storage path issues
  - start-limit hit
  - dependency not present
- Do not restart in loops without new evidence.

---

## 🧪 Step 4 — Attempt Controlled Recovery (Minimum Safe Action)

If Docker service is down:

    sudo systemctl start docker 2>/dev/null || true
    sudo systemctl restart docker 2>/dev/null || true

If containerd service is down:

    sudo systemctl start containerd 2>/dev/null || true
    sudo systemctl restart containerd 2>/dev/null || true

If Podman service is down (if applicable):

    sudo systemctl start podman 2>/dev/null || true
    sudo systemctl restart podman 2>/dev/null || true

Re-check:

    systemctl status docker --no-pager 2>/dev/null || true
    systemctl status containerd --no-pager 2>/dev/null || true
    systemctl status podman --no-pager 2>/dev/null || true

Decision:

- If the service still fails → stop and go back to logs (Step 3).  
  Treat as a service recovery incident using the service recovery algorithm.

---

## ✅ Step 5 — Prove Runtime Works (Known-Good Verification)

If Docker is present:

    docker pull alpine
    docker run --rm alpine echo hello

If Podman is present:

    podman pull alpine
    podman run --rm alpine echo hello

If nerdctl is present:

    nerdctl pull alpine
    nerdctl run --rm alpine echo hello

Interpretation:

- Pull verifies:
  - runtime + network path to registry
- Run verifies:
  - runtime can create/start containers
  - the runtime is operational, not merely “running”

---

## ⚠️ Forbidden Actions

- Do not reinstall packages as the first move.
- Do not delete runtime state directories as the first move.
- Do not “fix by upgrading” in the middle of diagnosis.
- Do not loop restarts without reading logs.

---

## ✅ Success Criteria

You can state:

- which tool/runtime is present (docker/podman/nerdctl)
- whether the runtime service was down or misbehaving
- what evidence (status/logs) proved the failure mode
- what minimal corrective action restored service
- that `alpine` runs and prints `hello`

---

## 📎 Remediation & Reinforcement (After Action)

After the incident is resolved, reinforce the skill by running these drill surfaces and re-running this scenario timed.

### Execution playbook to run (primary)

- `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`

### Supporting playbooks (secondary, as indicated by evidence)

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (if the runtime service fails to start)
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md` (if pulls fail due to DNS/routing)
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md` (if runtime fails due to storage/read-only/full)
- `linux/LFCS-training/execution-playbooks/security-triage-playbook.md` (if permissions/SELinux blocks runtime)

### Execution drills to reinforce (mechanics)

- `linux/LFCS-training/execution-drills/containers-and-virtualization.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

### Proof ritual (do not skip)

- Re-run the known-good verification:
  - `docker run --rm alpine echo hello` (or podman/nerdctl equivalent)
- Confirm runtime service health:
  - `systemctl status docker --no-pager` (or containerd/podman)

---

## 🏁 Operator Loop (Reinforced)

Symptom → Detect tooling → Supervisor view → Logs → Minimal correction → Known-good verify → Reinforce

