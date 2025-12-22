# 🌐 API Server Availability & Performance
*Control-plane responsiveness, stability, and failure isolation*

---

## 📌 Purpose

This document defines **operator responsibility for Kubernetes API server
availability and performance**.

The API server is the **front door to the cluster**:
- every read and write flows through it
- every controller, scheduler, and client depends on it
- degraded performance impacts the entire system, not just users

This document exists to help operators:
- reason about API availability
- detect performance degradation early
- avoid self-inflicted outages during remediation

---

## 🧠 Operator Mental Model

Think of the API server as **the cluster’s nervous system**.

- If it is responsive → the cluster appears healthy
- If it is slow → the cluster behaves unpredictably
- If it is unavailable → reconciliation stops everywhere

Availability and performance are inseparable.
A “slow API” is often worse than a briefly unavailable one.

---

## 🔁 What the API Server Does (Conceptual)

The API server is responsible for:

- validating and authenticating all requests
- enforcing authorization and admission control
- persisting state changes to etcd
- serving watch streams to controllers and clients

It is both:
- CPU- and memory-sensitive
- latency-sensitive with respect to etcd

Operators must consider **load, latency, and trust** together.

---

## ❤️ Availability Signals to Watch

Operators should be able to reason about:

- request latency trends
- error rates (timeouts, authorization failures)
- watch stream stability
- connection churn from clients and controllers
- API server restarts or crash loops

Healthy API servers are:
- boring
- predictable
- quiet

Noise is always a signal.

---

## ⚠️ Common Causes of Degradation

API server issues commonly stem from:

- etcd latency or instability
- certificate or authentication problems
- excessive or misbehaving clients
- large objects or excessive watch load
- insufficient CPU or memory on control-plane nodes
- admission controllers causing request delays

Symptoms often appear as:
- kubectl commands hanging
- controllers falling behind
- scheduling delays
- cascading timeouts across components

---

## 🔐 Authentication, Authorization, and Performance

Every API request incurs:

- authentication checks
- authorization decisions
- admission evaluation

Misconfiguration here can:
- add latency to every request
- cause partial outages
- create confusing, intermittent failures

Security and performance are tightly coupled at the API layer.

---

## 🔁 Failure Isolation and Safe Response

When the API server degrades:

- reduce write pressure first
- avoid large, sweeping changes
- stabilize etcd before tuning the API
- resist the urge to restart repeatedly

Blind restarts can:
- increase load spikes
- prolong leader re-election
- mask the true root cause

Stability beats speed during incidents.

---

## ⚠️ High-Risk Mistakes (Contextual)

> **⚠️ Mistake: Debugging workloads while the API is unstable**  
> Application symptoms are meaningless if the control plane is degraded.

> **⚠️ Mistake: Treating API slowness as a “kubectl problem”**  
> Client latency usually reflects deeper control-plane stress.

> **⚠️ Mistake: Restarting the API server without understanding etcd health**  
> The API server cannot be healthy if etcd is not.

---

## 🧭 Reference Context

API server behavior documented here is grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters make performance bottlenecks obvious because:
- resources are constrained
- latency spikes surface quickly
- recovery margins are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Control Plane Docs

- `README.md`  
  Defines control-plane scope and lifecycle ownership

- `etcd-health-and-recovery.md`  
  Covers the primary dependency of API performance

- `certificates-and-trust.md`  
  Defines authentication and identity guarantees

- `troubleshooting/README.md`  
  Provides incident response and diagnosis patterns

Together, these documents define **API stability as a first-class SLO**.

---
