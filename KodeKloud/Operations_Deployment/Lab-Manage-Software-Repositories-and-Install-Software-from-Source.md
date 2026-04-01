# Manage Software, Repositories & Install from Source — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: What is the difference between "apt update" and "apt upgrade"?

<details>
<summary>Answer</summary>

### Command
    apt update
    apt upgrade

### Explanation
- apt update → refresh package index (what versions are available)
- apt upgrade → install newer versions of already installed packages
- update = "what’s available"
- upgrade = "install updates"

</details>

---

## 🧪 Task 2

Task: Install the Apache web server.

<details>
<summary>Answer</summary>

### Command
    sudo apt search "apache http server"
    sudo apt update
    sudo apt install apache2

### Explanation
- apt search → find package name
- apt update → refresh repo metadata
- apt install apache2 → install Apache web server

</details>

---

## 🧪 Task 3

Task: Find which package /bin/ls belongs to and save it in /home/bob/package.txt.

<details>
<summary>Answer</summary>

### Command
    dpkg -S /bin/ls > /home/bob/package.txt

### Explanation
- dpkg -S → search which package owns a file
- /bin/ls → file to search
- `>` → save output to file

</details>

---

## 🧪 Task 4

Task: Find files from coreutils in /bin, identify the one starting with "u", and save full path in /home/bob/name.txt.

<details>
<summary>Answer</summary>

### Command
    dpkg -L coreutils | grep ^/bin

### Explanation
- dpkg -L → list files from package
- coreutils → package name
- grep ^/bin → filter only /bin entries
- expected match → /bin/uname

Save result:

    echo /bin/uname > /home/bob/name.txt

</details>

---

## 🧪 Task 5

Task: Uninstall ziptool and its dependencies.

<details>
<summary>Answer</summary>

### Command
    sudo apt-get remove --auto-remove -y ziptool

### Explanation
- remove → uninstall package
- --auto-remove → remove unused dependencies
- -y → auto-confirm

</details>

---

## 🧪 Task 6

Task: Add Ubuntu 20.04 (focal) repository and update APT.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/apt/sources.list

    deb http://us.archive.ubuntu.com/ubuntu/ focal main

    sudo apt update

### Explanation
- sources.list → repo configuration file
- deb → repository entry
- apt update → refresh package list with new repo

</details>

---

## 🧪 Task 7

Task: Build and install tmux from source in /home/bob/tmux.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob/tmux
    ./autogen.sh
    ./configure
    make
    sudo make install

### Explanation
- autogen.sh → generate build system files
- configure → prepare build environment
- make → compile source code
- make install → install compiled binaries into system

</details>
