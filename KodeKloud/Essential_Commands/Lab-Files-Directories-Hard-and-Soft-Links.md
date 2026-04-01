# Files, Directories, Hard and Soft Links — LFCS Lab

---

## 🧪 Task

Task: What is the top-level directory in Linux?

<details>
<summary>Answer</summary>

## Solution:

The root directory is /. This is the top-level directory. There can be no other directories above it.

### Explanation

- / → root directory
- top-level directory in Linux filesystem hierarchy

</details>

---

## 🧪 Task

Task: In what form does Linux organise files and directories?

<details>
<summary>Answer</summary>

## Solution:

Linux organizes files and directories in a filesystem tree.

### Explanation

- filesystem tree → hierarchical structure
- everything branches from the root directory

</details>

---

## 🧪 Task

Task: What is the command to print your current working directory?

<details>
<summary>Answer</summary>

## Solution:

#### pwd

### Explanation

- pwd → print working directory
- shows your current location in the filesystem

</details>

---

## 🧪 Task

Task: What is the command to climb up one directory?

<details>
<summary>Answer</summary>

## Solution:

#### cd .. 

is the command to climb up one directory.

### Explanation

- cd → change directory
- .. → parent directory

</details>

---

## 🧪 Task

Task: Absolute paths always start out with the root directory /. Then we specify the sub-directories we want to descend into; /home/bob/Documents/Invoice.pdf is an example of such a path. In this case, first home, then bob, and then Documents. We can see the sub-directory names are separated by a /, and we finally get to the file we want to access, i.e, Invoice.pdf. An absolute path can end with the name of a file or a directory.

As per the example above, If we'd want to delete the Documents directory, how would we specify the path?

<details>
<summary>Answer</summary>

## Solution:

If we'd want to delete the Documents directory, we'd specify the path like: /home/bob/Documents

### Explanation

- absolute path → starts from /
- /home/bob/Documents → full path to the Documents directory

</details>

---

## 🧪 Task

Task: Create a directory named lfcs under the /home/bob directory.

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### mkdir /home/bob/lfcs

### Explanation

- mkdir → make directory
- /home/bob/lfcs → full path of the new directory

</details>

---

## 🧪 Task

Task: Create a blank file named lfcs.txt under the/home/bob/lfcs directory.

Is the "/home/bob/lfcs/lfcs.txt" file created?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### touch  /home/bob/lfcs/lfcs.txt

### Explanation

- touch → creates an empty file if it does not exist
- /home/bob/lfcs/lfcs.txt → full path of the file

</details>

---

## 🧪 Task

Task: Copy the /tmp/Invoice directory (including all its contents) to the /home/bob directory.

Is the "/tmp/Invoice" directory copied to the "/home/bob" directory?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### cp -r /tmp/Invoice  /home/bob/

### Explanation

- cp → copy files/directories
- -r → recursive, so the directory and all contents are copied

</details>

---

## 🧪 Task

Task: Copy the /home/bob/myfile.txt file to the/home/bob/data/ directory. Make sure to preserve its attributes.

Is the file copied with all attributes?

<details>
<summary>Answer</summary>

## Solution:

#### cp -a /home/bob/myfile.txt /home/bob/data/

### Explanation

- cp → copy
- -a → archive mode, preserves attributes like permissions and timestamps

</details>

---

## 🧪 Task

Task: Copy the /home/bob/lfcs directory (including all its content) into the /home/bob/old-data/ directory.

Is the "/home/bob/lfcs" directory copied into the "/home/bob/old-data/" directory?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

#### cp -r /home/bob/lfcs /home/bob/old-data/

### Explanation

- cp → copy
- -r → recursive copy of the directory and everything inside it

</details>

---

## 🧪 Task

Task: Delete the /home/bob/lfcs/lfcs.txt file.

Is the "/home/bob/lfcs/lfcs.txt" file deleted?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

#### rm /home/bob/lfcs/lfcs.txt

### Explanation

- rm → remove file
- /home/bob/lfcs/lfcs.txt → file to delete

</details>

---

## 🧪 Task

Task: Move all contents, excluding the directory itself, from /home/bob/lfcs to /home/bob/new-data/ directory.

Are the contents of the "/home/bob/lfcs" directory moved to the "/home/bob/new-data/" directory?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

#### mv /home/bob/lfcs/* /home/bob/new-data/

### Explanation

- mv → move files/directories
- * → all contents inside /home/bob/lfcs
- the lfcs directory itself is not moved, only its contents

</details>

---

## 🧪 Task

Task: Delete directory /home/bob/lfcs .

Is the "/home/bob/lfcs" directory deleted?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### rm -rf /home/bob/lfcs

### Explanation

- rm → remove
- -r → recursive, remove directory and contents
- -f → force, no prompt

</details>

---

## 🧪 Task

Task: Create a soft link to /tmp directory. Create this link in /home/bob directory and call it link_to_tmp.

Is the "link_to_tmp" softlink created?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### ln -s /tmp /home/bob/link_to_tmp

### Explanation

- ln → create link
- -s → symbolic (soft) link
- /tmp → target
- /home/bob/link_to_tmp → new link name

</details>

---

## 🧪 Task

Task: Create a hard link to /opt/hlink file. Create this link in /home/bob/ directory and call it hlink.

Has the required hard link been created?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

#### ln  /opt/hlink /home/bob/hlink

### Explanation

- ln → create hard link
- /opt/hlink → original file
- /home/bob/hlink → new hard link

</details>

---

## 🧪 Task

Task: There is a file called /home/bob/new_file; rename this to /home/bob/old_file.

Is "/home/bob/new_file" renamed to "/home/bob/old_file"?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### mv /home/bob/new_file /home/bob/old_file

### Explanation

- mv → move or rename
- same directory with different name → acts as rename

</details>

---

## 🧪 Task

Task: Create a directory named 9 under the /tmp/1/2/3/4/5/6/7/8 directory. Please note that the structure of sub-directories from 1 to 8 does not exist. However, mkdir has a command line option to automatically create all of these sub-directories automatically in one shot, instead of 9 consecutive commands. This option is described in the help output or manual pages as make parent directories as needed. Find out what the correct option is and use it to create the directory in one shot.

Is the "/tmp/1/2/3/4/5/6/7/8/9" directory created?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### mkdir -p /tmp/1/2/3/4/5/6/7/8/9

### Explanation

- mkdir → make directory
- -p → create parent directories as needed

</details>

---

## 🧪 Task

Task: ls -l shows you the time when a file has been last modified, but it only shows you the hour and the minute, usually in a form like 17:53. Find another way to make ls display the full/exact last modified time for the files in /home/bob directory.

At what exact time was important_file created/modified?

<details>
<summary>Answer</summary>

## Solution:

Run the below command:

#### ls --full-time

### Explanation

- ls → list files
- --full-time → show full timestamp details

</details>
