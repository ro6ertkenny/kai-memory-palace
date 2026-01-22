# 🧪 Containers and Virtualization — Execution Drills (LFCS)

Mental mode: Runtime control and isolation.  
Goal: Be able to **build, run, inspect, network, persist, and troubleshoot containers**, and to **recognize/operate basic virtualization signals and virsh/libvirt controls** on a Linux system.

This is not a tutorial.  
This is an **execution checklist**.

Notes:
- Container tooling varies by distro: Docker, Podman, containerd, nerdctl.
- Virtualization tooling may or may not exist: libvirt, virsh, virt-install.
- Prefer the tool that exists on your box. Run detection first.

Core laws:

> Containers = fast, disposable workloads.  
> VMs = heavier, stateful workloads.  
> You must control both.

---

## 🧭 1) Detect What’s Installed

Container tools:

    command -v docker || true
    command -v podman || true
    command -v nerdctl || true
    command -v ctr || true

Runtime services:

    systemctl status docker || true
    systemctl status podman || true
    systemctl status containerd || true
    systemctl status crio || true

Virtualization tools:

    command -v virsh || true
    command -v virt-install || true
    systemctl status libvirtd || true

Quick versions:

    docker --version 2>/dev/null || true
    podman --version 2>/dev/null || true
    virsh --version 2>/dev/null || true

---

## 🧱 2) Lab Setup (Debian/Ubuntu)

⚠️ Do this in a VM or lab machine.  
⚠️ Do NOT run on a production host.

Create workspace:

    mkdir -p ~/lfcs-labs/execution-drills/containers-and-virtualization
    cd ~/lfcs-labs/execution-drills/containers-and-virtualization

Install tools (install what you plan to use):

    sudo apt-get update
    sudo apt-get install -y docker.io libvirt-clients libvirt-daemon-system virtinst

Start services if installed:

    sudo systemctl enable --now docker 2>/dev/null || true
    sudo systemctl enable --now libvirtd 2>/dev/null || true

Sanity:

    docker ps 2>/dev/null || true
    virsh list --all 2>/dev/null || true

---

# =========================
# 🐳 3) Containers — Images
# =========================

## 3.1 Pull / List / Inspect / Remove (Docker)

    docker pull alpine
    docker images
    docker inspect alpine
    docker rmi alpine

## 3.2 Pull / List / Inspect / Remove (Podman)

    podman pull alpine
    podman images
    podman inspect alpine
    podman rmi alpine

---

# =========================
# ▶️ 4) Run Containers
# =========================

## 4.1 Interactive shell + one-shot command

Docker:

    docker run -it alpine sh
    docker run --rm alpine echo hello

Podman:

    podman run -it alpine sh
    podman run --rm alpine echo hello

## 4.2 Detached, named container

Docker:

    docker run -d --name web nginx

Podman:

    podman run -d --name web nginx

## 4.3 Auto-remove on exit

Docker:

    docker run --rm --name tmp alpine echo ok

Podman:

    podman run --rm --name tmp alpine echo ok

---

# =========================
# 📋 5) Inspect / Logs / Exec
# =========================

Docker:

    docker ps
    docker ps -a
    docker inspect web
    docker logs web
    docker exec -it web sh

Podman:

    podman ps
    podman ps -a
    podman inspect web
    podman logs web
    podman exec -it web sh

---

# =========================
# 🛑 6) Stop / Start / Remove
# =========================

Docker:

    docker stop web
    docker start web
    docker restart web
    docker rm web
    docker rm -f web

Podman:

    podman stop web
    podman start web
    podman restart web
    podman rm web
    podman rm -f web

---

# =========================
# 🌐 7) Networking Basics
# =========================

## 7.1 Publish ports + verify with curl (exam favorite)

Docker:

    docker run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080

Podman:

    podman run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080

## 7.2 Networks (create + attach)

Docker:

    docker network ls
    docker network create labnet
    docker run -d --name web2 --network labnet nginx
    docker inspect labnet

Podman:

    podman network ls
    podman network create labnet
    podman run -d --name web2 --network labnet nginx
    podman network inspect labnet

---

# =========================
# 💾 8) Storage (Bind + Volume)
# =========================

## 8.1 Bind mount (read-only site content)

Docker:

    mkdir -p /tmp/ctr-lab
    echo "hello" > /tmp/ctr-lab/index.html
    docker run --rm -p 8081:80 -v /tmp/ctr-lab:/usr/share/nginx/html:ro nginx
    curl -s http://127.0.0.1:8081 | head -n 5

