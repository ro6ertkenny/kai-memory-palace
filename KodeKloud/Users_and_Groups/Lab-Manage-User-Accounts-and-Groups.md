# Lab - Manage User Accounts and Groups

## Task:

Set the jane user account to expire on March 1, 2030.

Has the expiration date been set for user jane?

<details><summary>Answer</summary>
Use the below command:

#### sudo usermod -e 2030-03-01 jane
</details>

### Explanation:
- usermod → modify user account
- sudo → run with elevated privileges
- -e 2030-03-01 → set account expiration date
- jane → target user

---

## Task:

Create a system account called apachedev

Has system account "apachedev" been created?

<details><summary>Answer</summary>
Use the below command:

#### sudo useradd --system apachedev
</details>

### Explanation:
- useradd → create new user
- --system → create system account (no login, lower UID)
- apachedev → username
- sudo → run with elevated privileges

---

## Task:

Jane's account, i.e., jane, is expired. Unexpire the same and make sure it never expires again.

Has Jane user account been unexpired?

<details><summary>Answer</summary>
Use the below command:

#### sudo usermod -e "" jane
</details>

### Explanation:
- usermod → modify user account
- -e "" → remove expiration date (never expires)
- jane → target user
- sudo → run with elevated privileges

---

## Task:

Create a user account called jack with home directory and set its default login shell to be /bin/csh.

Has user Jack been added and is its shell /bin/csh?

<details><summary>Answer</summary>
Execute the below command:

#### sudo useradd -s /bin/csh -m jack
</details>

### Explanation:
- useradd → create user
- -s /bin/csh → set login shell
- -m → create home directory
- jack → username
- sudo → run with elevated privileges

---

## Task:

Delete the user account called jack and ensure his home directory is removed.

Is user Jack removed?

Is user Jack's home directory also removed?

<details><summary>Answer</summary>
Execute the below command:

#### sudo userdel -r jack
</details>

### Explanation:
- userdel → delete user
- -r → remove home directory and mail spool
- jack → target user
- sudo → run with elevated privileges

---

## Task:

Mark the password for jane as expired to force her to immediately change it the next time she logs in.

Is password expiration set for user Jane?

<details><summary>Answer</summary>
Execute the below command:

#### sudo chage --lastday 0 jane
</details>

### Explanation:
- chage → change password aging info
- --lastday 0 → set last password change to day 0 (forces change)
- jane → target user
- sudo → run with elevated privileges

---

## Task:

Add the user jane to the group called developers.

Is user Jane added to the developers group?

<details><summary>Answer</summary>
Execute the below command:

#### sudo usermod -a -G developers jane
</details>

### Explanation:
- usermod → modify user account
- -a → append to existing groups
- -G developers → add to developers group
- jane → target user
- sudo → run with elevated privileges

---

## Task:

Create a group named cricket and set its GID to 9875

Is cricket group created with GID 9875?

<details><summary>Answer</summary>
Execute the below command:

#### sudo groupadd -g 9875 cricket
</details>

### Explanation:
- groupadd → create group
- -g 9875 → set group ID
- cricket → group name
- sudo → run with elevated privileges

---

## Task:

You already created a group cricket in the previous question. Now, rename this group soccer while preserving the same GID.

Is the group renamed from cricket to soccer with the same GID?

<details><summary>Answer</summary>
Execute the below command:

#### sudo groupmod -n soccer cricket
</details>

### Explanation:
- groupmod → modify group
- -n soccer → new group name
- cricket → existing group name
- GID → unchanged during rename
- sudo → run with elevated privileges

---

## Task:

Create a user sam with UID 5322. Also, make it a member of the soccer group.

Is user sam created with UID 5322?

Is user sam a member of group soccer?

<details><summary>Answer</summary>
Execute the below command:

#### sudo useradd -G soccer sam  --uid 5322
</details>

### Explanation:
- useradd → create user
- -G soccer → add to secondary group
- --uid 5322 → assign user ID
- sam → username
- sudo → run with elevated privileges

---

## Task:

Update primary group of user sam and set it to rugby

Has user sam's primary group been set to "rugby"?

<details><summary>Answer</summary>
Execute the below command:

#### sudo usermod -g rugby sam
</details>

### Explanation:
- usermod → modify user account
- -g rugby → set primary group
- sam → target user
- sudo → run with elevated privileges

---

## Task:

Delete the group called appdevs.

Has the group called appdevs been deleted?

<details><summary>Answer</summary>
Execute the below command:

#### sudo groupdel appdevs
</details>

### Explanation:
- groupdel → delete group
- appdevs → group name
- sudo → run with elevated privileges

---

## Task:

Make sure the user jane gets a warning at least 2 days before the password expires.

Are the required changes made?

<details><summary>Answer</summary>
Execute below given command:

#### sudo chage -W 2 jane
</details>

### Explanation:
- chage → manage password aging
- -W 2 → set warning period to 2 days
- jane → target user
- sudo → run with elevated privileges
