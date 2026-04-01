# Lab - File Content, Regular Expressions

## Task:
You have the following content in /home/bob/testfile (this is just an example file): a;b;c;d x;y;z How would you extract/print the b and the y?

<details><summary>Answer</summary>
cut -d ';' -f 2 testfile
</details>

### Explanation:
- cut → extract fields from text
- -d ';' → set delimiter to semicolon
- -f 2 → select the second field
- testfile → input file being processed

---

## Task:
Change all values enabled to disabled in the /home/bob/values.conf config file. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's/enabled/disabled/g' /home/bob/values.conf
</details>

### Explanation:
- sed → stream editor for text transformation
- -i → edit file in place
- s → substitute command
- enabled → text to match
- disabled → replacement text
- g → replace all occurrences on each line
- /home/bob/values.conf → target file

---

## Task:
Change all values disabled to enabled in the /home/bob/values.conf config file, ignoring the case sensitivity. For example, any string like disabled, DISABLED, Disabled, etc., must match and should be replaced with enabled. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's/disabled/enabled/gi' /home/bob/values.conf
</details>

### Explanation:
- sed → stream editor
- -i → edit file in place
- s → substitute command
- disabled → pattern to match
- enabled → replacement text
- g → replace all matches on each line
- i → case-insensitive matching
- /home/bob/values.conf → target file

---

## Task:
Change all values enabled to disabled in the /home/bob/values.conf config file from line number 500 to 2000. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i '500,2000s/enabled/disabled/g' values.conf
</details>

### Explanation:
- sed → stream editor
- -i → edit file in place
- 500,2000 → line range to apply changes
- s → substitute command
- enabled → pattern to match
- disabled → replacement text
- g → replace all matches on each line
- values.conf → target file

---

## Task:
Replace all occurrences of string #%$2jh//238720//31223 with $2//23872031223 in the /home/bob/data.txt file. Has the "/home/bob/data.txt" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt
</details>

### Explanation:
- sed → stream editor
- -i → edit file in place
- s → substitute command
- ~ → delimiter used instead of / to avoid escaping slashes
- #%$2jh//238720//31223 → pattern to match
- $2//23872031223 → replacement text
- g → replace all matches on each line
- /home/bob/data.txt → target file

---

## Task:
Open the /home/bob/testfile file in any editor (vi, nano etc) and move the line present on line no:1049 to line no: 5. Is the line moved?

<details><summary>Answer</summary>
To perform the action, you will need to cut and paste a line of text. The specific steps may vary depending on the editor you are using. If you are using the 'vim' editor, follow these instructions: Use :1049 to navigate to the text Use the command dd to cut the line. Navigate to line 5. Use the command p to paste the text at this location. You might need to paste on line 4, since it pastes below the selected line when using p.
</details>

### Explanation:
- :1049 → jump to line 1049 in vim
- dd → delete (cut) the current line
- navigate to line 5 → move cursor to target location
- p → paste below the current line
- vim → editor used to manipulate file content

---

## Task:
Delete the first 1000 lines from the /home/bob/testfile file. Have the first 1,000 lines been deleted?

<details><summary>Answer</summary>
The steps can vary from editor to editor, but let's use vi editor: Open file with vi editor: vi /home/bob/testfile Make sure the cursor is on the very first line; then without entering into the insert mode, enter number 1000 and press dd immediately after that. Finally save the file.
</details>

### Explanation:
- vi → open file in editor
- 1000dd → delete 1000 lines starting from current line
- dd → delete a line
- number prefix → repeat the command that many times
- save → write changes to disk

---

## Task:
/home/bob/file1 and /home/bob/file2 are 99% identical. But there's 1 unique line that exists only in /home/bob/file1 or in /home/bob/file2. Find that line and save the same in the /home/bob/file3 file. Is the required line saved in "file3"?

<details><summary>Answer</summary>
Execute the below command: ## diff file1 file2 Copy the line you got in the output from the above command and save the same in file3: ## vi file3
</details>

### Explanation:
- diff → compare two files line by line
- file1 file2 → files being compared
- output → shows differences between files
- vi file3 → open/create file3 to store the unique line

---

## Task:
In the /home/bob/textfile file, there's a number that has 5 digits. Save the number in the /home/bob/number file. You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/number Is the required number saved in the "/home/bob/number" file?

<details><summary>Answer</summary>
## egrep '[0-9]{5}' textfile > /home/bob/number
</details>

### Explanation:
- egrep → search using extended regular expressions
- [0-9]{5} → match exactly five digits
- textfile → input file being searched
- > → redirect output to file
- /home/bob/number → destination file

---

## Task:
How many numbers in /home/bob/textfile begin with the number 2. Save the count in the /home/bob/count file. You can use the redirection to save your command's output in a file: [your-command] > /home/bob/count Is the required count saved in the "/home/bob/count" file?

<details><summary>Answer</summary>
## grep -c '^2' textfile > /home/bob/count
</details>

### Explanation:
- grep → search text
- -c → count matching lines
- ^2 → match lines starting with 2
- textfile → input file
- > → redirect output to file
- /home/bob/count → destination file

---

## Task:
How many lines in the /home/bob/testfile file begin with string Section, regardless of case. Save the count in the /home/bob/count_lines file. Is the required count saved in the "/home/bob/count_lines" file?

<details><summary>Answer</summary>
## grep -ic '^SECTION' testfile > /home/bob/count_lines
</details>

### Explanation:
- grep → search text
- -i → case-insensitive matching
- -c → count matching lines
- ^SECTION → match lines starting with "SECTION"
- testfile → input file
- > → redirect output to file
- /home/bob/count_lines → destination file

---

## Task:
Find all lines in the/home/bob/testfile file that contain string man; it must be an exact match. For example, the line like # before /usr/man or NOCACHE keeps man should match but # given manpath for For a manpath must not match. Save the filtered lines in the /home/bob/man_filtered file. Is the filtered output saved in the "/home/bob/man_filtered" file?

<details><summary>Answer</summary>
## grep -w man testfile > /home/bob/man_filtered
</details>

### Explanation:
- grep → search text
- -w → match whole words only
- man → target word
- testfile → input file
- > → redirect output to file
- /home/bob/man_filtered → destination file

---

## Task:
Save the last 500 lines of the /home/bob/textfile file in the /home/bob/last file. Are the required lines saved in the "/home/bob/last" file?

<details><summary>Answer</summary>
## tail -500 /home/bob/textfile > /home/bob/last
</details>

### Explanation:
- tail → output last part of a file
- -500 → show last 500 lines
- /home/bob/textfile → input file
- > → redirect output to file
- /home/bob/last → destination file
