# 🚀 Bootstrap Overview
## How a Kubernetes cluster comes into existence

Mental mode: Building clusters deliberately and predictably.

This document describes the **high-level bootstrap flow** for bringing a Kubernetes cluster online.
It is not a command transcript. It is the operational mental model.

Bootstrapping is a sequence.
Skipping steps produces fragile clusters.

---

## Purpose
You should be able to answer:
- What are the phases of cluster bring-up?
- What must be true before kubeadm runs?
- What changes after the control plane exists?
- What validates a successful bootstrap?

This overview gives you a durable map for Day-1 operations.

---

## Bootstrap Phases (Map)

Phase 0: Plan the cluster  
Phase 1: Prepare the operating system  
Phase 2: Install runtime and Kubernetes tooling  
Phase 3: Initialize the control plane  
Phase 4: Install cluster networking (CNI)  
Phase 5: Join worker nodes  
Phase 6: Validate and snapshot the cluster

Each phase has prerequisites and validation.

---

## Phase 0: Plan the Cluster

Decide up front:
- control plane topology (single vs multi)
- node naming convention
- IP addressing approach
- DNS expectations
- container runtime choice
- Kubernetes version pinning
- CNI choice
- storage expectations

Outputs of this phase:
- a written target state
- a repeatable plan for new nodes

---

## Phase 1: Prepare the Operating System

Goal: make nodes stable and predictable.

Typical requirements:
- consistent OS version across nodes
- stable hostnames
- time sync enabled and correct
- swap configured per cluster policy
- kernel modules and sysctls set for Kubernetes
- firewall posture understood
- SSH access and sudo verified

Validation:
- nodes reboot cleanly
- network is stable
- disk and memory are sufficient
- you can run baseline inspection commands confidently

Linux work lives in: kai-memory-palace/linux

---

## Phase 2: Install Runtime and Kubernetes Tooling

Goal: ensure the node can run containers and speak Kubernetes.

Install and validate:
- container runtime (containerd)
- CRI integration
- kubeadm, kubelet, kubectl (pinned versions)
- required dependencies

Validation:
- container runtime is running
- kubelet can run and report
- versions match the target plan

---

## Phase 3: Initialize the Control Plane

Goal: create the cluster control plane.

Conceptually:
- kubeadm initializes control plane components
- the API server becomes reachable
- cluster state storage (etcd) becomes active
- core controllers begin reconciling

Immediate validation:
- API server responds
- nodes show expected roles
- core system pods begin to appear

At this stage, the cluster exists but is incomplete.

---

## Phase 4: Install Cluster Networking (CNI)

Goal: make pod-to-pod communication possible.

Until a CNI is installed:
- pods may schedule but not communicate properly
- cluster DNS and networking-dependent workloads may fail

Validation:
- CNI components are running
- core DNS becomes healthy
- pods can communicate within expected boundaries

Networking deep dives live in: kai-memory-palace/k8s/networking

---

## Phase 5: Join Worker Nodes

Goal: add capacity and distribute workloads.

Conceptually:
- workers join with a token/certificate trust path
- kubelet registers the node with the control plane
- the scheduler can now place workloads on workers

Validation:
- worker nodes appear as Ready
- pods can be scheduled onto them
- networking works across nodes

---

## Phase 6: Validate and Snapshot

Goal: ensure cluster health and capture baseline state.

Minimum validations:
- all nodes Ready
- critical system pods Running
- DNS resolves inside the cluster
- basic workload can be scheduled and reached

Snapshot outputs:
- versions (Kubernetes, containerd, OS, kernel)
- node inventory (names, IPs, roles)
- CNI choice and version
- any deviations from the plan

Reference snapshots belong in: rpi-cluster/

---

## Common Bootstrap Failure Patterns

- OS not prepared (swap, sysctl, modules)
- mismatched versions across nodes
- container runtime not configured correctly
- CNI installed at the wrong time
- DNS assumptions not validated
- joining failures due to tokens/certs/time drift

Bootstrap fails most often due to skipped prerequisites.

---

## Outcome
You should be able to say:

I know the phases of cluster bring-up,  
I know what to validate at each phase,  
and I can bootstrap a cluster predictably.

That is Day-1 operational control.
