# 🧠 Kubernetes Control Plane
*Provisioning, operation, and lifecycle management*

---

## 📌 Purpose

This directory documents **control plane responsibilities** within the
`k8s/ops+provisioning` wing.

The control plane is responsible for:

- cluster initialization and identity
- API availability and state consistency
- scheduling, admission, and reconciliation
- certificate authority and trust
- lifecycle operations across upgrades and failures

This documentation focuses on **how operators think about and manage
the control plane**, not on application workloads.

---

## 🔁 Lifecycle Focus

### 🚀 Day-1 Control Plane Operations (Provisioning)

Day-1 begins when a cluster is first brought into existence.

Responsibilities include:

- validating OS prerequisites on the control-plane node
- installing and configuring the container runtime (containerd)
- installing kubelet, kubeadm, and kubectl
- initializing the cluster with kubeadm
- generating and distributing certificates
- establishing the initial API endpoint
- installing a CNI
- verifying control-plane health

The goal of Day-1 is **a clean, trustworthy control plane**.

---

### 🔧 Day-2 Control Plane Operations (Maintenance)

Day-2 begins once the control plane is live.

Responsibilities include:

- Kubernetes version upgrades
- kubeadm config and certificate rotation
- API server availability and performance
- etcd health and recovery considerations
- node maintenance impacting the control plane
- disaster recovery scenarios
- understanding failure domains

Day-2 work dominates real-world Kubernetes operations.

---

## 🧠 Control Plane Components (Conceptual)

The control plane is composed of:

- **kube-apiserver**  
  The front door to the cluster; all state flows through it

- **etcd**  
  The authoritative data store for cluster state

- **kube-scheduler**  
  Assigns Pods to Nodes based on constraints and policy

- **kube-controller-manager**  
  Runs reconciliation loops to maintain desired state

Operators must understand how these components interact,
restart, fail, and recover.

---

## 🔐 Certificates and Trust

The control plane establishes the **root of trust** for the cluster.

Key concepts include:

- certificate authority ownership
- kubeadm-managed cert lifecycles
- API server client authentication
- kubelet and component trust relationships
- expiration timelines and rotation strategy

Certificate issues are among the **most common control-plane failures**.

---

## 🧭 Reference Implementation

Control-plane concepts in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** documented here:

rpi-cluster/  
├─ pi-cluster-hardware.md  
├─ pi-cluster-environment.md  
└─ pi-cluster-snapshot.md  

That cluster serves as a **concrete reference**, but the material here
is intended to be portable across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- control-plane provisioning notes
- kubeadm lifecycle explanations
- upgrade and rollback procedures
- certificate management guidance
- recovery and failure scenarios
- operator checklists

Exact commands and chronological build steps live in the
implementation repository; this wing documents **understanding and intent**.

---

## ▶️ Where to Start

If you are new to control-plane operations:

1. Understand the lifecycle split (Day-1 vs Day-2)
2. Review control-plane component responsibilities
3. Study certificate and trust relationships
4. Reference the rpi-cluster for concrete examples

This directory assumes familiarity with basic Kubernetes primitives.

---
