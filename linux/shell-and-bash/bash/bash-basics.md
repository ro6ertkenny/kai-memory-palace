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

command [options] [arguments]

- **command**: the action to perform  
- **options**: flags that modify behavior  
- **arguments**: targets the command operates on  

Bash evaluates input **left to right**.

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
```bash
cd /
cd /etc
cd ~

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

