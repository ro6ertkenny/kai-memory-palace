# Lab - Manage Partitions and Swap Space

## Task:

How do we display block devices such as disks or partitions?

<details><summary>Answer</summary>
Using lsblk command, we can display block devices.

#### lsblk

### Explanation:
- lsblk → list block devices
- shows disks, partitions, mount points, and sizes

</details>

---

## Task:

How do we format a partition as swap space?

<details><summary>Answer</summary>
We can format a partition as swap space using the sudo mkswap /dev/vdb3 command where /dev/vdb3 is the partition we want to format.

#### sudo mkswap /dev/vdb3

### Explanation:
- mkswap → create swap filesystem
- /dev/vdb3 → target partition
- sudo → run with elevated privileges

## If LFCS Asks About Swap — What Do You Look For?

## 🧠 Short Answer

> For **formatting** swap:

You are looking for:

    a block device / partition

NOT a directory.

## 🔥 This:

    sudo mkswap /dev/vdb3

uses:

    /dev/vdb3

which is a device file.

## 🧠 Mental Model

    /dev = where block devices appear

## 🔍 If Asked “Find a Partition To Use For Swap”

Check:

## 1. List block devices
    lsblk

## 2. See partitions
    sudo fdisk -l

> `fdisk` = **fixed disk**

## 3. Check existing swaps
    swapon --show

## 🧪 Example

    lsblk

might show:

    vdb
    └─vdb3

👉 that might be the target:

    /dev/vdb3

## ⚠️ This Is NOT In A Directory Like

❌ not:

    /swap
    /var/swap

Those would be for swap FILES (different thing)

## 🔥 Two Different Things

## Swap Partition
Uses:

    /dev/vdb3

Create:
    mkswap /dev/vdb3

## Swap File
Uses:

    /swapfile

Create with:
    fallocate
    chmod
    mkswap /swapfile

Different object.

## 🧠 If LFCS Says “Partition”

Think immediately:

    /dev/...

## 🔁 Memory Hook

    swap partition → look in /dev

## ⚡ After Formatting (Important Next Steps)

Usually:

    sudo mkswap /dev/vdb3
    sudo swapon /dev/vdb3

And for persistence:

    /etc/fstab

> `/etc/fstab` = **file system table**

## 🔁 1-Line Recall

    If it says swap partition → look at block devices in /dev

## 🧨 Operator Insight

Exam pattern:

- identify device → `lsblk`
- format swap → `mkswap`
- enable swap → `swapon`

That’s the flow.

## Final Takeaway

If LFCS asks about swap partitions:

👉 look for devices under:

    /dev

using:

    lsblk

not a directory.

</details>

---

## Task:

Identify the name of the virtual disk where / is mounted on this system.

Save the value (only the name without path) in the /root/part file.

Does the "/root/part" file have the required data?

<details><summary>Answer</summary>
Execute the below command to list the partitions on this system:

#### lsblk

For MOUNTPOINT /, look for the partition; for example, if you see an output as below:

NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda                    252:0    0   10G  0 disk 
└─vda1                 252:1    0   10G  0 part /
vdb                    252:16   0    1G  0 disk 
vdc                    252:32   0    1G  0 disk 

vda1 is the partition in which / is mounted. Copy it and save in a file as asked

#### vi /root/part

The file content should be:

#### vda1

### Explanation:
- lsblk → display block devices and mount points
- MOUNTPOINT / → identifies root filesystem
- vda1 → partition where root is mounted
- vi → manually save value

✅ YES — you identify root (`/`) by the **MOUNTPOINT column**

## 🔍 Your Output (Reformatted)

    NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
    vda    252:0   0  10G  0 disk
    └─vda1 252:1   0  10G  0 part /
    vdb    252:16  0   1G  0 disk
    vdc    252:32  0   1G  0 disk

## 🧠 How You Know Root

Look at:

    MOUNTPOINT

## This line:

    └─vda1 ... /

👉 means:

