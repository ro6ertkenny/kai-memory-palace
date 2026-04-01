# Lab: Manage Software, Repositories & Install Software from Source

## Task:

What is the difference between "apt update" and "apt upgrade"?

<details><summary>Answer</summary>

</details>

### Explanation:
- apt update → refresh package index from repositories
- retrieves latest package lists but does not install anything
- apt upgrade → install available upgrades for installed packages
- upgrades packages to newer versions without removing existing ones

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
</details>

### Explanation:
- apt search → search for packages
- "apache http server" → search string to narrow results
- apt update → refresh package index
- apt install apache2 → install Apache web server
- apache2 → package name for Apache

---

## Task:

Find out the name of the package that "/bin/ls" belongs to and save it in package.txt under /home/bob.

Is the name of the package that /bin/ls belongs to stored in /home/bob/package.txt?

<details><summary>Answer</summary>
We can find the package by

#### dpkg --search /bin/ls

and save the output to below file

#### vi /home/bob/package.txt
</details>

### Explanation:
- dpkg → package management tool
- --search → find which package owns a file
- /bin/ls → file being searched
- vi → manually save output to file
- /home/bob/package.txt → destination file

---

## Task:

List the files that belong to the coreutils package. Filter out the entries that were installed in the /bin directory. You will see one file in this /bin directory with a name that begins with the letter "u". Identify the complete path of this file in the /bin directory and save it in name.txt file under /home/bob?

Is the package name saved to the /home/bob/name.txt file?

<details><summary>Answer</summary>
We can list the files that belong to the coreutils package by running the below command.

dpkg --listfiles coreutils | grep ^/bin
Identify the package name that begins with the letter u (/bin/uname) and save the answer to

#### vi /home/bob/name.txt
</details>

### Explanation:
- dpkg --listfiles coreutils → list files in coreutils package
- grep ^/bin → filter files in /bin directory
- ^/bin → match paths starting with /bin
- /bin/uname → file starting with letter "u"
- vi → save result manually
- /home/bob/name.txt → destination file

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
</details>

### Explanation:
- apt-get remove → remove package
- --auto-remove → remove unused dependencies
- -y → automatically confirm prompts
- ziptool → package being removed
- dependencies → automatically removed with --auto-remove

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
</details>

### Explanation:
- /etc/apt/sources.list → repository configuration file
- sudo vim → edit file with elevated privileges
- deb http://us.archive.ubuntu.com/ubuntu/ focal main → repository entry
- focal → Ubuntu 20.04 release
- apt update → refresh package index with new repository

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
</details>

### Explanation:
- cd tmux → navigate to source code directory
- ./autogen.sh → generate build configuration files
- ./configure → prepare build environment
- make → compile source code
- make install → install compiled application
- tmux → run installed application
- sudo → run commands with elevated privileges
