# 🌐 Kubernetes Networking
## Understanding Kubernetes networking abstractions and intent

Mental mode: Reasoning about connectivity, not configuring networks.

This wing establishes the **conceptual networking model Kubernetes exposes**.
Its purpose is to remove confusion between:
- Linux networking
- cloud-provider networking
- Kubernetes networking abstractions

If you understand this wing, Kubernetes networking becomes predictable instead of mysterious.

---

## Purpose

This wing answers the question:

How does Kubernetes think about networking, and what guarantees does it provide?

You should leave this wing able to:
- explain how Pods communicate
- reason about Services and virtual IPs
- understand DNS and service discovery
- predict traffic flow through Ingress and Egress
- understand what NetworkPolicies do (and do not do)

This is not an implementation or vendor wing.
It is an abstraction and mental-model wing.

---

## Learning Posture

- Prefer conceptual models over packet flow diagrams
- Prefer Kubernetes guarantees over implementation details
- Prefer portability over environment-specific behavior
- Treat networking as a first-class system concern

You are building intuition that supports:
- troubleshooting
- operations
- architecture decisions
- interviews and design discussions

---

## Scope

This wing covers Kubernetes-native networking concepts only, including:

- Pod networking model and assumptions
- Service abstraction and virtual IP behavior
- Cluster DNS and service discovery
- Ingress and Egress concepts
- NetworkPolicies and traffic intent

This wing intentionally does **not** cover:
- CNI implementations or comparisons
- iptables, nftables, or routing internals
- cloud load balancer configuration
- kube-proxy modes or tuning
- packet-level debugging

Those topics live in other wings.

---

## Canonical Files

Planned files for this wing:

k8s/networking/
- README.md
- index.md
- pod-networking-model.md
- services-and-virtual-ips.md
- dns-and-service-discovery.md
- ingress-and-egress.md
- networkpolicies.md
- common-networking-misconceptions.md

Each file is focused on **one abstraction** and its intent.

---

## Style Rules

- Concept-first, mechanics second
- Minimal diagrams, maximal explanation
- No provider-specific assumptions
- No implementation tutorials
- If a topic belongs to ops or troubleshooting, reference it there

This wing explains *what Kubernetes promises*, not *how it enforces it*.

---

## Relationship to Other Wings

- Downstream of: linux (basic networking concepts)
- Upstream of: k8s/ops+provisioning
- Closely related to: k8s/troubleshooting
- Feeds into: k8s/ecosystem

This wing teaches how to **reason about traffic and connectivity**.
Other wings teach how to operate, debug, or extend it.

---

## Core Outcome

After completing this wing, you should be able to say:

I understand Kubernetes networking abstractions,
I can predict how traffic flows through the cluster,
and I know which problems belong to Kubernetes
and which do not.

That is networking clarity.
