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

# A) Atomic Drills (Repetition)

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
### -> 0

false
echo $?
### -> 1

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


### A3 — Grouping and redirecting a command group
Goal: redirect output of a group (not only one command).

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

# B) Diagnosis Drills (Interpret + Choose)

#### D1 — “No matches” vs “broken command”
Goal: interpret grep exit codes correctly.

    printf "%s\n" alpha beta gamma > input.txt

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

#### 🧠 What it does (simple)

It writes the words alpha, beta, and gamma one per line into a file called input.txt.

After running it:

cat input.txt


You’ll see:

alpha
beta
gamma

#### 🧱 Now, the pieces and “flags”

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


#### printf "%s\n" * > input.txt
####🧱 Why it’s powerful
* is a glob.

It means:

“All files and directories in the current directory.”

So this command:

Expands * into:

text
Copy code
file1 file2 file3 dirA dirB ...
Then printf prints each name on its own line

Then > input.txt writes them into a file

So in one command, you can:

Generate a complete inventory of the current directory into a file.

That’s extremely useful for:

Feeding into scripts

Testing text-processing tools

Building file lists

Creating manifests

### ⚠️ Why it’s dangerous

#### It can include a LOT of stuff

If you run it in:

/

/etc

A big project directory

* can expand to hundreds or thousands of entries.

You may:

Create a huge file

Fill your terminal scrollback if you forget > file

Or feed massive input into the next command

#### It will include things you did not expect

* includes:

Files

Directories

Weird names

Names with spaces

Names with newlines

Names starting with - (can break other commands)

#### The redirection is destructive
bash
Copy code
> input.txt
Means:

Overwrite input.txt without asking.

If input.txt had something important in it — it’s gone.

####  Shell expansion happens before the command runs
So:

bash
Copy code
printf "%s\n" *
The shell turns it into:

bash
Copy code
printf "%s\n" file1 file2 file3 dirA ...
If there are too many, you can even hit:

“Argument list too long”

### 🧠 Operator mental model
* is a chainsaw:

Very fast, very powerful — and can remove things you didn’t intend.

🏁 One-line summary
It’s powerful because it instantly enumerates everything; it’s dangerous because it does so blindly and can overwrite files or produce massive, unexpected output.

### 📌 Tiny exam-grade detail

Unlike echo, printf:

Is consistent across shells

Does not add extra newlines unless you specify them

Is preferred in scripts

#### Pass condition: you can explain:
- `grep` returns non-zero when no matches (not necessarily “error”)


# Job control muscle memory

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


# 🔐 Local and Remote Login

- Switch to a TTY and log in
- Return to GUI (if present)
- SSH into localhost
- SSH into another host (or same host via IP)
- Show who is logged in

    w
    who
    tty
---


# 🔎  Find Files

### 🧠 Find Mental Model & rule (for LFCS)

`find <PATH> <TESTS> <ACTIONS>`

- **PATH**: where to search (e.g., `.` or `/etc`)
- **TESTS**: filters (name, size, type, owner, perms, mtime, inode)
- **ACTIONS**: what to do with matches (`-print`, `-delete`, `-exec ...`)

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
---

## 1) Find files by name

Find by exact name:

    find . -name "sshd_config"

Find by wildcard pattern:

    find . -name "*.conf"

Case-insensitive:

    find . -iname "*.conf"


## 2) Find files by size

Larger than 10 MB:

    find . -size +10M

Smaller than 10 MB:

    find . -size -10M

Between 10 MB and 100 MB:

    find . -size +10M -size -100M


## 3) Find files by type

Regular files:

    find . -type f

Directories:

    find . -type d

Symbolic links:

    find . -type l


## 4) Find files by owner

Owned by user `root`:

    find . -user root

Owned by group `adm`:

    find . -group adm

Owned by numeric UID (example `0` for root):

    find . -uid 0


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


## 7) Find and delete a file by inode (safe method)

#### Step A — list inode numbers

Show inode + name in current tree:

    find . -maxdepth 2 -printf '%i %p\n' | head

Or for a single directory:

    ls -i


#### Step B — match by inode (confirm first)

Replace `123456`:

    find . -inum 123456 -ls


#### Step C — delete by inode

Only after confirming the `-ls` output is correct:

    find . -inum 123456 -delete

Safer: prompt before delete:

    find . -inum 123456 -ok rm -i {} \;


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

# 📚 Locate Files Using Database

- Update locate database
- Find a file using locate

    sudo updatedb
    locate passwd

### 🧠 What this is about (in plain English)

This is about using a pre-built file index to find files instantly, instead of searching the disk live.

#### 🧱 The two commands

##### sudo updatedb

Rebuilds the file search database (updates the index of what files exist on the system).

##### locate passwd

Searches that database for any file whose name contains passwd.

#### 🧠 How this works conceptually

updatedb = scan disk → build index

locate = search the index (very fast)

