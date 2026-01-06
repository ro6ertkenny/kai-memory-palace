# 🧭 Bash Basics
## Moving, inspecting, and acting with intent

Mental mode: Issuing precise instructions to the system.

This document is the **canonical Bash command and concept reference** you are expected to internalize.
Every entry explains **what it is** and **why it exists**, in short memory-friendly form.

If something appears in daily usage or exams, it belongs here.

---

## Purpose
You should be able to:
- recognize commands and symbols instantly
- understand how commands receive input and produce output
- predict outcomes before execution
- move through the filesystem quickly and safely under time pressure

This file converts confusion into recall.

---

## Command Structure (Foundational Concept)

##  How to Read a Command Like a Sentence

General form:

```bash
command [flags] [arguments]
```

Example:

```bash
tar -xf input.tar -C extract-here
```

Read as:

> **Extract the file `input.tar` into the directory `extract-here`.**

Mental mapping:

- command = verb  
- flags = how  
- arguments = what / where  

---

command [options] [arguments]

- **command**: the action to perform  
- **options**: flags that modify behavior  
- **arguments**: targets the command operates on  

Bash evaluates input **left to right**.

---

## 🔌 stdin, stdout, stderr (How Commands Talk)

Every command uses three streams:

- **stdin** (0)  → input to the program  
- **stdout** (1) → normal output  
- **stderr** (2) → error output  

Pipelines connect **stdout of the left command to stdin of the right command**:

```bash
ls | grep md
ps aux | head
```

Redirection:

```bash
command > file      # overwrite output
command >> file     # append output
```

Mental model:

> **Pipes move data between programs. Redirection sends data to files.**

---

## 🔗 Pipelines and Command Chaining

Common patterns:

```bash
ps aux | grep chrome
lsblk | grep sda
find ~ -type f | grep "\.md$"
grep -R "chmod" ~/kai-memory-palace | wc -l
```

Key tools:

- `|` → pipe (stdout → stdin)
- `grep` → filter text
- `wc -l` → count lines
- `head`, `tail` → trim output

Mental model:

> **Small tools, glued together.**

---

## 📚 stdin in the Real World (Why Pipes Work)

Example:

```bash
ps aux | head
```

Flow:

- `ps` writes to **stdout**
- `head` reads from **stdin**
- The pipe connects them

Another:

```bash
ls | grep md
```

> **Programs don’t know about each other. The shell wires them together.**


---

## 🏷️ Common Flags (NOT Universal — Per Command!)

Very common patterns:

- `-l` → long format (ls)
- `-h` → human readable (ls, df, du)
- `-a` → all (include hidden)
- `-R` → recursive
- `-f` → file or force (depends on command)
- `-C` → change directory (tar)

⚠️ Rule:

