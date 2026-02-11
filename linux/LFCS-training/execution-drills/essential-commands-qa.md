# 🧪 Essential Commands — Execution Drills (LFCS)

## 🎯 Goal
Be able to execute every task below without thinking and build muscle memory

This is a hands-on execution checklist + drill pack

---

## 🧰 Drill Framework (Applies to this file)

## Drill types

**A: Atomic** — one skill, repeat until automatic  
**B: Timed** — same skill under time pressure  
**C: Failure Injection** — break intentionally; recover fast  
**D: Diagnosis** — interpret output; choose the correct fix  
**E: Composition** — 3–6 primitives chained (exam style)

---

## Scoring

✅ Correct result  
✅ No collateral damage  
✅ Uses a safe/clean pattern  
⏱️ Meets time target (when timed)

---

## Rules of engagement

Prefer repeatable, non-destructive actions when possible  
Always know > vs >>  
Know when you need sudo and when you don’t  
Verify outcomes (don’t assume)

---

# 📚 Execution Surfaces

Drills below are organized strictly by operator surface:

1. Shell  
2. Filesystem  
3. Text  
4. Search  
5. Streams

## Shell

### Task: Create a safe, isolated workspace for command practice without risking system files

Create a repeatable practice directory in your home folder that can safely contain destructive command testing

<details>
<summary>Answer</summary>

# 🧱 Foundations — Shell Execution & Job Control  
Essential Commands — Practice Workspace  

Purpose:  
Create a safe, isolated directory for practicing LFCS essential commands (find, rm, redirection, job control, text tools) without risking system files  

Setup (do once):

 mkdir -p ~/essential-commands-practice  
 cd ~/essential-commands-practice  

</details>

---

### Task: Prove that exit code 0 indicates success and non-zero indicates failure

Execute minimal commands that demonstrate how Linux communicates success and failure through exit codes. Verify your understanding using `$?`

<details>
<summary>Answer</summary>

Atomic Drills (Repetition)  

Exit codes  
Goal: read success/failure immediately  

 true  
 echo $?  

 false  
 echo $?  

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

 -> 0  

 false  
 echo $?  

 -> 1  

### 🧱 Why Unix did it this way  

Because it allows:  

 0 = “all good, continue”  

Any other number = “something went wrong”  

And different numbers can mean different kinds of errors  

</details>

---

### Task: Use conditional chaining (&& and ||) to safely execute commands based on success or failure

Write and execute one-line commands that:
- Print confirmation only if a command succeeds
- Print an alternate message if a command fails
- Safely check for file or directory existence before performing destructive actions

Demonstrate correct understanding of exit-code-driven logic flow

<details>
<summary>Answer</summary>

Safe chaining with && and ||  
Goal: use conditional chaining correctly  

 mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"  
 test -f /etc/passwd && echo "exists" || echo "missing"  
 test -f /nope && echo "exists" || echo "missing"  

🔗 How this ties to && and ||  

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

#### 🧠 Step 1 — test -f /etc/passwd  

test is a command that:  

Checks a condition and returns an exit code  

 -f /etc/passwd means:  

“Does a regular file exist at /etc/passwd?”  

So:  

If /etc/passwd exists and is a normal file → exit code = 0 (success)  

If it does not exist (or is not a regular file) → exit code ≠ 0 (failure)  

It prints nothing. It only sets $?  

#### 🧠 Step 2 — && echo "exists"  

 && means:  

“Only run the next command if the previous command succeeded (exit 0)”  

So:  

If /etc/passwd exists → this runs:  

echo "exists"  

#### 🧠 Step 3 — || echo "missing"  

 || means:  

“Only run the next command if the previous command failed (exit ≠ 0)”  

So:  

If test -f /etc/passwd failed → this runs:  

 echo "missing"  

 -f means: “Check whether the given path exists and is a regular file (not a directory or device)”  

#### 🧠 Whole thing in plain English  

Check if /etc/passwd exists  
If it does → print exists  
If it does not → print missing  

#### 🧠 What $? means  

 $? = “The exit code of the last command that ran”  

In your case:  

 test -f /etc/passwd  
 echo $?  

Output:  

 0  

Means:  

The test -f /etc/passwd command succeeded  

#### 🧪 Why this works  

Because:  

test returns only an exit code  

&& and || react to exit codes  

The shell is acting like a logic engine  

#### ⚠️ Subtle but important operator detail  

This is evaluated as:  

 ( test -f /etc/passwd && echo "exists" ) || echo "missing"  

“If /etc/passwd exists, say so. Otherwise, say it’s missing”  

So:  

If test succeeds → echo "exists" runs → that also succeeds → || echo "missing" is skipped  

If test fails → the && part is skipped → whole left side fails → echo "missing" runs  

#### 🏁 Final one-line translation  

“If /etc/passwd exists, say so. Otherwise, say it’s missing”  

This is one of the most important rules in all of Linux and scripting  

#### 🧠 Operator mental model  

Every command is just:  

“Do something → return success or failure”  

And the shell chains them like logic blocks  

#### 🎯 Why this is exam-critical  

Because you will often see or need to write:  

Existence checks  

One-line conditionals  

Safe checks before destructive actions  

Example:  

test -d /backup && rm -rf /backup || echo "no backup dir"  

#### 🧱 How it works (very simply)  

test -d /backup  
→ Checks: “Does a directory named /backup exist?”  

If yes → success → continue with &&  

If no → failure → skip to ||  

 && rm -rf /backup  

→ If it exists, remove it completely  

 || echo "no backup dir"  

→ If it does not exist, print: no backup dir  

 rm -rf /backup  

 rm = remove (delete files/directories)  

 -r = recursive (delete everything inside, including subdirectories)  

 -f = force (do not ask, do not warn)  

#### 🧠 One-line mental model  

“Delete /backup if it exists, otherwise say it’s not there”  

#### ⚠️ Operator not (important but simple) 

This is exactly the kind of one-liner used in scripts and recovery tasks, but you always must be careful with:  

 rm -rf  

Because it deletes without asking  

It checks if /backup exists; if it does, it deletes it, otherwise it prints “no backup dir”  

#### 🧠 Operator-grade mental model  

 mkdir -p = “Make this path exist. I don’t care if parts already exist”  

 mkdir = make directory  

 -p = parents (create parent directories if needed and do not fail if it already exists)  

#### 🎯 Why is this important?  

Because provisioning scripts and recovery commands must not fail if rerun  

