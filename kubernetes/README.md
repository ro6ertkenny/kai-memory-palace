# ☸️ Kubernetes Wing

Welcome to the **Kubernetes Wing** of the Kai Memory Palace.

This wing documents **Kubernetes concepts, operations, and workflows** with an
emphasis on *understanding how the system behaves*, not just memorizing YAML or
commands.

Kubernetes is treated here as an **operating system for distributed systems** —
complex, powerful, and deserving of disciplined study.

---

## 🎯 Purpose

The Kubernetes Wing exists to:

- Build a clear mental model of Kubernetes architecture
- Document real cluster operations and troubleshooting
- Reinforce best practices through hands-on experience
- Support certification readiness (CKA) with durable understanding
- Connect theory directly to running systems

This wing is grounded in **practical cluster operation**, not abstract examples.

---

## 🧠 Scope

Topics in this wing include, but are not limited to:

- Cluster architecture and components
- Control plane vs worker node responsibilities
- `kubeadm` workflows (init, join, upgrade, reset)
- API objects and their relationships
- Pods, ReplicaSets, Deployments, and Services
- Scheduling and resource management
- Networking fundamentals (CNI behavior)
- Storage primitives (volumes, claims)
- Observability and debugging
- Failure modes and recovery
- Security basics (RBAC, contexts, kubeconfig)

---

## 🧭 How This Wing Is Organized

Content is organized as **focused Markdown artifacts**, typically centered around
one concept, workflow, or failure mode.

Examples:

- `cluster-architecture.md`
- `control-plane-components.md`
- `kubeadm-workflows.md`
- `pod-lifecycle.md`
- `services-and-networking.md`
- `debugging-playbook.md`
- `upgrade-notes.md`

Each artifact should:
- Answer a specific operational question
- Include commands and explanations
- Capture real output when useful
- Emphasize cause-and-effect

---

## 🧰 Operational Philosophy

Kubernetes documentation in this wing follows these principles:

- Understand the API before the abstraction
- Read system state before acting
- Prefer `kubectl get` and `describe` over guesswork
- Treat failures as learning opportunities
- Document *why* a fix worked, not just *that* it worked

Automation is introduced **after** manual workflows are understood.

---

## 🧠 Relationship to Other Wings

| Wing            | Relationship to Kubernetes |
|-----------------|----------------------------|
| 🐧 Linux         | Kubernetes runs on Linux |
| 🌐 Networking   | Kubernetes networking extends Linux networking |
| ✍️ Vim           | Primary editor for YAML and configs |
| 🧰 Snippets     | Extracted kubectl and YAML patterns |
| 🤙 Kai          | Mental models for operating distributed systems |

Kubernetes depends on Linux; it does not replace it.

---

## 📌 Intended Audience

- Kubernetes learners building real clusters
- Engineers preparing for CKA
- Linux admins expanding into orchestration
- Recruiters evaluating distributed systems competence

The tone is **clear, neutral, and instructional**.

---

## 🏁 Status

🚧 Active and evolving

This wing grows alongside real clusters, real failures, and real fixes.

---

## 🧭 Navigation

- 🗺️ **[Palace Map](../map.md)**
- 🏛️ **[Entrance Hall](../README.md)**
