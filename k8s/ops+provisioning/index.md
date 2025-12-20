# 🧭 k8s / ops + provisioning — Index
*How to navigate this wing*

---

## 📌 Purpose

This index provides a **navigation map** for the `k8s/ops+provisioning` wing.

This wing covers:
- **Day-1** cluster provisioning (build)
- **Day-2** cluster maintenance (operate)
- failure analysis and recovery (maintain)

It documents **operator responsibilities**, not application deployment.

---

## 🧠 Mental Model

Think of this wing as a lifecycle loop:

Build → Validate → Operate → Upgrade → Troubleshoot → Recover → Repeat

The goal is a cluster that is:
- understandable
- maintainable
- recoverable

---

## 🧭 Start Here

1. Read the wing overview  
   `README.md`

2. Understand the reference implementation  
   `rpi-cluster/README.md`

3. Follow lifecycle docs in this order:
- `control-plane/README.md`
- `worker-nodes/README.md`
- `upgrades/README.md`
- `troubleshooting/README.md`

---

## 📂 Reference Implementation

This wing uses a primary reference cluster to ground concepts:

`rpi-cluster/`  
- `pi-cluster-hardware.md`  
- `pi-cluster-environment.md`  
- `pi-cluster-snapshot.md`  

The reference cluster provides context, but the operational principles are
portable across environments.

---

## 🚀 Day-1 Path (Provisioning)

Day-1 is about bringing a cluster into existence correctly.

Recommended path:

- `control-plane/README.md`  
  Control plane initialization, components, trust

- `worker-nodes/README.md`  
  Node preparation and join workflows

Day-1 is complete only when:
- the API is stable
- nodes are Ready
- core components are healthy
- networking is functioning

---

## 🔧 Day-2 Path (Maintenance)

Day-2 is about keeping the cluster reliable over time.

Recommended path:

- `worker-nodes/README.md`  
  Node lifecycle: cordon/drain/replace/recover

- `upgrades/README.md`  
  Version lifecycle, risk management, validation discipline

Day-2 success is measured by:
- safe maintenance with minimal disruption
- predictable upgrades
- recoverable failures

---

## 🛠️ Incident Path (Troubleshooting)

When something breaks, use a controlled process:

- `troubleshooting/README.md`  
  Failure domains, symptom-first investigation, safe recovery mindset

A good operator:
- stabilizes first
- preserves evidence
- limits blast radius
- changes one variable at a time

---

## 🧠 Related Wings

This wing depends on knowledge from adjacent wings:

- **Kubernetes Foundations** → `../foundations/`  
  Core primitives and YAML mechanics

- **Kubernetes Networking** → `../networking/`  
  CNI, DNS, Services, traffic flow

- **Linux** → `../../linux/`  
  OS configuration, systemd, disks, networking

---

## ✅ What “Done” Looks Like

This wing is healthy when it contains:

- a repeatable Day-1 provisioning approach
- a repeatable Day-2 maintenance approach
- clear upgrade discipline
- diagnostic playbooks for common failures
- lessons learned captured as durable knowledge

This index exists to keep that structure coherent as the wing grows.

---
