# 📦 Containers — Operator Basics (Podman/Docker, LFCS-Level)

Mental mode: Run, inspect, logs, exec, mount, expose port, diagnose, move on.

LFCS does not test container orchestration or image building. It tests **basic operational control**:

- Can you run a container?
- Can you see what is running?
- Can you get logs?
- Can you exec into it?
- Can you mount a directory?
- Can you expose a port?
- Can you diagnose why it fails?

Applies to **Podman or Docker**. The command shapes are nearly identical.

---

## 🧠 The One Mental Model

A container is:

- A process
- With a filesystem view
- With optional mounts
- With optional port mappings

If it fails, it is almost always one of:

- Command exits
- Permission / SELinux
- Port already in use
- File path / mount issue

---

## 🎯 LFCS Operator Goals

You must be able to:

- Run a container
- List containers (running and stopped)
- Inspect a container
- View logs
- Exec into a container
- Stop and remove containers
- Mount a host directory
- Expose a port
- Diagnose common failures

---

## 🔎 Choose Your Tool

On the exam system, you will have **either** Podman **or** Docker.

Check:

    podman --version || docker --version

From here on, substitute:

- `podman` or `docker` as appropriate.

---

## 🔧 Core Commands (Must Be Automatic)

List containers:

    podman ps
    podman ps -a

Run:

    podman run --name test-nginx -d nginx

Stop / remove:

    podman stop test-nginx
    podman rm test-nginx

Logs:

    podman logs test-nginx

Inspect:

    podman inspect test-nginx

Exec shell:

    podman exec -it test-nginx sh

---

## 🧪 Standard Operator Workflow

### Step 1 — Run something simple

    podman run --name test-nginx -d nginx

Verify:

    podman ps

---

### Step 2 — Inspect it

    podman inspect test-nginx

---

### Step 3 — View logs

    podman logs test-nginx

---

### Step 4 — Exec into it

    podman exec -it test-nginx sh

Exit shell:

    exit

---

### Step 5 — Stop and remove

    podman stop test-nginx
    podman rm test-nginx

---

## 📁 Mounting a Host Directory (Very Common Exam Task)

Example: serve files from `/srv/web` into container.

    mkdir -p /srv/web
    echo "hello" > /srv/web/index.html

Run:

    podman run --name webtest -d -p 8080:80 -v /srv/web:/usr/share/nginx/html:Z nginx

Check:

    curl http://127.0.0.1:8080

Notes:

- `-v host:container`
- `:Z` is important on SELinux systems

---

## 🌐 Exposing Ports

Syntax:

    -p host_port:container_port

Example:

    podman run -d -p 8080:80 nginx

Verify:

    ss -lntup | grep 8080
    curl http://127.0.0.1:8080

---

## 🧯 The Three Most Common Failure Patterns

---

### 1) Container exits immediately

Check:

    podman ps -a
    podman logs <container>

Cause:

- Bad command
- App crashed
- Missing file

Fix:

- Read logs
- Fix command or path

---

### 2) Port will not bind

Symptom:

- Error about port already in use

Check:

    ss -lntup | grep <port>

Fix:

- Use a different port
- Stop the conflicting service

---

### 3) Container cannot read mounted files

Symptom:

- Permission denied inside container
- Even though host permissions look fine

Checks:

- Is SELinux enforcing?

      getenforce

Fix:

- Use :Z on the volume mount:

      -v /srv/web:/usr/share/nginx/html:Z

- Or apply restorecon to the directory

This is **exactly** where your SELinux playbook applies.

---

## 🗂️ Where Container Storage Lives (For Disk-Full Scenarios)

Depending on tool:

- Docker:

      /var/lib/docker

- Podman:

      /var/lib/containers

Useful when disk is full:

    du -x -sh /var/lib/containers /var/lib/docker 2>/dev/null

---

## 🧪 LFCS Practice Drills

### Drill 1 — Basic control

1) Run nginx
2) List containers
3) Exec into it
4) View logs
5) Stop and remove

You should be able to do this **without thinking**.

---

### Drill 2 — File serving

1) Create a host directory with a file
2) Run nginx with -v mount
3) Expose port 8080
4) curl it
5) Fix it if it fails due to SELinux

---

### Drill 3 — Failure diagnosis

1) Run a container with a bad command
2) Observe it exits
3) Use:

       podman ps -a
       podman logs

4) Explain exactly why it failed

---

## ⛔ Operator Rules

- Containers are just processes. Treat them that way.
- Always check logs first.
- If file access fails on SELinux systems, think: labels.
- If port bind fails, check listeners.
- If it exits, inspect logs and command.

---

## 🔗 Cross-Links

- SELinux denials playbook (for volume access issues)
- Disk full playbooks (for image/storage growth)
- Process/service troubleshooting (containers are processes)

---

## 🏁 Exit Criteria (You Are Done When)

- You can run, inspect, exec, log, stop, remove containers
- You can mount a directory and expose a port
- You can diagnose:
  - Exit immediately
  - Port conflict
  - Permission / SELinux issues

