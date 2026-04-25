# Lab - Verify Integrity and Availability of Resources and Key Processes

## Task:

Identify what % space of / partition is in use on our system. Save the value in the /home/bob/used file.

For example, if the used space is 10%, then the file content should be 10%.

Verify the /home/bob/used file.

<details><summary>Answer</summary>
Execute the below command and copy the used space value:

#### df /

Save the value in the /home/bob/used file:

#### vi /home/bob/used

### Explanation:
- df → display filesystem disk space usage
- / → root filesystem
- output → shows total, used, available, and percentage used
- vi → manually save the percentage value
- /home/bob/used → destination file

</details>

---

## Task:

Figure out how much storage space the /bin/ directory is using and save the value in the /home/bob/bin file.

Verify the /home/bob/bin file.

<details><summary>Answer</summary>
Execute the below command and copy the required value:

#### du -sh /bin/

Save the value in the /home/bob/bin file:

#### vi /home/bob/bin

### Explanation:
- du → estimate disk usage
- -s → summarize total size
- -h → human-readable format
- /bin/ → target directory
- vi → manually save the value
- /home/bob/bin → destination file

</details>

---

## Task:

Use the correct command to check out the memory on this system (in megabytes). In /home/bob/memory file, save the total amount of RAM that this system has.

For example, if you see 512 in the command's output, the file contents should be 512

Verify the /home/bob/memory file.

<details><summary>Answer</summary>
Execute the below command and copy the required value:

#### free --mega

Save the value in the /home/bob/memory file:

#### vi /home/bob/memory

### Explanation:
- free → display memory usage
- --mega → show values in megabytes
- output → includes total, used, free memory
- vi → manually save total RAM value
- /home/bob/memory → destination file

</details>

---

## Task:

Use the correct command to check out how long this system has been up. In the /home/bob/up file, save the time value in hours, minutes, or days (whichever is applicable).

For example, if you see 1:07 in the command's output, the file content should be 1.
Similarly, if you see something like 51 min in the command's output, the file content should be 51min (without any space).

Verify the /home/bob/up file.

<details><summary>Answer</summary>
Execute the below command and copy the required value:

#### uptime

Save the value in the /home/bob/up file:

#### vi /home/bob/up

### Explanation:
- uptime → show system runtime duration
- output → includes how long system has been running
- vi → manually save parsed uptime value
- /home/bob/up → destination file

</details>

---

## Task:

Use the correct command to identify the CPU core(s) per socket on this system. Save its value in the /home/bob/cpu file.

Verify the /home/bob/cpu file.

<details><summary>Answer</summary>
Execute the below command and copy the required value:

#### lscpu

Save the value in the /home/bob/cpu file:

#### vi /home/bob/cpu

### Explanation:
- lscpu → display CPU architecture information
- output → includes cores per socket, CPU count, threads
- vi → manually save the required value
- /home/bob/cpu → destination file

My Terminal Output:    Core(s) per socket:      6

You can also type:

#### lscpu | awk -F: '/Core\(s\) per socket/ {print $2}'

⚙️ SIMP breakdown (lock this in)
    
    awk → text processor
    -F: → split line by :
    /pattern/ → find the correct line
    {print $2} → print value after :
        pattern { action }
    xargs → trim whitespace

👉 { } = the action block
👉 /pattern/ = the filter
👉 $N = the field selector


👉 `awk` = **pull out exactly what you want from messy output**

## 🧠 THE PROBLEM

Command:

    lscpu

👉 gives you a LOT of info:

    Architecture:        x86_64
    CPU(s):              12
    Core(s) per socket:  6
    Thread(s) per core:  2
    ...

👉 LFCS task wants ONLY:

    6

## 🔥 WHY NOT JUST USE `lscpu`?

👉 Because:
- too much output
- not clean
- harder to automate

## ✅ WHY USE `awk`

👉 It lets you:

1. **Find the line you want**
2. **Extract only the value**

## 🧪 COMMAND

    lscpu | awk -F: '/Core(s) per socket/ {print $2}'

## 🔍 SIMP BREAKDOWN

### `lscpu`
👉 get all CPU info

### `|`
👉 send output to awk

### `awk`
👉 process text

### `-F:`
👉 split each line at `:`
👉 `-F` = **Field Separator**

### `/Core(s) per socket/`
👉 find the correct line

### `{print $2}`
👉 print what comes AFTER `:`

## 🧠 WHAT HAPPENS

Input line:

    Core(s) per socket:  6

After split (`:`):

    $1 = Core(s) per socket
    $2 =  6

👉 Output:

    6

