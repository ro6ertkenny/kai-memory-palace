# 🧪 Essential Commands — Execution Drill (LFCS)

Mental mode: **pure mechanics • speed • zero hesitation • operator accuracy**

Scope: **authoritative LFCS essential command set only**

Order: **foundation-first**

---

# 🥇 LAYER 1 — Shell Execution Model

## Command success and exit codes

1. Run a command that succeeds
2. Print its exit code
3. Run a command that fails
4. Print its exit code

Repeat until meaning of `0` vs non-zero is instant.

---

## Sequential vs conditional execution

1. Run two commands sequentially regardless of success
2. Run a command that only executes on success
3. Run a command that only executes on failure
4. Chain success and failure handling in one line

---

## STDOUT overwrite vs append

1. Write text to a file (overwrite)
2. Append text to the same file
3. Verify the result

---

## STDERR handling

1. Generate an error and capture only STDERR to a file
2. Confirm STDOUT is not captured
3. Suppress error output completely

---

## Pipes

1. Send command output through a pipeline
2. Count resulting lines
3. Filter for a matching pattern in a pipeline

---

## tee (view + save)

1. Capture piped output to a file while displaying it
2. Append to an existing file using tee

---

# 🥈 LAYER 2 — Navigation & Filesystem Awareness

## Determine current location

1. Print working directory
2. List contents
3. List with metadata
4. Identify file type of a target

---

## Inspect space usage

1. Show filesystem capacity
2. Show directory size
3. Compare sizes of two directories

---

# 🥉 LAYER 3 — Create / Move / Delete

## File creation and directory creation

1. Create an empty file
2. Create a directory
3. Create nested directories in one command

---

## Copy operations

1. Copy a file
2. Copy a directory recursively
3. Copy while preserving metadata

---

## Move and rename

1. Rename a file
2. Move a file into another directory
3. Move and rename in one operation

---

## Removal

1. Remove a file
2. Remove an empty directory
3. Remove a directory recursively

---

# 🏅 LAYER 4 — Viewing & Inspecting File Content

## Direct output

1. Display entire file
2. Display first N lines
3. Display last N lines

---

## Interactive inspection

1. Open a file for scrolling inspection
2. Search inside the viewer

---

## Content metrics

1. Count lines
2. Count words
3. Count bytes

---

# 🏅 LAYER 5 — Search

## Locate files by name

1. Search from current directory
2. Search system-wide (where permitted)

---

## Locate by attribute

1. Find by file type
2. Find by size
3. Find by owner
4. Find by permissions
5. Find by modification time

---

## Locate executables

1. Identify command path
2. Identify all related command locations

---

# 🏅 LAYER 6 — Text Filtering Primitives

## Pattern matching

1. Extract matching lines from a file
2. Count matches
3. Invert the match

---

## Field extraction

1. Extract a specific column from structured text
2. Change the delimiter and repeat

---

## Sorting and uniqueness

1. Sort input
2. Remove duplicate lines
3. Count unique values

---

## Character translation

1. Replace characters in a stream
2. Delete characters from a stream

---

## Stream metrics

1. Count lines from piped input
2. Count words from piped input

---

# 🏅 LAYER 7 — Links

## Hard links

1. Create a hard link to a file
2. Verify both names reference the same inode

---

## Soft links

1. Create a symbolic link
2. Verify link target
3. Observe behavior when target is removed

---

# 🏅 LAYER 8 — Permissions & Ownership

## View permissions

1. List file permissions
2. Identify numeric mode

---

## Modify permissions

1. Set exact numeric permissions
2. Add execute permission
3. Remove write permission

---

## Ownership

1. Change file owner
2. Change file group
3. Change owner and group in one command

---

## Default permissions

1. Display current umask
2. Change umask
3. Create a file and verify resulting permissions

---

# 🏅 LAYER 9 — Archive & Compression

## Archive creation

1. Create a tar archive
2. List archive contents
3. Extract archive

---

## Compression

1. Compress a file
2. Decompress a file
3. Create a compressed archive in one step

---

# 🏅 LAYER 10 — File Comparison

## Byte comparison

1. Compare two files for exact match

---

## Line comparison

1. Show differences between two text files

---

# 🏅 LAYER 11 — Remote Operations

## Remote login

1. Connect to a remote system
2. Execute a simple remote command and return

---

## Remote copy

1. Copy file to a remote system
2. Copy file from a remote system

---

# 🔁 EXECUTION STANDARD

Train each block until:

- no syntax lookup
- no hesitation
- no trial-and-error
- clean first execution


# APPENDIX — KodeKloud Alignment Index (not a drill)

#### Shell execution & redirection (already drilled)
    echo, true, false, $? , ;, &&, ||, >, >>, <, 2>, 2>>, &>, |, tee
    Deep links:
    - ../../shell-and-bash/bash/bash-basics.md
    - ../../shell-and-bash/bash/bash-pipelines.md

#### SSH essentials (add to drill as optional reps, keep in scope)
    ssh -V
    ssh -v user@host
    Deep link:
    - ../../networking/ssh-operator-basics.md

