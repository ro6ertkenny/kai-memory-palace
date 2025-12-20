# 🛠️ Kubernetes Troubleshooting
*Failure analysis, diagnosis, and safe recovery*

---

## 📌 Purpose

This directory documents **Kubernetes troubleshooting practices**
within the `k8s/ops+provisioning` wing.

Troubleshooting is the discipline of:
- identifying failure domains
- distinguishing symptoms from root causes
- restoring service safely
- avoiding secondary damage during recovery

This documentation is **operator-first** and assumes responsibility
for cluster health, not blame assignment.

---

## 🧠 Troubleshooting Mindset

Effective Kubernetes troubleshooting follows a few core principles:

- **Stay systematic**  
  Guessing increases blast radius.

- **Change one thing at a time**  
  Parallel fixes hide root causes.

- **Preserve evidence**  
  Logs and events disappear quickly.

- **Prefer containment over correction**  
  Stabilize first, fix second.

- **Assume partial failure**  
  Kubernetes is designed to survive component loss.

---

## 🔁 Lifecycle Context

Troubleshooting spans both lifecycle phases:

### 🚀 Day-1 Troubleshooting
- bootstrap failures
- kubeadm init or join errors
- control-plane components not coming up
- CNI installation issues
- certificate or networking misconfiguration

### 🔧 Day-2 Troubleshooting
- node flapping or becoming NotReady
- Pods failing to schedule or start
- API server latency or outages
- upgrade regressions
- certificate expiration
- etcd or storage-related failures

Most production incidents occur during **Day-2**.

---

## 🧠 Failure Domains (Think in Layers)

Kubernetes failures almost always originate in one of these domains:

- **Operating system**
  - disk pressure, memory exhaustion, kernel issues

- **Container runtime**
  - image pulls, runtime crashes, CRI errors

- **kubelet**
  - node registration, Pod lifecycle, status reporting

- **Networking**
  - CNI misconfiguration, DNS failures, Service routing

- **Control plane**
  - API server, scheduler, controller manager, etcd

- **Certificates and trust**
  - expired certs, authentication failures

Identifying the correct domain early saves time.

---

## 🔍 Symptom-First Investigation

Troubleshooting should begin with **observable symptoms**, such as:

- Pods stuck in Pending or CrashLoopBackOff
- Nodes transitioning between Ready and NotReady
- API calls timing out
- Controllers failing to reconcile
- Unexpected scheduling behavior

Symptoms guide **where to look first**, not what to fix immediately.

---

## ⚠️ High-Risk Situations

Some scenarios require extra caution:

- control-plane instability
- etcd health degradation
- certificate expiration near or past deadline
- rolling failures across multiple nodes
- upgrades in progress

In these cases:
- pause automation
- limit concurrent changes
- prioritize state preservation

---

## 🧭 Reference Context

Troubleshooting examples in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** as a reference implementation.

That cluster provides:
- realistic resource constraints
- clear failure signals
- safe opportunities to practice recovery

The diagnostic patterns documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- diagnostic checklists
- failure pattern catalogs
- recovery playbooks
- post-incident lessons learned
- operator decision frameworks

Exact commands and timelines live in the
implementation repository; this directory documents
**how to reason under failure**.

---

## ▶️ Where to Start

If you are new to Kubernetes troubleshooting:

1. Learn to classify failures by domain
2. Practice symptom-driven investigation
3. Understand control-plane vs worker-node impact
4. Treat recovery as a controlled operation

Troubleshooting is where Kubernetes operators
earn trust.

---
