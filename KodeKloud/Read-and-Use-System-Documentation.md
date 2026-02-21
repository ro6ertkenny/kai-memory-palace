ls --help

journalctl --help

man journalctl

man man

man 1 printf

man 3 printf

apropos
let's you search through man pages

create the database: 

 ## sudo mandb

commands are found in Sections 1 and 8 

apropos -s 1,8 director

Press Tab Tab for autocompletions

# systemctl list-dep 

this lists dependencies 

# *** LEARN HOW TO USE:

 man
 --help

man comes before and help comes after the command


Version:

ssh --V

Change the static hostname:

 hostnamectl 

Lab - Logging in and System Documentation:

## You are trying to use ssh alex@localhost to log in through SSH. Your connection is refused. ssh has a command line option to show you the verbose output. That will show a lot more status messages and help you debug why this connection is failing. What is the correct option for that? (you need not make ssh connection work at this point)

 ssh -v ro6ert@ro6bx

You type host in the terminal. What keys do you press to see some suggestions about what you can type here?

TAB TAB

## Which section of the manual pages deals with System administration commands?

 man man

Section #8

How many hidden files are there in the /home/bob/data/ directory?

ls -a

2 

## SSH into node01 host from ubuntu-host and create a blank file called /home/bob/myfile in node01 host

You should be able to create the file using touch /home/bob/myfile command.


Please find below the SSH credentials for node01 host:

Host: node01
Username: bob

Password: caleston123

Remember to type exit when you finish this task


## We are trying to run the apropos ssh command to get some details about the commands related to ssh, but we are getting this error:

ssh: nothing appropriate


Look into the issue and fix it to make the apropos ssh command work

 ### sudo mandb

 ### apropos ssh


## Using the apropos command, find out the configuration file for NFS mounts and save its name in the /home/bob/nfs file.

Is the configuration file name NFS mounts saved in the "/home/bob/nfs" file?

To fix this, you'll want to use the echo command to write the string nfsmount.conf directly into the file /home/bob/nfs. Here's how you can do it:

echo "nfsmount.conf" > /home/bob/nfs

