# 🧪 Shell Execution, Redirection, Pipelines, and Job Control

**Path:** `linux/LFCS-training/execution-drills/shell-execution-and-redirection.md`

Mental mode: **Pure mechanics, speed, correctness**  
Purpose: Eliminate **all hesitation and all mistakes** around:

- exit codes
- chaining (`&&`, `||`)
- redirection (`>`, `>>`, `2>`, `2>&1`, `&>`)
- pipelines
- grouping
- `tee`
- job control

If you are weak here, **everything else in Linux becomes slow and dangerous**

This is a **muscle-memory drill pack**

---

## 🧱 Drill Framework (How to Use This File)

Drill types used here:

- **A: Atomic** — one skill, repeat until automatic
- **B: Timed** — same skill under time pressure
- **C: Failure Injection** — intentionally break something; recover fast
- **D: Diagnosis** — interpret output/exit codes, choose correct meaning
- **E: Composition** — chain multiple primitives together (exam style)

Rules:

- Type everything. No copy/paste
- Always verify output and files
- Prefer idempotent actions (test -d /backup || mkdir /backup)
    Idempotent = you can run it multiple times and the final state is the same as running it once
- Always know whether you are writing with `>` or `>>`
- Always be conscious of `2>&1` ordering
- Keep a scratch directory

---

## 🧪 Setup (Do Once Per Session)

    mkdir -p ~/lfcs-labs/execution-drills/shell
    cd ~/lfcs-labs/execution-drills/shell
    rm -f out.txt err.txt all.txt report.txt input.txt file.txt important.txt
    rm -rf data

### 🧠 Why Is mkdir & rm At The Beginning to type everytime you run this lab?

This makes the lab idempotent and reproducible “No matter what you did last session, start clean”


Create a reproducible input file:

    cat > input.txt <<EOF
    alpha
    beta
    gamma
    beta
    delta
    EOF

What’s happening:

 <<EOF tells the shell:
“Take everything until EOF and feed it into cat.”

 > tells the shell:
“Write cat’s output into input.txt.”

Again:

cat processes the input

 > creates or overwrites the file
 >> this appends instead

---

# A) Atomic Drills (Repetition Until Automatic)

## A1 — Exit codes

Goal: Read success/failure immediately.

    true
    echo $?
    false
    echo $?

Target: 10 reps, no hesitation.

---

## A2 — Safe chaining with && and ||

    mkdir -p a2 && echo "mkdir ok" || echo "mkdir failed"
    test -f /etc/passwd && echo "exists" || echo "missing"
    test -f /nope && echo "exists" || echo "missing"

Target: 10 reps.

---

## A3 — Redirect STDOUT overwrite vs append

    echo "one" > out.txt
    echo "two" >> out.txt
    cat out.txt

Target: 10 reps. Always inspect the file.

---

## A4 — Redirect STDERR only

    ls /no/such/path 2> err.txt
    cat err.txt

Target: 10 reps.

---

## A5 — Redirect both: classic vs modern

Classic:

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Modern:

    ls /no/such/path &> all.txt
    cat all.txt

Target: 10 reps each.

---

## A6 — /dev/null patterns

    ls /no/such/path 2> /dev/null
    ls /etc > /dev/null
    ls /no/such/path &> /dev/null

Target: 10 reps.

---

## A7 — tee: view + save

    dmesg | head -n 5 | tee out.txt
    cat out.txt

Append:

    echo "append-test" | tee -a out.txt
    tail -n 3 out.txt

Target: 10 reps.

---

## A8 — Pipes (simple)

    cat input.txt | wc -l
    cat input.txt | grep -c beta

Target: 10 reps.

# 🔗 The Pipe |

The pipe means:

“Take the output of the command on the left and feed it as input to the command on the right.”

So:

 command1 | command2


means:

 stdout of command1 → stdin of command2

1️⃣
 cat input.txt | wc -l

#### Step-by-step

 cat input.txt
→ prints the contents of the file

 |
→ send that output to the next command

 wc -l
