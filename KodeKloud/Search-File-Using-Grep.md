# Search File Using Grep

## grep 'password' /etc/ssh/sshd_config

## grep 'Password' 

case sensitive is counterproductive because they give us partial results

use:
## grep -i 'password' /etc/ssh/..

### -i means ignore case (case insensitive)

Search for all files under a directory and it's sub directories

## grep -r 'password' /etc/ 

## -r
recursive

We can group the recursive search option with a -i ignore case option:
## grep -ri 'password' /etc/

## sudo grep -ri 'password' /etc 
(searches for root user)

## sudo grep -ri --color 'password' /etc/
this color codes the grep output 

## grep -vi 'password' /etc/ssh/sshd_config
invert search results - search for lines that don't contain the text password y adding the -v option

## grep -wi 'password' /etc/
adding the -w option matches the exact word without any letters before or after it (ex/passwords)

## grep -oi 'password' /etc/
the -o means 'only matching' option
omits extra stuff on the line that doesn't matter





ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Searching-File-Using-Grep-Searching-with-Grep$ ls
Search-File-Using-Grep-Searching-with-Grep-2.png
Searching-File-Using-Grep-Searching-with-Grep-1.png
Searching-File-Using-Grep-Searching-with-Grep-3.png
Searching-File-Using-Grep-Searching-with-Grep-4.png
Searching-File-Using-Grep-Searching-with-Grep-5.png
Searching-File-Using-Grep-Searching-with-Grep-6.png
Searching-File-Using-Grep-Searching-with-Grep-7.png
Searching-File-Using-Grep-Searching-with-Grep-8.png

