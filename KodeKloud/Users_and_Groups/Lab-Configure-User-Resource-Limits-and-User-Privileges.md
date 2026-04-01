# Lab - Configure User Resource Limits and User Privileges

## Task:

Which of the following keywords can we use to limit the number of processes a user can run?

<details><summary>Answer</summary>
nproc will be used to limit the number of processes a user can run.
</details>

### Explanation:
- nproc → limits the number of processes a user can run
- security limits keyword → used in limits.conf entries

---

## Task:

Modify the security limits file and make sure that the user called trinity can run no more than 30 processes in her session.
This should be both a hard limit and a soft limit, written in a single line.

Have required limits been set?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### trinity - nproc 30

Save and exit.
</details>

### Explanation:
- /etc/security/limits.conf → file for PAM resource limits
- sudo vi → edit file with elevated privileges
- trinity → target user
- - → apply both soft and hard limits
- nproc → process count limit
- 30 → maximum number of processes

---

## Task:

Identify all the security limits currently applied in our user's session and save them in the /home/bob/limits file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/limits

Verify the saved data.

<details><summary>Answer</summary>
Execute the below command:

#### ulimit -a > /home/bob/limits
</details>

### Explanation:
- ulimit → show or set shell resource limits
- -a → display all current limits
- > → redirect output to file
- /home/bob/limits → destination file

---

## Task:

Modify the sudoers file in such a way to allow the user called trinity to run any sudo command without needing to provide her password.

Are required changes added for the user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity    ALL=(ALL)   NOPASSWD: ALL

Save and exit.
</details>

### Explanation:
- sudoers file → controls sudo permissions
- visudo → safely edit sudoers configuration
- trinity → target user
- ALL=(ALL) → may run commands as any user on any host
- NOPASSWD: ALL → no password required for any command

---

## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to only run the /usr/bin/mount command with sudo.

Are required changes added for the user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Remove the previous entry for trinity user and add the below line at the end of the /etc/sudoers file:

#### trinity ALL=(ALL) /usr/bin/mount

Save and exit.
</details>

### Explanation:
- visudo → safely edit sudoers file
- trinity → target user
- ALL=(ALL) → may run command as any user on any host
- /usr/bin/mount → only allowed sudo command
- previous entry → must be removed to avoid broader access

---

## Task:

Make changes in security limits file for user stephen so that he can create maximum filesize upto 4 MiB. This should be a hard limit.

Are required changes added for the user stephen?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### stephen hard fsize 4096

Save and exit.
</details>

### Explanation:
- /etc/security/limits.conf → resource limits file
- stephen → target user
- hard → hard limit
- fsize → maximum file size
- 4096 → size value in this limits entry
- sudo vi → edit file with privileges

---

## Task:

Set a soft limit of 20 processes for everyone in the salesteam group.

Is the required soft limit set to the salesteam group ?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the following line at the end of the file:

#### @salesteam     soft    nproc     20

Save and exit.
</details>

### Explanation:
- @salesteam → apply rule to group
- soft → soft limit
- nproc → process count limit
- 20 → maximum allowed processes
- /etc/security/limits.conf → limits configuration file

---

## Task:

Define a policy for all the users in the salesteam group to run any sudo command.

Is the required policy defined for salesteam group to run all sudo commands?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### %salesteam     ALL=(ALL)     ALL

Save and exit.
</details>

### Explanation:
- %salesteam → apply sudo rule to group
- ALL=(ALL) → may run commands as any user on any host
- ALL → all commands permitted
- visudo → safely edit sudoers file

---

## Task:

Define a policy so that user trinity can run sudo commands as the user sam.

Have required changes been added?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity   ALL=(sam)   ALL

Save and exit.
</details>

### Explanation:
- trinity → user receiving sudo permission
- ALL=(sam) → may run commands as user sam
- ALL → all commands allowed in that context
- visudo → safely edit sudoers file

---

## Task:

We applied a hard limit of 10 processes for all the users under developers group, but somehow the limit isn't working. Look into the issue and fix the same.

Has the limits issue for "developers" group been fixed?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Look for the developers group entry and make sure it looks like this:

#### @developers     hard    nproc  10
</details>

### Explanation:
- @developers → apply rule to group
- hard → hard limit
- nproc → process count limit
- 10 → maximum allowed processes
- correct group syntax → requires @ before group name
- /etc/security/limits.conf → file being fixed

---

## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to run all commands with sudo, but only after entering the password.

Have required changes been made for user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line in the /etc/sudoers file:

#### trinity ALL=(ALL) ALL

Save and exit.
</details>

### Explanation:
- trinity → target user
- ALL=(ALL) → may run commands as any user on any host
- ALL → all commands allowed
- password required → no NOPASSWD present, so password is required
- visudo → safely edit sudoers file