> `/` (root filesystem) is mounted on:

    vda1


> What does `0 disk` mean?

### Column 1: `RM`

    RM = removable

## Value:

    0 = NOT removable  
    1 = removable (like USB)

## 🔍 Column: `TYPE`

    disk = whole disk  
    part = partition  

## 🧠 So:

    vdb  252:16  0  1G  0  disk

means:

- `0` → not removable  
- `disk` → whole disk (not partitioned or no partitions shown)

## 🔥 Important Distinction

## `vda`

    disk → whole disk

## `vda1`

    part → partition on that disk

## 🧠 Mental Model

    disk = entire drive  
    part = slice of drive  

## 🔁 Memory Hook

    RM 0 = fixed disk  
    TYPE disk = whole device  
    TYPE part = partition  

## 🔁 1-Line Recall

    `0` means “not removable,” and `disk` means it’s a whole drive (not a partition).

</details>

---

## Task:

Find out the swapfile used on this system and save its exact path in the /root/swap file.

Does the "/root/swap" file have the required data as needed?

<details><summary>Answer</summary>
Execute the below command to identify the swapfile:

#### swapon --show

Look for the value under NAME and save it in a file as asked.

#### vi /root/swap

For example, if the value is /swapfile.img, then the file content should be:

#### /swapfile.img

### Explanation:
- swapon --show → list active swap devices/files
- NAME → shows swap file or partition path
- vi → manually save value

## Regarding my question about why a .img file ... and Kia said "even this ..."

    /banana

(yes, really 😄)

## 🧠 Linux Does NOT Care About Extensions

Just like:

    env > myfile

doesn’t need:

    myfile.txt

Same idea.

## 🔍 What Makes It A Swap File?

NOT the name.

NOT `.img`.

👉 This makes it swap:

    mkswap /swapfile.img

and then:

    swapon /swapfile.img

## 🧠 Mental Model

    name does not define function  
    formatting does

## ❓Why Use `.img` Then?

Usually because:

> people think of it as a disk image file

## 🔥 Before `mkswap`

Suppose you create a file:

    sudo fallocate -l 1G /swapfile

👉 right now it is just:

> an ordinary file

Nothing special yet.

## 🔍 Breakdown

    fallocate   → allocate space for a file  
    -l          → length (how much space)  
    1G          → 1 gigabyte  
    /swapfile   → file to create/use

## 🔥 Then You Run

    sudo mkswap /swapfile

👉 NOW:

it is formatted as swap.

## 🧠 That’s What I Meant

    name does not define function  
    formatting does

</details>

---

## Task:

Create three primary partitions on /dev/vdd.

First should have 10MB, second should have 21MB and the third should have 15MB.

- Verify 10MB partition.

- Verify 21MB partition.

- Verify 15MB partition.

<details><summary>Answer</summary>
Follow the below given steps:

#### fdisk /dev/vdd

If the user is not root, you need to use the command with sudo.

Now, enter below given responses:

    Command (m for help): n
    Select (default p):  <just-leave-it-default-and-press-enter>
    Partition number (1-4, default 1): <just-leave-it-default-and-press-enter>
    First sector (2048-2097151, default 2048):  <just-leave-it-default-and-press-enter>
    Last sector, +sectors or +size{K,M,G,T,P} (2048-2097151, default 2097151): +10M
    Command (m for help): w

You can follow these same steps for all three partitions.

Further, you can verify the created partitions using the below command:

#### lsblk

### Explanation:
- fdisk → partition disk
- n → create new partition
- p → primary partition
- +10M / +21M / +15M → partition sizes
- w → write changes
- lsblk → verify partitions

## So:

    fdisk

≈ fixed disk utility

## What Are `m` and `n` in `fdisk`?

## 🧠 Short Answer

Inside interactive `fdisk`:

    m = menu (help)
    n = new partition

## 🔥 This:

    Command (m for help):

is a prompt.

It means:

> “Type a command here”

## 🧠 If You Type

    m