Podman:

    mkdir -p /tmp/ctr-lab
    echo "hello" > /tmp/ctr-lab/index.html
    podman run --rm -p 8081:80 -v /tmp/ctr-lab:/usr/share/nginx/html:ro nginx
    curl -s http://127.0.0.1:8081 | head -n 5

## 8.2 Named volume

Docker:

    docker volume create webdata
    docker run --rm -v webdata:/data alpine sh -c "echo hi > /data/hi.txt; ls -la /data"
    docker volume ls
    docker volume inspect webdata

Podman:

    podman volume create webdata
    podman run --rm -v webdata:/data alpine sh -c "echo hi > /data/hi.txt; ls -la /data"
    podman volume ls
    podman volume inspect webdata

---

# =========================
# 🧪 9) Resource Controls
# =========================

Docker:

    docker run --rm -m 128m alpine sh -c "cat /sys/fs/cgroup/memory.max 2>/dev/null || true; echo ok"
    docker run --rm --cpus=0.5 alpine sh -c "echo ok"

Podman:

    podman run --rm -m 128m alpine sh -c "cat /sys/fs/cgroup/memory.max 2>/dev/null || true; echo ok"
    podman run --rm --cpus=0.5 alpine sh -c "echo ok"

---

# =========================
# 🧾 10) Build an Image (Dockerfile)
# =========================

## 10.1 Minimal build (Docker or Podman)

Create build context:

    mkdir -p ~/lfcs-labs/execution-drills/containers-and-virtualization/imglab
    cd ~/lfcs-labs/execution-drills/containers-and-virtualization/imglab

Write Dockerfile:

    printf "%s\n" \
      "FROM nginx" \
      "RUN echo \"LFCS TEST\" > /usr/share/nginx/html/index.html" \
      > Dockerfile

Build:

Docker:

    docker build -t lfcs-nginx:1.0 .

Podman:

    podman build -t lfcs-nginx:1.0 .

Run + verify:

Docker:

    docker run -d -p 8181:80 --name lfcs_web lfcs-nginx:1.0
    curl http://127.0.0.1:8181 2>/dev/null || true
    docker rm -f lfcs_web

Podman:

    podman run -d -p 8181:80 --name lfcs_web lfcs-nginx:1.0
    curl http://127.0.0.1:8181 2>/dev/null || true
    podman rm -f lfcs_web

Cleanup build context:

    cd ~
    rm -rf ~/lfcs-labs/execution-drills/containers-and-virtualization/imglab

---

# =========================
# 🧯 11) Troubleshooting Drills
# =========================

## 11.1 Container exits immediately (exit code + logs)

Docker:

    docker run --name fail alpine sh -c "exit 7" || true
    docker inspect fail --format '{{.State.ExitCode}}'
    docker logs fail || true
    docker rm fail

Podman:

    podman run --name fail alpine sh -c "exit 7" || true
    podman inspect fail --format '{{.State.ExitCode}}'
    podman logs fail || true
    podman rm fail

## 11.2 DNS and reachability inside container

Docker:

    docker run --rm alpine getent hosts github.com || true
    docker run --rm alpine sh -c "apk add --no-cache curl >/dev/null 2>&1; curl -I https://example.com | head -n 1" || true

Podman:

    podman run --rm alpine getent hosts github.com || true
    podman run --rm alpine sh -c "apk add --no-cache curl >/dev/null 2>&1; curl -I https://example.com | head -n 1" || true

## 11.3 “Container unreachable” checklist

Checklist:
- is it running?
- was a port published?
- is the host listening?

Examples:

    docker ps 2>/dev/null || true
    docker port web 2>/dev/null || true
    ss -tlnp | head
    curl -I http://127.0.0.1:8080 2>/dev/null | head -n 5 || true

---

# =========================
# 🧷 12) Persistence Awareness (systemd)
# =========================

Docker engine:

    systemctl is-enabled docker 2>/dev/null || true
    sudo systemctl enable --now docker 2>/dev/null || true

containerd:

    systemctl is-enabled containerd 2>/dev/null || true
    sudo systemctl enable --now containerd 2>/dev/null || true

---

# =========================
# 🖥️ 13) Virtualization Signals (Host Awareness)
# =========================

