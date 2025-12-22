# ✅ Post-Bootstrap Validation
*Proving the cluster is healthy after kubeadm init/join*

---

## 📌 Purpose

This document defines the **minimum validation steps** required after:

- `kubeadm init` (control plane bootstrap)
- `kubeadm join` (worker node join)

It exists to prevent the most common failure pattern in Kubernetes ops:

> *Bootstrap “works”, but the cluster is not actually healthy.*

Validation is a **required operator responsibility**.
A cluster is not “done” until validation passes.

---

## 🧠 Operator Mental Model

Post-bootstrap validation answers three questions:

1. **Is the API stable and responsive?**
2. **Are nodes healthy and reporting correctly?**
3. **Can a minimal workload schedule and run?**

If any answer is “no”, stop and diagnose immediately.
Do not proceed to add complexity.

---

## ✅ Validation Phases

Validation should happen in phases, from lowest risk to highest:

1. Control plane health (API and core components)
2. Node readiness (control plane + workers)
3. Networking readiness (CNI + DNS behavior)
4. Scheduling sanity (minimal workload)
5. Persistence checks (stability over time)

---

## 1️⃣ Control Plane Health

Confirm the control plane is running and stable:

- API server is reachable
- control-plane Pods are Running
- etcd is healthy
- scheduler and controller manager are running
- kube-system baseline components are present

Failure here means bootstrap is incomplete.
Do not join additional nodes until the control plane is stable.

---

## 2️⃣ Node Readiness

Confirm that:

- control-plane node is Ready
- each worker node joined is Ready
- nodes have correct roles and expected metadata
- there is no repeated NotReady/Ready flapping

Node instability immediately after join often indicates:
- container runtime misconfiguration
- kubelet issues
- time drift
- CNI/networking problems

---

## 3️⃣ Networking Readiness

Networking validation focuses on:

- CNI installed and running
- kube-system networking components stable
- Pod network behavior is functional
- DNS resolution works inside the cluster

If networking is not stable, workload symptoms will be misleading.

Networking must be validated before interpreting workload failures.

---

## 4️⃣ Scheduling Sanity (Minimal Workload)

A minimal scheduling test validates:

- scheduler is functioning
- kubelet can start pods
- container runtime can pull images
- networking supports basic connectivity

The goal is not to “deploy an app”.
The goal is to prove the system can perform the simplest end-to-end action:
schedule → start → run.

If this fails, treat it as a cluster health issue, not an application issue.

---

## 5️⃣ Stability Over Time

Some failures surface only after a short period.

After initial validation, verify that:

- nodes remain Ready
- control plane remains stable
- core components do not crash-loop
- there are no recurring certificate or auth errors

A short stability window is cheaper than incident response later.

---

## ⚠️ Common Mistakes (Contextual)

> **⚠️ Mistake: Declaring success after “kubeadm init succeeded”**  
> kubeadm success only means the tooling completed.  
> You still must validate: API stability, node readiness, CNI, and scheduling.

> **⚠️ Mistake: Debugging workloads before validating networking**  
> Many “app” failures are actually missing or broken CNI/DNS.  
> Validate networking first, then interpret workload symptoms.

> **⚠️ Mistake: Joining multiple workers before control plane stability**  
> Adding nodes increases noise and failure surface area.  
> Stabilize the control plane first.

---

## 🧭 Reference Context

These validation phases are applied using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify bootstrap mistakes because:
- resources are constrained
- timing issues surface quickly
- re-provisioning cost is high

The validation principles documented here remain portable
across environments.

---

## 🔗 Related Bootstrap Docs

- `bootstrap-overview.md`  
  Defines the bootstrap lifecycle and operator responsibilities

- `preflight-and-invariants.md`  
  Defines what must be true before kubeadm runs

- `kubeadm-workflow.md`  
  Documents the kubeadm init/join/reset flow

- `kubeadm-reset-and-recovery.md`  
  Defines safe teardown and retry patterns

Together these form a **closed bootstrap loop**.

---
