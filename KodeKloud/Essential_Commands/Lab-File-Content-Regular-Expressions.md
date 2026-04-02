# Lab - File Content, Regular Expressions

## Task:
You have the following content in /home/bob/testfile (this is just an example file): a;b;c;d x;y;z How would you extract/print the b and the y?

<details><summary>Answer</summary>
cut -d ';' -f 2 testfile

### Explanation:
- cut → extract fields from text
- -d ';' → set delimiter to semicolon
- -f 2 → select the second field
- testfile → input file being processed

## Understanding `cut -d ';' -f 2 testfile`

## 🧠 Core Questions
1. What is a **delimiter** and why do we need it?  
2. Why aren’t we using `>` to redirect output?

---

## 🔥 What Is a Delimiter?

> A delimiter is the character that **separates fields (columns)** in a line

---

## 🧪 Your File Content

    a;b;c;d
    x;y;z

👉 Here:
- `;` separates each value
- so `;` is the **delimiter**

---

## 🔍 What `cut` Needs

`cut` works like this:

> “Split each line using a delimiter → then pick specific fields”

---

## ⚙️ Command Breakdown

    -d ';'
    → delimiter = semicolon

    -f 2
    → field 2 (second column)

---

## 🧠 Step-by-Step

### Line 1:
    a ; b ; c ; d
    1   2   3   4

👉 field 2 = `b`

---

### Line 2:
    x ; y ; z
    1   2   3

👉 field 2 = `y`

---

## ✅ Output

    b
    y

---

## 🧠 Mental Model

    delimiter → splits the line  
    field     → selects the column  

---

## 🔁 1-Line Recall

    cut = split by delimiter → pick field

---

## 🔥 Why NOT Use `>` ?

Because:

> The task only asked to **print/extract**, not save

---

## 🧠 What `>` Does

    > file

👉 redirects output INTO a file

---

## 🧪 Example (if you wanted to save)

    cut -d ';' -f 2 testfile > output.txt

---

## ⚠️ Important Distinction

| Goal        | Command Style |
|-------------|--------------|
| just view   | no `>`       |
| save output | use `>`      |

---

## ⚡ Exam Pattern

If you see:
- “print” → no redirect  
- “save” → use `>`  

---

## 🧨 Operator Insight

`cut` assumes:
- delimiter = TAB by default  

So when it's NOT a tab:
👉 you MUST specify `-d`

---

## Final Takeaway

    -d ';' → tells cut how to split  
    -f 2   → selects the second value  

And no `>` is used because:
> the task only required output, not saving

</details>

---

## Task:
Change all values enabled to disabled in the /home/bob/values.conf config file. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's/enabled/disabled/g' /home/bob/values.conf

### Explanation:
- sed → stream editor for text transformation
- -i → edit file in place
- s → substitute command
- enabled → text to match
- disabled → replacement text
- g → replace all occurrences on each line
- /home/bob/values.conf → target file

## Understanding `sed -i 's/enabled/disabled/g'`

---

## 🧠 Core Questions
1. Does `-i` edit the file in place?  
2. What does `s/.../.../` do?  
3. Why is there a `g` at the end?

---

## 🔥 1. `-i` → In-Place Editing

> YES — `-i` modifies the file directly

Without `-i`:
    sed 's/enabled/disabled/g' file

👉 prints result to screen ONLY

With `-i`:
    sed -i ...

👉 writes changes back into the file

---

## 🧠 Mental Model

    -i = “write it INTO the file”

---

## 🔥 2. What does `s/.../.../` mean?

> `s` = substitute (replace)

---

## ⚙️ Structure

    s / old / new /

Breakdown:

- `s` → substitute  
- `enabled` → what to find  
- `disabled` → what to replace with  

---

## 🧠 Mental Model

    s = search → replace

---

## 🔥 3. What does the `g` mean?

> `g` = global (replace ALL matches in the line)

---

## ⚠️ Without `g`

    sed 's/enabled/disabled/' file

👉 only replaces FIRST match per line

---

## ✅ With `g`

    sed 's/enabled/disabled/g' file

👉 replaces EVERY match on each line

---

## 🧠 Mental Model

    no g → first only  
    g    → get ALL  

---

