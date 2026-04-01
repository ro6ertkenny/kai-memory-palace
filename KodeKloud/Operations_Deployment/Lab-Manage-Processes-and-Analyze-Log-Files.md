# Manage Processes & Analyze Log Files — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: How can we see all processes running on the system along with their nice values?

<details>
<summary>Answer</summary>

### Command
    ps lax

### Explanation
- ps → process status
- l → long format (includes nice value)
- a → all users
- x → include processes without terminal

</details>

---

## 🧪 Task 2

Task: Which command will you use to sleep for 10 seconds?

<details>
<summary>Answer</summary>

### Command
    sleep 10

### Explanation
- sleep → pause execution
- 10 → seconds

</details>

---

## 🧪 Task 3

Task: By default, which directory contains the logs of most services?

<details>
<summary>Answer</summary>

### Command
    /var/log/

### Explanation
- /var/log → default location for system and service logs

</details>

---

## 🧪 Task 4

Task: Assign a nice value of 9 to the sshd process.

<details>
<summary>Answer</summary>

### Command
    ps aux
    sudo renice 9 <PID>

### Explanation
- ps aux → list all processes
- find sshd PID
- renice → change priority of running process
- 9 → lower priority (higher niceness)

</details>

---

## 🧪 Task 5

Task: List all files opened by the process with PID 1 and save output to /home/bob/files.txt.

<details>
<summary>Answer</summary>

### Command
    sudo lsof -p 1 > /home/bob/files.txt

### Explanation
- lsof → list open files
- -p 1 → process with PID 1
- `>` → redirect output to file

</details>

---

## 🧪 Task 6

Task: Find the last IP address that successfully connected to SSH and save it to /home/bob/ip.txt.

<details>
<summary>Answer</summary>

### Command
    sudo journalctl --unit=ssh.service -n 20 --no-pager

### Explanation
- journalctl → view system logs
- --unit=ssh.service → filter SSH logs
- -n 20 → last 20 entries
- look for "Accepted" entries

Then save manually:

    vi /home/bob/ip.txt

</details>

---

## 🧪 Task 7

Task: Identify PID of rpcbind and save it to /home/bob/pid.txt.

<details>
<summary>Answer</summary>

### Command
    pgrep -a rpcbind

### Explanation
- pgrep → find process by name
- -a → show PID and command

Then save manually:

    vi /home/bob/pid.txt

</details>

---

## 🧪 Task 8

Task: Find PID of ssh.service and send it a SIGHUP signal.

<details>
<summary>Answer</summary>

### Command
    systemctl status ssh.service
    sudo kill -SIGHUP <PID>

### Explanation
- systemctl status → find Main PID
- kill -SIGHUP → reload signal (graceful restart)

</details>

---

## 🧪 Task 9

Task: Search /var/log for files containing "reboot" and save output to /home/bob/reboot.log.

<details>
<summary>Answer</summary>

### Command
    sudo grep -r --text 'reboot' /var/log/ > /home/bob/reboot.log

### Explanation
- grep → search text
- -r → recursive
- --text → treat binary files as text
- `>` → save output

</details>

---

## 🧪 Task 10

Task: Analyze error logs using journalctl and save to /home/bob/.priority/priority.log.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    sudo journalctl -p err > .priority/priority.log

### Explanation
- -p err → filter error-level logs
- `>` → redirect output

</details>

---

## 🧪 Task 11

Task: Analyze info logs beginning with letter "c" and save to /home/bob/.priority/boot.log.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    sudo journalctl -p info -g '^c' > .priority/boot.log

### Explanation
- -p info → info-level logs
- -g '^c' → grep filter (lines starting with "c")
- `>` → save output

</details>

---

## 🧪 Task 12

Task: Display CPU and memory usage for PID 1 and save to /home/bob/resources.txt.

<details>
<summary>Answer</summary>

### Command
    ps u 1 > /home/bob/resources.txt

### Explanation
- ps u → user-oriented format (CPU, memory)
- 1 → PID 1
- `>` → redirect output

</details>

---

## 🧪 Task 13

Task: Run a sleep command for 3000 seconds in the background.

<details>
<summary>Answer</summary>

### Command
    sleep 3000 &

### Explanation
- sleep 3000 → run for 3000 seconds
- `&` → run in background

</details>
