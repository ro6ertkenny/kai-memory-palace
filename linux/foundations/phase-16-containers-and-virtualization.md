# 🐳 Phase 16 — Containers & Virtualization (Docker + libvirt/virsh)
*LFCS execution layer: run workloads in containers and virtual machines, inspect them, control lifecycle.*

---

## 📌 Purpose

This phase covers **two isolation mechanisms**:

- **Containers** (Docker / container engines)
- **Virtual Machines** (libvirt / virsh / virt-install)

LFCS expects you to:

- Run, list, inspect, start, stop, remove containers
- Pull and remove images
- Run containers with ports and restart policies
- Start/stop/list VMs
- Autostart VMs
- Create VMs using virt-install
- Change VM memory settings

---

## 🧠 Mental Model

Two different layers:

- **Containers** = process isolation (fast, lightweight)
- **VMs** = hardware virtualization (slower, heavier, full OS)

Commands and failure modes are **completely different**.

---

# 🐳 Part A — Docker: Core Lifecycle

List running containers:

    docker ps

List all (including stopped):

    docker ps -a

List images:

    docker images

Pull image:

    docker pull nginx

---

## Run a container

Basic:

    docker run nginx

Detached with name:

    docker run -d --name web nginx

Port mapping:

    docker run -d -p 8080:80 --name website nginx

With restart policy (exam favorite):

    docker run -d -p 9080:80 --restart always --name webinstance1 httpd

On-failure policy:

    docker run -d -p 80:80 --name apache_container --restart on-failure:3 httpd

---

## Stop / Remove

Stop:

    docker stop web

Remove container:

    docker rm web

Force remove:

    docker rm -f web

Remove image:

    docker rmi nginx

Force remove image:

    docker rmi nginx -f

Remove everything:

    docker rm -f $(docker ps -a -q)

---

## Inspect / Exec

Inspect container:

    docker inspect web

Enter container:

    docker exec -it web bash

---

# 🧱 Part B — Build Images

From Dockerfile:

    docker build -f Dockerfile . -t kodekloud/nginx_kodekloud:1.0

Run it:

    docker run -d -p 81:80 --name kodekloud_webserv kodekloud/nginx_kodekloud:1.0

---

# 🧪 Docker Exam Drills

- Run container with port mapping
- Run container with restart policy
- List all containers
- Remove broken containers
- Remove images
- Build and run from Dockerfile

---

# 🖥️ Part C — Virtual Machines (libvirt / virsh)

List all VMs:

    virsh list --all

Start VM:

    virsh start VM1

Shutdown cleanly:

    virsh shutdown VM1

Force stop:

    virsh destroy VM1

Enable autostart:

    virsh autostart VM1

Undefine VM:

    virsh undefine VM1

---

## Memory Management

Set max memory:

    virsh setmaxmem VM2 80M --config

Set current memory:

    virsh setmem VM2 80M --config

---

# 🏗️ Part D — Creating VMs (virt-install)

Single-line:

    virt-install --name kk-ubuntu --memory=1024 --vcpu=1 --graphics=none --disk path=/var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img --os-variant=ubuntu22.04 --network network=default --import

Multi-line (exam friendly):

    virt-install \
      --name kk-ubuntu \
      --memory 1024 \
      --vcpus 1 \
      --disk path=/var/lib/libvirt/images/ubuntu.img \
      --import \
      --os-variant ubuntu22.04 \
      --graphics none \
      --network network=default

---

# 🧪 VM Exam Drills

- List all VMs
- Start VM
- Stop VM
- Autostart VM
- Create VM from disk image
- Change memory limits

---

# ⚠️ Failure Modes

- Forgetting -d when container should run in background
- Forgetting port mappings
- Removing wrong container or image
- Confusing virsh shutdown vs destroy
- Forgetting --import for cloud images
- VM exists but not autostarted

---

# 🏁 Phase 16 Mastery Checklist

You must be able to:

- Run containers with ports and restart policies
- List, stop, remove containers
- Remove images
- Build image from Dockerfile
- List VMs
- Start, stop, destroy VMs
- Autostart VMs
- Create VM with virt-install
- Modify VM memory

---

## 🧠 Exam Law

> **Containers are cattle. VMs are pets. Commands are not interchangeable.**

---

