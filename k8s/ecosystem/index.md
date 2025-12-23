# 🧭 Kubernetes Ecosystem — Index
*Navigation map for extending a stable Kubernetes platform*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/ecosystem` directory.

It answers the question:

> “Which extensions should I consider *after* Kubernetes foundations,
networking, and operations are solid?”

This index is **orientation and sequencing**, not endorsement.

---

## 🧠 How to Think About the Ecosystem

The Kubernetes ecosystem exists because:
- core Kubernetes is intentionally minimal
- different teams need different capabilities
- extension points enable innovation without bloating the core

Ecosystem tools should:
- extend Kubernetes, not replace it
- respect declarative reconciliation
- fail safely and transparently
- be removable without destabilizing the cluster

If a tool violates these principles, it increases risk.

---

## 🔁 Recommended Reading Order

Read these documents **in order** to build ecosystem literacy without overload.

---

### 1️⃣ `README.md`
Defines:
- scope and intent of the ecosystem wing
- what belongs here vs elsewhere
- adoption posture and guardrails

Start here to align expectations.

---

### 2️⃣ `ecosystem-boundaries.md`
Defines:
- where Kubernetes stops
- where ecosystem tools begin
- warning signs of overextension

Read this before evaluating any tool.

---

### 3️⃣ `helm.md`
Defines:
- package management and templating intent
- when Helm adds value
- when Helm increases complexity

Helm is optional, not mandatory.

---

### 4️⃣ `operators-and-crds.md`
Defines:
- Kubernetes extensibility model
- CustomResourceDefinitions (CRDs)
- operator reconciliation patterns

This explains how Kubernetes is extended safely.

---

### 5️⃣ `observability.md`
Defines:
- metrics, logs, and traces at the platform level
- why observability is foundational
- common anti-patterns

Observability should precede automation.

---

### 6️⃣ `gitops.md`
Defines:
- declarative workflows for cluster state
- reconciliation-driven deployment
- trade-offs vs imperative pipelines

GitOps is a workflow philosophy, not a product.

---

### 7️⃣ `security-and-policy.md`
Defines:
- access control and authorization patterns
- policy engines and admission control
- guardrails vs enforcement

Security is layered, not absolute.

---

### 8️⃣ `ai-on-kubernetes.md`
Explores:
- emerging AI workloads
- scheduling and resource pressure
- experimental platform extensions

This file is intentionally future-facing.

---

## 🔗 Relationship to Other Wings

- `k8s/foundations/`  
  Provides the mental models ecosystem tools depend on

- `k8s/networking/`  
  Underpins traffic behavior extensions rely on

- `k8s/ops+provisioning/`  
  Determines whether the platform can support extensions safely

- `k8s/troubleshooting/`  
  Becomes essential as ecosystem complexity increases

Ecosystem tools amplify both **capability and failure modes**.

---

## ▶️ How to Use This Index

- New to the ecosystem → read top to bottom
- Evaluating a tool → read boundaries first
- Operating mature clusters → revisit trade-offs regularly

Adopt slowly. Remove confidently.

---
