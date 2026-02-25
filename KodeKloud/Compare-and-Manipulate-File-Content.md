# Compare and Manipulate File Content

## cat /home/users.txt
 use cat to view file if it's short 

Sed - Stream Editor
Searches large lists of files and can replace names etc in single command:

##  sed 's/canda/canada/g' userinfo.txt
    the s is a substitue command
    the g means global(all)

    -i 

##  cut -d ' ' -f 1 userinfo.txt
    -d is a delimeter
    ' ' space to 
    -f fields we want to extract
    1 is the first field 

diff and sdiff


ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Compare-and-Manipulate-File-Content$ ls
Compare-and-Manipulate-File-Content_cat-tac.png
Compare-and-Manipulate-File-Content-Comparing-Files_sdiff.png
Compare-and-Manipulate-File-Content_Cut.png
Compare-and-Manipulate-File-Content_diff.png
Compare-and-Manipulate-File-Content_head.png
Compare-and-Manipulate-File-Content_tail.png
Compare-and-Manipulate-File-Content_Transforming-Text_Sed-1.png
Compare-and-Manipulate-File-Content_Transforming-Text_Sed.png
Compare-and-Manipulate-File-Content_uniq-and-sort.png


 


 


