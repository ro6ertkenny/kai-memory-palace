# 🧩 Kubernetes Ecosystem
## Tools and patterns that extend the Kubernetes platform

Mental mode: Extending a stable core, not replacing it.

This wing documents the **Kubernetes ecosystem** — tools, patterns, and extensions
that build *on top of* core Kubernetes once foundations, networking, and operations
are solid.

If you understand this wing, you can reason about **why and when** to adopt
ecosystem tools without losing control of the platform.

---

## Purpose

This wing answers the question:

What do experienced Kubernetes operators add *after* the core platform is stable?

You should leave this wing able to:
- understand the role ecosystem tools play
- distinguish platform extensions from core responsibilities
- reason about trade-offs before adopting tools
- avoid overloading Kubernetes with unnecessary abstractions

This wing is about **intent and architecture**, not tutorials.

---

## Learning Posture

- Prefer understanding over adoption
- Prefer platform stability over feature velocity
- Prefer fewer tools with clear purpose
- Treat ecosystem tools as optional, not mandatory

Most Kubernetes failures come from **overextension**, not underuse.

---

## Scope

This wing covers **ecosystem-level concepts and patterns**, including:

- Package management and templating (Helm)
- Custom resources and operators
- Observability and telemetry patterns
- GitOps workflows and reconciliation
- Security and policy extensions
- Platform extensibility boundaries

This wing intentionally does **not** cover:
- cluster provisioning
- core Kubernetes APIs
- application development frameworks
- vendor-specific walkthroughs

Those belong in other wings or external references.

---

## Canonical Files

Planned files for this wing:

k8s/ecosystem/
- README.md
- index.md
- helm.md
- operators-and-crds.md
- observability.md
- gitops.md
- security-and-policy.md
- ecosystem-boundaries.md
- ai-on-kubernetes.md

Each file focuses on **why a tool class exists**, not how to install it.

---

## 🤖 AI on Kubernetes (Intentional Future Area)

The file `ai-on-kubernetes.md` is intentionally scoped as **future-facing**.

It exists to:
- capture emerging patterns
- explore AI-native workloads on Kubernetes
- avoid mixing experimental concepts into core operations

This file is **not required** to understand Kubernetes today.

---

## Style Rules

- Concept-first, tooling second
- No step-by-step installation guides
- No vendor lock-in assumptions
- Emphasize trade-offs and failure modes
- If a tool replaces core Kubernetes behavior, question it

This wing explains **why tools exist**, not **how to deploy them**.

---

## Relationship to Other Wings

- Downstream of:  
  - `k8s/foundations`
  - `k8s/networking`
  - `k8s/ops+provisioning`

- Closely related to:
  - `k8s/troubleshooting`

The ecosystem assumes the core platform is understood and stable.

---

## Core Outcome

After completing this wing, you should be able to say:

I know which Kubernetes extensions are optional,
I understand what problems they solve,
and I can evaluate them without losing platform clarity.

That is ecosystem maturity.
