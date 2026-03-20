# Lab - Remote File Systems: NFS

## Task:

From the listed options, select the path for default NFS configuration file

## Solution:

/etc/exports is the default NFS configuration file.


## Task:

An NFS server is already running and active in the system. Configure the existing NFS server to share the /home directory in read-only mode. Allow access to any client within the CIDR range 10.0.0.0/24.

Note: Make sure you reexport the configuration file using exportfs -r.

Is "/home" shared in read-only mode for clients in the "10.0.0.0/24" CIDR range?

## Solution:

- Open the NFS server configuration file: vi /etc/exports
- Add the following line: /home 10.0.0.0/24(ro)
- Save the file and exit the text editor.
- Once you edit /etc/exports file, export it using exportfs -r.
- Restart the NFS server:

#### systemctl restart nfs-server

Now, the "/home" directory is shared in read-only mode for clients in the specified CIDR range.

Note: You need to use sudo with the commands if the user is not root.


## Task:

Inspect the configuration file for the newly established NFS share on the /homedirectory. Identify the IP address specified for which access to /home is configured.

## Solution:

To identify the IP address configured for the /home NFS share, inspect the NFS server configuration file. Use the following command to view the relevant information.

grep "/home" /etc/exports
----
/home 10.0.0.0/24(ro)
/home 127.0.0.1(ro)

As you can see, 127.0.0.1 is the IP for which /home is shared.


## Task:

For this step, manually mount the NFS share with the following properties:

- The IP of the NFS server is 127.0.0.1.
- The remote directory you should mount from 127.0.0.1 is /home.
- Mount this share in the local directory /mnt.

Is 127.0.0.1:/home mounted on /mnt ?

## Solution:

Execute the following command to manually mount the NFS share:

#### mount 127.0.0.1:/home /mnt

Note: You need to use sudo with the command if the user is not root.


## Task:

Which file from the below options needs to be modified in order to automatically mount an NFS share at system startup?

## Solution:

To automatically mount an NFS share at system startup, you need to modify the /etc/fstab file on the client machine.


## Task:

In the previous step, we have manually mounted NFS share. For this step, configure the system to automatically mount an NFS share when it boots up:

- The share is on the server with the IP address 127.0.0.1.
- The remote directory you should mount from the NFS server is /home
- Mount it in the local directory /mnt
- Use defaults in the mount options

Is entry added to /fstab file to automatically share /home from 127.0.0.1?

## Solution:

To automatically mount the NFS share at system startup, add an entry to the "/etc/fstab" file. Edit the file with a text editor su
ch as nano or vim:

#### vi /etc/fstab

Note: You need to use sudo with the command if the user is not root.

Add the following line to the end of the file:

#### 127.0.0.1:/home /mnt nfs defaults 0 0

Save the file and exit the text editor.


## Task:

Can a single entry in "/etc/exports" be used to share the same file directory with two different IPs by specifying them?

## Solution:

Yes, you can add a single entry in "/etc/exports" to share the same file directory with two different IPs by specifying them in the entry separated by a space


## Task:

An NFS server is already running on this system. Configure the following share in a single entry.

- Share the /home directory with any client with an IP address in the CIDR range: 192.0.0.0/24. Make this share read-only.

- Share the same /home directory, but this time, with any client with the exact IP address 127.0.0.10. Make this share read-write. Besides the read-write option, also enable the no_root_squash option.

Note: Make sure you reexport the configuration file using exportfs -r.

- Is /etc/exports modified with the specified configuration?

- Is exportfs -v showing the updated nfs shares?

## Solution:

To achieve the specified NFS share configurations, add the following entry to the "/etc/exports" file on the NFS server:

#### /home 192.0.0.0/24(ro) 127.0.0.10(rw,no_root_squash)

- This configuration shares the "/home" directory read-only with clients in the CIDR range 192.0.0.0/24 and read-write with the specific IP address 127.0.0.1, enabling the no_root_squash option for the latter.
- Run the following command to export the changes.

#### exportfs -r

Note: You need to use sudo with the command if the user is not root.







