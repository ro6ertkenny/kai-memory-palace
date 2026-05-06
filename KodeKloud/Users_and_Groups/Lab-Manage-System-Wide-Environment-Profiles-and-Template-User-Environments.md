# Lab - Manage System-Wide Environment Profiles and Template User Environments

## Task:

How can we print the value of an environment variable?

<details><summary>Answer</summary>
We can print the value of an environment variable using echo $MYVAR command.

### Explanation:
- echo → print text to terminal
- $MYVAR → reference environment variable
- $ → access value of variable
    `$` means: **“give me the value of this variable”**

## 🔍 Example

    MYVAR=hello

    echo $MYVAR

👉 Bash does:
    echo hello

👉 output:
    hello

## 🧠 Think of It Like This

    $ = “unwrap the value inside”

## 🧪 Without `$`

    echo MYVAR

👉 output:
    MYVAR   (just text)

## 🧪 With `$`

    echo $MYVAR

👉 output:
    hello   (actual value)

</details>

---

## Task:

Which of the following environment variables holds the value of user's home directory?

<details><summary>Answer</summary>
$HOME environment variable holds the value of user's home directory.

### Explanation:
- $HOME → stores path of user's home directory
- environment variable → dynamic value used by shell

</details>

---

## Task:

Which of the following files can be used to set the globally available environment variables in a Linux-based system?

<details><summary>Answer</summary>
The /etc/environment file can be used to set the globally available environment variables in a Linux-based system.

### Explanation:
- /etc/environment → system-wide environment configuration file
- global variables → available to all users

</details>

---

## Task:

Print our current user's (bob) environment and save the output in the /home/bob/env file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/env

Check bob's env.

<details><summary>Answer</summary>
Execute the below command:

#### env > /home/bob/env

### Explanation:
- env → display all environment variables
- '>' → redirect output to file
- /home/bob/env → destination file

## 🔁 1-Line Recall

    `>` = take output and put it in a file (name doesn’t matter)

## 🧨 Operator Insight

Think:

    screen output = file content

## Final Takeaway

- Yes, it stores all that text in a file  
- `.txt` is optional  
- Linux only cares about the content, not the extension

</details>

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

### Explanation:
- ~/.bashrc → user-specific shell configuration
- export → set environment variable
- MYVAR=TRUE → variable assignment
- source ~/.bashrc → reload configuration

    `.bashrc` makes the variable **persistent**

## 🧠 The Problem Without `.bashrc`

If you just run:

    export MYVAR=TRUE

👉 it works ONLY for:
- the current terminal session

    `.bashrc` is: a file that runs **every time a new shell starts**

    .bashrc = startup script for your shell

    When you add:
    export MYVAR=TRUE
    to `.bashrc`…

👉 every new terminal automatically runs iT

## 🧪 Result

    echo $MYVAR

👉 always prints:
    TRUE

—even after reopening terminal

## ⚙️ Why `export` Is Used

    export MYVAR=TRUE

👉 makes the variable:
- available to child processes  
- truly an **environment variable**

## ⚠️ Why `source ~/.bashrc`?

After editing:

    source ~/.bashrc

👉 reloads the file immediately

👉 otherwise you'd need to:
- close and reopen terminal

## 🧠 Mental Model (LOCK THIS IN)

| Method | Behavior |
|--------|--------|
| `MYVAR=TRUE` | temporary |
| `export MYVAR=TRUE` | temporary (but exported) |
| `.bashrc` | permanent |

## ⚡ Exam Pattern

If you see:
- “set environment variable permanently” → use `.bashrc`

## 🔁 1-Line Recall

    .bashrc = persistent environment variables

## 🧨 Operator Insight

Think:

    one-time command → temporary  
    config file → persistent  

</details>

---

## Task:

Identify the value of GLOBALENV environment variable and save it in the /home/bob/globalenv file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/globalenv

Is GLOBALENV environment variable value saved in the /home/bob/globalenv file?

