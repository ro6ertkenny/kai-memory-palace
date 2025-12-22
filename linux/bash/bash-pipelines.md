# 🔗 Bash Pipelines
## Turning output into signal

Mental mode: Shaping data as it flows.

This document covers how Bash pipelines let you take raw command output
and transform it into **useful, focused information**.

Pipelines are how you think with the shell.

---

## Purpose
You should be able to:
- connect commands intentionally
- filter noise into signal
- extract only what matters
- build readable one-liners

If you can pipeline confidently, troubleshooting accelerates.

---

## The Pipe Operator

The pipe sends output from one command into another.

Concept:
command1 | command2

The second command never sees files.
It only sees **output**.

---

## Simple Pipelines

List processes and filter:
ps aux | grep ssh

Exclude the grep process:
ps aux | grep ssh | grep -v grep

Always verify what each stage receives.

---

## Redirecting Output

Overwrite file:
command > file.txt

Append to file:
command >> file.txt

Redirect errors:
command 2> errors.txt

Redirect output and errors:
command > all.txt 2>&1

Redirection controls **where data goes**.

---

## Common Filters

grep filters lines:
ps aux | grep root

cut extracts columns:
cut -d: -f1 /etc/passwd

awk selects fields:
ps aux | awk '{print $1, $2, $11}'

sed edits streams:
ps aux | sed 's/root/ROOT/g'

Each tool does one thing well.

---

## Sorting and Limiting

Sort output:
du -sh * | sort -h

Reverse sort:
sort -hr

Limit results:
ps aux --sort=-%cpu | head

Combining sort and head is common.

---

## Chaining for Inspection

Find large directories:
du -sh /var/* 2>/dev/null | sort -h | tail

Find top CPU consumers:
ps aux --sort=-%cpu | head

Each pipe narrows focus.

---

## Readability Rule

Pipelines should be readable.

Bad:
ps aux|grep ssh|grep -v grep|awk '{print $2}'

Better:
ps aux \
 | grep ssh \
 | grep -v grep \
 | awk '{print $2}'

Clarity beats cleverness.

---

## Pipelines vs Scripts

Use pipelines when:
- inspecting state
- troubleshooting
- answering a one-off question

Use scripts when:
- repeating workflows
- enforcing consistency

Do not script prematurely.

---

## Common Mistakes

- forgetting what each stage outputs
- filtering too early
- overusing sed when grep suffices
- copying pipelines without understanding

Always build pipelines incrementally.

---

## Practice

Build this pipeline step by step:
ps aux
ps aux | grep root
ps aux | grep root | awk '{print $2, $11}'
ps aux | grep root | awk '{print $2, $11}' | head

Explain what each stage adds.

---

## Outcome

You should be able to say:

I can shape command output deliberately,  
I understand each transformation,  
and I can extract exactly what I need.

That is pipeline fluency.

