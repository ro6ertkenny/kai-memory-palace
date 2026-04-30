# Lab - Remote File Systems: NFS | **NFS = Network File System**

## Task:

From the listed options, select the path for default NFS configuration file

<details><summary>Answer</summary>

/etc/exports is the default NFS configuration file.

#### Explanation:
/etc/exports → main NFS server configuration file
defines which directories are shared and with whom

## Why Is It Called `/etc/exports`?

> It is a **file** ✅  
NOT a directory.

It is called:

    exports

because it lists:

> what directories the NFS server **exports** (shares out)

## 🧠 What “Export” Means Here

In NFS:

> export = make a directory available to other machines

Inside:

    /etc/exports

you might have:

    /srv/share 10.0.0.0/24(rw,sync)

## That means:

Export (share):

    /srv/share

to:

    10.0.0.0/24

## 🧠 Mental Model

    export = share outward

## 🔥 Why “exports”?

Because this file is literally:

> a list of exported directories

## 🧪 Like This

    /etc/fstab

lists:
- filesystems to mount

    /etc/exports

lists:
- directories to export

## 🔁 Memory Hook

    exports = things this server shares out

## ⚠️ File or Directory?

This:

    /etc/exports

is one file.

You can verify:

    ls -l /etc/exports

or:

    file /etc/exports

## 🔁 1-Line Recall

    /etc/exports = file listing NFS shares (exports)

</details>

## Task:

An NFS server is already running and active in the system. Configure the existing NFS server to share the /home directory in read-only mode. Allow access to any client within the CIDR range 10.0.0.0/24.

Note: Make sure you reexport the configuration file using exportfs -r.

Is "/home" shared in read-only mode for clients in the "10.0.0.0/24" CIDR range?

<details><summary>Answer</summary>
    
    - Open the NFS server configuration file: vi /etc/exports
    - Add the following line: /home 10.0.0.0/24(ro)
    - Save the file and exit the text editor.
    - Once you edit /etc/exports file, export it using exportfs -r.
    - Restart the NFS server:

#### sudo exportfs -r

#### systemctl restart nfs-server

Now, the "/home" directory is shared in read-only mode for clients in the specified CIDR range.

Note: You need to use sudo with the commands if the user is not root.

### Explanation:
- /etc/exports → define NFS shares
- (ro) → read-only access (no space and this is here as one NFS exports field "client (options)")
- exportfs -r → reload export configuration
- systemctl restart nfs-server → apply changes

## 🧠 CIDR =
**Classless Inter-Domain Routing**

## What you need to remember:

    /24

is CIDR notation.

## It means:

> how big the network is  
> (subnet size)

> **CIDR lets you define how big a network is and route traffic between networks using the `/number` after an IP address.**

## 🔁 Memory Hook

    CIDR = defines network size and helps route traffic

</details>

---

## Task:

Inspect the configuration file for the newly established NFS share on the /home directory. Identify the IP address specified for which access to /home is configured.

<details><summary>Answer</summary>
To identify the IP address configured for the /home NFS share, inspect the NFS server configuration file. Use the following command to view the relevant information.

####  grep "/home" /etc/exports

/home 10.0.0.0/24(ro)
/home 127.0.0.1(ro)

As you can see, 127.0.0.1 is the IP for which /home is shared.

### Explanation:
- grep → search file for pattern
- "/home" → filter relevant entries
- /etc/exports → NFS config file
- shows allowed IPs and permissions

## Yes — This Is Asking For A SINGLE IP — the task specifically says:

> “Identify the IP address specified…”

Singular:

    IP address

not:

    IP addresses

## 🔥 That’s Why They Want

    127.0.0.1

as the answer.

## ⚠️ Why Not `10.0.0.0/24`?

Because:

    10.0.0.0/24

is not a single IP.

It is:

> a subnet (network range)

## It represents MANY addresses:

    10.0.0.1
    10.0.0.2
    ...
    10.0.0.254

## 🔍 So The Lab Is Distinguishing

- subnet/range ❌  
- single IP ✅

## 🧠 Mental Model

    10.0.0.0/24 = network

    127.0.0.1 = host IP

</details>

---

## Task:

For this step, manually mount the NFS share with the following properties:

- The IP of the NFS server is 127.0.0.1.
- The remote directory you should mount from 127.0.0.1 is /home.
- Mount this share in the local directory /mnt.

Is 127.0.0.1:/home mounted on /mnt ?

<details><summary>Answer</summary>
Execute the following command to manually mount the NFS share:

#### mount 127.0.0.1:/home /mnt

Note: You need to use sudo with the command if the user is not root.

### Explanation:
- mount → attach filesystem
- 127.0.0.1:/home → NFS server and share
- /mnt → local mount point

</details>

---

## Task:

Which file from the below options needs to be modified in order to automatically mount an NFS share at system startup?

<details><summary>Answer</summary>
To automatically mount an NFS share at system startup, you need to modify the /etc/fstab file on the client machine.

### Explanation:
- /etc/fstab → defines mounts at boot
- used for local and remote (NFS) mounts