## 🔁 1-Line Recall

    g = “get them all”

---

## 🧪 Example

### Input
    enabled enabled enabled

### Without `g`
    disabled enabled enabled

### With `g`
    disabled disabled disabled

---

## ⚠️ Clarification About Your Question

> “does -s mean replace?”

❌ There is NO `-s` here

👉 It’s:
    s/.../.../

NOT:
    -s

---

## 🧠 Full Command Breakdown

    sed -i 's/enabled/disabled/g' file

- `sed` → stream editor  
- `-i` → edit file in place  
- `s` → substitute  
- `enabled` → find  
- `disabled` → replace  
- `g` → all occurrences  

---

## ⚡ Exam Pattern

If you see:
- “replace text in file” → use `sed`
- “update file directly” → add `-i`
- “all occurrences” → add `g`

---

## 🧨 Operator Insight

Always remember:

    sed without -i = safe preview  
    sed with -i    = permanent change

---

## Final Takeaway

    -i → edit file directly  
    s  → substitute  
    g  → replace ALL matches  

👉 Together:
> “replace every occurrence of ‘enabled’ with ‘disabled’ in the file”

</details>

---

## Task:
Change all values disabled to enabled in the /home/bob/values.conf config file, ignoring the case sensitivity. For example, any string like disabled, DISABLED, Disabled, etc., must match and should be replaced with enabled. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's/disabled/enabled/gi' /home/bob/values.conf

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

## 🧠 Core Question
> Why are there single quotes `' '` around `s/.../.../g`?

---

## 🔥 Short Answer

> The quotes protect the `sed` expression from the shell (Bash)

---

## 🧠 What Bash Does (Important)

Before running a command, **Bash tries to interpret special characters** like:

- `$` → variables  
- `*` → wildcards  
- `\` → escapes  
- `/` → sometimes path-related parsing  

---

## 🔥 Why We Use Quotes

    's/enabled/disabled/g'

👉 tells Bash:

> “DO NOT touch this — pass it exactly to `sed`”

---

## ⚠️ What Happens Without Quotes?

    sed -i s/enabled/disabled/g file

👉 This *might* work sometimes…

BUT:
- unsafe
- can break if special characters are involved

---

## 🧠 Mental Model

    '...' = hands-off mode for Bash

    Everything inside quotes is:

    ONE instruction to sed

---

## 🔁 1-Line Recall

    quotes = protect sed logic from Bash

---

## 🧨 Operator Insight

Always quote `sed` expressions:

    sed 's/a/b/' file

Even if it “works” without quotes:

👉 don’t risk it — always use quotes

---

</details>

---

## Task:
Change all values enabled to disabled in the /home/bob/values.conf config file from line number 500 to 2000. Has the "/home/bob/values.conf" file been updated as needed?

<details><summary>Answer</summary>
sed -i '500,2000s/enabled/disabled/g' values.conf

### Explanation:
- sed → stream editor
- -i → edit file in place
- 500,2000 → line range to apply changes
- s → substitute command
- enabled → pattern to match
- disabled → replacement text
- g → replace all matches on each line
- values.conf → target file

</details>

---

## Task:
Replace all occurrences of string #%$2jh//238720//31223 with $2//23872031223 in the /home/bob/data.txt file. Has the "/home/bob/data.txt" file been updated as needed?

<details><summary>Answer</summary>
sed -i 's~#%$2jh//238720//31223~$2//23872031223~g' /home/bob/data.txt

### Explanation:
- sed → stream editor
- -i → edit file in place
- s → substitute command
- ~ → delimiter used instead of / to avoid escaping slashes
- #%$2jh//238720//31223 → pattern to match
- $2//23872031223 → replacement text
- g → replace all matches on each line
- /home/bob/data.txt → target file

## Using Different Delimiters in `sed` (Not Just `/`)

---

## 🧠 Core Question
> Is `~` the only substitute for `/` in `sed`?

---

## 🔥 Short Answer

> NO — you can use **almost ANY character** as the delimiter

---

## 🧠 What’s Going On Here?

Normally:

    s/old/new/

👉 `/` is the delimiter

---

## 🔁 But You Can Change It

    s~old~new~
    s|old|new|
    s#old#new#
    s@old@new@

👉 All of these are VALID

---

## 🔥 Why Change the Delimiter?

Because your pattern contains `/`

---

## 🧪 Example Problem

    s/path/to/file/new/path/

❌ Confusing — too many `/`

---

## ✅ Better Version

    s|path/to/file|new/path|

👉 Much cleaner

---

## 🧠 Mental Model

    s<delimiter>old<delimiter>new<delimiter>

👉 delimiter = your choice

---

## ⚙️ In Your Command

    s~#%$2jh//238720//31223~$2//23872031223~g

- delimiter = `~`
- avoids escaping all those `/`

---

## ⚠️ Rule for Choosing a Delimiter

> Pick a character that does NOT appear in your pattern

---

## 🔥 Common Choices

| Delimiter | When to Use |
|----------|------------|
| `/`      | simple patterns |
| `|`      | paths/URLs |
| `#`      | configs |
| `~`      | random safe choice |
| `@`      | general use |

