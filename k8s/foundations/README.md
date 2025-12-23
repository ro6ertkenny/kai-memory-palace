# ☸️ Kubernetes Foundations
## Understanding what Kubernetes is actually doing

Mental mode: Building correct mental models.

This wing establishes the conceptual foundations of Kubernetes.
Its purpose is to remove mystery, reduce memorization, and replace “magic” with understanding.

If you understand this wing, everything else in Kubernetes becomes easier to reason about.

---

## How to Use This Wing
Start with `index.md` to follow the recommended reading order and learning flow.

---

## Purpose
This wing answers the question:

What is Kubernetes, and how does it behave when I interact with it?

You should leave this wing able to:
- explain core Kubernetes concepts in plain language
- predict system behavior before running commands
- understand why Kubernetes objects exist
- read YAML and know what matters and what does not

This is not an operations or tooling wing.
It is a thinking wing.

---

## Learning Posture
- Prefer understanding over memorization
- Prefer mental models over commands
- Prefer “why” before “how”
- Treat Kubernetes as a distributed system, not a product

You are building intuition that supports:
- troubleshooting
- operations
- interviews
- real-world cluster work

---

## Scope
This wing covers core Kubernetes concepts only, including:

- What problems Kubernetes solves (and does not)
- High-level cluster architecture
- Control plane vs worker nodes
- Pods and containers
- Declarative configuration
- Desired state vs current state
- Basic kubectl interaction
- YAML structure and intent

Operational details intentionally live in `k8s/ops+provisioning`.

No deep ops.
No ecosystem tools.
No networking deep dives.

---

## Canonical Files
Planned files for this wing:

k8s/foundations/
- README.md
- index.md
- what-kubernetes-is.md
- cluster-architecture.md
- control-plane-components.md
- nodes-and-pods.md
- declarative-vs-imperative.md
- kubectl-basics.md
- yaml-anatomy.md
- mistakes.md

Each file is intentionally focused and short.

---

## File Intent
what-kubernetes-is.md
- What Kubernetes does, why it exists, and what it explicitly does not do

cluster-architecture.md
- How the cluster is structured at a high level and what talks to what

control-plane-components.md
- Conceptual roles of kube-apiserver, etcd, scheduler, controller manager

nodes-and-pods.md
- What nodes are, what pods are, and why pods exist

declarative-vs-imperative.md
- Why Kubernetes is declarative and why desired state matters

kubectl-basics.md
- kubectl as a client, not “the cluster”

yaml-anatomy.md
- Kubernetes YAML structure: what is signal vs boilerplate

mistakes.md
- High-signal conceptual misunderstandings worth remembering

---

## Style Rules
- Concept-first, commands second
- Minimal YAML, maximal explanation
- No production assumptions
- No cloud-provider bias
- If a concept belongs to ops or networking, reference it there—do not duplicate it here

---

## Relationship to Other Wings
- Downstream of: linux (system fundamentals)
- Upstream of: k8s/ops+provisioning
- Feeds into: k8s/networking and k8s/ecosystem

This wing teaches how to think about Kubernetes.
Other wings teach how to operate it.

---

## Core Outcome
After completing this wing, you should be able to say:

I understand what Kubernetes is responsible for,
I understand how it maintains desired state,
and I can reason about its behavior before acting.

That is foundational understanding.
