# Compare and Manipulate File Content

#### cat /home/users.txt
 use cat to view file if it's short 


## Automating Text Replacement with SED

Sed - Stream Editor

Searches large lists of files and can replace names etc in single command:



Editing multiple instances manually in large files can be error-prone and time-consuming. The Stream Editor (SED) automates search and replace tasks efficiently. For example, if a file listing user details has the country “Canada” misspelled as “canda”, you can preview the correction with:

#### $ sed 's/canda/canada/g' userinfo.txt

Let’s break down the command:

#### s/canda/canada/g: The substitute command where canda is replaced with canada globally on each line.

Single quotes ensure Bash does not interpret special characters.

The -g flag replaces all occurrences in each line.

Once you’re satisfied with the preview, apply the change in-place:

#### $ sed -i 's/canda/canada/g' userinfo.txt

Always back up your files before performing in-place edits with sed -i.

It is important to quote the expression correctly to prevent Bash from misinterpreting special characters such as the asterisk. Both single and double quotes can be used:

#### $ sed "s/canda/canada/g" userinfo.txt

    the s is a substitue command
    the g means global(all)

    -i 


## Extracting Data with Cut

The cut command is ideal for extracting specific columns from a file. For example, to extract the first column—which often contains names—from a space-separated file, use:

####  cut -d ' ' -f 1 userinfo.txt
    -d is a delimeter
    ' ' space to 
    -f fields we want to extract
    1 is the first field 

Here, -d ' ' sets the delimiter to a space, while -f 1 specifies that the first field should be extracted.

If the file is comma-separated, simply adjust the delimiter. For instance, to extract the third field (which could represent country names) and save the output to countries.txt, run:

#### $ cut -d ',' -f 3 userinfo.txt > countries.txt

In this command, the redirection operator (>) saves the extracted output to a new file.

## Removing Duplicate Entries

After extracting data—like a list of countries—you might encounter duplicate entries. The uniq command removes duplicates from adjacent lines. For example:

#### $ uniq countries.txt
	usa
	canada
	usa
	canada

To remove duplicates effectively, sort the file first so that similar lines are adjacent, then pipe the output to uniq:

#### $ sort countries.txt | uniq
	canada
	usa

Piping (|) is a powerful technique that allows you to pass the output from one command directly into another for further processing.


## Comparing Files with Diff

When system upgrades or configuration changes modify files, comparing the old and new versions is crucial. The diff command highlights these differences. Consider the following example:

#### $ diff file1 file2
1c1
< only exists in file 1
---
> only exists in file 2
4c4
< only exists in file 1
---
> only exists in file 2

In this output, the notation 1c1 indicates that line 1 of file1 differs from line 1 of file2. The < symbol shows content from file1, while > represents content from file2.
For more context, use the -c option:

#### $ diff -c file1 file2
*** file1	2021-10-28 20:39:43.083264406 -0500
--- file2	2021-10-28 20:40:02.900262846 -0500
**************
** 1,4 ****
! only exists in file 1
  identical line 2
  identical line 3
! only exists in file 1
--- 1,4 ----
! only exists in file 2
  identical line 2
  identical line 3
! only exists in file 2

For a side-by-side visual comparison, use the -y option:

#### $ diff -y file1 file2
only exists in file 1        | only exists in file 2
identical line 2            | identical line 2
identical line 3            | identical line 3
only exists in file 1

Alternatively, you can use sdiff for a similar side-by-side comparison:

#### $ sdiff file1 file2
only exists in file 2
identical line 2
identical line 3
exists in file 2

Using the diff command with different options (-c, -y, or sdiff) can help you pinpoint changes more easily during system upgrades or when troubleshooting configuration issues.

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


 


 


