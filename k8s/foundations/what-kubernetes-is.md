# ❓ What Kubernetes Is
## And what it explicitly is not

Mental mode: Understanding responsibility boundaries.

This document defines **what Kubernetes is responsible for** and, just as importantly,
**what it does not do**. Most confusion and misuse comes from unclear boundaries.

---

## Purpose
You should be able to answer, clearly and calmly:
- Why does Kubernetes exist?
- What problem is it solving?
- What problems does it *not* solve?
- When is Kubernetes the wrong tool?

Understanding scope prevents misuse.

---

## What Kubernetes Is

Kubernetes is a **container orchestration system**.

At its core, Kubernetes:
- runs containers
- groups them into pods
- schedules them onto nodes
- monitors their health
- reconciles actual state to desired state

Kubernetes is a **control system**.

You tell it *what you want*, not *how to do it*.

---

## Desired State Management

Kubernetes operates on **desired state**.

You declare:
- how many replicas should exist
- what image they should run
- what resources they should use
- how they should be exposed

Kubernetes continuously works to make reality match that declaration.

If something drifts, Kubernetes corrects it.

---

## Reconciliation Loop (Mental Model)

Kubernetes continuously:
1. Observes current state
2. Compares it to desired state
3. Takes action if they differ

This loop never stops.

This is why:
- containers restart automatically
- pods are rescheduled when nodes fail
- manual changes are often overwritten

---

## What Kubernetes Is Not

Kubernetes is **not**:
- a container runtime
- a virtualization platform
- a configuration management system
- a CI/CD tool
- a logging or monitoring system
- a security solution by itself
- a cloud provider

Kubernetes coordinates systems.
It does not replace them.

---

## Containers vs Kubernetes

Containers:
- package applications
- define runtime environments

Kubernetes:
- decides where containers run
- keeps them running
- replaces them when they fail
- connects them together

Containers are the unit of execution.
Kubernetes is the system of control.

---

## Infrastructure Agnostic

Kubernetes does not care where it runs:
- bare metal
- virtual machines
- on-prem
- cloud

It assumes:
- compute exists
- networking exists
- storage exists

How those are provided is **outside Kubernetes’ scope**.

---

## Declarative Control

Kubernetes prefers **declarative input**.

You do not tell it:
- start container A on node B

You tell it:
- I want three replicas of this workload

How that happens is Kubernetes’ responsibility.

---

## When Kubernetes Is the Wrong Tool

Kubernetes may be unnecessary when:
- you run one or two static services
- workloads are simple and stable
- operational overhead outweighs benefits

Kubernetes adds complexity.
It is justified only when it reduces *overall* complexity.

---

## Common Misunderstandings

- Kubernetes does not make applications reliable by itself
- Kubernetes does not fix broken software
- Kubernetes does not remove the need for Linux knowledge
- Kubernetes does not eliminate networking problems

Kubernetes exposes reality.
It does not hide it.

---

## Relationship to Other Concepts

Kubernetes sits between:
- applications
- infrastructure

It coordinates:
- scheduling
- lifecycle
- health
- connectivity

Everything else integrates *around* it.

---

## Outcome
You should be able to say:

I know why Kubernetes exists,  
I know what it controls,  
and I know where its responsibility ends.

That is conceptual clarity.
