# 🧪 Nginx Static Site via ConfigMap (Pi Cluster) — Edit → Apply → Verify Loop

## 🎯 Purpose
Practice a CKA-relevant workflow on a real Raspberry Pi Kubernetes cluster:

- Create and use a namespace
- Store static content in a ConfigMap
- Mount the ConfigMap into an Nginx Deployment
- Expose the Deployment with a Service
- Access it via port-forward
- Iterate using a tight Vim edit → apply → restart → verify loop

This pattern is reusable for:
- ConfigMap management
- Deployments + Services
- Port-forward debugging
- Fast iteration with Vim

---

## 📂 Recommended location in kai-memory-palace
k8s/general/nginx-static-configmap-workflow.md

---

## ✅ Prerequisites
- kubectl configured for the target cluster
- curl available locally
- Working directory contains:
  - index.html
  - nginx.yaml

Example working directory:
~/k8s-labs/nginx-static

---

## 1) Create namespace (idempotent)

    kubectl create namespace nginx-static 2>/dev/null || true

---

## 2) Create or update ConfigMap from local index.html
Run from the directory containing index.html:

    cd ~/k8s-labs/nginx-static

    kubectl -n nginx-static create configmap nginx-html \
      --from-file=index.html \
      --dry-run=client -o yaml | kubectl apply -f -

Verify ConfigMap contents:

    kubectl -n nginx-static describe configmap nginx-html | sed -n '1,80p'

---

## 3) Apply the Deployment
Run from the directory containing nginx.yaml:

    kubectl apply -f nginx.yaml -n nginx-static
    kubectl -n nginx-static get deploy,pods -o wide

---

## 4) Expose the Deployment as a ClusterIP Service

    kubectl -n nginx-static expose deployment nginx --port=80 --target-port=80
    kubectl -n nginx-static get svc,endpoints -o wide

Expected:
- Service named nginx
- Endpoints pointing to <pod-ip>:80

---

## 5) Access the site via port-forward

    kubectl -n nginx-static port-forward svc/nginx 8080:80

In another terminal:

    curl -s http://127.0.0.1:8080 | head -n 20

Stop port-forward with Ctrl+C.

---

## 6) Core iteration loop (Vim → apply → restart → verify)

### A) Edit content with Vim

    cd ~/k8s-labs/nginx-static
    vi index.html

Change visible content (for example an <h1>).

---

### B) Apply updated ConfigMap

    kubectl -n nginx-static create configmap nginx-html \
      --from-file=index.html \
      --dry-run=client -o yaml | kubectl apply -f -

---

### C) Restart Deployment to force immediate pickup

    kubectl -n nginx-static rollout restart deployment nginx
    kubectl -n nginx-static rollout status deployment nginx
    kubectl -n nginx-static get pods -o wide

---

### D) Verify updated content

    kubectl -n nginx-static port-forward svc/nginx 8080:80

In another terminal:

    curl -s http://127.0.0.1:8080 | head -n 20

You should see the updated HTML.

---

## 🔎 Troubleshooting

### Service has no endpoints

    kubectl -n nginx-static get svc,endpoints -o wide
    kubectl -n nginx-static get pods -o wide
    kubectl -n nginx-static describe svc nginx | sed -n '1,80p'

Common causes:
- Service selector does not match pod labels
- Pod is not Running or Ready

---

### “Nothing happens when I type commands”
If your shell shows a prompt like:

    >

It is waiting for a multi-line command to finish (often due to a trailing backslash).
Cancel safely with Ctrl+C, then re-run the command.

---

## 🧾 Git commands

    cd ~/kai-memory-palace
    vim k8s/general/nginx-static-configmap-workflow.md
    git add k8s/general/nginx-static-configmap-workflow.md
    git commit -m "Add nginx static ConfigMap workflow and edit-apply-verify loop"
    git push

