# 🧰 kubectl Basics
## Interacting with the cluster without confusing cause and effect

Mental mode: Observing and declaring through a client.

This document explains **kubectl as a client tool**, not as “Kubernetes itself.”
Misunderstanding this distinction leads to incorrect mental models and debugging paths.

kubectl does not run workloads.
kubectl does not enforce state.
kubectl submits requests.

---

## Purpose
You should be able to answer:
- What is kubectl actually talking to?
- What happens when I run a kubectl command?
- Why does kubectl output not change reality by itself?
- How does kubectl fit into the declarative model?

kubectl is an interface, not the system.

---

## What kubectl Is

kubectl is a **command-line client**.

Its responsibilities:
- send requests to the Kubernetes API
- retrieve cluster state
- apply declared configuration

kubectl has no authority on its own.
It acts only through the control plane.

---

## What kubectl Is Not

kubectl is not:
- a scheduler
- a controller
- a container runtime
- a source of truth

If kubectl disappears, the cluster keeps running.

---

## Client–Server Relationship

When you run a kubectl command:
- kubectl formats a request
- sends it to the API server
- receives a response
- prints the result

All logic happens on the server side.

kubectl is replaceable.
The API is not.

---

## Read vs Write Operations

kubectl commands fall into two categories.

Read-only:
- get
- describe
- explain

These inspect state.
They do not change it.

Write operations:
- apply
- create
- delete
- patch

These submit intent.
They do not enforce outcomes.

---

## kubectl get

Purpose:
- retrieve current state

Examples:
kubectl get nodes
kubectl get pods
kubectl get services

get shows **what exists now**, not why it exists.

---

## kubectl describe

Purpose:
- inspect details and events

describe answers:
- what happened
- when it happened
- what Kubernetes tried to do

describe is diagnostic, not declarative.

---

## kubectl apply

Purpose:
- submit desired state

apply:
- sends configuration to the API server
- updates desired state
- triggers reconciliation

apply does not “deploy.”
It declares intent.

---

## Declarative Thinking with kubectl

The correct mindset:
- YAML is the source of truth
- kubectl applies state
- controllers enforce state

Manual kubectl actions are temporary unless reflected in declarations.

---

## Namespaces (Basic Awareness)

Namespaces:
- partition cluster resources
- provide scoping
- reduce naming collisions

kubectl defaults to a namespace.
Always be aware of context.

---

## Context and Configuration

kubectl uses:
- kubeconfig
- contexts
- credentials

kubectl commands always run against:
- a specific cluster
- a specific user
- a specific namespace

Wrong context equals wrong results.

---

## Common Misunderstandings

- kubectl does not restart pods by itself
- kubectl delete is not permanent if state says otherwise
- kubectl output is a snapshot, not a guarantee
- kubectl failures may be auth or context issues

Understand the client boundary.

---

## Operational Rules

- Read before you write
- Inspect before you change
- Treat kubectl output as observation
- Treat YAML as authority

kubectl is a window, not the engine.

---

## Outcome
You should be able to say:

I know what kubectl is doing,  
I know what it is not doing,  
and I know how it fits into Kubernetes’ control model.

That is client clarity.
