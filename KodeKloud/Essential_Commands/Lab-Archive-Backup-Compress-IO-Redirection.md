# Lab - Archive, Back Up, Compress, IO, Redirection

## Task:
Create a tar archive logs.tar (under bob's home) of the/var/log/ directory

<details><summary>Answer</summary>
sudo tar -cvf logs.tar /var/log

-c: Create a new archive.
-v: Verbose — show files being added (nice for confirmation).
-f: Specify the filename of the archive.

So, tar -cvf logs.tar /var/log means: "Create (-c) a verbose (-v) archive with filename (-f) logs.tar of the /var/log directory."

### Explanation:
- tar → archive tool
- sudo → run with elevated privileges
- -c → create a new archive
- -v → verbose output, show files being processed
- -f → specify the archive filename
- logs.tar → name of the tar archive being created
- /var/log → source directory being archived

</details>

---

## Task:
Create a compressed tar archive logs.tar.gz (under bob's home) of the /var/log/ directory

<details><summary>Answer</summary>
sudo tar czfP logs.tar.gz /var/log/

In the context of the tar command, the capital P flag stands for "absolute path". When used, it tells tar to preserve the full absolute path of files and directories during archiving, rather than making them relative or stripping the leading slash.

This is useful if you want to extract the archive exactly where the files originally resided, maintaining the full directory structure.

### Explanation:
- tar → archive tool
- sudo → run with elevated privileges
- -c → create a new archive
- -z → compress with gzip
- -f → specify the archive filename
- -P → preserve absolute paths
- logs.tar.gz → compressed archive filename
- /var/log/ → source directory being archived

</details>

---

## Task:
List the content of the /home/bob/logs.tar archive and save the output in the /home/bob/tar_data.txt file.

<details><summary>Answer</summary>
tar tfP /home/bob/logs.tar > /home/bob/tar_data.txt

### Explanation:
- tar → archive tool
- -t → list archive contents
- -f → specify the archive file to read
- -P → preserve absolute path names when listing
- /home/bob/logs.tar → archive being inspected
- '>' → redirect standard output into a file
- /home/bob/tar_data.txt → file receiving the listing output

---

## 🧠 Core Question
> Is `tar` being used like `grep` just to view contents?  
> Is it the ONLY way to view a `.tar` file?

---

## 🔥 Short Answer

> `tar` is NOT like `grep` — it is the **native tool for working with archives**

And:

> NO — it’s not the only way, but it is the **correct and expected way (LFCS)**

---

# 🧠 What `tar` Actually Does

`tar` = **Tape Archive**

👉 Used to:
- create archives
- extract archives
- list contents

---

## ⚙️ Command Breakdown

    tar tfP /home/bob/logs.tar

| Part | Meaning |
|------|--------|
| `t`  | list contents (table of contents) |
| `f`  | file (specify archive file) |
| `P`  | preserve full paths |

---

## 🧠 Mental Model

    tar = archive manager

NOT:
- text search tool (`grep`)
- file viewer (`cat`)

---

# 🔍 What This Command Does

    tar tfP logs.tar

👉 “Show me what’s INSIDE the archive”

WITHOUT extracting it

---

# 🧪 Example Output

    /var/log/syslog
    /var/log/auth.log
    /var/log/messages

---

# 🔥 Why NOT Use `cat` or `less`?

You *can* do:

    cat logs.tar

👉 but you’ll see:
❌ binary garbage  
❌ unreadable output  

---

## 🧠 Why?

Because `.tar` is:
> a structured archive format — not plain text

---

# 🔥 Are There Other Tools?

Yes, but `tar` is the **standard**

---

# ⚡ Exam Pattern

If you see:
- “list contents of tar file” → use:

    tar -t

---

## Common Variations

    tar -tf file.tar       → list  
    tar -xvf file.tar      → extract  
    tar -cvf file.tar      → create  

---

# 🔁 1-Line Recall

    tar -t = “tell me what’s inside”

---

# 🧨 Operator Insight

Think:

    tar = box of files

- `-t` → peek inside  
- `-x` → unpack  
- `-c` → create  

---

# Final Takeaway

    tar tfP file.tar

👉 lists archive contents WITHOUT extracting

</details>

---

## Task:
Extract the contents of /home/bob/archive.tar.gz to the /tmp directory

<details><summary>Answer</summary>
tar --extract --file /home/bob/archive.tar.gz --directory /tmp/
or
tar xf /home/bob/archive.tar.gz -C /tmp
---
The uppercase -C flag in tar doesn't mean "copy." Instead, it stands for "change to directory" before performing the operation. Think of it as telling tar to switch to a specific directory and then do its thing there—like a quick change of location before acting.

For example:

tar -czf archive.tar.gz -C /path/to/directory .

This creates an archive of the contents in /path/to/directory without including the full path

### Explanation:
- tar → archive tool
- --extract or -x → extract files from the archive
- --file or -f → specify the archive to extract
- /home/bob/archive.tar.gz → archive being extracted
- --directory or -C → change into the target directory before extracting
- /tmp/ or /tmp → extraction destination

</details>

---

## Task:
Execute the /home/bob/script.sh script and save all normal output (except errors/warnings) in the /home/bob/output_stdout.txt file

<details><summary>Answer</summary>
sudo ./script.sh > /home/bob/output_stdout.txt
---
The ./ before script.sh indicates that the script is located in the current directory. It's a way to tell the shell, "Run this script from the current directory," especially when the current directory isn't in the system's PATH.

In your case, ./script.sh means you're executing the script.sh file in the directory you're currently in, rather than searching for it in the directories listed in PATH.

### Explanation:
- sudo → run with elevated privileges
- ./script.sh → execute the script from the current directory
-'>' → redirect standard output only
- /home/bob/output_stdout.txt → file receiving normal output
- errors and warnings are not redirected here, so they still go to standard error

## 🧠 Core Question
> Does `>` redirect everything (including errors), or just normal output?

---

## 🔥 Short Answer

> `>` redirects ONLY **standard output (stdout)**

👉 It does NOT capture:
- errors
- warnings (if sent to stderr)

---

## 🧠 The 3 Standard Streams

| Stream | Number | Description |
|--------|--------|-------------|
| stdin  | 0      | input       |
| stdout | 1      | normal output |
| stderr | 2      | errors      |

---

## 🔍 What `>` Actually Does

    command > file

👉 is the same as:

    command 1> file

---

## 🧪 Example

    ls /valid_dir > out.txt

👉 stdout → goes into `out.txt`

---

## ❌ Errors Still Go to Screen

    ls /invalid_dir > out.txt

👉 result:
- error prints to terminal
- `out.txt` is empty

---

## 🔥 How to Redirect Errors

## Redirect stderr ONLY

    command 2> errors.txt

---

## Redirect BOTH stdout + stderr

    command > all.txt 2>&1

---

## 🧠 What `2>&1` Means

- `2` → stderr  
- `1` → stdout  

👉 “send errors to wherever stdout is going”

---

## ⚡ Cleaner Modern Syntax

    command &> all.txt

👉 redirects:
- stdout ✅
- stderr ✅

---

## 🧠 Mental Model

| Symbol | Meaning |
|--------|--------|
| `>`    | stdout only |
| `2>`   | stderr only |
| `&>`   | both |

---

## ⚠️ LFCS Trap

If you only use:
    >

👉 errors will STILL appear on screen

---

## 🔁 1-Line Recall

    `>` = stdout only, NOT errors

---

## 🧨 Operator Insight

Always ask:

> “Do I care about errors?”

- yes → redirect both  
- no  → `>` is fine  

---

## Final Takeaway

    > redirects ONLY standard output

Errors require:
    2> or &>

</details>

---

## Task:
Execute the /home/bob/script.sh script and save all command output (both errors/warnings and normal output) in the /home/bob/output.txt file

<details><summary>Answer</summary>
sudo ./script.sh > /home/bob/output.txt 2>&1

### Explanation:
- sudo → run with elevated privileges
- ./script.sh → execute the script from the current directory
- > /home/bob/output.txt → redirect standard output to the file
- 2>&1 → redirect standard error to the same place as standard output
- result → both normal output and errors go into one file

---

## 🧠 Core Question
> What exactly does `2>&1` mean?

---

## 🔥 Short Answer

> `2>&1` means:
> “send STDERR (2) to wherever STDOUT (1) is going”

---

# 🧠 Step-by-Step Breakdown

## Step 1
    > /home/bob/output.txt

👉 redirects:
- stdout (1) → `/home/bob/output.txt`

---

## Step 2
    2>&1

👉 redirects:
- stderr (2) → same place as stdout (1)

---

# 🧠 Mental Model

| Stream | Meaning |
|--------|--------|
| 1      | stdout (normal output) |
| 2      | stderr (errors) |

---

## 🔥 What `>&` Means

    2>&1

👉 “redirect 2 TO 1”

NOT:
- not “into a file”
- not “append”

👉 it means:
> “follow wherever 1 is going”

---

# 🧪 Final Result

    ./script.sh > output.txt 2>&1

👉 BOTH go to:
    /home/bob/output.txt

- stdout ✅  
- stderr ✅  

---

# ⚠️ ORDER MATTERS (VERY IMPORTANT)

## Correct:
    command > file 2>&1

👉 both go to file ✅

---

## WRONG:
    command 2>&1 > file

👉 what happens:
- stderr → goes to terminal ❌
- stdout → goes to file

---

## 🧠 Why?

Because:
- redirections are processed LEFT → RIGHT

---

# 🔍 Visual Flow

### Correct order:
    stdout → file  
    stderr → follows stdout → file  

---

### Wrong order:
    stderr → follows stdout (still terminal)  
    stdout → file  

---

# 🔁 1-Line Recall

    2>&1 = “send errors where output is going”

---

# ⚡ Modern Alternative

    command &> file

👉 same result:
- stdout + stderr → file

---

# 🧨 Operator Insight

Think of it like:

    stdout = destination  
    stderr = follower  

👉 `2>&1` = “stderr follows stdout”

---

# Final Takeaway

    > file     → send output to file  
    2>&1       → send errors to SAME place  

👉 Together:
> everything goes into one file

</details>

---

## Task:
Execute the /home/bob/script.sh script and save all errors only in the /home/bob/output_errors.txt file

<details><summary>Answer</summary>
sudo ./script.sh 2> /home/bob/output_errors.txt

### Explanation:
- sudo → run with elevated privileges
- ./script.sh → execute the script from the current directory
- 2> → redirect standard error only
- /home/bob/output_errors.txt → file receiving only errors and warnings
- standard output still goes to the terminal

</details>

---

## Task:
Create a bzip archive under bob's home named file.txt.bz2 out of /home/bob/file.txt, but preserve the original file. At the end of the exercise, you should have both.

Does the original file exist?
Is bzip2 created?

bzip2 is created?

<details><summary>Answer</summary>
bzip2 --keep /home/bob/file.txt

### Explanation:
- bzip2 → compress a file using bzip2
- --keep → keep the original file after compression
- /home/bob/file.txt → source file being compressed
- result → original file remains and a .bz2 file is created

</details>

---

## Task:
Extract the contents of /home/bob/archive.tar.gz to the /opt directory

<details><summary>Answer</summary>
sudo tar --extract --file /home/bob/archive.tar.gz --directory /opt/
or
sudo tar xf /home/bob/archive.tar.gz -C /opt

### Explanation:
- sudo → run with elevated privileges
- tar → archive tool
- --extract or -x → extract files
- --file or -f → specify the archive file
- /home/bob/archive.tar.gz → archive being extracted
- --directory or -C → change into the destination directory first
- /opt/ or /opt → extraction destination

</details>

---

## Task:
Use the cat command, and redirection, to add (append) the contents of /home/bob/file.txt to /home/bob/destination.txt.

<details><summary>Answer</summary>
cat /home/bob/file.txt >> /home/bob/destination.txt

### Explanation:
- cat → print file contents to standard output
- /home/bob/file.txt → source file being read
- '>>' → append redirected output to the destination file
- /home/bob/destination.txt → file receiving the appended content
- append means existing content stays and new content is added at the end

---

## 🧠 Core Question
> Does the extra `>` in `>>` mean append?

---

## 🔥 Short Answer

> YES — `>>` means:
> “append output to the file (do NOT overwrite)”

---

# 🧠 Difference Between `>` and `>>`

| Operator | Behavior |
|----------|----------|
| `>`      | overwrite file |
| `>>`     | append to file |

---

# 🔍 What This Command Does

    cat /home/bob/file.txt >> /home/bob/destination.txt

👉 takes contents of:
    file.txt

👉 and ADDS it to the end of:
    destination.txt

---

## 🧪 Example

### destination.txt BEFORE:
    line1
    line2

### Run command

### destination.txt AFTER:
    line1
    line2
    (contents of file.txt appended here)

---

# ⚠️ Important Behavior

## If file exists:
- `>>` → appends  
- `>` → deletes old content and replaces  

---

## If file does NOT exist:
👉 BOTH:
    > and >>

👉 will CREATE the file

---

# 🧠 Mental Model

    >  = replace  
    >> = stack on top  

---

# 🔁 1-Line Recall

    `>>` = append, don’t destroy

---

# ⚡ Exam Pattern

If you see:
- “add to file” → `>>`
- “write fresh output” → `>`

---

# 🧨 Operator Insight

Use `>>` when:
- logging
- accumulating results
- preserving previous data

Use `>` when:
- you want a clean file
- previous content doesn’t matter

---

# Final Takeaway

    >> = append to existing file (safe, non-destructive)

</details>

---

## Task:
Create a file.tar archive of the /home/bob/file directory under the /home/bob location.

Is the archive created?

Check contents.

<details><summary>Answer</summary>

    tar -cvf /home/bob/file.tar -C /home/bob file

## Explanation

tar → archive tool used to create, extract, and list archives  

-c → create a new archive  

-v → verbose (shows files being added to the archive)  

-f /home/bob/file.tar → specify the output archive file and its full path  

-C /home/bob → change to this directory BEFORE performing the archive operation  

file → the directory (inside /home/bob) to include in the archive  

---

## 🧠 What Actually Happens

1. tar switches to:
       /home/bob

2. then archives:
       file/

3. and writes the result to:
       /home/bob/file.tar

---

## 🧠 Mental Model

    tar -cvf OUTPUT -C BASE_DIR TARGET

- OUTPUT → where the archive goes  
- BASE_DIR → where tar “pretends” it is  
- TARGET → what to archive  

---

## 🔁 1-Line Recall

    -C = “change directory before doing anything”

---

## Final Result

    file.tar is created in /home/bob  
    containing the contents of the file directory (with clean relative paths)

</details>

---

## Task:
Create the gzip archive of the games.txt file , which is present under the /home/bob directory.

Is the gzip of "games.txt" file created?

<details><summary>Answer</summary>

#### cd /home/bob

#### gzip games.txt

### Explanation:
- cd /home/bob → move into the directory containing the file
- gzip → compress the file with gzip
- games.txt → source file being compressed
- result → games.txt.gz is created
- by default, gzip removes the original uncompressed file

</details>

---

## Task:
We have a /home/bob/lfcs.txt.xz file; uncompress it under /home/bob/.
 
Is the file uncompressed?

<details><summary>Answer</summary>

#### cd /home/bob

#### unxz lfcs.txt.xz

### Explanation:
- cd /home/bob → move into the target directory
- unxz → decompress an .xz file
- lfcs.txt.xz → compressed file being unpacked
- result → lfcs.txt is restored
- by default, the compressed .xz file is removed after decompression

</details>

---

## Task:
Sort the contents of the /home/bob/values.conf file alphabetically and eliminate any common values. Save the sorted output in the /home/bob/values.sort file.

Verify the sorted output.

<details><summary>Answer</summary>
sort -du /home/bob/values.conf > /home/bob/values.sort

### Explanation:
- sort → sort lines from the file
- -d → dictionary-order sort
- -u → output only unique lines, removing duplicates
- /home/bob/values.conf → input file being sorted
- '>' → redirect output into a file
- /home/bob/values.sort → file receiving the sorted unique output

</details>

---

## Task:
Sort again the contents of the /home/bob/values.conf file alphabetically. Eliminate any common values and ignore case

Finally, save the sorted output in the/home/bob/values.sorted file

Verify the sorted output

<details><summary>Answer</summary>
sort -duf /home/bob/values.conf > /home/bob/values.sorted

### Explanation:
- sort → sort lines from the file
- -d → dictionary-order sort
- -u → output only unique lines, removing duplicates
- -f → fold lowercase to uppercase for case-insensitive comparison
- /home/bob/values.conf → input file being sorted
- '>' → redirect output into a file
- /home/bob/values.sorted → file receiving the sorted unique case-insensitive output

</details>
