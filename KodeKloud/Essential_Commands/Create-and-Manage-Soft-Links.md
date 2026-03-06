A hardlink points to an Inode and a softlink is nothing more than a file that points to path instead ... it's like a text file with a path to a file or directory inside

The syntax of the command to create a softlink (which is also called a symbolic link) is the same as the hardlink but we need to add the -s (symbolic option) 

Example:

## ln -s path_to_target_file path_to_link_file

## ln -s /home/aaron/Pictures/family_dog.jpg family_dog_shortcut.jpg

## ls -l

## lrwxrwxrwx. 1 aaron aaron family_dog_shortcut.jpg -> /home/aaron/Pictures..

The l in the beginning shows that it's a softlink ... it also displays the path that the softlink points to
** if this path is long it may not show the whole path so use the following command:

## readlink family_dog_shortcut.jpg
    /home/aaron/Pictures/family_dog.jpg

Also notice all the permissions bits (rwx) for this file are enabled because the permissions for the softlink don't matter ... if you try to write to fstab shortcut this will be denied because the permissios to the destination file apply and etc/fstab doesn't allow regular users to write here

If you ever change the directory name (aaron) to something else the softlink will break

Create a softlink with a relative path of the dogfile ... relative to the directory where the softlink is

[/home/aaron]$ ln -s Pictures/family_dog.jpg relative_picture_shortcut

You can also softlink to different directories

Lab - Files, Directories, Hard and Soft Links - Question:

Create a soft link to /tmp directory. Create this link in /home/bob directory and call it link_to_tmp

##  ln -s /home/bob /tmp/link_to_tmp
