# Filesystem Features and Mount Options — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: We have /dev/vda1 mounted in /.
What are the mount options used with /dev/vda1?

Example: rw or ro, logbufs, logbsize, etc.
Identify all those options for /dev/vda1 and save them in the /root/moptions file.

Verify the mount options.

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

    findmnt /dev/vda1

Copy the output under OPTIONS and save that in the /root/moptions file:

    vi /root/moptions

Its content should be something like:

    rw,relatime,discard,errors=remount-ro

</details>

---

## 🧪 Task 2

Task: Unmount /dev/vdd1 from the /mnt/directory.

Is "/mnt" unmounted?

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

    umount /mnt

If the user is not root, you need to use the command with sudo.

</details>

---

## 🧪 Task 3

Task: Mount /dev/vdd1 back into the /mnt/ directory. But this time, use these mount options: ro,noexec,nosuid.

Verify the "/mnt" mount

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

    mount -o ro,noexec,nosuid /dev/vdd1 /mnt

If the user is not root, you need to use the command with sudo.

</details>

---

## 🧪 Task 4

Task: /dev/vdd1 is currently mounted with the rooption, so it's read-only. Remount it with the rw option so it becomes read-write.

Verify the "/mnt" mount

<details>
<summary>Answer</summary>

## Solution:

Execute the below command:

    mount -o remount,rw /dev/vdd1 /mnt

If the user is not root, you need to use the command with sudo.

</details>

---

## 🧪 Task 5

Task: Edit /etc/fstab so that the ext4 filesystem on /dev/vdd1 is automatically mounted into /mnt at boot time.
But also make sure that this filesystem is mounted as read-only. Otherwise said, use these two mount options: defaults and ro.

Verify the required changes.

<details>
<summary>Answer</summary>

## Solution:

Edit /etc/fstab file:

    vi /etc/fstab

Add below given line in it:

    /dev/vdd1 /mnt ext4 defaults,ro 0 2

</details>
