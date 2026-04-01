# Lab - Manage System-Wide Environment Profiles and Template User Environments

## Task:

How can we print the value of an environment variable?

<details><summary>Answer</summary>
We can print the value of an environment variable using echo $MYVAR command.
</details>

### Explanation:
- echo → print text to terminal
- $MYVAR → reference environment variable
- $ → access value of variable

---

## Task:

Which of the following environment variables holds the value of user's home directory?

<details><summary>Answer</summary>
$HOME environment variable holds the value of user's home directory.
</details>

### Explanation:
- $HOME → stores path of user's home directory
- environment variable → dynamic value used by shell

---

## Task:

Which of the following files can be used to set the globally available environment variables in a Linux-based system?

<details><summary>Answer</summary>
The /etc/environment file can be used to set the globally available environment variables in a Linux-based system.
</details>

### Explanation:
- /etc/environment → system-wide environment configuration file
- global variables → available to all users

---

## Task:

Print our current user's (bob) environment and save the output in the /home/bob/env file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/env

Check bob's env.

<details><summary>Answer</summary>
Execute the below command:

#### env > /home/bob/env
</details>

### Explanation:
- env → display all environment variables
- > → redirect output to file
- /home/bob/env → destination file

---

## Task:

Add an environment variable for user bob.

The variable name should be MYVAR and its value should be TRUE

Is the required environment variable set for user bob?

<details><summary>Answer</summary>
Edit .bashrc file:

#### vi ~/.bashrc

add the variable at the end of the file:

#### export MYVAR=TRUE

save the file and run:

#### source ~/.bashrc
</details>

### Explanation:
- ~/.bashrc → user-specific shell configuration
- export → set environment variable
- MYVAR=TRUE → variable assignment
- source ~/.bashrc → reload configuration

---

## Task:

Identify the value of GLOBALENV environment variable and save it in the /home/bob/globalenv file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/globalenv

Is GLOBALENV environment variable value saved in the /home/bob/globalenv file?

<details><summary>Answer</summary>
Execute the below command:

#### echo $GLOBALENV > /home/bob/globalenv
</details>

### Explanation:
- echo → print variable value
- $GLOBALENV → access variable
- > → redirect output
- /home/bob/globalenv → destination file

---

## Task:

Whenever we add a new user to the system, some files are copied from a template directory to the user's home directory.

Manually copy those files into the /home/bob/default_data directory.

Is required data copied?

<details><summary>Answer</summary>
Execute the below command:

#### sudo cp /etc/skel/.bash* /home/bob/default_data/
</details>

### Explanation:
- cp → copy files
- sudo → run with elevated privileges
- /etc/skel → template directory for new users
- .bash* → match bash-related config files
- /home/bob/default_data/ → destination directory

---

## Task:

Modify the system-wide environment file and make sure that the variable GLOBALOPTION is set to this value: ON. Otherwise, after you modify that file, any user that logs in and types…

#### echo $GLOBALOPTION

should get this result:

#### ON

Is the required variable updated/added?

<details><summary>Answer</summary>
Edit the /etc/environment file:

#### sudo vi /etc/environment

Save the below line at the end of the file:

#### GLOBALOPTION=ON

Then execute the following command on the terminal for the changes to take effect:

#### source /etc/environment
</details>

### Explanation:
- /etc/environment → global environment configuration
- sudo vi → edit file with privileges
- GLOBALOPTION=ON → define variable
- source → reload environment variables

---

## Task:

Make sure that this command gets executed for any user that logs in to the system:

#### echo Welcome to our server!

Are the required changes made?

<details><summary>Answer</summary>
Create a file with .sh extension at location /etc/profile.d/, for example:

#### sudo vi /etc/profile.d/welcome.sh

And save in it the line given below:

#### echo "Welcome to our server!"
</details>

### Explanation:
- /etc/profile.d/ → scripts executed at login
- .sh file → shell script
- echo → display message
- sudo → create file with privileges

---

## Task:

Make sure that every time a new user account is added to the system, a file called README is copied to the new user's home directory.

Are the required changes made?

<details><summary>Answer</summary>
Whenever we create a new user in Linux, the files in the /etc/skel directory get copied into the user's home. So, we can create a README in the /etc/skel directory so that it gets copied to the newly created user's home.
Execute the below command to do so:

#### sudo touch /etc/skel/README
</details>

### Explanation:
- /etc/skel → template directory for new users
- touch → create empty file
- README → file copied to new user home
- sudo → run with privileges

---

## Task:

Set a variable named LFCS with value Welcome to the KodeKloud LFCS Labs! for every user that logs into this system.

Note: You may need to login again to make the changes take effect, so run sudo su - <current-user-name>.

Has LFCS variable been set?

<details><summary>Answer</summary>
Edit the /etc/environment file:

#### sudo vi /etc/environment

Add the below line at the end of the file:

#### LFCS=Welcome to the KodeKloud LFCS Labs!
</details>

### Explanation:
- /etc/environment → global environment file
- sudo vi → edit file with privileges
- LFCS=... → define global variable
- applies to all users after login

---

## Task:

Add the value of $PATH variable for user bob to include $HOME/.config/bin location in the path.

Has PATH been updated for user bob?

<details><summary>Answer</summary>
Edit the .bashrc file:

#### vi /home/bob/.bashrc

Add the PATH variable value so that it looks similar to this and save it:

#### PATH="$HOME/.config/bin:$PATH"

Source .bashrc:

#### source ~/.bashrc
</details>

### Explanation:
- ~/.bashrc → user shell configuration
- PATH → list of executable directories
- $HOME/.config/bin → new directory added
- : → separator for PATH entries
- source ~/.bashrc → reload changes
