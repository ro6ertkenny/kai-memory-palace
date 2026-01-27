# 🧪 Essential Commands — Execution Drills (LFCS)

Mental mode: Muscle memory.  
Goal: Be able to execute every task below **without thinking**.

This file is not a tutorial.  
This is a **hands-on execution checklist + drill pack**.

If you need deeper redirection/pipeline reps, see:
- `linux/LFCS-training/execution-drills/files-and-text.md`

---

## 🧰 Drill Framework (Applies to this file)

Drill types:
- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — break intentionally; recover fast
- **D: Diagnosis** — interpret output; choose the correct fix
- **E: Composition** — 3–6 primitives chained (exam style)

Scoring:
- ✅ Correct result
- ✅ No collateral damage
- ✅ Uses a safe/clean pattern
- ⏱️ Meets time target (when timed)

Rules of engagement:
- Prefer idempotent actions when possible
- Always know `>` vs `>>`
- Know when you need sudo and when you don’t
- Verify outcomes (don’t assume)

---

## 🧪 Phase 0 — Shell Execution + Job Control (Drill Pack)

### Setup (Do once)

    mkdir -p ~/lfcs-labs/execution-drills/phase-0
    cd ~/lfcs-labs/execution-drills/phase-0

---

### A) Atomic Drills (Repetition)

#### A1 — Exit codes
Goal: read success/failure immediately.

    true
    echo $?

    false
    echo $?

Target: 10 reps, no hesitation.

### 🧠 The rule (must memorize)

In Unix/Linux:

Exit code 0 = SUCCESS
Any NON-ZERO exit code = FAILURE

✅ So:

true always returns 0 (success)

false always returns 1 (failure)

Check it:

true
echo $?
# -> 0

false
echo $?
# -> 1

### 🧱 Why Unix did it this way

Because it allows:

0 = “all good, continue”

Any other number = “something went wrong”

And different numbers can mean different kinds of errors.

#### A2 — Safe chaining with && and ||
Goal: use conditional chaining correctly.

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

##🔗 How this ties to && and ||
command && echo "success"
command || echo "failed"

Because:

&& runs if exit code = 0

|| runs if exit code ≠ 0


true → always exits 0 → success

false → always exits 1 → failure

0 = success

non-zero = failure


test -f /etc/passwd && echo "exists" || echo "missing"


### 🧠 Step 1 — test -f /etc/passwd

test is a command that:

Checks a condition and returns an exit code.

-f /etc/passwd means:

“Does a regular file exist at /etc/passwd?”

So:

If /etc/passwd exists and is a normal file → exit code = 0 (success)

If it does not exist (or is not a regular file) → exit code ≠ 0 (failure)

It prints nothing. It only sets $?.

### 🧠 Step 2 — && echo "exists"

&& means:

“Only run the next command if the previous command succeeded (exit 0).”

So:

If /etc/passwd exists → this runs:

echo "exists"

### 🧠 Step 3 — || echo "missing"

|| means:

“Only run the next command if the previous command failed (exit ≠ 0).”

So:

If test -f /etc/passwd failed → this runs:

echo "missing"

#### -f means: “Check whether the given path exists and is a regular file (not a directory or device).”

### 🧠 Whole thing in plain English

Check if /etc/passwd exists.
If it does → print exists.
If it does not → print missing.

### 🧠 What $? means

$? = “The exit code of the last command that ran.”

In your case:

test -f /etc/passwd
echo $?

Output:

0

Means:

The test -f /etc/passwd command succeeded.

### 🧪 Why this works

Because:

test returns only an exit code

&& and || react to exit codes

The shell is acting like a logic engine

### ⚠️ Subtle but important operator detail

This is evaluated as:

( test -f /etc/passwd && echo "exists" ) || echo "missing"

“If /etc/passwd exists, say so. Otherwise, say it’s missing.”

So:

If test succeeds → echo "exists" runs → that also succeeds → || echo "missing" is skipped

If test fails → the && part is skipped → whole left side fails → echo "missing" runs

### 🏁 Final one-line translation

“If /etc/passwd exists, say so. Otherwise, say it’s missing.”

##This is one of the most important rules in all of Linux and scripting.

### 🧠 Operator mental model

Every command is just:

“Do something → return success or failure”

And the shell chains them like logic blocks.

### 🎯 Why this is exam-critical

Because you will often see or need to write:

Existence checks

One-line conditionals

Safe checks before destructive actions

Example:

test -d /backup && rm -rf /backup || echo "no backup dir"

### 🧱 How it works (very simply)
test -d /backup


→ Checks: “Does a directory named /backup exist?”

If yes → success → continue with &&

If no → failure → skip to ||

&& rm -rf /backup


→ If it exists, remove it completely.

|| echo "no backup dir"


→ If it does not exist, print: no backup dir

