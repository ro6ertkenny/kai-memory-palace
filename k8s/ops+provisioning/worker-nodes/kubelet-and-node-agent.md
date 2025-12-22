# 🧠 Kubelet & Node Agent Behavior
*Worker-node authority, reporting, and execution*

---

## 📌 Purpose

This document defines **operator responsibility for understanding kubelet
behavior** on Kubernetes worker nodes.

The kubelet is the **authoritative node agent**.  
It is responsible for:

- registering the node with the control plane
- reporting node and Pod status
- enforcing Pod lifecycle decisions
- interfacing with the container runtime
- executing instructions from the scheduler

If the kubelet is unhealthy, the node is **not operational**, regardless of
what the control plane reports.

---

## 🧠 Operator Mental Model

Think of the kubelet as the **node’s brain**.

- The control plane decides *what should happen*
- The kubelet decides *what actually happens on the node*

If kubelet behavior diverges from expectations:
- Pods fail silently
- Nodes flap between Ready and NotReady
- Scheduling appears correct but execution fails

Operators diagnose worker-node issues **from the kubelet outward**.

---

## 🔁 Kubelet Responsibilities (Conceptual)

The kubelet is responsible for:

- node self-registration and heartbeats
- Pod lifecycle management (start, stop, restart)
- reporting resource usage and pressure
- mounting volumes and secrets
- enforcing Pod-level configuration
- executing container runtime instructions

The kubelet does **not**:
- schedule Pods
- make placement decisions
- manage cluster-wide state

Understanding this boundary prevents misdiagnosis.

---

## 🔗 Relationship to the Control Plane

The kubelet interacts primarily with:

- **API server** — for instructions and reporting
- **container runtime** — for container execution
- **CNI plugins** — for Pod networking
- **CSI drivers** — for storage operations

If any dependency degrades, kubelet symptoms may appear first.

Kubelet issues are often **downstream signals** of upstream problems.

---

## ❤️ Health Signals and Indicators

Operators should reason about:

- node Ready / NotReady transitions
- kubelet heartbeat stability
- Pod status discrepancies
- repeated container restarts
- node conditions (memory, disk, PID pressure)

A healthy kubelet is:
- predictable
- boring
- quiet

Noise is diagnostic.

---

## ⚠️ Common Kubelet Failure Patterns

Frequent kubelet-related failure causes include:

- container runtime crashes or misconfiguration
- certificate or authentication issues
- disk pressure or inode exhaustion
- networking failures impacting API access
- kernel or OS changes
- resource starvation

Symptoms often surface as:
- Pods stuck in ContainerCreating
- CrashLoopBackOff without clear cause
- Nodes oscillating between Ready and NotReady

These are **execution-layer failures**, not scheduling failures.

---

## 🔁 Kubelet Restarts and Recovery

Restarting the kubelet is a **high-impact operation**.

Operators must consider:

- whether restart is masking upstream issues
- impact on running Pods
- interaction with container runtime state
- potential for cascading restarts

Kubelet restarts should be:
- deliberate
- isolated
- followed by validation

Repeated restarts indicate unresolved root causes.

---

## ⚠️ High-Risk Mistakes (Contextual)

> **⚠️ Mistake: Treating kubelet errors as application issues**  
> Many “app failures” are actually kubelet or runtime failures.

> **⚠️ Mistake: Restarting kubelet repeatedly without diagnosis**  
> This increases churn and hides systemic problems.

> **⚠️ Mistake: Ignoring node conditions during incidents**  
> Resource pressure signals are early warnings, not noise.

---

## 🧭 Reference Context

Kubelet behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make kubelet issues visible because:
- resources are constrained
- pressure surfaces quickly
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Worker Node Docs

- `README.md`  
  Defines worker-node lifecycle and scope

- `node-join-lifecycle.md`  
  Covers how kubelet enters the cluster

- `runtime-and-resource-management.md`  
  Covers kubelet interaction with container runtime and resources

- `node-failure-and-recovery.md`  
  Covers response patterns when kubelet health degrades

Together, these documents define **execution correctness** at the worker layer.

---
