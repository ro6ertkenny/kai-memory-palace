# 🕰️ Bash History & Job Control
## Recovering, repeating, and managing running work

Mental mode: Maintaining control over past and present commands.

This document covers how Bash helps you:
- recall previous commands
- correct mistakes without retyping
- manage foreground and background jobs
- recover control without restarting your session

These skills prevent frustration and wasted effort.

---

## Purpose
You should be able to:
- reuse commands safely
- search command history efficiently
- manage running jobs intentionally
- recover from accidental interruptions

History and job control are productivity force multipliers.

---

## Command History

View history:
history

Each command is stored with a number.
Recent commands appear last.

---

## Re-running Commands

Run previous command:
!!

Run a specific command by number:
!123

Run last command starting with a string:
!ssh

Use history expansion deliberately.
Never run it blindly.

---

## Interactive History Search

Reverse search:
Ctrl+r

Type part of a previous command.
Press Ctrl+r again to cycle matches.
Press Enter to run.

This is the fastest way to recall complex commands.

---

## Editing Previous Commands

Recall last command for editing:
Up Arrow

Move cursor and edit before pressing Enter.

This avoids repeating mistakes.

---

## Job Control Basics

A job is a command managed by the shell.

Start in background:
command &

List jobs:
jobs

Each job has a job number.

---

## Suspending Jobs

Suspend current job:
Ctrl+Z

The job stops but remains in memory.

Resume in background:
bg

Resume in foreground:
fg

Job control applies only to the current shell.

---

## Foreground vs Background

Foreground jobs:
- receive keyboard input
- block the shell

Background jobs:
- run without blocking
- do not receive keyboard input

Choose intentionally.

---

## Killing Jobs and Processes

Terminate job:
kill %1

Terminate process by PID:
kill <PID>

Graceful termination first.
Force only as a last resort.

---

## Disowning Jobs

Remove job from shell control:
disown %1

Useful for long-running tasks you want to survive logout.

---

## Common Mistakes

- closing the terminal and losing work
- restarting instead of suspending
- killing processes without identifying them
- forgetting jobs are shell-local

Know what the shell controls and what it does not.

---

## Practice

Run:
sleep 300
Ctrl+Z
jobs
bg
fg
Ctrl+C

Explain:
- job state transitions
- when the shell regains control

If you can explain this calmly, job control is mastered.

---

## Operational Rule

Never panic when a command blocks.
You always have options.

History recovers the past.
Job control manages the present.

---

## Outcome

You should be able to say:

I can recover commands,  
I can manage running work,  
and I can regain control without restarting.

That is shell mastery.