Goal: Recognize whether you are inside a VM/container, and identify virtualization support.

    systemd-detect-virt
    lscpu | grep -i virtualization || true
    egrep -i 'vmx|svm' /proc/cpuinfo | head -n 5 || true
    ls -l /dev/kvm 2>/dev/null || true
    lsmod | egrep -i 'kvm|vbox|vmware' || true

---

# =========================
# 🖥️ 14) libvirt / virsh Basics (If Present)
# =========================

## 14.1 List VMs

    virsh list --all

## 14.2 Start / shutdown / destroy

(Use an existing VM name.)

    virsh start VM1
    virsh shutdown VM1
    virsh destroy VM1

Meaning:
- shutdown = graceful OS shutdown
- destroy  = power off (hard)

## 14.3 Autostart

Enable:

    virsh autostart VM1

Disable:

    virsh autostart --disable VM1

## 14.4 Undefine VM (DO NOT delete disk)

    virsh undefine VM1

Meaning:
- XML definition removed
- disk usually remains

## 14.5 Memory control (persistent)

    virsh setmaxmem VM2 80M --config
    virsh setmem VM2 80M --config
    virsh dominfo VM2 | grep -i memory || true

Meaning:
- --config = persistent (affects next boot)

---

# =========================
# 🧠 15) virt-install (Conceptual or Lab-Real)
# =========================

Example flow (if you already have an image):

    virt-install \
      --name lfcs-testvm \
      --memory 1024 \
      --vcpus 1 \
      --disk path=/var/lib/libvirt/images/ubuntu.img \
      --import \
      --os-variant ubuntu22.04 \
      --graphics none \
      --network network=default

Then:

    virsh list --all
    virsh autostart lfcs-testvm

---

# =========================
# ⏱️ 16) Timed Drills
# =========================

## 16.1 List all containers (5 seconds)

    docker ps -a 2>/dev/null || true
    podman ps -a 2>/dev/null || true

## 16.2 Run nginx on port 1234 (15 seconds)

Docker:

    docker run -d -p 1234:80 --name testweb nginx

Podman:

    podman run -d -p 1234:80 --name testweb nginx

Cleanup:

    docker rm -f testweb 2>/dev/null || true
    podman rm -f testweb 2>/dev/null || true

## 16.3 Remove all containers (lab only)

Docker:

    docker rm -f $(docker ps -a -q) 2>/dev/null || true

Podman:

    podman rm -f $(podman ps -a -q) 2>/dev/null || true

## 16.4 List all VMs (5 seconds)

    virsh list --all 2>/dev/null || true

---

# =========================
# 💣 17) Failure Injection Drills
# =========================

## 17.1 Forgot -d (foreground run)

Run:

    docker run nginx

Problem:
- terminal blocks

Fix:
- Ctrl+C, rerun with -d

## 17.2 Forgot port mapping

Run:

    docker run -d --name webtest nginx

Problem:
- curl 127.0.0.1:80 does not hit container

Diagnosis:

    docker inspect webtest

Fix:
- remove + recreate with -p

## 17.3 Confusing VM commands

Explain:
- virsh shutdown = graceful
- virsh destroy  = hard power-off

---

# =========================
# 🧠 18) Composition (Exam Style)
# =========================

## 18.1 Full container lifecycle

    docker pull nginx
    docker run -d -p 8088:80 --restart always --name examweb nginx
    docker ps
    docker inspect examweb
    docker rm -f examweb
    docker rmi nginx

## 18.2 VM lifecycle (if available)

    virsh list --all
    virsh start VM1
    virsh autostart VM1
    virsh shutdown VM1

---

# ✅ Completion Criteria

You are done with this file when:

- You can run, inspect, exec, log, mount, and publish ports in minutes
- You can build a simple image without hesitation
- You can isolate whether a failure is image, command, network, or storage
- You can explain container vs image lifecycle clearly
- You can quickly identify whether the host is virtualized
- You can list/start/stop/destroy VMs and set autostart (if libvirt exists)

---

# 🔒 Final Law

If you can’t control workloads, you can’t control compute.

---

# Cleanup (Optional / Lab Only)

Docker:

    docker rm -f $(docker ps -a -q) 2>/dev/null || true
    docker rmi lfcs-nginx:1.0 2>/dev/null || true

Podman:

    podman rm -f $(podman ps -a -q) 2>/dev/null || true
    podman rmi lfcs-nginx:1.0 2>/dev/null || true

---
