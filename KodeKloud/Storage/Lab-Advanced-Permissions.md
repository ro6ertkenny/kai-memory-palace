# Lab - Advanced Permissions

## Task:

Which one of these is also called a mirrored array?

<details><summary>Answer</summary>
Disks grouped in level 1 RAID is also called a mirrored array.

### Explanation:
- RAID 1 → mirrors data across disks
- mirrored array → identical data written to multiple disks

</details>

---

## Task:

What command can you use to view a summary status of your RAID arrays?

<details><summary>Answer</summary>
The /proc/mdstat file contains the summary status of the RAID arrays, so you can use the cat /proc/mdstat command to view a summary status of your RAID arrays.

### Explanation:
- /proc/mdstat → virtual file showing RAID status
- cat → display file contents
- shows RAID devices, sync status, and health

> `proc` = **process**

> `mdstat` =

    md   + stat

## `md`

means:

**multiple devices**

👉 Linux software RAID term

## `stat`

means:

**status**

## So:

    mdstat

means:

> multiple devices status

## 🧠 Mental Model

    md    = RAID devices

    stat  = their status

# 🔥 Why “multiple devices”?

Because RAID combines:

- multiple disks  
- into one RAID device

## 🧪 Example

    cat /proc/mdstat

might show:

- RAID members  
- syncing  
- degraded arrays

## 🔁 1-Line Recall

    mdstat = status of Linux software RAID devices

</details>

---

## Task:

In your /home/bob directory, you will find a file named archive. List the ACL permissions associated with this file.

What permissions are listed for john in this ACL?

<details><summary>Answer</summary>
You can use the command getfacl archive to get ACL permissions of the file.

### file: archive
### owner: bob
### group: bob
user::rw-
user:john:r--
group::r--
mask::r--
other::r--

As you can see in the output, John has read only permissions.

### Explanation:
- getfacl → display ACLs
- user:john:r-- → john has read-only access
- ACL → extended permissions beyond standard rwx

> get file ACL

</details>

---

## Task:

Create a level 1 RAID array, at /dev/md0, with two devices: /dev/vdd and /dev/vde.

mdadm is already installed in your system which is used for creating, managing, and monitoring RAID devices using the md driver.

Has the required RAID array been created?

<details><summary>Answer</summary>
Execute the below command:

#### mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/vdd /dev/vde

Enter y and press Enter if asked for the confirmation.

Note: You need to use sudo with the command in case of a non-root user.

### Explanation:
- mdadm → manage RAID devices
- --create → create RAID array
- /dev/md0 → RAID device name
- --level=1 → RAID 1 (mirroring)
- --raid-devices=2 → number of disks
- /dev/vdd /dev/vde → source disks

</details>

---

## Task:

In your /home/bob directory, you will find a file named specialfile. Add an ACL permission to this file so that the user called john can read and write to it.

Has the required acl been set for user john?

<details><summary>Answer</summary>
Execute the below command:

#### setfacl --modify user:john:rw specialfile

Note: You need to use sudo with the command in case of a non-root user.

### Explanation:
- setfacl → modify ACLs
- --modify → add/update ACL entry
- user:john:rw → give john read and write
- specialfile → target file

</details>

---

## Task:

From the file called specialfile, remove the ACL permissions for the user called john.

Have the required acl permissions been removed for user john?

<details><summary>Answer</summary>
Execute the below command:

#### setfacl --remove user:john specialfile

Note: You need to use sudo with the command in case of a non-root user.

### Explanation:
- setfacl → manage ACLs
- --remove → delete ACL entry
- user:john → target ACL entry
- specialfile → file being modified

</details>

---

## Task:

To the file called specialfile, add an ACL permission for the group called mail. The mail group should get permissions to read and execute this file.

Has the required acl been set for group mail?

<details><summary>Answer</summary>
Execute the below command:

#### setfacl --modify group:mail:rx specialfile

Note: You need to use sudo with the command in case of a non-root user.

### Explanation:
- setfacl → modify ACLs
- group:mail:rx → read and execute for group
- specialfile → target file

</details>

---

## Task:

In your /home/bob directory, you will find a directory called collection. Use the setfacl command recursively, so that ACL entries are modified on the directory itself but also all the files and subdirectories it may contain. The ACL permissions should allow the user called john to read, write and execute all entries within this directory.

- Have the required acl permissions been set on "collection" directory?

- Were ACL set recursively?

<details><summary>Answer</summary>
Execute the below command:

#### setfacl --recursive --modify user:john:rwx collection/

Note: You need to use sudo with the command in case of a non-root user.

### Explanation:
- setfacl → modify ACLs
- --recursive → apply to directory and contents
- user:john:rwx → full permissions for john
- collection/ → target directory

## Why The Trailing `/` In:

    collection/

## 🧠 Short Answer

> The trailing slash:

    /

is just indicating:

> this is a directory

## 🔥 It is basically a visual cue.

These are effectively the same here:

    collection

and

    collection/

✅ both work

## 🧠 Why People Add It

To make it obvious:

- not a file  
- not ambiguous  
- this is a directory target

## 🔍 Especially Helpful With Recursive Commands

Since:

    --recursive

acts on directories and contents,

writing:

    collection/

reinforces:

> recurse through this directory tree

## 🧪 Like These

    cd /etc/

    cp -r dir1/ dir2/

Same idea.

## ⚠️ Important

The trailing slash is NOT the thing making recursion happen.

THIS does that:

    --recursive

not:

    /

## 🧠 Mental Model

    / at end = “this is a folder”

## 🔁 Memory Hook

    trailing / = directory hint

## 🔁 1-Line Recall

    `collection/` uses a trailing slash just to indicate the target is a directory; `--recursive` is what does the recursive work.


</details>



















 
