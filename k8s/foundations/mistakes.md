# ⚠️ Kubernetes Foundations — Mistakes
## High-signal conceptual mistakes worth remembering

Mental mode: Preventing incorrect mental models.

This file captures **conceptual mistakes** that commonly cause confusion,
misuse, or ineffective debugging in Kubernetes.

Only include mistakes that:
- distort understanding
- lead to wrong actions
- are likely to recur

This is not an ops troubleshooting list.
It is a mental guardrail.

---

## Rule: Document sparingly
A mistake belongs here only if:
- it reflects a misunderstanding of how Kubernetes works
- it caused incorrect reasoning or decisions
- it would mislead you again if forgotten

If it is procedural, it belongs elsewhere.

---

## Mistake: Thinking kubectl “does things”
Symptom:
- believing kubectl starts containers
- assuming kubectl output reflects enforcement

Cause:
- confusing the client with the control plane

Correction:
- kubectl sends requests
- the API server accepts or rejects them
- controllers and nodes enforce state

Operational rule:
- kubectl is an interface, not the system

---

## Mistake: Treating pods as durable entities
Symptom:
- manually fixing pods
- expecting pods to persist
- storing important data inside pods

Cause:
- thinking of pods like virtual machines

Correction:
- pods are disposable
- they are replaced, not repaired
- durability lives above the pod layer

Operational rule:
- never depend on pod longevity

---

## Mistake: Expecting manual changes to “stick”
Symptom:
- editing runtime state
- restarting containers by hand
- changes reverting unexpectedly

Cause:
- ignoring the declarative model

Correction:
- update desired state
- let reconciliation do the work

Operational rule:
- change behavior through declarations, not manual intervention

---

## Mistake: Assuming Kubernetes fixes broken applications
Symptom:
- deploying unhealthy apps repeatedly
- expecting restarts to resolve logic bugs

Cause:
- attributing application reliability to the platform

Correction:
- Kubernetes manages lifecycle, not correctness
- broken software remains broken

Operational rule:
- Kubernetes exposes failure; it does not cure it

---

## Mistake: Confusing control plane responsibility
Symptom:
- debugging the wrong component
- blaming nodes for scheduling decisions
- blaming kubectl for enforcement

Cause:
- unclear component roles

Correction:
- API server accepts requests
- etcd stores state
- scheduler decides placement
- controllers reconcile

Operational rule:
- debug according to responsibility boundaries

---

## Mistake: Thinking YAML is the deployment
Symptom:
- believing “applying YAML” deploys software directly
- treating YAML as executable logic

Cause:
- misunderstanding declarative intent

Correction:
- YAML declares desired state
- Kubernetes acts on it asynchronously

Operational rule:
- YAML expresses intent, not execution

---

## Mistake: Ignoring current vs desired state distinction
Symptom:
- misinterpreting kubectl output
- assuming observed state equals declared intent

Cause:
- conflating spec and status

Correction:
- spec is intent
- status is observation

Operational rule:
- always distinguish what you asked for from what exists now

---

## Mistake: Treating Kubernetes as a product, not a system
Symptom:
- tool-chasing
- memorizing commands without understanding
- confusion when behavior differs from expectations

Cause:
- lack of systems thinking

Correction:
- Kubernetes is a distributed control system
- behavior follows architecture and reconciliation

Operational rule:
- reason from system design, not surface behavior

---

## Add New Mistakes Here
When adding a new entry, include:
- Symptom
- Cause
- Correction
- Operational rule

If it doesn’t improve reasoning, remove it.
