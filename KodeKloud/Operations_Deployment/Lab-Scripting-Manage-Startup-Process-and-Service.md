# Lab - Scripting, Manage Startup Process and Services

## Task:

Schedule this system to power off two hours later from now.

Is this system scheduled to power off two hours from now?

<details><summary>Answer</summary>

    sudo shutdown +120

 Explanation:
- shutdown → schedule system shutdown
- sudo → run with elevated privileges
- +120 → time in minutes (120 minutes = 2 hours)

</details>

---

## Task:

The system is currently booting to a text-only console.
Change it to boot to a graphical desktop by default.

Has the system been configured to boot into a graphical desktop by default?

<details><summary>Answer</summary>

    sudo systemctl set-default graphical.target
 
Explanation:
- systemctl → manage systemd services and targets
- set-default → set default boot target
- graphical.target → graphical desktop environment
- sudo → run with elevated privileges

</details>

---

## Task:

Cancel the scheduled shutdown you configured in the beginning.

Has the scheduled shutdown been canceled?

<details><summary>Answer</summary>

    sudo shutdown -c

Explanation:
- shutdown → manage system shutdown
- -c → cancel a scheduled shutdown
- sudo → run with elevated privileges

</details>

---

## Task:

How do we run script.sh that is located in our current directory?

<details><summary>Answer</summary>

 We can run the script like this:

     ./script.sh

 Explanation:
- ./script.sh → execute script in current directory
- ./ → explicitly reference current directory
- script.sh → script file being executed

</details>

---

## Task:

What is the correct shebang to add in a script?

<details><summary>Answer</summary>

    #!/bin/bash is the correct shebang to add in a script.

Explanation:
- #! → shebang indicator
- /bin/bash → path to bash interpreter
- ensures script runs using bash shell

</details>

---

## Task:

Under bob's home:

Create a script called script.sh. This script should create a tar archive called archive.tar.gz. The script should archive the directory called dir1.

Please make sure you execute the script at least once.

Is script.sh created?

Does the archive have dir1 contents as mentioned in the task?

<details><summary>Answer</summary>

Create script.sh script:

    vi script.sh

Add in it the code given below:

    #!/bin/bash

    tar acf archive.tar.gz dir1

Make it executable:

    chmod u+x script.sh

Finally, execute the script:

    ./script.sh

 Explanation:
- vi script.sh → create/edit script file
- #!/bin/bash → define bash interpreter
- tar → archive tool
- a → auto-select compression based on extension
- c → create archive
- f → specify archive filename
- archive.tar.gz → output archive
- dir1 → directory being archived
- chmod u+x → make script executable
- ./script.sh → run script

</details>

---

## Task:

There is a service unit that automatically starts up the SSH daemon. Use the correct command to find out the PID assigned to the process launched by this service.

Save the PID in /home/bob/pid file.

Is the correct PID saved in the /home/bob/pid file?

<details><summary>Answer</summary>
Run the below command:

    systemctl status sshd.service

Then look for Main PID and save that value in the /home/bob/pid file:

    vi /home/bob/pid

For example:

    134

 Explanation:
- systemctl status → view service status
- sshd.service → SSH daemon service
- Main PID → process ID of running service
- vi /home/bob/pid → save PID into file manually

</details>

---

## Task:

Under bob's home:
Create script2.sh script that displays if the sshd.service unit is enabled or disabled.

Remember to make this script executable and try to execute it at least once to verify your answer.

Check the script.

<details><summary>Answer</summary>

 Create script2.sh script:

    vi /home/bob/script2.sh

Add in it the code given below

    #!/bin/bash

    systemctl is-enabled sshd.service

Make it executable:

    chmod u+x /home/bob/script2.sh

Finally, execute the script:

    ./script2.sh

 Explanation:
- vi → create/edit script
- #!/bin/bash → bash interpreter
- systemctl is-enabled → check if service is enabled
- sshd.service → target service
- chmod u+x → make script executable
- ./script2.sh → execute script

</details>

---

## Task:

Create a script /home/bob/perm.sh. This script should set permissions on the /home/bob/dir8 directory so that the user owner only has x (execute) permissions; the group owner and others must not have any permissions at all.

