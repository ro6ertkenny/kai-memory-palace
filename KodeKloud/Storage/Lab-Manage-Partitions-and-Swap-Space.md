# Manage Partitions & Swap Space — LFCS Lab (Hidden Answers)

---

## 🧠 Mental Model

- lsblk → visualize block devices (tree view)
- fdisk / cfdisk → partition editing tools
- mkswap → format partition as swap
- swapon / swapoff → enable/disable swap
- swap = disk used as RAM overflow

---

## 🧪 Task 1

Task: How do we display block devices such as disks or partitions?

<details>
<summary>Answer</summary>

### Command
    lsblk

### Explanation
- lsblk → list block devices
- shows disks, partitions, mountpoints

</details>

---

## 🧪 Task 2

Task: How do we format a partition as swap space?

<details>
<summary>Answer</summary>

### Command
    sudo mkswap /dev/vdb3

### Explanation
- mkswap → format partition as swap
- /dev/vdb3 → target partition

</details>

---

## 🧪 Task 3

Task: Identify partition where / is mounted and save its name (no path) to /root/part.

<details>
<summary>Answer</summary>

### Command
    lsblk | awk '$7=="/" {print $1}' > /root/part

### Explanation
- lsblk → list block devices
- $7=="/" → match mountpoint "/"
- $1 → partition name
- `>` → save output

</details>

---

## 🧪 Task 4

Task: Find swapfile used and save its path to /root/swap.

<details>
<summary>Answer</summary>

### Command
    swapon --show | awk 'NR>1 {print $1}' > /root/swap

### Explanation
- swapon --show → list active swap
- $1 → device/file path
- `>` → save output

</details>

---

## 🧪 Task 5

Task: Create three primary partitions on /dev/vdd (10M, 21M, 15M).

<details>
<summary>Answer</summary>

### Command
    sudo fdisk /dev/vdd

### Steps
- n → new partition
- p → primary
- +10M → first partition
- repeat for:
    +21M
    +15M
- w → write changes

### Verify
    lsblk

### Explanation
- fdisk → interactive partition tool
- sizes defined with +M

</details>

---

## 🧪 Task 6

Task: Format 21MB partition as swap and enable it.

<details>
<summary>Answer</summary>

### Command
    sudo mkswap /dev/vdd2
    sudo swapon /dev/vdd2

### Explanation
- mkswap → prepare swap
- swapon → activate swap

</details>

---

## 🧪 Task 7

Task: Stop using the 21MB partition as swap.

<details>
<summary>Answer</summary>

### Command
    sudo swapoff /dev/vdd2

### Explanation
- swapoff → disable swap usage

</details>

---

## 🧪 Task 8

Task: Resize /dev/vdd3 partition to 21MB.

<details>
<summary>Answer</summary>

### Command
    sudo cfdisk /dev/vdd

### Steps
- select /dev/vdd3
- choose Resize
- set size → 21M
- Write → confirm
- Quit

### Verify
    lsblk

### Explanation
- cfdisk → interactive partition editor
- resize adjusts partition size
- must write changes to disk

</details>
