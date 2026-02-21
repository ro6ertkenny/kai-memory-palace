# Listing Files and Directories

To list all files in a directory ... including those with beginnig with a dot . use:

ls -la

ls -a

ls /var/log

ls -l /var log 
Long listing format


ls -alh 
adds the human readable format

Linux uses an upside down tree ... where the root is the:

###  /
Root directory  

### home | var 
First branches

../Invoice.pdf

../..Invoice.pdf 

 cd / #goto root directory

 cd - #goto previous directory

 cd # will always take you back to the home directory

 cp [source] [destination]

 cp Receipt.pdf Receipts/ 
#use the / after the directory name as a good practice to know it's a directory and not a file

 cp Receipt.pdf Receipts/ ReceiptCopy.pdf 
#copy and change the the name

# Copying Directories

cp -r [source] [dest] recursive (all subfolders and files)

### cp -r Receipts/ BackupOfReceipts/

It can't have the same name ... if it does it will just move it 

 mv 
