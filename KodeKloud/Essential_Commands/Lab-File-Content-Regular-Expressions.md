Lab - File Content, Regular Expressions

Task:
You have the following content in /home/bob/testfile (this is just an example file):

a;b;c;d
x;y;z

How would you extract/print the b and the y?

Solution:
cut -d ';' -f 2 testfile

Task:
Change all values enabled to disabled in the /home/bob/values.conf config file.

Has the "/home/bob/values.conf" file been updated as needed?

Solution:
sed -i 's/enabled/disabled/g' /home/bob/values.conf

Task:
Change all values disabled to enabled in the /home/bob/values.conf config file, ignoring the case sensitivity.


For example, any string like disabled, DISABLED, Disabled, etc., must match and should be replaced with enabled.

Has the "/home/bob/values.conf" file been updated as needed?

Solution:
sed -i 's/disabled/enabled/gi' /home/bob/values.conf

Task:
Change all values enabled to disabled in the /home/bob/values.conf config file from line number 500 to 2000.

Has the "/home/bob/values.conf" file been updated as needed?

Solution:
sed -i '500,2000s/enabled/disabled/g' values.conf

Task: 
Replace all occurrences of string #%$2jh//238720//31223 with $2//23872031223 in the /home/bob/data.txt file.

Has the "/home/bob/data.txt" file been updated as needed?

Solution:
sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt

Task:
Open the /home/bob/testfile file in any editor (vi, nano etc) and move the line present on line no:1049 to line no: 5.

Is the line moved?

Solution:
To perform the action, you will need to cut and paste a line of text. The specific steps may vary depending on the editor you are using.

If you are using the 'vim' editor, follow these instructions:

Use :1049 to navigate to the text
Use the command dd to cut the line.
Navigate to line 5.
Use the command p to paste the text at this location.
You might need to paste on line 4, since it pastes below the selected line when using p.

Task:
Delete the first 1000 lines from the /home/bob/testfile file.

Have the first 1,000 lines been deleted?

Solution:
The steps can vary from editor to editor, but let's use vi editor:

Open file with vi editor:

vi /home/bob/testfile

Make sure the cursor is on the very first line; then without entering into the insert mode, enter number 1000 and press dd immediately after that. Finally save the file.

Task:
/home/bob/file1 and /home/bob/file2 are 99% identical. But there's 1 unique line that exists only in /home/bob/file1 or in /home/bob/file2.

Find that line and save the same in the /home/bob/file3 file.

Is the required line saved in "file3"?

Solution:
Execute the below command:

## diff file1 file2 

Copy the line you got in the output from the above command and save the same in file3:

## vi file3

Task:
In the /home/bob/textfile file, there's a number that has 5 digits. Save the number in the /home/bob/number file.

You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/number

Is the required number saved in the "/home/bob/number" file?

Solution:
## egrep '[0-9]{5}' textfile > /home/bob/number

Task:
How many numbers in /home/bob/textfile begin with the number 2. Save the count in the /home/bob/count file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/count

Is the required count saved in the "/home/bob/count" file?

Solution:
## grep -c '^2' textfile > /home/bob/count

Task:
How many lines in the /home/bob/testfile file begin with string Section, regardless of case.
Save the count in the /home/bob/count_lines file.

Is the required count saved in the "/home/bob/count_lines" file?

Solution:
## grep -ic '^SECTION' testfile > /home/bob/count_lines

Task:
Find all lines in the/home/bob/testfile file that contain string man; it must be an exact match.

For example, the line like # before /usr/man or NOCACHE keeps man should match but # given manpath for For a manpath must not match.

Save the filtered lines in the /home/bob/man_filtered file.

Is the filtered output saved in the "/home/bob/man_filtered" file?

Solution:
## grep -w man testfile > /home/bob/man_filtered

Task:
Save the last 500 lines of the /home/bob/textfile file in the /home/bob/last file.

Are the required lines saved in the "/home/bob/last" file?

Solution:
## tail -500  /home/bob/textfile > /home/bob/last


