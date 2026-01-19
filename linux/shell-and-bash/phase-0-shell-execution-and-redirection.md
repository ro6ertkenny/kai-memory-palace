# 🐚 Phase 0 — Shell Execution, Redirection, Pipelines, and Job Control
*LFCS foundation: if this is not automatic, everything else is slower and riskier.*

---

## 📌 Purpose

This document defines the **execution model of the Unix shell** and the **mechanics of data flow** between commands.  
Every LFCS scenario depends on these primitives:

- Running commands correctly
- Chaining commands safely
- Capturing output and errors
- Controlling foreground/background jobs
- Building reliable pipelines

Mastery here is **non-negotiable**.

---

## 🧠 Mental Model

- A shell command is:
  - a program
  - with arguments
  - with three standard streams:
    - STDIN (0)  → input
    - STDOUT (1) → normal output
    - STDERR (2) → error output

- The shell’s job is to:
  - start programs
  - connect their streams
  - decide what happens to the output

---

## ▶️ Command Execution Basics

Run a command:

    ls -la

Run multiple commands sequentially:

    mkdir testdir
    cd testdir
    touch file1

---

## 🔗 Command Chaining (Exit-Code Aware)

Run next command **only if previous succeeded**:

    make && sudo make install

Run next command **only if previous failed**:

    systemctl start ssh || systemctl status ssh

Combine:

    mkdir /mnt/test && mount /dev/vdb1 /mnt/test || echo "Mount failed"

---

## ❗ Exit Codes

Check exit code of last command:

    echo $?

Convention:
- 0   = success
- non-zero = failure

---

## 📤 Output Redirection

Redirect STDOUT (overwrite):

    ls -l > out.txt

Redirect STDOUT (append):

    ls -l >> out.txt

Redirect STDERR:

    ls /no/such/path 2> err.txt

Redirect both STDOUT and STDERR (classic):

    command > all.txt 2>&1

Redirect both (modern):

    command &> all.txt

Discard output:

    command > /dev/null
    command 2> /dev/null
    command &> /dev/null

---

## 🔀 Pipes (|)

Send STDOUT of one command into STDIN of another:

    ps aux | grep root
    ls -l | wc -l
    journalctl | grep -i error

Pipelines are **left to right data flows**.

---

## 🧰 tee (View + Save)

Write output to file **and** see it:

    dmesg | tee dmesg.txt
    command | tee out.txt

Append mode:

    command | tee -a out.txt

---

## 🧾 Separate STDOUT and STDERR

Send STDOUT and STDERR to different files:

    command > out.txt 2> err.txt

Send both to same file:

    command > all.txt 2>&1

---

## 🧪 Here-Documents (Here-Doc)

Feed multi-line input into a command:

    cat <<EOF > file.txt
    line one
    line two
    line three
    EOF

Common for:
- generating config files
- scripting

---

## 🧬 Process Substitution

Treat command output like a file:

    diff <(ls dir1) <(ls dir2)

Used when tools expect filenames.

---

## 🧵 Background & Foreground Jobs

Run in background:

    sleep 3000 &

List jobs:

    jobs

Bring job to foreground:

    fg %1

Send job to background:

    bg %1

Suspend foreground job:

    Ctrl+Z

---

## 🧨 Killing Jobs

Kill by PID:

    kill 1234

Kill by name:

    pkill nginx
    killall nginx

Send specific signal:

    kill -SIGHUP 1234
    kill -9 1234

---

## 🧱 Subshells and Grouping

Run in subshell:

    (cd /tmp && ls)

Group commands for redirection:

    { ls; date; uptime; } > report.txt

---

## 🔐 Quoting Rules (Critical)

Double quotes: variables expand

    echo "$HOME"

Single quotes: nothing expands

    echo '$HOME'

Backslash escapes:

    echo "This costs \$5"

---

## 🌍 Globbing (Wildcards)

    *.txt
    file?.log
    [a-z]*

Brace expansion:

    mkdir -p /data/{raw,processed,archive}/{2024,2025}

---

## 🧪 Canonical Exam Patterns

Find biggest file and delete it:

    find /data -type f -exec du -h {} + | sort -rh | head -n 1

Capture both outputs:

    fsck /dev/vdb1 > fsck.log 2>&1

Search logs live:

    journalctl -f | grep -i error

Count matches:

    grep -c FAILED /var/log/auth.log

---

## ⚠️ Failure Modes to Avoid

- Forgetting 2>&1 order
- Overwriting files accidentally with >
- Piping when tool needs filenames
- Killing wrong PID
- Assuming grep output means success

---

## 🏁 Phase 0 Mastery Checklist

You must be able to do **without thinking**:

- Chain commands with && and ||
- Pipe 3+ commands together
- Separate or merge STDOUT/STDERR
- Use tee
- Use here-docs
- Run background jobs and manage them
- Kill by name or PID
- Build find | sort | head pipelines
- Safely redirect output

---

## 🔒 Exam Law

> If you can’t **move data through commands safely and predictably**, you are not in control of the system.

Everything else builds on this.

---