## 🧠 Mental Model

    /mnt = parking spot

## 🧠 Mental Model

    mounts = what is currently parked

## 🧠 Mental Model

    /etc/fstab = parking instructions

> config file that tells Linux what to mount automatically at boot

</details>

---

## Task:

In the previous step, we have manually mounted NFS share. For this step, configure the system to automatically mount an NFS share when it boots up:

- The share is on the server with the IP address 127.0.0.1.
- The remote directory you should mount from the NFS server is /home
- Mount it in the local directory /mnt
- Use defaults in the mount options

Is entry added to /fstab file to automatically share /home from 127.0.0.1?

<details><summary>Answer</summary>
To automatically mount the NFS share at system startup, add an entry to the "/etc/fstab" file. Edit the file with a text editor su
ch as nano or vim:

#### vi /etc/fstab

Note: You need to use sudo with the command if the user is not root.

Add the following line to the end of the file:

#### 127.0.0.1:/home /mnt nfs defaults 0 0

Save the file and exit the text editor.

### Explanation:
- 127.0.0.1:/home → NFS server and share
- /mnt → local mount point
- nfs → filesystem type
- defaults → standard mount options
- /etc/fstab → persistent mount configuration

## What Are The `0 0` In `/etc/fstab`?

## 🧠 Short Answer

Those are the LAST TWO `fstab` fields:

    dump   fsck

## First `0`

    dump

### What it means:

> do not use old `dump` backup checking

Usually:

    0 = skip

## It was used to back up filesystems.

## In `/etc/fstab`

This field:

    0

(the FIRST zero)

controls whether the old:

    dump

utility considers this filesystem.

## 🔥 Second `0`

    fsck

### What it means:

> do not check this filesystem at boot

Usually:

    0 = skip fsck

## 🧠 So:

    0 0

means:

- skip dump  
- skip fsck

## 🔍 Why For NFS?

Because:

> NFS is a remote network filesystem

It is NOT a local ext4 disk needing normal boot-time fsck.

## 🧠 Mental Model

    first 0 = no dump

    second 0 = no fsck

## 🔁 Memory Hook

    0 0 = skip both

## 🧪 Compare Local Root Filesystem

Often:

    /dev/vda1 / ext4 defaults 0 1

That last:

    1

means:
check at boot.

## ⚡ For NFS

Usually:

    0 0

is normal.

---

## 🔁 1-Line Recall

    In fstab, `0 0` means skip dump and skip fsck.

</details>

---

## Task:

Can a single entry in "/etc/exports" be used to share the same file directory with two different IPs by specifying them?

<details><summary>Answer</summary>
Yes, you can add a single entry in "/etc/exports" to share the same file directory with two different IPs by specifying them in the entry separated by a space

### Explanation:
- /etc/exports → supports multiple clients per entry
- space-separated IPs → multiple access rules in one line

## Example of One `/etc/exports` Line With Two IPs

## Syntax

    directory   client1(options) client2(options)

## Example

    /home 10.0.0.5(ro) 10.0.0.6(ro)

## 🧠 Meaning

Export:

    /home

to BOTH:

    10.0.0.5

and

    10.0.0.6

with:

    read-only

## 🔥 Notice

The two clients are separated by:

    space

NOT comma.

</details>

---

## Task:

An NFS server is already running on this system. Configure the following share in a single entry.

- Share the /home directory with any client with an IP address in the CIDR range: 192.0.0.0/24. Make this share read-only.

- Share the same /home directory, but this time, with any client with the exact IP address 127.0.0.10. Make this share read-write. Besides the read-write option, also enable the no_root_squash option.

Note: Make sure you reexport the configuration file using exportfs -r.

- Is /etc/exports modified with the specified configuration?

- Is exportfs -v showing the updated nfs shares?

<details><summary>Answer</summary>
To achieve the specified NFS share configurations, add the following entry to the "/etc/exports" file on the NFS server:

#### /home 192.0.0.0/24(ro) 127.0.0.10(rw,no_root_squash)

- This configuration shares the "/home" directory read-only with clients in the CIDR range 192.0.0.0/24 and read-write with the specific IP address 127.0.0.1, enabling the no_root_squash option for the latter.
- Run the following command to export the changes.

#### exportfs -r

Note: You need to use sudo with the command if the user is not root.

### Explanation:
- /etc/exports → define NFS shares
- 192.0.0.0/24(ro) → read-only network access
- 127.0.0.10(rw,no_root_squash) → full access with root privileges preserved
- exportfs -r → reload NFS exports

## 🧠 Mental Model

    /etc/exports = instructions  
    exportfs -r  = apply instructions  

## 🧪 Example

You add:

    /home 10.0.0.0/24(ro)

Then run:

    exportfs -r

👉 now NFS starts sharing `/home` with that network

## 🔁 Memory Hook

    -r = re-read config

## 🔁 1-Line Recall

    `exportfs -r` reloads `/etc/exports` and applies the current NFS share configuration.

</details>