→ count lines

 wc = word count
 -l = lines

#### Result

It printed:

 5

That means:

There are 5 lines in input.txt

#### 🧠 Simpler Version

You actually don’t need cat

You could just do:

 wc -l input.txt


Same result ... using cat here is just for pipe practice

2️⃣
 cat input.txt | grep -c beta

Step-by-step

 cat input.txt
→ print file

 |
→ send into grep

 grep -c beta
→ search for lines containing “beta”
→ -c = count matches

So instead of printing the matching lines,
it prints how many lines matched.

Result
 2


That means:

The word beta appears on 2 lines in the file

#### 🧠 Ultra Simple Mental Model

 cat file | wc -l

 = count total lines


 cat file | grep -c word

= count lines containing word


#### 🔥 Slightly Cleaner Way (Operator Tip)

You don’t need cat here either

Better style:

 grep -c beta input.txt


And:

 wc -l input.txt


Pipes are useful when chaining commands, but not required here

### 🎯 Why This Matters for LFCS

This trains:

 Pipes

 Stream thinking

 Counting output

 Filtering text

 Understanding -c

 Understanding -l

These are core exam skills

---

## A9 — Here-doc file creation

    cat > file.txt <<EOF
    line1
    line2
    EOF

Verify:

    cat file.txt

Target: 10 reps

---

## A10 — Grouping for redirection

    { date; uptime; echo "OK"; } > report.txt
    cat report.txt

Target: 10 reps.

---

# B) Timed Drills (Speed)

## B1 — “Capture everything” in 15 seconds

    ls /no/such/path > all.txt 2>&1
    cat all.txt

Pass condition: ordering must be correct (`> all.txt 2>&1`)

---

## B2 — 3-command pipeline in 20 seconds

    cat input.txt | sort | uniq -c

Pass condition: correct output, no stumbles

#### 🔗 The Command
 cat input.txt | sort | uniq -c


Think of it as a 3-stage assembly line

#### 🧱 Stage 1 — cat input.txt

Prints the file contents

Your file probably looks like:

 alpha
 beta
 gamma
 beta
 delta


That stream of lines now flows to the next command.

#### 🧱 Stage 2 — sort

 sort rearranges lines alphabetically

So now the stream becomes:

 alpha
 beta
 beta
 delta
 gamma


Important:

 sort puts identical lines next to each other

That’s critical for what comes next

#### 🧱 Stage 3 — uniq -c

 uniq removes duplicate adjacent lines

But only adjacent ones

 -c means:

 Count how many times each line appears

So since duplicates are now grouped together (because of sort), uniq -c can count them

#### 🔍 Why Output Looks Like This
      1 alpha
      2 beta
      1 delta
      1 gamma


That means:

 alpha appears 1 time

 beta appears 2 times

 delta appears 1 time

 gamma appears 1 time

#### 🧠 Critical Rule

 uniq only works properly if duplicates are adjacent

 That’s why sort comes before uniq

If you ran:

 cat input.txt | uniq -c


##### You’d get wrong counts because the two beta lines weren’t next to each other

### 🎯 Ultra Simple Mental Model

 sort | uniq -c

= Count frequency of each unique line


#### 🔥 Even Cleaner Version

You don’t need cat here either

Better style:

 sort input.txt | uniq -c

#### 🏁 Final Lock-In

Pipeline logic:

 Print file

 Sort it

 Count adjacent duplicates

This is Unix composability at its best

---

## B3 — Find + sort + head in 30 seconds

Setup:

    mkdir -p data
    dd if=/dev/zero of=data/a bs=1K count=10 status=none
    dd if=/dev/zero of=data/b bs=1K count=50 status=none
    dd if=/dev/zero of=data/c bs=1K count=20 status=none

Find biggest:

    find data -type f -exec du -h {} + | sort -rh | head -n 1

Pass condition: file `b` is largest

### 🎯 What This Drill Is Testing

You must be able to:

 Create test data

 Inspect file sizes

 Sort results

 Extract the top result

 Do it quickly (≤ 30 seconds)