#### 🏁 Lock-in sentence  

 -p makes mkdir safe, repeatable, and parent-aware  

</details>

---

### Task: Redirect the output of multiple commands as a single unit into a file

Execute multiple commands as one grouped block and redirect their combined output into a file. Verify that the file contains all expected output

Repeat until grouping and redirection syntax are automatic

<details>
<summary>Answer</summary>

Grouping and redirecting a command group  
Goal: redirect output of a group (not only one command)  

 { date; uptime; echo "OK"; } > report.txt  
 cat report.txt  

Target: 10 reps  

</details>

---

### Task: Diagnose grep exit codes — distinguish “no matches” from command failure

Create a test file and use grep to demonstrate:

- grep returning non-zero when no matches are found
- grep returning zero when matches are found
- correct interpretation of `$?`
- correct understanding of redirection overwrite behavior
- safe reasoning about glob expansion (`*`)

Be able to explain why “no match” is not necessarily an error

<details>
<summary>Answer</summary>

Diagnosis Drills (Interpret + Choose)  

 D1 — “No matches” vs “broken command”  
Goal: interpret grep exit codes correctly  

 printf "%s\n" alpha beta gamma > input.txt  

 cat input.txt | grep zzz  
 echo $?  

 cat input.txt | grep beta  
 echo $?  

#### 🧠 What it does (simple)  

It writes the words alpha, beta, and gamma one per line into a file called input.txt  

After running it:  

 cat input.txt  

You’ll see:  

 alpha  
 beta  
 gamma  

#### 🧱 Now, the pieces and “flags”  

 1️⃣ printf  

 printf = “Print formatted output” (like C’s printf)  

It does not automatically add newlines unless you tell it to  

 2️⃣ "%s\n"  

This is the format string  

 %s = “print a string”  

 \n = “print a newline”  

So:  

 "%s\n" means: “Print each string, then move to a new line”  

 " " = quotes (treat everything inside as one literal string)  

 %s = string placeholder (print a string value)  

 \n = newline (move to the next line)  

“Print a string, then start a new line”  

 3️⃣ alpha beta gamma  

These are the strings being printed  

 printf will apply the format to each argument:  

 prints alpha\n  

 prints beta\n  

 prints gamma\n  

 4️⃣ > input.txt  

 = “Redirect output into a file (overwrite it)”  

So:  

Instead of printing to the screen,  

The output goes into input.txt  

If the file exists → it is replaced  

If it doesn’t exist → it is created  

 printf "%s\n" * > input.txt  

#### 🧱 Why it’s powerful  

 * is a glob.  
It means:  

“All files and directories in the current directory”  

So this command:  

Expands * into:  

 file1  
 file2  
 file3  
 dirA  
 dirB  
 ...  

Then printf prints each name on its own line  

Then > input.txt writes them into a file  

So in one command, you can:  

Generate a complete inventory of the current directory into a file  

That’s extremely useful for:  

Feeding into scripts  

Testing text-processing tools  

Building file lists  

Creating manifests  

#### ⚠️ Why it’s dangerous  

It can include a LOT of stuff  

If you run it in:  

 /  

 /etc  

A big project directory  

 * can expand to hundreds or thousands of entries  

You may:  

Create a huge file  

Fill your terminal scrollback if you forget > file  

Or feed massive input into the next command  

It will include things you did not expect  

 * includes:  

Files  

Directories  

Weird names  

Names with spaces  

Names with newlines  

Names starting with - (can break other commands)  

The redirection is destructive  

 > input.txt  

Means:  

Overwrite input.txt without asking  

If input.txt had something important in it — it’s gone  

Shell expansion happens before the command runs  

So:  

 printf "%s\n" *  

The shell turns it into:  

 printf "%s\n" file1 file2 file3 dirA ...  

If there are too many, you can even hit:  

“Argument list too long”  

#### 🧠 Operator mental model  

 * is a chainsaw:  

Very fast, very powerful — and can remove things you didn’t intend  

#### 🏁 One-line summary  

It’s powerful because it instantly enumerates everything; it’s dangerous because it does so blindly and can overwrite files or produce massive, unexpected output  

#### 📌 Tiny exam-grade detail  

Unlike echo, printf:  

Is consistent across shells  

Does not add extra newlines unless you specify them  

Is preferred in scripts  

Pass condition: you can explain:  

 grep returns non-zero when no matches (not necessarily “error”)  

</details>

---

### Task: Control foreground and background jobs without confusing job IDs and PIDs

Start a long-running process in the background

List active jobs

Bring the job to the foreground, suspend it, resume it in the background, and then terminate it safely

Demonstrate clear understanding of job specifiers (e.g., %1) versus process IDs (PID)

<details>
<summary>Answer</summary>

# Job control muscle memory  

Goal: manage background/foreground without confusion  

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

Pass condition: no confusion between job spec (%1) vs PID  

</details>

## Search

### Task: Explain and apply the core find mental model (WHERE + WHAT)

Write valid find commands that correctly follow the structure:

 find <PATH> <TESTS> <ACTIONS>

Demonstrate understanding of:
- explicit search paths
- test filters
- why path should be written explicitly on exams

<details>
<summary>Answer</summary>

# 🔐 Local and Remote Login  

### 🔎 Find Files  

#### 🧠 Find Mental Model & rule (for LFCS)  

 find <PATH> <TESTS> <ACTIONS>  

PATH: where to search (e.g., . or /etc)  
TESTS: filters (name, size, type, owner, perms, mtime, inode)  
ACTIONS: what to do with matches (-print, -delete, -exec ...)  

 find always needs: where to look first, then what to match  

So think:  

 find WHERE WHAT  

Examples:  

 find . -type f  
 find = search for files  

 . = current directory  

 -type f = type = file (only show regular files)  

“Find all regular files in the current directory tree”  

 find /var -size +1G  
 /var = where to search  
 -size +1G = bigger than 1 gigabyte  
“Find files in /var that are larger than 1 GB”  

 find /home -user bob  
 /home = where to search  
 -user bob = owned by user bob  
“Find files in /home that are owned by user bob”  

#### ⚠️ One more important detail  

You can technically omit the path and GNU find will assume :  

 find -name "*.conf"  

But for the exam and for clarity:  

Always write the path explicitly (. or /etc or /var)  

</details>

---

### Task: Find files by name (exact, wildcard, case-insensitive)

Write commands to locate files by:
- exact filename
- wildcard pattern
- case-insensitive pattern

<details>
<summary>Answer</summary>

