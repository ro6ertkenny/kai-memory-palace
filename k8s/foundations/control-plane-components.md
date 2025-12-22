# 🧠 Control Plane Components
## Understanding who decides and who remembers

Mental mode: Knowing which component is responsible for what.

This document explains the **conceptual roles** of the Kubernetes control plane components.
The goal is responsibility clarity, not configuration or tuning.

If you know who does what, Kubernetes behavior becomes predictable.

---

## Purpose
You should be able to answer:
- Which component handles requests?
- Which component stores state?
- Which component makes decisions?
- Which component takes action?

Each control plane component has a **single primary responsibility**.

---

## The Control Plane at a Glance

The Kubernetes control plane is composed of:
- kube-apiserver
- etcd
- kube-scheduler
- kube-controller-manager

These components work together to maintain desired state.

---

## kube-apiserver
Role: **Front door and traffic controller**

Responsibilities:
- Accepts all cluster requests
- Authenticates and authorizes clients
- Validates requests
- Persists accepted state changes

Important points:
- All clients talk to the API server
- No other component bypasses it
- It does not make scheduling decisions

If the API server is unavailable, the cluster cannot be changed.

---

## etcd
Role: **Source of truth**

Responsibilities:
- Stores all cluster state
- Persists desired and current state
- Provides consistency guarantees

Important points:
- etcd is not queried directly by users
- It must be reliable and consistent
- Losing etcd means losing the cluster’s memory

Kubernetes without etcd has no memory.

---

## kube-scheduler
Role: **Decision maker**

Responsibilities:
- Selects which node should run a workload
- Evaluates resource availability
- Considers constraints and policies

Important points:
- The scheduler only decides placement
- It does not start containers
- It does not enforce runtime behavior

Scheduling is a one-time decision per workload placement.

---

## kube-controller-manager
Role: **Reconciliation engine**

Responsibilities:
- Runs controllers
- Watches cluster state
- Takes action to correct drift

Examples of controllers:
- node controller
- replication controller
- endpoint controller

Controllers are constantly active.

They make Kubernetes self-healing.

---

## Controllers (Mental Model)

A controller:
- watches a resource
- compares current state to desired state
- takes action if they differ

This loop never stops.

Controllers are why manual changes are often overwritten.

---

## Component Interaction Flow

At a high level:
1. A request enters via the API server
2. State is stored in etcd
3. Controllers observe the change
4. The scheduler assigns placement if needed
5. Nodes act and report status
6. Controllers verify convergence

Understanding this flow explains most behavior.

---

## Statelessness and Resilience

Most control plane components:
- are stateless
- can be restarted safely
- rely on etcd for state

This design enables high availability.

---

## Common Misunderstandings

- The API server does not run workloads
- etcd does not make decisions
- The scheduler does not start containers
- Controllers do not accept user input

Confusing roles leads to incorrect debugging.

---

## Outcome
You should be able to say:

I know which component accepts requests,  
I know which component stores state,  
I know which component decides placement,  
and I know which components enforce desired state.

That is control plane clarity.
