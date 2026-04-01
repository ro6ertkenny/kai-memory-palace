# Configure User Resource Limits & User Privileges — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Which keyword can we use to limit the number of processes a user can run?

<details>
<summary>Answer</summary>

### Command
    nproc

### Explanation
- nproc → limit number of processes
- used in `/etc/security/limits.conf`

</details>

---

## 🧪 Task 2

Task: Modify the security limits file so user trinity can run no more than 30 processes in her session. This should be both a hard and soft limit, written in a single line.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/security/limits.conf

    trinity - nproc 30

### Explanation
- trinity → target user
- - → apply both soft and hard limits
- nproc → process count limit
- 30 → maximum allowed processes

</details>

---

## 🧪 Task 3

Task: Identify all security limits currently applied in our user's session and save them in /home/bob/limits.

<details>
<summary>Answer</summary>

### Command
    ulimit -a > /home/bob/limits

### Explanation
- ulimit -a → show all current shell/session limits
- `>` → redirect output to file

</details>

---

## 🧪 Task 4

Task: Modify sudoers so user trinity can run any sudo command without entering her password.

<details>
<summary>Answer</summary>

### Command
    sudo visudo

    trinity ALL=(ALL) NOPASSWD: ALL

### Explanation
- visudo → safely edit sudoers file
- trinity → target user
- ALL=(ALL) → may run as any user
- NOPASSWD: ALL → no password required for any command

</details>

---

## 🧪 Task 5

Task: Remove the previous sudoers entry for trinity and add a new one that allows trinity to run only /usr/bin/mount with sudo.

<details>
<summary>Answer</summary>

### Command
    sudo visudo

    trinity ALL=(ALL) /usr/bin/mount

### Explanation
- remove old trinity entry first
- new rule allows only `/usr/bin/mount`
- no other sudo commands are allowed by this rule

</details>

---

## 🧪 Task 6

Task: Set a hard file size limit of 4 MiB for user stephen.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/security/limits.conf

    stephen hard fsize 4096

### Explanation
- stephen → target user
- hard → hard limit
- fsize → maximum file size
- 4096 → size in KiB, which equals 4 MiB

</details>

---

## 🧪 Task 7

Task: Set a soft limit of 20 processes for everyone in the salesteam group.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/security/limits.conf

    @salesteam soft nproc 20

### Explanation
- @salesteam → group entry
- soft → soft limit
- nproc → number of processes
- 20 → maximum soft limit

</details>

---

## 🧪 Task 8

Task: Define a policy for all users in the salesteam group to run any sudo command.

<details>
<summary>Answer</summary>

### Command
    sudo visudo

    %salesteam ALL=(ALL) ALL

### Explanation
- %salesteam → group in sudoers
- ALL=(ALL) → may run as any user
- ALL → may run any command
- password is still required unless NOPASSWD is added

</details>

---

## 🧪 Task 9

Task: Define a policy so user trinity can run sudo commands as user sam.

<details>
<summary>Answer</summary>

### Command
    sudo visudo

    trinity ALL=(sam) ALL

### Explanation
- trinity → target user
- ALL=(sam) → may run commands as user `sam`
- ALL → any command, but only as `sam`

</details>

---

## 🧪 Task 10

Task: We applied a hard limit of 10 processes for all users under developers group, but the limit isn't working. Fix the issue.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/security/limits.conf

    @developers hard nproc 10

### Explanation
- `@developers` → group entry
- hard → hard limit
- nproc → process count limit
- 10 → maximum allowed
- the fix is using `@` so the entry applies to the group instead of a username

</details>

---

## 🧪 Task 11

Task: Remove the previous sudoers entry for trinity and add a new one that allows trinity to run all commands with sudo, but only after entering the password.

<details>
<summary>Answer</summary>

### Command
    sudo visudo

    trinity ALL=(ALL) ALL

### Explanation
- remove old trinity entry first
- ALL=(ALL) → may run as any user
- ALL → may run any command
- no `NOPASSWD` means password is required

</details>
