# File Permissions & Search — LFCS Lab

---

## 🧪 Task 1

Task: What command can be used to find files and directories modified in the last 5 minutes in the /dev directory?

<details>
<summary>Answer</summary>

### Command
    find /dev -mmin -5

### Explanation
- find → search filesystem
- /dev → starting directory
- -mmin → modified time in minutes
- -5 → less than 5 minutes ago

</details>

---

## 🧪 Task 2

Task: What command removes the write permission for the group from a file?

<details>
<summary>Answer</summary>

### Command
    chmod g-w some_file

### Explanation
- chmod → change permissions
- g → group
- -w → remove write permission

</details>

---

## 🧪 Task 3

Task: Find files/directories under the /var/log/ directory that the group can write to, but others cannot read or write to it. Save the list of the files/directories (with complete parent path) in the /home/bob/data.txt file.

You can use the redirection to save your command's output in a file i.e [your-command] > /home/bob/data.txt

To make this easier to understand, the logic of the command can be broken down like this:

-> Permissions for the group have to be at least w. If there's also an extra r or x in there, it will still match.

-> Permissions for others have not to be r or w. That means, if any of these two permissions, r or w, match for others, the result has to be excluded.

<details>
<summary>Answer</summary>

### Command
    sudo find /var/log -perm -g=w ! -perm /o=rw > /home/bob/data.txt

### Explanation
- -perm -g=w → group has write permission as a minimum match
- ! → NOT
- -perm /o=rw → exclude entries where others have read or write
- `>` → redirect output to a file

👉 In find:

! <condition>

Means:

“exclude anything that matches this”

So:

! -perm /o=rw

👉 “NOT files where others have read OR write”

🧠 Now the REAL question (this is the important part)
Why /o=rw and NOT -o=rw?

👉 Because:

/ and - mean completely different things in -perm

📖 How you'd discover this (man thinking)
man find

Search:

/perm

You’ll see three modes:

⚙️  The 3 -perm Modes (THIS is the key)

#### Exact match
-perm mode

👉 permissions must match exactly

#### ALL bits must be set
-perm -mode

👉 “must include ALL these permissions”

Example:

-perm -g=w

👉 group must have write

3️⃣  ANY bit can match
-perm /mode

👉 “ANY of these bits are set”

Example:

-perm /o=rw

👉 others have read OR write (or both)

🧠 So what does YOUR command say?
First part:
-perm -g=w

👉 group has write ✅

Second part:
! -perm /o=rw

Break it down:

/o=rw → others have read OR write
! → NOT that

👉 So:

others have NO read AND NO write

🧠 Mental Model (LOCK THIS IN)
Symbol	Meaning
-	    ALL required
/	    ANY allowed
!	    NOT

⚡ Why NOT -o=rw?

Because:

-perm -o=rw

👉 means:

others must have BOTH read AND write

❌ That’s too strict

We want to catch:

read only
write only
read+write

👉 so we use:

/ (ANY)


⚡ Exam Pattern

If you see:

“must have” → use -
“any of these” → use /
“must NOT have” → use !
🔁 1-Line Recall Hook

 - = ALL, / = ANY, ! = NOT

🧨 Ultra-Clutch Insight (LFCS Gold)

Your condition:

group CAN write
others CANNOT read or write

👉 That translates to:

-perm -g=w ! -perm /o=rw

</details>

---

## 🧪 Task 4

Task: Find our secret file under /home/bob. You can either look for a file that is exactly 213 kilobytes or a file that has permission 402 in octal.

Save the name (including the parent directory path) of this file in the /home/bob/secfile.txt file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/secfile.txt

<details>
<summary>Answer</summary>

### Command
    find /home/bob -size 213k -o -perm 402 > /home/bob/secfile.txt

### Explanation
- -size 213k → exactly 213 KB
- -o → OR
- -perm 402 → exact permission match
- `>` → save output to file

🔥 1. “How does bash know it’s a file?”

👉 Short answer:

It doesn’t — find searches BOTH files and directories by default

🧠 Mental Model
find <path>

👉 means:

“walk this entire tree and check EVERYTHING”

That includes:

