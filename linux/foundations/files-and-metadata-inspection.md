# files-and-metadata-inspection.md
Foundations — Files, Inodes, Links, and Inspection Tools

Goal: Understand what a file really is on disk, and use inspection-first tools to explain system behavior without guessing.

Mental mode: Inspect → Understand → Verify

--------------------------------------------------------------------

SCOPE

This document covers:

- inodes (what they are, why they matter)
- hard links vs symbolic links
- interpreting ls -l output
- file and filesystem metadata with stat
- inspection-first habits for common file questions

Not covered here:

- deep permissions rules (see: filesystem-and-permissions.md)
- mounting and /etc/fstab (see: filesystems-and-storage/*)
- disk usage deep dives (see: disk-usage-analysis.md)
- block device topology (see: storage-inspection.md)

--------------------------------------------------------------------

FILES AND INODES (THE REAL MODEL)

A filename is not the file.

- A filename (directory entry) points to an inode.
- The inode contains metadata and pointers to the file’s data blocks.

This is why:

- multiple names can refer to the same underlying file (hard links)
- permissions and ownership are inode metadata
- renaming a file does not change its inode

Show inode number:

    ls -li file.txt

--------------------------------------------------------------------

HARD LINKS VS SYMBOLIC LINKS

Hard link:

- another name for the same inode
- same inode number
- link count increases
- cannot span filesystems
- generally cannot link directories (for normal users)

Symbolic link (symlink):

- its own inode
- points to a pathname
- can cross filesystems
- can break if target moves

Recognize a symlink:

    ls -l

You will see:

- file type starts with l
- output shows: linkname -> target

Show symlink target:

    readlink linkname

Useful detail:

- deleting a link does not delete the target
- deleting the target leaves a broken symlink

--------------------------------------------------------------------

UNDERSTANDING ls -l COLUMNS

Example:

    -rw-rw-r-- 1 ro6ert ro6ert 7061 Jan 5 09:19 bash-basics.md

Columns:

1) file type
   -  = regular file
   d  = directory
   l  = symlink

2) permissions (owner, group, others)

3) link count
   - number of hard links referencing this inode

4) owner

5) group

6) size in bytes

7) timestamp (typically mtime)

8) name

Note:
- a high link count usually indicates hard links
- link count on directories reflects subdirectory structure (., ..) and is expected to be > 1

--------------------------------------------------------------------

PERMISSIONS (ONLY THE MINIMUM HERE)

Permissions are central to file behavior, but the full model is in:

- filesystem-and-permissions.md

Quick hooks:

- r = read
- w = write
- x = execute

Numeric:

- r = 4
- w = 2
- x = 1

Examples:

    chmod 664 file.txt
    chmod +x script.sh

Scripts usually need:

- execute bit
- a shebang line, e.g.:

    #!/usr/bin/env bash

--------------------------------------------------------------------

stat — FILE METADATA (AUTHORITATIVE)

Show full metadata:

    stat file.txt

Key fields to understand:

- Size: file size in bytes
- Blocks: 512-byte blocks allocated (disk usage view)
- IO Block: filesystem block size (often 4096)
- Device: major/minor device number
- Inode: inode number
- Links: hard link count
- Access/Modify/Change/Birth:
  - Access = read time (atime)
  - Modify = content changed (mtime)
  - Change = metadata changed (ctime)
  - Birth = creation (not always available)

Tip:
- Blocks vs Size can differ (sparse files, block allocation, filesystem behavior)

--------------------------------------------------------------------

stat -f — FILESYSTEM METADATA

Filesystem view of the path:

    stat -f /home

Useful fields:

- block size
- total/free blocks
- inode counts
- max filename length (Namelen; often 255)

Rule of thumb:
- stat is precise and verbose
- df and du are more human-oriented

--------------------------------------------------------------------

INSPECTION FIRST: THE 6 COMMANDS

When something about a file seems “off”, start here:

Who am I?

    whoami
    id

Where am I?

    pwd

What is it?

    ls -la

What is the real path?

    realpath target

What does metadata say?

    stat target

Is it a link?

    readlink target

Never guess. Verify each step.

--------------------------------------------------------------------

STORAGE INSPECTION (WHERE TO LOOK NOW)

If your question becomes storage/mount related, jump to the canonical Day 3 docs:

- filesystems-and-storage/storage-inspection.md
- filesystems-and-storage/mounting-and-fstab.md
- filesystems-and-storage/disk-usage-analysis.md

At a minimum, know these exist:

Filesystem capacity (space):

    df -h

Filesystem inodes:

    df -hi

Directory usage:

    du -sh /path

Mount truth:

    findmnt

Block device layout:

    lsblk -f

--------------------------------------------------------------------

EXAM RULES (FOUNDATIONS)

- Use ls -li to prove inode identity
- Use stat to prove metadata and timestamps
- Use readlink to prove symlink targets
- Use df for filesystem capacity and inodes
- Use du for directory-level usage
- Never guess — inspect first

--------------------------------------------------------------------
