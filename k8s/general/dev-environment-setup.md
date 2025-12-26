# 🛠️ Kubernetes Development Environment — Canonical Setup (Local)

## 🎯 Purpose
Define the authoritative, repeatable setup for a local Kubernetes development environment
used for CKA preparation, hands-on practice, and real-world debugging.

This document exists to:
- Prevent re-debugging Docker / permissions issues
- Standardize kind + minikube usage
- Provide registry-proof image workflows
- Establish known-good baselines before running workloads

---

## 🧩 Environment Assumptions
- OS: Linux (Debian/Ubuntu family)
- Container runtime: Docker
- Kubernetes CLI: kubectl
- Local clusters:
  - kind (primary)
  - minikube (secondary)

---

## 🐳 Docker (Hard Requirement)

Verify Docker:
    docker --version
    docker ps

Ensure user access to Docker socket:
    getent group docker
    sudo usermod -aG docker $USER
    exec su -l $USER

Verify (no sudo):
    docker run --rm hello-world

---

## ☸️ kubectl

Verify client:
    kubectl version --client

Context hygiene:
    kubectl config get-contexts
    kubectl config use-context kind-kind

---

## 🧪 kind (Primary Local Cluster)

Verify:
    kind version

Create cluster:
    kind create cluster

Verify cluster:
    kubectl get nodes
    kubectl get pods -n kube-system

---

## 🧪 minikube (Secondary / Feature Testing)

Verify:
    minikube version

Start:
    minikube start

Context switch:
    kubectl config use-context minikube
    kubectl get nodes

---

## 📦 Namespace Standard
All practice workloads live outside default.

    kubectl create namespace practice
    kubectl config set-context --current --namespace=practice

---

## 🚨 Registry Reality (Critical Insight)

Many historically referenced images now fail due to:
- GCR deprecation
- GHCR token restrictions
- Docker Hub namespace changes

Do not fight registries during practice.

---

## 🧰 Canonical kind Local Image Workflow (Registry-Proof)

Use this workflow if:
- ImagePullBackOff occurs
- Registry returns 403 / 412 / timeout
- Deterministic behavior is required

Build image locally (from app repo):
    docker build -t <image>:local .

Example:
    docker build -t kuard:local .

Load image into kind:
    kind load docker-image <image>:local --name kind

Deploy using local image:
    kubectl set image deployment/<name> <container>=<image>:local
    kubectl patch deployment/<name> \
      -p '{"spec":{"template":{"spec":{"containers":[{"name":"<container>","imagePullPolicy":"IfNotPresent"}]}}}}'

Restart workload:
    kubectl delete pod -l app=<name>
    kubectl rollout status deployment/<name>

Expected:
- No image pulls
- Pod transitions directly to Running

---

## 🧯 Deployment Reset Canon (When Things Get Stuck)

If rollouts hang or ReplicaSets keep reappearing:

    kubectl delete deployment <name>
    kubectl delete service <name>
    kubectl create deployment <name> --image=<image>
    kubectl expose deployment <name> --port=80 --target-port=8080

Do not fight ReplicaSets. Reset the controller.

---

## 🧭 Operator Rule
If a Deployment blocks progress for more than 2–3 minutes,
delete and recreate it.

This is correctness, not failure.

---

## ✅ Outcome
Following this document guarantees:
- Stable local clusters
- Deterministic workload behavior
- Exam-aligned muscle memory
- Zero time wasted on registry drift
