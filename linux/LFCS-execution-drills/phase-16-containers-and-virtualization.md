# 🧪 LFCS Execution Drills — Phase 16
# 🐳 Containers & Virtualization (Docker + libvirt/virsh)

Path:
  linux/execution-drills/phase-16-containers-and-virtualization.md

Purpose:
  Build reflex-level control over container and VM lifecycle operations.

Mental Mode:
  Always ask first:
  “Is this a container or a VM? The commands are not interchangeable.”

---

## 🧱 Lab Safety Rules

⚠️ Do this in a VM or lab machine.
⚠️ Do NOT run on a production host.
⚠️ Containers are disposable. VMs are not.

---

## 🧱 Lab Setup

    mkdir -p ~/lfcs-labs/execution-drills/phase-16
    cd ~/lfcs-labs/execution-drills/phase-16

Verify tools exist:

    docker --version
    virsh --version || true
    virt-install --version || true

---

# 🐳 A) Docker — Core Lifecycle

## A1 — List containers and images

    docker ps
    docker ps -a
    docker images

---

## A2 — Pull and run nginx

    docker pull nginx
    docker run -d --name web1 nginx

Verify:

    docker ps
    docker logs web1 | head

Stop and remove:

    docker stop web1
    docker rm web1

---

## A3 — Run with port mapping (exam favorite)

    docker run -d -p 8080:80 --name website nginx

Test locally:

    curl http://127.0.0.1:8080 || true

Cleanup:

    docker stop website
    docker rm website

---

## A4 — Run with restart policy

Always restart:

    docker run -d -p 9080:80 --restart always --name webinstance1 httpd

Check policy:

    docker inspect webinstance1 | grep -i restart

Cleanup:

    docker rm -f webinstance1

---

## A5 — On-failure restart policy

    docker run -d -p 9090:80 --restart on-failure:3 --name apache_container httpd

Inspect:

    docker inspect apache_container | grep -i restart

Cleanup:

    docker rm -f apache_container

---

## A6 — Exec into a container

    docker run -d --name shelltest nginx
    docker exec -it shelltest /bin/bash || docker exec -it shelltest sh

Exit and cleanup:

    exit
    docker rm -f shelltest

---

# 🧹 B) Cleanup Patterns

## B1 — Remove all containers

    docker rm -f $(docker ps -a -q)

## B2 — Remove images

    docker images
    docker rmi nginx httpd || true

---

# 🧱 C) Build Image from Dockerfile

## C1 — Create a minimal Dockerfile

    mkdir dockerbuild
    cd dockerbuild

    cat > Dockerfile <<EOF
    FROM nginx
    RUN echo "LFCS TEST" > /usr/share/nginx/html/index.html
    EOF

Build:

    docker build -t lfcs-nginx:1.0 .

Run:

    docker run -d -p 8181:80 --name lfcs_web lfcs-nginx:1.0

Test:

    curl http://127.0.0.1:8181 || true

Cleanup:

    docker rm -f lfcs_web
    docker rmi lfcs-nginx:1.0

    cd ..
    rm -rf dockerbuild

---

# 🧪 D) Timed Docker Drills

## D1 — List all containers (5 seconds)

    docker ps -a

## D2 — Run nginx on port 1234 (15 seconds)

    docker run -d -p 1234:80 --name testweb nginx

Cleanup:

    docker rm -f testweb

## D3 — Remove all containers (5 seconds)

    docker rm -f $(docker ps -a -q)

---

# 🖥️ E) Virtual Machines — virsh

(Only if libvirt is available in your lab.)

## E1 — List all VMs

    virsh list --all

---

## E2 — Start, shutdown, destroy

Start:

    virsh start VM1

Shutdown (graceful):

    virsh shutdown VM1

Force stop:

    virsh destroy VM1

---

## E3 — Autostart

Enable:

    virsh autostart VM1

Disable:

    virsh autostart --disable VM1

---

## E4 — Undefine VM (definition only)

    virsh undefine VM1

Explain:
- This does NOT delete the disk by default.

---

# 🧠 F) VM Memory Management

## F1 — Set max memory

    virsh setmaxmem VM2 80M --config

## F2 — Set current memory

    virsh setmem VM2 80M --config

Verify:

    virsh dominfo VM2 | grep -i memory

---

# 🏗️ G) Creating VMs (virt-install)

(Only if your lab supports it.)

## G1 — Import from existing image

    virt-install \
      --name lfcs-testvm \
      --memory 1024 \
      --vcpus 1 \
      --disk path=/var/lib/libvirt/images/ubuntu.img \
      --import \
      --os-variant ubuntu22.04 \
      --graphics none \
      --network network=default

List:

    virsh list --all

Enable autostart:

    virsh autostart lfcs-testvm

---

# 🧪 H) Timed VM Drills

## H1 — List all VMs (5 seconds)

    virsh list --all

## H2 — Start a VM and enable autostart (15 seconds)

    virsh start VM1
    virsh autostart VM1

## H3 — Force reboot VM (10 seconds)

    virsh destroy VM1
    virsh start VM1

---

# 💣 I) Failure Injection Drills

## I1 — Forgot -d

Run:

    docker run nginx

Problem:
- Terminal blocks

Fix:
- Ctrl+C, rerun with -d

---

## I2 — Forgot port mapping

Run:

    docker run -d --name webtest nginx

Problem:
- curl 127.0.0.1:80 does not work

Diagnosis:

    docker inspect webtest

Fix:
- Remove and recreate with -p

---

## I3 — Confusing VM commands

Explain:
- virsh shutdown = graceful
- virsh destroy  = hard power-off

---

# 🧠 J) Composition (Exam Style)

## J1 — Full container lifecycle

    docker pull nginx
    docker run -d -p 8088:80 --restart always --name examweb nginx
    docker ps
    docker inspect examweb
    docker rm -f examweb
    docker rmi nginx

---

## J2 — Full VM lifecycle

    virsh list --all
    virsh start VM1
    virsh autostart VM1
    virsh shutdown VM1

---

# ✅ Phase 16 Completion Criteria

You are Phase 16-ready when you can:

- Run containers with ports and restart policies
- List, stop, inspect, and remove containers
- Remove images
- Build and run from Dockerfile
- List, start, stop, destroy VMs
- Enable VM autostart
- Create VM with virt-install
- Modify VM memory settings
- Never confuse container commands with VM commands

---

# 🧠 Phase 16 Law

Containers are cattle. VMs are pets. Commands are not interchangeable.

---

# 🧹 Cleanup

    docker rm -f $(docker ps -a -q) || true

---