So:

You first update the list, then you search the list.

#### 🏁 One-line summary

updatedb refreshes the file index, and locate passwd quickly finds files named like “passwd” using that index.

#### ⚠️  Important exam note (simple)

locate may show old results if you haven’t run updatedb recently.

---

# 🧩 Globbing (Wildcard Expansion)

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

## Globbing = “Pattern matching for filenames”

The shell expands patterns like * and ? into real filenames before the command runs.

### * — match anything

ls a*

 List all files that start with a.


### ? — match one character

ls a?

 List files named a plus exactly one character (like ab, a1, etc).


### [] — match one character from a set

ls a[bc]

 List files named ab or ac.

### Ranges inside []

ls a[a-c]*

 List files that start with a and whose second letter is between a and c.


### {} — generate multiple names

mkdir test-{1,2,3}

 Creates: test-1, test-2, test-3.


### Exclusions with !

ls [!a]*

 List files that do not start with a.


#### 🏁 One-line summary

Globbing lets the shell expand patterns into filenames so you can operate on many files at once.

---

# 💽 5) Filesystem Inspection

- Show disk usage
- Show filesystem types
- Identify filesystem on a block device

    df -h
    df -T
    lsblk -f
    file -sL /dev/sda1

### Filesystem Inspection = “Look at disks and filesystems”

#### df -h

df = disk free

-h = human-readable (show sizes in KB/MB/GB instead of raw numbers)

Shows how much disk space is used and free in a human-readable way (GB, MB).

“How full are my disks?”

#### df -T

df = disk free

-T = type (show the filesystem type, like ext4, xfs)

Shows what filesystem type each mounted filesystem is (ext4, xfs, etc).

“What kind of filesystem is this disk using?”

#### lsblk -f

lsblk = list block devices

-f = filesystem info (shows filesystem type, label, UUID, mountpoint)

Shows all disks and partitions, their filesystems, and where they’re mounted.

“Show me the disk layout and what’s on each partition.”

#### file -sL /dev/sda1

file = identify file type

-s = special files (read block devices, not just regular files)

-L = follow symlinks

Probes the block device and tells you what filesystem is on it.

“What exactly is stored on this partition?”

---

# 📝 6) Compare and Manipulate Text

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

## 🆕 Create files

##### touch a.txt b.txt

touch = create empty files (or update timestamps if they exist)

This creates two empty files: a.txt and b.txt.

## 🔍 Compare files

#### diff a.txt b.txt

diff = show differences between two files

It prints the lines that differ between a.txt and b.txt.

## 📁 Compare directories

#### diff -ur dir1 dir2

diff = compare

-u = unified format (readable diff output)

-r = recursive (compare subdirectories too)

This compares two directories and all their contents.

## 🔤 Sort text

#### sort file.txt

sort = sort lines alphabetically

Prints the file’s lines in sorted order.

## 🔢 Count lines

#### wc -l file.txt

wc = word count

-l = lines

Shows how many lines are in the file.

## 🔢 Show line numbers

#### nl -ba file.txt

nl = number lines

-b = number all lines

-a = include empty lines

Prints the file with line numbers on every line.

## ✂️ Cut columns

#### cut -d ':' -f 1 /etc/passwd

cut = extract columns

-d ':' = delimiter is :

-f 1 = field (column) 1

Prints only the first column of /etc/passwd.

## 🔁 Translate characters

#### tr ',' ';' < file.csv

tr = translate characters

This replaces every , with ; in the input.

## 🧹 Squeeze repeated spaces

#### tr -s ' ' < file.txt

tr = translate

-s = squeeze repeats

This turns multiple spaces into a single space.

## 🔢 Show binary/octal view

#### od -bc file.txt

od = octal dump (show file in raw bytes)

-b = octal bytes

-c = show characters

Shows the raw byte content of the file.

## 🔄 Rename files using pattern

#### rename 's/foo/bar/' *.txt

rename = batch rename files

's/foo/bar/' = substitute foo with bar

*.txt = all text files

Renames all .txt files by replacing foo with bar in their names.

### 🏁 One-line summary

These are the core Linux tools for creating, comparing, transforming, inspecting, and mass-editing text and files — all high-value LFCS commands.

---

# 🔗 7) Join, Paste, Split

- Join two files
- Paste two files side by side
- Split a file by size or lines

    join a.txt b.txt
    paste a.txt b.txt
    split -n 3 bigfile.txt

## 🔗 Join two files

#### join a.txt b.txt

join = merge two files by a common column (usually the first column)

It combines matching lines from both files into one output.

“Join two files together where their keys match.”

## 📎 Paste two files side by side

#### paste a.txt b.txt

paste = merge files horizontally (line 1 with line 1, line 2 with line 2, etc.)

It prints the files next to each other as columns.

“Put two files side by side, line by line.”

## ✂️ Split a file by size or lines

#### split -n 3 bigfile.txt

