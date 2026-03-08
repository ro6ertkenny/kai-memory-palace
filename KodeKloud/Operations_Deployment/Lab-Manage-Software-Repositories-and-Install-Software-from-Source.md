# Lab: Manage Software, Repositories & Install Software from Source

## Task:

What is the difference between "apt update" and "apt upgrade"?

## Solution:


## Task:

Install the Apache web server.

To find the package you need, you can search for this text: apache http server. In your search command, you can wrap this search string between " " double quotes to get fewer results and find the package easier.

Is apache webserver installed?

## Solution:

#### sudo apt search "apache http server"

Install the Apache web server

#### sudo apt update 
#### sudo apt install apache2


## Task:

Find out the name of the package that "/bin/ls" belongs to and save it in package.txt under /home/bob.

Is the name of the package that /bin/ls belongs to stored in /home/bob/package.txt?

## Solution:

We can find the package by

#### dpkg --search /bin/ls

and save the output to below file

#### vi /home/bob/package.txt


## Task:

List the files that belong to the coreutils package. Filter out the entries that were installed in the /bin directory. You will see one file in this /bin directory with a name that begins with the letter "u". Identify the complete path of this file in the /bin directory and save it in name.txt file under /home/bob?

Is the package name saved to the /home/bob/name.txt file?

## Solution:

We can list the files that belong to the coreutils package by running the below command.

dpkg --listfiles coreutils | grep ^/bin
Identify the package name that begins with the letter u (/bin/uname) and save the answer to

#### vi /home/bob/name.txt


## Task:

Uninstall the package ziptool and its dependency package(s) from the system.

Are ziptool and its dependencies removed?

## Solution:

Execute the below command and observe the output

#### sudo apt-get remove --auto-remove -y ziptool

Observe the highlighted section
#### The following packages will be REMOVED:
####  libzip4 ziptool


## Task:

In rare cases, we may need to get packages that were available on an older Ubuntu distribution.

Configure the package manager with this extra repository:

#### deb http://us.archive.ubuntu.com/ubuntu/ focal main

This will make packages from Ubuntu 20.04 (codenamed Focal Fossa) available on this system.

Don't forget to also update APT's local cache

Is the information on the remote repository focal available now?

## Solution:

Add this repository information to the /etc/apt/sources.list file.

#### bob@ubuntu-host /etc/apt🔒 ➜  sudo vim sources.list

And add the repo

#### deb http://us.archive.ubuntu.com/ubuntu/ focal main

Run the below command

#### sudo apt update 


## Task:

In the tmux directory, you will find the source code for the tmux application. All compilation tools and libraries were already installed for you.

1. Build the application (compile source code).
2. Install it on the system.

Is tmux application installed?

## Solution:

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
