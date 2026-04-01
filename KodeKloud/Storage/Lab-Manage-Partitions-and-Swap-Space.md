# Manage Partitions and Swap Space — LFCS Lab (Hidden Answers)

---

## 🧪 Task

Task: How do we display block devices such as disks or partitions?

<details>
<summary>Answer</summary>

## Solution:

Using lsblk command, we can display block devices.

### Explanation

- lsblk → lists block devices
- shows disks, partitions, mount points

</details>

---

## 🧪 Task

Task: How do we format a partition as swap space?

<details>
<summary>Answer</summary>

## Solution:

We can format a partition as swap space using the sudo mkswap /dev/vdb3 command where /dev/vdb3 is the partition we want to format.

### Explanation

- mkswap → prepares partition for swap usage

</details>

---

## 🧪 Task

Task: Identify the name of the virtual disk where / is mounted on this system.

Save the value (only the name without path) in the /root/part file.

Does the "/root/part" file have the required data?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command to list the partitions on this system:

    lsblk

For MOUNTPOINT /, look for the partition.

    vi /root/part

### Explanation

- lsblk → shows mountpoints
- / → root filesystem
- save only partition name (e.g., vda1)

</details>

---

## 🧪 Task

Task: Find out the swapfile used on this system and save its exact path in the /root/swap file.

<details>
<summary>Answer</summary>

## Solution:

Execute the below command to identify the swapfile:

    swapon --show

    vi /root/swap

### Explanation

- swapon --show → lists active swap devices/files

</details>

---

## 🧪 Task

Task: Create three primary partitions on /dev/vdd.

<details>
<summary>Answer</summary>

## Solution:

    fdisk /dev/vdd

Create partitions with:

    +10M
    +21M
    +15M

Verify:

    lsblk

### Explanation

- fdisk → interactive partition tool
- +SIZE → defines partition size

</details>

---

## 🧪 Task

Task: Format the 21MB partition as swap and activate it.

<details>
<summary>Answer</summary>

## Solution:

    mkswap /dev/vdd2
    swapon /dev/vdd2

### Explanation

- mkswap → prepares swap
- swapon → enables swap

</details>

---

## 🧪 Task

Task: Stop using the 21MB partition as swap.

<details>
<summary>Answer</summary>

## Solution:

    swapoff /dev/vdd2

### Explanation

- swapoff → disables swap usage

</details>

---

## 🧪 Task

Task: Resize the /dev/vdd3 partition to 21MB.

<details>
<summary>Answer</summary>

## Solution:

    cfdisk /dev/vdd

Resize partition → Write → Quit

### Explanation

- cfdisk → interactive partition editor
- resize modifies partition size

</details>
