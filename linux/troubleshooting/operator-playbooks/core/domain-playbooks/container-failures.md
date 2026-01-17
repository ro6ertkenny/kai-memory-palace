# 📦 Container Failures — Domain Playbook

Mental mode: Check state, check logs, check ports, check mounts, check SELinux.

This playbook is used when:

- A container exits immediately
- A container will not start
- A port will not bind
- A container cannot read mounted files
- Behavior is not what you expect

---

## 🎯 Objective

1) Identify container state
2) Identify failure reason
3) Fix cause
4) Verify correct behavior

---

## 🧠 Core Model

A container is:

- Just a process
- With a filesystem view
- With optional ports and mounts

Failures are almost always:

- Bad command / app crash
- Port conflict
- Permission / SELinux issue
- Bad mount path

---

## 🧪 Entry Conditions

- Container is not running
- Container exits immediately
- Port does not respond
- Permission denied inside container

---

## 🔎 Step 1 — Check State

    podman ps
    podman ps -a

---

## 🧾 Step 2 — Check Logs

    podman logs <container>

This is the **first place to look**.

---

## 🧯 Branch A — Container Exits Immediately

Check:

    podman ps -a
    podman logs <container>

Cause:

- Bad command
- App crash
- Missing file

Fix:

- Correct command or path
- Re-run container

---

## 🌐 Branch B — Port Will Not Bind or Respond

If run failed with port error:

    ss -lntup | grep <port>

If container runs but no response:

    ss -lntup | grep <port>
    podman inspect <container>

Fix:

- Use a different port
- Stop conflicting service
- Correct port mapping

---

## 📁 Branch C — Mounted Files Not Accessible

Symptom:

- Permission denied inside container

Check:

    getenforce

If enforcing:

- Ensure volume uses :Z

Example:

    -v /srv/web:/usr/share/nginx/html:Z

Or fix labels:

    restorecon -Rv /srv/web

This is where the SELinux playbook applies.

---

## 🗂️ Branch D — Disk Full Due To Containers

Check:

    du -x -sh /var/lib/containers /var/lib/docker 2>/dev/null

Then:

- Remove unused containers/images

---

## ⛔ Operator Rules

- Always check logs first
- Containers are just processes
- Port issues are port conflicts or mapping mistakes
- File access issues on SELinux systems are usually labels

---

## 🔁 Exit Criteria

- Container runs
- Service responds
- No permission or port errors remain

