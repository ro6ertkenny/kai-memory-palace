# Lab - Filesystem Features and Mount Options

## Task:

We have /dev/vda1 mounted in /.
What are the mount options used with /dev/vda1?

Example: rw or ro, logbufs, logbsize, etc.
Identify all those options for /dev/vda1 and save them in the /root/moptions file.

Verify the mount options.

<details><summary>Answer</summary>
Execute the below command:

#### findmnt /dev/vda1

Copy the output under OPTIONS and save that in the /root/moptions file:

#### vi /root/moptions

Its content should be something like:

#### rw,relatime,discard,errors=remount-ro

### Explanation:
- findmnt → show mounted filesystems and options
- /dev/vda1 → target device
- OPTIONS → mount options used
- vi → manually save values
- /root/moptions → destination file

</details>

---

## Task:

Unmount /dev/vdd1 from the /mnt/directory.

Is "/mnt" unmounted?

<details><summary>Answer</summary>
Execute the below command:

#### umount /mnt

If the user is not root, you need to use the command with sudo.

### Explanation:
- umount → unmount filesystem
- /mnt → mount point
- sudo → required if not root

</details>

---

## Task:

Mount /dev/vdd1 back into the /mnt/ directory. But this time, use these mount options: ro,noexec,nosuid.

Verify the "/mnt" mount

<details><summary>Answer</summary>
Execute the below command:

#### mount -o ro,noexec,nosuid /dev/vdd1 /mnt

If the user is not root, you need to use the command with sudo.

### Explanation:
- mount → attach filesystem
- -o → specify mount options
- ro → read-only
- noexec → prevent execution of binaries
- nosuid → ignore setuid/setgid bits
- /dev/vdd1 → source device
- /mnt → mount point

</details>

---

## Task:

/dev/vdd1 is currently mounted with the rooption, so it's read-only. Remount it with the rw option so it becomes read-write.

Verify the "/mnt" mount

<details><summary>Answer</summary>
Execute the below command:

#### mount -o remount,rw /dev/vdd1 /mnt

If the user is not root, you need to use the command with sudo.

### Explanation:
- mount → manage mounts
- -o remount → modify existing mount
- rw → read-write mode
- /dev/vdd1 → target device
- /mnt → mount point

</details>

---

## Task:

Edit /etc/fstab so that the ext4 filesystem on /dev/vdd1 is automatically mounted into /mnt at boot time.
But also make sure that this filesystem is mounted as read-only. Otherwise said, use these two mount options: defaults and ro.

Verify the required changes.

<details><summary>Answer</summary>
Edit /etc/fstab file:

#### vi /etc/fstab

Add below given line in it:

#### /dev/vdd1 /mnt ext4 defaults,ro 0 2

### Explanation:
- /etc/fstab → filesystem configuration file
- /dev/vdd1 → device
- /mnt → mount point
- ext4 → filesystem type
- defaults,ro → default options plus read-only
- 0 → dump setting
- 2 → fsck order

Old backup tool:

    dump
    0 = ignore backups

## 🔥 What is the `2` (fsck order)?

Controls:

> filesystem check order at boot

## Values

    0 → never check  
    1 → check FIRST (root `/`)  
    2 → check AFTER root

## Are `0 2` Even Necessary Here?

## 🧠 Short Answer

> ❌ Not required for the task  
> ✅ But REQUIRED for a valid `/etc/fstab` entry  

## 🔥 Key Insight

In `/etc/fstab`, EVERY line must have:

    6 fields

## Format

    device  mountpoint  type  options  dump  fsck

## So You MUST Include:

    0 2

👉 even if the task doesn’t care about them


## 🧠 Mental Model (for the spaces vs commas):

In `/etc/fstab`:

fields are separated by:

    spaces

options inside one field are separated by:

    commas

## 🔁 Memory Hook

    spaces separate fields  
    commas separate options

## 🔁 1-Line Recall

    defaults,ro

✅ no space after comma



</details>
