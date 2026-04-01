# Lab - Manage LVM

## Task:

Install lvm on this system.

Is lvm installed?

<details><summary>Answer</summary>
Execute the below command:

#### apt install lvm2 -y

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- apt install → install package
- lvm2 → Logical Volume Manager tools
- -y → auto confirm installation

---

## Task:

Add these two disks as Physical Volumes (PVs) to LVM: /dev/vdd and /dev/vde.

Have the required disks been added to the LVM?

<details><summary>Answer</summary>
Execute the below command:

#### pvcreate /dev/vdd /dev/vde 

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- pvcreate → initialize disks as physical volumes
- /dev/vdd /dev/vde → target devices
- PV → base layer of LVM

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
</details>

### Explanation:
- pvs → list physical volumes
- PSize → size of physical volume
- vi → manually save value

---

## Task:

Remove the /dev/vde physical volume from LVM.

Has the "/dev/vde" physical volume been removed from the LVM?

<details><summary>Answer</summary>
Execute the below command:

#### pvremove /dev/vde

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- pvremove → remove physical volume from LVM
- /dev/vde → target device

---

## Task:

Create a Volume Group (VG) named volume1. It should be created on Physical Volume: /dev/vdd.

Has the Volume Group (VG) named "volume1" been created?

<details><summary>Answer</summary>
Execute the below command:

#### vgcreate volume1 /dev/vdd 

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- vgcreate → create volume group
- volume1 → VG name
- /dev/vdd → physical volume used

---

## Task:

Imagine that our volume group volume1 is running out of free space. It currently uses /dev/vdd to store data. Add /dev/vde to this volume group so that we gain more usable storage space.

Has "/dev/vde" been added to the "volume1" volume group?

<details><summary>Answer</summary>
Execute the below command:

#### vgextend volume1 /dev/vde

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- vgextend → add PV to VG
- volume1 → target volume group
- /dev/vde → additional storage device

---

## Task:

Remove /dev/vde from the volume group volume1.

Has "/dev/vde" been removed from the "volume1" volume group?

<details><summary>Answer</summary>
Execute the below command:

#### vgreduce volume1 /dev/vde

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- vgreduce → remove PV from VG
- volume1 → target volume group
- /dev/vde → device being removed

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
</details>

### Explanation:
- vgs → display volume groups
- VSize → total size of VG
- vi → manually save value

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
</details>

### Explanation:
- lvcreate → create logical volume
- --size 0.5G → set size
- --name smalldata → LV name
- volume1 → volume group

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
</details>

### Explanation:
- lvresize → change LV size
- --size 752M → new size
- volume1/smalldata → target LV

---

## Task:

Create an XFS filesystem on the logical volume called smalldata.
This logical volume exists on the volume group called volume1.

Has the XFS filesystem on the logical volume called "smalldata" been created?

<details><summary>Answer</summary>
Execute the below command:

#### mkfs.xfs /dev/volume1/smalldata

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- mkfs.xfs → create XFS filesystem
- /dev/volume1/smalldata → logical volume path

---

## Task:

Destroy/Remove the Logical Volume called smalldata.

Has the "smalldata" LV been removed?

<details><summary>Answer</summary>
Execute the below command:

#### sudo lvremove volume1/smalldata

Enter y if asked for the confirmation.

Note: Use sudo with the command in case of a non-root user.
</details>

### Explanation:
- lvremove → delete logical volume
- volume1/smalldata → target LV
- sudo → required for destructive operation
