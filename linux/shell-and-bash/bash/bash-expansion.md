# 🧠 Bash Expansion
## Understanding what Bash does before the command runs

Mental mode: Knowing what the shell changes before execution.

Bash performs **expansion** before running any command.
If you do not understand expansion, commands will surprise you.

This file explains how Bash rewrites what you type *before* execution.

---

## Purpose
You should be able to answer, without guessing:
- Why did this command touch more files than expected?
- Why didn’t this variable expand?
- Why did quoting change the result?
- What exactly is Bash sending to the command?

Expansion happens **before** the command executes.

---

## Expansion Order (High Level)

Bash performs expansions in a defined order.
The important takeaway:

What you type is **not** what the command receives.

Key expansion types:
- brace expansion
- tilde expansion
- parameter expansion
- command substitution
- pathname expansion (globbing)
- quote removal

---

## Brace Expansion

Brace expansion generates text patterns.

Example:
echo file{1,2,3}.txt

Result:
file1.txt file2.txt file3.txt

Ranges:
echo {a..e}
echo {1..5}

Brace expansion happens **first**.
It does not depend on files existing.

---

## Tilde Expansion

The tilde represents home directories.

Examples:
~           → current user’s home
~rob        → rob’s home
~/projects  → path under home

Tilde expansion does not occur inside quotes.

---

## Parameter Expansion

Variables expand using the dollar sign.

Example:
NAME=rob
echo $NAME

Unset variables expand to empty by default.

Safer form:
echo ${NAME}

Braces prevent ambiguity during expansion.

---

## Command Substitution

Command substitution replaces a command with its output.

Modern form:
echo $(date)

Legacy form:
echo `date`

Always prefer the $( ) form.
It nests cleanly and is easier to read.

---

## Pathname Expansion (Globbing)

Wildcards expand to matching filenames.

Common patterns:
*    → any characters
?    → single character
[]   → character class

Example:
ls *.log

If no files match, the pattern may remain unchanged.

Always test globs with ls before destructive commands.

---

## Quoting (Critical Control)

Quoting controls expansion.

Double quotes:
- allow variable expansion
- suppress globbing

Single quotes:
- suppress all expansion

Examples:
echo "$HOME"
echo '$HOME'

When in doubt, quote it.

---

## Expansion Pitfalls

Unquoted variables:
rm $FILE

If FILE is empty, the command changes meaning.

Safer:
rm "$FILE"

Never trust unquoted variables in destructive commands.

---

## Inspecting Expansion

Use echo to inspect expansion results.

Example:
echo *.txt
echo "$VAR"

This shows what Bash produces *before* execution.

---

## Practice

Run and explain:
echo file{a,b}.txt
NAME=test
echo $NAME
echo "$NAME"
echo *.md

Explain:
- what expanded
- what did not
- why quoting changed behavior

If you can predict the output, you understand expansion.

---

## Operational Rule

Most shell mistakes are expansion mistakes.

If a command surprises you:
- stop
- echo the arguments
- inspect expansion
- then act

---

## Outcome

You should be able to say:

I know how Bash rewrites my command,  
I know what the program actually receives,  
and I can prevent accidental side effects.

That is expansion awareness.