1) Find files by name  

Find by exact name:  

 find . -name "sshd_config"  

Find by wildcard pattern:  

 find . -name "*.conf"  

Case-insensitive:  

 find . -iname "*.conf"  

</details>

---

### Task: Find files by size using + and - operators

Write commands that locate files:
- larger than 10MB
- smaller than 10MB
- within a size range

<details>
<summary>Answer</summary>

2) Find files by size  

Larger than 10 MB:  

 find . -size +10M  

Smaller than 10 MB:  

 find . -size -10M  

Between 10 MB and 100 MB:  

 find . -size +10M -size -100M  

</details>

---

### Task: Find files by type (regular, directory, symlink)

<details>
<summary>Answer</summary>

3) Find files by type  

Regular files:  

 find . -type f  

Directories:  

 find . -type d  

Symbolic links:  

 find . -type l  

</details>

---

### Task: Find files by ownership (user, group, UID)

<details>
<summary>Answer</summary>

4) Find files by owner  

Owned by user root:  

 find . -user root  

Owned by group adm:  

 find . -group adm  

Owned by numeric UID (example 0 for root):  

 find . -uid 0  

</details>

---

### Task: Find files by permission bits (exact, must-include, any-match)

Write commands that locate files based on:
- exact permission match
- required bits set
- any bits set
- world-writable files
- SUID binaries
- SGID binaries
- suppressing permission-denied errors safely

<details>
<summary>Answer</summary>

5) Find files by permissions  

Exact mode 777 (be careful, this is usually bad):  

 find . -perm 777  

At least these bits set (e.g., any file writable by group):  

 find . -perm -020  

Any of these bits set (e.g., writable by group OR others):  

 find . -perm /022  

 find . -perm 777  
 find = search for files  

 . = current directory  

 -perm 777 = exact permissions 777  

“Find files whose permissions are exactly 777”  

 find . -perm -020  
 -perm -020 = at least these bits set (- means must include)  

 020 = group write bit  

“Find files that are writable by the group.”  

 find . -perm /022  
 -perm /022 = any of these bits set (/ means any match)  

 022 = group write OR others write  

“Find files that are writable by group or others”  

🧠 Tiny memory hook  

 -perm MODE = exact match  

 -perm -MODE = must include these bits  

 -perm /MODE = any of these bits  

Common LFCS checks:  

world-writable files:  

 find / -type f -perm /002 2>/dev/null  

 find = search for files  

 / = start at root (entire system)  

 -type f = regular files only  

 -perm /002 = any file with the “others write” bit set (/ = any match, 002 = others-write bit)  

 2>/dev/null = hide error messages  

“Find files anywhere on the system that anyone can write to”  

SUID binaries:  

 find / -type f -perm -4000 2>/dev/null  

 -perm -4000 = SUID bit is set (- = must include, 4000 = SUID bit)  

 2>/dev/null = hide error messages  

“Find all files that run with the owner’s privileges (SUID)”  

SGID binaries:  

 find / -type f -perm -2000 2>/dev/null  

 -perm -2000 = SGID bit is set (- = must include, 2000 = SGID bit)  

 2>/dev/null = hide error messages  

“Find all files that run with the group’s privileges (SGID)”  

What this means in the command:  

 2>/dev/null  

 2 = error output (stderr)  

 = redirect  

 /dev/null = the black hole (throw it away)  

#### 🧠 What it means in plain English  

“Send all error messages to nowhere”  

Normal output still shows on screen  

Error messages are hidden  

#### 🧱 Why the number 2?  

In Linux:  

 0 = standard input (stdin)  

 1 = standard output (stdout)  

 2 = standard error (stderr)  

 2> /dev/null  

Means:“Redirect error output into /dev/null”  

#### 🕳️ What is /dev/null?  

 /dev/null = a special file that throws away anything written to it  

People call it: “The black hole”  

#### 🧪 Example  

 find / -type f  

Will show:  

Real results ... plus tons of permission denied errors  

But:  

 find / -type f 2>/dev/null  

Shows:  

Only the real results  

No error spam  

#### 🏁 Simp  

 2>/dev/null = “Hide error messages”  

#### 🧠 Slightly deeper (still simple)  

You are not fixing the errors — you are just silencing them  

#### 🎯 Exam-grade mental model  

Use 2>/dev/null when scanning the system and you don’t care about permission errors cluttering the output  

#### 🧠 Tiny memory hook  

 002 = others can write (world-writable)  

 4000 = SUID  

 2000 = SGID  

 /MODE = any of these bits  

 -MODE = must include these bits  

#### 🏁 One-line summary  

These commands scan the system for dangerous permissions and privilege-elevated binaries — exactly the kind of thing LFCS expects you to recognize and check  

</details>

---

### Task: Find files modified within and outside a given time window using -mtime and -mmin

Write find commands that locate files based on modification time:

- modified in the last N days
- modified more than N days ago
- modified roughly exactly N days ago
- modified in the last N minutes

Demonstrate understanding that -mtime is in 24-hour chunks and -mmin is minute-based

<details>
<summary>Answer</summary>

6) Find files modified in last N days  
Modified in last 7 days:  

 find . -mtime -7  

Modified more than 7 days ago:  

 find . -mtime +7  

Modified exactly 7 days ago (roughly):  

 find . -mtime 7  

Note:  

 -mtime is in 24-hour chunks  
Use -mmin for minutes  

Modified in last 60 minutes:  

 find . -mmin -60  

</details>

---

### Task: Locate a specific file by inode and delete it safely (confirm-first workflow)

Demonstrate a safe inode-based deletion workflow:

- list inode numbers and paths
- confirm the match by inode using a non-destructive action first
- delete only after confirmation
- optionally require interactive confirmation per match

<details>
<summary>Answer</summary>

7) Find and delete a file by inode (safe method)  

Step A — list inode numbers  

Show inode + name in current tree:  

 find . -maxdepth 2 -printf '%i %p\n' | head  

Or for a single directory:  

 ls -i  

 find . -maxdepth 2 -printf '%i %p\n' | head  

find = search  

 . = start in the current directory  

 -maxdepth 2 = only go 2 levels deep  

 -printf = print in a custom format  

 '%i %p\n':  

 %i = inode number  

 %p = path (filename)  

 \n = new line  

 | = pipe (send output to next command)  

 head = show only the first 10 lines  
 top of file ... default is 10 lines unless you do this:  

 head -n 5 file.txt  

 head = top of file ... default is 10 lines unless you do this:  
 -n = number of lines  