### 🧠 One-line mental model

“Delete /backup if it exists, otherwise say it’s not there.”

#### ⚠️ Operator note (important but simple)

This is exactly the kind of one-liner used in scripts and recovery tasks, but you always must be careful with:

rm -rf

Because it deletes without asking.

It checks if /backup exists; if it does, it deletes it, otherwise it prints “no backup dir”.


### 🧠 Operator-grade mental model

mkdir -p = “Make this path exist. I don’t care if parts already exist.”

### 🎯 Why LFCS loves this

Because provisioning scripts and recovery commands must not fail if rerun.

### 🏁 Lock-in sentence

-p makes mkdir safe, repeatable, and parent-aware.



#### A3 — Grouping and redirecting a command group
Goal: redirect output of a group (not only one command).

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

### D) Diagnosis Drills (Interpret + Choose)

#### D1 — “No matches” vs “broken command”
Goal: interpret grep exit codes correctly.

    printf "%s\n" alpha beta gamma > input.txt

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

🧠 What it does (simple)

It writes the words alpha, beta, and gamma one per line into a file called input.txt.

After running it:

cat input.txt


You’ll see:

alpha
beta
gamma

### 🧱 Now, the pieces and “flags”
1️⃣ printf

printf = “Print formatted output” (like C’s printf)

It does not automatically add newlines unless you tell it to.

2️⃣ "%s\n"

This is the format string.

%s = “print a string”

\n = “print a newline”

So:

"%s\n" means: “Print each string, then move to a new line.”

3️⃣ alpha beta gamma

These are the strings being printed.

printf will apply the format to each argument:

prints alpha\n

prints beta\n

prints gamma\n

4️⃣ > input.txt

> = “Redirect output into a file (overwrite it).”

So:

Instead of printing to the screen,

The output goes into input.txt

If the file exists → it is replaced

If it doesn’t exist → it is created

### 📌 Tiny exam-grade detail

Unlike echo, printf:

Is consistent across shells

Does not add extra newlines unless you specify them

Is preferred in scripts

#### Pass condition: you can explain:
- `grep` returns non-zero when no matches (not necessarily “error”)

---

### A4 — Job control muscle memory
Goal: manage background/foreground without confusion.

Start a long job:

    sleep 3000 &

Confirm jobs list:

    jobs

Bring to foreground, suspend, then background:

    fg %1
    (press Ctrl+Z)
    bg %1

Terminate safely:

    jobs
    kill %1

Pass condition: no confusion between job spec (`%1`) vs PID.

---

## 🔐 1) Local and Remote Login

- Switch to a TTY and log in
- Return to GUI (if present)
- SSH into localhost
- SSH into another host (or same host via IP)
- Show who is logged in

    w
    who
    tty

---

## 🔎 2) Find Files

- Find files by name
- Find files by size
- Find files by type
- Find files by owner
- Find files by permissions
- Find files modified in last N days
- Find and delete a file by inode
- Find files and run a command on them

    find . -name "*.conf"
    find . -size +10M
    find . -type f
    find . -user root
    find . -perm 777
    find . -mtime -7
    ls -i
    find . -inum 123456 -delete
    find . -type f -exec ls -lh {} +

## 🔎 `find` — File Discovery Drills (LFCS)

Goal: Find files fast by **name, size, type, owner, permissions, time**, and safely **act on results**.

---

## 🧠 0) Mental Model

`find <PATH> <TESTS> <ACTIONS>`

- **PATH**: where to search (e.g., `.` or `/etc`)
- **TESTS**: filters (name, size, type, owner, perms, mtime, inode)
- **ACTIONS**: what to do with matches (`-print`, `-delete`, `-exec ...`)

---

## 1) Find files by name

Find by exact name:

    find . -name "sshd_config"

Find by wildcard pattern:

    find . -name "*.conf"

Case-insensitive:

    find . -iname "*.conf"

---

## 2) Find files by size

Larger than 10 MB:

    find . -size +10M

Smaller than 10 MB:

    find . -size -10M

Between 10 MB and 100 MB:

    find . -size +10M -size -100M

### 🧠 Mental rule (for LFCS)

find always needs:
where to look first, then what to match

So think:

find WHERE WHAT

Examples:

find . -type f
find /var -size +1G
find /home -user bob

⚠️ One more important detail

You can technically omit the path and GNU find will assume .:

find -name "*.conf"


But for the exam and for clarity:

Always write the path explicitly (. or /etc or /var).

---

## 3) Find files by type

Regular files:

    find . -type f

Directories:

    find . -type d

Symbolic links:

    find . -type l

---

## 4) Find files by owner

Owned by user `root`:

    find . -user root

Owned by group `adm`:

    find . -group adm

Owned by numeric UID (example `0` for root):

    find . -uid 0

---

## 5) Find files by permissions

