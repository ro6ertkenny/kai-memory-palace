# Lab - Archive, Back Up, Compress, IO, Redirection

Task:
Create a tar archive logs.tar (under bob's home) of the/var/log/ directory

Solution:
sudo tar -cvf logs.tar /var/log

-c: Create a new archive.
-v: Verbose — show files being added (nice for confirmation).
-f: Specify the filename of the archive.

So, tar -cvf logs.tar /var/log means: "Create (-c) a verbose (-v) archive with filename (-f) logs.tar of the /var/log directory."


Task:
Create a compressed tar archive logs.tar.gz (under bob's home) of the /var/log/ directory

Solution:
sudo tar czfP logs.tar.gz /var/log/

In the context of the tar command, the capital P flag stands for "absolute path". When used, it tells tar to preserve the full absolute path of files and directories during archiving, rather than making them relative or stripping the leading slash.

This is useful if you want to extract the archive exactly where the files originally resided, maintaining the full directory structure.


Task:
List the content of the /home/bob/logs.tar archive and save the output in the /home/bob/tar_data.txt file.

Solution:
tar tfP /home/bob/logs.tar > /home/bob/tar_data.txt


Task:
Extract the contents of /home/bob/archive.tar.gz to the /tmp directory

Solution:
tar --extract --file /home/bob/archive.tar.gz --directory /tmp/
or
tar xf /home/bob/archive.tar.gz -C /tmp

The uppercase -C flag in tar doesn't mean "copy." Instead, it stands for "change to directory" before performing the operation. Think of it as telling tar to switch to a specific directory and then do its thing there—like a quick change of location before acting.

For example:

tar -czf archive.tar.gz -C /path/to/directory .

This creates an archive of the contents in /path/to/directory without including the full path


Task:
Execute the /home/bob/script.sh script and save all normal output (except errors/warnings) in the /home/bob/output_stdout.txt file

Solution:
sudo ./script.sh > /home/bob/output_stdout.txt

The ./ before script.sh indicates that the script is located in the current directory. It's a way to tell the shell, "Run this script from the current directory," especially when the current directory isn't in the system's PATH.

In your case, ./script.sh means you're executing the script.sh file in the directory you're currently in, rather than searching for it in the directories listed in PATH.


Task:
Execute the /home/bob/script.sh script and save all command output (both errors/warnings and normal output) in the /home/bob/output.txt file

Solution:
sudo ./script.sh > /home/bob/output.txt 2>&1


Task:
Execute the /home/bob/script.sh script and save all errors only in the /home/bob/output_errors.txt file

Solution:
sudo ./script.sh 2> /home/bob/output_errors.txt


Task:
Create a bzip archive under bob's home named file.txt.bz2 out of /home/bob/file.txt, but preserve the original file. At the end of the exercise, you should have both.

Does the original file exist?
Is bzip2 created?

bzip2 is created?

Solution:
bzip2 --keep /home/bob/file.txt


Task:
Extract the contents of /home/bob/archive.tar.gz to the /opt directory

Solution:
sudo tar --extract --file /home/bob/archive.tar.gz --directory /opt/
or
sudo tar xf /home/bob/archive.tar.gz -C /opt


Task:
Use the cat command, and redirection, to add (append) the contents of /home/bob/file.txt to /home/bob/destination.txt.

Solution:
cat /home/bob/file.txt >> /home/bob/destination.txt


Task:
Create a file.tar archive of the /home/bob/file directory under the /home/bob location.

Is the archive created?

Check contents.

Solution:
cd  /home/bob
tar --create --file file.tar  file


Task:
Create the gzip archive of the games.txt file , which is present under the /home/bob directory.

Is the gzip of "games.txt" file created?

Solution:

cd /home/bob
gzip games.txt


Task:
We have a /home/bob/lfcs.txt.xz file; uncompress it under /home/bob/.

Is the file uncompressed?

Solution:
cd /home/bob
unxz lfcs.txt.xz


Task:
Sort the contents of the /home/bob/values.conf file alphabetically and eliminate any common values. Save the sorted output in the /home/bob/values.sort file.

Verify the sorted output.

Solution:
sort -du /home/bob/values.conf > /home/bob/values.sort


Task:
Sort again the contents of the /home/bob/values.conf file alphabetically. Eliminate any common values and ignore case

Finally, save the sorted output in the/home/bob/values.sorted file

Verify the sorted output

Solution:
sort -duf /home/bob/values.conf > /home/bob/values.sorted


