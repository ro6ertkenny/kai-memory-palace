# 📦 Phase 11 — Containers and Virtual Machines (Docker / Podman / libvirt / virsh)
*LFCS execution layer: run workloads in containers and virtual machines, inspect, control, and recover them.*

---

## 📌 Purpose

This phase makes you **operational with modern workload isolation**:

- Running, stopping, inspecting containers
- Managing container images
- Understanding restart policies and port mappings
- Managing virtual machines with libvirt / virsh
- Installing VMs with virt-install
- Setting autostart and basic resource limits

LFCS does **not** test Kubernetes here — it tests **basic container and VM operations**.

---

## 🧠 Mental Model

Two layers:

1) **Containers**
   - Share host kernel
   - Fast, lightweight
   - Controlled by docker / podman

2) **Virtual Machines**
   - Full OS per VM
   - Managed by libvirt / virsh
   - Slower but stronger isolation

---

# 🐳 Part A — Containers (Docker / Podman)

## List containers

Running:

    docker ps

All:

    docker ps -a

---

## List images

    docker images

---

## Pull image

    docker pull nginx
    docker pull httpd

---

## Run container

Detached, map port:

    docker run -d -p 1234:80 --name website nginx

With restart policy:

    docker run -d -p 9080:80 --restart always --name webinstance1 httpd

Restart policies:

- no
- always
- on-failure
- on-failure:3
- unless-stopped

---

## Stop / Start / Remove

Stop:

    docker stop website

Remove container:

    docker rm website

Force remove:

    docker rm -f website

Remove image:

    docker rmi nginx
    docker rmi -f nginx

Remove all containers:

    docker rm -f $(docker ps -a -q)

---

## Inspect container

    docker inspect website

Enter shell:

    docker exec -it website /bin/bash

---

## Build image from Dockerfile

    docker build -f Dockerfile . -t myimage:1.0

Run it:

    docker run -d -p 81:80 --name mycontainer myimage:1.0

---

# 🧪 Canonical Container Exam Scenarios

List all containers:

    docker ps -a

Run nginx on port 1234:

    docker run -d -p 1234:80 --name website nginx

Run httpd with restart policy:

    docker run -d -p 9080:80 --restart on-failure:3 --name web httpd

Remove all containers:

    docker rm -f $(docker ps -a -q)

---

# 🖥️ Part B — Virtual Machines (libvirt / virsh)

## List VMs

    virsh list --all

---

## Start / Stop / Destroy

Start:

    virsh start VM1

Graceful shutdown:

    virsh shutdown VM1

Force stop:

    virsh destroy VM1

---

## Autostart

Enable:

    virsh autostart VM1

Disable:

    virsh autostart --disable VM1

---

## Remove VM definition

    virsh undefine VM1

(This does not delete disk by default.)

---

## Define VM from XML

    virsh define /opt/testmachine2.xml

---

## Set memory

Set max memory:

    virsh setmaxmem VM2 80M --config

Set current memory:

    virsh setmem VM2 80M --config

---

## Install VM using virt-install

Single line:

    virt-install --name kk-ubuntu --memory=1024 --vcpu=1 --graphics=none --disk path=/var/lib/libvirt/images/ubuntu.img --os-variant=ubuntu22.04 --network network=default --import

Multiline:

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

# 🧪 Canonical VM Exam Scenarios

List all VMs:

    virsh list --all

Start VM and enable autostart:

    virsh start VM1
    virsh autostart VM1

Force reboot VM:

    virsh destroy VM1 && virsh start VM1

Install VM from disk image:

    virt-install --name mockexam2 --memory=1024 --vcpu=1 --disk=/var/lib/libvirt/images/ubuntu.img --os-variant=ubuntu22.04 --noautoconsole --import

---

## ⚠️ Failure Modes

- Confusing destroy vs shutdown
- Forgetting to map ports in containers
- Forgetting restart policies
- Removing container but not image (or vice versa)
- Undefining VM but thinking disk is gone

---

## 🏁 Phase 11 Mastery Checklist

You must be able to:

- List, start, stop, remove containers
- Run containers with port mapping and restart policy
- Build images from Dockerfile
- Inspect containers
- List, start, stop, destroy VMs
- Enable VM autostart
- Install a VM using virt-install
- Set VM memory limits

---

## 🔒 Exam Law

> **If you can’t control workloads, you can’t control compute.**

---

