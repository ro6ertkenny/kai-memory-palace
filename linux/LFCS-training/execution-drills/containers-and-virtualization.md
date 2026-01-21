# 🧪 Containers and Virtualization — Execution Drills (LFCS)

Mental mode: Runtime control and isolation.  
Goal: Be able to **build, run, inspect, network, persist, and troubleshoot containers**, and to **recognize/operate basic virtualization signals** on a Linux system.

This is not a tutorial.  
This is an **execution checklist**.

Notes:
- Container tooling varies by distro: Docker, Podman, containerd, nerdctl.
- Prefer the tool that exists on your box. Run the detection step first.

---

## 🧭 1) Detect What’s Installed

- Identify available container tools
- Identify the active container runtime service(s)

    command -v docker || true
    command -v podman || true
    command -v nerdctl || true
    command -v ctr || true

    systemctl status docker || true
    systemctl status podman || true
    systemctl status containerd || true
    systemctl status crio || true

---

## 🧱 2) Container Image Basics (Pull / List / Inspect)

- Pull an image
- List local images
- Inspect image metadata
- Remove an image

Docker:

    docker pull alpine
    docker images
    docker inspect alpine
    docker rmi alpine

Podman:

    podman pull alpine
    podman images
    podman inspect alpine
    podman rmi alpine

---

## ▶️ 3) Run Containers (Interactive / Detached)

- Run an interactive shell
- Run a one-shot command
- Run detached
- Name a container
- Auto-remove container on exit

Docker:

    docker run -it alpine sh
    docker run --rm alpine echo hello
    docker run -d --name web nginx
    docker run --rm --name tmp alpine echo ok

Podman:

    podman run -it alpine sh
    podman run --rm alpine echo hello
    podman run -d --name web nginx
    podman run --rm --name tmp alpine echo ok

---

## 📋 4) List, Inspect, Logs, Exec

- List running containers
- List all containers
- Inspect a container
- View logs
- Exec into a running container

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

## 🛑 5) Stop, Start, Restart, Remove

- Stop container
- Start container
- Restart container
- Remove container
- Force remove

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

## 🧠 6) Networking Basics (Ports, Networks)

- Show container port mappings
- Publish a port
- Verify with curl
- List networks
- Create custom network
- Attach container to network

Docker:

    docker run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080
    docker network ls
    docker network create labnet
    docker run -d --name web2 --network labnet nginx
    docker inspect labnet

Podman:

    podman run -d --name web -p 8080:80 nginx
    curl -I http://127.0.0.1:8080
    podman network ls
    podman network create labnet
    podman run -d --name web2 --network labnet nginx
    podman network inspect labnet

---

## 💾 7) Storage (Bind Mounts and Volumes)

- Bind mount a host directory
- Verify file appears inside container
- Create a named volume
- Mount named volume

Docker:

    mkdir -p /tmp/ctr-lab
    echo "hello" > /tmp/ctr-lab/index.html
    docker run --rm -p 8081:80 -v /tmp/ctr-lab:/usr/share/nginx/html:ro nginx
    curl -s http://127.0.0.1:8081 | head -n 5

    docker volume create webdata
    docker run --rm -v webdata:/data alpine sh -c "echo hi > /data/hi.txt; ls -la /data"
    docker volume ls
    docker volume inspect webdata

Podman:

    mkdir -p /tmp/ctr-lab
    echo "hello" > /tmp/ctr-lab/index.html
    podman run --rm -p 8081:80 -v /tmp/ctr-lab:/usr/share/nginx/html:ro nginx
    curl -s http://127.0.0.1:8081 | head -n 5

    podman volume create webdata
    podman run --rm -v webdata:/data alpine sh -c "echo hi > /data/hi.txt; ls -la /data"
    podman volume ls
    podman volume inspect webdata

---

## 🧪 8) Resource Controls (CPU / Memory) and Limits

- Run with memory limit
- Run with CPU quota
- Inspect limits

Docker:

    docker run --rm -m 128m alpine sh -c "cat /sys/fs/cgroup/memory.max 2>/dev/null || true; echo ok"
    docker run --rm --cpus=0.5 alpine sh -c "echo ok"

Podman:

    podman run --rm -m 128m alpine sh -c "cat /sys/fs/cgroup/memory.max 2>/dev/null || true; echo ok"
    podman run --rm --cpus=0.5 alpine sh -c "echo ok"

---

## 🧾 9) Build a Simple Image (Dockerfile)

- Create a simple image
- Build it
- Run it
- Inspect it

Docker:

    mkdir -p /tmp/imglab
    cd /tmp/imglab
    printf "%s\n" "FROM alpine" "RUN echo hello-from-image > /hello.txt" "CMD [\"cat\",\"/hello.txt\"]" > Dockerfile
    docker build -t imglab:1 .
    docker run --rm imglab:1
    docker history imglab:1

Podman:

    mkdir -p /tmp/imglab
    cd /tmp/imglab
    printf "%s\n" "FROM alpine" "RUN echo hello-from-image > /hello.txt" "CMD [\"cat\",\"/hello.txt\"]" > Dockerfile
    podman build -t imglab:1 .
    podman run --rm imglab:1
    podman history imglab:1

---

## 🧯 10) Troubleshooting Drills

- Container exits immediately: inspect exit code and logs
- DNS inside container: test name resolution
- Network reachability: curl from inside container
- Check mounts: verify file path

Docker:

    docker run --name fail alpine sh -c "exit 7" || true
    docker inspect fail --format '{{.State.ExitCode}}'
    docker logs fail || true
    docker rm fail

    docker run --rm alpine getent hosts github.com || true
    docker run --rm alpine sh -c "apk add --no-cache curl >/dev/null 2>&1; curl -I https://example.com | head -n 1" || true

Podman:

    podman run --name fail alpine sh -c "exit 7" || true
    podman inspect fail --format '{{.State.ExitCode}}'
    podman logs fail || true
    podman rm fail

    podman run --rm alpine getent hosts github.com || true
    podman run --rm alpine sh -c "apk add --no-cache curl >/dev/null 2>&1; curl -I https://example.com | head -n 1" || true

---

## 🧷 11) Systemd and Containers (Service Control Awareness)

- Check if container engine is enabled
- Enable and start engine (if required)

    systemctl is-enabled docker 2>/dev/null || true
    sudo systemctl enable --now docker 2>/dev/null || true

    systemctl is-enabled containerd 2>/dev/null || true
    sudo systemctl enable --now containerd 2>/dev/null || true

---

## 🧠 12) Virtualization Signals (Basic Host Awareness)

Goal: Recognize whether you are inside a VM, and identify virtualization support.

- Detect if running inside a VM/container
- Check CPU virtualization flags
- Check KVM device
- Check loaded modules

    systemd-detect-virt
    lscpu | grep -i virtualization || true
    egrep -i 'vmx|svm' /proc/cpuinfo | head -n 5 || true
    ls -l /dev/kvm 2>/dev/null || true
    lsmod | egrep -i 'kvm|vbox|vmware' || true

---

## ✅ Completion Criteria

You are done with this file when:

- You can run, inspect, exec, log, mount, and publish ports in minutes
- You can build a simple image without hesitation
- You can isolate whether a failure is image, command, network, or storage
- You can quickly identify whether the host is virtualized

---

