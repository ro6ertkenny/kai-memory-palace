# filesystem-troubleshooting.md
LFCS Day 3 — Filesystems & Storage

Goal: Diagnose and recover from filesystem problems: mount failures, read-only remounts, fsck workflows, superblock issues, and common failure modes.

--------------------------------------------------------------------

MENTAL MODEL

- Filesystem problems usually appear as:
  - Won’t mount
  - Mounts read-only
  - I/O errors
  - Boot drops to emergency shell
  - “Bad superblock” errors
- The kernel will protect data by remounting filesystems read-only.
- Repair tools assume the filesystem is NOT mounted.

--------------------------------------------------------------------

FIRST RESPONSE CHECKLIST

When something is wrong:

1) What failed?

    mount
    findmnt

2) What does the kernel say?

    dmesg | tail -n 50

3) What filesystem is it?

    lsblk -f
    blkid

4) Is it mounted?

    findmnt /mount/point
    findmnt | grep sdb

Never run repair tools on a mounted filesystem.

--------------------------------------------------------------------

COMMON SYMPTOMS AND MEANINGS

"Read-only filesystem":
- Kernel detected an error and remounted it RO
- You must unmount and repair

"Bad superblock":
- Primary superblock is damaged
- Backup superblocks may exist (ext filesystems)

"Target is busy":
- Some process is using the mount
- You must find and stop it

Boot drops to emergency shell:
- Usually a failed mount from /etc/fstab
- Or a corrupted root or critical filesystem

--------------------------------------------------------------------

DETERMINING IF A FILESYSTEM IS SAFE TO REPAIR

It must NOT be mounted:

    findmnt /dev/sdb1
    lsblk -f

If it shows a mountpoint: DO NOT fsck it.

Unmount it first:

    sudo umount /dev/sdb1

If it is the root filesystem, use recovery or boot-time repair.

--------------------------------------------------------------------

FSCK — THE GENERIC FRONTEND

fsck calls the filesystem-specific checker.

Basic check:

    sudo fsck /dev/sdb1

Force check even if marked clean:

    sudo fsck -f /dev/sdb1

Auto-answer yes (dangerous):

    sudo fsck -y /dev/sdb1

--------------------------------------------------------------------

EXT FILESYSTEM REPAIR (ext4, ext3, ext2)

Use e2fsck explicitly:

    sudo e2fsck -f /dev/sdb1

If superblock error:

1) Find backup superblocks:

    sudo mke2fs -n /dev/sdb1
    or
    sudo dumpe2fs /dev/sdb1 | grep -i superblock

2) Use alternate superblock:

    sudo e2fsck -b 32768 /dev/sdb1

Repeat with another backup if needed.

--------------------------------------------------------------------

XFS FILESYSTEM REPAIR

XFS does not use fsck for repair.

Dry run:

    sudo xfs_repair -n /dev/sdb1

Actual repair:

    sudo xfs_repair /dev/sdb1

If it says the log needs replay:
- Mount it once (if possible), then unmount, then run xfs_repair again.

--------------------------------------------------------------------

NEVER REPAIR A MOUNTED FILESYSTEM

Why:
- The kernel is modifying metadata while you are repairing it.
- This can cause massive corruption.

Only exception:
- Root filesystem during early boot or via recovery mode.

--------------------------------------------------------------------

REPAIRING THE ROOT FILESYSTEM

You cannot normally unmount /.

Options:

- Boot into recovery mode
- Or force a check on next boot:

    sudo touch /forcefsck
    sudo reboot

On ext filesystems you can also:

    sudo tune2fs -c 1 /dev/sda1

--------------------------------------------------------------------

FSTAB-RELATED BOOT FAILURES

Symptom:
- Boot drops to emergency shell
- Complains about a mount

Fix:

1) Boot into emergency or recovery shell
2) Edit fstab:

    mount -o remount,rw /
    vi /etc/fstab

3) Comment out the bad line
4) Reboot

Always validate fstab before rebooting:

    sudo mount -a

--------------------------------------------------------------------

BUSY MOUNTS

Find who is using it:

    sudo lsof +f -- /mnt/data
    sudo fuser -vm /mnt/data

Kill them (careful):

    sudo fuser -km /mnt/data

Common cause:
- A shell is cd’d into the directory
- A service is using it

--------------------------------------------------------------------

READ-ONLY REMOUNTS

Check:

    mount | grep ' ro,'

Check kernel messages:

    dmesg | tail -n 50

Workflow:

1) Unmount filesystem
2) Run fsck or xfs_repair
3) Re-mount
4) Verify it is read-write

--------------------------------------------------------------------

HIDDEN DATA DUE TO MOUNTING OVER DIRECTORIES

Symptom:
- “My files disappeared”

Cause:
- You mounted something over a non-empty directory

Fix:

    sudo umount /mnt/data
    ls /mnt/data   (your old files are still there)

--------------------------------------------------------------------

HARDWARE OR I/O ERRORS

Check:

    dmesg | grep -i error
    dmesg | grep -i i/o

If you see repeated I/O errors:
- The disk may be failing
- Filesystem repair may not be enough

--------------------------------------------------------------------

REAL-WORLD RECOVERY FLOW (EXT4)

1) Identify device:

    lsblk -f

2) Ensure unmounted:

    sudo umount /dev/sdb1

3) Repair:

    sudo e2fsck -f /dev/sdb1

4) If superblock error:
   - Find backups
   - Use -b alternate

5) Mount and verify:

    sudo mount /dev/sdb1 /mnt/test
    dmesg | tail

--------------------------------------------------------------------

REAL-WORLD RECOVERY FLOW (XFS)

1) Ensure unmounted
2) Dry run:

    sudo xfs_repair -n /dev/sdb1

3) Real repair:

    sudo xfs_repair /dev/sdb1

4) Mount and verify

--------------------------------------------------------------------

LFCS DRILLS

DRILL 1: Simulate and inspect

- Pick a non-critical test filesystem
- Run:

    sudo fsck -f /dev/sdb1

- Observe output

DRILL 2: Superblock discovery (do not corrupt disk)

    sudo mke2fs -n /dev/sdb1
    sudo dumpe2fs /dev/sdb1 | grep -i superblock

DRILL 3: fstab failure recovery (in VM)

- Add a bad entry to fstab
- Reboot
- Recover and fix it

--------------------------------------------------------------------

EXAM STANDARD

You must be able to:

- Diagnose mount failures using dmesg, lsblk, findmnt
- Determine if a filesystem is safe to repair
- Use fsck/e2fsck for ext filesystems
- Use xfs_repair for XFS
- Recover from bad fstab entries
- Explain read-only remounts and busy mounts
- Understand superblocks and backup superblocks

--------------------------------------------------------------------
