# mounting-and-fstab.md
LFCS Day 3 — Filesystems & Storage

Goal: Mount and unmount filesystems safely, understand mount options, and make mounts persistent using /etc/fstab.

--------------------------------------------------------------------

MENTAL MODEL

- A filesystem exists on a device or partition.
- Mounting attaches that filesystem to a directory (the mount point).
- Linux has one directory tree rooted at /.
- Mounting grafts a filesystem into that tree.
- Unmounting detaches it.
- /etc/fstab defines what should be mounted automatically (usually at boot).

--------------------------------------------------------------------

MOUNT POINTS

A mount point is just a directory.

Create one:

    sudo mkdir -p /mnt/data

Good conventions:

- /mnt = temporary or admin mounts
- /media = removable media
- /home, /boot, /var = often separate filesystems on real systems

--------------------------------------------------------------------

BASIC MOUNTING (MANUAL)

Mount by device:

    sudo mount /dev/sdb1 /mnt/data

Mount by UUID (preferred):

    sudo mount UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/data

Mount by LABEL:

    sudo mount LABEL=DATA /mnt/data

Let mount auto-detect filesystem type whenever possible.

--------------------------------------------------------------------

MOUNT WITH EXPLICIT FILESYSTEM TYPE

Sometimes needed:

    sudo mount -t ext4 /dev/sdb1 /mnt/data
    sudo mount -t xfs  /dev/sdb1 /mnt/data
    sudo mount -t vfat /dev/sdb1 /mnt/usb

--------------------------------------------------------------------

MOUNT OPTIONS

Specify options:

    sudo mount -o ro,noexec,nosuid,nodev /dev/sdb1 /mnt/data

Common options:

- defaults = rw, suid, dev, exec, auto, nouser, async
- ro = read only
- rw = read/write
- noexec = do not allow binaries to execute
- nosuid = ignore setuid/setgid bits
- nodev = do not allow device files
- nofail = do not fail boot if missing
- x-systemd.automount = mount on first access

--------------------------------------------------------------------

VERIFYING MOUNTS

Show all mounts:

    findmnt

Check a specific mount:

    findmnt /mnt/data

Filesystem view:

    df -hT /mnt/data

--------------------------------------------------------------------

UNMOUNTING

Unmount by mount point:

    sudo umount /mnt/data

Unmount by device:

    sudo umount /dev/sdb1

Lazy unmount (detach now, clean up later):

    sudo umount -l /mnt/data

Force unmount (dangerous, last resort):

    sudo umount -f /mnt/data

--------------------------------------------------------------------

"TARGET IS BUSY" — HOW TO FIX

Find who is using it:

    sudo lsof +f -- /mnt/data
    sudo fuser -vm /mnt/data

Kill offending processes (careful):

    sudo fuser -km /mnt/data

Common causes:

- A shell is cd’d into the directory
- A process has files open there
- A service is using the mount

--------------------------------------------------------------------

LOOP MOUNTS (ISO FILES)

Mount an ISO:

    sudo mkdir -p /mnt/iso
    sudo mount -o loop file.iso /mnt/iso

Unmount:

    sudo umount /mnt/iso

--------------------------------------------------------------------

TMPFS (RAM FILESYSTEM)

Mount a RAM-backed filesystem:

    sudo mount -t tmpfs -o size=256m tmpfs /mnt/ramdisk

Check:

    df -hT /mnt/ramdisk

--------------------------------------------------------------------

WHAT /etc/fstab IS

/etc/fstab is a configuration file describing:

- What to mount
- Where to mount it
- What filesystem type
- With what options
- In what order to check it

It is read by mount/systemd at boot and when you run mount -a.

--------------------------------------------------------------------

FSTAB FORMAT

One line per filesystem:

    <source>  <mountpoint>  <fstype>  <options>  <dump>  <pass>

Example:

    UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  /mnt/data  ext4  defaults  0  2

Fields:

- source: device, UUID=, or LABEL=
- mountpoint: directory
- fstype: ext4, xfs, vfat, etc.
- options: mount options
- dump: almost always 0
- pass: fsck order (0, 1, or 2)

--------------------------------------------------------------------

WHY UUID IS PREFERRED

Device names like /dev/sdb1 can change across boots.

UUIDs are stable.

Always get UUID with:

    blkid
    lsblk -f

--------------------------------------------------------------------

VALIDATING FSTAB SAFELY

After editing /etc/fstab:

    sudo mount -a

If there is a syntax error, it will tell you.

Always run this before rebooting.

Verify:

    findmnt /mnt/data

--------------------------------------------------------------------

BOOT-TIME FAILURE SAFETY

If a disk might not always be present, use:

    nofail

Example:

    UUID=xxxx  /mnt/usb  vfat  defaults,nofail  0  0

This prevents boot from failing if the device is missing.

--------------------------------------------------------------------

FSCK ORDER FIELD (PASS)

- 0 = never check
- 1 = root filesystem
- 2 = other local filesystems

Typical:

    UUID=root  /      ext4  defaults  0  1
    UUID=data  /data  ext4  defaults  0  2

--------------------------------------------------------------------

NETWORK FILESYSTEMS (CONCEPTUAL)

NFS:

    sudo mount -t nfs server:/export /mnt/nfs

SMB/CIFS:

    sudo apt-get update
    sudo apt-get install -y cifs-utils
    sudo mount -t cifs //server/share /mnt/smb -o username=USER

--------------------------------------------------------------------

SAFE WORKFLOW FOR ADDING A PERMANENT DISK

1) Inspect:

    lsblk -f
    blkid

2) Create mount point:

    sudo mkdir -p /mnt/data

3) Test mount manually:

    sudo mount UUID=xxxx /mnt/data

4) Verify:

    findmnt /mnt/data

5) Add to /etc/fstab

6) Test:

    sudo umount /mnt/data
    sudo mount -a
    findmnt /mnt/data

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Manual mount and unmount

    sudo mkdir -p /mnt/drill
    sudo mount /dev/sdb1 /mnt/drill
    findmnt /mnt/drill
    sudo umount /mnt/drill

DRILL 2: Busy mount

    sudo mount /dev/sdb1 /mnt/drill
    cd /mnt/drill
    sudo umount /mnt/drill   (should fail)
    sudo fuser -vm /mnt/drill
    cd /
    sudo umount /mnt/drill

DRILL 3: fstab entry

    blkid /dev/sdb1
    sudo vi /etc/fstab
    sudo mount -a
    findmnt

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Mount and unmount filesystems correctly
- Diagnose and fix "target is busy"
- Write correct /etc/fstab entries using UUID
- Validate fstab safely
- Explain mount options and fsck order

--------------------------------------------------------------------
