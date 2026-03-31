# Files, Directories, Hard & Soft Links — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: What is the top-level directory in Linux?

<details>
<summary>Answer</summary>

### Command
    /

### Explanation
- `/` → root directory
- top of the filesystem
- nothing exists above it

</details>

---

## 🧪 Task 2

Task: In what form does Linux organise files and directories?

<details>
<summary>Answer</summary>

### Command
    Filesystem tree

### Explanation
- tree structure → hierarchical
- everything branches from `/`

</details>

---

## 🧪 Task 3

Task: What is the command to print your current working directory?

<details>
<summary>Answer</summary>

### Command
    pwd

### Explanation
- pwd → print working directory
- shows your current location in the filesystem

</details>

---

## 🧪 Task 4

Task: What is the command to climb up one directory?

<details>
<summary>Answer</summary>

### Command
    cd ..

### Explanation
- cd → change directory
- .. → parent directory (one level up)

</details>

---

## 🧪 Task 5

Task: If we'd want to delete the Documents directory, how would we specify the path?

<details>
<summary>Answer</summary>

### Command
    /home/bob/Documents

### Explanation
- absolute path → starts from `/`
- follows directory chain down to target

</details>

---

## 🧪 Task 6

Task: Create a directory named lfcs under the /home/bob directory.

<details>
<summary>Answer</summary>

### Command
    mkdir /home/bob/lfcs

### Explanation
- mkdir → make directory
- full path ensures correct location

</details>

---

## 🧪 Task 7

Task: Create a blank file named lfcs.txt under the /home/bob/lfcs directory.

<details>
<summary>Answer</summary>

### Command
    touch /home/bob/lfcs/lfcs.txt

### Explanation
- touch → create empty file
- also updates timestamp if file exists

</details>

---

## 🧪 Task 8

Task: Copy the /tmp/Invoice directory (including all its contents) to the /home/bob directory.

<details>
<summary>Answer</summary>

### Command
    cp -r /tmp/Invoice /home/bob/

### Explanation
- cp → copy
- -r → recursive (copy directories + contents)

</details>

---

## 🧪 Task 9

Task: Copy the /home/bob/myfile.txt file to the /home/bob/data/ directory. Make sure to preserve its attributes.

<details>
<summary>Answer</summary>

### Command
    cp -a /home/bob/myfile.txt /home/bob/data/

### Explanation
- -a → archive mode
- preserves permissions, ownership, timestamps

</details>

---

## 🧪 Task 10

Task: Copy the /home/bob/lfcs directory (including all its content) into the /home/bob/old-data/ directory.

<details>
<summary>Answer</summary>

### Command
    cp -r /home/bob/lfcs /home/bob/old-data/

### Explanation
- -r → recursive copy of directory and contents

</details>

---

## 🧪 Task 11

Task: Delete the /home/bob/lfcs/lfcs.txt file.

<details>
<summary>Answer</summary>

### Command
    rm /home/bob/lfcs/lfcs.txt

### Explanation
- rm → remove file
- permanently deletes (no recycle bin)

</details>

---

## 🧪 Task 12

Task: Move all contents, excluding the directory itself, from /home/bob/lfcs to /home/bob/new-data/ directory.

<details>
<summary>Answer</summary>

### Command
    mv /home/bob/lfcs/* /home/bob/new-data/

### Explanation
- mv → move files
- * → all contents inside directory (not the directory itself)

</details>

---

## 🧪 Task 13

Task: Delete directory /home/bob/lfcs.

<details>
<summary>Answer</summary>

### Command
    rm -rf /home/bob/lfcs

### Explanation
- -r → recursive (delete directory + contents)
- -f → force (no prompts)

</details>

---

## 🧪 Task 14

Task: Create a soft link to /tmp directory in /home/bob called link_to_tmp.

<details>
<summary>Answer</summary>

### Command
    ln -s /tmp /home/bob/link_to_tmp

### Explanation
- ln → create link
- -s → symbolic (soft link)
- points to target path

</details>

---

## 🧪 Task 15

Task: Create a hard link to /opt/hlink file in /home/bob called hlink.

<details>
<summary>Answer</summary>

### Command
    ln /opt/hlink /home/bob/hlink

### Explanation
- ln → create link
- no -s → hard link
- same inode as original file

</details>

---

## 🧪 Task 16

Task: Rename /home/bob/new_file to /home/bob/old_file.

<details>
<summary>Answer</summary>

### Command
    mv /home/bob/new_file /home/bob/old_file

### Explanation
- mv → move/rename
- same directory → acts as rename

</details>

---

## 🧪 Task 17

Task: Create directory /tmp/1/2/3/4/5/6/7/8/9 in one command.

<details>
<summary>Answer</summary>

### Command
    mkdir -p /tmp/1/2/3/4/5/6/7/8/9

### Explanation
- -p → create parent directories as needed
- builds full path in one command

</details>

---

## 🧪 Task 18

Task: Display the full/exact last modified time for files in /home/bob.

<details>
<summary>Answer</summary>

### Command
    ls --full-time /home/bob

### Explanation
- ls → list files
- --full-time → show full timestamp (date + seconds)

</details>
