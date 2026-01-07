# 🔍 system-inspection.md
Foundations — Inspecting System State Before Acting

Mental mode: Observing reality before changing it.

Goal: Build fast, accurate situational awareness of a Linux system using inspection-only commands before taking any action.

--------------------------------------------------------------------

SCOPE

This document defines how to inspect a Linux system’s current state:

- CPU
- memory
- disk and filesystems
- mounts
- network
- processes
- kernel signals

This is about:

- understanding what is happening
- not changing state
- not fixing yet

This is your **diagnostic dashboard**.

--------------------------------------------------------------------

THE PRIME DIRECTIVE

> Never change state before you understand state.

Before you fix anything, you should be able to explain:

- who you are
- what system this is
- what is mounted
- what is full
- what resource is under pressure
- what the kernel is complaining about

--------------------------------------------------------------------

IDENTITY AND BASELINE

Who am I?

    whoami
    id

What system is this?

    hostnamectl

What kernel and architecture?

    uname -a

What OS?

    cat /etc/os-release

Uptime and load:

    uptime

Load averages represent runnable processes over time.

--------------------------------------------------------------------

CPU INSPECTION

Quick live view:

    top

What matters:

- %us → user processes
- %sy → kernel work
- %id → idle time
- load average vs number of CPU cores

Number of cores:

    nproc

Rule of thumb:

- High load with low CPU usage often indicates IO wait.

--------------------------------------------------------------------

MEMORY INSPECTION

Human-readable summary:

    free -h

What to look for:

- available memory (not just free)
- swap usage

Kernel view:

    cat /proc/meminfo | head

Rule:

- Swap pressure often explains slow systems with low CPU usage.

--------------------------------------------------------------------

FILESYSTEMS AND DISK USAGE

Filesystem usage:

    df -hT
    df -hi

Block devices and layout:

    lsblk -f

Directory-level usage:

    du -xh --max-depth=1 / 2>/dev/null

Common failure:

- Disk full causes many unrelated services to fail.

--------------------------------------------------------------------

MOUNTS AND STORAGE CONTEXT

What is mounted?

    findmnt

What backs a specific path?

    df -hT /some/path

This is **situational awareness**, not surgery.

For real storage operations, go to:

    linux/filesystems-and-storage/

--------------------------------------------------------------------

DISK IO PRESSURE

Check IO wait in:

    top

Look for:

- high load
- low CPU usage
- blocked processes

Disk issues often masquerade as “random slowness”.

--------------------------------------------------------------------

FILES AND METADATA (SPOT CHECKS)

When a file behaves strangely:

    ls -l
    stat file
    stat -f /some/path
    realpath target

Use this when:

- timestamps seem wrong
- size vs disk usage is confusing
- you need inode-level truth

--------------------------------------------------------------------

NETWORK INSPECTION

Interfaces and addresses:

    ip a

Routing:

    ip r

Listening ports and owners:

    ss -tulpen

DNS:

    resolvectl status
    or
    cat /etc/resolv.conf

Connectivity test:

    ping -c 3 1.1.1.1

--------------------------------------------------------------------

PROCESS-LEVEL CORRELATION

Find heavy consumers:

    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head

Correlate:

- process
- user
- service
- resource usage

--------------------------------------------------------------------

KERNEL AND HARDWARE SIGNALS

Recent kernel messages:

    dmesg | tail -n 50

Search for errors:

    dmesg | grep -i error
    dmesg | grep -i i/o

Critical for:

- disk problems
- filesystem read-only remounts
- driver and hardware issues

--------------------------------------------------------------------

TIME AND CLOCK

Check system time:

    date

Time drift breaks:

- TLS
- certificates
- cluster coordination

Always verify time sanity early.

--------------------------------------------------------------------

INSPECTION DISCIPLINE (ORDER OF OPERATIONS)

Always inspect in this order:

1) uptime / load
2) CPU
3) memory
4) disk usage
5) mounts
6) network
7) processes
8) kernel messages

Skipping steps leads to false conclusions.

--------------------------------------------------------------------

REAL-WORLD INSPECTION CHECKLIST

When “something is wrong”:

    whoami
    id
    hostnamectl
    uptime
    free -h
    df -hT
    df -hi
    findmnt
    lsblk -f
    du -xh --max-depth=1 /
    top
    dmesg | tail

Only after this should you attempt fixes.

--------------------------------------------------------------------

PHILOSOPHY

- Inspection is cheap.
- Mistakes are expensive.
- You cannot debug what you cannot see.

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Inspect system state without changing it
- Use df/du/findmnt/lsblk/stat appropriately
- Use dmesg to identify kernel-level issues
- Correlate CPU, memory, disk, and process pressure
- Build a correct mental picture before acting

--------------------------------------------------------------------
