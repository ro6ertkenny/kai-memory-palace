# 🧭 Bash Basics
## Moving, inspecting, and acting with intent

Mental mode: Issuing precise instructions to the system.

This document covers the **core Bash skills** required to function confidently on a Linux system.
These are the commands you should be able to type **without thinking**.

---

## Purpose
You should be able to:
- move through the filesystem quickly
- inspect files and directories
- understand command structure
- predict command outcomes before running them

If you hesitate here, everything else slows down.

---

## Command Structure

Basic form:
command [options] [arguments]

Example:
ls -la /etc

Rules:
- options modify behavior
- arguments are targets
- order matters

Always read commands left to right.

---

## Navigation

Print working directory:
pwd

List contents:
ls
ls -l
ls -la

Change directory:
cd /path/to/dir
cd ..
cd ~

Return to previous directory:
cd -

Navigation should become muscle memory.

---

## Files and Directories

Create directory:
mkdir test-dir

Create nested directories:
mkdir -p a/b/c

Create file:
touch file.txt

Copy:
cp file1 file2
cp -r dir1 dir2

Move or rename:
mv old new

Remove file:
rm file.txt

Remove directory:
rm -r dir

Never use rm -r unless you know exactly what it targets.

---

## Viewing File Contents

View file:
cat file.txt

Paged view:
less file.txt

View beginning:
head file.txt

View end:
tail file.txt

Follow updates:
tail -f logfile

Prefer less over cat for large files.

---

## Wildcards and Globbing

Common patterns:
*   → any characters
?   → single character

Examples:
ls *.log
rm temp-?.txt

Globs expand before the command runs.
Always verify with ls first.

---

## Command Exit Codes

Every command returns an exit code:
0   → success
non-zero → failure

Inspect last exit code:
echo $?

Exit codes drive automation and conditionals.

---

## Environment Variables

View variables:
env

View specific variable:
echo $HOME

Set variable (current shell only):
MYVAR=value

Export variable:
export MYVAR=value

Variables influence command behavior.

---

## Which and Type

Find command path:
which ls

Inspect command type:
type ls

Not everything is a binary.
Some commands are built into the shell.

---

## Command History

View history:
history

Run previous command:
!!

Search history:
Ctrl+r

History is a productivity multiplier.

---

## Safety Habits

- Always inspect targets before destructive commands
- Prefer mv over rm when unsure
- Use absolute paths for risky operations
- Slow down when using wildcards

Speed comes from correctness, not haste.

---

## Practice

Run:
pwd
ls -la
cd /
ls
cd ~

Create a test directory and file.
Move it.
Remove it.

Explain each step before executing it.

---

## Outcome

You should be able to say:

I know where I am,  
I know what I am touching,  
and I know what the command will do.

That is Bash control.
