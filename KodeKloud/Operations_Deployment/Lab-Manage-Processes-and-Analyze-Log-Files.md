# Lab - Manage Processes and Analyze Log Files

## Task: 

How can we see all processes running on the system along with their nice values?

<details><summary>Answer</summary>
Using the ps lax command, we can see all processes running on the system along with their nice values.
</details>

### Explanation:
- ps → display running processes
- l → long format
- a → show processes for all users with a terminal
- x → include processes without a terminal
- nice value → scheduling priority adjustment shown in the process listing

---

## Task:

Which of the following commands will you use to sleep for 10 seconds?

<details><summary>Answer</summary>
You can use sleep 10 command to sleep for 10 seconds.
</details>

### Explanation:
- sleep → pause for a specified amount of time
- 10 → sleep duration in seconds

---

## Task:

By default, which directory contains the logs of most of the services running on a Linux system?

<details><summary>Answer</summary>
By default, the /var/log/ directory contains the logs of most of the services running on a Linux system.
</details>

### Explanation:
- /var/log/ → standard directory for many Linux service and system log files
- logs → records of events, activity, and errors

---

## Task:

Assign a nice value of 9 to the sshd process.

Is the nice value of 9 assigned to the sshd process?

<details><summary>Answer</summary>
Execute the below command to identify the sshd process ID:

#### ps aux

Look for the PID value for the sshd process. Now, execute the below command:

#### sudo renice 9 <PID>
</details>

### Explanation:
- ps aux → list running processes in detailed format
- sshd → SSH daemon process to identify
- PID → process ID
- renice → change the nice value of a running process
- 9 → new nice value
- sudo → run with elevated privileges
- <PID> → target process ID

---

## Task:

List all files that are opened by the process with PID 1; this process is owned by the root user.

Save the output in the /home/bob/files.txt file.

Verify "/home/bob/files.txt" file.

<details><summary>Answer</summary>
Execute the below command:

#### sudo lsof -p 1 > /home/bob/files.txt
</details>

### Explanation:
- lsof → list open files
- sudo → run with elevated privileges
- -p 1 → limit output to process with PID 1
- > → redirect output to file
- /home/bob/files.txt → destination file

---

## Task:

Search the logs for entries related to the SSH daemon. Find out what IP address last connected to this daemon successfully.

Save that IP in the /home/bob/ip.txt file.

Look for the correct IP in the /home/bob/ip.txt file.

<details><summary>Answer</summary>
Execute the below command:

#### sudo journalctl --unit=ssh.service -n 20 --no-pager

And look for the logs entries like this:

#### sshd[1790]: Accepted publickey for root from ....

Copy the IP address and save it in the /home/bob/ip.txt file:

#### vi /home/bob/ip.txt
</details>

### Explanation:
- journalctl → view systemd journal logs
- sudo → run with elevated privileges
- --unit=ssh.service → show logs for ssh service only
- -n 20 → show last 20 log entries
- --no-pager → print directly without pager
- Accepted publickey → successful SSH login indicator
- vi /home/bob/ip.txt → save the IP manually into file

---

## Task:

Identify the PID of the process named rpcbind and save its value in the /home/bob/pid.txt file.

Look for the correct PID in the "/home/bob/pid.txt" file.

<details><summary>Answer</summary>
Execute the below command:

#### pgrep -a rpcbind

Copy the PID and save it in the /home/bob/pid.txt file.

#### vi /home/bob/pid.txt
</details>

### Explanation:
- pgrep → find process IDs by name
- -a → show PID and full command line
- rpcbind → target process name
- vi /home/bob/pid.txt → save the PID manually into file

---

## Task:

With the systemctl command, find out the PID of the process currently managed by the ssh.service. Send the SIGHUP signal to this process.

Is SIGHUP sent to the ssh service?

<details><summary>Answer</summary>
Execute the below command and look for the Main PID:

#### systemctl status ssh.service

Send it a SIGHUP signal using the below command:

#### sudo kill -SIGHUP <pid>
</details>

### Explanation:
- systemctl status → show service status details
- ssh.service → target service
- Main PID → process ID managed by the service
- kill → send a signal to a process
- -SIGHUP → send hangup signal
- sudo → run with elevated privileges
- <pid> → target process ID

---

## Task:

Under the /var/log directory, search for all files containing the reboot string and save the search result in the /home/bob/reboot.log file.

Is the search result saved in the /home/bob/reboot.log file?

<details><summary>Answer</summary>
Use the below command:

#### sudo grep -r --text 'reboot' /var/log/ > reboot.log
</details>

### Explanation:
- grep → search text in files
- sudo → run with elevated privileges
- -r → search recursively through directories
- --text → treat files as text
- 'reboot' → search string
- /var/log/ → directory being searched
- > → redirect output to file
- reboot.log → destination file

---

## Task:

Analyze the error logs through journalctl with the priority flag and copy the output to /home/bob/.priority/priority.log.

Are the journalctl error logs with priority flag copied to /home/bob/.priority/priority.log?

<details><summary>Answer</summary>
Use the below commands:

#### cd /home/bob
#### sudo journalctl -p err > .priority/priority.log
</details>

### Explanation:
- cd /home/bob → change to bob's home directory
- journalctl → view journal logs
- sudo → run with elevated privileges
- -p err → show only error-priority logs
- > → redirect output to file
- .priority/priority.log → destination file

---

## Task:

Analyze the info priority logs through journalctl that begin with letter c and store the output in the /home/bob/.priority/boot.log file.

Is the correct output stored in /home/bob/.priority/boot.log?

<details><summary>Answer</summary>
Use the below commands:

#### cd /home/bob
#### sudo journalctl -p info -g '^c' > .priority/boot.log
</details>

### Explanation:
- cd /home/bob → change to bob's home directory
- journalctl → view journal logs
- sudo → run with elevated privileges
- -p info → show info-priority logs
- -g '^c' → filter log messages matching lines that begin with c
- > → redirect output to file
- .priority/boot.log → destination file

---

## Task:

Using the ps command, display information for the process with PID 1 in a way that includes its CPU and memory usage, and save the complete command output to the file
/home/bob/resources.txt

Verify the contents of "/home/bob/resources.txt" file.

<details><summary>Answer</summary>
Execute the below command:

ps u 1 > /home/bob/resources.txt
</details>

### Explanation:
- ps → display process information
- u → user-oriented format with CPU and memory usage
- 1 → target PID
- > → redirect output to file
- /home/bob/resources.txt → destination file

---

## Task:

Run a command to sleep for 3000 seconds and make sure it is running in the background.

Is the required command running in the background?

<details><summary>Answer</summary>
Execute the below command:

#### sleep 3000 &
</details>

### Explanation:
- sleep → pause for a specified duration
- 3000 → sleep duration in seconds
- & → run command in the background
