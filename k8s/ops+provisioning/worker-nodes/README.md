# 🧩 Kubernetes Worker Nodes
*Execution, capacity, and lifecycle management*

---

## 📌 Purpose

This directory documents **worker-node–specific operational knowledge**
within the `k8s/ops+provisioning` wing.

Worker nodes are responsible for:
- executing application workloads
- maintaining kubelet and container runtime health
- participating in scheduling decisions
- enforcing networking and storage behavior
- absorbing the majority of operational churn in a cluster

This directory focuses on **how operators manage worker nodes as disposable,
replaceable execution units**, not on application configuration.

---

## 🧭 Relationship to Other Directories

- `bootstrap/`  
  Covers how nodes are initially prepared and joined

- `control-plane/`  
  Covers authority, state, and decision-making components

This directory begins **after a worker successfully joins**
and owns the node’s **entire operational lifespan**.

---

## 🔁 Lifecycle Focus

Worker-node operations span both **Day-1** and **Day-2** phases.

---

### 🚀 Day-1 (Worker Node Entry)

Day-1 begins when a node is prepared to join a cluster.

Responsibilities include:

- validating OS prerequisites (swap, cgroups, kernel modules)
- installing container runtime and kubelet
- ensuring time sync and network reachability
- joining the cluster using kubeadm
- verifying node readiness and scheduling eligibility

The goal of Day-1 is a **clean, predictable node join**.

A worker that joins incorrectly becomes a long-term operational liability.

---

### 🔧 Day-2 (Worker Node Operations)

Day-2 begins once the node is actively running workloads.

Responsibilities include:

- monitoring kubelet and node health
- cordoning and draining nodes safely
- performing OS and Kubernetes upgrades
- managing node labels, taints, and capacity
- replacing failed or degraded nodes
- understanding workload impact during maintenance

In real systems, **most Kubernetes operational effort happens here**.

---

## 🧠 Core Worker Node Components

Every worker node runs a small but critical set of components:

- **kubelet**  
  The primary node agent responsible for Pod lifecycle and status reporting

- **container runtime (containerd)**  
  Executes containers and manages images

- **CNI plugins**  
  Provide Pod networking and connectivity

- **kube-proxy (or equivalent)**  
  Implements Service routing behavior

Operators must understand how failures in any of these
surface as **node-level symptoms**.

---

## 🔁 Worker Node Lifecycle Patterns

Common operational patterns include:

- **Add node**  
  Prepare → join → validate → schedule workloads

- **Maintain node**  
  Cordon → drain → update → uncordon

- **Replace node**  
  Drain → remove → rebuild → rejoin

- **Recover node**  
  Diagnose → repair → validate *or* replace

Healthy clusters assume **worker nodes are disposable**.

Repair is optional; replacement is always valid.

---

## ⚠️ Common Failure Domains

Worker-node failures frequently originate from:

- kubelet crashes or misconfiguration
- container runtime failures
- disk pressure or inode exhaustion
- networking misconfiguration
- certificate expiration
- kernel or OS updates

Symptoms often appear as:
- Pods stuck Pending or CrashLoopBackOff
- Nodes flapping Ready / NotReady
- Scheduling failures without clear errors

Correct diagnosis starts with understanding **which layer failed first**.

---

## 🧭 Reference Context

Worker-node concepts in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

That cluster provides:
- concrete hardware constraints
- realistic networking limitations
- visible failure modes

The principles documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- kubelet behavior and node-agent responsibilities
- node join and removal lifecycle details
- draining and maintenance playbooks
- runtime and resource management guidance
- node upgrade and replacement strategies
- worker-node failure and recovery scenarios

Exact commands and chronological build steps live in the
implementation repository; this directory documents
**intent, lifecycle discipline, and operator judgment**.

---

## ▶️ Where to Start

If you are new to worker-node operations:

1. Understand the Day-1 vs Day-2 distinction
2. Learn the kubelet’s role and failure modes
3. Study drain, replacement, and recovery patterns
4. Treat workers as disposable execution capacity

Worker nodes are where Kubernetes becomes **operationally real**.

---