This command prints the inode number and name of every file and directory under your current directory (up to 2 levels deep), then shows only the first 10 results  

Step B — match by inode (confirm first)  

Replace 123456:  

 find . -inum 123456 -ls  

Step C — delete by inode  

Only after confirming the -ls output is correct:  

 find . -inum 123456 -delete  

Safer: prompt before delete:  

 find . -inum 123456 -ok rm -i {} \;  

</details>

---

### Task: Use find with -exec and -ok to run commands on matched files (batched vs one-by-one)

Write find commands that:

- execute another command on each found file
- batch execution efficiently where possible
- run one-by-one where necessary
- require confirmation before executing
- combine find + exec + shell fragments to inspect files (example: show first 5 lines)

Demonstrate understanding of `{}`, `+`, `;`, and `-ok`

<details>
<summary>Answer</summary>

8) Use find to locate files, then run another command on each result:  

List files with sizes (fast batching):  

 find . -type f -exec ls -lh {} +  

Run a command per-file (slower but simple):  

 find . -type f -exec ls -lh {} \;  

Use -ok to confirm each execution:  

 find . -type f -ok ls -lh {} \;  

Example: search .conf and show first 5 lines:  

 find . -name "*.conf" -type f -exec sh -c 'echo "=== {} ==="; head -n 5 "{}"' \;  

Fast batching (run on many files at once)  
“Find all files and list them with sizes efficiently”  

 find . -type f -exec ls -lh {} +  
 find = search  

 . = current directory  

 -type f = regular files  

 -exec = execute a command on results  

 ls = list files  

 -l = long format  

 -h = human-readable sizes  

 {} = placeholder for found files  

 = pass many files at once (batch mode)  
“Run ls -lh on many files at once (faster)”  

One-by-one (slower, but simple)  
“Find all files and run ls -lh on each file one at a time”  

 find . -type f -exec ls -lh {} ;  
 ; = end of the -exec command (run once per file)  

“Run ls -lh separately for each file (slower)  

Confirm before each run  
“Find all files and ask me before running ls -lh on each one”  

 find . -type f -ok ls -lh {} ;  
 -ok = like -exec but ask before each run  

“Ask me before running ls -lh on each file  

Real example: show first 5 lines of each .conf file  
“Find all .conf files and show the first 5 lines of each one”  

 find . -name "*.conf" -type f -exec sh -c 'echo "=== {} ==="; head -n 5 "{}"' ;  
("=== {} ===") is just decorative text and placeholder for the filename (replaced by find) )  

 -name "*.conf" = only files ending in .conf  

 sh -c = run a shell command string  

 echo = print a header  

 head = show beginning of file  

 -n 5 = first 5 lines  

 {} = current filename  

#### 🧠 Tiny memory hook  

 -exec ... {} + = fast, batched  

 -exec ... {} ; = slow, one-by-one  

 -ok = ask before running  

#### 🏁 One-line summary  

 find -exec lets you search for files and run commands on them automatically — exactly what real admins do every day  

The +, the ;, and -ok are three different ways to tell find how and when to run the command on the files it finds  

</details>

---

### Task: Use locate with an updated database to find files instantly

Rebuild the system file index and use it to search for files by name

Demonstrate understanding of:

- when to run updatedb
- how locate differs from find
- why locate results may be outdated

<details>
<summary>Answer</summary>

# 📚 Locate Files Using Database  

Update locate database  
Find a file using locate  

 sudo updatedb  
 locate passwd  

#### 🧠 What this is about (in plain English)  

This is about using a pre-built file index to find files instantly, instead of searching the disk live  

#### 🧱 The two commands  

 sudo updatedb  

Rebuilds the file search database (updates the index of what files exist on the system)  

 locate passwd  

Searches that database for any file whose name contains passwd  

#### 🧠 How this works conceptually  

 updatedb = scan disk → build index  

 locate = search the index (very fast)  

So: you first update the list, then you search the list  

#### 🏁 One-line summary  

updatedb refreshes the file index, and locate passwd quickly finds files named like “passwd” using that index  

#### ⚠️ Important exam note (simple)  

 locate may show old results if you haven’t run updatedb recently  

</details>

---

### Task: Use shell globbing patterns to match and expand filenames correctly

Demonstrate correct use of shell wildcard expansion:

- match any characters
- match exactly one character
- match from a character set
- use character ranges
- generate multiple names
- exclude patterns

Explain how globbing happens before command execution

<details>
<summary>Answer</summary>


# 🧩 Globbing (Wildcard Expansion)  

Globbing = “Pattern matching for filenames”  

The shell expands patterns like * and ? into real filenames before the command runs  

 * — match anything  

 ls a*  

List all files that start with a  

 ? — match one character  

 ls a?  

List files named a plus exactly one character (like ab, a1, etc)  

 [] — match one character from a set  

 ls a[bc]  

List files named ab or ac  

Ranges inside []  

 ls a[a-c]*  

List files that start with a and whose second letter is between a and c  

 [a-c] = the next character must be a, b, or c  

 * = zero or more characters after that  

WITH * it matches:  

 aa  
 ab  
 ac  
 abc  
 abfile  
 ac_config  
 ab123  

So the * allows longer filenames, not just two letters  

WITHOUT * ... it matches only:  

 aa  
 ab  
 ac  

 {} — generate multiple names  

 mkdir test-{1,2,3}  

Creates: test-1, test-2, test-3  

Exclusions with !  

 ls [!a]*  

List files that do not start with a  

#### 🏁 One-line summary  

Globbing lets the shell expand patterns into filenames so you can operate on many files at once  

</details>

## Filesystem

---

### Task: Inspect disk usage, filesystem types, and block devices

Use system tools to:

- determine how full mounted filesystems are
- identify filesystem types in use
- view block devices and partition layout
- probe a block device to determine what filesystem it contains
- explain the purpose of -s and -L when inspecting special files

Be able to answer:
- “How full are my disks?”
- “What kind of filesystem is this disk using?”
- “What exactly is stored on this partition?”

<details>
<summary>Answer</summary>

💽 5) Filesystem Inspection  

Filesystem Inspection = “Look at disks and filesystems”  

 df -h  

 df = disk free  

 -h = human-readable (show sizes in KB/MB/GB instead of raw numbers)  

Shows how much disk space is used and free in a human-readable way (GB, MB)  

“How full are my disks?”  

 df -T  

 df = disk free  

 -T = type (show the filesystem type, like ext4, xfs)  

