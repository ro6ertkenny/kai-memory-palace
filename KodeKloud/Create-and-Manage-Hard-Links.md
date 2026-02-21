echo "Picture of Milo the dog" > Pictures/family_dog.jpg

#### stat Pictures/family_dog.jpg

    File:
    Size:
    Device:     Inode:52946177      Links:2 

 Inode remembers where things are stored and keeps track of meta data

 File points to Inode and Inode points to all of the blocks of data that we require

 Links: is how many hard links to Inodes there are

#### ln path_to_target_file path_to_link_file

#the target is the file you want to link with | the link file is the name of the new hard link we create   

Example: 

ln /home/aaron/Pictures/family_dog.jpg /home/jane/Pictures/family_dog.jpg

Stores picture only once

## Limitations of hard links:

- You can only hard link to files, not directories
- You can only hard link to files on the same filesystem, external drive won't work
- Make sure you all users have the required permissions to access file
####  useradd -a G family aaron
####  useradd -a G family jane

#### chmod 660 /home/aaron/Pictures/family_dog.jpg
#you only need to change permissions on one of the hardlinks because you're actually changing permissions on the Inode