#### Host identity (NOT essential-commands drill scope; route to foundations)
    hostnamectl (set-hostname / static hostname workflows)
    Deep link:
    - ../../foundations/system-inspection.md

#### “Find hidden files” (still essential; add as optional rep)
    ls -la /path
    Deep link:
    - ../../foundations/files-and-metadata-inspection.md

#### Manual discovery (route to shell-and-bash/bash)
    apropos "keywords"
    Deep link:
    - ../../shell-and-bash/bash/man-basics.md

#### Filesystem mount inspection (NOT essential-commands scope; storage wing)
    findmnt /dev/...
    mount -o ro,noexec,nosuid ...
    umount /mnt
    Deep link:
    - ../../filesystems-and-storage/mounting-and-unmounting.md

#### Archives & compression (already in scope)
    tar -cf/-tf/-xf
    gzip/gunzip
    bzip2/bunzip2
    xz/unxz
    Deep link:
    - ../../foundations/archives-and-compression-tar.md

#### Compare (already in scope)
    diff
    cmp
    Deep link:
    - ../../shell-and-bash/text-processing/grep.md

---

## 2) Add the cheat-sheet commands into canonical wing docs (merge checklist)

This is a routing plan. For each item, paste the command(s) into the correct operator doc

### A) linux/networking/
File: ssh-operator-basics.md
Add:
    ssh -V
    ssh -v user@host
    scp file user@host:/path/
    scp user@host:/path/file .

From PDF: ssh/scp examples and debug flags  

---

### B) linux/shell-and-bash/bash/
File: man-basics.md
Add:
    apropos "NFS mounts"
Explain: search manpage names/descriptions for keywords

From PDF: apropos usage  

---

### C) linux/foundations/
File: system-inspection.md
Add:
    hostnamectl (static hostname workflows)
    uptime
    lscpu
    free --mega
    df /
    du -sh /bin/
From PDF: system inspection commands  

---

### D) linux/package-management/
File: package-management.md
Add (Rob standard is apt-get; keep the cheat sheet as “alias/alt syntax”):
    apt search "term"
    apt install pkg
    apt-get remove --auto-remove -y pkg
    dpkg --search /path/to/file
    dpkg --listfiles pkg | grep '^/bin'
From PDF: apt/dpkg examples  

---

### E) linux/process-and-resource-management/
File: process-inspection.md / process-control.md / signals-and-sigkill.md
Add:
    ps lax
    ps u 1
    pgrep -a name
    lsof -p 1
    kill -SIGHUP <pid>
    renice 9 <pid>
From PDF: ps/pgrep/lsof/kill/renice  

---

### F) linux/process-and-resource-management/ (scheduling)
File: services-and-daemons.md or a scheduling doc (if present)
Add:
    crontab -l
    anacron -n -f
    atq
    atrm <jobid>
From PDF: cron/anacron/at commands  

---

### G) linux/foundations/ or linux/security/
SELinux items (ONLY if you’re in an SELinux-enabled distro):
    ls -Z /bin/sudo
    chcon -t TYPE file
    setenforce 0
    semanage user -l
    restorecon -R /path
From PDF: SELinux commands.

Suggested home:
    foundations/selinux-operator-basics.md

---

### H) linux/filesystems-and-storage/
Storage and mounts:
    lsblk
    fdisk /dev/...
    cfdisk
    mkfs.xfs ...
    mkfs.ext4 ...
    mount /dev/... /mnt
    umount /mnt
    mkswap /dev/...
    swapon --show
    swapon / swapoff
    findmnt /dev/...
From PDF: storage/mount/swap commands.

Suggested homes (choose where you want them):
    filesystems-and-storage/storage-inspection.md
    filesystems-and-storage/filesystem-creation-and-tuning.md
    filesystems-and-storage/mounting-and-unmounting.md

LVM + RAID + quotas + ACLs (clearly non-essential domain):
    pvcreate/pvs/pvremove
    vgcreate/vgextend/vgreduce/vgs
    lvcreate/lvresize/lvremove
    mdadm --create ...
    setfacl/getfacl
    xfs_quota ...
From PDF: storage advanced topics

Suggested homes:
    filesystems-and-storage/lvm-operator-basics.md
    filesystems-and-storage/acls-and-the-acl-mask.md

---

### I) linux/foundations/ (users and groups are NOT essential commands)
User/group lifecycle commands from PDF:
    useradd/usermod/userdel
    groupadd/groupmod/groupdel
    gpasswd
    chage
Suggested home:
    foundations/users-and-groups.md
    foundations/user-lifecycle-management.md

---

### J) git/ (not linux essential commands)
Git commands from PDF:
    git add
    git commit -m
    git branch
    git checkout
    git log --raw
    git merge
    git pull/push
    git clone
Suggested home:
    git/README.md or git/change-workflow.md

---

## 3) Rules to prevent scope corruption (permanent)

- essential-commands.md drill stays “Essential Commands” + shell mechanics + archives + compare + ssh/scp only.
- Everything else from the cheat sheet is routed to its wing:
  users/groups, storage, networking, running systems, packages, SELinux, git

---
