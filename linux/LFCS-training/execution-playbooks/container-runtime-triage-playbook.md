# 🐳 Container Runtime Triage Playbook (LFCS)

**Path:** `linux/LFCS-training/execution-playbooks/container-runtime-triage-playbook.md`  
**Purpose:** Restore **basic container runtime functionality** (run, inspect, network, persist) using a **safe, exam-ready operator algorithm**.

This is not a tutorial. This is a procedure.

---

## 🎯 Scope

Use this playbook when:

- `docker` / `podman` commands fail
- Container runtime service is down (`docker`, `containerd`, `crio`, `podman`)
- Images won’t pull
- Containers won’t start / immediately exit
- Port publishing does not work (`-p 8080:80`)
- Container networking/DNS behaves unexpectedly
- Storage mount/volume behavior causes failures

This playbook composes the following drill surfaces:

- `linux/LFCS-training/execution-drills/containers-and-virtualization.md`
- `linux/LFCS-training/execution-drills/services-and-logging.md`
- `linux/LFCS-training/execution-drills/networking.md`
- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/essential-commands.md`

Related scenarios (practice inputs):

- `linux/LFCS-training/failure-scenarios/scenario-14-container-runtime-down.md`
- `linux/LFCS-training/failure-scenarios/scenario-15-container-networking-broken.md`
- `linux/LFCS-training/failure-scenarios/scenario-16-image-pull-fails.md`

---

## 🧠 Operator Contract

Always proceed in this order:

1. **Detect tooling and runtime**
2. **Confirm service state**
3. **Reproduce the failure**
4. **Classify the failure mode**
5. **Apply minimal correction**
6. **Verify with a known-good container**
7. **Make persistent**
8. **Rollback if needed**

Never start by reinstalling packages or deleting runtime state blindly.

---

## 🧭 Global Safety Rules

- **Prefer the tool that exists on the box.** Do detection first.
- **Always verify with a known-good container** (e.g., `alpine`, `nginx`).
- **Avoid destructive cleanup** unless explicitly required.
- **Every action requires verification.**

---

## 0) Inputs

You must know or determine:

- Which container tool is expected: `docker` or `podman`
- The failing command and exact error message
- Whether you have root access (or rootless podman is intended)
- Whether the failure is:
  - runtime/service
  - network/DNS
  - image/pull
  - storage/mount
  - permissions

---

## 1) Detect What’s Installed (No Changes)

Container tools:

    command -v docker || true
    command -v podman || true
    command -v nerdctl || true
    command -v ctr || true

Runtime services:

    systemctl status docker || true
    systemctl status podman || true
    systemctl status containerd || true
    systemctl status crio || true

Quick versions:

    docker --version 2>/dev/null || true
    podman --version 2>/dev/null || true

Branch:

- If `docker` exists → treat Docker as primary → go to **Section 2**
- If `podman` exists → treat Podman as primary → go to **Section 2**
- If only `nerdctl`/`ctr` exist → runtime is containerd-facing → go to **Section 2**
- If no tools exist → this is not a runtime triage problem (install is required)

---

## 2) Confirm Runtime Service State

For Docker:

    systemctl status docker --no-pager
    systemctl status containerd --no-pager || true

For Podman:

    systemctl status podman --no-pager || true

For containerd / CRI-O (if present):

    systemctl status containerd --no-pager
    systemctl status crio --no-pager || true

Branch:

- If the expected service is **inactive/failed** → go to **Section 3**
- If the expected service is **active** → go to **Section 4**

---

## 3) Runtime Service Is Down (Recover Service First)

Start/restart the relevant unit:

    sudo systemctl start docker 2>/dev/null || true
    sudo systemctl restart docker 2>/dev/null || true

    sudo systemctl start containerd 2>/dev/null || true
    sudo systemctl restart containerd 2>/dev/null || true

    sudo systemctl start crio 2>/dev/null || true
    sudo systemctl restart crio 2>/dev/null || true

Observe failure reason:

    sudo journalctl -u docker --no-pager -n 120 2>/dev/null || true
    sudo journalctl -u containerd --no-pager -n 120 2>/dev/null || true
    sudo journalctl -u crio --no-pager -n 120 2>/dev/null || true

If the service will not start cleanly:

- Use `service-recovery-playbook.md` as the primary algorithm.
- Return here after service is healthy.

Then go to **Section 4**.

---

## 4) Reproduce Failure (Minimal Test)

Known-good image pull:

Docker:

    docker pull alpine

Podman:

    podman pull alpine

Known-good run:

Docker:

    docker run --rm alpine echo hello

Podman:

    podman run --rm alpine echo hello

Branch (classify based on what fails first):

- If **pull fails** → go to **Section 5**
- If **pull succeeds but run fails** → go to **Section 6**
- If **run works but networking/ports fail** → go to **Section 7**
- If **run works but storage mount/volume fails** → go to **Section 8**
- If everything works → incident resolved; go to **Section 10**

---

## 5) Image Pull Fails (Network/DNS/Repo Signal)

Capture the exact error message. Then validate host connectivity:

Basic reachability:

    ip a
    ip route

DNS check:

    getent hosts google.com

Branch:

- If host network/DNS is broken → use `network-diagnosis-playbook.md`, then return to **Section 4**
- If host network/DNS is OK but pull fails:
  - Treat as registry/proxy/repo configuration or policy issue
  - Re-try with a different image (`alpine` vs `nginx`) to confirm pattern

Verification re-test:

    docker pull alpine 2>/dev/null || true
    podman pull alpine 2>/dev/null || true

Return to **Section 4**.

---

## 6) Pull Works but Containers Won’t Start

Inspect container lifecycle and logs.

Docker (one-shot diagnostic):

    docker run --rm alpine sh -c "echo ok && uname -a"

Podman:

    podman run --rm alpine sh -c "echo ok && uname -a"

If a named container fails quickly, capture logs:

Docker:

    docker run -d --name web nginx
    docker logs web
    docker inspect web

Podman:

    podman run -d --name web nginx
    podman logs web
    podman inspect web

Branch:

- If error indicates permission/SELinux/denials → use `security-triage-playbook.md`, then return to **Section 4**
- If error indicates runtime daemon problems → return to **Section 2/3** and use logs
- If container exits because the process ends (expected behavior) → this is not a failure

Cleanup test container:

    docker rm -f web 2>/dev/null || true
    podman rm -f web 2>/dev/null || true

Return to **Section 4**.

---

## 7) Networking and Port Publishing Fails

Run the known-good port-publish test from the drill:

Docker:

    docker run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080

Podman:

    podman run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080

If curl fails, classify:

- Is the container running?

    docker ps 2>/dev/null || true
    podman ps 2>/dev/null || true

- Is the port listening on the host?

    ss -lntup | grep 8080 || true

Branch:

- If container is not running → go to **Section 6**
- If container is running but host port not listening:
  - Treat as runtime publish failure or config issue
  - Re-check command syntax and re-run
- If host port is listening but curl fails:
  - Treat as firewall or local networking
  - Use `network-diagnosis-playbook.md` (localhost checks + firewall checks), then re-test

Cleanup:

    docker rm -f web 2>/dev/null || true
    podman rm -f web 2>/dev/null || true

Return to **Section 4**.

---

## 8) Storage Mount / Volume Failures

If a container fails when using bind mounts or volumes:

- Confirm host path exists and permissions are correct:

    ls -ld /path/to/hostdir
    ls -l /path/to/hostdir

- Confirm filesystem is healthy and writable:

    df -h
    mount | head

Branch:

- If the host filesystem is full/read-only/mis-mounted → use `storage-recovery-playbook.md`
- If permissions/SELinux block access → use `security-triage-playbook.md`

Then re-test the minimal run in **Section 4**.

---

## 9) Network Objects (Optional Validation)

If networking features are part of the task prompt, validate networks:

Docker:

    docker network ls
    docker network create labnet
    docker run -d --name web2 --network labnet nginx
    docker inspect labnet

Podman:

    podman network ls
    podman network create labnet
    podman run -d --name web2 --network labnet nginx
    podman network inspect labnet

Cleanup (avoid leaving artifacts):

    docker rm -f web2 2>/dev/null || true
    docker network rm labnet 2>/dev/null || true

    podman rm -f web2 2>/dev/null || true
    podman network rm labnet 2>/dev/null || true

---

## 10) Verification (Exit Gate)

You are done when all required checks pass on the host:

Runtime is healthy:

    systemctl status docker --no-pager 2>/dev/null || true
    systemctl status containerd --no-pager 2>/dev/null || true

Known-good run works:

    docker run --rm alpine echo hello 2>/dev/null || true
    podman run --rm alpine echo hello 2>/dev/null || true

If port publishing is required, it works:

    curl -I http://127.0.0.1:8080 2>/dev/null || true

And logs show no ongoing runtime crash loops:

    sudo journalctl -u docker --no-pager -n 60 2>/dev/null || true
    sudo journalctl -u containerd --no-pager -n 60 2>/dev/null || true

---

## 🔁 Rollback Strategy

If changes made things worse:

- Stop and capture state:

    systemctl status docker --no-pager 2>/dev/null || true
    sudo journalctl -u docker --no-pager -n 120 2>/dev/null || true

- Remove only the test containers/networks you created:

    docker rm -f web web2 2>/dev/null || true
    docker network rm labnet 2>/dev/null || true

    podman rm -f web web2 2>/dev/null || true
    podman network rm labnet 2>/dev/null || true

Then return to **Section 1** and re-run the algorithm.

---

## ✅ Completion Criteria

- You can detect which tool/runtime is present
- The runtime service (if applicable) is healthy
- You can pull a known-good image
- You can run a known-good container
- If required, port publishing works and verifies via curl
- If required, storage access works without unsafe permission hacks

You can explain:

- What failed (service vs network vs storage vs permissions)
- Why it failed
- Why your fix was minimal and safe
- How you verified recovery

---

## 🧠 Exam Safety Rules

- Prefer service recovery via systemd + logs over random reinstalls
- Prefer localhost verification (`curl 127.0.0.1`) before remote tests
- Prefer minimal cleanup (remove only your test artifacts)
- Do not loosen key directories or security controls as a “fix”
- Verify after every action

---

## 🧱 This Playbook Composes From

- containers-and-virtualization.md
- services-and-logging.md
- networking.md
- storage-and-mounts.md
- essential-commands.md

This is a **composition layer**, not a source of primitives.

---

## 🔁 Scenario Coverage (Validation Map)

- `scenario-14-container-runtime-down.md`
  - Primary: this playbook
  - Secondary: `service-recovery-playbook.md`

- `scenario-15-container-networking-broken.md`
  - Primary: this playbook
  - Secondary: `network-diagnosis-playbook.md`
  - Secondary: `security-triage-playbook.md` (if policy blocks traffic)

- `scenario-16-image-pull-fails.md`
  - Primary: this playbook
  - Secondary: `network-diagnosis-playbook.md`

