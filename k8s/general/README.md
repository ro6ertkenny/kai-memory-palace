# 🧭 k8s/general

This Wing contains Kubernetes notes that are **cross-cutting** or **not yet classified** into a specific Kubernetes Wing.

## ✅ What belongs here
- Conventions for this repo’s Kubernetes notes
- Quick references that span multiple Wings
- “Inbox” notes before they’re sorted
- Shared troubleshooting patterns (when not purely ops)
- Links and indexes

## 🧱 Where to put other content
- Foundations / primitives → `../foundations/`
- Cluster builds / kubeadm / node lifecycle → `../ops+provisioning/`
- CNI / Services / DNS / Ingress concepts → `../networking/`
- Helm / GitOps / Observability / Security tooling → `../ecosystem/`

## 📌 Suggested structure inside this Wing (optional)
Create these files over time as needed:

- `commands.md` — canonical `kubectl` and cluster command references
- `glossary.md` — concise definitions (CRI, CNI, etc.)
- `troubleshooting.md` — cross-cutting debugging checklists
- `index.md` — curated links into the Wings

## 🔁 Sorting rule
If a note fits a Wing clearly, move it there.
If not, keep it here until the correct Wing is obvious.
