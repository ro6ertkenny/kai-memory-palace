# ☸️ Kubernetes (k8s)

This directory is the Kubernetes domain root for **kai-memory-palace**.

## 🧠 Mental Model: 5 Wings

### 1) 🧭 `k8s/general/`
**Purpose:** Cross-cutting Kubernetes notes that don’t belong to one Wing.  
**Examples:** tooling conventions, common commands, quick references, “where does this go?” notes.

➡️ Start here: `k8s/general/README.md`

---

### 2) 🧱 `k8s/foundations/`
**Purpose:** Core Kubernetes concepts and primitives.  
**Examples:** control plane vs workers, Pods/Deployments/Services, YAML fundamentals, `kubectl` basics.

➡️ Start here: `k8s/foundations/README.md`

---

### 3) 🛠️ `k8s/ops+provisioning/`
**Purpose:** Building, operating, and maintaining clusters.  
**Examples:** kubeadm workflows, container runtime (CRI/containerd), node joins/resets, upgrades, troubleshooting nodes.

➡️ Start here: `k8s/ops+provisioning/README.md`

---

### 4) 🌐 `k8s/networking/`
**Purpose:** How traffic moves inside Kubernetes.  
**Examples:** CNI, Service types, DNS, Ingress concepts, NetworkPolicies.

➡️ Start here: `k8s/networking/README.md`

---

### 5) 🧩 `k8s/ecosystem/`
**Purpose:** Extending Kubernetes with common tooling.  
**Examples:** Helm, Operators, Observability (Prometheus/Grafana), GitOps (ArgoCD/Flux), Security (RBAC/OPA).

➡️ Start here: `k8s/ecosystem/README.md`

## ✅ Placement Rules
- Put content in the Wing that matches the **mental mode**.
- If it spans multiple Wings, store it in `k8s/general/` and link out.
- Avoid duplication; prefer a single canonical note with links.
