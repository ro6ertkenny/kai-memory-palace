# Lab - Create Filesystems and Mount Them at Boot

## Task:

What file do we need to edit to tell the Linux OS which filesystems it should automatically mount when it boots up?

## Solution:

We will need to edit /etc/fstab file to tell the Linux OS which filesystems it should automatically mount when it boots up.


## Task:

We want to create an xfs filesystem on /dev/vdd1 with the label BackupVolume. What is wrong with this command?

#### sudo mkfs.xfs -l "BackupVolume" /dev/vdd1

A. The volume name is too long. 10 characters is the maximum limit and we used 12.

B. The lowercase -l option is wrong. It should be -L, with an uppercase L.

C. The -l option should go at the end. The command should be: sudo mkfs.xfs /dev/vdd1 -l "BackupVolume".

D. The command mkfs.xfs is wrong. It should be mkfs-xfs.

## Solution:

The lowercase -l option is wrong. It should be -L, with an uppercase L


## Task:

Create an xfs filesystem with the label "DataDisk" on /dev/vdd.

Is the required label set for the filesystem?

## Solution:

Execute the below command:

#### mkfs.xfs -L "DataDisk" /dev/vdd

If the user is not root, you need to use the command with sudo.


## Task:

Create an ext4 filesystem with 2048 inodes on /dev/vde.

Is the required filesystem created?

## Solution:

Execute the below command:

#### mkfs.ext4 -N 2048 /dev/vde

If the user is not root, you need to use the command with sudo.


## Task:

Mount /dev/vdd in the /mnt/ directory.

Is the partition mounted?

## Solution:

Execute the below command:

#### mount /dev/vdd /mnt

If the user is not root, you need to use the command with sudo.


## Task:

Unmount the filesystem mounted in the /mnt/ directory.

Is filesystem unmounted?

## Solution:

Execute the below command:

#### umount /mnt

If the user is not root, you need to use the command with sudo.


## Task:

Configure the system to automatically mount /dev/vde when it boots up. This partition has an ext4 filesystem on it. It should mount the filesystem to the /test directory. This directory does not exist. Make sure you create it first.

Also, make sure this filesystem is checked on boot.

For now, you do not need to reboot the system after making the required changes.

- Is the "/test" directory created?

- Is '/dev/vde' automatically mounted when system boots up?

## Solution:

First, create a directory using the following command:

#### mkdir /test

Edit the /etc/fstab file:

#### vi /etc/fstab

If the user is not root, you need to use the command with sudo.

Add this line in it:

#### /dev/vde /test ext4 defaults 0 2

Save and exit.


## Task:

Configure the system to automatically use /dev/vdd as swap when it boots up.

For now, you do not need to reboot the system after making the required changes as this might affect the next task.

- Is required configuration done ?

## Solution:

Edit /etc/fstab file:

#### vi /etc/fstab

If the user is not root, you need to use the command with sudo.

Add this line in it:

#### /dev/vdd none swap defaults 0 0

Save and exit.


## Task:

Change the label for /dev/vdd filesystem to SwapFS

- Required label set for the filesystem?

## Solution:

Execute below given command:

#### xfs_admin -L "SwapFS" /dev/vdd

If the user is not root, you need to use the command with sudo.


