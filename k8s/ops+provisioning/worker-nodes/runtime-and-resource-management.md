# ⚙️ Runtime & Resource Management
*Container execution, pressure signals, and capacity discipline*

---

## 📌 Purpose

This document defines **operator responsibility for container runtime behavior
and resource management** on Kubernetes worker nodes.

Worker nodes are execution environments.
Their primary job is to:
- start containers reliably
- allocate resources predictably
- report pressure accurately
- protect node stability under load

Failures at this layer often masquerade as application bugs.

---

## 🧠 Operator Mental Model

Think in terms of **pressure and guarantees**.

- Kubernetes schedules based on *declared intent*
- the runtime enforces *actual limits*
- the kubelet arbitrates when reality diverges

When resources are mismanaged:
- Pods restart unexpectedly
- Nodes become NotReady
- workloads fail non-deterministically

Operators reason from **node pressure → kubelet decisions → workload symptoms**.

---

## 🔁 Container Runtime Responsibilities

The container runtime (e.g., containerd) is responsible for:

- pulling and storing images
- creating and destroying containers
- enforcing CPU and memory limits
- exposing container state to the kubelet
- managing low-level execution primitives

If the runtime is unhealthy, kubelet behavior degrades immediately.

---

## 📊 Resource Types and Enforcement

Worker nodes manage multiple resource dimensions:

- **CPU** — time-sliced, compressible
- **Memory** — non-compressible, OOM-sensitive
- **Disk** — images, logs, volumes
- **PID** — process count limits
- **Network** — bandwidth and latency constraints

Each resource has distinct failure modes.
Memory pressure is the most destructive.

---

## ❤️ Node Pressure Signals

Kubelet reports pressure through node conditions:

- MemoryPressure
- DiskPressure
- PIDPressure
- NetworkUnavailable (via CNI)

These signals directly influence:
- Pod eviction
- scheduling eligibility
- node readiness

Pressure signals are **early warnings**, not noise.

---

## 🔁 Eviction and Protection Behavior

When pressure occurs, kubelet may:

- evict Pods based on QoS class
- throttle container execution
- mark the node NotReady
- protect system-critical workloads

Operators must understand:
- eviction thresholds
- QoS implications
- how misconfigured limits trigger instability

Poor resource hygiene causes cascading failures.

---

## ⚠️ Common Runtime Failure Patterns (Contextual)

> **⚠️ Mistake: Treating OOMKills as application-only issues**  
> Many OOMs reflect node-level overcommitment.

> **⚠️ Mistake: Ignoring disk and inode exhaustion**  
> Disk pressure often surfaces as container start failures.

> **⚠️ Mistake: Restarting runtime without understanding kubelet impact**  
> Runtime restarts disrupt all running workloads.

---

## 🔁 Capacity Planning and Reality

Schedulers assume reported capacity is accurate.

Operators must ensure:
- allocatable resources reflect reality
- OS-level reservations are respected
- background services are accounted for

Over-reporting capacity creates **latent instability**.

---

## 🧭 Reference Context

Runtime and resource behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make resource pressure visible because:
- margins are thin
- contention surfaces quickly
- recovery paths are limited

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `kubelet-and-node-agent.md`  
  Covers kubelet decision-making under pressure

- `node-join-lifecycle.md`  
  Covers execution readiness after join

- `draining-and-maintenance.md`  
  Covers safe handling of workloads during maintenance

Together, these documents define **execution stability at the worker layer**.

---