files ✅
directories ✅
symlinks ✅
⚠️ So why does this still work?

Because:

-size 213k

👉 applies meaningfully to files (directories usually won’t match this cleanly)

So effectively:

the condition filters down to the correct file

🧨 If you wanted ONLY files (explicitly):
find /home/bob -type f -size 213k

👉 -type f = file
👉 -type d = directory

🔥 2. What is -o REALLY?

This is the big confusion.

❌ It is NOT:
not “other”
not related to chmod
✅ In find, -o means:

logical OR

🧠 Mental Model
condition1 -o condition2

👉 means:

“match if EITHER is true”

So your command means:
-size 213k -o -perm 402

👉 find anything that is:

exactly 213 KB OR
has permission 402

⚙️ SIMP Breakdown

-size 213k → size = 213 kilobytes
-o → OR
-perm 402 → exact permission match
> → redirect output

⚠️ VERY IMPORTANT (LFCS GOTCHA)
Operator precedence

find evaluates left → right unless grouped

So this:

find /home/bob -size 213k -o -perm 402

is interpreted as:

( -size 213k ) OR ( -perm 402 )

🧨 Real-world issue

Without grouping, find may behave unexpectedly in more complex commands.

Safer version:

find /home/bob \( -size 213k -o -perm 402 \)

👉 \( and \) group conditions

🧠 Mental Model (LOCK THIS IN)

Concept 	Meaning
find /path	search EVERYTHING
-type f 	only files

-o	OR (logical)
chmod o	“others” (different context!)

⚡ Exam Pattern

If you see:

“either this OR that” → use -o
“only files” → use -type f
multiple conditions → consider grouping \( \)

🔁 1-Line Recall Hook

-o in find = OR (not “other”) — totally different from chmod

🧨 Bonus (Pro Operator Insight)

This confusion is intentional on LFCS:

chmod o+r → o = others
find -o → OR

👉 same letter… completely different meaning


</details>

---

## 🧪 Task 5

Task: In our lessons, we briefly mentioned the setuid, setgid, and sticky bit special permissions. Consider that setuid is short for set user id and setgid is short for set group id.

Add the permissions for setuid, setgid, and sticky bit on the /home/bob/datadir directory.

Do not use octal notation for this question.

<details>
<summary>Answer</summary>

### Command
    chmod u+s,g+s,o+t /home/bob/datadir

### Explanation
- u+s → setuid
- g+s → setgid
- o+t → sticky bit

## Special Permissions in Linux (setuid, setgid, sticky bit)

## What are `s` and `t`?

These are **special permission bits** (not normal `rwx` permissions).

| Symbol | Name     | Applies To |
|--------|----------|------------|
| s      | setuid   | user (u)   |
| s      | setgid   | group (g)  |
| t      | sticky   | others (o) |

---

## Why does `s` appear twice?

Because it depends on WHO you apply it to:

- `u+s` → setuid (user)
- `g+s` → setgid (group)

Same symbol, different target → different behavior.

---

## setuid (`u+s`)

### What it does
When a file is executed:
- it runs as the **file owner**, not the user executing it

### Example
    passwd

Runs as root even when executed by a normal user.

---

## setgid (`g+s`)

### On files
- runs with the **group’s permissions**

### On directories (LFCS IMPORTANT)
- new files inherit the **directory’s group**

### Example
    chmod g+s shared_dir

Any file created inside:
- automatically belongs to the same group as the directory

---

## sticky bit (`o+t`)

### What it does (directory use case)
- users can only delete **their own files**
- even if the directory is writable by everyone

### Example
    /tmp

- everyone can write
- BUT cannot delete other users’ files

---

## Why is sticky bit written as `o+t`?

Not because it applies to “others”.

It’s because the sticky bit lives in the **others execute position**.

---

## Permission Layout

    rwx rwx rwx
     u   g   o

Sticky bit replaces:
    others execute (x) → becomes t

---

## Example

    drwxrwxrwt

- `t` is in the others position
- indicates sticky bit is active

---

## Lowercase vs Uppercase

- `t` → execute bit is ON
- `T` → execute bit is OFF

---

## Mental Model

