# Lab - Create Filesystems and Mount Them at Boot

## Task:

What file do we need to edit to tell the Linux OS which filesystems it should automatically mount when it boots up?

<details><summary>Answer</summary>
We will need to edit /etc/fstab file to tell the Linux OS which filesystems it should automatically mount when it boots up.

### Explanation:
- /etc/fstab → filesystem table
- defines which filesystems mount at boot
- contains device, mount point, type, and options

## 🧠 Mental Model (this is here from searching my own OS and seeing the following directory)

    /dev/sda1         = real device name  
    /dev/disk/by-uuid = stable alias (points to it)

## 🔍 Why `/dev/sda1` Is NOT Always Used

Because:

> device names can CHANGE on reboot

Example:

    today:  /dev/sda  
    reboot: /dev/sdb

😬 bad if used in `/etc/fstab`

## 🔥 Why UUID Is Used

    UUID = Universally Unique Identifier

👉 never changes


</details>

---

## Task:

We want to create an xfs filesystem on /dev/vdd1 with the label BackupVolume. What is wrong with this command?

#### sudo mkfs.xfs -l "BackupVolume" /dev/vdd1

A. The volume name is too long. 10 characters is the maximum limit and we used 12.

B. The lowercase -l option is wrong. It should be -L, with an uppercase L.

C. The -l option should go at the end. The command should be: sudo mkfs.xfs /dev/vdd1 -l "BackupVolume".

D. The command mkfs.xfs is wrong. It should be mkfs-xfs.

<details><summary>Answer</summary>
The lowercase -l option is wrong. It should be -L, with an uppercase L

#### sudo mkfs.xfs -L "BackupVolume" /dev/vdd1

#### Explanation:
    mkfs.xfs      → make XFS filesystem  
    -L           → Label (uppercase L)  
    "BackupVolume" → filesystem label  
    /dev/vdd1    → target partition

</details>

---

## Task:

Create an xfs filesystem with the label "DataDisk" on /dev/vdd.

Is the required label set for the filesystem?

<details><summary>Answer</summary>
Execute the below command:

#### mkfs.xfs -L "DataDisk" /dev/vdd

If the user is not root, you need to use the command with sudo.

### Explanation:
- mkfs.xfs → create XFS filesystem
- -L "DataDisk" → assign label
- /dev/vdd → target device

</details>

---

## Task:

Create an ext4 filesystem with 2048 inodes on /dev/vde.

Is the required filesystem created?

<details><summary>Answer</summary>
Execute the below command:

#### mkfs.ext4 -N 2048 /dev/vde

If the user is not root, you need to use the command with sudo.

### Explanation:
- mkfs.ext4 → create ext4 filesystem
- -N 2048 → specify number of inodes
- /dev/vde → target device

## 🧠 What Is An Inode Again?

Think:

> an inode is metadata for a file

Every file consumes:
- one inode  
- plus data blocks

## 🔥 So `-N` Controls

How many files the filesystem can potentially track.

</details>

---

## Task:

Mount /dev/vdd in the /mnt/ directory.

Is the partition mounted?

<details><summary>Answer</summary>
Execute the below command:

#### mount /dev/vdd /mnt

If the user is not root, you need to use the command with sudo.

### Explanation:
- mount → attach filesystem
- /dev/vdd → source device
- /mnt → mount point directory

## Does This Mount Permanently?

> ❌ NO — this is a **temporary mount**

## 🔥 What It Does

It attaches:

    /dev/vdd

to this mount point:

    /mnt

for the current running system.

## 🧠 Mental Model

    device appears “under” /mnt

## ⚠️ But Only Until

- reboot  
- unmount  
- some system changes

Then it can disappear.

## 🔍 Why It Is NOT Permanent

Because:

> it does NOT write anything to:

    /etc/fstab

## 🔥 Permanent Mounts Use

    /etc/fstab

Example:

    /dev/vdd   /mnt   ext4   defaults   0 0

Then:

    sudo mount -a

to test it.

## 🧠 Mental Model

    mount command  = temporary

    fstab entry    = persistent

> ✅ `mount` = temporary (right now)  
> ✅ `/etc/fstab` = persistent (on boot)

## ⚠️ One More Important Thing

Usually you mount a filesystem/partition like:

    /dev/vdd1

(not whole disk `vdd`, unless special case)

Often:

    /dev/vdd
    └─ /dev/vdd1

You normally mount:

    /dev/vdd1

## 🔁 Memory Hook

    mount now = temporary

    fstab = forever

## 🔁 1-Line Recall

    `mount /dev/vdd /mnt` does NOT make it permanent.

</details>

---

## Task:

Unmount the filesystem mounted in the /mnt/ directory.

Is filesystem unmounted?

<details><summary>Answer</summary>
Execute the below command:

