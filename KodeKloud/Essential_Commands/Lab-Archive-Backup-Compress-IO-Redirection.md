# Archive, Back Up, Compress, IO & Redirection — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Create a tar archive logs.tar (under bob's home) of the /var/log/ directory.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    sudo tar -cvf logs.tar /var/log

### Explanation
- tar → archive tool
- -c → create archive
- -v → verbose output
- -f logs.tar → archive filename
- /var/log → source directory to archive

</details>

---

## 🧪 Task 2

Task: Create a compressed tar archive logs.tar.gz (under bob's home) of the /var/log/ directory.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    sudo tar -czf logs.tar.gz /var/log/

### Explanation
- -c → create archive
- -z → gzip compression
- -f logs.tar.gz → archive filename
- /var/log/ → source directory
- The extra `-P` is not required for this task.

</details>

---

## 🧪 Task 3

Task: List the content of the /home/bob/logs.tar archive and save the output in the /home/bob/tar_data.txt file.

<details>
<summary>Answer</summary>

### Command
    tar -tf /home/bob/logs.tar > /home/bob/tar_data.txt

### Explanation
- -t → list archive contents
- -f /home/bob/logs.tar → archive to read
- `>` → redirect output to file
- The extra `-P` is not required for listing.

</details>

---

## 🧪 Task 4

Task: Extract the contents of /home/bob/archive.tar.gz to the /tmp directory.

<details>
<summary>Answer</summary>

### Command
    tar -xf /home/bob/archive.tar.gz -C /tmp

### Explanation
- -x → extract
- -f /home/bob/archive.tar.gz → archive to extract
- -C /tmp → change to /tmp before extracting
- Many `tar` versions auto-detect compression here, so `-z` is often not required.

</details>

---

## 🧪 Task 5

Task: Execute the /home/bob/script.sh script and save all normal output (except errors/warnings) in the /home/bob/output_stdout.txt file.

<details>
<summary>Answer</summary>

### Command
    /home/bob/script.sh > /home/bob/output_stdout.txt

### Explanation
- /home/bob/script.sh → run the script by full path
- `>` → redirect standard output only
- standard error is not redirected, so errors/warnings still go to the terminal

</details>

---

## 🧪 Task 6

Task: Execute the /home/bob/script.sh script and save all command output (both errors/warnings and normal output) in the /home/bob/output.txt file.

<details>
<summary>Answer</summary>

### Command
    /home/bob/script.sh > /home/bob/output.txt 2>&1

### Explanation
- `>` → redirect standard output to file
- `2>&1` → redirect standard error to wherever standard output is going
- result → both stdout and stderr go into the same file

</details>

---

## 🧪 Task 7

Task: Execute the /home/bob/script.sh script and save all errors only in the /home/bob/output_errors.txt file.

<details>
<summary>Answer</summary>

### Command
    /home/bob/script.sh 2> /home/bob/output_errors.txt

### Explanation
- `2>` → redirect standard error only
- standard output still goes to the terminal
- output_errors.txt will contain only errors/warnings

</details>

---

## 🧪 Task 8

Task: Create a bzip archive under bob's home named file.txt.bz2 out of /home/bob/file.txt, but preserve the original file.

<details>
<summary>Answer</summary>

### Command
    bzip2 --keep /home/bob/file.txt

### Explanation
- bzip2 → compress file with bzip2
- --keep → keep original file
- result → /home/bob/file.txt remains and /home/bob/file.txt.bz2 is created

</details>

---

## 🧪 Task 9

Task: Extract the contents of /home/bob/archive.tar.gz to the /opt directory.

<details>
<summary>Answer</summary>

### Command
    sudo tar -xf /home/bob/archive.tar.gz -C /opt

### Explanation
- -x → extract
- -f → archive file
- -C /opt → extract into /opt

</details>

---

## 🧪 Task 10

Task: Use the cat command, and redirection, to add (append) the contents of /home/bob/file.txt to /home/bob/destination.txt.

<details>
<summary>Answer</summary>

### Command
    cat /home/bob/file.txt >> /home/bob/destination.txt

### Explanation
- cat → print file contents
- `>>` → append output to file
- destination.txt keeps existing content and gets the new content added at the end

</details>

---

## 🧪 Task 11

Task: Create a file.tar archive of the /home/bob/file directory under the /home/bob location.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    tar --create --file file.tar file

### Explanation
- --create → create archive
- --file file.tar → archive name
- file → source directory inside /home/bob
- running from /home/bob makes the archive path and source clean

</details>

---

## 🧪 Task 12

Task: Create the gzip archive of the games.txt file, which is present under the /home/bob directory.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    gzip games.txt

### Explanation
- gzip → compress file with gzip
- creates games.txt.gz
- original games.txt is removed by default

</details>

---

## 🧪 Task 13

Task: We have a /home/bob/lfcs.txt.xz file; uncompress it under /home/bob/.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    unxz lfcs.txt.xz

### Explanation
- unxz → decompress xz file
- creates lfcs.txt
- removes lfcs.txt.xz by default

</details>

---

## 🧪 Task 14

Task: Sort the contents of the /home/bob/values.conf file alphabetically and eliminate any common values. Save the sorted output in the /home/bob/values.sort file.

<details>
<summary>Answer</summary>

### Command
    sort -u /home/bob/values.conf > /home/bob/values.sort

### Explanation
- sort → sort lines alphabetically
- -u → unique only, remove duplicate lines
- `>` → save result to file
- `-d` is not required for this task.

</details>

---

## 🧪 Task 15

Task: Sort again the contents of the /home/bob/values.conf file alphabetically. Eliminate any common values and ignore case.

Finally, save the sorted output in the /home/bob/values.sorted file.

<details>
<summary>Answer</summary>

### Command
    sort -uf /home/bob/values.conf > /home/bob/values.sorted

### Explanation
- sort → sort lines
- -u → unique only
- -f → ignore case by folding lowercase to uppercase for comparisons
- `>` → save result to file
- `-d` is not required for this task.

</details>
