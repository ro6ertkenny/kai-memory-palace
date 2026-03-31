# File Content & Regular Expressions — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Extract/print the second field (b and y) from a semicolon-separated file.

<details>
<summary>Answer</summary>

### Command
    cut -d ';' -f 2 /home/bob/testfile

### Explanation
- cut → extract columns
- -d ';' → delimiter is semicolon
- -f 2 → field 2

</details>

---

## 🧪 Task 2

Task: Change all values enabled to disabled in /home/bob/values.conf.

<details>
<summary>Answer</summary>

### Command
    sed -i 's/enabled/disabled/g' /home/bob/values.conf

### Explanation
- sed → stream editor
- -i → edit file in place
- s → substitute
- g → global (all matches per line)

</details>

---

## 🧪 Task 3

Task: Change all values disabled to enabled in /home/bob/values.conf, ignoring case.

<details>
<summary>Answer</summary>

### Command
    sed -i 's/disabled/enabled/gi' /home/bob/values.conf

### Explanation
- g → replace all matches
- i → ignore case

</details>

---

## 🧪 Task 4

Task: Change all values enabled to disabled in /home/bob/values.conf from line 500 to 2000.

<details>
<summary>Answer</summary>

### Command
    sed -i '500,2000s/enabled/disabled/g' /home/bob/values.conf

### Explanation
- 500,2000 → line range
- s → substitute within range

</details>

---

## 🧪 Task 5

Task: Replace all occurrences of #%$2jh//238720//31223 with $2//23872031223 in /home/bob/data.txt.

<details>
<summary>Answer</summary>

### Command
    sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt

### Explanation
- ~ → alternate delimiter (avoids escaping /)
- g → replace all occurrences

</details>

---

## 🧪 Task 6

Task: Move the line at line 1049 to line 5 using an editor.

<details>
<summary>Answer</summary>

### Command (vim)
    :1049
    dd
    :5
    p

### Explanation
- :1049 → jump to line
- dd → cut line
- :5 → go to line 5
- p → paste below current line

</details>

---

## 🧪 Task 7

Task: Delete the first 1000 lines from /home/bob/testfile.

<details>
<summary>Answer</summary>

### Command (vim)
    1000dd

### Explanation
- 1000 → repeat count
- dd → delete line
- deletes first 1000 lines from current position

</details>

---

## 🧪 Task 8

Task: Find the unique differing line between /home/bob/file1 and /home/bob/file2 and save it to file3.

<details>
<summary>Answer</summary>

### Command
    diff /home/bob/file1 /home/bob/file2

### Explanation
- diff → compare files line by line
- manually copy differing line into:
    
    vi /home/bob/file3

</details>

---

## 🧪 Task 9

Task: Extract a 5-digit number from /home/bob/textfile and save to /home/bob/number.

<details>
<summary>Answer</summary>

### Command
    egrep '[0-9]{5}' /home/bob/textfile > /home/bob/number

### Explanation
- [0-9]{5} → exactly 5 digits
- egrep → extended regex
- `>` → redirect output to file

</details>

---

## 🧪 Task 10

Task: Count how many numbers in /home/bob/textfile begin with 2 and save to /home/bob/count.

<details>
<summary>Answer</summary>

### Command
    grep -c '^2' /home/bob/textfile > /home/bob/count

### Explanation
- ^2 → starts with 2
- -c → count matches
- `>` → save output

</details>

---

## 🧪 Task 11

Task: Count lines in /home/bob/testfile that begin with "Section", ignoring case.

<details>
<summary>Answer</summary>

### Command
    grep -ic '^SECTION' /home/bob/testfile > /home/bob/count_lines

### Explanation
- ^SECTION → starts with "SECTION"
- -i → ignore case
- -c → count lines
- `>` → save result

</details>

---

## 🧪 Task 12

Task: Find lines containing exact word "man" in /home/bob/testfile and save to /home/bob/man_filtered.

<details>
<summary>Answer</summary>

### Command
    grep -w man /home/bob/testfile > /home/bob/man_filtered

### Explanation
- -w → whole word match only
- avoids partial matches (manpath, human, etc.)
- `>` → save output

</details>

---

## 🧪 Task 13

Task: Save the last 500 lines of /home/bob/textfile into /home/bob/last.

<details>
<summary>Answer</summary>

### Command
    tail -500 /home/bob/textfile > /home/bob/last

### Explanation
- tail → get last lines
- -500 → last 500 lines
- `>` → redirect to file

</details>