---

## ⚠️ What You CANNOT Use

- letters (`a`, `b`, etc.) → confusing  
- numbers → confusing  
- space → invalid  

---

## 🧠 Mental Model (LOCK THIS IN)

    delimiter = separator between parts

NOT special — just a separator

---

## 🔁 1-Line Recall

    “You can use ANY delimiter — just avoid conflicts”

---

## 🧨 Operator Insight

Good operators ALWAYS switch delimiters when:

- working with file paths
- working with URLs
- working with complex strings

👉 reduces escaping → cleaner commands

---

## Final Takeaway

`~` is NOT special.

> It’s just a convenient separator — you can use almost any character you want

</details>

---

## Task:
Open the /home/bob/testfile file in any editor (vi, nano etc) and move the line present on line no:1049 to line no: 5. Is the line moved?

<details><summary>Answer</summary>
To perform the action, you will need to cut and paste a line of text. The specific steps may vary depending on the editor you are using. If you are using the 'vim' editor, follow these instructions: Use :1049 to navigate to the text Use the command dd to cut the line. Navigate to line 5. Use the command p to paste the text at this location. You might need to paste on line 4, since it pastes below the selected line when using p.

### Explanation:
- :1049 → jump to line 1049 in vim
- dd → delete (cut) the current line
- navigate to line 5 → move cursor to target location
- p → paste below the current line
- vim → editor used to manipulate file content

</details>

---

## Task:
Delete the first 1000 lines from the /home/bob/testfile file. Have the first 1,000 lines been deleted?

<details><summary>Answer</summary>
The steps can vary from editor to editor, but let's use vi editor: Open file with vi editor: vi /home/bob/testfile Make sure the cursor is on the very first line; then without entering into the insert mode, enter number 1000 and press dd immediately after that. Finally save the file.

### Explanation:
- vi → open file in editor
- 1000dd → delete 1000 lines starting from current line
- dd → delete a line
- number prefix → repeat the command that many times
- save → write changes to disk

</details>

---

## Task:
/home/bob/file1 and /home/bob/file2 are 99% identical. But there's 1 unique line that exists only in /home/bob/file1 or in /home/bob/file2. Find that line and save the same in the /home/bob/file3 file. Is the required line saved in "file3"?

<details><summary>Answer</summary>

    diff /home/bob/file1 /home/bob/file2
    vi /home/bob/file3

### Explanation:
- diff → compare two files line by line
- file1 file2 → files being compared
- output → shows differences between files
- vi file3 → open/create file3 to store the unique line

</details>

---

## Task:
In the /home/bob/textfile file, there's a number that has 5 digits. Save the number in the /home/bob/number file. You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/number Is the required number saved in the "/home/bob/number" file?

<details><summary>Answer</summary>
 egrep '[0-9]{5}' textfile > /home/bob/number

### Explanation:
- egrep → search using extended regular expressions
- [0-9]{5} → match exactly five digits
- textfile → input file being searched
 > → redirect output to file
- /home/bob/number → destination file

# Understanding `[ ]` and `{ }` in `egrep '[0-9]{5}'`

---

## 🧠 Core Question
> What do `[ ]` and `{ }` mean?

---

## 🔥 Short Answer

| Symbol | Meaning |
|--------|--------|
| `[ ]`  | match ONE character from a set |
| `{ }`  | match a specific NUMBER of times |

