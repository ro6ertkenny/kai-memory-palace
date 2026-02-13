# 🧪 Essential Commands — Execution Drill (LFCS)

Mental mode: **pure mechanics • speed • zero hesitation • operator accuracy**

Scope: **authoritative LFCS essential command set only**

Order: **foundation-first**

---

# 🥇 LAYER 0 — Shell Execution Model

## A0.1 — Command success and exit codes

1. Run a command that succeeds
2. Print its exit code
3. Run a command that fails
4. Print its exit code

Repeat until meaning of `0` vs non-zero is instant.

---

## A0.2 — Sequential vs conditional execution

1. Run two commands sequentially regardless of success
2. Run a command that only executes on success
3. Run a command that only executes on failure
4. Chain success and failure handling in one line

---

## A0.3 — STDOUT overwrite vs append

1. Write text to a file (overwrite)
2. Append text to the same file
3. Verify the result

---

## A0.4 — STDERR handling

1. Generate an error and capture only STDERR to a file
2. Confirm STDOUT is not captured
3. Suppress error output completely

---

## A0.5 — Pipes

1. Send command output through a pipeline
2. Count resulting lines
3. Filter for a matching pattern in a pipeline

---

## A0.6 — tee (view + save)

1. Capture piped output to a file while displaying it
2. Append to an existing file using tee

---

# 🥈 LAYER 1 — Navigation & Filesystem Awareness

## A1.1 — Determine current location

1. Print working directory
2. List contents
3. List with metadata
4. Identify file type of a target

---

## A1.2 — Inspect space usage

1. Show filesystem capacity
2. Show directory size
3. Compare sizes of two directories

---

# 🥉 LAYER 2 — Create / Move / Delete

## A2.1 — File creation and directory creation

1. Create an empty file
2. Create a directory
3. Create nested directories in one command

---

## A2.2 — Copy operations

1. Copy a file
2. Copy a directory recursively
3. Copy while preserving metadata

---

## A2.3 — Move and rename

1. Rename a file
2. Move a file into another directory
3. Move and rename in one operation

---

## A2.4 — Removal

1. Remove a file
2. Remove an empty directory
3. Remove a directory recursively

---

# 🏅 LAYER 3 — Viewing & Inspecting File Content

## A3.1 — Direct output

1. Display entire file
2. Display first N lines
3. Display last N lines

---

## A3.2 — Interactive inspection

1. Open a file for scrolling inspection
2. Search inside the viewer

---

## A3.3 — Content metrics

1. Count lines
2. Count words
3. Count bytes

---

# 🏅 LAYER 4 — Search

## A4.1 — Locate files by name

1. Search from current directory
2. Search system-wide (where permitted)

---

## A4.2 — Locate by attribute

1. Find by file type
2. Find by size
3. Find by owner
4. Find by permissions
5. Find by modification time

---

## A4.3 — Locate executables

1. Identify command path
2. Identify all related command locations

---

# 🏅 LAYER 5 — Text Filtering Primitives

## A5.1 — Pattern matching

1. Extract matching lines from a file
2. Count matches
3. Invert the match

---

## A5.2 — Field extraction

1. Extract a specific column from structured text
2. Change the delimiter and repeat

---

## A5.3 — Sorting and uniqueness

1. Sort input
2. Remove duplicate lines
3. Count unique values

---

## A5.4 — Character translation

1. Replace characters in a stream
2. Delete characters from a stream

---

## A5.5 — Stream metrics

1. Count lines from piped input
2. Count words from piped input

---

# 🏅 LAYER 6 — Links

## A6.1 — Hard links

1. Create a hard link to a file
2. Verify both names reference the same inode

---

## A6.2 — Soft links

1. Create a symbolic link
2. Verify link target
3. Observe behavior when target is removed

---

# 🏅 LAYER 7 — Permissions & Ownership

## A7.1 — View permissions

1. List file permissions
2. Identify numeric mode

---

## A7.2 — Modify permissions

1. Set exact numeric permissions
2. Add execute permission
3. Remove write permission

---

## A7.3 — Ownership

1. Change file owner
2. Change file group
3. Change owner and group in one command

---

## A7.4 — Default permissions

1. Display current umask
2. Change umask
3. Create a file and verify resulting permissions

---

# 🏅 LAYER 8 — Archive & Compression

## A8.1 — Archive creation

1. Create a tar archive
2. List archive contents
3. Extract archive

---

## A8.2 — Compression

1. Compress a file
2. Decompress a file
3. Create a compressed archive in one step

---

# 🏅 LAYER 9 — File Comparison

## A9.1 — Byte comparison

1. Compare two files for exact match

---

## A9.2 — Line comparison

1. Show differences between two text files

---

# 🏅 LAYER 10 — Remote Operations

## A10.1 — Remote login

1. Connect to a remote system
2. Execute a simple remote command and return

---

## A10.2 — Remote copy

1. Copy file to a remote system
2. Copy file from a remote system

---

# 🔁 EXECUTION STANDARD

Train each block until:

- no syntax lookup
- no hesitation
- no trial-and-error
- clean first execution