Shows what filesystem type each mounted filesystem is (ext4, xfs, etc)  

“What kind of filesystem is this disk using?”  

 lsblk -f  

 lsblk = list block devices  

 -f = filesystem info (shows filesystem type, label, UUID, mountpoint)  

Shows all disks and partitions, their filesystems, and where they’re mounted  

“Show me the disk layout and what’s on each partition”  

 file -sL /dev/sda1  

Probes the block device and tells you what filesystem is on it  

“What exactly is stored on this partition?”  

 file = identify file type  

 -s = special files (read block devices, not just regular files)  

 -L = follow symlinks  

 L = links  

 -L = follow symbolic links  

“If the file is a link, follow it to what it points to”  

So instead of inspecting the link itself, the command inspects the real target  

A symlink (symbolic link) is a shortcut that points to another file or directory  

It does not store the data — it just points somewhere else  

 -L tells the command: “Don’t stop at the shortcut — go to the real thing"  

What a “special file” is  

A special file is not a normal data file — it represents a device or system interface  

They usually live in /dev  

Examples of special files  

 /dev/sda Represents a disk  

 /dev/sda1 Represents a disk partition  

 /dev/null The black hole (throws data away)  

 /dev/tty Represents your terminal  

Why -s and -L are often used together  

Example:  

 file -sL /dev/sda1  

“Read the real device behind the link and tell me what filesystem it has”  

</details>

---

### Task: Sort text files alphabetically

Sort the contents of a file and display the results in alphabetical order

<details>
<summary>Answer</summary>

 🔤 Sort text  

 sort file.txt  

 sort = sort lines alphabetically  

Prints the file’s lines in sorted order  

</details>

---

### Task: Count the number of lines in a file

Display how many lines exist in a file using a standard counting utility

<details>
<summary>Answer</summary>

 🔢 Count lines  

 wc -l file.txt  

 wc = word count  

 -l = lines  

Shows how many lines are in the file  

</details>

---

### Task: Display line numbers for all lines, including empty ones

Show a file with line numbers on every line, including blank lines

<details>
<summary>Answer</summary>

 🔢 Show line numbers  

 nl -ba file.txt  

 nl = number lines  

 -b = number all lines  

 -a = include empty lines  

Prints the file with line numbers on every line  

</details>

---

### Task: Extract a specific column from colon-delimited data

Extract only the first field from a colon-delimited file such as /etc/passwd

<details>
<summary>Answer</summary>

####  ✂️ Cut columns  

 cut -d ':' -f 1 /etc/passwd  

What each part means:  

 cut = extract columns from each line  

 -d ':' = delimiter is : (this tells cut how columns are separated)  

 -f 1 = field (column) number 1  

 /etc/passwd = the file to read  

 cut splits each line at every : and prints only the first piece  

In /etc/passwd, fields look like this:  

 username:password:UID:GID:comment:home:shell  

So -f 1 prints just:  

username  

One-line summary  

“Split each line on : and print the first column only”  

Prints only the first column of /etc/passwd  

</details>

---

### Task: Translate characters in a text stream

Replace one character with another across an input stream without modifying the original file

<details>
<summary>Answer</summary>

 🔁 Translate characters  

 tr ',' ';' < file.csv  

 tr = translate characters (swap one character for another)  

 ',' = character to replace  

 ';' = replacement character  

When you see ,, replace that exact character with ;  

Leave all other characters alone  

 < file.csv = take input from file.csv (stdin)  

 tr reads the input character by character and replaces every , it sees with ;  

Important detail:  

It does not understand columns or fields  

It does not care about CSV structure  

It simply swaps characters everywhere  

EXAMPLE:  

Input (file.csv)  
 a,b,c  
 1,2,3  

Command  

 tr ',' ';' < file.csv  

Output  

 a;b;c  
 1;2;3  

Every , becomes ;  

What it does not do (important):  

❌ It does not modify the file on disk  

❌ It does not understand quoted CSV fields  

It only prints the transformed result to the screen  

(To save it, you’d redirect output)  

One-line summary  

“Replace every comma with a semicolon in the input text”  

##### Tiny memory hook  

 cut = columns  

 tr = characters  

</details>

---

### Task: Squeeze repeated characters in a text stream

Remove consecutive duplicate spaces from a file’s output

<details>
<summary>Answer</summary>

#### 🧹 Squeeze repeated spaces  

 tr -s ' ' < file.txt  

 tr = translate  

 -s = squeeze repeats  

This turns multiple spaces into a single space  

EXAMPLE:  

Input (file.txt)  
this    has    too    many    spaces  

Command  

 tr -s ' ' < file.txt  

Output  

this has too many spaces  

Multiple spaces get squeezed into one space  

</details>

---

### Task: Inspect raw byte representation of a file

Display the raw byte-level representation of a file to diagnose hidden or non-printable characters

<details>
<summary>Answer</summary>

 🔢 Show binary/octal view  

 od -bc file.txt  

 od = octal dump (show file in raw bytes)  

 -b = octal bytes  

 -c = show characters  

Shows the raw byte content of the file ... raw bytes are the actual numeric values the computer stores for each character, before they’re interpreted as letters or symbols ... text is just numbers underneath — od lets you see them  

EXAMPLE:  

##### Input (file.txt)  
 Hi  

##### Command  
 od -bc file.txt  

Output (example)  

 0000000 110 151 012 H i \n  

Scenario: “Why is this file broken?”  

A config file looks normal when you cat it, but a program keeps failing to read it  

The admin runs:  
 od -bc config.txt  

And sees:  

 \0 \r \n  

Now they know:  

The file contains hidden characters  

Those characters aren’t visible in normal editors  

The program is choking on them  

Use od when something looks fine, but the bytes are wrong  

Sysadmins use od to see invisible characters that break programs  

This is one of those “last-mile debugging” tools — rare, but clutch when you need it  

</details>

---

### Task: Batch rename files using pattern substitution

Rename multiple files by substituting one string for another in their filenames

<details>
<summary>Answer</summary>

 🔄 Rename files using pattern  

 rename 's/foo/bar/' *.txt  

 rename = batch rename files  

 's/foo/bar/' = substitute foo with bar  

 *.txt = all text files  

Renames all .txt files by replacing foo with bar in their names  

</details>

---

### Task: Explain the role of core Linux text utilities in system administration

Be able to summarize the operational purpose of these tools in an exam context

<details>
<summary>Answer</summary>

