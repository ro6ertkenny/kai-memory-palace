# 🗺️ kai-memory-palace — Knowledge Map

This document is the **authoritative map** of the kai-memory-palace repository.  
It explains how knowledge is organized and where to put new material.

---

## 🧠 Core Principle

Content is organized by **mental mode**, not by tool or trend.

If the thinking mode changes, it belongs in a different Wing.

---

## 🔀 Version Control

**Path:** `git/`

Git and version-control discipline used throughout the repository.

- Commit scope and message standards
- History hygiene (amend, revert, rebase vs merge)
- Branching strategy (when needed)
- Change safety patterns (reviewable diffs, small commits)
- Repository structure conventions

Other Wings may reference this Wing for **how to ship changes**, but this Wing owns the
**how and why of version control**.

---

## ☸️ Kubernetes (Domain: `k8s/`)

Kubernetes content is organized into **five Wings**, each with a clear purpose.

### 🧭 `k8s/general/`
Cross-cutting Kubernetes notes that don’t belong to a single Wing.

- Conventions
- Shared references
- “Inbox” notes awaiting classification
- Cross-Wing troubleshooting patterns

---

### 🧱 `k8s/foundations/`
Core Kubernetes concepts and primitives.

- Control plane vs workers
- Pods, Deployments, Services
- Declarative YAML
- `kubectl` fundamentals

Use this Wing to **understand how Kubernetes works**.

---

### 🛠️ `k8s/ops+provisioning/`
Cluster build, operation, and maintenance.

- kubeadm workflows
- Container runtimes (CRI / containerd)
- Node lifecycle (join/reset/upgrade)
- OS prep and system tuning

Use this Wing to **run Kubernetes reliably**.

---

### 🌐 `k8s/networking/`
Kubernetes-specific networking abstractions.

- CNI concepts
- Pod-to-Pod and Service networking
- Cluster DNS
- Ingress and NetworkPolicies

Linux networking fundamentals belong **outside** Kubernetes.

---

### 🧩 `k8s/ecosystem/`
Tools and patterns that extend Kubernetes.

- Helm
- Operators
- Observability (Prometheus / Grafana)
- GitOps (Argo CD / Flux)
- Security tooling (RBAC / OPA)

- 🤖 AI-on-Kubernetes workloads (tracked via a placeholder in `k8s/ecosystem/`)

*Only populate this Wing after foundations and ops feel solid.*

---

## 🌐 Networking (General)

**Path:** `networking/`

Linux and infrastructure networking fundamentals used by everything else.

- TCP/IP
- Routing and subnets
- Interfaces and bridges
- iptables / nftables
- DNS at the OS level

Kubernetes networking builds on this knowledge but is tracked separately.

---

## 🐧 Linux

**Path:** `linux/`

Linux operating system knowledge.

- Debian-specific notes
- Bash usage
- System administration fundamentals
- Package management and services

This Wing supports Kubernetes, not the other way around.

---

## ✍️ Editor Knowledge

### `vim/`
Vim usage patterns, workflows, and references.

---

## 🧭 Meta & Assets

- `README.md` — repository entry point and navigation
- `map.md` — this document (mental index)
- `images/` — diagrams and screenshots used by notes

---

## ✅ Placement Rules (Summary)

- Organize by **mental mode**
- Avoid duplication
- Prefer one canonical location
- Split Wings only when pressure exists