## 🧠 SIMP MEMORY

👉 Think:

> 🗣️ “awk finds the line and grabs the value”

## ⚠️ LFCS GOTCHA

👉 Output may have spaces:

    " 6"

👉 Clean it with:

    ... | xargs

## 🧪 FINAL CLEAN COMMAND

    lscpu | awk -F: '/Core(s) per socket/ {print $2}' | xargs > /home/bob/cpu


## 🧠 FINAL LOCK-IN

👉 `awk` = filter + extract  
👉 `-F:` = split at colon  
👉 `$2` = value after colon  

👉 Use awk when:
    you need ONE clean value from messy output

</details>

---

## Task:

On /dev/vdd, we have an XFS filesystem. Use the correct command to check this filesystem for errors and save the output in /home/bob/fscheck file.

Has the required file system been checked for errors?

<details><summary>Answer</summary>
Execute the below command:

#### sudo xfs_repair -n /dev/vdd > /home/bob/fscheck 2>&1

### Explanation:
- xfs_repair → check and repair XFS filesystem
- -n → no-modify mode (check only, no changes)
- /dev/vdd → target device
- sudo → run with elevated privileges
- '>' → redirect standard output to file
- 2>&1 → redirect standard error to same file
- /home/bob/fscheck → destination file

🔥 Mental model (lock this in)

    Filesystem	Check command	Safe check flag
    ext4    	fsck	            -n
    XFS     	xfs_repair	        -n

🧠 What the lab is testing

They want you to understand:

    Correct tool → xfs_repair
    Safe mode → -n
    Output capture → > file 2>&1

⚙️ About this part (also important)

    > /home/bob/fscheck 2>&1

👉 This ensures:

    stdout → file
    stderr → same file

Because filesystem tools often print errors to stderr, not stdout.

This line:

    Filesystem Check command Safe check flag ext4 fsck -n XFS xfs_repair -n

👉 looks messy… but it’s just a **mapping table**


## 🧠 CLEAN VERSION (UNDERSTAND THIS)

| Filesystem | Command       | Safe Check Flag |
|-----------|--------------|-----------------|
| ext4      | fsck         | -n              |
| XFS       | xfs_repair   | -n              |


## 🎯 CORE IDEA

👉 Different filesystems use **different tools**


## 🧠 SIMP MEMORY

👉 Think:

    ext4 → fsck  
    XFS  → xfs_repair  

## 🔑 WHAT DOES `-n` MEAN?

👉 `-n` = **NO CHANGES (read-only check)**

👉 Say:

> 🗣️ “check only, don’t fix”

## 🧪 EXAMPLES

### ext4 check (safe)
    fsck -n /dev/sda1

### XFS check (safe)
    xfs_repair -n /dev/sda1

## ⚠️ LFCS GOTCHA

👉 NEVER run repair tools without `-n` unless asked

👉 Without `-n`:
- it will MODIFY the filesystem
- risky in exams

## 🔥 WHAT THE LAB IS TESTING

You must know:

1️⃣ Correct tool for filesystem  
2️⃣ Use safe mode (`-n`)  
3️⃣ Capture output  


## ⚙️ OUTPUT CAPTURE (IMPORTANT)

    > /home/bob/fscheck 2>&1

## 🔍 SIMP BREAKDOWN

### `>`
👉 send normal output (stdout) to file

### `2>&1`
👉 send errors (stderr) to SAME place

👉 Read it like:

> 🗣️ “send 2 (errors) to wherever 1 (normal output) is going”

## 🔍 BREAKDOWN

### `>`
👉 redirect stdout (1) to a file

### `2>&1`
👉 redirect stderr (2) → to same place as stdout (1)

> 🗣️ “& = reference a descriptor, not a file”

👉 `&` = “this is a descriptor”  
👉 `2>&1` = send errors → same place as output  

👉 Think:

    “don’t treat 1 like a file — it’s a stream”

## 🧠 WHY THIS MATTERS

👉 Filesystem tools print:
- info → stdout
- errors → stderr

👉 If you don’t use `2>&1`:
❌ you miss half the output

## 🧠 SIMP MEMORY

👉 Think:

> 🗣️ “send EVERYTHING to the file”

## 🧪 FULL EXAMPLE

    xfs_repair -n /dev/sda1 > /home/bob/fscheck 2>&1

👉 Result:
- full report saved
- no changes made

## 🧠 FINAL LOCK-IN

👉 ext4 → fsck  
👉 XFS → xfs_repair  
👉 -n → safe (no changes)  
👉 > file 2>&1 → capture everything  

</details>
