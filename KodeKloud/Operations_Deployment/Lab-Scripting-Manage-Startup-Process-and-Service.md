# Scripting, Startup Process & Services — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Schedule this system to power off two hours later from now.

<details>
<summary>Answer</summary>

### Command
    sudo shutdown +120

### Explanation
- shutdown → schedule system shutdown
- +120 → time in minutes (120 = 2 hours)

</details>

---

## 🧪 Task 2

Task: Change the system to boot into a graphical desktop by default.

<details>
<summary>Answer</summary>

### Command
    sudo systemctl set-default graphical.target

### Explanation
- systemctl → manage systemd
- set-default → set default boot target
- graphical.target → GUI mode

</details>

---

## 🧪 Task 3

Task: Cancel the scheduled shutdown.

<details>
<summary>Answer</summary>

### Command
    sudo shutdown -c

### Explanation
- -c → cancel scheduled shutdown

</details>

---

## 🧪 Task 4

Task: How do we run script.sh that is located in our current directory?

<details>
<summary>Answer</summary>

### Command
    ./script.sh

### Explanation
- ./ → current directory
- required because current directory is not in PATH by default

</details>

---

## 🧪 Task 5

Task: What is the correct shebang to add in a script?

<details>
<summary>Answer</summary>

### Command
    #!/bin/bash

### Explanation
- #! → shebang (interpreter directive)
- /bin/bash → specifies Bash shell

</details>

---

## 🧪 Task 6

Task: Create script.sh under /home/bob that archives dir1 into archive.tar.gz and execute it.

<details>
<summary>Answer</summary>

### Command
    vi /home/bob/script.sh

    #!/bin/bash
    tar -acf archive.tar.gz dir1

    chmod u+x /home/bob/script.sh
    cd /home/bob
    ./script.sh

### Explanation
- tar -a → auto-detect compression (gzip via .gz)
- -c → create archive
- -f → output file
- chmod u+x → make script executable

</details>

---

## 🧪 Task 7

Task: Find the PID of the sshd.service process and save it in /home/bob/pid.

<details>
<summary>Answer</summary>

### Command
    systemctl status sshd.service

### Explanation
- look for "Main PID" in output
- manually save it:

    vi /home/bob/pid

- write the PID value (e.g., 134)

</details>

---

## 🧪 Task 8

Task: Create script2.sh to display if sshd.service is enabled or disabled.

<details>
<summary>Answer</summary>

### Command
    vi /home/bob/script2.sh

    #!/bin/bash
    systemctl is-enabled sshd.service

    chmod u+x /home/bob/script2.sh
    /home/bob/script2.sh

### Explanation
- systemctl is-enabled → checks if service starts at boot
- outputs enabled/disabled

</details>

---

## 🧪 Task 9

Task: Create /home/bob/perm.sh to set /home/bob/dir8 permissions to owner execute only.

<details>
<summary>Answer</summary>

### Command
    vi /home/bob/perm.sh

    #!/bin/bash
    chmod 0100 /home/bob/dir8

    chmod u+x /home/bob/perm.sh
    /home/bob/perm.sh

### Explanation
- 0100 → owner execute only
- no permissions for group or others

</details>

---

## 🧪 Task 10

Task: Fix script10.sh so it runs correctly.

<details>
<summary>Answer</summary>

### Command
    chmod 700 /home/bob/script10.sh

    vi /home/bob/script10.sh

    #!/bin/bash
    cat test.txt

### Explanation
- chmod 700 → make script executable by owner
- cat test.txt → correct command inside script

</details>

---

## 🧪 Task 11

Task: Copy the output of sshd.service status to /home/bob/service.txt.

<details>
<summary>Answer</summary>

### Command
    sudo systemctl status sshd.service > /home/bob/service.txt

### Explanation
- systemctl status → show service status
- `>` → redirect output to file

</details>

---

## 🧪 Task 12

Task: Mask the apache2 service.

<details>
<summary>Answer</summary>

### Command
    sudo systemctl mask apache2.service

### Explanation
- mask → prevents service from being started (even manually)

</details>

---

## 🧪 Task 13

Task: Unmask the apache2 service.

<details>
<summary>Answer</summary>

### Command
    sudo systemctl unmask apache2.service

### Explanation
- unmask → restore ability to start service

</details>

---

## 🧪 Task 14

Task: Fix kkloud.service with the following requirements:
- Restart always
- Add stop command
- Start after sshd.service

<details>
<summary>Answer</summary>

### Command
    vi /etc/systemd/system/kkloud.service

### Correct File
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

### Explanation
- Restart=always → restart regardless of exit reason
- ExecStop → defines shutdown command
- After=sshd.service → dependency ordering

</details>
