# 🧪 Shell Execution, Redirection, Pipelines, and Job Control — Execution Drill (Questions Only)

Mental mode: **Pure mechanics, speed, correctness**

---

# A) Atomic Drills (Repetition Until Automatic)

## A1 — Exit codes

1. Run a command that succeeds
2. Immediately print its exit code
3. Run a command that fails
4. Immediately print its exit code

Repeat until exit code meaning is instant and automatic

---

## A2 — Safe chaining with && and ||

1. Create a directory only if it does not fail, and print a success message
2. Test for existence of a known file and print appropriate message
3. Test for existence of a nonexistent file and print appropriate message

Repeat until chaining logic is automatic

---

## A3 — Redirect STDOUT overwrite vs append

1. Write text to a file using overwrite
2. Append additional text to the same file
3. Display the file contents

Repeat until you never confuse `>` and `>>`

---

## A4 — Redirect STDERR only

1. Trigger an error from a command
2. Redirect only STDERR to a file
3. Display the error file

Repeat until `2>` is automatic

---

## A5 — Redirect both STDOUT and STDERR

1. Capture both normal output and errors using classic redirection syntax
2. Display the file
3. Repeat using modern Bash shorthand
4. Display the file

Repeat until both forms are natural

---

## A6 — /dev/null patterns

1. Suppress only STDERR
2. Suppress only STDOUT
3. Suppress both STDOUT and STDERR

Repeat until suppression patterns are automatic

---

## A7 — tee: view + save

1. Pipe command output through `tee` to both display and save
2. Confirm file contents
3. Append to the file using `tee -a`
4. Confirm appended contents

Repeat until tee feels natural

---

## A8 — Pipes (simple)

1. Count total lines in a file using a pipeline
2. Count matching lines in a file using a pipeline

Repeat until pipe direction is instinctive

---

## A9 — Here-doc file creation

1. Create a file using a here-document
2. Verify the file contents

Repeat until here-doc creation is fluent

---

## A10 — Grouping for redirection

1. Group multiple commands
2. Redirect their combined output to a file
3. Display the file

Repeat until grouping with redirection is automatic

---

# B) Timed Drills (Speed)

## B1 — Capture everything in 15 seconds

1. Run a command that produces an error
2. Capture both STDOUT and STDERR into a file using correct ordering
3. Display the file

Must complete without misordering redirection

---

## B2 — 3-command pipeline in 20 seconds

1. Print file contents
2. Sort them
3. Count unique occurrences
4. Produce correct frequency output

Must execute without hesitation

---

## B3 — Find + sort + head in 30 seconds

1. Create multiple files of different sizes
2. Locate all regular files
3. Determine their sizes
4. Sort by size descending
5. Output the single largest file

Must complete within time constraint

---

# C) Failure Injection Drills (Break & Recover)

## C1 — Misordered redirection

1. Run a command with incorrectly ordered redirection
2. Observe behavior
3. Run the corrected redirection order

Be able to state the rule governing `2>&1`

---

## C2 — Accidental clobber prevention

1. Create a file containing important data
2. Overwrite it unintentionally
3. Recreate it correctly
4. State the difference between overwrite and append

You must feel the destructive nature of `>`

---

# D) Diagnosis Drills (Interpret Output + Exit Codes)

## D1 — Pipeline vs grep exit code

1. Search for a pattern that does not exist in a file
2. Print the exit code
3. Search for a pattern that does exist
4. Print the exit code
5. Trigger an actual grep error
6. Print the exit code

Be able to distinguish:
- No match
- Match found
- Actual failure

---

## D2 — Job control muscle memory

1. Start a long-running process in the background
2. List background jobs
3. Bring the job to the foreground
4. Suspend it
5. Resume it in the background
6. Safely terminate it using job control
7. Verify termination

Must distinguish job specifiers from PIDs

---

# E) Composition Drills (Exam Style)

## E1 — Live filter + capture

1. Group multiple commands (one producing error, one producing normal output)
2. Combine STDOUT and STDERR
3. Pipe combined output through `tee` to capture everything
4. Pipe through `grep` to filter live output
5. Verify:
   - Filtered output is displayed
   - Full output is stored in file

---

## E2 — Report generator

1. Group multiple inspection commands
2. Add structured headers using echo
3. Sort process output by memory usage descending
4. Limit output to top entries
5. Redirect entire grouped output to a report file
6. Verify report readability
7. Regenerate from memory without reference

---

# ✅ Completion Gate

You are complete when:

- You never hesitate on:
  - `>`, `>>`, `2>`, `2>&1`, `&>`
- You never misorder redirection
- You use `tee` naturally
- You build 3–5 command pipelines fluidly
- You group commands for redirection automatically
- You are fluent with job control primitives
- You can construct:

  find | du | sort -rh | head

…without thinking

---

# 🧠 Operator Rule

If you do not control redirection and pipelines perfectly, you do not control Linux

