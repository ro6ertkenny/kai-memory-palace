# 🐳 Phase 16 — Containers & Virtualization (Execution Playbook)
*LFCS workload isolation: run, inspect, control lifecycle of containers and VMs under time pressure.*

Path:
- linux/LFCS-execution-playbooks/phase-16-containers-and-virtualization.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- run containers with ports and restart policies
- list, inspect, exec into, stop, and remove containers
- manage images (pull, remove)
- build and run from Dockerfile (when provided)
- list, start, stop, destroy VMs
- set VM autostart
- create VMs using virt-install (when environment supports it)
- distinguish container vs VM workflows

---

## 🧱 Lab Root

All Phase 16 drills run in:

- ~/lfcs-labs/phase-16

Initialize:

    mkdir -p ~/lfcs-labs/phase-16
    cd ~/lfcs-labs/phase-16
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT remove production containers or VMs.
- Operate only on lab resources.
- If docker/podman or libvirt is not installed, perform the parts that exist and still produce proof files.
- Do NOT flush iptables or touch host networking here.

---

## 🧪 Completion Standard

Pass Phase 16 when you can complete P16-1 through P16-16:

- in ≤ 150 minutes
- without breaking the host
- with proof files created
- and with system left clean

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P16-1 — Verify container engine

Time limit:
- 2 minutes

Do:

    docker --version > engine.txt 2>/dev/null || podman --version > engine.txt

Verify:

    cat engine.txt

-------------------------------------------------------------------------------

## P16-2 — List containers and images

Time limit:
- 3 minutes

Do:

    docker ps -a > containers.txt 2>/dev/null || podman ps -a > containers.txt
    docker images > images.txt 2>/dev/null || podman images > images.txt

Verify:

    wc -l containers.txt
    wc -l images.txt

-------------------------------------------------------------------------------

## P16-3 — Pull an image

Time limit:
- 4 minutes

Do:

    docker pull nginx > pull.txt 2>/dev/null || podman pull nginx > pull.txt

Verify:

    grep -i nginx pull.txt || true

-------------------------------------------------------------------------------

## P16-4 — Run container with port mapping

Time limit:
- 4 minutes

Do:

    docker run -d -p 18081:80 --name p16-web nginx > run.txt 2>/dev/null || podman run -d -p 18081:80 --name p16-web nginx > run.txt

Verify:

    docker ps > running.txt 2>/dev/null || podman ps > running.txt
    grep p16-web running.txt

-------------------------------------------------------------------------------

## P16-5 — Inspect container

Time limit:
- 3 minutes

Do:

    docker inspect p16-web > inspect.json 2>/dev/null || podman inspect p16-web > inspect.json

Verify:

    wc -l inspect.json

-------------------------------------------------------------------------------

## P16-6 — Exec into container

Time limit:
- 3 minutes

Do:

    docker exec p16-web ls / > exec.txt 2>/dev/null || podman exec p16-web ls / > exec.txt

Verify:

    wc -l exec.txt

-------------------------------------------------------------------------------

## P16-7 — Restart policy

Time limit:
- 4 minutes

Do:

    docker run -d --restart on-failure:3 --name p16-restart nginx > restart.txt 2>/dev/null || podman run -d --restart on-failure:3 --name p16-restart nginx > restart.txt

Verify:

    docker inspect p16-restart | grep -i restart > restart-proof.txt 2>/dev/null || podman inspect p16-restart | grep -i restart > restart-proof.txt

-------------------------------------------------------------------------------

## P16-8 — Stop, start, remove containers

Time limit:
- 5 minutes

Do:

    docker stop p16-web p16-restart > stop.txt 2>/dev/null || podman stop p16-web p16-restart > stop.txt
    docker rm -f p16-web p16-restart > rm.txt 2>/dev/null || podman rm -f p16-web p16-restart > rm.txt

Verify:

    docker ps -a > after-rm.txt 2>/dev/null || podman ps -a > after-rm.txt

-------------------------------------------------------------------------------

## P16-9 — Remove image

Time limit:
- 3 minutes

Do:

    docker rmi nginx > rmi.txt 2>/dev/null || podman rmi nginx > rmi.txt

Verify:

    docker images > images-after.txt 2>/dev/null || podman images > images-after.txt

-------------------------------------------------------------------------------

## P16-10 — Build from Dockerfile (if available)

Time limit:
- 8 minutes

Task:
Create minimal Dockerfile and build.

Do:

    mkdir buildtest
    cd buildtest
    echo "FROM nginx" > Dockerfile
    docker build -t p16img:1.0 . > build.txt 2>/dev/null || podman build -t p16img:1.0 . > build.txt
    cd ..

Verify:

    docker images | grep p16img > build-proof.txt 2>/dev/null || podman images | grep p16img > build-proof.txt

-------------------------------------------------------------------------------

## P16-11 — Run built image

Time limit:
- 3 minutes

Do:

    docker run -d -p 18082:80 --name p16-built p16img:1.0 > run-built.txt 2>/dev/null || podman run -d -p 18082:80 --name p16-built p16img:1.0 > run-built.txt

Verify:

    docker ps | grep p16-built > built-running.txt 2>/dev/null || podman ps | grep p16-built > built-running.txt

-------------------------------------------------------------------------------

## P16-12 — Cleanup built artifacts

Time limit:
- 4 minutes

Do:

    docker rm -f p16-built > rm-built.txt 2>/dev/null || podman rm -f p16-built > rm-built.txt
    docker rmi p16img:1.0 > rmi-built.txt 2>/dev/null || podman rmi p16img:1.0 > rmi-built.txt
    rm -rf buildtest

-------------------------------------------------------------------------------

## P16-13 — Verify virsh exists

Time limit:
- 3 minutes

Do:

    virsh --version > virsh.txt 2>/dev/null || echo "no virsh" > virsh.txt

-------------------------------------------------------------------------------

## P16-14 — List VMs

Time limit:
- 3 minutes

Do:

    virsh list --all > vms.txt 2>/dev/null || echo "no libvirt" > vms.txt

Verify:

    wc -l vms.txt

-------------------------------------------------------------------------------

## P16-15 — Autostart a VM (if any exist)

Time limit:
- 6 minutes

Task:
If at least one VM exists, pick one and enable autostart.

Do:

    virsh list --all

If VM named VM1 exists:

    virsh autostart VM1
    virsh dominfo VM1 > vm1-info.txt

If no VMs exist:

    echo "no vms available" > vm1-info.txt

-------------------------------------------------------------------------------

## P16-16 — Cleanup

Time limit:
- 2 minutes

Do:

    echo OK > cleanup.txt

---

## 🏁 Phase 16 Pass Criteria

You can:

- run containers with ports and restart policies
- inspect and exec into containers
- build and run images
- remove containers and images safely
- list and manage VMs
- enable VM autostart
- clearly separate container vs VM workflows

---

## 🧠 Phase 16 Law

Containers are **processes**.  
VMs are **machines**.  
Commands are **not interchangeable**.

---