| Permission | Meaning |
|-----------|--------|
| setuid    | run as OWNER |
| setgid    | inherit GROUP |
| sticky    | protect FILE deletion |

---

## Exam Patterns

- “run as owner” → use `u+s`
- “shared group directory” → use `g+s`
- “prevent users deleting each other’s files” → use `o+t`

---

## 1-Line Recall

u+s = run as owner  
g+s = inherit group  
t   = protect deletes

</details>

---

## 🧪 Task 6

Task: Find the dogs.txt file under the /usr/share directory.

Save the location of the file in the /home/bob/dogs file.

<details>
<summary>Answer</summary>

### Command
    sudo find /usr/share -name dogs.txt > /home/bob/dogs

### Explanation
- -name dogs.txt → match exact filename
- `>` → save full path output to file

## Why `-name` Was Used in This Task

---

## Core Question
> “The task didn’t specify anything… so why use `-name`?”

---

## Short Answer

Because:

> `find` ALWAYS needs a condition — otherwise it returns EVERYTHING

---

## What Happens Without `-name`

    sudo find /usr/share

This would output:
- every file
- every directory
- every path

👉 Massive, noisy, useless for this task

---

## What `-name` Does

    -name dogs.txt

👉 Filters results to:
> only items with the exact name `dogs.txt`

---

## 🧠 Mental Model

    find = walk + filter

- walk → traverse the directory tree
- filter → apply conditions (`-name`, `-size`, `-perm`, etc.)

Without a filter:
> you’re just dumping the entire filesystem tree

---

## Why They Used `-name` Specifically

Even though the task was vague, the **intent** was:

> “Find a specific file named dogs.txt”

So:
- `-name` = the most direct and efficient filter
- avoids unnecessary output
- matches exact filename

---

👉 matches:
- dogs.txt only

NOT:
- dogs.txt.bak
- mydogs.txt

---

## Case Sensitivity

    -name      → case-sensitive  
    -iname     → case-insensitive  

Example:
    find /usr/share -iname dogs.txt

---

## ⚡ Exam Pattern

If you see:
- “find file named X” → use `-name`
- “not sure where it is” → use `find + -name`

---

## 🔁 1-Line Recall

    find = search everything → filter with -name

---

## 🧨 Operator Insight

Even if a task is vague:

👉 You choose the **most precise filter available**

Common ones:
- name → `-name`
- size → `-size`
- permissions → `-perm`
- type → `-type`

---

## Final Takeaway

`-name` is not optional here — it’s what makes `find` useful.

Without it:
> you’re not searching… you’re just listing everything

</details>

---

## 🧪 Task 7

Task: Find the cats.txt file under bob's home directory and copy it into the /opt directory.

<details>
<summary>Answer</summary>

### Command
    sudo find /home/bob -name cats.txt
    sudo cp /home/bob/.etc/h/e/r/cats.txt /opt/cats.txt

### Explanation
- find → locate the file first
- cp → copy the file into /opt
- /home/bob/.etc/h/e/r/cats.txt → example discovered full path from the lab

</details>

---

## 🧪 Task 8

Task: Find all directories named pets in the /var/ directory and save the output (along with directory path) in the/home/bob/pets.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/pets.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /var/ -type d -name pets > /home/bob/pets.txt

### Explanation
- -type d → directories only
- -name pets → match directories named pets
- `>` → save output to file

</details>

---

## 🧪 Task 9

Task: Find all the files whose permissions are 0777 in /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -perm 0777 -print

### Explanation
- -type f → files only
- -perm 0777 → exact permission match
- -print → display matching paths

---

## Core Question
> “Why is `-print` at the end? Isn’t it unnecessary?”

---

## 🔥 Short Answer

> `-print` explicitly tells `find` to OUTPUT the results

---

## 🧠 Important Truth (Modern vs Exam Thinking)

### In modern systems:
    -print is the DEFAULT

So this:
    find /var -type f -perm 0777

👉 already prints results

---

## 🤔 So why include `-print`?

### 1. 📖 Clarity (Teaching / Labs)
- Makes it obvious:
  > “this command outputs matches”

---

### 2. 🧠 Consistency (Operator Thinking)

