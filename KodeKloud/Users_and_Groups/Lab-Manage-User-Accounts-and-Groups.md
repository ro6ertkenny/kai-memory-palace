# Manage User Accounts & Groups — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Set the jane user account to expire on March 1, 2030.

<details>
<summary>Answer</summary>

### Command
    sudo usermod -e 2030-03-01 jane

### Explanation
- usermod → modify existing user account
- -e 2030-03-01 → set account expiration date
- jane → target user

</details>

---

## 🧪 Task 2

Task: Create a system account called apachedev.

<details>
<summary>Answer</summary>

### Command
    sudo useradd --system apachedev

### Explanation
- useradd → create user
- --system → create system account
- apachedev → username

</details>

---

## 🧪 Task 3

Task: Jane's account is expired. Unexpire it and make sure it never expires again.

<details>
<summary>Answer</summary>

### Command
    sudo usermod -e "" jane

### Explanation
- usermod → modify user
- -e "" → clear expiration date
- jane → target user
- result → account no longer has an expiration date

</details>

---

## 🧪 Task 4

Task: Create a user account called jack with a home directory and set its default login shell to /bin/csh.

<details>
<summary>Answer</summary>

### Command
    sudo useradd -m -s /bin/csh jack

### Explanation
- useradd → create user
- -m → create home directory
- -s /bin/csh → set login shell
- jack → username

</details>

---

## 🧪 Task 5

Task: Delete the user account called jack and ensure his home directory is removed.

<details>
<summary>Answer</summary>

### Command
    sudo userdel -r jack

### Explanation
- userdel → delete user
- -r → remove home directory and mail spool
- jack → target user

</details>

---

## 🧪 Task 6

Task: Mark the password for jane as expired so she must change it on next login.

<details>
<summary>Answer</summary>

### Command
    sudo chage --lastday 0 jane

### Explanation
- chage → change password aging settings
- --lastday 0 → force password change on next login
- jane → target user

</details>

---

## 🧪 Task 7

Task: Add the user jane to the group called developers.

<details>
<summary>Answer</summary>

### Command
    sudo usermod -aG developers jane

### Explanation
- usermod → modify user
- -aG → append supplementary group membership
- developers → group to add
- jane → target user
- `-a` is critical so existing supplementary groups are not removed

</details>

---

## 🧪 Task 8

Task: Create a group named cricket and set its GID to 9875.

<details>
<summary>Answer</summary>

### Command
    sudo groupadd -g 9875 cricket

### Explanation
- groupadd → create group
- -g 9875 → set GID
- cricket → group name

</details>

---

## 🧪 Task 9

Task: Rename group cricket to soccer while preserving the same GID.

<details>
<summary>Answer</summary>

### Command
    sudo groupmod -n soccer cricket

### Explanation
- groupmod → modify group
- -n soccer → new name
- cricket → current group name
- GID stays the same unless explicitly changed

</details>

---

## 🧪 Task 10

Task: Create a user sam with UID 5322 and make it a member of the soccer group.

<details>
<summary>Answer</summary>

### Command
    sudo useradd -u 5322 -G soccer sam

### Explanation
- useradd → create user
- -u 5322 → set UID
- -G soccer → add supplementary group membership
- sam → username

</details>

---

## 🧪 Task 11

Task: Update primary group of user sam and set it to rugby.

<details>
<summary>Answer</summary>

### Command
    sudo usermod -g rugby sam

### Explanation
- usermod → modify user
- -g rugby → set primary group
- sam → target user

</details>

---

## 🧪 Task 12

Task: Delete the group called appdevs.

<details>
<summary>Answer</summary>

### Command
    sudo groupdel appdevs

### Explanation
- groupdel → delete group
- appdevs → target group

</details>

---

## 🧪 Task 13

Task: Make sure the user jane gets a warning at least 2 days before the password expires.

<details>
<summary>Answer</summary>

### Command
    sudo chage -W 2 jane

### Explanation
- chage → manage password aging
- -W 2 → warn 2 days before password expiration
- jane → target user

</details>
