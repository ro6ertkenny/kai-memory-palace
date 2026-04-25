# Lab: Manage Software, Repositories & Install Software from Source

## Task:

What is the difference between "apt update" and "apt upgrade"?

<details><summary>Answer</summary>

### Explanation:
- apt update → refresh package index from repositories
- retrieves latest package lists but does not install anything
- apt upgrade → install available upgrades for installed packages
- upgrades packages to newer versions without removing existing ones

</details>

---

## Task:

Install the Apache web server.

To find the package you need, you can search for this text: apache http server. In your search command, you can wrap this search string between " " double quotes to get fewer results and find the package easier.

Is apache webserver installed?

<details><summary>Answer</summary>
#### sudo apt search "apache http server"

Install the Apache web server

#### sudo apt update 
#### sudo apt install apache2

### Explanation:
- apt search → search for packages
- "apache http server" → search string to narrow results
- apt update → refresh package index
- apt install apache2 → install Apache web server
- apache2 → package name for Apache

</details>

---

## Task:

Find out the name of the package that "/bin/ls" belongs to and save it in package.txt under /home/bob.

Is the name of the package that /bin/ls belongs to stored in /home/bob/package.txt?

<details><summary>Answer</summary>
We can find the package by

#### dpkg --search /bin/ls

and save the output to below file

#### vi /home/bob/package.txt

### Explanation:
- dpkg → package management tool
- --search → find which package owns a file
- /bin/ls → file being searched
- vi → manually save output to file
- /home/bob/package.txt → destination file

👉 `dpkg` = **Debian Package**

## 🧪 CORRECT LFCS WAY (BETTER)

👉 Instead of using `vi`, use redirect:

    dpkg --search /bin/ls > /home/bob/package.txt

## ⚠️ LFCS GOTCHA

👉 `dpkg` = low-level tool  
👉 `apt` = high-level tool (uses dpkg underneath)

## 🧠 RELATED COMMANDS (LOCK THESE IN)

### 📌 List installed packages
    dpkg -l

### 📌 Install package file
    dpkg -i package.deb

### 📌 Remove package
    dpkg -r package

## 🧠 FINAL LOCK-IN

👉 `d` = Debian  
👉 `pkg` = package  

👉 `dpkg` = Debian package manager  

👉 `--search` = “who owns this file?”

</details>

---

## Task:

List the files that belong to the coreutils package. Filter out the entries that were installed in the /bin directory. You will see one file in this /bin directory with a name that begins with the letter "u". Identify the complete path of this file in the /bin directory and save it in name.txt file under /home/bob?

Is the package name saved to the /home/bob/name.txt file?

<details><summary>Answer</summary>
We can list the files that belong to the coreutils package by running the below command.

#### dpkg --listfiles coreutils | grep ^/bin

Identify the package name that begins with the letter u (/bin/uname) and save the answer to

#### vi /home/bob/name.txt

### Explanation:
- dpkg --listfiles coreutils → list files in coreutils package
- grep ^/bin → filter files in /bin directory
- ^/bin → match paths starting with /bin
- /bin/uname → file starting with letter "u"
- vi → save result manually
- /home/bob/name.txt → destination file

## 🔍 BREAKDOWN (SIMP)

### `dpkg --listfiles coreutils`
👉 list ALL files in the coreutils package

### `|`
👉 pipe → send output to next command

### `grep ^/bin`
👉 filter only files that:
- start with `/bin`

👉 `^` = “starts with”

## 🎯 TASK REQUIREMENT

👉 Find:

    /bin/uname

👉 AND:

👉 Save it to:

    /home/bob/name.txt

## ✅ CORRECT LFCS COMMAND

    dpkg --listfiles coreutils | grep ^/bin/u > /home/bob/name.txt

## 🧠 WHY THIS IS BETTER

👉 You:
- filter directly to the correct file (`u`)
- save it immediately
- avoid manual editing

## ⚠️ LFCS EXAM MINDSET

👉 ALWAYS prefer:

    command → filter → redirect

## 🧠 SIMP PATTERN

👉 Think:

    find → filter → save

## 🧠 FINAL LOCK-IN

👉 YES — use `>`  
👉 avoid `vi` unless required  
👉 automate everything  

👉 Goal:

    one clean command → correct output file

</details>

---

## Task:

Uninstall the package ziptool and its dependency package(s) from the system.

Are ziptool and its dependencies removed?

<details><summary>Answer</summary>
Execute the below command and observe the output

#### sudo apt-get remove --auto-remove -y ziptool

Observe the highlighted section
#### The following packages will be REMOVED:
####  libzip4 ziptool

### Explanation:
- apt-get remove → remove package
- --auto-remove → remove unused dependencies
- -y → automatically confirm prompts
- ziptool → package being removed
- dependencies → automatically removed with --auto-remove

## 🧠 LFCS — `dpkg` vs `apt-get` (REMOVING PACKAGES)

## 🎯 SHORT ANSWER

👉 YES, you *can* use `dpkg`…

👉 BUT ❗ **`apt-get` is the CORRECT tool for this task**

## 🧠 CORE DIFFERENCE