`find` expressions are structured like:

    find <path> <conditions> <actions>

👉 `-print` is the **action**

---

### 3. ⚠️ VERY IMPORTANT (LFCS LEVEL)

When you start adding other actions:

- `-delete`
- `-exec`
- `-ls`

👉 `-print` is NOT automatic anymore in the same way

---

## 🧪 Example (Why it matters)

    find /var -type f -perm 0777 -delete

👉 deletes files  
👉 prints nothing

---

### If you want BOTH:
    find /var -type f -perm 0777 -print -delete

---

## 🧠 Mental Model

| Part        | Meaning |
|------------|--------|
| conditions | filter results |
| actions    | what to DO with results |

👉 `-print` = “show me the result”

---

## ⚙️ SIMP Breakdown

- `-type f` → files only  
- `-perm 0777` → exact permissions  
- `-print` → display matches  

---

## ⚡ Exam Pattern

If you see:
- basic find → `-print` optional  
- advanced find → `-print` becomes important  

---

## 🔁 1-Line Recall

    -print = output the matches (explicit action)

---

## 🧨 Operator Insight

Think like this:

    find = logic engine

- conditions → decide WHAT matches  
- actions → decide WHAT happens  

👉 `-print` is the default action… but making it explicit = safer + clearer

---

## Final Takeaway

`-print` is not required here…

…but it shows:
> you understand how `find` actually works internally


</details>

---

## 🧪 Task 10

Task: Find all the files whose permissions are 0640 in /usr/ directory and save the output (along with parent path) in /home/bob/.opt/permissions.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/.opt/permissions.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -perm 0640 > /home/bob/.opt/permissions.txt

### Explanation
- -type f → files only
- -perm 0640 → exact permission match
- `>` → redirect output to file

</details>

---

## 🧪 Task 11

Task: Find all the files which have been modified in the last 2 hours in /usr directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -mmin -120

### Explanation
- -type f → files only
- -mmin -120 → modified within the last 120 minutes

</details>

---

## 🧪 Task 12
Task: Find all the files which have been modified in the last 30 minutes in the /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -mmin -30 | wc -l

### Explanation
- -type f → files only
- -mmin -30 → modified within the last 30 minutes
- `|` → send output from one command into the next
- wc -l → count matching lines

## Why `| wc -l` Was Added

---

## 🧠 Read the Task CAREFULLY

> “How many such files did you find?”

👉 That changes EVERYTHING.

---

## 🔥 Without `wc -l`

    sudo find /var -type f -mmin -30

👉 Output:
- list of matching files (paths)
- could be dozens or hundreds

❌ But does NOT answer:
> “How many?”

---

## 🔥 What `| wc -l` Does

### Breakdown

- `|` → pipe (send output to another command)
- `wc` → word count
- `-l` → count lines

---

## 🧠 Mental Model

    find → produces a list (one file per line)
    wc -l → counts lines

👉 So:

> number of lines = number of files

---

## ⚙️ SIMP Breakdown

    find /var -type f -mmin -30
        → find files modified in last 30 minutes

    | wc -l
        → count how many results

---

## 🧪 Example

### Without pipe
    /var/log/a.log
    /var/log/b.log
    /var/tmp/c.tmp

### With pipe
    3

---

## 🔍 How You’d Discover This (man thinking)

### For `find`
    man find
    /mmin

→ shows:
> `-mmin n` → modified n minutes ago

---

### For `wc`
    man wc
    /-l

→ shows:
> `-l` → print newline counts

---

## ⚡ Exam Pattern

If you see:
- “how many files…”  
- “count the number of…”  

👉 ALWAYS think:
    | wc -l

---

## ⚠️ LFCS Trap

People often stop at:
    find ...

❌ That only lists  
✅ You must COUNT if asked

---

## 🧠 Mental Model (LOCK THIS IN)

    find = generate results
    wc -l = count results

---

## 🔁 1-Line Recall

    “If they ask HOW MANY → pipe to wc -l”

---

## 🧨 Operator Insight

This is a **composition pattern**:

    command → pipe → summary

Examples:
    find ... | wc -l        → count
    find ... | sort         → organize
    find ... | grep         → filter further