---

# 🔍 1. `[ ]` → Character Class

    [0-9]

👉 means:
> match ANY ONE digit from 0 through 9

---

## 🧠 Mental Model

    [ ] = “one of these”

---

## 🧪 Examples

| Pattern | Matches |
|--------|--------|
| `[abc]` | a OR b OR c |
| `[0-9]` | any digit |
| `[A-Z]` | uppercase letters |

---

# 🔍 2. `{ }` → Quantifier (How Many Times)

    {5}

👉 means:
> exactly 5 times

---

## 🧠 Mental Model

    {n} = repeat n times

---

## 🧪 Examples

| Pattern | Meaning |
|--------|--------|
| `[0-9]{5}` | exactly 5 digits |
| `[a]{3}`   | aaa |
| `[A-Z]{2}` | 2 uppercase letters |

---

# 🔥 Combine Them

    [0-9]{5}

👉 means:

> “match EXACTLY 5 digits in a row”

---

## 🧪 Example Matches

✅ Matches:
    12345
    98765

❌ Does NOT match:
    1234      (too short)
    123456    (too long unless partial match allowed)

---

# ⚠️ Why Quotes `' '` Are Used

    '[0-9]{5}'

👉 protects pattern from Bash

Without quotes:
- `{}` might be interpreted by shell
- pattern could break

---

# 🧠 Full Mental Model

    [0-9]     → choose a digit  
    {5}       → do it 5 times  

👉 result:
> 5-digit number

---

# ⚡ Exam Pattern

If you see:
- “X digits” → use `{X}`
- “numbers only” → `[0-9]`

---

# 🔁 1-Line Recall

    [ ] = choose one  
    { } = how many times  

---

# 🧨 Operator Insight

This is **regex (pattern matching)** — used in:

- `grep / egrep`
- `sed`
- logs parsing
- config searches

👉 Mastering this = huge LFCS advantage

---

# Final Takeaway

    [0-9]{5}

means:
> match exactly five digits in a row

And:

    egrep '[0-9]{5}'

👉 finds any 5-digit number in the file

</details>

---

## Task:
How many numbers in /home/bob/textfile begin with the number 2. Save the count in the /home/bob/count file. You can use the redirection to save your command's output in a file: [your-command] > /home/bob/count Is the required count saved in the "/home/bob/count" file?

<details><summary>Answer</summary>
 grep -c '^2' textfile > /home/bob/count

### Explanation:
- grep → search text
- -c → count matching lines
- ^2 → match lines starting with 2
- textfile → input file
'>' → redirect output to file
- /home/bob/count → destination file

</details>

---

## Task:
How many lines in the /home/bob/testfile file begin with string Section, regardless of case. Save the count in the /home/bob/count_lines file. Is the required count saved in the "/home/bob/count_lines" file?

<details><summary>Answer</summary>
  grep -ic '^SECTION' testfile > /home/bob/count_lines

### Explanation:
- grep → search text
- -i → case-insensitive matching
- -c → count matching lines
- ^SECTION → match lines starting with "SECTION"
- testfile → input file
'>' → redirect output to file
- /home/bob/count_lines → destination file

</details>

---

## Task:
Find all lines in the/home/bob/testfile file that contain string man; it must be an exact match. For example, the line like # before /usr/man or NOCACHE keeps man should match but # given manpath for For a manpath must not match. Save the filtered lines in the /home/bob/man_filtered file. Is the filtered output saved in the "/home/bob/man_filtered" file?

<details><summary>Answer</summary>
 grep -w man testfile > /home/bob/man_filtered

### Explanation:
- grep → search text
- -w → match whole words only
- man → target word
- testfile → input file
'>' → redirect output to file
- /home/bob/man_filtered → destination file

</details>

---

## Task:
Save the last 500 lines of the /home/bob/textfile file in the /home/bob/last file. Are the required lines saved in the "/home/bob/last" file?

<details><summary>Answer</summary>
 tail -500 /home/bob/textfile > /home/bob/last

### Explanation:
- tail → output last part of a file
- -500 → show last 500 lines
- /home/bob/textfile → input file
'>' → redirect output to file
- /home/bob/last → destination file


</details>
