# Create Filesystems & Mount at Boot — LFCS Lab (Hidden Answers)

---

## 🧠 Mental Model

- /etc/fstab → persistent mounts (boot-time)
- mount → temporary mount (runtime)
- umount → detach filesystem
- mkfs.* → create filesystem
- labels/UUIDs → preferred over raw device names in production

---

## 🧪 Task 1

Task: Which file controls automatic mounting at boot?

<details>
<summary>Answer</summary>

### Command
    /etc/fstab

### Explanation
- fstab → filesystem table
- defines mounts at boot

</details>

---

## 🧪 Task 2

Task: What is wrong with this command?

    sudo mkfs.xfs -l "BackupVolume" /dev/vdd1

<details>
<summary>Answer</summary>

### Explanation
- correct answer:
  lowercase `-l` is wrong
- should be:
    -L (uppercase) for label

</details>

---

## 🧪 Task 3

Task: Create XFS filesystem with label "DataDisk" on /dev/vdd.

<details>
<summary>Answer</summary>

### Command
    sudo mkfs.xfs -L DataDisk /dev/vdd

### Explanation
- mkfs.xfs → create XFS filesystem
- -L → set label

</details>

---

## 🧪 Task 4

Task: Create ext4 filesystem with 2048 inodes on /dev/vde.

<details>
<summary>Answer</summary>

### Command
    sudo mkfs.ext4 -N 2048 /dev/vde

### Explanation
- mkfs.ext4 → create ext4 filesystem
- -N → number of inodes

</details>

---

## 🧪 Task 5

Task: Mount /dev/vdd to /mnt.

<details>
<summary>Answer</summary>

### Command
    sudo mount /dev/vdd /mnt

### Explanation
- mount → attach filesystem
- temporary (lost on reboot unless in fstab)

</details>

---

## 🧪 Task 6

Task: Unmount filesystem from /mnt.

<details>
<summary>Answer</summary>

### Command
    sudo umount /mnt

### Explanation
- umount → detach filesystem

</details>

---

## 🧪 Task 7

Task: Configure /dev/vde to mount at /test on boot (ext4), and ensure fsck runs.

<details>
<summary>Answer</summary>

### Command
    sudo mkdir /test

    sudo vi /etc/fstab

    /dev/vde /test ext4 defaults 0 2

    sudo mount -a

### Explanation
- mkdir → create mount point
- fstab entry:
    device mountpoint fstype options dump fsck
- 0 → no dump
- 2 → fsck order (non-root filesystems)
- mount -a → validate config without reboot

</details>

---

## 🧪 Task 8

Task: Configure /dev/vdd as swap at boot.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/fstab

    /dev/vdd none swap defaults 0 0

    sudo swapon -a

### Explanation
- swap entry format:
    device none swap defaults 0 0
- swapon -a → activate all swap entries

</details>

---

## 🧪 Task 9

Task: Change label of /dev/vdd filesystem to SwapFS.

<details>
<summary>Answer</summary>

### Command
    sudo xfs_admin -L SwapFS /dev/vdd

### Explanation
- xfs_admin → modify XFS filesystem metadata
- -L → set label

</details>
