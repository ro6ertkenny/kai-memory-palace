# 🎛️ Job Control and Signals
*Controlling running programs from the shell*

---

## 🎯 Purpose

This document explains:

- The difference between **processes** and **shell jobs**
- How to move jobs between foreground and background
- How signals work at a practical level
- How to keep programs running after you disconnect

This is about **controlling execution**, not inspecting the system.

---

## 🧠 Mental Model

- A **process** is managed by the kernel.
- A **job** is how your **shell** tracks processes it started.

Job control is a **shell feature** layered on top of the process model.

---

# 🧱 Part 1 — Foreground and Background

Run a command normally:

    sleep 1000

This runs in the **foreground** and blocks your terminal.

Run it in the background:

    sleep 1000 &

Now your shell returns immediately.

---

## 🔎 List jobs

    jobs

This shows jobs **known to this shell** (not system-wide).

---

# 🧱 Part 2 — Stopping and Resuming Jobs

While a command is running in the foreground, press:

    Ctrl+Z

This **stops** (suspends) the job.

Check:

    jobs

---

## ▶️ Resume in background

    bg

---

## ▶️ Bring to foreground

    fg

---

## 🧠 Important

- `Ctrl+Z` does **not** kill a process.
- It sends **SIGSTOP** (stop signal).
- The process is still in memory.

---

# 🧱 Part 3 — Killing Jobs vs Killing Processes

From job control:

    kill %1

(Where `%1` is the job number from `jobs`.)

This sends **SIGTERM** by default.

System-wide kill (by PID):

    kill 1234
    kill -9 1234

---

# 🧱 Part 4 — Signals (Practical Set)

List signals:

    kill -l

Important ones:

- SIGTERM (15) = please exit cleanly
- SIGKILL (9)  = die immediately (cannot be caught)
- SIGSTOP      = stop (cannot be ignored)
- SIGCONT      = continue

You can send these manually by PID:

    kill -STOP 1234
    kill -CONT 1234

This is the signal-level equivalent of Ctrl+Z and fg/bg, but works even without job control.

---

## 🧠 Rule

Always try **SIGTERM** first.  
Use **SIGKILL** only if the process is stuck.

---

# 🧱 Part 5 — Surviving Disconnects

## 🚫 The problem

If you close a terminal or SSH session, the shell sends **SIGHUP** (hangup) to child processes.

They usually die.

---

## ✅ nohup

    nohup long_command &

Meaning:

- Run this command
- Ignore hangup signals
- Keep running after logout

Output goes to `nohup.out` by default.

---

## ✅ disown

Start a job:

    long_command &

Then:

    disown

This tells the shell:

> “Forget about this job.”

It will no longer receive SIGHUP from this shell.

There is also:

    disown -h %1

Meaning:

Remove the job from the shell’s hangup (SIGHUP) list but keep it in the job table.

---

# 🧱 Part 6 — Relationship to systemd

- Job control is **per shell**
- systemd services are **not jobs**
- They are still processes, but managed by systemd instead of your shell

---

# 🧠 Common Confusions

- jobs ≠ system processes
- fg/bg ≠ kill
- Ctrl+Z ≠ Ctrl+C

Ctrl+C sends **SIGINT** (interrupt).  

SIGINT asks a process to stop, but the program can handle or ignore it.
That is why Ctrl+C sometimes does not terminate a process.


Ctrl+Z sends **SIGSTOP** (stop).

---

# 🧪 Practical Drills

    sleep 1000
    Ctrl+Z
    jobs
    bg
    fg
    Ctrl+Z
    kill %1

Test:

    nohup sleep 1000 &
    pgrep sleep

Then log out and back in and confirm it’s still running.

---

## ✅ Outcome

You should be able to:

- Control foreground and background jobs
- Stop and resume work safely
- Kill the right thing the right way
- Keep work running across SSH disconnects

That is **execution control**.
EOF