#### umount /mnt

If the user is not root, you need to use the command with sudo.

### Explanation:
- umount → detach filesystem
- /mnt → mount point being unmounted

> ✅ At any given moment → ONLY ONE filesystem can be mounted **on a specific mount point**

## 🔥 What That Means

    /mnt

can only point to:

    ONE mounted filesystem at a time

## 🧠 Mental Model

    mount point = doorway  
    filesystem  = what’s behind it  

👉 one doorway → one thing behind it

</details>

---

## Task:

Configure the system to automatically mount /dev/vde when it boots up. This partition has an ext4 filesystem on it. It should mount the filesystem to the /test directory. This directory does not exist. Make sure you create it first.

Also, make sure this filesystem is checked on boot.

For now, you do not need to reboot the system after making the required changes.

- Is the "/test" directory created?

- Is '/dev/vde' automatically mounted when system boots up?

<details><summary>Answer</summary>
First, create a directory using the following command:

#### mkdir /test

Edit the /etc/fstab file:

#### vi /etc/fstab

If the user is not root, you need to use the command with sudo.

Add this line in it:

#### /dev/vde /test ext4 defaults 0 2

Save and exit.

### Explanation:
- mkdir /test → create mount point
- /etc/fstab → define auto-mount configuration
- /dev/vde → device
- /test → mount point
- ext4 → filesystem type
- defaults → default mount options
- 0 → dump setting
- 2 → filesystem check order at boot

Linux reads:

    /etc/fstab

👉 and mounts everything listed there — it will automatically mount at boot  
👉 IF everything is correct

## ⚠️ Requirements (IMPORTANT)

For it to work:

## 1️⃣ Mount point must exist

    mkdir -p /test

> ✅ `-p` = **parents**

> create the directory AND any missing parent directories


## 2️⃣ Device must have a filesystem

    mkfs.ext4 /dev/vde


## 3️⃣ Device must exist at boot

👉 if it doesn’t → boot errors

</details>

---

## Task:

Configure the system to automatically use /dev/vdd as swap when it boots up.

For now, you do not need to reboot the system after making the required changes as this might affect the next task.

- Is required configuration done ?

<details><summary>Answer</summary>
Edit /etc/fstab file:

#### vi /etc/fstab

If the user is not root, you need to use the command with sudo.

Add this line in it:

#### /dev/vdd none swap defaults 0 0

Save and exit.

### Explanation:
- /etc/fstab → filesystem configuration file
- /dev/vdd → swap device
- none → no mount point
- swap → filesystem type
- defaults → default options
- 0 0 → skip dump and fsck

> `fsck` = **file system check**

## So:

    fsck

means:

> check and repair filesystems

## 🧪 Example

    sudo fsck /dev/vdd1

👉 check that filesystem for problems

## 🔥 Why It Appears In `/etc/fstab`

This part:

    0 0

are the last two fields.

## Field 5
    0

= dump backup flag

## Field 6
    0

= fsck check order

## 🧠 That Second Zero Means

    do NOT run fsck on boot

## ⚠️ Why For Swap?

Because:

> swap is NOT a normal filesystem like ext4

So:

❌ no fsck needed

## 🧠 Mental Model

    ext4 may need fsck

    swap does not

## 🔁 Memory Hook

    fsck = filesystem doctor 🩺

## 🧪 Example For Root Filesystem

Often:

    /dev/vda1 / ext4 defaults 0 1

That:

    1

means check it at boot.

## 🔁 1-Line Recall

    fsck = check/repair filesystem

and in:

    0 0

the last 0 means:

    skip fsck


## Kai's response to why was the 'none' issued in the command to not mount on boot:

## 🔥 Why `none`?

Because:

> swap is NOT something you mount like `/mnt`

👉 it’s attached to memory, not a directory

</details>

---

## Task:

Change the label for /dev/vdd filesystem to SwapFS

- Required label set for the filesystem?

<details><summary>Answer</summary>
Execute below given command:

#### xfs_admin -L "SwapFS" /dev/vdd

If the user is not root, you need to use the command with sudo.

### Explanation:
- xfs_admin → manage XFS filesystem parameters
- -L "SwapFS" → set new label
- /dev/vdd → target filesystem

🔥 Best Way - first to show the current FSTYPE & LABEL: 

✅ Use lsblk -f

    lsblk -f

## You can't just use the same command and replace the xfs w/and ext4:

## 🧠 Mental Model

    XFS   → xfs_admin  
    EXT4  → e2label / tune2fs  
    SWAP - mkswap

    each filesystem has its own tool

# 🔁 1-Line Recall

    You must use filesystem-specific tools: `xfs_admin` for XFS, `e2label/tune2fs` for ext4, and `mkswap` for swap.

</details>