#### 🏁 One-line summary  

These are the core Linux tools for creating, comparing, transforming, inspecting, and mass-editing text and files — all high-value LFCS commands  

</details>

## Streams

---

### Task: Join two files using a common key column

Use join to merge two text files based on a shared key (typically the first column)

Demonstrate understanding of:
- matching keys
- ignoring non-matching rows
- how join differs from paste

<details>
<summary>Answer</summary>

# 🔗 Join, Paste, Split  

#### 🔗 Join two files  

 join a.txt b.txt  

 join = merge two files by a common column (usually the first column)  

It combines matching lines from both files into one output  

“Join two files together where their keys match” ... means ... “line up rows from both files using a shared ID number, and merge only the ones with the same ID”  

EXAMPLE:  

#### Input files  

##### a.txt  
 1 Alice  
 2 Bob  
 3 Carol  

##### b.txt  
 1 Admin  
 2 User  
 4 Guest  

##### Command  

 join a.txt b.txt  

##### Output  

 1 Alice Admin  
 2 Bob User  

The first column in each file is the key  

 join looks for matching keys  

It combines lines only where the keys are the same  

 1 matches → joined  

 2 matches → joined  

 3 and 4 don’t match → ignored  

Explain the sentence:  

“Join two files together where their keys match”  

“Line up rows from both files using a shared ID number, and merge only the ones with the same ID”  

##### One-line memory hook  

 join = SQL-style join for text files (match on a key, then merge)  

 join = match by key  

</details>

---

### Task: Merge two files side-by-side using line position

Use paste to combine two files horizontally

Demonstrate understanding that paste aligns by line number, not by matching values

<details>

<summary>Answer</summary>

### 📎 Paste two files side by side  

 paste a.txt b.txt  

paste = merge files horizontally (line 1 with line 1, line 2 with line 2, etc.)  

It prints the files next to each other as columns  

“Put two files side by side, line by line”  

EXAMPLE:  

#### Input files  

##### a.txt  
 Alice  
 Bob  
 Carol  

##### b.txt  
 Admin  
 User  
 Guest  

#### Command  

 paste a.txt b.txt  

#### Output  

 Alice Admin  
 Bob User  
 Carol Guest  

 paste takes line 1 from each file and prints them together ... then line 2 with line 2, line 3 with line 3, etc  

It does not care about keys or IDs  

"put two files side by side, line by line” and “line up rows by position, not by value, and print them next to each other”  

 paste = match by line number  

</details>

---

### Task: Split a large file into multiple smaller files

Use split to divide a file into a specified number of roughly equal parts

Demonstrate understanding of:
- how many output files are created
- default output naming (xaa, xab, etc.)
- difference between splitting by count vs size

<details>
<summary>Answer</summary>

### ✂️ Split a file by size or lines  

 split -n 3 bigfile.txt  

 split = break a file into smaller files  

 -n 3 = split into 3 parts  

“Cut a big file into 3 smaller pieces”  

EXAMPLE:  

#### Input file  

##### bigfile.txt  
 line1  
 line2  
 line3  
 line4  
 line5  
 line6  

#### Command  

 split -n 3 bigfile.txt  

#### Output (example files created)  

 xaa  
 xab  
 xac  

#### Contents:  

 xaa  
 line1  
 line2  

 xab  
 line3  
 line4  

 xac  
 line5  
 line6  

 split = break a file apart  

 -n 3 = make 3 roughly equal pieces  

Each piece is written to a new file  

“Cut a big file into 3 smaller pieces”  

 split = break one file into many  

</details>

---

### Task: Distinguish join, paste, and split in one sentence each

Be able to explain when to use each command in an LFCS context

<details>
<summary>Answer</summary>

#### 🏁 One-line summary  

 join merges by matching keys, paste merges side-by-side, and split breaks a file into smaller parts  

</details>


## Search

---

### Task: Use grep to search for text in files and explain what “grep” stands for

Search a file for a matching pattern and explain the historical meaning of grep

Demonstrate understanding of:
- basic pattern matching
- grep acronym origin
- how grep prints matching lines

<details>
<summary>Answer</summary>

# 🔎 8) Regex and Text Search (grep)  

Note: Perl regex (grep -P) may not be available everywhere. Prefer -E  

### 🔎 Regex and Text Search (grep) = “Find text in files”  

### 🔍 Basic grep  

 grep = “Global Regular Expression Print”  

Historically, it comes from the old ed editor command:  

 g /pattern/ p  

Which meant:  

“Globally search for this pattern and print the matching lines”  

So:  

 g = global  

 re = regular expression  

 p = print  

“grep literally means global regex print”  

EXAMPLE:  

### Input file (file.txt)  

 root:x:0:0:root:/root:/bin/bash  
 user:x:1000:1000:User:/home/user:/bin/bash  
 daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin  

#### Command  

 grep root file.txt  

#### Output  

 root:x:0:0:root:/root:/bin/bash  

</details>

---

### Task: Use common LFCS grep flags without hesitation

Use grep with the following flags:

- -i (ignore case)
- -v (invert match)
- -n (show line numbers)
- -R (recursive search)
- -E (extended regex)

Be able to explain what each flag does and when to use it

<details>
<summary>Answer</summary>

✅ Most common grep options for LFCS  

These are the ones you should expect, recognize instantly, and be able to use without thinking:  

🔹 -i — ignore case  

 grep -i root file.txt  

Simp: match root, Root, ROOT  

🔹 -v — invert match  

 grep -v root file.txt  

Simp: show lines that do NOT contain root  

🔹 -n — line numbers  

 grep -n root file.txt  

Simp: show matching lines with their line number  

🔹 -r or -R — recursive  

 grep -R root /etc  

Simp: search all files under a directory tree  

🔹 -E — extended regex (important)  

 grep -E "root|daemon" /etc/passwd  

Simp: allow OR (|), grouping, and cleaner patterns  

#### 📌 Exam note:  

 Prefer -E  
 Do not rely on -P  

#### ⚠️ Optional but still common  

You might also see these, but less frequently:  

 -l → show filenames only  

 -c → count matching lines  

 -w → match whole words  

Example: -n (show line numbers)  

### Input file (file.txt)  

 apple  
 banana  
 apple pie  
 cherry  

#### Command  

 grep -n apple file.txt  

#### Output  

 1:apple  
 3:apple pie  

 -n tells grep to print the line number along with each matching line  

 grep root /etc/passwd  

 grep = search for text  

