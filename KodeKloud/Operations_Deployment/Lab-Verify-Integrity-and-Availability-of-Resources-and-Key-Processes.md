# Lab - Verify Integrity and Availability of Resources and Key Processes

## Task:

Identify what % space of / partition is in use on our system. Save the value in the /home/bob/used file.

For example, if the used space is 10%, then the file content should be 10%.

Verify the /home/bob/used file.

## Solution:

Execute the below command and copy the used space value:

#### df /

Save the value in the /home/bob/used file:

#### vi /home/bob/used


## Task:

Figure out how much storage space the /bin/ directory is using and save the value in the /home/bob/bin file.

Verify the /home/bob/bin file.

## Solution:

Execute the below command and copy the required value:

#### du -sh /bin/

Save the value in the /home/bob/bin file:

#### vi /home/bob/bin


## Task:

Use the correct command to check out the memory on this system (in megabytes). In /home/bob/memory file, save the total amount of RAM that this system has.

For example, if you see 512 in the command's output, the file contents should be 512

Verify the /home/bob/memory file.

## Solution:

Execute the below command and copy the required value:

#### free --mega

Save the value in the /home/bob/memory file:

#### vi /home/bob/memory


## Task:

Use the correct command to check out how long this system has been up. In the /home/bob/up file, save the time value in hours, minutes, or days (whichever is applicable).

For example, if you see 1:07 in the command's output, the file content should be 1.
Similarly, if you see something like 51 min in the command's output, the file content should be 51min (without any space).

Verify the /home/bob/up file.

## Solution:

Execute the below command and copy the required value:

#### uptime

Save the value in the /home/bob/up file:

#### vi /home/bob/up


## Task:

Use the correct command to identify the CPU core(s) per socket on this system. Save its value in the /home/bob/cpu file.

Verify the /home/bob/cpu file.

## Solution:

Execute the below command and copy the required value:

#### lscpu

Save the value in the /home/bob/cpu file:

#### vi /home/bob/cpu


## Task:

On /dev/vdd, we have an XFS filesystem.Use the correct command to check this filesystem for errors and save the output in /home/bob/fscheck file.

Has the required file system been checked for errors?

## Solution:

Execute the below command:

#### sudo xfs_repair -n /dev/vdd > /home/bob/fscheck 2>&1
