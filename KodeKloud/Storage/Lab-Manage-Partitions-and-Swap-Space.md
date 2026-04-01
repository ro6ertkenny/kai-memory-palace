# Manage Partitions and Swap Space — LFCS Lab (Hidden Answers)

---

## 🧪 Task

Task: How do we display block devices such as disks or partitions?

<details>
<summary>Answer</summary>

## Solution:

Using lsblk command, we can display block devices.

</details>

---

## 🧪 Task

Task: How do we format a partition as swap space?

<details>
<summary>Answer</summary>

## Solution:

We can format a partition as swap space using the sudo mkswap /dev/vdb3 command where /dev/vdb3 is the partition we want to format.

</details>

---

## 🧪 Task

Task: Identify the name of the virtual disk where / is mounted on this system.

Save the value (only the name without path) in the /root/part file.

Does the "/root/part" file have the required data?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command to list the partitions on this system:

    lsblk

For MOUNTPOINT /, look for the partition; for example, if you see an output as below:

NAME                   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda                    252:0    0   10G  0 disk 
└─vda1                 252:1    0   10G  0 part /
vdb                    252:16   0    1G  0 disk 
vdc                    252:32   0    1G  0 disk 

vda1 is the partition in which / is mounted. Copy it and save in a file as asked

    vi /root/part

The file content should be:

    vda1

</details>

---

## 🧪 Task

Task: Find out the swapfile used on this system and save its exact path in the /root/swap file.

Does the "/root/swap" file have the required data as needed?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command to identify the swapfile:

    swapon --show

Look for the value under NAME and save it in a file as asked.

    vi /root/swap

For example, if the value is /swapfile.img, then the file content should be:

    /swapfile.img

</details>

---

## 🧪 Task

Task: Create three primary partitions on /dev/vdd.

First should have 10MB, second should have 21MB and the third should have 15MB.

- Verify 10MB partition.

- Verify 21MB partition.

- Verify 15MB partition.

<details>
<summary>Answer</summary>

## Solution:

Follow the below given steps:

    fdisk /dev/vdd

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

    lsblk

</details>

---

## 🧪 Task

Task: Format the 21MB partition as swap. Next, make it active, and tell Linux to start using it as swap memory.

Is "21MB" partition formatted as "swap"?

<details>
<summary>Answer</summary>

## Solution:

Execute the below commands:

    mkswap /dev/vdd2
    swapon /dev/vdd2

You can validate with:

    swapon --show

If the user is not root, you need to use the commands with sudo.

</details>

---

## 🧪 Task

Task: Tell Linux to stop using the 21MB partition as swap.

Has Linux stopped using "21MB" partition as "swap"?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

    swapoff /dev/vdd2

You can validate with:

    swapon --show

If the user is not root, you need to use the command with sudo.

</details>

---

## 🧪 Task

Task: Resize the /dev/vdd3 partition (which you created earlier) to 21MB.

Has the "/dev/vdd3" partition been resized to "21MB"?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

    cfdisk /dev/vdd

If the user is not root, you need to use the command with sudo.

Using arrow keys, select the partition you want to resize.

Choose Resize → set size to 21M → Write → Yes → Quit

Verify with:

    lsblk

</details>
