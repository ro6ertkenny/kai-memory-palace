# 🧪 LFCS Execution Drills — Phase 11
# 📦 Containers and Virtual Machines (Docker / Podman / libvirt / virsh)

Path:
  linux/execution-drills/phase-11-containers-and-virtual-machines.md

Purpose:
  Build reflex-level control over containers and virtual machines: run, inspect, stop, remove, recover, and set persistence.

Mental Mode:
  Containers = fast, disposable workloads.
  VMs = heavier, stateful workloads.
  You must control both.

---

## 🧱 Lab Safety Rules

⚠️ Do this in a VM or lab machine.
⚠️ Do NOT delete important images or real VMs.
⚠️ Expect that your system may have:
- Docker OR Podman
- libvirt may or may not be installed

Use what is available.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-11
    cd ~/lfcs-labs/execution-drills/phase-11

Install tools if missing (Debian/Ubuntu):

    sudo apt update
    sudo apt install -y docker.io libvirt-clients libvirt-daemon-system virtinst

Start services:

    sudo systemctl enable --now docker
    sudo systemctl enable --now libvirtd

Verify:

    docker --version || podman --version
    virsh --version

---

# 🐳 A) Containers — Basics

## A1 — List containers

Running:

    docker ps

All:

    docker ps -a

---

## A2 — List images

    docker images

---

## A3 — Pull images

    docker pull nginx
    docker pull httpd

Verify:

    docker images

---

# 🐳 B) Run Containers

## B1 — Run nginx with port mapping

    docker run -d -p 1234:80 --name website nginx

Test:

    curl http://127.0.0.1:1234

---

## B2 — Run httpd with restart policy

    docker run -d -p 9080:80 --restart on-failure:3 --name webinstance1 httpd

Check policy:

    docker inspect webinstance1 | grep -i restart

---

# 🐳 C) Inspect and Enter Containers

## C1 — Inspect container

    docker inspect website

---

## C2 — Exec into container

    docker exec -it website /bin/bash

Exit:

    exit

---

# 🐳 D) Stop, Start, Remove

## D1 — Stop and start

    docker stop website
    docker start website

---

## D2 — Remove container

    docker stop website
    docker rm website

Force remove:

    docker rm -f webinstance1

---

## D3 — Remove image

    docker rmi nginx

(If it fails, remove dependent containers first.)

---

## D4 — Remove all containers (lab only)

    docker rm -f $(docker ps -a -q)

---

# 🐳 E) Build Image From Dockerfile

## E1 — Create Dockerfile

    cat > Dockerfile <<EOF
    FROM nginx
    COPY index.html /usr/share/nginx/html/index.html
    EOF

    echo "PHASE 11 TEST" > index.html

---

## E2 — Build image

    docker build -t myimage:1.0 .

Verify:

    docker images | grep myimage

---

## E3 — Run it

    docker run -d -p 8181:80 --name mycontainer myimage:1.0
    curl http://127.0.0.1:8181

Cleanup:

    docker rm -f mycontainer

---

# 🐳 F) Timed Container Drills

## F1 — Run nginx on 1234 in 20 seconds

    docker run -d -p 1234:80 --name website nginx

---

## F2 — Remove all containers in 10 seconds

    docker rm -f $(docker ps -a -q)

---

## F3 — List all containers in 5 seconds

    docker ps -a

---

# 🖥️ G) Virtual Machines — virsh Basics

(If libvirt is not available, read conceptually.)

## G1 — List VMs

    virsh list --all

---

## G2 — Start / shutdown / destroy

(Use an existing VM name.)

    virsh start VM1
    virsh shutdown VM1
    virsh destroy VM1

Explain:
- shutdown = graceful
- destroy = power off

---

## G3 — Autostart

Enable:

    virsh autostart VM1

Disable:

    virsh autostart --disable VM1

---

## G4 — Undefine VM (DO NOT delete disk)

    virsh undefine VM1

Explain:
- XML definition removed
- Disk usually remains

---

# 🖥️ H) VM Memory Control

## H1 — Set memory (example)

    virsh setmaxmem VM2 80M --config
    virsh setmem VM2 80M --config

Explain:
- --config = persistent

---

# 🖥️ I) virt-install (If You Have an Image)

(This is often conceptual in labs.)

## I1 — Example install

    virt-install \
      --name mockexam1 \
      --memory 1024 \
      --vcpus 1 \
      --disk path=/var/lib/libvirt/images/ubuntu.img \
      --import \
      --os-variant ubuntu22.04 \
      --graphics none \
      --network network=default

---

# 🖥️ J) Timed VM Drills

## J1 — List all VMs (5 seconds)

    virsh list --all

---

## J2 — Start VM and enable autostart (20 seconds)

    virsh start VM1
    virsh autostart VM1

---

## J3 — Force reboot VM (10 seconds)

    virsh destroy VM1
    virsh start VM1

---

# K) Failure Injection Drills

## K1 — destroy vs shutdown

Explain:
- destroy = power cut
- shutdown = graceful OS shutdown

---

## K2 — Container unreachable

Scenario:
- Container running
- curl fails

Checklist:
- docker ps
- docker port <container>
- ss -tlnp
- was -p used?

---

## K3 — Removed container but image still exists

Explain difference:

    docker rm   = removes container
    docker rmi  = removes image

---

# L) Composition (Exam Style)

## L1 — Full container lifecycle

    docker pull nginx
    docker run -d -p 1234:80 --name website nginx
    docker ps
    docker inspect website
    docker stop website
    docker rm website

---

## L2 — VM lifecycle (conceptual or real)

    virsh list --all
    virsh start VM1
    virsh autostart VM1
    virsh shutdown VM1

---

# ✅ Phase 11 Completion Criteria

You are Phase 11-ready when you can:

- List, run, inspect, stop, and remove containers
- Run containers with port mappings and restart policies
- Build and run an image from a Dockerfile
- Understand container vs image lifecycle
- List, start, stop, destroy VMs
- Enable and disable VM autostart
- Set VM memory limits
- Understand virt-install flow

---

# 🔒 Phase 11 Law

If you can’t control workloads, you can’t control compute.

---

# Cleanup (Optional)

    docker rm -f $(docker ps -a -q) || true
    docker rmi myimage:1.0 || true

---