This is exam muscle memory

### 🧱 Setup Section (What It Creates)

 mkdir -p data


Create a directory named data

These create files of different sizes:

 dd if=/dev/zero of=data/a bs=1K count=10 status=none


Breakdown:

 dd = low-level copy tool

 if=/dev/zero = input file is zeros

 of=data/a = output file is data/a

 bs=1K = block size = 1 kilobyte

 count=10 = write 10 blocks

 status=none = suppress progress output

#### Result:

 a = 10 KB

Next:

 dd ... count=50


 b = 50 KB

Next:

 dd ... count=20


 c = 20 KB

So now your directory looks like:

 data/
  a (10K)
  b (50K)
  c (20K)

#### 🔍 The Task: Find the Largest File

 find data -type f -exec du -h {} + | sort -rh | head -n 1


This is the real exercise

🔹 Step 1 — find

 find data -type f


Find all regular files inside data

🔹 Step 2 — -exec du -h {} +

For each file found:

 du -h filename


 du = disk usage

 -h = human-readable

 {} = placeholder for file

 + = batch mode (efficient)

So output looks like:

 10K data/a
 50K data/b
 20K data/c

🔹 Step 3 — sort -rh

 -r = reverse (largest first)

 -h = human-readable sort (understands K, M, G)

This sorts by size, biggest first:

 50K data/b
 20K data/c
 10K data/a

🔹 Step 4 — head -n 1

Show only the first line

Result:

 50K data/b

#### 🏁 Pass Condition

You correctly identify:

 data/b


as the largest file

#### 🧠 What This Drill Builds

You are chaining:

 find

 du

 sort

 head

That is 4 primitives combined

That is exactly how LFCS questions are structured

#### 🔐 Operator Mental Model

When asked:

“Find the largest file in this directory tree”

Your brain should instantly go:

#### find → du → sort -rh → head

Automatic

#### ⚡ Faster Version (Pro Tip)

