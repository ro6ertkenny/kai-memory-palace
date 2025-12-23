# 🧭 Troubleshooting — Index
*Navigation map for Kubernetes incident response*

---

## 📌 Purpose

This index provides a **structured navigation map** for the
`k8s/ops+provisioning/troubleshooting` directory.

It answers the operator question:

> “Where do I go when something is broken, unstable, or behaving unexpectedly?”

This index is **orientation, not instruction**.

---

## 🧠 How to Think About Troubleshooting

Troubleshooting is not about fixing fast.
It is about **restoring control**.

Effective operators:
- diagnose before acting
- contain before correcting
- preserve evidence
- optimize for recovery, not heroics

This directory documents **how to reason under failure**.

---

## 🔁 Troubleshooting Lifecycle

Incidents follow a predictable lifecycle:

1. Observe symptoms
2. Identify the failure domain
3. Contain the blast radius
4. Recover safely
5. Analyze and improve

Each document in this directory maps to one or more lifecycle stages.

---

## 🗂️ Document Map

### 📄 `README.md`
Defines:
- troubleshooting philosophy and scope
- Day-1 vs Day-2 incident context
- failure-domain thinking

Start here to understand **how this directory is meant to be used**.

---

### 🧭 `symptom-to-domain-diagnosis.md`
Covers:
- symptom-first investigation
- mapping symptoms to failure domains
- avoiding misclassification

Use this when:
- you don’t know where to start
- multiple symptoms appear simultaneously

---

### 🧯 `containment-first-response.md`
Covers:
- stabilizing the cluster
- limiting blast radius
- preserving evidence

Use this when:
- failure scope is unclear
- cascading issues are possible
- upgrades or changes are in progress

---

### 🧠 `control-plane-failure-patterns.md`
Covers:
- API server, etcd, scheduler, controller failures
- authority-layer containment and recovery

Use this when:
- the API is unstable or unavailable
- controllers stop reconciling
- cluster authority is at risk

---

### 🧱 `node-and-runtime-failure-patterns.md`
Covers:
- worker-node, kubelet, runtime, and OS failures
- execution-layer containment and recovery

Use this when:
- nodes flap Ready / NotReady
- Pods crash or fail to start
- execution capacity degrades

---

### 🔄 `recovery-and-post-incident-analysis.md`
Covers:
- completing recovery
- validating long-term stability
- extracting durable lessons

Use this when:
- service is restored
- risk must be reduced
- improvements need to be captured

---

## 🔗 Relationship to Other Directories

- `bootstrap/`  
  Covers failures during initial cluster creation

- `control-plane/`  
  Covers design and lifecycle of cluster authority

- `worker-nodes/`  
  Covers execution capacity and node operations

- `upgrades/`  
  Covers change-induced failure scenarios

This directory owns **incident response and recovery discipline**.

---

## ▶️ How to Use This Index

1. Start with symptoms, not assumptions
2. Navigate to the matching document
3. Contain before correcting
4. Validate before declaring recovery

Troubleshooting is where Kubernetes operators
demonstrate maturity.

---