split = break a file into smaller files

-n 3 = split into 3 parts

“Cut a big file into 3 smaller pieces.”

### 🏁 One-line summary

join merges by matching keys, paste merges side-by-side, and split breaks a file into smaller parts.

---

# 🔎 8) Regex and Text Search (grep)

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

## 🔎 Regex and Text Search (grep) = “Find text in files”

### 🔍 Basic grep

grep = “Global Regular Expression Print”

Historically, it comes from the old ed editor command:

g /pattern/ p

Which meant:

“Globally search for this pattern and print the matching lines.”

So:

g = global

re = regular expression

p = print

### 🧠 Memory hook

grep = globally search with a regex and print the matches

#### grep root /etc/passwd

grep = search for text

This prints lines in /etc/passwd that contain root.

“Show me lines that contain root.”

## 🔤 Case-insensitive grep

#### grep -i root /etc/passwd

-i = ignore case

Matches root, Root, ROOT, etc.

“Find root no matter how it’s capitalized.”

## 🚫 Invert match

#### grep -v root /etc/passwd

-v = invert (show lines that do NOT match)

“Show me all lines that do NOT contain root.”

## 📂 Recursive grep

#### grep -R "root" /etc

-R = recursive (search all subdirectories)

“Search for root in all files under /etc.”

## 🔢 Show line numbers

#### grep -n root /etc/passwd

-n = line numbers

“Show me matching lines and tell me what line number they’re on.”

## 🧠 Use extended regex

#### grep -E "root|daemon" /etc/passwd

-E = extended regex

| = OR operator

“Show lines that contain root OR daemon.”

### ⚠️ Exam note (simple)

-P (Perl regex) may not exist everywhere — use -E instead.

#### 🏁 One-line summary

grep searches text; flags control case, inversion, recursion, line numbers, and regex power.

---

# 🧹 9) sed Basics

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

## 🧹 sed = “Stream Editor” (edit text as it flows)

### 📄 Print specific lines

#### sed -n '1,10p' file.txt

sed = stream editor

-n = no automatic printing

'1,10p' = print lines 1 through 10

p = print

“Show me lines 1 to 10 from the file.”

### 🗑️ Delete lines

#### sed '1,5d' file.txt

d = delete

'1,5d' = delete lines 1 through 5

“Show the file without lines 1 to 5.”

## 🔁 Substitute text (first match per line)

#### sed 's/foo/bar/' file.txt

s = substitute

foo = what to find

bar = what to replace it with

“Replace the first foo on each line with bar.”

## 🌍 Substitute globally (all matches)

#### sed 's/foo/bar/g' file.txt

g = global (all matches in the line)

“Replace all foo with bar everywhere.”

## 🧠 Use groups

#### sed -E 's/(foo)(bar)/\2\1/' file.txt

-E = extended regex

( ) = capture groups

\1, \2 = refer to captured groups

"Find foobar and swap it to barfoo.”

##### 🏁 One-line summary

sed lets you print, delete, and rewrite text as it streams past.

---

# 🧮 10) awk Basics

- Print columns
- Filter by value
- Use BEGIN and END
- Do arithmetic

    awk '{print $1}' /etc/passwd
    awk -F: '{print $1, $3}' /etc/passwd
    awk '$3 > 1000 {print $1}' /etc/passwd
    ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

## 🧮 awk = “Pattern scanning and processing language” (column processor)

awk is named after its creators:

Aho
Weinberger
Kernighan

So:

awk = Aho–Weinberger–Kernighan

### 🧠 Memory hook

awk = “the Aho–Weinberger–Kernighan text processing language”

And what it does:

A powerful column-based text processor for scanning and transforming text.


## 📄 Print columns

#### awk '{print $1}' /etc/passwd

awk = process text by columns

$1 = first column

“Print the first column.”

## 📄 Print specific columns using :

#### awk -F: '{print $1, $3}' /etc/passwd

-F: = field separator is :

$1 = first column, $3 = third column

“Using : as the separator, print column 1 and 3.”

## 🔍 Filter by value

#### awk '$3 > 1000 {print $1}' /etc/passwd

$3 > 1000 = only lines where column 3 is greater than 1000

“Show the names whose UID is greater than 1000.”

## 🧠 Use BEGIN and END

#### ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'

BEGIN = run before any lines are processed

{sum+=$6} = add column 6 to sum for each line

END = run after all lines are processed

“Add up column 6 for every line and print the total at the end.”

## ➕ Do arithmetic

#### (Already shown above)

sum+=$6 = keep a running total

“Use awk like a calculator on columns.”

### 🏁 One-line summary

awk is a column-aware text processor that can filter, calculate, and summarize data.

---

# ✅ Completion Criteria

You are **done with this file** when:

- Exit codes and chaining are automatic
- Job control is automatic (`&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill`)
- You can execute the listed command surfaces without looking anything up

---

