# disk-usage-analysis.md
LFCS Day 3 — Filesystems & Storage

Goal: Analyze disk usage, find what is consuming space, understand inode exhaustion, and safely identify storage pressure.

--------------------------------------------------------------------

MENTAL MODEL

- There are two common ways to “run out of disk”:
  - You run out of BLOCKS (space)
  - You run out of INODES (too many files)
- df shows filesystem-level usage.
- du shows directory-level usage.
- You always start with df, then drill down with du.

--------------------------------------------------------------------

DF — FILESYSTEM VIEW (TOP LEVEL)

Show all filesystems:

    df -h

Show filesystem types:

    df -hT

Check a specific path:

    df -h /var
    df -hT /home

Shows:

- Filesystem
- Size
- Used
- Available
- Use%
- Mount point

Important:

- df reports usage of the filesystem that backs the path you ask about.
- It does NOT tell you which directories are using the space.

--------------------------------------------------------------------

INODE USAGE

Check inode usage:

    df -i

If Use% is 100% but space is available:

- You ran out of inodes
- Usually caused by millions of tiny files (logs, cache, mail spools, etc.)

--------------------------------------------------------------------

DU — DIRECTORY VIEW (WHERE SPACE IS USED)

Check a directory:

    du -sh /var

Check subdirectories:

    du -sh /var/*

Summarize top-level directories:

    du -xh --max-depth=1 /

Options explained:

- -s = summary
- -h = human readable
- -x = stay on same filesystem
- --max-depth=1 = only one level deep

--------------------------------------------------------------------

FINDING BIG DIRECTORIES

Start at root of the filesystem:

    cd /
    du -xh --max-depth=1 /

Then descend:

    du -xh --max-depth=1 /var
    du -xh --max-depth=1 /home

Repeat until you find the offender.

--------------------------------------------------------------------

FINDING BIG FILES

Find files larger than 1GB:

    find / -xdev -type f -size +1G 2>/dev/null

Sort files by size:

    find /var -type f -exec ls -lh {} + | sort -k5 -h

--------------------------------------------------------------------

OPEN-BUT-DELETED FILES (COMMON TRAP)

Sometimes space is used but du cannot find it.

Cause:

- A process has a file open
- The file was deleted
- The space is not freed until the process exits

Find them:

    sudo lsof | grep deleted

Fix:

- Restart the process
- Or reboot (last resort)

--------------------------------------------------------------------

MOUNTPOINT CONFUSION (VERY COMMON)

If you:

- Write data to /mnt/data
- Then mount something over /mnt/data

The old data still exists but is hidden.

Check:

    lsblk -f
    findmnt

Fix:

- Unmount
- Inspect the directory
- Clean up
- Remount

--------------------------------------------------------------------

LOG FILE GROWTH

Common space hog:

- /var/log

Check:

    du -sh /var/log
    du -sh /var/log/*

Common fixes:

- Truncate logs
- Rotate logs
- Fix runaway services

--------------------------------------------------------------------

CACHE AND PACKAGE FILES

On Debian/Ubuntu:

    sudo apt-get clean
    sudo apt-get autoremove

Check:

    du -sh /var/cache
    du -sh /var/cache/*

--------------------------------------------------------------------

TEMPORARY DIRECTORIES

Check:

    /tmp
    /var/tmp

    du -sh /tmp/*
    du -sh /var/tmp/*

--------------------------------------------------------------------

INODE EXHAUSTION DRILLDOWN

Find directories with many files:

    find /var -xdev -type d -exec sh -c 'echo -n "{}: "; find "{}" -maxdepth 1 -type f | wc -l' \;

Usually:

- Mail spools
- Cache dirs
- App temp dirs
- Broken cleanup jobs

--------------------------------------------------------------------

SAFE CLEANUP PRINCIPLES

- Never delete blindly.
- Always confirm what the files are.
- Prefer truncating logs over deleting important files.
- Stop the service before deleting its data.

--------------------------------------------------------------------

REAL-WORLD WORKFLOW

1) Check filesystem:

    df -hT

2) If full, check inodes:

    df -i

3) Find big directories:

    du -xh --max-depth=1 /

4) Drill down until you find the cause.

5) Check for deleted-but-open files:

    sudo lsof | grep deleted

6) Fix the root cause, not just the symptom.

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Full disk survey

    df -hT
    df -i
    du -xh --max-depth=1 /

DRILL 2: Find top consumers

    du -xh --max-depth=1 /var
    du -xh --max-depth=1 /home

DRILL 3: Find large files

    find / -xdev -type f -size +500M 2>/dev/null

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Use df to assess filesystem usage
- Use df -i to diagnose inode exhaustion
- Use du to find where space is going
- Find large files
- Diagnose “space missing” scenarios (deleted-but-open files, mount hiding)
- Explain the difference between filesystem usage and directory usage

--------------------------------------------------------------------