👉 `fdisk` shows menu/help:

- n → new partition  
- d → delete partition  
- p → print partition table  
- w → write changes  
- q → quit without saving

## 🔁 Memory Hook

    m = menu

(not “manual”)

## 🔥 What About `n`?

    n

means:

> new partition

## You type:

    n

and `fdisk` starts asking:

- primary or extended?  
- partition number?  
- size?  

## 🧠 Mental Model

    m = show choices

    n = make new slice

## 🔍 Your Flow

Start:

    sudo fdisk /dev/vdd

Prompt:

    Command (m for help):

Type:

    n

Then:

    Select (default p):

Type:

    p

(primary)

Then size:

    +10M

Then save:

    w

(write)

## ⚠️ What Is `w` Again?

    w = write

👉 commit changes to disk

Until `w`:

changes are mostly not committed.

## 🧪 Why They Keep Saying “m for help”

Because it is literally the prompt text built into fdisk.

It reminds you:

> if lost, press:

    m

## 🔁 1-Line Recall

    m = menu  
    n = new  
    w = write

## 🧨 Operator Insight

These three alone get you through many basic LFCS fdisk tasks.

## Final Takeaway

In `fdisk`:

    m → show help/menu  
    n → create new partition

</details>

---

## Task:

Format the 21MB partition as swap. Next, make it active, and tell Linux to start using it as swap memory.

Is "21MB" partition formatted as "swap"?

<details><summary>Answer</summary>
Execute the below commands:

#### mkswap /dev/vdd2
#### swapon /dev/vdd2

You can validate with:

#### swapon --show

If the user is not root, you need to use the commands with sudo.

### Explanation:
- mkswap → format partition as swap
- swapon → enable swap
- /dev/vdd2 → target partition
- swapon --show → verify active swap

</details>

---

## Task:

Tell Linux to stop using the 21MB partition as swap.

Has Linux stopped using "21MB" partition as "swap"?

<details><summary>Answer</summary>
Execute the below command:

#### swapoff /dev/vdd2

You can validate with:

#### swapon --show

If the user is not root, you need to use the command with sudo.

### Explanation:
- swapoff → disable swap
- /dev/vdd2 → target partition
- swapon --show → confirm removal

</details>

---

## Task:

Resize the /dev/vdd3 partition (which you created earlier) to 21MB.

Has the "/dev/vdd3" partition been resized to "21MB"?

<details><summary>Answer</summary>
Run the below command:

#### cfdisk /dev/vdd

If the user is not root, you need to use the command with sudo.

You will see some details as below (it can vary from one system to another):

    Device             Boot                  Start            End        Sectors         Size        Id Type
    Free space                                2048          22527          20480          10M                             
    /dev/vdd2                                22528          65535          43008          21M        83 Linux
    /dev/vdd3                                65536         108543          43008          15M        83 Linux
    Free space                              108544        2097151        1988608         971M

Using arrow keys, select the partition you want to resize. In our case, it's /dev/vdd3. At the bottom, you will see some options as below:

#### [Bootable]  [ Delete ]  [ Resize ]  [  Quit  ]  [  Type  ]  [  Help  ]  [  Write ]  [  Dump  ]

Using arrow keys, select the Resize option and press Enter, adjust the size as needed. For example, in our case, we will set it to 21M and then press Enter again.

#### New size: 21M

Now, using arrow keys, select the Write option and press Enter. It will ask for the confirmation, so enter Yes and press Enter.

#### Are you sure you want to write the partition table to disk? yes

Now, using arrow keys, select the Quit option and press Enter. You are done!!

You can confirm your changes by listing the partitions using the lsblk command.

### Explanation:
- cfdisk → interactive partition editor
- Resize → adjust partition size
- 21M → new size
- Write → save changes
- lsblk → verify updated partition size

## 🧠 Mental Model

    fdisk  = command-line partition editor

    cfdisk = menu-driven partition editor
> **c = console menu for fixed disk editor (visual)**

</details>
