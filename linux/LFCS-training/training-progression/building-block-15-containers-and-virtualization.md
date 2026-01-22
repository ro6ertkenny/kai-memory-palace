# 🧱 Building Block 15 — Containers and Virtualization

**Path:** `linux/LFCS-training/training-progression/building-block-15-containers-and-virtualization.md`  
**Purpose:** Build the operational ability to **run, inspect, and reason about containers** (and basic virtualization concepts) as required by the LFCS exam surface.

---

## 🎯 What This Block Builds

You are building:

- A practical understanding of:
  - what a container is (and is not)
  - how it relates to the host
  - how resources, filesystems, and networking are isolated or shared
- The ability to:
  - run containers
  - inspect their state
  - diagnose common failures using **host-level tools**

This block turns “the container doesn’t work” into a **host-visible, inspectable problem**.

---

## 🧠 Mental Models You Must Own

- A container is:
  - a process (or set of processes)
  - with isolation boundaries
  - not a VM
- If a container is “down”:
  - it is not running as a process
- If a container can’t access something:
  - it is still subject to:
    - filesystem mounts
    - permissions
    - SELinux
    - networking
- The host is:
  - always the place where truth is observable

Invariants:

- “I can always see containers from the host.”
- “A container failure is still a process, storage, or network failure.”
- “I do not treat containers as magic.”

---

## 🛠️ Canonical Drill Surfaces

You must master:

- `linux/LFCS-training/execution-drills/containers-and-virtualization.md`
- `linux/LFCS-training/execution-drills/processes-logs-and-scheduling.md`
- `linux/LFCS-training/execution-drills/storage-and-mounts.md`
- `linux/LFCS-training/execution-drills/networking.md`

Rule:

> You should be able to inspect containers using both container tooling and host-level tools.

---

## 🧪 Canonical Failure Scenarios

These are exercised after this block:

- “Container won’t start”
- “Container exits immediately”
- “Container can’t access files or network”

---

## ⚙️ Canonical Execution Playbooks

- `linux/LFCS-training/execution-playbooks/service-recovery-playbook.md` (when containers are managed as services)
- `linux/LFCS-training/execution-playbooks/process-control-playbook.md`
- `linux/LFCS-training/execution-playbooks/network-diagnosis-playbook.md`
- `linux/LFCS-training/execution-playbooks/storage-recovery-playbook.md`

Rule:

> You always diagnose container problems using **normal Linux operator playbooks**.

---

## 🧭 Required Capabilities

You must be able to:

### Operate Containers

- Run:
  - a container
  - a container in the background
- List:
  - running containers
  - stopped containers
- Inspect:
  - logs
  - exit status
  - configuration

### Map Container to Host Reality

- Determine:
  - which host process corresponds to a container
  - which ports are exposed
  - which volumes are mounted
- Inspect:
  - filesystem paths
  - network listeners
  - resource usage

### Diagnose Failures

- Decide whether failure is:
  - image problem
  - command problem
  - permission problem
  - network problem
  - storage/mount problem
- Use:
  - logs
  - exit codes
  - host tools
  - to prove the cause

---

## ✅ Exit Criteria (Gate)

You may proceed only when all of the following are true:

- You can:
  - run and inspect containers confidently
  - explain what they are doing on the host
- Given a broken container, you can:
  - determine why it exited or failed
  - classify the failure using normal Linux reasoning
- You do not:
  - treat containers as opaque boxes
  - guess or “recreate until it works”

Concrete tests:

- You can:
  - explain why a container is restarting
  - find the host process and logs for a container
  - diagnose a container that can’t access a path or port

---

## 🔁 Regression Rule

If later you:

- treat container failures as mysterious
- forget that containers are just processes
- cannot map a container issue to a host issue

You must:

> Return here and re-run `containers-and-virtualization.md` until containers feel like normal Linux workloads again.

---

## 🧠 Operator Rule (Carry Forward)

> **Containers are not special. They are processes with boundaries.**

---

## 🧱 This Block Enables

- Confident container operations
- Correct use of host-level troubleshooting for container issues
- Integration of containers into normal service and process workflows

Without this block, **container problems will feel alien and slow to debug**.

---
