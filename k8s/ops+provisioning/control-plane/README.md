# 🧠 Kubernetes Control Plane
*Authority, stability, and lifecycle management*

---

## 📌 Purpose

This directory documents **control plane–specific operational knowledge**
within the `k8s/ops+provisioning` wing.

The control plane is responsible for:
- defining and enforcing cluster state
- serving and validating all API interactions
- coordinating scheduling and reconciliation
- establishing and maintaining cluster trust
- surviving upgrades, failures, and recovery events

This directory focuses on **ongoing control plane ownership** —
not general cluster bootstrap and not application workloads.

---

## 🧭 Relationship to Bootstrap

Initial cluster creation is documented in:

bootstrap/

Specifically:
- preflight and invariants
- kubeadm init / join workflows
- post-bootstrap validation
- reset and recovery

Once bootstrap is complete and validated, **control plane responsibility
moves here**.

Think of the boundary as:

Bootstrap → control plane exists  
This directory → control plane must remain correct

---

## 🔁 Lifecycle Focus

### 🚀 Day-1 (Control Plane Establishment)

After successful bootstrap, operators must ensure:

- API server stability and reachability
- etcd health and persistence
- scheduler and controller-manager correctness
- baseline security and trust configuration
- observability into control plane health

Day-1 success is not “kubeadm finished” — it is **stable authority**.

---

### 🔧 Day-2 (Control Plane Maintenance)

Most real-world control plane work happens here.

Responsibilities include:

- Kubernetes version upgrades
- certificate rotation and trust continuity
- API performance and availability
- etcd backup, restore, and recovery
- node maintenance impacting the control plane
- failure-domain isolation and incident response

Day-2 errors in the control plane have **cluster-wide impact**.

---

## 🧠 Core Control Plane Components

Operators must understand the behavior and failure modes of:

- kube-apiserver  
  The single source of truth for all cluster interaction

- etcd  
  Durable storage for desired and actual state

- kube-scheduler  
  Placement decisions based on constraints and policy

- kube-controller-manager  
  Reconciliation loops enforcing desired state

Control plane operations require understanding **interaction**, not just components in isolation.

---

## 🔐 Certificates and Trust

The control plane establishes and enforces **cluster trust**.

Key areas of ownership include:

- certificate authority lifecycle
- kubeadm-managed certificate rotation
- API server authentication and authorization
- kubelet and component trust relationships
- detecting and responding to expiration-related failures

Certificate issues are a **primary cause of control plane outages**.

---

## 🧭 Reference Context

Control-plane practices in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

That cluster provides:
- constrained resources
- clear failure signals
- realistic recovery scenarios

The principles documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- control-plane operational invariants
- certificate management and rotation guidance
- upgrade sequencing and validation
- etcd health, backup, and recovery notes
- failure scenarios and operator playbooks

Exact commands and chronological build steps live in the
implementation repository; this directory documents
**authority, intent, and lifecycle discipline**.

---

## ▶️ Where to Start

If you are new to control-plane operations:

1. Understand the bootstrap → control-plane boundary
2. Study control plane component responsibilities
3. Learn certificate and trust ownership
4. Review upgrade and failure implications

The control plane is where Kubernetes becomes **authoritative**.

---
