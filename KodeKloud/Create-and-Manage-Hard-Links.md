# Create and Manage Hard Links

## File System Basics

Imagine a Linux system used by two distinct users, Aaron and Jane. Each user logs in with their own credentials, which provide personalized desktops, settings, and file directories.

Suppose Aaron takes a picture of the family dog and saves it as:

#### /home/aaron/pictures/family_dog.jpg

To simulate the file creation, we use the following command, which writes a description (acting as the file’s content) into the file:

#### echo "Picture of Milo the dog" > Pictures/family_dog.jpg

When you inspect the file with the stat command, it shows details that include the inode number:

#### stat Pictures/family_dog.jpg

    File:
    Size:
    Device:     Inode:52946177      Links:2 

 Inode remembers where things are stored and keeps track of meta data

 File points to Inode and Inode points to all of the blocks of data that we require

 Links: is how many hard links to Inodes there are

In Linux, every file is represented by an inode—a data structure that stores metadata (like permissions, modification times, and data block locations). While the inode number is the technical reference, we use the file name (in this case, family_dog.jpg) to map to that inode. Notice the output indicates “Links: 1”, meaning there is a single hard link (the original file name) associated with the inode.

#### ln path_to_target_file path_to_link_file

#the target is the file you want to link with | the link file is the name of the new hard link we create   

Example: 

ln /home/aaron/Pictures/family_dog.jpg /home/jane/Pictures/family_dog.jpg

Stores picture only once

## Creating and Using Hard Links

Hard links allow you to reference the same data from different locations without duplicating file content. This is especially useful if you want to share data without unnecessarily consuming additional disk space.

Consider Jane, who has her own pictures directory at /home/jane/pictures. Instead of copying family_dog.jpg from Aaron’s directory, which duplicates the file data, you can create a hard link. This avoids the overhead of duplicating thousands of high-resolution images.

While the typical copy command might be:

#### $ cp -r /home/aaron/Pictures/ /home/jane/Pictures/

you can create a hard link using the following syntax:

#### $ ln /home/aaron/Pictures/family_dog.jpg /home/jane/Pictures/family_dog.jpg

After creating the hard link, both file paths reference the same inode. Running the stat command now will show the file has two hard links:

#### $ stat Pictures/family_dog.jpg
File: Pictures/family_dog.jpg
Size: 49         Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d Inode: 52946177  Links: 2
Access: (0640/-rw-r-----)  Uid: ( 1000/ aaron)   Gid: ( 1005/ family)
Access: 2021-10-27 16:33:18.949749912 -0500
Modify: 2021-10-27 14:41:19.20278881 -0500
Change: 2021-10-27 16:33:18.851749919 -0500
Birth: 2021-10-26 13:37:17.980969655 -0500

If one user deletes their reference (hard link) to the file, the data remains accessible through the other link. The file data is only removed when the last hard link is deleted.

## Deleting Hard Links

For example, if Aaron removes his file:

#### $ rm /home/aaron/Pictures/family_dog.jpg

Jane still has access via her hard link. However, if Jane then deletes the file as well:

#### $ rm /home/jane/Pictures/family_dog.jpg

the filesystem marks the data blocks as free, and from the user’s perspective, the file is gone.

## Managing Permissions with Hard Links

Since hard links share the same inode, any permission changes on one link are reflected on all links. To ensure both Aaron and Jane have correct access to the file, you might add them to the same group (for example, “family”) and adjust the file’s permissions accordingly:

#### $ usermod -a -G family aaron

#### $ usermod -a -G family jane

#### $ chmod 660 /home/aaron/Pictures/family_dog.jpg

These permission changes apply to all hard links referencing the inode, ensuring consistent access.


## Limitations of hard links:

- You can only hard link to files, not directories
- You can only hard link to files on the same filesystem, external drive won't work
- Make sure you all users have the required permissions to access file
####  useradd -a G family aaron
####  useradd -a G family jane

#### chmod 660 /home/aaron/Pictures/family_dog.jpg
#you only need to change permissions on one of the hardlinks because you're actually changing permissions on the Inode











