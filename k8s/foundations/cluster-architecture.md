# 🧱 Cluster Architecture
## How a Kubernetes cluster is structured

Mental mode: Knowing what talks to what.

This document explains the **high-level structure of a Kubernetes cluster**.
The goal is not configuration, tuning, or operations—only correct mental models.

If you understand cluster architecture, Kubernetes behavior stops feeling random.

---

## Purpose
You should be able to answer:
- What components make up a cluster?
- What runs where?
- How requests flow through the system?
- Which parts are control vs execution?

Architecture explains behavior.

---

## What a Cluster Is

A Kubernetes cluster is composed of:
- a **control plane**
- one or more **worker nodes**

Together, they form a distributed system.

The control plane decides.
Worker nodes execute.

---

## Control Plane vs Worker Nodes

### Control Plane
Responsible for:
- accepting requests
- storing cluster state
- making scheduling decisions
- coordinating reconciliation

The control plane does **not** run application workloads.

### Worker Nodes
Responsible for:
- running containers
- reporting status
- enforcing decisions made by the control plane

Workloads live on worker nodes.

---

## High-Level Component Layout

At a conceptual level:

- Clients talk to the control plane
- The control plane manages desired state
- Nodes carry out that state

You interact with the cluster **only through the control plane**.

---

## Client Interaction Path

When you run a command or apply YAML:
- kubectl sends a request
- the request goes to the API server
- the control plane records intent
- controllers act
- nodes converge toward desired state

Nothing talks directly to nodes behind your back.

---

## Stateless vs Stateful Components

Control plane components are mostly **stateless**:
- they rely on a central state store
- they can be restarted or replaced

Cluster state itself is stored separately.

This separation enables resilience.

---

## Scheduling Flow (Conceptual)

When a new workload is declared:
1. Desired state is recorded
2. The scheduler selects a node
3. The node is instructed to run the workload
4. The node reports status back

If the node fails, the cycle repeats.

---

## Failure Domains

Understand these failure boundaries:
- control plane failure
- node failure
- workload failure

Kubernetes responds differently to each.

Architecture defines recovery behavior.

---

## Single-Node vs Multi-Node Clusters

Single-node clusters:
- control plane and worker on the same machine
- useful for learning and development

Multi-node clusters:
- control plane isolated
- multiple workers
- production pattern

The architecture is the same.
Only scale and separation differ.

---

## Control Plane Placement

The control plane:
- may run on dedicated nodes
- may be replicated
- is often hidden in managed services

Even when hidden, it still exists.

You cannot reason about Kubernetes without it.

---

## Boundaries and Responsibilities

Kubernetes architecture assumes:
- Linux manages the OS
- the network moves packets
- storage systems persist data

Kubernetes coordinates.
It does not replace underlying systems.

---

## Common Misunderstandings

- Nodes do not decide what to run
- kubectl does not “do” anything by itself
- YAML does not deploy workloads directly
- Control plane components do not host apps

Understanding this prevents incorrect debugging paths.

---

## Outcome
You should be able to say:

I know the major parts of a Kubernetes cluster,  
I know what runs where,  
and I know how requests flow through the system.

That is architectural clarity.