| Tool     | Level        | Handles Dependencies? |
|----------|-------------|-----------------------|
| dpkg     | low-level   | ❌ NO                 |
| apt-get  | high-level  | ✅ YES                |

## 🔥 WHY `dpkg` IS NOT IDEAL HERE

### If you run:

    sudo dpkg -r ziptool

👉 It will:
- remove ONLY `ziptool`
- ❌ NOT remove dependencies
- ❌ possibly leave broken packages

👉 Worse:

If dependencies are still required:
- dpkg may FAIL
- or leave system in inconsistent state

## ✅ CORRECT LFCS COMMAND

    sudo apt-get remove --auto-remove -y ziptool

## 🔍 SIMP BREAKDOWN

### `remove`
👉 uninstall the package

### `--auto-remove`
👉 remove unused dependencies too

### `-y`
👉 auto-confirm (no prompts)

## 🧠 WHY LFCS EXPECTS THIS

👉 The task says:

> remove package **AND its dependencies**

👉 Only `apt-get` (or `apt`) does that cleanly

## 🧪 WHAT `dpkg` IS GOOD FOR

### 📌 Remove package ONLY
    sudo dpkg -r ziptool

### 📌 Force remove (dangerous)
    sudo dpkg -P ziptool

👉 But:
- ❌ no dependency cleanup
- ❌ not exam-friendly for this task

## 🔧 CLEANUP (IF YOU USED `dpkg`)

You’d need:

    sudo apt-get autoremove

👉 Now you're basically using apt anyway

## 🧠 FINAL LOCK-IN

👉 `dpkg` = manual, low-level  
👉 `apt-get` = smart, dependency-aware  

👉 If task mentions:
    “dependencies”

👉 Use:

    apt-get remove --auto-remove

</details>

---

## Task:

In rare cases, we may need to get packages that were available on an older Ubuntu distribution.

Configure the package manager with this extra repository:

#### deb http://us.archive.ubuntu.com/ubuntu/ focal main

This will make packages from Ubuntu 20.04 (codenamed Focal Fossa) available on this system.

Don't forget to also update APT's local cache

Is the information on the remote repository focal available now?

<details><summary>Answer</summary>
Add this repository information to the /etc/apt/sources.list file.

#### bob@ubuntu-host /etc/apt🔒 ➜  sudo vim sources.list

And add the repo

#### deb http://us.archive.ubuntu.com/ubuntu/ focal main

Run the below command

#### sudo apt update 

### Explanation:
- /etc/apt/sources.list → repository configuration file
- sudo vim → edit file with elevated privileges
- deb http://us.archive.ubuntu.com/ubuntu/ focal main → repository entry
- focal → Ubuntu 20.04 release
- apt update → refresh package index with new repository

</details>

---

## Task:

In the tmux directory, you will find the source code for the tmux application. All compilation tools and libraries were already installed for you.

1. Build the application (compile source code).
2. Install it on the system.

Is tmux application installed?

<details><summary>Answer</summary>
Navigate to the /home/bob/tmux directory and follow the below steps to install an application from the binary.

#### cd tmux

Run autogen.sh to generate the necessary build files

#### sudo ./autogen.sh

Configure the build

#### sudo ./configure

Compile the source code

#### sudo make

Install the application

#### sudo make install

Now access it by running command

#### tmux

### Explanation:
- cd tmux → navigate to source code directory
- ./autogen.sh → generate build configuration files
- ./configure → prepare build environment
- make → compile source code
- make install → install compiled application
- tmux → run installed application
- sudo → run commands with elevated privileges

👉 `tmux` = **terminal multiplexer**

> 🗣️ “tmux lets me run multiple terminals inside one terminal”

## 🧠 WHAT IT DOES

👉 Inside ONE terminal, you can:

- open multiple sessions
- split screen into panes
- switch between tasks
- keep processes running after disconnect

## 🧪 REAL USE CASE

👉 You SSH into a server:

    ssh server

Start tmux:

    tmux

Run something long:

    apt-get update

👉 Disconnect (close SSH)

👉 Reconnect later…

    tmux attach

✔️ Your session is STILL running

## 🔥 WHY THIS IS POWERFUL

👉 tmux = “don’t lose your work”

## ⚠️ IS IT INSTALLED BY DEFAULT?

👉 ❌ NO (usually NOT on Ubuntu)

## 📦 INSTALL IT

    sudo apt-get update
    sudo apt-get install tmux

## 🛠️ BASIC COMMANDS

### Start session
    tmux

### Detach (leave session running)
    Ctrl + b  then  d

### List sessions
    tmux ls

### Reattach
    tmux attach

### Kill session
    tmux kill-session

## 🧠 SPLIT SCREEN

### Vertical split
    Ctrl + b  then  %

### Horizontal split
    Ctrl + b  then  "

## ⚠️ LFCS NOTE

👉 tmux is NOT usually tested directly

👉 BUT it is:
- VERY useful during exam
- helps manage multiple tasks

## 🧠 FINAL LOCK-IN

👉 tmux = multiple terminals + persistent sessions  
👉 not installed by default → install it  
👉 key combo = Ctrl + b  

👉 Think:

    “tmux keeps my terminal alive”

</details>


