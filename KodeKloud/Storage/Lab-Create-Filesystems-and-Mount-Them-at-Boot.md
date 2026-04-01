# Create Filesystems and Mount Them at Boot — LFCS Lab (Hidden Answers)

---

## 🧪 Task

Task: What file do we need to edit to tell the Linux OS which filesystems it should automatically mount when it boots up?

<details>
<summary>Answer</summary>

## Solution:

We will need to edit /etc/fstab file.

### Explanation

- /etc/fstab → defines mounts at boot

</details>

---

## 🧪 Task

Task: What is wrong with mkfs.xfs command?

<details>
<summary>Answer</summary>

## Solution:

The lowercase -l option is wrong. It should be -L.

### Explanation

- -L → sets filesystem label
- -l → incorrect flag

</details>

---

## 🧪 Task

Task: Create XFS filesystem labeled DataDisk.

<details>
<summary>Answer</summary>

## Solution:

    mkfs.xfs -L "DataDisk" /dev/vdd

### Explanation

- mkfs.xfs → create XFS filesystem
- -L → assign label

</details>

---

## 🧪 Task

Task: Create ext4 filesystem with 2048 inodes.

<details>
<summary>Answer</summary>

## Solution:

    mkfs.ext4 -N 2048 /dev/vde

### Explanation

- -N → sets inode count

</details>

---

## 🧪 Task

Task: Mount /dev/vdd to /mnt.

<details>
<summary>Answer</summary>

## Solution:

    mount /dev/vdd /mnt

### Explanation

- mount → attaches filesystem

</details>

---

## 🧪 Task

Task: Unmount filesystem.

<details>
<summary>Answer</summary>

## Solution:

    umount /mnt

### Explanation

- umount → detaches filesystem

</details>

---

## 🧪 Task

Task: Configure /dev/vde mount at boot.

<details>
<summary>Answer</summary>

## Solution:

    mkdir /test
    vi /etc/fstab

    /dev/vde /test ext4 defaults 0 2

### Explanation

- defaults → standard mount options
- 2 → fsck order

</details>

---

## 🧪 Task

Task: Configure swap at boot.

<details>
<summary>Answer</summary>

## Solution:

    vi /etc/fstab

    /dev/vdd none swap defaults 0 0

### Explanation

- swap entries use "none" as mount point

</details>

---

## 🧪 Task

Task: Change label to SwapFS.

<details>
<summary>Answer</summary>

## Solution:

    xfs_admin -L "SwapFS" /dev/vdd

### Explanation

- xfs_admin → modifies XFS metadata

</details>
