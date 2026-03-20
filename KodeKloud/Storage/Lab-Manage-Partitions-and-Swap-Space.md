# Lab - Manage Partitions and Swap Space

## Task:

How do we display block devices such as disks or partitions?

## Solution:

Using lsblk command, we can display block devices.


## Task:

How do we format a partition as swap space?

## Solution:

We can format a partition as swap space using the sudo mkswap /dev/vdb3 command where /dev/vdb3 is the partition we want to format.


## Task:

Identify the name of the virtual disk where / is mounted on this system.

Save the value (only the name without path) in the /root/part file.

Does the "/root/part" file have the required data?

## Solution:

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


## Task:

Find out the swapfile used on this system and save its exact path in the /root/swap file.

Does the "/root/swap" file have the required data as needed?

## Solution:

Execute the below command to identify the swapfile:

#### swapon --show

Look for the value under NAME and save it in a file as asked.

#### vi /root/swap

For example, if the value is /swapfile.img, then the file content should be:

#### /swapfile.img


## Task:

Create three primary partitions on /dev/vdd.

First should have 10MB, second should have 21MB and the third should have 15MB.

- Verify 10MB partition.

- Verify 21MB partition.

- Verify 15MB partition.

## Solution:

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


## Task:

Format the 21MB partition as swap. Next, make it active, and tell Linux to start using it as swap memory.

Is "21MB" partition formatted as "swap"?

## Solution:

Execute the below commands:

#### mkswap /dev/vdd2
#### swapon /dev/vdd2

You can validate with:

#### swapon --show

If the user is not root, you need to use the commands with sudo.


## Task:

Tell Linux to stop using the 21MB partition as swap.

Has Linux stopped using "21MB" partition as "swap"?

## Solution:

Execute the below command:

#### swapoff /dev/vdd2

You can validate with:

#### swapon --show

If the user is not root, you need to use the command with sudo.


## Task:

Resize the /dev/vdd3 partition (which you created earlier) to 21MB.

Has the "/dev/vdd3" partition been resized to "21MB"?

## Solution:

Run the below command:

#### cfdisk /dev/vdd

If the user is not root, you need to use the command with sudo.

You will see some details as below (it can vary from one system to another):

Device             Boot                  Start            End        Sectors         Size        Id Type
>>  Free space                                2048          22527          20480          10M                             
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