---

## Final Takeaway

`| wc -l` was added because:

> the task didn’t ask for the files…  
> it asked for the COUNT of the files

</details>

---

## 🧪 Task 13

Task: Find all the files with size 20MB in /var directory.

How many such files did you find?

<details>
<summary>Answer</summary>

### Command
    sudo find /var -type f -size 20M | wc -l

### Explanation
- -type f → files only
- -size 20M → exactly 20 MB
- send the output from one command into the next
- wc -l - count matching lines

</details>

---

## 🧪 Task 14

Task: Find all files between 5MB and 10MB in the /usr directory and save the output (along with parent path) in the/home/bob/size.txt file.

You should be able to save the output in a file using redirection: <your-command> > /home/bob/size.txt

<details>
<summary>Answer</summary>

### Command
    sudo find /usr -type f -size +5M -size -10M > /home/bob/size.txt

### Explanation
- -type f → files only
- -size +5M → larger than 5 MB
- -size -10M → smaller than 10 MB
- `>` → save output to file

Understanding `-size +5M -size -10M` (Range Filtering in `find`)

---

## 🧠 Core Question
> Why `+5M` and `-10M`?  
> Is there a more intuitive way?

---

## 🔥 What `+` and `-` Mean in `-size`

| Syntax     | Meaning                  |
|------------|--------------------------|
| `-size 5M` | exactly 5 MB             |
| `-size +5M`| greater than 5 MB        |
| `-size -5M`| less than 5 MB           |

---

## 🧠 Mental Model

Think:

- `+` → bigger than  
- `-` → smaller than  

👉 NOT math signs… just **range indicators**

---

## 🔍 So This Command Means

    -size +5M   → greater than 5 MB  
    -size -10M  → less than 10 MB  

Together:

> files BETWEEN 5 MB and 10 MB

---

## ⚠️ Important Detail

This is an **AND condition**

    find /usr -type f -size +5M -size -10M

👉 means:
> must satisfy BOTH conditions

---

## 🧠 Mental Model (LOCK THIS IN)

    lower bound → +  
    upper bound → -

So:

    between A and B = +A AND -B

---

## ⚡ Why This Feels Confusing

Because:

- `+` looks like “add”
- `-` looks like “subtract”

👉 but here they mean:
- `+` → ABOVE
- `-` → BELOW

---

## 🔁 1-Line Recall

    + = bigger than  
    - = smaller than  

---

## 🤔 Is There a More Intuitive Way?

### ❌ No direct "range" syntax exists in `find`

You MUST combine conditions like this.

---

## ✅ Slightly More Readable Version (Grouped)

    sudo find /usr -type f \( -size +5M -a -size -10M \) > /home/bob/size.txt

---

### What changed?

- `\(` `\)` → grouping  
- `-a` → AND (explicit)

---

## 🧠 Why This Helps

Makes it clearer:

    ( bigger than 5M ) AND ( smaller than 10M )

---

## ⚙️ SIMP Breakdown

- `-type f` → files only  
- `-size +5M` → > 5 MB  
- `-size -10M` → < 10 MB  
- `>` → redirect output  

---

## ⚡ Exam Pattern

If you see:
- “between X and Y”

👉 translate to:

    -size +X -size -Y

---

## 🧨 Operator Insight

This pattern applies to multiple `find` options:

- `-mtime`
- `-mmin`
- `-size`

👉 same logic:
    + = older/larger  
    - = newer/smaller  

---

## Final Takeaway

The command is correct:

    -size +5M -size -10M

👉 It means:
> greater than 5 MB AND less than 10 MB

There is no simpler syntax — just remember:

    + = above  
    - = below


## Why the `\` Is BEFORE the `)` (Not After)

## Expression
    \( -size +5M -a -size -10M \)

---

## 🧠 Core Question
> Why is the backslash BEFORE `)` and not after?

---

## 🔥 Short Answer

