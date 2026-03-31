# File Permissions & Search — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: What command can be used to find files and directories modified in the last 5 minutes in the /dev directory?

<details>
<summary>Answer</summary>

### Command
    find /dev -mmin -5

### Explanation
- find → search filesystem
- /dev → starting directory
- -mmin → modified time in minutes
- -5 → less than 5 minutes ago

</details>

---

## 🧪 Task 2

Task: What command removes the write permission for the group from a file?

<details>
<summary>Answer</summary>

### Command
    chmod g-w some_file

### Explanation
- chmod → change permissions
- g → group
- -w → remove write permission

</details>

---

## 🧪 Task 3

Task: Find files/directories under the /var/log/ directory that the group can write to, but others cannot read or write to it. Save the list of the files/directories (with complete parent path) in the /home/bob/data.txt file.

You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/data.txt

To make this easier to understand, the logic of the command can be broken down like this:

-> Permissions for the group have to be at least w. If there's also an extra r or x in there, it will still match.

-> Permissions for others have not to be r or w. That means, if any of these two permissions, r or w, match for others, the result has to be excluded.

<details>
<summary>Answer</summary>

### Command
    sudo find /var/log -perm -g=w ! -perm /o=rw > /home/bob/data.txt

### Explanation
- -perm -g=w → group has write permission as a minimum match
- ! → NOT
- -perm /o=rw → exclude entries where others have read or write
- `>` → redirect output to a file

</details>

---

## 🧪 Task 4

Task: Find our secret file under /home/bob. You can either look for a file that is exactly 213 kilobytes or a file that has permission 402 in octal.

Save the name (including the parent directory path) of this file in the /home/bob/secfile.txt file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/secfile.txt

<details>
<summary>Answer</summary>

### Command
    find /home/bob -size 213k -o -perm 402 > /home/bob/secfile.txt

### Explanation
- -size 213k → exactly 213 KB
- -o → OR
- -perm 402 → exact permission match
- `>` → save output to file

</details>

---

## 🧪 Task 5

Task: In our lessons, we briefly mentioned the setuid, setgid, and sticky bit special permissions. Consider that setuid is short for set user id and setgid is short for set group id.

Add the permissions for setuid, setgid, and sticky bit on the /home/bob/datadir directory.

Do not use octal notation for this question.

<details>
<summary>Answer</summary>

### Command
    chmod u+s,g+s,o+t /home/bob/datadir

### Explanation
- u+s → setuid
- g+s → setgid
- o+t → sticky bit

</details>

---

## 🧪 Task 6

Task: Find the dogs.txt file under the /usr/share directory.

Save the location of the file in the /home/bob/dogs file.

<details>
<summary>Answer</summary>

### Command
    sudo find /usr/share -name dogs.txt > /home/bob/dogs

### Explanation
- -name dogs.txt → match exact filename
- `>` → save full path output to file

</details>

---

## 🧪 Task 7

Task: Find the cats.txt file under bob's home directory and copy it into the /opt directory.

<details>
<summary>Answer</summary>

### Command
    sudo find /home/bob -name cats.txt
    sudo cp /home/bob/.etc/h/e/r/cats.txt /opt/cats.txt

### Explanation
- find → locate the file first
- cp → copy the file into /opt
- /home/bob/.etc/h/e/r/cats.txt → example discovered full path from the lab

</details>

---

## 🧪 Task 8

Task: Find all directories named pets in the /var/directory and save the output (along with directory path) in the/home/bob/pets.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/pets.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /var/ -type d -name pets > /home/bob/pets.txt

### Explanation
- -type d → directories only
- -name pets → match directories named pets
- `>` → save output to file

</details>

---

## 🧪 Task 9

Task: Find all the files whose permissions are 0777 in /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -perm 0777 -print

### Explanation
- -type f → files only
- -perm 0777 → exact permission match
- -print → display matching paths

</details>

---

## 🧪 Task 10

Task: Find all the files whose permissions are 0640 in /usr/ directory and save the output (along with parent path) in /home/bob/.opt/permissions.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/.opt/permissions.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -perm 0640 > /home/bob/.opt/permissions.txt

### Explanation
- -type f → files only
- -perm 0640 → exact permission match
- `>` → redirect output to file

</details>

---

## 🧪 Task 11

Task: Find all the files which have been modified in the last 2 hours in /usr directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -mmin -120

### Explanation
- -type f → files only
- -mmin -120 → modified within the last 120 minutes

</details>

---

## 🧪 Task 12

Task: Find all the files which have been modified in the last 30 minutes in the /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -mmin -30 | wc -l

### Explanation
- -type f → files only
- -mmin -30 → modified within the last 30 minutes
- `|` → send output from one command into the next
- wc -l → count matching lines

</details>

---

## 🧪 Task 13

Task: Find all the files with size 20MB in /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -size 20M

### Explanation
- -type f → files only
- -size 20M → exactly 20 MB

</details>

---

## 🧪 Task 14

Task: Find all files between 5MB and 10MB in the /usr directory and save the output (along with parent path) in the/home/bob/size.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/size.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -size +5M -size -10M > /home/bob/size.txt

### Explanation
- -type f → files only
- -size +5M → larger than 5 MB
- -size -10M → smaller than 10 MB
- `>` → save output to file

</details>

---

## 🧪 Task 15

Task: Create a directory named LFCS under bob's home directory and update its user owner permissions to only x (execute), and group and others should not have any permissions.

It should give us a permission denied error while listing the contents of the directory.

<details>
<summary>Answer</summary>

### Command
    sudo mkdir /home/bob/LFCS
    sudo chmod 0100 /home/bob/LFCS

### Explanation
- mkdir → create directory
- chmod 0100 → owner gets execute only
- no read permission → listing contents fails with permission denied

</details>

---

## 🧪 Task 16

Task: Update the permissions for some_directory to rwxr-xr-x

<details>
<summary>Answer</summary>

### Command
    chmod 0755 some_directory/

### Explanation
- 7 → rwx for owner
- 5 → r-x for group
- 5 → r-x for others

</details>