Remember to make this script executable and try to execute it at least once to verify your answer.

Does /home/bob/perm.sh exist?

Test and execute the script.

<details><summary>Answer</summary>

Create perm.sh script:

    vi /home/bob/perm.sh

Add in it the code given below:

    #!/bin/bash

    chmod 0100 /home/bob/dir8

Make it executable:

    chmod u+x /home/bob/perm.sh

Finally, execute the script:

    ./perm.sh

 Explanation:
- vi → create/edit script
- #!/bin/bash → bash interpreter
- chmod → change file permissions
- 0100 → user execute only, no permissions for group/others
- /home/bob/dir8 → target directory
- chmod u+x → make script executable
- ./perm.sh → execute script

</details>

---

## Task:

We already have a script named script10.sh under /home/bob/. Make sure this script runs without any errors to display the appropriate output.

Is the script correct?

<details><summary>Answer</summary>

Update script permissions to make it executable

    chmod 700 /home/bob/script10.sh

Fix some issues in the /home/bob/script10.sh script and, finally, it should look like this.

    #!/bin/bash

    cat test.txt

 Explanation:
- chmod 700 → give full permissions to owner only
- script10.sh → script file
- #!/bin/bash → bash interpreter
- cat → display file contents
- test.txt → file being read

</details>

---

## Task:

Copy the output of the sshd.service status to /home/bob/service.txt.

Is the sshd.service status copied to /home/bob/service.txt?

<details><summary>Answer</summary>

Execute the below commands:

    cd /home/bob

    sudo systemctl status sshd.service > service.txt

 Explanation:
- cd /home/bob → change directory
- systemctl status → get service status
- sshd.service → target service
- '>' → redirect output to file
- service.txt → destination file

</details>

---

## Task:

apache2 is already installed; mask its service.

Is 'apache2.service' masked ?

<details><summary>Answer</summary>

Execute the below command:

    sudo systemctl mask apache2.service

 Explanation:
- systemctl → manage systemd services
- mask → disable service completely (cannot be started)
- apache2.service → target service
- sudo → run with elevated privileges

</details>

---

## Task:

Now, unmask the apache2 service.

Is 'apache2.service' unmasked ?

<details><summary>Answer</summary>

Execute the below command:

    sudo systemctl unmask apache2.service

 Explanation:
- systemctl → manage services
- unmask → re-enable ability to start service
- apache2.service → target service
- sudo → run with elevated privileges

</details>

---

## Task:

Take a look at the Systemd service called kkloud.service. Find where this file is located, and edit it to correct three mistakes.

Currently, the process managed by this service is only restarted when it fails. Set it to always restart, regardless of the reason why it stopped.

Also, this service file does not include instructions about what command to run when it wants to stop this process. Add another line to instruct that the correct command to stop this process is kkloud --savedata. path to command is /usr/local/bin/kkloud

Finally, this service should start after the sshd.service. Locate the correct line you need to fix and edit it accordingly.

Is the restart policy set to always?

Is the stop command added to the service file?

Is the kkloud.service configured to start after sshd.service ?

<details><summary>Answer</summary>

Locate the file in the /etc/systemd/system folder with name kkloud.service,

1. Change the restart on failure to always

    Restart=on-failure --> Restart=always

2. Add the command to run when we want to stop the service in the service section.

    ExecStop=/usr/local/bin/kkloud --savedata

3. Edit the required line under the Unit section.

    After=sshd.service

Overall, the file should be like this after making changes.

[Unit]

    Description=KodeKloud Service
    After=sshd.service

[Service]
   
    ExecStart=/usr/local/bin/kkloud
    ExecStop=/usr/local/bin/kkloud --savedata
    KillMode=process
    Restart=always
    Type=simple

[Install]
    
    WantedBy=multi-user.target

 Explanation:
- /etc/systemd/system → location of custom service files
- Restart=always → restart service regardless of exit condition
- ExecStop → command used to stop the service
- /usr/local/bin/kkloud → executable path
- --savedata → argument passed during stop
- After=sshd.service → define startup order dependency
- systemd unit sections → [Unit], [Service], [Install] define service behavior

</details>
