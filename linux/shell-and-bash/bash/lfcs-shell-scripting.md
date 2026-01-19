# 🧪 LFCS Minimal Shell Scripting (Bash)

Mental mode: **Small scripts that are safe, predictable, and debuggable.**  
Scope: the scripting you actually need for LFCS tasks and real operations.

---

## 📌 Script Skeleton (Canonical)

Create file:

    vi script.sh

Template:

    #!/usr/bin/env bash
    set -euo pipefail

    main() {
      echo "hello"
    }

    main "$@"

Make executable:

    chmod +x script.sh

Run:

    ./script.sh

Notes:
- `set -e`  : exit on error
- `set -u`  : fail on unset variables
- `pipefail`: propagate pipeline failures

---

## 🔎 Exit Codes (Truth)

- Success: `0`
- Failure: non-zero

Check the last command’s status:

    echo $?

Use explicit exits:

    exit 0
    exit 1

---

## 🧠 Variables and Quoting (LFCS-Grade Rules)

### Variables

    name="rob"
    echo "$name"

### Always quote expansions unless you explicitly want word-splitting/globbing

Good:

    echo "$name"
    cp "$src" "$dst"

Bad:

    cp $src $dst

---

## ✅ Conditionals

### File tests (classic LFCS)

    if [ -f /etc/hosts ]; then
      echo "hosts exists"
    fi

Common tests:
- `-f` file exists and is regular file
- `-d` directory exists
- `-r` readable
- `-w` writable
- `-x` executable

### String tests

    if [ -z "$var" ]; then
      echo "empty"
    fi

---

## 🔁 Loops (Minimal Set)

### for loop over explicit items

    for svc in ssh cron rsyslog; do
      systemctl is-active "$svc" || echo "inactive: $svc"
    done

### while read loop (safe stream processing)

Prefer this for lines from a command:

    find /etc -maxdepth 1 -type f -print | while IFS= read -r f; do
      echo "FILE=$f"
    done

Important:
- `IFS= read -r` prevents backslash escapes and preserves whitespace.

---

## 🧭 case (simple routing)

    case "${1:-}" in
      start) echo "starting" ;;
      stop)  echo "stopping" ;;
      *)     echo "usage: $0 {start|stop}" ; exit 2 ;;
    esac

---

## 🧷 Functions (LFCS-style)

    log() {
      echo "[$(date +%F\ %T)] $*"
    }

    log "hello"

---

## 🧯 Error Handling Patterns

### Guard missing args

    if [ $# -lt 1 ]; then
      echo "usage: $0 <path>"
      exit 2
    fi

### Validate paths

    path="$1"
    if [ ! -e "$path" ]; then
      echo "missing: $path"
      exit 1
    fi

---

## 📦 Parsing Simple Output (grep/awk/sed basics)

Goal: extract the PID of sshd (example)

    ps -ef | grep '[s]shd' | awk '{print $2}' | head -n 1

Note:
- `grep '[s]shd'` prevents matching the grep process itself.

---

## 🧪 LFCS Drills (Script These)

### Drill 1 — “Service Status Reporter”

Create `svc-status.sh`:

Requirements:
- Takes one or more service names
- Prints ACTIVE/INACTIVE per service
- Exit 0 if all active, else exit 1

Pseudo-implementation outline:

    #!/usr/bin/env bash
    set -euo pipefail

    if [ $# -lt 1 ]; then
      echo "usage: $0 <service>..."
      exit 2
    fi

    failed=0
    for svc in "$@"; do
      if systemctl is-active --quiet "$svc"; then
        echo "ACTIVE: $svc"
      else
        echo "INACTIVE: $svc"
        failed=1
      fi
    done

    exit "$failed"

Test:

    ./svc-status.sh ssh cron does-not-exist ; echo "rc=$?"

---

### Drill 2 — “Find Large Files Under a Path”

Create `large-files.sh`:

Requirements:
- Args: path + size threshold (MB)
- Print files larger than threshold
- Must not cross filesystem boundaries

Command surface you’ll use:

    du -x -ah <path> | sort -h | tail

Verification:
- Compare output against `find` size queries:

    find <path> -xdev -type f -size +100M -print | head

---

### Drill 3 — “Backup /etc safely”

Create `backup-etc.sh`:

Requirements:
- Creates a timestamped tarball in /tmp
- Prints the tarball path
- Exits non-zero if tar fails

Command surface:

    tar -czf "/tmp/etc-$(date +%F-%H%M%S).tgz" /etc

Verify tarball exists:

    ls -lh /tmp/etc-*.tgz | tail -n 1

---

## 🧷 Script Debugging (LFCS-friendly)

Turn on tracing:

    bash -x ./script.sh

Inside script, enable temporarily:

    set -x
    # ... code ...
    set +x

---

## 🏁 Minimal Bash Checklist (If You Can Do This, You’re Good)

- Write executable scripts with correct shebang
- Use variables and quoting correctly
- Use if / case / loops
- Use exit codes intentionally
- Validate inputs
- Combine tools with pipelines safely
- Debug with `bash -x`

---