<details><summary>Answer</summary>
Execute the below command:

#### echo $GLOBALENV > /home/bob/globalenv

### Explanation:
- echo → print variable value
- $GLOBALENV → access variable
- '>' → redirect output
- /home/bob/globalenv → destination file

</details>

---

## Task:

Whenever we add a new user to the system, some files are copied from a template directory to the user's home directory.

Manually copy those files into the /home/bob/default_data directory.

Is required data copied?

<details><summary>Answer</summary>
Execute the below command:

#### sudo cp /etc/skel/.bash* /home/bob/default_data/

### Explanation:
- cp → copy files
- sudo → run with elevated privileges
- /etc/skel → template directory for new users
- .bash* → match bash-related config files
- /home/bob/default_data/ → destination directory

A full correct copy requires:

#### cp -r /etc/skel/. /home/bob/default_data/

## 🔍 WHY THE `.` MATTERS

👉 `.` = “this directory (current level)”

👉 So:

    /etc/skel/.

👉 Means:

> “everything inside /etc/skel”

## 🔥 EXTRA IMPORTANT

👉 It ALSO includes:

- hidden files (`.bashrc`, `.profile`, etc.)

👉 Think:

> 🗣️ “dot = contents, not container”

## 🧪 WHAT `/etc/skel` IS

👉 Template directory for new users

When you create a user:
- these files get copied into their home directory

## ⚠️ LFCS GOTCHA

👉 Without `.`:
❌ wrong structure  
❌ extra directory created  

👉 With `.`:
✅ correct structure  
✅ matches how user homes are built  

## 🧠 FINAL LOCK-IN

👉 `/etc/skel/.` = contents of skel  
👉 `.` = include hidden files + no extra folder  

👉 Think:

    “dot = dump contents here”

</details>

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

Normally:

- `/etc/environment` is read at login  
- NOT automatically reloaded after editing  

---

## So if you edit it:

    sudo vi /etc/environment

👉 changes won’t apply immediately ❌

---

## Fix:

    source /etc/environment

👉 applies changes RIGHT NOW ✅

### Explanation:
- /etc/environment → global environment configuration
- sudo vi → edit file with privileges
- GLOBALOPTION=ON → define variable
- source → reload environment variables

</details>

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

### Explanation:
- /etc/profile.d/ → scripts executed at login
- .sh file → shell script
- echo → display message
- sudo → create file with privileges

</details>

---

## Task:

Make sure that every time a new user account is added to the system, a file called README is copied to the new user's home directory.

Are the required changes made?

<details><summary>Answer</summary>
Whenever we create a new user in Linux, the files in the /etc/skel directory get copied into the user's home. So, we can create a README in the /etc/skel directory so that it gets copied to the newly created user's home.
Execute the below command to do so:

#### sudo touch /etc/skel/README

### Explanation:
- /etc/skel → template directory for new users
- touch → create empty file
- README → file copied to new user home
- sudo → run with privileges

</details>

---

## Task:

Set a variable named LFCS with value Welcome to the KodeKloud LFCS Labs! for every user that logs into this system.

Note: You may need to login again to make the changes take effect, so run sudo su - <current-user-name>.

Has LFCS variable been set?

<details><summary>Answer</summary>
Edit the /etc/environment file:

#### sudo vi /etc/environment

Add the below line at the end of the file:

#### LFCS="Welcome to the KodeKloud LFCS Labs!"

### Explanation:
- /etc/environment → global environment file
- sudo vi → edit file with privileges
- LFCS=... → define global variable
- applies to all users after login

</details>

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

### Explanation:
- ~/.bashrc → user shell configuration
- PATH → list of executable directories
- $HOME/.config/bin → new directory added
- : → separator for PATH entries
- source ~/.bashrc → reload changes
    ~ = “take me home” = current user’s home directory

## 🧨 Operator Insight

Use `~` to:
- avoid typing full paths  
- make commands portable across users  

</details>