> **Flags are command-specific. Always check `man'

---

## Core Commands & Concepts (Alphabetical)

### `cat`
Prints file contents to standard output.  
Used to quickly inspect small files or feed data into pipelines.

---

### `cd`
Changes the current working directory.  
Used to move around the filesystem.

Common forms:
- `cd /path`
- `cd ..`
- `cd ~`
- `cd -`

---

### `cp`
Copies files or directories.  
Used when you need a duplicate without removing the original.

---

### `df`
Displays disk space usage for mounted filesystems.  
Used to determine whether a disk is full or running out of space.

---

### `echo`
Prints text or variable values to standard output.  
Used to inspect variables and test shell behavior.

---

### `env`
Displays the current environment variables.  
Used to see what configuration the shell passes to programs.

---

### `export`
Marks a variable so child processes can see it.  
Used when programs need access to variables you define.

---

### `findmnt`
Displays the current mount hierarchy from the kernel’s perspective.  
Used as the authoritative source of truth for what is actually mounted.

---

### `head`
Prints the first lines of a file.  
Used to quickly inspect file structure or headers.

---

### `history`
Shows previously run commands.  
Used to recall and reuse past work efficiently.

---

### `less`
Displays file contents one screen at a time.  
Used for safely viewing large files.

---

### `ls`
Lists directory contents.  
Used to inspect files, directories, and metadata.

Common options:
- `-l` long format
- `-a` include hidden files
- `-h` human-readable sizes

---

### `lsblk`
Lists block devices and their mount points in a tree view.  
Used to safely inspect disk and partition layout before any storage operation.

---

### `mount`
Attaches a filesystem to the directory tree.  
Used to make storage available at a specific path.

### `umount`
Detaches a filesystem from the directory tree.  
Used to safely remove access to storage before disconnecting it.

---

### `mkdir`
Creates directories.  
Used to build filesystem structure.

---

### `mv`
Moves or renames files and directories.  
Used to reorganize data without copying.

---

### `pwd`
Prints the current working directory.  
Used to confirm location before acting.

---

### `rm`
Deletes files or directories permanently.  
Used to remove data that is no longer needed.

Use with extreme caution.

---

### `sed`
Stream editor that transforms text line by line.  
Used to search, replace, or modify text without opening an editor.

---

### `tail`
Prints the last lines of a file.  
Used to inspect recent output or logs.

---

### `touch`
Creates an empty file or updates timestamps.  
Used to create files quickly or signal file presence.

---

### `type`
Shows how the shell interprets a command.  
Used to distinguish builtins, aliases, and binaries.

---

### `which`
Displays the path of the executable that would run.  
Used to confirm which binary is actually being invoked.

---

## Input & Output Concepts (Critical)

### `stdin` (standard input)
The data a command receives by default.  
Usually comes from the keyboard or another command.

---

### `stdout` (standard output)
The normal output a command produces.  
Usually printed to the terminal or piped elsewhere.

---

### `stderr` (standard error)
Error messages produced by a command.  
Kept separate so failures can be handled independently.

---

## Pipes & Redirection

### `|`
Pipe operator that sends stdout from one command into stdin of another.  
Used to chain commands together.

---

### `>`
Redirects stdout to a file, overwriting it.  
Used to save command output.

---

### `>>`
Redirects stdout to a file, appending to it.  
Used to add output without deleting existing content.

---

### `2>`
Redirects stderr to a file.  
Used to capture error messages separately.

---

## Wildcards (Globbing)

### `*`
Matches any number of characters.  
Used to target groups of files.

---

### `?`
Matches exactly one character.  
Used for precise filename patterns.

Globs expand **before** the command runs.

---

##  Globs and Shell Expansion (Happens Before the Command Runs)

The shell expands these **before** executing the command:

- `*` → any characters
- `?` → one character
- `~` → home directory

Examples:

```bash
ls *.txt
ls -lh ~/archive-lab/*.tar*
```

Important:

> **The command never sees `*`. The shell replaces it first.**

---

## Exit Codes

### `$?`
Holds the exit code of the last command.  
Used to determine success or failure.

- `0` success  
- non-zero failure  

Exit codes drive scripting logic.

---

## Exam & Exam-Speed Navigation (Critical)

### Absolute jumps (preferred)
cd /        # go to filesystem root
cd ~        # go to home directory
cd -        # go to previous directory
cd ../../.. # go up multiple levels
```

Rules:

- `~` always means **your home**
- `-` always means **where you just were**
- Prefer **absolute paths** for risky operations

---

## Flags & Options (Exam-Critical)

Flags modify **how** a command behaves.  
They do **not** change what the command is.

Never guess flag meanings by letter — learn them by behavior.

---

### `-a`
Means “all”.  
Used to include hidden files or normally omitted items.

Common example:
- `ls -a` → show dotfiles

---

### `-f`
Means “force”.  
Used to bypass prompts or ignore warnings.

Dangerous when combined with destructive commands.

---

### `-h`
Means “human-readable”.  
Used to display sizes in K, M, G instead of raw bytes.

---

### `-i`
Means “interactive”.  
Used to prompt before each action, especially deletions.

---

### `-l`
Means “long format”.  
Used to display detailed metadata, not to list.

---

### `-p`
Means “parents” or “preserve” depending on command.  
For `mkdir`, it creates parent directories as needed.

---

### `-r`
Means “recursive”.  
Used to operate on directories and everything inside them.

---

### `-t`
Means “sort by time”.  
Used to order output by modification time.

---

### `-y`
Means “assume yes”.  
Used to automatically confirm prompts in non-interactive operations.

---

## Flag Interpretation Rules (Important)

- Flags describe **behavior**, not intent
- Same flag letter can mean different things for different commands
- Always read flags in the context of the command
- When unsure, check the man page immediately

---

## Exam Memory Hooks 🧠

- `-l` → details, not list
- `-r` → descend into directories
- `-f` → remove safety nets
- `-i` → ask before acting
- `-y` → “I already decided”
- `-h` → readable sizes

---

## Exam Rule
> **Never assume a flag means the same thing everywhere.**

Understanding behavior beats memorization.