This prints lines in /etc/passwd that contain root  

“Show me lines that contain root”  

#### 🧠 Memory hook  

 grep = globally search with a regex and print the matches  

 🔤 Case-insensitive grep  

 grep -i root /etc/passwd  

 -i = ignore case  

Matches root, Root, ROOT, etc.  

“Find root no matter how it’s capitalized”  

#### 🚫 Invert match  

 grep -v root /etc/passwd  

 -v = invert (show lines that do NOT match)  

“Show me all lines that do NOT contain root”  

#### 📂 Recursive grep  

 grep -R "root" /etc  

 grep = search text  

 -R = recursive (go into subdirectories)  

 "root" = text to match  

 /etc = starting directory  

“Search for root in all files under /etc and every subdirectory inside it (like /etc/ssh, /etc/systemd, /etc/nginx, etc.)”  

If a subdirectory exists under /etc, -R will search it too  

 🔢 Show line numbers  

 grep -n root /etc/passwd  

 -n = line numbers  

“Show me matching lines and tell me what line number they’re on”  

EXAMPLE:  

### Input (/etc/passwd excerpt)  

 root:x:0:0:root:/root:/bin/bash  
 daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin  
 user:x:1000:1000:User:/home/user:/bin/bash  

#### Command  

 grep -n root /etc/passwd  

#### Output  

 1:root:x:0:0:root:/root:/bin/bash  

The 1: at the start is the line number where root was found  

#### 🧠 Use extended regex  

 grep -E "root|daemon" /etc/passwd  

 -E = extended regex (more powerful pattern rules)  

"root|daemon" = match root OR daemon  

 | = OR (operator) = “one or the other”  

 /etc/passwd = file to search  

“Show lines that contain root OR daemon”  

#### 🏁 One-line summary  

 grep searches text; flags control case, inversion, recursion, line numbers, and regex power  

Example: find login shells  

### Input (/etc/passwd excerpt)  

 root:x:0:0:root:/root:/bin/bash  
 daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin  
 user:x:1000:1000:User:/home/user:/bin/zsh  

#### Command  

 grep -E "/bin/bash|/bin/zsh" /etc/passwd  

#### Output  

 root:x:0:0:root:/root:/bin/bash  
 user:x:1000:1000:User:/home/user:/bin/zsh  

“Show users whose login shell is bash OR zsh”  

This is exactly the kind of practical text-filtering task LFCS expects  

</details>

---

### Task: Use sed to print specific line ranges without automatic output

Use sed to print only a selected range of lines from a file

Demonstrate understanding of:
- -n
- p
- how sed suppresses default output

<details>
<summary>Answer</summary>

# 🧹 9) sed Basics  

### 🧹 sed = “Stream Editor” (edit text as it flows)  

 📄 Print specific lines  

 sed -n '1,10p' file.txt  

 sed = stream editor  

 -n = no automatic printing  

 '1,10p' = print lines 1 through 10  

 p = print  

“Show me lines 1 to 10 from the file”  

</details>

---

### Task: Delete a range of lines using sed

Use sed to remove a specified range of lines from output without modifying the original file

<details>
<summary>Answer</summary>

### 🗑️ Delete lines  

 sed '1,5d' file.txt  

 d = delete  

 '1,5d' = delete lines 1 through 5  

“Show the file without lines 1 to 5”  

</details>

---

### Task: Substitute text using sed (first match per line)

Replace the first occurrence of a pattern on each line

<details>
<summary>Answer</summary>

 🔁 Substitute text (first match per line)  

 sed 's/foo/bar/' file.txt  

 s = substitute  

 foo = what to find  

 bar = what to replace it with  

“Replace the first foo on each line with bar”  

</details>

---

### Task: Substitute all occurrences of a pattern globally using sed

Replace every match on each line using the global flag

<details>
<summary>Answer</summary>

### 🌍 Substitute globally (all matches)  

 sed 's/foo/bar/g' file.txt  

 g = global (all matches in the line)  

“Replace all foo with bar everywhere”  

</details>

---

### Task: Use capture groups in sed to rearrange matched text

Use extended regex and capture groups to reorder matched patterns

Demonstrate understanding of:
- -E
- grouping with ()
- backreferences \1, \2
- delimiter behavior in s///

<details>
<summary>Answer</summary>

### 🧠 Use groups  

 sed -E 's/(foo)(bar)/\2\1/' file.txt  

 -E = extended regex  

 s = substitute  

 / = delimiters that separate parts of the sed command  

 ( ) = capture groups  

 \1, \2 = refer to captured groups  

 file.txt = the input file  

"Find foobar and swap it to barfoo”  

What the / / are doing (this is the key)  

The / characters are delimiters — they separate parts of the sed command  

They do not mean paths, directories, or navigation ... they break the s/// apart:  

 s / (foo)(bar) / \2\1 /  

first / … second / = what to find  

second / … third / = what to replace it with  

last / = end of the substitution  

So structurally:  

 s / FIND / REPLACE /  

 s = substitute  

 (foo)(bar) = two capture groups  

 (foo) = group 1  

 (bar) = group 2  

 \2\1 = replace using group 2, then group 1  

 ' ' = quotes (keep it as one argument)  

 -E = extended regex (allows () without escaping)  

### Input line:  

#### foobar  

 (foo) matches foo  

 (bar) matches bar  

 \2\1 outputs bar + foo  

### Output:  

#### barfoo  

Important mental model (lock this in)  

In sed, / means “separator”, not “path”  

(Some people even use other delimiters like |, but / is the most common)  

 sed uses / to separate what you want to find from what you want to replace it with, and capture groups let you rearrange parts of the match  

#### 🏁 One-line summary  

 sed reads the input one line at a time, processes it, and immediately moves on ... It does not load the whole file into memory and treats input like a flow of lines or 'stream'... and never stops to hold the whole file  

</details>

---

### Task: Explain what awk is and what it is designed to do

Define awk, explain its origin, and describe its purpose as a column-based text processor

<details>
<summary>Answer</summary>


# 🧮 10) awk Basics  

 awk = “Pattern scanning and processing language” (column processor)  

 awk is named after its creators:  

Aho Weinberger Kernighan  

So:  

 awk = Aho–Weinberger–Kernighan  

🧠 Memory hook  

 awk = “the Aho–Weinberger–Kernighan text processing language”  

And what it does:  

A powerful column-based text processor for scanning and transforming text  

</details>

---

### Task: Print specific columns using awk and explain field references

