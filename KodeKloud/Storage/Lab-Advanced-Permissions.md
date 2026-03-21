# Lab - Advanced Permissions

## Task:

Which one of these is also called a mirrored array?

## Solution:

Disks grouped in level 1 RAID is also called a mirrored array.


## Task:

What command can you use to view a summary status of your RAID arrays?

## Solution:

The /proc/mdstat file contains the summary status of the RAID arrays, so you can use the cat /proc/mdstat command to view a summary status of your RAID arrays.


## Task:

In your /home/bob directory, you will find a file named archive. List the ACL permissions associated with this file.

What permissions are listed for john in this ACL?

## Solution:

You can use the command getfacl archive to get ACL permissions of the file.

# file: archive
# owner: bob
# group: bob
user::rw-
user:john:r--
group::r--
mask::r--
other::r--

As you can see in the output, John has read only permissions.


## Task:

Create a level 1 RAID array, at /dev/md0, with two devices: /dev/vdd and /dev/vde.

mdadm is already installed in your system which is used for creating, managing, and monitoring RAID devices using the md driver.

Has the required RAID array been created?

## Solution:

Execute the below command:

#### mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/vdd /dev/vde

Enter y and press Enter if asked for the confirmation.

Note: You need to use sudo with the command in case of a non-root user.


## Task:

In your /home/bob directory, you will find a file named specialfile. Add an ACL permission to this file so that the user called john can read and write to it.

Has the required acl been set for user john?

## Solution:

Execute the below command:

#### setfacl --modify user:john:rw specialfile

Note: You need to use sudo with the command in case of a non-root user.


## Task:

From the file called specialfile, remove the ACL permissions for the user called john.

Have the required acl permissions been removed for user john?

## Solution:

Execute the below command:

#### setfacl --remove user:john specialfile

Note: You need to use sudo with the command in case of a non-root user.


## Task:

To the file called specialfile, add an ACL permission for the group called mail. The mail group should get permissions to read and execute this file.

Has the required acl been set for group mail?

## Solution:

Execute the below command:

#### setfacl --modify group:mail:rx specialfile

Note: You need to use sudo with the command in case of a non-root user.


## Task:

In your /home/bob directory, you will find a directory called collection. Use the setfacl command recursively, so that ACL entries are modified on the directory itself but also all the files and subdirectories it may contain. The ACL permissions should allow the user called john to read, write and execute all entries within this directory.

- Have the required acl permissions been set on "collection" directory?

- Were ACL set recursively?

## Solution:

Execute the below command:

#### setfacl --recursive --modify user:john:rwx collection/

Note: You need to use sudo with the command in case of a non-root user.



























 
