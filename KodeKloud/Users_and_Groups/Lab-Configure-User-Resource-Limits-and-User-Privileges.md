# Lab - Configure User Resource Limits and User Privileges

## Task:

Which of the following keywords can we use to limit the number of processes a user can run?

## Solution:

nproc will be used to limit the number of processes a user can run.


## Task:

Modify the security limits file and make sure that the user called trinity can run no more than 30 processes in her session.
This should be both a hard limit and a soft limit, written in a single line.

Have required limits been set?

## Solution:

Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### trinity - nproc 30

Save and exit.


## Task:

Identify all the security limits currently applied in our user's session and save them in the /home/bob/limits file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/limits

Verify the saved data.

## Solution:

Execute the below command:

#### ulimit -a > /home/bob/limits


## Task:

Modify the sudoers file in such a way to allow the user called trinity to run any sudo command without needing to provide her password.

Are required changes added for the user trinity?

## Solution:

Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity    ALL=(ALL)   NOPASSWD: ALL

Save and exit.


## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to only run the /usr/bin/mount command with sudo.

Are required changes added for the user trinity?

## Solution:

Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Remove the previous entry for trinity user and add the below line at the end of the /etc/sudoers file:

#### trinity ALL=(ALL) /usr/bin/mount

Save and exit.


## Task:

Make changes in security limits file for user stephen so that he can create maximum filesize upto 4 MiB. This should be a hard limit.

Are required changes added for the user stephen?

## Solution:

Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### stephen hard fsize 4096

Save and exit.


## Task:

Set a soft limit of 20 processes for everyone in the salesteam group.

Is the required soft limit set to the salesteam group ?

## Solution:

Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the following line at the end of the file:

#### @salesteam     soft    nproc     20

Save and exit.


## Task:

Define a policy for all the users in the salesteam group to run any sudo command.

Is the required policy defined for salesteam group to run all sudo commands?

## Solution:

Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### %salesteam     ALL=(ALL)     ALL

Save and exit.


## Task:

Define a policy so that user trinity can run sudo commands as the user sam.

Have required changes been added?

## Solution:

Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity   ALL=(sam)   ALL

Save and exit.


## Task:

We applied a hard limit of 10 processes for all the users under developers group, but somehow the limit isn't working. Look into the issue and fix the same.

Has the limits issue for "developers" group been fixed?

## Solution:

Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Look for the developers group entry and make sure it looks like this:

#### @developers     hard    nproc  10


## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to run all commands with sudo, but only after entering the password.

Have required changes been made for user trinity?

## Solution:

Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line in the /etc/sudoers file:

#### trinity ALL=(ALL) ALL

Save and exit.


