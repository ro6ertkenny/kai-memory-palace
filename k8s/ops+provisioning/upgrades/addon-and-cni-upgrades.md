# 🧩 Add-ons & CNI Upgrades
*Coordinating ecosystem components without destabilizing the cluster*

---

## 📌 Purpose

This document defines **operator responsibility for upgrading cluster add-ons**
during Kubernetes version changes.

Add-ons extend core Kubernetes behavior. They include:
- CNI plugins (networking)
- CSI drivers (storage)
- ingress controllers
- DNS and observability components
- policy, security, and metrics agents

Add-ons often fail **after** a successful core upgrade.
This document exists to prevent that class of failure.

---

## 🧠 Operator Mental Model

Think of add-ons as **tight-coupled consumers of Kubernetes APIs**.

- The control plane defines APIs
- Add-ons depend on those APIs
- Breaking API contracts breaks add-ons

Add-on upgrades must be **coordinated**, not opportunistic.

---

## 🔁 Why Add-ons Upgrade Last

Add-ons should be upgraded **after**:
- the control plane is stable
- worker nodes are compatible
- version skew boundaries are understood

Upgrading add-ons too early:
- obscures root cause
- limits rollback options
- introduces unnecessary variables

Authority first, execution second, extensions last.

---

## 🌐 CNI Plugins (Special Case)

CNI plugins are **foundational add-ons**.

They affect:
- Pod-to-Pod connectivity
- Service routing
- Network policy enforcement
- Node readiness

CNI failures can:
- prevent Pods from starting
- break cluster DNS
- cause Nodes to appear Ready but unusable

Treat CNI upgrades with **control-plane-level caution**.

---

## 🔁 Add-on Upgrade Strategy (Conceptual)

A safe add-on upgrade follows this pattern:

1. Verify core cluster stability
2. Review add-on compatibility matrices
3. Upgrade one add-on at a time
4. Validate behavior before proceeding
5. Observe for delayed failures

Parallel add-on upgrades multiply risk.

---

## 🔍 Common Add-on Failure Patterns

Add-on upgrade failures often stem from:

- deprecated or removed APIs
- CRD version mismatches
- incompatible admission controllers
- CNI feature flag changes
- insufficient permissions or RBAC drift

Symptoms may include:
- Pods stuck Pending or CrashLoopBackOff
- Nodes reporting Ready but workloads failing
- controller logs filling with warnings
- silent networking or storage failures

---

## ⚠️ High-Risk Mistakes (Contextual)

> **⚠️ Mistake: Upgrading add-ons before control-plane stability**  
> This removes isolation and complicates diagnosis.

> **⚠️ Mistake: Treating CNI like a normal workload**  
> CNI is infrastructure, not an app.

> **⚠️ Mistake: Skipping compatibility documentation**  
> Add-ons break most often due to ignored version matrices.

---

## ❤️ Validation After Add-on Upgrades

Operators must validate:
- Pod networking and DNS resolution
- Service connectivity
- storage attach/detach behavior
- node readiness and stability
- absence of repeated controller errors

Add-on validation must include **real workload behavior**, not just health checks.

---

## 🧭 Reference Context

Add-on upgrade practices here are grounded using the
**Raspberry Pi Kubernetes cluster** reference implementation.

Small clusters amplify add-on risk because:
- redundancy is limited
- networking is fragile
- recovery paths are narrow

The principles documented here remain portable
across environments.

---

## 🔗 Related Upgrade Docs

- `README.md`  
  Defines cluster-wide upgrade scope and ownership

- `upgrade-strategy-and-sequencing.md`  
  Defines when add-ons are upgraded

- `version-skew-and-compatibility.md`  
  Defines compatibility boundaries

- `validation-and-hold-points.md`  
  Defines explicit go / no-go checks

Together, these documents define **add-ons as first-class upgrade dependencies**.

---