Exact mode 777 (be careful, this is usually bad):

    find . -perm 777

At least these bits set (e.g., any file writable by group):

    find . -perm -020

Any of these bits set (e.g., writable by group OR others):

    find . -perm /022

Common LFCS checks:
- world-writable files:

    find / -type f -perm /002 2>/dev/null

- SUID binaries:

    find / -type f -perm -4000 2>/dev/null

- SGID binaries:

    find / -type f -perm -2000 2>/dev/null

---

## 6) Find files modified in last N days

Modified in last 7 days:

    find . -mtime -7

Modified more than 7 days ago:

    find . -mtime +7

Modified exactly 7 days ago (roughly):

    find . -mtime 7

Note:
- `-mtime` is in **24-hour chunks**.
- Use `-mmin` for minutes.

Modified in last 60 minutes:

    find . -mmin -60

---

## 7) Find and delete a file by inode (safe method)

### Step A — list inode numbers

Show inode + name in current tree:

    find . -maxdepth 2 -printf '%i %p\n' | head

Or for a single directory:

    ls -i

### Step B — match by inode (confirm first)

Replace `123456`:

    find . -inum 123456 -ls

### Step C — delete by inode

Only after confirming the `-ls` output is correct:

    find . -inum 123456 -delete

Safer: prompt before delete:

    find . -inum 123456 -ok rm -i {} \;

---

## 8) Find files and run a command on them

List files with sizes (fast batching):

    find . -type f -exec ls -lh {} +

Run a command per-file (slower but simple):

    find . -type f -exec ls -lh {} \;

Use `-ok` to confirm each execution:

    find . -type f -ok ls -lh {} \;

Example: search `.conf` and show first 5 lines:

    find . -name "*.conf" -type f -exec sh -c 'echo "=== {} ==="; head -n 5 "{}"' \;

---

## ✅ Your exact commands, corrected as a clean set

    find . -name "*.conf"
    find . -size +10M
    find . -type f
    find . -user root
    find . -perm 777
    find . -mtime -7
    ls -i
    find . -inum 123456 -delete
    find . -type f -exec ls -lh {} +

find . -type f
find /var -size +1G
find /home -user bob

---

## 📚 3) Locate Files Using Database

- Update locate database
- Find a file using locate

    sudo updatedb
    locate passwd

---

## 🧩 4) Globbing (Wildcard Expansion)

- Use *
- Use ?
- Use []
- Use ranges
- Use {}
- Use exclusions

    ls a*
    ls a?
    ls a[bc]
    ls a[a-c]*
    mkdir test-{1,2,3}
    ls [!a]*

---

## 💽 5) Filesystem Inspection

- Show disk usage
- Show filesystem types
- Identify filesystem on a block device

    df -h
    df -T
    lsblk -f
    file -sL /dev/sda1

---

## 📝 6) Compare and Manipulate Text

- Create files
- Compare files
- Compare directories
- Sort text
- Count lines
- Show line numbers
- Cut columns
- Translate characters
- Squeeze repeated spaces
- Show binary/octal view
- Rename files using pattern

    touch a.txt b.txt
    diff a.txt b.txt
    diff -ur dir1 dir2
    sort file.txt
    wc -l file.txt
    nl -ba file.txt
    cut -d ':' -f 1 /etc/passwd
    tr ',' ';' < file.csv
    tr -s ' ' < file.txt
    od -bc file.txt
    rename 's/foo/bar/' *.txt

---

## 🔗 7) Join, Paste, Split

- Join two files
- Paste two files side by side
- Split a file by size or lines

    join a.txt b.txt
    paste a.txt b.txt
    split -n 3 bigfile.txt

---

## 🔎 8) Regex and Text Search (grep)

- Basic grep
- Case insensitive grep
- Invert match
- Recursive grep
- Show line numbers
- Use extended regex

    grep root /etc/passwd
    grep -i root /etc/passwd
    grep -v root /etc/passwd
    grep -R "root" /etc
    grep -n root /etc/passwd
    grep -E "root|daemon" /etc/passwd

Note: Perl regex (`grep -P`) may not be available everywhere. Prefer `-E`.

---

## 🧹 9) sed Basics

- Print specific lines
- Delete lines
- Substitute text
- Substitute globally
- Use groups

    sed -n '1,10p' file.txt
    sed '1,5d' file.txt
    sed 's/foo/bar/' file.txt
    sed 's/foo/bar/g' file.txt
    sed -E 's/(foo)(bar)/\2\1/' file.txt

---

## 🧮 10) awk Basics

- Print columns
- Filter by value
- Use BEGIN and END
- Do arithmetic

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

---

## ✅ Completion Criteria

You are **done with this file** when:

- Exit codes and chaining are automatic
- Job control is automatic (`&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill`)
- You can execute the listed command surfaces without looking anything up

---

