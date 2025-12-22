# 📜 Declarative vs Imperative
## How Kubernetes thinks about change

Mental mode: Describing intent, not issuing instructions.

This document explains the **declarative model** at the heart of Kubernetes
and contrasts it with imperative command-driven systems.

If this distinction is clear, Kubernetes behavior becomes predictable.

---

## Purpose
You should be able to answer:
- What does “declarative” mean in Kubernetes?
- How is it different from imperative control?
- Why does Kubernetes overwrite manual changes?
- How does desired state actually work?

This is a core mental model, not a syntax lesson.

---

## Imperative Control (Traditional Model)

Imperative systems work by **issuing commands**.

You say:
- start this
- stop that
- restart this service
- change this setting now

The system performs the action once.

Responsibility for correctness stays with the operator.

---

## Declarative Control (Kubernetes Model)

Declarative systems work by **declaring desired state**.

You say:
- this workload should exist
- it should have three replicas
- it should run this image
- it should expose this port

Kubernetes continuously works to make reality match the declaration.

Responsibility for enforcement shifts to the system.

---

## Desired State vs Current State

Kubernetes constantly compares:
- desired state (what you declared)
- current state (what actually exists)

If they differ, Kubernetes takes action.

This comparison never stops.

---

## Why Manual Changes Get Reverted

If you:
- delete a pod by hand
- edit a container manually
- change runtime state directly

Kubernetes will restore the declared state.

This is not stubbornness.
It is correctness.

---

## Reconciliation Loop (Mental Model)

Kubernetes repeatedly:
1. observes current state
2. compares it to desired state
3. acts to close the gap

This loop explains:
- self-healing
- automatic restarts
- rescheduling
- drift correction

The loop is always running.

---

## Declarative Does Not Mean Static

Declarative systems are dynamic.

You change behavior by:
- updating the declaration
- applying a new desired state

Kubernetes then moves the system toward that new target.

Change happens through state, not commands.

---

## kubectl in Context

kubectl is a **client**.

When used imperatively:
- kubectl creates or deletes objects

When used declaratively:
- kubectl applies desired state

kubectl does not enforce state.
Kubernetes does.

---

## Advantages of Declarative Control

Declarative systems:
- are easier to reason about
- recover from failure automatically
- scale better operationally
- reduce manual intervention

They trade immediate control for long-term consistency.

---

## Common Misunderstandings

- Declarative does not mean “slow”
- Declarative does not remove control
- Declarative does not eliminate debugging
- Declarative does not prevent change

It changes *how* change is expressed.

---

## Operational Implications

You should:
- fix issues by updating declarations
- avoid manual runtime edits
- treat YAML as the source of truth
- expect the system to correct drift

Fight the model and you will lose.

---

## Outcome
You should be able to say:

I understand how Kubernetes interprets intent,  
I know why it overwrites manual changes,  
and I know how to change behavior correctly.

That is declarative clarity.
