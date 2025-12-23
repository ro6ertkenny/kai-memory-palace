# 🧱 Kubernetes Foundations — Index
*Conceptual grounding before operations*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/foundations` directory.

The Foundations wing exists to answer one question clearly:

> “What must I understand about Kubernetes *before* I try to operate it?”

This wing is **conceptual by design**.
It intentionally avoids procedures, runbooks, and troubleshooting.

---

## 🧠 How to Think About Foundations

Foundations is about **mental models**, not mechanics.

It establishes:
- what Kubernetes is (and is not)
- how its core abstractions fit together
- how operators should reason about desired state
- where beginners commonly misunderstand the system

If these concepts are weak, every other wing becomes harder.

---

## 🔁 Recommended Reading Order

Read these documents **in order** if you are new to Kubernetes.

---

### 1️⃣ `what-kubernetes-is.md`
Defines:
- the problem Kubernetes solves
- what Kubernetes does *not* do
- why it exists at all

Start here to align expectations.

---

### 2️⃣ `cluster-architecture.md`
Defines:
- high-level system structure
- control plane vs worker responsibilities
- authority vs execution

This establishes the global mental model.

---

### 3️⃣ `control-plane-components.md`
Defines:
- kube-apiserver, etcd, scheduler, controllers
- how reconciliation works
- why authority is centralized

Read this before touching operations.

---

### 4️⃣ `nodes-and-pods.md`
Defines:
- execution primitives
- how Pods relate to nodes
- why Pods are the unit of scheduling

This bridges concept to execution.

---

### 5️⃣ `declarative-vs-imperative.md`
Defines:
- declarative desired state
- reconciliation vs command execution
- why Kubernetes resists imperative control

This is core to “thinking in Kubernetes.”

---

### 6️⃣ `yaml-anatomy.md`
Defines:
- how desired state is expressed
- structure and meaning of manifests
- common YAML pitfalls

Read this before writing or reviewing manifests.

---

### 7️⃣ `kubectl-basics.md`
Defines:
- how humans interact with the API
- read vs write operations
- observation vs mutation

This is tooling, not operations.

---

### 8️⃣ `mistakes.md`
Catalogs:
- common beginner and operator misconceptions
- conceptual errors that cause real incidents
- habits that fight the Kubernetes model

Revisit this often.

---

## 🔗 Relationship to Other Wings

Foundations intentionally stops **before** action.

Next steps live elsewhere:

- `k8s/ops+provisioning/`  
  Operating and maintaining clusters

- `k8s/networking/`  
  Pod networking, Services, and traffic flow

- `k8s/ecosystem/`  
  Helm, operators, observability, GitOps

Foundations answers *why*.
Other wings answer *how*.

---

## ▶️ How to Use This Index

- New to Kubernetes → read top to bottom
- Confused during ops → return here
- Debugging conceptual issues → re-anchor here

Strong foundations reduce operational mistakes.

---
