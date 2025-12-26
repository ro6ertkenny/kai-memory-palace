# 🧪 Kubernetes Hands-On Practice — Repos & Environments (CKA Prep)

## 🎯 Purpose
Create a focused, repeatable set of hands-on Kubernetes practice targets (apps, manifests, and environments)
that map cleanly to CKA-style execution.

This document exists to answer one question clearly:
What should I actually run to get good at Kubernetes?

---

## ✅ What to Fork + Clone (Hands-On / You’ll Modify)

### 1) KUARD (Kubernetes Up & Running demo app)
Why: Canonical workload for debugging and observability practice.

Repo: kubernetes-up-and-running/kuard  
URL: https://github.com/kubernetes-up-and-running/kuard  
Common image: gcr.io/kuard-demo/kuard-amd64

Use it to practice:
- Deployments and Services (ClusterIP / NodePort)
- Port-forwarding
- Probes (liveness / readiness)
- Resource requests and limits
- kubectl logs, kubectl exec, events, and debugging

---

### 2) Benjamin Muschko — CKA Study Guide Companion Repo
Why: Realistic, exam-aligned YAML and scenarios designed to be broken and fixed repeatedly.

Repo: bmuschko/cka-study-guide  
URL: https://github.com/bmuschko/cka-study-guide

Use it to practice:
- Imperative vs declarative workflows
- Workloads and scheduling constraints
- Storage and networking exercises
- Troubleshooting drills across domains

---

## 📚 Reference-Only Repositories (Do NOT Fork)

### 3) Kubernetes Official Examples
Why: Authoritative example manifests maintained by the Kubernetes project.

Repo: kubernetes/examples  
URL: https://github.com/kubernetes/examples

Guidance:
- Do not fork
- Pull individual YAML files as needed into your own practice directories

---

## 🧰 Practice Environments (Install / Use — Do NOT Fork)

### 4) minikube
Repo: kubernetes/minikube  
URL: https://github.com/kubernetes/minikube  
Use for: Ingress, StorageClasses, and add-ons in a local cluster

### 5) kind (Kubernetes IN Docker)
Repo: kubernetes-sigs/kind  
URL: https://github.com/kubernetes-sigs/kind  
Use for: Fast, disposable multi-node clusters for repeated drills

---

## 🌐 Interactive Practice (No GitHub Forks)

### 6) Killercoda
URL: https://killercoda.com  
Use for: Community-driven, exam-style Kubernetes scenarios

### 7) Killer Shell
URL: https://killer.sh  
Use for: Timed CKA simulator sessions (often included with exam vouchers)

---

## 🗂️ Canonical Location in kai-memory-palace

Path:
    k8s/general/practice-repos.md

Why this lives in general:
- Cross-cutting reference used by all Kubernetes wings
- Not specific to foundations, ops+provisioning, networking, or ecosystem
- Acts as a navigation and execution index

---

## ✅ Decision Summary

Fork + clone (you will modify):
- kubernetes-up-and-running/kuard
- bmuschko/cka-study-guide

Reference only:
- kubernetes/examples

Install / use only:
- kubernetes/minikube
- kubernetes-sigs/kind

---

## 📚 Sources
- Kubernetes Up & Running — O’Reilly
- Certified Kubernetes Administrator (CKA) Study Guide — Benjamin Muschko, O’Reilly
- Official Kubernetes documentation (kubernetes.io)


