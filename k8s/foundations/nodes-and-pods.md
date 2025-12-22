# 🧩 Nodes & Pods
## Where workloads actually run

Mental mode: Separating execution from coordination.

This document explains **nodes** and **pods**, the two most important
execution-level concepts in Kubernetes.

If you understand nodes and pods, you understand where work happens.

---

## Purpose
You should be able to answer:
- What is a node?
- What is a pod?
- Why does Kubernetes use pods instead of running containers directly?
- Where do containers actually execute?

Pods are the unit of execution.
Nodes are the unit of capacity.

---

## Nodes

A **node** is a machine that runs workloads.

A node may be:
- a physical server
- a virtual machine
- a cloud instance

Responsibilities of a node:
- run containers
- report health and resource usage
- enforce decisions from the control plane

Nodes do not make scheduling decisions.
They execute instructions.

---

## What Runs on a Node

Each node runs:
- a container runtime
- a kubelet
- networking components

The kubelet:
- receives instructions from the control plane
- ensures containers are running as declared
- reports status back

Without a functioning kubelet, a node cannot run workloads.

---

## Pods

A **pod** is the smallest deployable unit in Kubernetes.

A pod:
- wraps one or more containers
- defines a shared execution environment
- lives on exactly one node

Pods are **ephemeral**.
They are created and destroyed as needed.

---

## Why Pods Exist

Pods exist to support:
- tightly coupled containers
- shared networking
- shared storage

Containers in the same pod:
- share an IP address
- share ports
- can share volumes
- communicate via localhost

Pods group containers that must live and die together.

---

## One Container vs Multiple Containers

Most pods contain **one container**.

Multiple containers are used when:
- helper containers are required
- sidecars provide supporting functionality
- containers must share lifecycle and locality

Do not assume multi-container pods are the default.

---

## Pod Lifecycle (Conceptual)

A pod is:
- scheduled to a node
- started by the kubelet
- monitored for health
- replaced when it fails

Pods are not repaired.
They are replaced.

This is a key Kubernetes mindset shift.

---

## Pods Are Not Durable

Important rule:
Pods are disposable.

You should not:
- store important data inside pods
- assume a pod will live forever
- manually fix a running pod

Durability is handled by higher-level abstractions.

---

## Nodes vs Pods (Key Distinction)

Nodes:
- represent capacity
- are long-lived
- fail infrequently

Pods:
- represent work
- are short-lived
- fail and restart often

Confusing these leads to incorrect designs.

---

## Scheduling Context

When you declare a workload:
- the scheduler selects a node
- the pod is bound to that node
- the kubelet makes it real

If the node fails, the pod is rescheduled elsewhere.

---

## Common Misunderstandings

- Pods are not virtual machines
- Pods do not move between nodes
- Containers do not run without pods
- Nodes do not choose workloads

Understanding these prevents debugging errors.

---

## Outcome
You should be able to say:

I know where workloads run,  
I know how containers are grouped,  
and I know why pods exist.

That is execution clarity.
