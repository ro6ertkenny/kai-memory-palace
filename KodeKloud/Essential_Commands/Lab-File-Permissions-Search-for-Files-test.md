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
- -mmin → modified time (in minutes)
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

Task: Find files/directories under the /var/log/ directory that the group can write to, but others cannot read or write to it. Save the list in /home/bob/data.txt.

<details>
<summary>Answer</summary>

### Command
    sudo find /var/log -perm -g=w ! -perm /o=rw > /home/bob/data.txt

### Explanation
- -perm -g=w → group has write (minimum match)
- ! → NOT
- -perm /o=rw → exclude if others have read OR write
- > → redirect output to file

</details>

---

## 🧪 Task 4

Task: Find a file under /home/bob that is either exactly 213 kilobytes OR has permission 402. Save the full path in /home/bob/secfile.txt.

<details>
<summary>Answer</summary>

### Command
    find /home/bob -size 213k -o -perm 402 > /home/bob/secfile.txt

### Explanation
- -size 213k → exactly 213 KB
- -o → OR
- -perm 402 → exact permission match
- > → save output

</details>

---

## 🧪 Task 5

Task: Add setuid, setgid, and sticky bit permissions to /home/bob/datadir (no octal).

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

Task: Find the dogs.txt file under /usr/share and save its location in /home/bob/dogs.

<details>
<summary>Answer</summary>

### Command
    sudo find /usr/share -name dogs.txt > /home/bob/dogs

### Explanation
- -name → match filename
- > → save full path output

</details>

---

## 🧪 Task 7

Task: Find the cats.txt file under bob's home directory and copy it into /opt.

<details>
<summary>Answer</summary>

### Command
    sudo find /home/bob -name cats.txt
    sudo cp /home/bob/.../cats.txt /opt/cats.txt

### Explanation
- find → locate file
- cp → copy to /opt
- ... → actual discovered path

</details>

---

## 🧪 Task 8

Task: Find all directories named pets in /var and save output to /home/bob/pets.txt.

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type d -name pets > /home/bob/pets.txt

### Explanation
- -type d → directories only
- -name pets → match directory name

</details>

---

## 🧪 Task 9

Task: Find all files with permission 0777 in /var. How many did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -perm 0777

### Explanation
- -type f → files only
- -perm 0777 → exact permissions

</details>

---

## 🧪 Task 10

Task: Find all files with permission 0640 in /usr and save output to /home/bob/.opt/permissions.txt.

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -perm 0640 > /home/bob/.opt/permissions.txt

### Explanation
- -perm 0640 → exact match
- > → redirect output

</details>

---

## 🧪 Task 11

Task: Find all files modified in the last 2 hours in /usr. How many did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -mmin -120

### Explanation
- -mmin -120 → last 120 minutes (2 hours)

</details>

---

## 🧪 Task 12

Task: Find all files modified in the last 30 minutes in /var. How many did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -mmin -30 | wc -l

### Explanation
- -mmin -30 → last 30 minutes
- wc -l → count results

</details>

---

## 🧪 Task 13

Task: Find all files with size 20MB in /var. How many did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -size 20M

### Explanation
- -size 20M → exactly 20 MB

</details>

---

## 🧪 Task 14

Task: Find all files between 5MB and 10MB in /usr and save output to /home/bob/size.txt.

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -size +5M -size -10M > /home/bob/size.txt

### Explanation
- +5M → greater than 5MB
- -10M → less than 10MB

</details>

---

## 🧪 Task 15

Task: Create a directory LFCS under /home/bob and set permissions so only the owner has execute permission.

<details>
<summary>Answer</summary>

### Command
    sudo mkdir /home/bob/LFCS
    sudo chmod 0100 /home/bob/LFCS

### Explanation
- 0100 → owner execute only
- no read → cannot list directory contents

</details>

---

## 🧪 Task 16

Task: Update permissions for some_directory to rwxr-xr-x.

<details>
<summary>Answer</summary>

### Command
    chmod 0755 some_directory/

### Explanation
- 7 → rwx (owner)
- 5 → r-x (group)
- 5 → r-x (others)

</details>

---

## 📌 Commit

    git add linux/LFCS-training/execution-drills/file-permissions-and-search.md
    git commit -m "Add LFCS drill: file permissions and search (hidden-answer format)"
    git push
