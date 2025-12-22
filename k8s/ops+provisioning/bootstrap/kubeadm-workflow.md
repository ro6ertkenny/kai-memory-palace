# 🧩 kubeadm Workflow
## The control-plane and node join mental model

Mental mode: Understanding what kubeadm does, not memorizing commands.

This document explains **kubeadm as a workflow**, not a command list.
If you understand the sequence and responsibilities, the commands become obvious.

kubeadm bootstraps Kubernetes.
It does not operate the cluster long-term.

---

## Purpose
You should be able to answer:
- What kubeadm is responsible for
- What kubeadm does during init, join, and reset
- What kubeadm does not manage after bootstrap
- Where kubeadm hands control to Kubernetes itself

This clarity prevents misuse and broken clusters.

---

## What kubeadm Is

kubeadm is a **cluster bootstrap tool**.

Its responsibilities:
- initialize the control plane
- generate certificates and credentials
- configure kubelet for cluster participation
- produce join instructions for additional nodes

kubeadm is used at **Day-1** and occasionally at **Day-2**.
It is not part of steady-state operations.

---

## What kubeadm Is Not

kubeadm does not:
- manage workloads
- enforce desired state
- perform upgrades automatically
- monitor cluster health long-term

Once the cluster is running, Kubernetes takes over.

---

## High-Level Workflow

The kubeadm lifecycle consists of three core actions:
- init
- join
- reset

Each action has a distinct purpose and boundary.

---

## kubeadm init (Control Plane Creation)

Purpose:
Create the initial control plane.

Conceptually, init:
- validates node prerequisites
- generates PKI assets
- configures kubelet as a control-plane node
- starts core control plane components
- writes cluster configuration
- produces a join command

Outputs:
- a running API server
- etcd initialized
- admin kubeconfig
- bootstrap tokens

At this point, the cluster exists.

---

## kubeadm init Validation

After init, validate:
- API server is reachable
- control plane pods are running
- kube-system namespace is populated
- node shows control-plane role

Failure here means the cluster is not yet viable.

---

## kubeadm join (Adding Nodes)

Purpose:
Enroll additional nodes into the cluster.

Conceptually, join:
- establishes trust using tokens and certificates
- configures kubelet for cluster membership
- registers the node with the API server

Worker nodes:
- run kubelet and container runtime
- do not host control plane components

Control-plane joins:
- also install control plane components
- participate in etcd if configured

---

## kubeadm join Validation

After join, validate:
- node appears in Ready state
- networking works across nodes
- workloads can schedule onto the node

Join failures are usually:
- token expiration
- certificate issues
- time drift
- networking problems

---

## kubeadm reset (Tear-Down)

Purpose:
Return a node to a clean state.

Conceptually, reset:
- removes Kubernetes configuration
- stops kubelet
- deletes PKI and cluster state artifacts

reset is destructive.
It should be used intentionally.

---

## reset Validation

After reset:
- node is no longer part of the cluster
- kubelet is not registered
- cluster state does not reference the node

Reset does not:
- remove OS-level changes
- uninstall container runtime
- clean arbitrary data directories

---

## Boundaries and Ownership

After bootstrap:
- Kubernetes owns lifecycle
- controllers reconcile state
- kubeadm steps aside

You do not rerun init to fix a cluster.
You debug the cluster itself.

---

## Common kubeadm Failure Patterns

- running init before OS prep
- mismatched kubeadm / kubelet versions
- reusing expired join tokens
- incorrect advertise-address
- forgetting CNI installation timing
- resetting nodes without draining

Most kubeadm issues are sequencing issues.

---

## Operational Rules

- Treat kubeadm as a one-time constructor
- Validate each step before proceeding
- Never mix kubeadm actions with guesswork
- Reset only when you mean to start over

---

## Outcome
You should be able to say:

I understand what kubeadm does at each stage,  
I know where its responsibility ends,  
and I can use it deliberately without breaking clusters.

That is bootstrap fluency.
