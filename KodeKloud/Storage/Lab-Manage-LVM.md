# Lab - Manage LVM

## Task:

Install lvm on this system.

Is lvm installed?

<details><summary>Answer</summary>
Execute the below command:

#### apt install lvm2 -y

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- apt install → install package
- lvm2 → Logical Volume Manager tools
- -y → auto confirm installation

> `lvm2` means:

**Logical Volume Manager version 2**

> **LVM (Logical Volume Manager) lets you take one or more physical disks and treat them like flexible storage you can combine, split, resize, and manage more easily than fixed partitions.**

> Think:

    disks → pooled storage → logical volumes

like turning several hard drives into adjustable storage you can grow later.

## How To Find a Package When You Only Know the Concept

    Use:

    apt search <keyword>

    apt search logical volume

## See Available Package Versions (APT)

> Use:

    apt list -a <package>

## 🔥 For Your Task (lvm)

    apt list -a lvm2

</details>

---

## Task:

Add these two disks as Physical Volumes (PVs) to LVM: /dev/vdd and /dev/vde.

Have the required disks been added to the LVM?

<details><summary>Answer</summary>
Execute the below command:

#### pvcreate /dev/vdd /dev/vde 

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- pvcreate → initialize disks as physical volumes
- /dev/vdd /dev/vde → target devices
- PV → base layer of LVM

</details>

---

## Task:

Use the correct command to display a list of Physical Volumes (PVs) used by LVM. What is the PSize of /dev/vde? Save the value in the /root/pvsize file.

Note that, if the value is 10.00g, then the file content should be 10.

Verify the "PSize" of "/dev/vde"

<details><summary>Answer</summary>
Execute the below command:

#### pvs

Note: Use sudo with the command in case of a non-root user.

Look for the PSize of /dev/vde and save its value in the /root/pvsize file:

#### vi /root/pvsize

### Explanation:
- pvs → list physical volumes
- PSize → size of physical volume
- vi → manually save value

> ✅ `pvs` = **Physical Volumes (show)**

</details>

---

## Task:

Remove the /dev/vde physical volume from LVM.

Has the "/dev/vde" physical volume been removed from the LVM?

<details><summary>Answer</summary>
Execute the below command:

#### pvremove /dev/vde

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- pvremove → remove physical volume from LVM
- /dev/vde → target device

</details>

---

## Task:

Create a Volume Group (VG) named volume1. It should be created on Physical Volume: /dev/vdd.

Has the Volume Group (VG) named "volume1" been created?

<details><summary>Answer</summary>
Execute the below command:

#### vgcreate volume1 /dev/vdd 

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- vgcreate → create volume group
- volume1 → VG name
- /dev/vdd → physical volume used

</details>

---

## Task:

Imagine that our volume group volume1 is running out of free space. It currently uses /dev/vdd to store data. Add /dev/vde to this volume group so that we gain more usable storage space.

Has "/dev/vde" been added to the "volume1" volume group?

<details><summary>Answer</summary>
Execute the below command:

#### vgextend volume1 /dev/vde

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- vgextend → add PV to VG
- volume1 → target volume group
- /dev/vde → additional storage device

</details>

---

## Task:

Remove /dev/vde from the volume group volume1.

Has "/dev/vde" been removed from the "volume1" volume group?

<details><summary>Answer</summary>
Execute the below command:

#### vgreduce volume1 /dev/vde

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- vgreduce → remove PV from VG
- volume1 → target volume group
- /dev/vde → device being removed

</details>

---

## Task:

Use the command that displays all of the volume groups. What is the VSize of volume1?

Save the respective value in the /root/volume1 file.

Note that, if the value is 10.00m, then the file content should be 10.00m.

Verify the "VSize" of "volume1"

<details><summary>Answer</summary>
Execute the below command:

#### vgs

Note: Use sudo with the command in case of a non-root user.

Look for the VSize of volume1 and save its value in the /root/volume1 file:

#### vi /root/volume1

### Explanation:
- vgs → display volume groups
- VSize → total size of VG
- vi → manually save value

> ✅ `vgs` = **Volume Groups (show)**

</details>

---

## Task:

Create a Logical Volume (LV). It should have these properties:

1. The size of the LV should be 0.5 Gigabytes.

2. Its name should be smalldata.

3. The logical volume should be created on the volume group named volume1.

Has "smalldata" LV been created?

<details><summary>Answer</summary>
Execute the below command:

#### lvcreate --size 0.5G --name smalldata volume1

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- lvcreate → create logical volume
- --size 0.5G → set size
- --name smalldata → LV name
- volume1 → volume group

> “Create a logical volume inside an EXISTING volume group”

</details>

---

## Task:

Resize the Logical Volume called smalldata to 752 MB.
This logical volume resides on the volume group called volume1.

Has "smalldata" LV size been changed?

<details><summary>Answer</summary>
Execute the below command:

#### lvresize --size 752M volume1/smalldata

Enter y if asked for the confirmation.

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- lvresize → change LV size
- --size 752M → new size
- volume1/smalldata → target LV

</details>

---

## Task:

Create an XFS filesystem on the logical volume called smalldata.
This logical volume exists on the volume group called volume1.

Has the XFS filesystem on the logical volume called "smalldata" been created?

<details><summary>Answer</summary>
Execute the below command:

#### mkfs.xfs /dev/volume1/smalldata

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- mkfs.xfs → create XFS filesystem
- /dev/volume1/smalldata → logical volume path

## How Do You Know It Goes In `/dev`?

> Because:

    smalldata

is a **logical volume** (a block device)

and block devices live under:

    /dev

# 🔥 Key Rule

If the thing is a:

- disk  
- partition  
- logical volume  
- swap device

👉 think:

    /dev/...

## 🧠 Mental Model

    /dev = where Linux exposes devices

# 🔍 The Task Told You

It said:

> logical volume called:

    smalldata

inside volume group:

    volume1

## In LVM, that maps to:

    /dev/volume1/smalldata

Pattern:

    /dev/<VG>/<LV>

## 🧪 General LVM Pattern

Volume Group:
    volume1

Logical Volume:
    smalldata

Path:
    /dev/volume1/smalldata

## ⚠️ Why Not Just:

    mkfs.xfs smalldata

❌ because `mkfs` needs a device target.

It formats a block device.

## 🧠 How I “Know”

Because:

    mkfs.* commands target devices

not arbitrary names.

## 🔁 Memory Hook

    If it’s storage you format →

    look in /dev

## 🧪 Same Pattern Elsewhere

Partition:

    mkfs.ext4 /dev/vdb1

Swap:

    mkswap /dev/vdb3

Logical volume:

    mkfs.xfs /dev/volume1/smalldata

Same idea.

## 🔁 1-Line Recall

    Logical volumes are block devices, and block devices live under `/dev`.

</details>

---

## Task:

Destroy/Remove the Logical Volume called smalldata.

Has the "smalldata" LV been removed?

<details><summary>Answer</summary>
Execute the below command:

#### sudo lvremove volume1/smalldata

Enter y if asked for the confirmation.

Note: Use sudo with the command in case of a non-root user.

### Explanation:
- lvremove → delete logical volume
- volume1/smalldata → target LV
- sudo → required for destructive operation

</details>
