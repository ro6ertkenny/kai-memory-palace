# 🧪 Kubernetes Hands-On Practice — Repos & Environments (CKA Prep)

## 🎯 Purpose
Create a focused, repeatable set of **hands-on Kubernetes practice targets** (apps + manifests + environments)
that map cleanly to **CKA-style execution**.

This list was extracted from the PDFs you uploaded:
- **KUARD – Definitions** :contentReference[oaicite:0]{index=0}
- **Kubernetes Up & Running – Appendix: Building Your Own Kubernetes Cluster** :contentReference[oaicite:1]{index=1}
- **CKA Study Guide – Appendix B: Exam Review Guide** :contentReference[oaicite:2]{index=2}
- **CKA Study Guide (full)** :contentReference[oaicite:3]{index=3}

---

## ✅ What to Fork + Clone (Hands-On / You’ll Modify)

### 1) KUARD (Kubernetes Up & Running demo app)
**Why:** Canonical workload for debugging/observability practice (logs/exec/probes/services).
- Repo: `kubernetes-up-and-running/kuard`
- URL: https://github.com/kubernetes-up-and-running/kuard
- Common image referenced: `gcr.io/kuard-demo/kuard-amd64` :contentReference[oaicite:4]{index=4}

**Use it to practice**
- Deployments, Services (ClusterIP/NodePort), port-forward
- Probes (liveness/readiness)
- Resource requests/limits
- Logs, exec, describe, events

---

### 2) Benjamin Muschko — CKA Study Guide companion repo
**Why:** Realistic exam-style YAML + scenarios you can break/fix repeatedly.
- Repo: `bmuschko/cka-study-guide`
- URL: https://github.com/bmuschko/cka-study-guide :contentReference[oaicite:5]{index=5}

**Use it to practice**
- Imperative vs declarative workflows
- Workloads, scheduling constraints
- Storage + networking exercises
- Troubleshooting drills

---

## 📚 Reference-Only (Do NOT Fork — Pull files as needed)

### 3) Kubernetes Examples
**Why:** Official example manifests; great for grabbing patterns fast.
- Repo: `kubernetes/examples`
- URL: https://github.com/kubernetes/examples :contentReference[oaicite:6]{index=6}

**Guidance**
- Do not fork. Prefer copying specific YAML you need into your own practice folders.

---

## 🧰 Practice Environments (Install/Use — Do NOT Fork)

### 4) minikube
- Repo: `kubernetes/minikube`
- URL: https://github.com/kubernetes/minikube :contentReference[oaicite:7]{index=7}
- Use for: Ingress, StorageClasses, add-ons in a local cluster.

### 5) kind (Kubernetes in Docker)
- Repo: `kubernetes-sigs/kind`
- URL: https://github.com/kubernetes-sigs/kind :contentReference[oaicite:8]{index=8}
- Use for: fast disposable multi-node clusters for repeated drills.

---

## 🌐 Interactive Labs (Use online — Not GitHub repos to fork)

### 6) Killercoda
- URL: https://killercoda.com :contentReference[oaicite:9]{index=9}
- Use for: exam-like community scenarios.

### 7) Killer Shell
- URL: https://killer.sh :contentReference[oaicite:10]{index=10}
- Use for: timed simulator sessions (voucher often includes free sessions).

---

## 🗂️ Where this should live in kai-memory-palace
**Recommended path:**
- `k8s/general/practice-repos.md`

Rationale:
- This is cross-cutting and not specific to foundations/ops/networking/ecosystem.
- It’s a “navigation & execution” asset used by all wings.

---

## ✅ Decision Summary
**Fork + clone (you will modify):**
- `kubernetes-up-and-running/kuard`
- `bmuschko/cka-study-guide`

**Reference only (don’t fork):**
- `kubernetes/examples`

**Install/use only (don’t fork):**
- `kubernetes/minikube`
- `kubernetes-sigs/kind`
