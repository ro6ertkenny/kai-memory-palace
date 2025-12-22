# 🧭 Scheduler & Controller Behavior
*Placement decisions, reconciliation loops, and systemic stability*

---

## 📌 Purpose

This document defines **operator responsibility for understanding scheduler
and controller-manager behavior** within the Kubernetes control plane.

The scheduler and controllers are the **engines of convergence**:
- the scheduler decides *where* work should run
- controllers decide *what* should exist and continuously reconcile reality

When these components misbehave, the cluster may appear alive while
**silently failing to converge**.

---

## 🧠 Operator Mental Model

Think in terms of **intent vs reality**.

- The scheduler makes **one-time placement decisions**
- Controllers run **continuous reconciliation loops**

If scheduling or reconciliation stalls:
- workloads stop progressing
- failures accumulate quietly
- operators chase symptoms instead of causes

Operators must reason about **flow, backlog, and convergence**.

---

## 🎯 kube-scheduler Responsibilities

The scheduler is responsible for:

- selecting nodes for unscheduled Pods
- evaluating resource availability and constraints
- honoring taints, tolerations, affinity, and policy
- scoring candidate nodes and making placement decisions

Key characteristics:

- scheduling is event-driven
- decisions are not continuously revisited
- failed scheduling creates backpressure

Once a Pod is scheduled, the scheduler steps away.

---

## 🔁 kube-controller-manager Responsibilities

The controller manager runs multiple controllers that:

- watch desired state
- compare it to actual state
- take corrective action until convergence

Examples include:
- ReplicaSet controller
- Node controller
- Endpoint controller
- Job controller

Controllers operate as **independent reconciliation loops**.
Slowness or failure in one does not always halt others.

---

## ❤️ Health and Performance Signals

Operators should reason about:

- scheduling latency
- backlog of unscheduled Pods
- controller reconciliation delays
- repeated retries without progress
- divergence between desired and actual state

Healthy behavior looks like:
- rapid convergence
- low steady-state churn
- predictable reconciliation cycles

Persistent backlog is always a signal.

---

## ⚠️ Common Failure Patterns

Scheduler-related failures often stem from:
- insufficient resources
- conflicting affinity rules
- taints without tolerations
- stale node state
- API server latency

Controller-related failures often stem from:
- API watch disruptions
- etcd latency
- controller crashes or throttling
- misconfigured ownership or selectors

Symptoms may include:
- Pods stuck Pending indefinitely
- workloads partially updating
- resources existing without effect

---

## 🔐 Interaction with API Server and etcd

Both scheduler and controllers depend on:

- timely API responses
- consistent watch streams
- reliable persistence in etcd

When the API server or etcd degrades:
- schedulers appear idle
- controllers fall behind
- reconciliation slows or halts

These components are **downstream consumers of control-plane health**.

---

## ⚠️ High-Risk Mistakes (Contextual)

> **⚠️ Mistake: Treating Pending Pods as purely application problems**  
> Pending often indicates scheduling or control-plane stress.

> **⚠️ Mistake: Restarting controllers to “unstick” the cluster**  
> Restarts can increase backlog and delay convergence.

> **⚠️ Mistake: Ignoring slow reconciliation because “things eventually work”**  
> Slow convergence hides systemic issues.

---

## 🧭 Reference Context

Scheduler and controller behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make convergence issues visible because:
- resource margins are thin
- scheduling constraints surface quickly
- controller delays are noticeable

The principles documented here remain portable
across environments.

---

## 🔗 Related Control Plane Docs

- `README.md`  
  Defines control-plane authority and lifecycle ownership

- `api-server-availability-and-performance.md`  
  Covers upstream dependencies affecting scheduling and reconciliation

- `etcd-health-and-recovery.md`  
  Defines the persistence layer that controllers depend on

- `troubleshooting/README.md`  
  Provides diagnostic frameworks for stalled convergence

Together, these documents define **convergence as the measure of cluster health**.

---
