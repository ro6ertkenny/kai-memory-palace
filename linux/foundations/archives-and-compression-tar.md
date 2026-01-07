# archives-and-compression-tar.md
Foundations — Archives, Compression, and tar

Goal: Confidently create, inspect, extract, and compress archives using tar, and understand what happens to files and metadata in the process.

Mental mode: Package → Inspect → Verify → Restore

--------------------------------------------------------------------

SCOPE

This document covers:

- what an archive is vs what compression is
- using tar to create, list, and extract archives
- gzip and xz compression with tar
- preserving permissions and ownership
- safe inspection-first workflows

Not covered here:

- filesystem-level backups or snapshots
- block-level imaging
- advanced compression tuning

--------------------------------------------------------------------

ARCHIVES VS COMPRESSION

Important distinction:

- An archive bundles many files into one file.
- Compression reduces the size of data.

tar by itself:
- creates archives
- does NOT compress unless you tell it to

gzip / xz:
- compress data
- usually used together with tar

That is why you often see:

- .tar      = archive only
- .tar.gz   = tar + gzip
- .tar.xz   = tar + xz

--------------------------------------------------------------------

BASIC TAR CONCEPTS

tar works on trees of files and directories.

Core modes:

- c = create
- t = list
- x = extract
- f = file (use a file, not stdin/stdout)

You almost always combine them.

--------------------------------------------------------------------

CREATING ARCHIVES

Create an uncompressed archive:

    tar -cf backup.tar mydir/

Create gzip-compressed archive:

    tar -czf backup.tar.gz mydir/

Create xz-compressed archive:

    tar -cJf backup.tar.xz mydir/

Mnemonic:

- c = create
- z = gzip
- J = xz
- f = file

--------------------------------------------------------------------

LISTING ARCHIVE CONTENTS (INSPECT FIRST)

Always inspect before extracting:

    tar -tf backup.tar
    tar -tf backup.tar.gz
    tar -tf backup.tar.xz

This shows:

- paths inside the archive
- what will be created on disk

Never extract a tar you have not listed.

--------------------------------------------------------------------

EXTRACTING ARCHIVES

Extract into current directory:

    tar -xf backup.tar
    tar -xf backup.tar.gz
    tar -xf backup.tar.xz

Extract into a specific directory:

    tar -xf backup.tar -C /target/dir

Rule:

- Always control where extraction happens.

--------------------------------------------------------------------

VERBOSE MODE

Add -v to see what tar is doing:

    tar -cvf backup.tar mydir/
    tar -xvf backup.tar

This prints every file as it is processed.

--------------------------------------------------------------------

COMPRESSION FORMATS

gzip:

- fast
- moderate compression
- very common

    tar -czf backup.tar.gz mydir/

xz:

- slower
- better compression
- common for large archives

    tar -cJf backup.tar.xz mydir/

--------------------------------------------------------------------

PRESERVING PERMISSIONS AND OWNERSHIP

By default, tar:

- stores permissions
- stores ownership
- stores timestamps

When extracting:

- if you are root, tar will try to restore ownership
- if you are not root, ownership restoration may fail (expected)

Important flags:

    -p   preserve permissions (when extracting, as root)

Example:

    sudo tar -xpf backup.tar

--------------------------------------------------------------------

COMMON MISTAKES

- Extracting in the wrong directory
- Forgetting -f (and writing to stdout)
- Not listing contents first
- Accidentally creating archives with absolute paths
- Overwriting existing files silently

--------------------------------------------------------------------

ABSOLUTE PATH WARNING

If an archive contains absolute paths like:

    /etc/passwd

Extracting as root could overwrite system files.

Always inspect first:

    tar -tf archive.tar

If you see leading / paths, be very careful.

--------------------------------------------------------------------

CREATING CLEAN ARCHIVES

Prefer relative paths:

Good:

    tar -czf backup.tar.gz mydir/

Not ideal:

    tar -czf backup.tar.gz /home/user/mydir

Reason:

- Relative paths restore cleanly anywhere.

--------------------------------------------------------------------

CHECKING ARCHIVE SIZE

    ls -lh *.tar*

Compare:

- uncompressed .tar
- compressed .tar.gz or .tar.xz

This helps you understand compression impact.

--------------------------------------------------------------------

PIPELINE STYLE (ADVANCED, OPTIONAL)

You may see:

    tar -cf - mydir | gzip > backup.tar.gz

Or:

    tar -cf - mydir | xz > backup.tar.xz

This is equivalent to -czf and -cJf, just more explicit.

For LFCS, the short forms are enough.

--------------------------------------------------------------------

SAFE WORKFLOW

1) Create archive:

    tar -czf backup.tar.gz mydir/

2) List it:

    tar -tf backup.tar.gz

3) Create restore directory:

    mkdir /tmp/restore-test

4) Extract into it:

    tar -xf backup.tar.gz -C /tmp/restore-test

5) Verify contents:

    ls /tmp/restore-test

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Create and inspect

    mkdir testdir
    touch testdir/a testdir/b testdir/c
    tar -czf test.tar.gz testdir
    tar -tf test.tar.gz

DRILL 2: Extract elsewhere

    mkdir restore
    tar -xf test.tar.gz -C restore
    ls restore

DRILL 3: Compare compression

    tar -cf test.tar testdir
    tar -czf test.tar.gz testdir
    tar -cJf test.tar.xz testdir
    ls -lh test.tar*

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Create tar archives
- List contents before extracting
- Extract into a specific directory
- Use gzip and xz compression
- Explain the difference between archiving and compression
- Avoid overwriting files by extracting blindly

--------------------------------------------------------------------
