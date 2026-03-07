# Lab - Manage Processes and Analyze Log Files

## Task: 

How can we see all processes running on the system along with their nice values?

## Solution:

Using the ps lax command, we can see all processes running on the system along with their nice values.


## Task:

Which of the following commands will you use to sleep for 10 seconds?

## Solution:

You can use sleep 10 command to sleep for 10 seconds.


## Task:

By default, which directory contains the logs of most of the services running on a Linux system?

## Solution:

By default, the /var/log/ directory contains the logs of most of the services running on a Linux system.


## Task:

Assign a nice value of 9 to the sshd process.

Is the nice value of 9 assigned to the sshd process?

## Solution:

Execute the below command to identify the sshd process ID:

#### ps aux

Look for the PID value for the sshd process. Now, execute the below command:

#### sudo renice 9 <PID>


## Task:

List all files that are opened by the process with PID 1; this process is owned by the root user.

Save the output in the /home/bob/files.txt file.

Verify "/home/bob/files.txt" file.

## Solution:

Execute the below command:

#### sudo lsof -p 1 > /home/bob/files.txt


## Task:

Search the logs for entries related to the SSH daemon. Find out what IP address last connected to this daemon successfully.

Save that IP in the /home/bob/ip.txt file.

Look for the correct IP in the /home/bob/ip.txt file.

## Solution:

Execute the below command:

#### sudo journalctl --unit=ssh.service -n 20 --no-pager

And look for the logs entries like this:

#### sshd[1790]: Accepted publickey for root from ....

Copy the IP address and save it in the /home/bob/ip.txt file:

#### vi /home/bob/ip.txt


## Task:

Identify the PID of the process named rpcbind and save its value in the /home/bob/pid.txt file.

Look for the correct PID in the "/home/bob/pid.txt" file.

## Solution:

Execute the below command:

#### pgrep -a rpcbind

Copy the PID and save it in the /home/bob/pid.txt file.

#### vi /home/bob/pid.txt


## Task:

With the systemctl command, find out the PID of the process currently managed by the ssh.service. Send the SIGHUP signal to this process.

Is SIGHUP sent to the ssh service?

## Solution:

Execute the below command and look for the Main PID:

#### systemctl status ssh.service

Send it a SIGHUP signal using the below command:

#### sudo kill -SIGHUP <pid>


## Task:

Under the /var/log directory, search for all files containing the reboot string and save the search result in the /home/bob/reboot.log file.

Is the search result saved in the /home/bob/reboot.log file?

## Solution:

Use the below command:

#### sudo grep -r --text 'reboot' /var/log/ > reboot.log


## Task:

Analyze the error logs through journalctl with the priority flag and copy the output to /home/bob/.priority/priority.log.

Are the journalctl error logs with priority flag copied to /home/bob/.priority/priority.log?

## Solution:

Use the below commands:

#### cd /home/bob
#### sudo journalctl -p err > .priority/priority.log


## Task:

Analyze the info priority logs through journalctl that begin with letter c and store the output in the /home/bob/.priority/boot.log file.

Is the correct output stored in /home/bob/.priority/boot.log?

## Solution:

Use the below commands:

#### cd /home/bob
#### sudo journalctl -p info -g '^c' > .priority/boot.log


## Task:

Using the ps command, display information for the process with PID 1 in a way that includes its CPU and memory usage, and save the complete command output to the file
/home/bob/resources.txt

Verify the contents of "/home/bob/resources.txt" file.

## Solution:

Execute the below command:

ps u 1 > /home/bob/resources.txt


## Task:

Run a command to sleep for 3000 seconds and make sure it is running in the background.

Is the required command running in the background?

## Solution:

Execute the below command:

#### sleep 3000 &
