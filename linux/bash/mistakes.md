# ⚠️ Bash Mistakes
## High-signal shell mistakes worth remembering

Mental mode: Preventing self-inflicted damage.

This file exists to document **only the Bash mistakes that matter**:
- easy to repeat
- costly when repeated
- subtle enough to surprise you again

This is not a checklist of beginner errors.
It is a memory guardrail.

---

## Rule: Document sparingly
A Bash mistake belongs here only if:
- you personally made it, and
- it caused real confusion, delay, or risk

If it didn’t hurt, it doesn’t belong.

---

## Mistake: Running destructive commands with unquoted variables
Symptom:
- files deleted or moved unexpectedly
- command targets expand incorrectly

Cause:
- unquoted variables expand to empty or multiple values

Example problem:
rm $FILE

Fix:
Always quote variables:
rm "$FILE"

Operational rule:
- never trust unquoted variables in destructive commands

---

## Mistake: Assuming globs always match something
Symptom:
- command behaves strangely
- literal patterns appear in output

Cause:
- glob patterns that match nothing remain unexpanded

Example:
rm *.log

If no .log files exist, behavior may differ than expected.

Fix:
- test with ls first
- inspect expansion with echo

Operational rule:
- always verify globs before destructive actions

---

## Mistake: Forgetting which layer controls a job
Symptom:
- killing a job does nothing
- restarting the shell “fixes” it

Cause:
- confusion between shell job control and system processes

Fix:
- use jobs, fg, bg for shell-managed work
- use ps and kill for system processes

Operational rule:
- know whether the shell or the system owns the task

---

## Mistake: Re-running history expansions blindly
Symptom:
- unintended commands execute
- state changes you didn’t intend

Cause:
- using !! or !string without reviewing

Fix:
- recall command with arrow keys
- edit before executing

Operational rule:
- history recall is for reuse, not autopilot

---

## Mistake: Using sudo to “make it work”
Symptom:
- commands succeed once
- future operations require sudo unexpectedly

Cause:
- bypassed permissions instead of fixing ownership

Fix:
- inspect ownership and permissions
- correct root cause

Operational rule:
- sudo is not a fix, it is an escalation

---

## Mistake: Copy-pasting pipelines without understanding them
Symptom:
- output surprises you
- commands behave differently than expected

Cause:
- pipelines copied as incantations

Fix:
- build pipelines one stage at a time
- inspect output at each step

Operational rule:
- never run a pipeline you cannot explain

---

## Mistake: Assuming the shell “knows what you meant”
Symptom:
- wrong files touched
- wrong directories affected

Cause:
- Bash does exactly what it is told, not what you intended

Fix:
- slow down
- inspect expansion
- verify targets

Operational rule:
- intent must be explicit

---

## Add New Mistakes Here
When adding a new mistake, include:
- Symptom
- Cause
- Fix
- Operational rule

If it doesn’t teach control, delete it.
