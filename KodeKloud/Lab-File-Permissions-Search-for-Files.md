Lab - File Permissions, Search for Files

Task:
What command can be used to find files and directoriesmodified in the last 5 minutes in the /dev directory?

Solution:
The find /dev/ -mmin -5 command can be used to find files and directories modified in the last 5 minutes in the /dev directory.

Task:
What command removes the write permission for the group from a file?

Solution:
The chmod g-w some_file command can be used to remove write permission for the group from some_file file.



Task:
Find files/directories under the /var/log/ directory that the group can write to, but others cannot read or write to it. Save the list of the files/directories (with complete parent path) in the /home/bob/data.txt file.

You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/data.txt


To make this easier to understand, the logic of the command can be broken down like this:

-> Permissions for the group have to be at least w. If there's also an extra r or x in there, it will still match.

-> Permissions for others have not to be r or w. That means, if any of these two permissions, r or w, match for others, the result has to be excluded.

Solution:
##  sudo find /var/log/ -perm -g=w ! -perm /o=rw > /home/bob/data.txt

Task:
Find our secret file under /home/bob. You can either look for a file that is exactly 213 kilobytes or a file that has permission 402 in octal.


Save the name (including the parent directory path) of this file in the /home/bob/secfile.txt file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/secfile.txt

Solution:
##  find /home/bob -size 213k -o -perm 402 > /home/bob/secfile.txt

Task:
In our lessons, we briefly mentioned the setuid, setgid, and sticky bit special permissions. Consider that setuid is short for set user id and setgid is short for set group id.


Add the permissions for setuid, setgid, and sticky bit on the /home/bob/datadir directory.

Do not use octal notation for this question.

Solution:
##  chmod u+s,g+s,o+t /home/bob/datadir

Task:
Find the dogs.txt file under the /usr/share directory.


Save the location of the file in the /home/bob/dogs file.

Solution:
##  sudo find /usr/share -name dogs.txt > /home/bob/dogs

Task:
Find the cats.txt file under bob's home directory and copy it into the /opt directory.

Solution:
##  sudo find /home/bob/ -name cats.txt
##  sudo cp /home/bob/.etc/h/e/r/cats.txt /opt/cats.txt

Task:
Find all directories named pets in the /var/directory and save the output (along with directory path) in the/home/bob/pets.txt file.


You should be able to save the output in a file using redirection: <your-command> > /home/bob/pets.txt

Solution:
##  sudo find /var/ -type d -name pets > /home/bob/pets.txt

Task:
Find all the files whose permissions are 0777 in /var directory.

How many such files did you find?

Solution:
sudo find /var -type f -perm 0777 -print

Task:
Find all the files whose permissions are 0640 in /usr/ directory and save the output (along with parent path) in /home/bob/.opt/permissions.txt file.


You should be able to save the output in a file using redirection: <your-command> > /home/bob/.opt/permissions.txt

Solution:
##  sudo find /usr -type f -perm 0640 > /home/bob/.opt/permissions.txt

Task:
Find all the files which have been modified in the last 2 hours in /usr directory.

How many such files did you find?

Solution:
##  sudo find /usr -type f -mmin -120

Task:
Find all the files which have been modified in the last 30 minutes in the /var directory.

How many such files did you find?

##  sudo find /var -type f -mmin -30 | wc -l

Task:
Find all the files with size 20MB in /var directory.

How many such files did you find?

Solution:
##  sudo find /var -type f -size 20M

Task:
Find all files between 5MB and 10MB in the /usr directory and save the output (along with parent path) in the/home/bob/size.txt file.


You should be able to save the output in a file using redirection: <your-command> > /home/bob/size.txt

Solution:
##  sudo find /usr -type f -size +5M -size -10M > /home/bob/size.txt

Task:
Create a directory named LFCS under bob's home directory and update its user owner permissions to only x (execute), and group and others should not have any permissions.


It should give us a permission denied error while listing the contents of the directory.

Solution:
##  sudo mkdir /home/bob/LFCS
##  sudo chmod 0100 /home/bob/LFCS

Task:
Update the permissions for some_directory to rwxr-xr-x

Solution:
##  chmod 0755 some_directory/


