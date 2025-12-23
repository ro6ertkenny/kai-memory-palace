# 🛠️ Kubernetes Troubleshooting
*Failure analysis, diagnosis, and safe recovery*

---

## 📌 Purpose

This directory documents **operator-grade Kubernetes troubleshooting**
within the `k8s/ops+provisioning` wing.

Troubleshooting is not improvisation.
It is the discipline of:

- identifying the correct failure domain
- separating symptoms from root cause
- stabilizing the system before fixing it
- restoring service without introducing secondary damage

This documentation is **operator-first** and assumes responsibility
for cluster health, not blame assignment.

---

## 🧠 Troubleshooting Mindset

Effective Kubernetes troubleshooting follows a small set of
non-negotiable principles:

- **Be systematic**  
  Guessing increases blast radius.

- **Change one thing at a time**  
  Parallel fixes destroy causality.

- **Preserve evidence**  
  Logs, events, and states disappear quickly.

- **Contain before correcting**  
  Stabilize first; repair second.

- **Assume partial failure**  
  Kubernetes is designed to survive component loss.

Good troubleshooting is calm, deliberate, and evidence-driven.

---

## 🔁 Lifecycle Context

Troubleshooting spans both cluster lifecycle phases.

### 🚀 Day-1 Troubleshooting (Bootstrap & Initialization)

Common Day-1 failure scenarios include:

- kubeadm init or join failures
- control-plane components not starting
- CNI installation issues
- certificate or networking misconfiguration
- nodes failing to register or become Ready

Day-1 failures usually indicate **misconfiguration or unmet prerequisites**.

---

### 🔧 Day-2 Troubleshooting (Operations & Change)

Common Day-2 failure scenarios include:

- nodes flapping Ready / NotReady
- Pods failing to schedule or start
- API server latency or outages
- upgrade regressions
- certificate expiration
- etcd, storage, or networking degradation

Most real-world incidents occur during **Day-2**.

---

## 🧠 Failure Domains (Think in Layers)

Kubernetes failures almost always originate in one primary domain:

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
  - expired certs, authentication or authorization failures

Correct domain identification is the **highest-leverage troubleshooting step**.

---

## 🔍 Symptom-First Investigation

Troubleshooting should begin with **observable symptoms**, such as:

- Pods stuck in Pending or CrashLoopBackOff
- Nodes transitioning between Ready and NotReady
- API calls timing out or returning errors
- Controllers failing to reconcile desired state
- Unexpected scheduling or placement behavior

Symptoms guide **where to look first**, not what to fix immediately.

---

## ⚠️ High-Risk Situations

Some scenarios require extra caution and slower action:

- control-plane instability
- etcd health degradation
- certificate expiration near or past deadline
- rolling failures across multiple nodes
- upgrades or migrations in progress

In these cases:
- pause automation
- limit concurrent changes
- prioritize state and trust preservation

Speed increases risk during instability.

---

## 🧭 Reference Context

Troubleshooting practices in this directory are grounded using the
**Raspberry Pi Kubernetes cluster** as a reference implementation.

That cluster provides:
- realistic resource constraints
- clear and immediate failure signals
- safe opportunities to practice recovery

The diagnostic patterns documented here remain portable
across environments.

---

## 📦 What Lives in This Directory

This directory will contain:

- symptom-to-domain diagnostic frameworks
- failure pattern catalogs
- containment and recovery playbooks
- high-risk scenario guidance
- post-incident analysis frameworks

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