You could also do:

 du -h data/* | sort -rh | head -n 1


But the drill forces you to practice find -exec

#### 🎯 Why This Is a B-Level Drill

Because it requires:

 File discovery

 Size calculation

 Correct numeric sorting

 Output filtering

 Time constraint

No memorization
Just composability

---

# C) Failure Injection Drills (Break & Recover)

## C1 — Misordered redirection

#### Wrong Order (Break it):

    ls /no/such/path 2>&1 > all.txt

Explain to yourself why it is wrong

#### Correct Order (Fix it):

    ls /no/such/path > all.txt 2>&1

Rule you must be able to say out loud:

- `2>&1` copies STDERR to wherever STDOUT is pointing **at that moment**

 🔁 What 2>&1 means (this is the confusing part)

 2>&1 does NOT mean “background” here

It means:

 “Make stderr (2) go to the same place as stdout (1)”

Break down the symbols

 2> = “redirect stderr”

 &1 = “to file descriptor 1 (stdout)”

 2>&1
means:

“Redirect stderr to wherever stdout is currently going”

### Important: the & here
The & in 2>&1 means:

“This is a file descriptor destination (not a filename)”

Without &, the shell would treat 1 as a literal filename

 2>1 → redirect stderr into a file literally named 1

 2>&1 → redirect stderr to stdout stream

#### 🧠 The one rule to memorize

 2>&1 copies stderr to wherever stdout is pointing at that moment

That’s the whole drill

### 🧱 The 3 numbered streams (0, 1, 2)

Every command runs with three standard channels (file descriptors):

 0 = stdin (input to the program)
Usually your keyboard, or piped/redirected input

 1 = stdout (normal output)
“Regular results” the command produces

 2 = stderr (error output)
“Error messages” the command produces

## 🧩 Bonus: &> /dev/null vs background &

These are two totally different & uses:

1) Background & (job control)

 sleep 10 &

Runs in background

2) &> (bash redirection shorthand)

 ls /no/such/path &> all.txt


Means:

 redirect stdout and stderr to the same file

Equivalent to:

 ls /no/such/path > all.txt 2>&1


So:

command & = background

 &> = redirect both outputs

### 🏁 Tiny cheat sheet

> or 1> = redirect stdout

2> = redirect stderr

2>&1 = redirect stderr to wherever stdout currently points

&> = redirect both stdout and stderr (bash shortcut)

& at end = run command in background

---

## C2 — Accidental clobber prevention

Simulate risk:

    echo "DO NOT LOSE THIS" > important.txt

Destroy it:

    echo "oops" > important.txt

Recover:

    echo "DO NOT LOSE THIS" > important.txt
    cat important.txt

Pass condition: you feel the danger and never forget it

### 🏁 Lock This In

> = overwrite
>> = append

Overwrite is destructive

---

# D) Diagnosis Drills (Interpret Output + Exit Codes)

## D1 — Pipeline vs grep exit code

    cat input.txt | grep zzz
    echo $?

    cat input.txt | grep beta
    echo $?

Pass condition: you can explain the difference between:
- “no matches”
- “command failure”

### 🧪 First Command

 cat input.txt | grep zzz


What happens?

 grep searches for zzz

It finds nothing

So it prints nothing

Then you run:

 echo $?


It prints:

1

### 🧠 What Does 1 Mean Here?

For grep specifically:

Exit Code	Meaning
 0	       Match found
 1     	No match found
 2  	Actual error

So:

1 does NOT mean something broke

It means:

The search ran successfully, but nothing matched

That’s normal

🧪 Second Command
cat input.txt | grep beta


It prints:

 beta
 beta


Then:

 echo $?


Prints:

 0


That means:

The command succeeded and found matches

### 🔥 The Key Difference

#### Case 1 — No Matches

No output

 Exit code = 1

Not an error

Just “nothing found”

#### Case 2 — Real Failure

Example:

 grep beta nofile.txt


That would produce:

 grep: nofile.txt: No such file or directory


And:

 echo $?


Would print:

 2

---

## D2 — Job control muscle memory

    sleep 3000 &

    jobs

Bring to foreground:

    fg %1

Suspend with Ctrl+Z.

Background again:

    bg %1

Kill safely:

    jobs
    kill %1

Pass condition: no confusion between PID and job spec

### 🔎 What %1 Means

The % tells the shell:

“This is a job number, not a PID.”


 ro6ert@ro6bx:~/lfcs-labs$ sleep 3000 &
 [1] 64778
 Job #[1] | PID: 64778

---

# E) Composition Drills (Exam Style)

## E1 — “Live filter + capture”

    (ls /no/such/path; ls /etc) 2>&1 | tee all.txt | grep -i "no such"

Pass condition:
- You see filtered output
- `all.txt` contains full output


#### 🧱 Step 1 — The Parentheses ( ... )

 (ls /no/such/path; ls /etc)


This groups the commands together so they behave like one unit

Inside:

 ls /no/such/path
 ls /etc


The ; means:

Run the first command, then run the second one regardless of success/failure

So:

First command → produces an error

Second command → lists /etc

#### 🧱 Step 2 — 2>&1
 (...) 2>&1


This means:

Send stderr (2) to wherever stdout (1) is currently going

At this point, stdout is still the pipe

So both:

 normal output

 error output

now go into the pipe

Without 2>&1, the error would bypass the pipe and go straight to your screen

#### 🧱 Step 3 — | tee all.txt

tee does two things:

 Writes everything it receives into all.txt

 Passes the same data forward down the pipe

So now:

 Full combined output goes into all.txt

 Same full output continues to grep

#### 🧱 Step 4 — | grep -i "no such"

 grep filters the stream

 -i = ignore case

 "no such" = search phrase

So only lines containing “no such” survive

That’s why you saw:

 ls: cannot access '/no/such/path': No such file or directory


You did NOT see the huge /etc listing because grep filtered it out

#### 🎯 Why This Drill Works

Pass condition 1:

 You see filtered output

 Yes — you saw only the error line

Pass condition 2:

 all.txt contains full output


### 🧠 What This Drill Teaches

It teaches a powerful pattern:

 group commands
 combine stdout + stderr
 capture everything
 filter live


This is real-world admin work

### 🧩 Mental Model

 (grouped commands)
      ↓
 combine outputs
      ↓
 tee (save copy + forward)
      ↓
 filter for display

#### 🏁 Ultra Simple Summary

 Parentheses group commands

 ; runs both

 2>&1 combines error + normal output

 tee saves everything

 grep filters what you see

---

## E2 — “Report generator”

    {
      echo "=== DATE ==="
      date
      echo
      echo "=== UPTIME ==="
      uptime
      echo
      echo "=== TOP 5 PROCESSES BY MEM ==="
      ps aux --sort=-%mem | head -n 6
    } > report.txt

Pass condition:
- File is readable
- You can regenerate it from memory

### 🎯 What This Drill Is

You are generating a structured report file using only shell primitives

This is:

 grouping { }

 redirection >

 basic system inspection commands

 formatting with echo

It simulates something you’d absolutely do in production

#### 🧱 Step 1 — The Curly Braces { }

These group commands together

Everything inside behaves like one block

Important detail:
There must be a space after { and before }
And no pipe between them — just grouping

#### 🧱 Step 2 — The > report.txt

The redirection happens once, after the group

That means:

 Everything produced inside the block goes into report.txt

 Not just one command
 The entire grouped output

#### 🧱 Step 3 — What Each Section Does

##### Section 1 — Date

 echo "=== DATE ==="
 date

Adds a header, then prints current date/time

##### Section 2 — Uptime

 echo "=== UPTIME ==="
 uptime

Shows how long system has been running + load averages

##### Section 3 — Top Processes by Memory

 ps aux --sort=-%mem | head -n 6

Breakdown:

 ps aux

 a = all users

 u = user format

 x = include background processes

 --sort=-%mem

 Sort by memory usage

 - means descending (largest first)

 head -n 6

 Show first 6 lines

 That includes header line + top 5 processes

#### 📄 What report.txt Will Look Like

Something like:

 === DATE ===
 Mon Jan 27 10:00:00 EST 2026

 === UPTIME ===
 10:00:00 up 2 days,  4:32,  2 users,  load average: 0.10, 0.15, 0.12

 === TOP 5 PROCESSES BY MEM ===
 USER   PID %CPU %MEM ...
 root   123  1.0  5.0 ...
 ...

Clean
Readable
Structured

#### 🎯 Why This Is Exam Style

It tests:

 Grouping commands

 One-time redirection

 Structured output formatting

 Process inspection

 Sorting

 Piping

 Memory awareness

This is composition mastery

#### 🧠 Operator Mental Model

If asked:

 “Generate a system report containing date, uptime, and top memory consumers”

Your brain should think:

 { echo headers; run commands; } > file

#### 🏁 Pass Condition Explained

“File is readable”

Open it:

 cat report.txt

It should be organized and structured

“You can regenerate it from memory”

That means:

You understand:

 Why { } are used

 Why > is outside

 Why head -n 6

 Why --sort=-%mem

Not memorizing
Understanding

#### 🔐 Key Mental Lock-In

 Grouped commands + single redirection = report generator pattern

---

# ✅ Completion Criteria (Gate)

You are done with this file when **all** of the following are true:

- You never hesitate on:
  - `>`, `>>`, `2>`, `2>&1`, `&>`
- You never mis-order redirection
- You use `tee` naturally
- You can build 3–5 command pipelines without trial-and-error
- You can use grouping `{ ...; }` for redirection
- You are fluent with:
  - `&`, `jobs`, `fg`, `bg`, Ctrl+Z, `kill %job`
- You can build:

    find | du | sort | head

…without thinking

---

## 🧠 Operator Rule (Carry Forward Everywhere)

> **If you do not control redirection and pipelines perfectly, you do not control Linux**

This file is **non-negotiable foundation**