> The `\` escapes the character that comes AFTER it

So:

- `\(` → escape `(`
- `\)` → escape `)`

---

## 🧠 What “escape” means

In Bash:

- `(` and `)` have special meaning (subshell/grouping in shell)
- So Bash tries to interpret them BEFORE `find` sees them

👉 We must “escape” them so they are passed literally to `find`

---

## 🔍 What happens WITHOUT escaping

    find /usr ( -size +5M -a -size -10M )

👉 Bash interprets:
- `(` `)` as shell grouping
- NOT as part of the `find` command

❌ This breaks the command

---

## ✅ Correct version

    find /usr \( -size +5M -a -size -10M \)

👉 Now Bash says:
> “treat these parentheses as literal characters”

👉 and passes them to `find`

---

## 🧠 Mental Model

    \ = “treat the next character literally”

---

## 🔁 1-Line Recall

    backslash ALWAYS goes BEFORE the thing you want to escape

---

## 🧨 Operator Insight

This applies everywhere in Bash:

- `\(` → escape parentheses  
- `\*` → escape wildcard  
- `\$` → escape variable  

👉 Always:
    \ + character

---

## Final Takeaway

> `\` escapes the character that follows it — not the one before

---

</details>

## 🧪 Task 15

Task: Create a directory named LFCS under bob's home directory and update its user owner permissions to only x (execute), and group and others should not have any permissions.

It should give us a permission denied error while listing the contents of the directory.

<details>
<summary>Answer</summary>
    sudo mkdir /home/bob/LFCS
    sudo chmod 0100 /home/bob/LFCS

### Explanation
- mkdir → create directory
- chmod 0100 → owner gets execute only
- no read permission → listing contents fails with permission denied

## Why `chmod 0100` Works (and Why They Didn’t Use `u g o`)

## 🧠 Core Question
> Why is this so simple?  
> Why not use `u g o` (symbolic mode)?

---

## 🔥 Short Answer

> They used **octal mode** (`0100`) instead of symbolic mode (`u+x,go-`)

Both are VALID. Octal is just more compact.

---

## 🧠 What Does `0100` Mean?

Permissions are written as:

    u g o
    1 0 0

Each digit represents:

| Value | Meaning |
|------|--------|
| 4    | read (r) |
| 2    | write (w) |
| 1    | execute (x) |

---

## 🔍 So:

    1 → execute only  
    0 → no permissions  

👉 Therefore:

    0100 = user: execute only
           group: none
           others: none

---

## 🧠 Mental Model

    chmod XYZ

- X → user
- Y → group
- Z → others

---

## ⚙️ Equivalent Symbolic Command

This:

    chmod 0100 /home/bob/LFCS

is EXACTLY the same as:

    chmod u=x,go= /home/bob/LFCS

---

## 🔥 Why Didn’t They Use `u g o`?

### 1. Octal is faster
- shorter
- commonly used in scripts and exams

---

### 2. Exact control

- sets ALL permissions at once
- no ambiguity

---

### 3. LFCS expects you to know both

You may see:
- symbolic → `u+x`
- octal → `0755`

👉 You must understand BOTH

---

## ⚠️ Important Behavior (THIS is the point of the task)

Directory permissions behave differently than files.

---

## 🧠 What Does `execute` Mean on a Directory?

For directories:

| Permission | Meaning |
|-----------|--------|
| r         | list contents |
| w         | create/delete files |
| x         | enter/traverse |

---

## 🔍 So with `0100`:

- user CAN enter the directory (`cd`)
- user CANNOT list contents (`ls` ❌)

---

## 🧪 Result

    cd /home/bob/LFCS      → works
    ls /home/bob/LFCS      → Permission denied

---

## 🧠 Mental Model (LOCK THIS IN)

> Directory execute = “you can go in”  
> Directory read = “you can see inside”

---

## ⚡ Exam Pattern

If you see:
- “can enter but not list” → `x only`
- “no access for group/others” → `0`

👉 Think:
    0100

---

## 🔁 1-Line Recall

    0100 = user can enter, nobody can see

---

## 🧨 Operator Insight

Symbolic:
    chmod u=x,go=

Octal:
    chmod 0100

👉 Same result — octal is just faster and cleaner

---

## Final Takeaway

They used `0100` because:

> it’s the fastest way to say:
> user = execute only, group/others = nothing

And the task is really testing:

> Do you understand how directory permissions actually behave?

## Yes — `go=` Means “Set to NOTHING”

## Command
    chmod u=x,go= /home/bob/LFCS

---

## 🧠 Core Question
> “Is there really nothing after `go=`?”

👉 YES — and that is intentional.

---

## 🔥 What `=` Means in chmod

In symbolic mode:

| Operator | Meaning |
|----------|--------|
| `+`      | add permission |
| `-`      | remove permission |
| `=`      | set EXACT permissions |

---

## 🧠 So What Does This Do?

    go=

👉 Means:
> set group and others permissions to EXACTLY nothing

---

## 🔍 Equivalent Thinking

    go=

is the same as:
    g= , o=

👉 both become:
> no permissions at all

---

## ⚙️ Full Breakdown

    u=x
    → user gets execute only

    go=
    → group = nothing  
    → others = nothing  

---

## 🧪 Resulting Permissions

    --- --- ---

But for user:
    --x------

---

## 🧠 Mental Model

Think:

    = → “wipe and replace”

So:

    go=

👉 “wipe everything for group and others”

---

## ⚠️ Common Confusion

People expect:
    go=---   ❌ (not how chmod works)

Instead:
    go=      ✅ (empty means none)

---

## ⚡ Equivalent Octal

    chmod 0100

---

## 🔁 1-Line Recall

    go= = give group and others NOTHING

---

## 🧨 Operator Insight

Symbolic mode lets you:

- add → `+`
- remove → `-`
- replace → `=`

👉 `=` with nothing = **total reset to zero**

---

## Final Takeaway

Yes — nothing after `go=` is correct.

It means:
> group and others get ZERO permissions


</details>

---

## 🧪 Task 16

Task: Update the permissions for some_directory to rwxr-xr-x

<details>
<summary>Answer</summary>

command
    chmod 0755 some_directory/

### Explanation
- 7 → rwx for owner
- 5 → r-x for group
- 5 → r-x for others

## Why Is There a Leading `0` in `0755`?

---

## 🧠 Core Question
> Why `0755` instead of `755`?

---

## 🔥 Short Answer

> The leading `0` tells the system:
> “this is an OCTAL (base-8) number”

---

## 🧠 What Is Octal?

Octal = base 8 → digits go from **0–7**

Permissions use octal because:
- each digit maps cleanly to `rwx`

---

## 🔍 Permission Breakdown

    0755

Split into:

    0 | 7 | 5 | 5
      u   g   o

---

## 🔥 What Each Digit Means

| Number | Meaning |
|--------|--------|
| 7      | rwx (4+2+1) |
| 5      | r-x (4+0+1) |
| 5      | r-x (4+0+1) |

---

## 🧠 So What Is the Leading `0`?

    0 → special permission bits (setuid, setgid, sticky)

---

## ⚠️ Important

If the first digit is:

| Value | Meaning |
|-------|--------|
| 0     | no special bits |
| 1     | sticky bit |
| 2     | setgid |
| 4     | setuid |

---

## 🧠 Mental Model

    chmod ABCD

- A → special bits  
- B → user  
- C → group  
- D → others  

---

## 🧪 Example

    chmod 1755 file

👉 `1` = sticky bit set

---

## ⚡ So Why Include the `0`?

### 1. Explicit clarity
- shows full 4-digit structure

---

### 2. Consistency
- same format whether special bits exist or not

---

### 3. Exam readiness
- LFCS expects awareness of special bits

---

## ⚠️ Can You Omit It?

Yes:

    chmod 755 some_directory/

👉 works the same as `0755`

---

## 🧠 But Best Practice

Use:

    0755

👉 makes structure explicit:
    [special][user][group][others]

---

## 🔁 1-Line Recall

    leading 0 = “no special bits, but slot is reserved”

---

## 🧨 Operator Insight

Think:

    0755 → standard permissions  
    4755 → setuid  
    2755 → setgid  
    1755 → sticky  

---

## Final Takeaway

The leading `0` is:

> a placeholder for special permissions (setuid, setgid, sticky)

Even when unused, it keeps the format complete and predictable

---

</details>