Use awk to print selected columns from a file and explain:

- why quotes are required
- what {} represent
- what $1 means
- how awk processes each line

<details>
<summary>Answer</summary>

📄 Print columns  

 awk '{print $1}' /etc/passwd  

 awk = process text by columns  

 $1 = first column  

1️⃣ What the ' quotes are doing '{print $1}'  

 ' ' = single quotes  

They tell the shell: “pass this exactly to awk”  

Why this matters:  

 $1 would normally be interpreted by the shell  

The quotes protect it so awk sees $1, not the shell  

The quotes keep the awk program intact so the shell doesn’t mess with it  

 2️⃣ What the { } mean  

 {print $1}  

 { } = an awk action block  

It means: “do this for each line”  

“For every line, run this command”  

 3️⃣ What $1 means (and why there’s a $)  

 $ = field reference ... $ means “field (column) number” in awk  

 1 = first field (column)  

 $1 = column 1  

 $2 = column 2  

 $3 = column 3  

 etc.  

 $1 means “the first column of the current line”  

(The $ is required — it tells awk you’re referring to a field, not the number 1)  

 4️⃣ What print is doing  

 print = output the value  

 print $1  

“Print the first column”  

 5️⃣ What /etc/passwd is  

 /etc/passwd  

This is the input file  

It’s a regular file, not a directory  

It contains user account information  

#### Example line:  

 root:x:0:0:root:/root:/bin/bash  

 Awk splits this into fields (by default, whitespace or with -F: if specified)  

### 🧠 What the whole command does  

“For each line in /etc/passwd, print only the first column”  

### 🏁 One-line lock-in  

 '...' = protect awk code  

 {} = do this for every line  

 $1 = first column  

 /etc/passwd = input file  

</details>

---

### Task: Specify a custom field separator and print selected columns

Use awk with -F to define a delimiter and print multiple columns

<details>
<summary>Answer</summary>

 📄 Print specific columns using :  

 awk -F: '{print $1, $3}' /etc/passwd  

 -F: = field separator is :  

 $1 = first column, $3 = third column  

“Using : as the separator, print column 1 and 3”  

</details>

---

### Task: Filter rows based on numeric comparison using awk

Use awk to filter rows where a column meets a numeric condition

Explain where knowledge of field meaning comes from

<details>
<summary>Answer</summary>

### 🔍 Filter by value  

 awk '$3 > 1000 {print $1}' /etc/passwd  

 $3 > 1000 = only lines where column 3 is greater than 1000  

“Show the names whose UID is greater than 1000”  

Protocol breakdown  

 awk = process text by columns  

 $3 = third column  

 1000 = numeric comparison  

 {print $1} = print first column  

 /etc/passwd = input file  

What awk itself knows  

Nothing about UIDs. Nothing about users  

 awk only knows:  

“Split line → compare column 3 → if true → print column 1”  

That’s it  

Second — where the “UID” knowledge comes from  

This is Linux knowledge, not awk knowledge  

The structure of /etc/passwd is standardized:  

### Format:  

 username:password:UID:GID:comment:home:shell  

### Field meanings:  

#### Field Meaning  
 $1 username  
 $2 password placeholder  
 $3 UID  
 $4 GID  
 $5 comment  
 $6 home directory  
 $7 shell  

So how do you “know” $3 is UID?  

Because:  

 / etc/passwd has a fixed, documented format  

You learn this once and memorize it for Linux admin work (and LFCS absolutely expects you to know it)  

</details>

---

### Task: Use BEGIN and END blocks to initialize and summarize data streams

Process streamed input, initialize variables before processing, accumulate values per line, and print results after all input is processed

<details>
<summary>Answer</summary>

### 🧠 Use BEGIN and END  

 ps aux | awk 'BEGIN {sum=0} {sum+=$6} END {print sum}'  

 ps = process status  

It’s one word, not two flags  

 aux = here the letters are options, not part of the name  

 a = all users’ processes  

 u = user-oriented format (more columns)  

 x = include processes without a terminal (daemons)  

“Show all processes, with details, even background ones”  

 | = pipe (send output into next command)  

 awk = receives a stream of lines coming from ps  

Example input flowing in:  

 USER PID %CPU %MEM VSZ RSS ...  
 root 1 ...  
 rob 22 ...  

So awk is waiting for input  

Step 2 — awk program structure  

Awk always follows this order:  

 BEGIN (once)  
 For each line → main block  
 END (once)  

So internally awk does:  

 load program  
 run BEGIN  
 process lines  
 run END  

What awk does first (mechanically)  

 Start awk process  

 Compile the awk script  

 Prepare to read input  

 Then run BEGIN  

So:  

Nothing is processed yet ... No lines are read yet  

 ' ' = protect the awk program from the shell ... 'pass this text exactly to awk'  

BEGIN = runs first before any lines are processed and any input is read  

So at BEGIN time:  

 No $1, $2, $6  

 No current line  

 No records exist yet  

 Only variables and setup code work here  

Why BEGIN exists  

Because you often need to:  

 initialize variables  

 print headers  

 setup counters  

Example:  

 BEGIN {sum=0}  

“Set up my calculator before the data starts flowing”  

Think:  

 awk starts ↓ BEGIN runs ↓ lines stream through ↓ END runs  

Before BEGIN, awk just starts up and prepares; BEGIN is literally the first code that runs  

 ' ' = protect the awk program from the shell  

“Pass this text exactly to awk”  

 {} = action block  

 sum=0 = initialize variable ... start sum at 0  

 {sum+=$6} = add column 6 to sum for each line  

 {} = do this for each line  

 sum = variable  

 += = assign value (store something in a variable)  
add this value to the variable and save it back  

 $6 = column 6  

 END = run after all lines are processed  

“Add up column 6 for every line and print the total at the end” ... runs once per process line  

### ➕ Do arithmetic  

(Already shown above)  

 sum+=$6 = keep a running total  

“Use awk like a calculator on columns”  

### 🏁 One-line summary  

 awk is a column-aware text processor that can filter, calculate, and summarize data  

</details>

---

### Task: Define completion criteria for Essential Commands mastery

Confirm you can execute all required command surfaces without hesitation

<details>
<summary>Answer</summary>

### ✅ Completion Criteria  

You are done with this file when:  

 Exit codes and chaining are automatic  

 Job control is automatic (&, jobs, fg, bg, Ctrl+Z, kill)  

 You can execute the listed command surfaces without looking anything up  

</details>

