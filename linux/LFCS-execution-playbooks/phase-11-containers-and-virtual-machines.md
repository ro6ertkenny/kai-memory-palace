# 📦 Phase 11 — Containers & Virtual Machines (Execution Playbook)
*LFCS workload control: run, inspect, fix, and remove containers and VMs under time pressure.*

Path:
- linux/LFCS-execution-playbooks/phase-11-containers-and-virtual-machines.md

Rule:
- This is not reference material.
- This is timed execution.
- Every task produces proof.

---

## 📌 Purpose

Build reflex-level ability to:

- run containers with correct options
- list, inspect, stop, and remove containers
- manage images
- apply restart policies
- exec into containers
- build and run from Dockerfile (if present)
- control VMs with virsh
- set VM autostart
- create VMs with virt-install (if environment supports it)

---

## 🧱 Lab Root

All Phase 11 drills run in:

- ~/lfcs-labs/phase-11

Initialize:

    mkdir -p ~/lfcs-labs/phase-11
    cd ~/lfcs-labs/phase-11
    rm -rf ./*

---

## ⚠️ Safety Contract

- Do NOT remove production containers or VMs.
- Only operate on lab resources.
- If docker/podman or libvirt is not installed, perform the parts that exist and still produce proof files.

---

## 🧪 Completion Standard

Pass Phase 11 when you can complete P11-1 through P11-14:

- in ≤ 120 minutes
- without breaking the host
- with proof files created
- and with system left clean

---

# ⚔️ Playbooks

-------------------------------------------------------------------------------

## P11-1 — Verify container engine exists

Time limit:
- 2 minutes

Do:

    docker --version > docker-version.txt 2>/dev/null || podman --version > docker-version.txt

Verify:

    cat docker-version.txt

-------------------------------------------------------------------------------

## P11-2 — List containers and images

Time limit:
- 3 minutes

Do:

    docker ps -a > containers.txt 2>/dev/null || podman ps -a > containers.txt
    docker images > images.txt 2>/dev/null || podman images > images.txt

Verify:

    wc -l containers.txt
    wc -l images.txt

-------------------------------------------------------------------------------

## P11-3 — Pull image

Time limit:
- 3 minutes

Do:

    docker pull nginx > pull.txt 2>/dev/null || podman pull nginx > pull.txt

Verify:

    grep -i nginx pull.txt || true

-------------------------------------------------------------------------------

## P11-4 — Run container with port mapping

Time limit:
- 4 minutes

Do:

    docker run -d -p 18080:80 --name p11-web nginx > run.txt 2>/dev/null || podman run -d -p 18080:80 --name p11-web nginx > run.txt

Verify:

    docker ps > running.txt 2>/dev/null || podman ps > running.txt
    grep p11-web running.txt

-------------------------------------------------------------------------------

## P11-5 — Inspect container

Time limit:
- 3 minutes

Do:

    docker inspect p11-web > inspect.json 2>/dev/null || podman inspect p11-web > inspect.json

Verify:

    wc -l inspect.json

-------------------------------------------------------------------------------

## P11-6 — Exec into container

Time limit:
- 3 minutes

Do:

    docker exec p11-web ls / > exec.txt 2>/dev/null || podman exec p11-web ls / > exec.txt

Verify:

    wc -l exec.txt

-------------------------------------------------------------------------------

## P11-7 — Stop and start container

Time limit:
- 3 minutes

Do:

    docker stop p11-web > stop.txt 2>/dev/null || podman stop p11-web > stop.txt
    docker start p11-web > start.txt 2>/dev/null || podman start p11-web > start.txt

Verify:

    docker ps | grep p11-web || podman ps | grep p11-web

-------------------------------------------------------------------------------

## P11-8 — Run container with restart policy

Time limit:
- 4 minutes

Do:

    docker run -d --restart always --name p11-restart nginx > restart-run.txt 2>/dev/null || podman run -d --restart always --name p11-restart nginx > restart-run.txt

Verify:

    docker inspect p11-restart | grep -i restart > restart-policy.txt 2>/dev/null || podman inspect p11-restart | grep -i restart > restart-policy.txt

-------------------------------------------------------------------------------

## P11-9 — Remove containers

Time limit:
- 4 minutes

Do:

    docker rm -f p11-web p11-restart > rm.txt 2>/dev/null || podman rm -f p11-web p11-restart > rm.txt

Verify:

    docker ps -a > after-rm.txt 2>/dev/null || podman ps -a > after-rm.txt

-------------------------------------------------------------------------------

## P11-10 — Remove image

Time limit:
- 3 minutes

Do:

    docker rmi nginx > rmi.txt 2>/dev/null || podman rmi nginx > rmi.txt

Verify:

    docker images > images-after.txt 2>/dev/null || podman images > images-after.txt

-------------------------------------------------------------------------------

## P11-11 — Check VM tooling

Time limit:
- 3 minutes

Do:

    virsh --version > virsh-version.txt 2>/dev/null || echo "no virsh" > virsh-version.txt

Verify:

    cat virsh-version.txt

-------------------------------------------------------------------------------

## P11-12 — List VMs

Time limit:
- 2 minutes

Do:

    virsh list --all > vms.txt 2>/dev/null || echo "no libvirt" > vms.txt

Verify:

    wc -l vms.txt

-------------------------------------------------------------------------------

## P11-13 — Autostart a VM (if any exist)

Time limit:
- 6 minutes

Task:
If at least one VM exists, pick one and:

- enable autostart
- prove it

Do:

    virsh list --all

(If VM named VM1 exists:)

    virsh autostart VM1
    virsh autostart VM1 > autostart.txt

If no VMs exist:

    echo "no vms available" > autostart.txt

-------------------------------------------------------------------------------

## P11-14 — Cleanup proof

Time limit:
- 2 minutes

Do:

    echo OK > cleanup.txt

---

## 🏁 Phase 11 Pass Criteria

You can:

- run containers with port mapping
- inspect and exec into containers
- apply restart policies
- stop, start, and remove containers
- remove images
- list VMs
- enable VM autostart (when present)
- distinguish container vs VM workflows

---

## 🧠 Phase 11 Law

Containers are **processes**.  
VMs are **machines**.  
Commands are **not interchangeable**.

---
