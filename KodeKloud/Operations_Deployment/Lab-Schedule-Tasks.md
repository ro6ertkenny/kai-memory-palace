# Lab - Schedule Tasks

## Task:

As per the cron given below:

0 3 15 * * /usr/bin/touch test_passed

When will /usr/bin/touch test_passed command run?

<details><summary>Answer</summary>
On the 15th of each month, at 3 AM

### Explanation:
- 0 → minute field, runs at minute 0
- 3 → hour field, runs at 3 AM
- 15 → day of month field, runs on the 15th
- '*' → every month
- '*' → every day of week
- /usr/bin/touch test_passed → command that will run


## 🕒 LFCS CRON — SIMP KEY (MEMORY + EXECUTION)

👉 **CRON = “run this command on a schedule”**

Think:
> “At THIS time → run THIS command”

## 🔑 THE 5 FIELD KEY (MOST IMPORTANT)

👉 **Memorize this EXACTLY:**

    * * * * *  command
    │ │ │ │ │
    │ │ │ │ └── Day of Week (0–7) (Sun=0 or 7)
    │ │ │ └──── Month (1–12)
    │ │ └────── Day of Month (1–31)
    │ └──────── Hour (0–23)
    └────────── Minute (0–59)

## 🧠 MEMORY PHRASE (USE THIS)

👉 **“Minute Hour Day Month Week”**

When you see a cron line:

    30 2 * * * /script.sh

👉 Read it like:

> “At minute 30, hour 2, every day, every month, every week → run script.sh”

Value	Meaning
0	12:00 AM (midnight)
12	12:00 PM (noon)
23	11:00 PM
❌ 24	INVALID

## ⚙️ SPECIAL SYMBOLS (YOU WILL SEE THESE)

### ⭐ `*` = “EVERY”
    * * * * *
→ every minute of every hour of every day

### ➗ `*/N` = “EVERY N UNITS”
    */5 * * * *
→ every 5 minutes

EXAMPLE:

## ✅ CRON JOB

    */5 * * * * /home/bob/backup.sh

## 🧠 HOW TO READ IT

    */5 * * * * /home/bob/backup.sh
    │
    └── Minute field

👉 `*/5` = every 5 minutes

So this means:

> “Every 5 minutes, every hour, every day, every month, every week → run /home/bob/backup.sh”


### 📋 `,` = “LIST”
    0 1,13 * * *
→ 1 AM and 1 PM

### ➖ `-` = “RANGE”
    0 9-17 * * *
→ every hour from 9 to 17 (9 AM – 5 PM)

---

## 🧪 COMMON LFCS TASK PATTERNS

### 🟢 Run every day at 2 AM
    0 2 * * * /script.sh

### 🟢 Run every 5 minutes
    */5 * * * * /script.sh

### 🟢 Run every Sunday at midnight
    0 0 * * 0 /script.sh

### 🟢 Run at 3:15 PM on the 1st of every month
    15 15 1 * * /script.sh


## 🛠️ COMMANDS YOU MUST KNOW

### 📌 Edit cron jobs (current user)
    crontab -e

### 📌 List cron jobs
    crontab -l

### 📌 Remove cron jobs
    crontab -r

### 📌 Edit another user’s cron
    sudo crontab -u username -e

## 📂 SYSTEM CRON (IMPORTANT DIFFERENCE)

File:
    /etc/crontab

👉 Has an EXTRA FIELD:

    * * * * * user command

### 🧠 KEY DIFFERENCE

| Type            | Has User Field? |
|-----------------|----------------|
| crontab -e      | ❌ NO          |
| /etc/crontab    | ✅ YES         |


## ⚠️ LFCS GOTCHAS (DON’T MISS THESE)

### ❗ FULL PATHS ONLY
Cron does NOT know your environment

BAD:
    script.sh

GOOD:
    /home/bob/script.sh

### ❗ REDIRECT OUTPUT (VERY COMMON TASK)

    0 2 * * * /script.sh > /tmp/output.log 2>&1

👉 Means:
- `>` → stdout
- `2>&1` → stderr → same place

### ❗ SERVICE MUST BE RUNNING

Check:
    systemctl status cron

Start if needed:
    sudo systemctl start cron


## 🧠 FINAL SIMP LOCK-IN

👉 CRON =

    “Minute Hour Day Month Week → Command”

👉 If you can:
- Read it
- Write it
- Recognize patterns

👉 You pass cron questions on LFCS.

</details>


## Task:

We're logged in as the user called alex. How do we see the crontab for the root user?

<details><summary>Answer</summary>
Using the sudo crontab -l command, we can see the crontab for the root user.

####    sudo crontab -l

### Explanation:
- sudo → run with elevated privileges
- crontab → manage cron jobs
- -l → list current crontab entries
- root user → target user's crontab being viewed

</details>

---

## Task:

Which file can we analyze to check if anacron jobs have run successfully?

<details><summary>Answer</summary>
The /var/log/cron file contains the information about anacron jobs run.

### Explanation:
- /var/log/cron → log file for cron and anacron activity
- anacron jobs → scheduled jobs tracked through logging

## 🧠 WHERE TO SEE ANACRON JOBS (RUNNING + HISTORY)

👉 **Anacron does NOT have its own “job list” like crontab**

Instead:
- Jobs are defined in a file
- Execution is tracked in logs

## 🟢 1. WHERE ANACRON JOBS ARE DEFINED

### 📌 File:
    /etc/anacrontab

### 📌 View it:
    cat /etc/anacrontab

### 🧠 Example:
    1   5   cron.daily     run-parts /etc/cron.daily
    7   10  cron.weekly    run-parts /etc/cron.weekly
    30  15  cron.monthly   run-parts /etc/cron.monthly

### 🧠 What this means:

    period delay job-id command

👉 Example:
- `1` → run every 1 day
- `5` → wait 5 minutes after boot
- `cron.daily` → job name
- `run-parts /etc/cron.daily` → what runs

## 🟢 2. WHERE ANACRON JOBS LIVE

👉 These directories:

    /etc/cron.daily/
    /etc/cron.weekly/
    /etc/cron.monthly/

### 📌 View jobs:
    ls /etc/cron.daily

## 🟢 3. WHERE TO SEE IF THEY RAN (🔥 MOST IMPORTANT)

### ✅ On Ubuntu:

    /var/log/syslog

### 📌 Search logs:
    grep anacron /var/log/syslog
    grep CRON /var/log/syslog

### 🧠 Example output:

    anacron[1234]: Job `cron.daily' started
    anacron[1234]: Job `cron.daily' terminated

## 🟢 4. REAL-TIME / RECENT ACTIVITY (BEST METHOD)

👉 Use journalctl:

    journalctl -u cron
    journalctl | grep anacron

## 🟢 5. TRACKING FILES (ADVANCED — VERY USEFUL)

👉 Anacron keeps timestamps here:

    /var/spool/anacron/

### 📌 View:
    ls /var/spool/anacron

### 🧠 Example:
    cron.daily
    cron.weekly

👉 These files contain:
- Last run date of each job

## ⚠️ LFCS GOTCHA

👉 There is NO:

    crontab -l (for anacron)

👉 You must combine:

- /etc/anacrontab → definition
- /etc/cron.* → actual scripts
- logs → execution proof


## 🧠 FINAL LOCK-IN

👉 WHERE ARE JOBS DEFINED?
    /etc/anacrontab

👉 WHAT ACTUALLY RUNS?
    /etc/cron.daily / weekly / monthly

👉 WHERE DO I SEE IF THEY RAN?
    /var/log/syslog
    journalctl

👉 LAST RUN TRACKING?
    /var/spool/anacron/

</details>

---

## Task:

How can we force anacron to rerun all jobs, regardless of when they were last executed?

<details><summary>Answer</summary>
We can force anacron to rerun all jobs, regardless of when they were last executed using:

####    sudo anacron -nf

### Explanation:
- sudo → run with elevated privileges
- anacron → run commands periodically with delay handling
- -n → run jobs now, without waiting for delays
- -f → force execution, ignoring timestamps of previous runs

</details>

---

## Task:

What is the command to see the jobs that are scheduled to run in at utility?

Using the correct command, identify the currently scheduled jobs under user bob and save the command output in the /home/bob/at_jobs.txt file.

Verify the "/home/bob/at_jobs.txt" file.

<details><summary>Answer</summary>
Execute the below command:

#### atq > /home/bob/at_jobs.txt

### Explanation:
- atq → list pending at jobs
- '>' → redirect output to file
- /home/bob/at_jobs.txt → destination file

👉 `at` = run a job **ONE TIME in the future**

👉 `atq` = **see the jobs waiting to run**

## 🔑 WHAT DOES `atq` MEAN?

👉 Think:

    at + queue = atq

👉 So:

    atq = “show me the at queue”

> “List all scheduled at jobs that haven’t run yet”


If you are logged in as:

    bob

Run:

    atq

👉 You will see:
- ONLY bob’s scheduled jobs

## 🔐 WHAT ABOUT OTHER USERS?

👉 You CANNOT see other users’ jobs unless you have privileges

### 🟢 As root (or sudo)

    sudo atq

👉 Now you see:
- ALL users’ at jobs

</details>

---

## Task:

Remove all at jobs that exist for the user bob.

Have all at jobs been removed?

<details><summary>Answer</summary>
Identify the job id using atq command:

#### atq

Remove the job using job id; for example, if job id is 3, then execute the below command:

#### atrm 3

### Explanation:
- atq → list queued at jobs and their job IDs
- atrm → remove an at job
- 3 → example job ID to remove

</details>

---

## Task:

Add this command to the crontab of root:

#### /usr/bin/touch test_passed

Make it run every day at 21:30

Is the required cron added?

<details><summary>Answer</summary>
Execute the sudo crontab -e command and add the code given below.

#### sudo crontab -e

#### 30 21 * * * /usr/bin/touch test_passed

### Explanation:
- sudo → edit root user's crontab
- crontab -e → open crontab for editing
- 30 → minute field
- 21 → hour field, 9 PM
- * → every day of month
- * → every month
- * → every day of week
- /usr/bin/touch test_passed → command to run

👉 crontab = “cron table”

cron → time-based job scheduler
tab → table

👉 It’s literally a table of scheduled jobs

Each line = one scheduled task

Here's what the crontab should look like:
# These replace cron's entries
    1       5       cron.daily      run-parts --report /etc/cron.daily
    7       10      cron.weekly     run-parts --report /etc/cron.weekly
    10      5       db_cleanup      /usr/bin/touch /root/anacron_created_this

@monthly        15      cron.monthly    run-parts --report /etc/cron.monthly

The last line means:

This is still an anacron-style job, not normal cron
It’s using a nickname (@monthly) instead of a number

🧠 SIMP Breakdown
@monthly → run once per month
15 → wait 15 minutes after boot
cron.monthly → job ID
run-parts --report /etc/cron.monthly → run all scripts in that directory

🔥 What it actually does

“Once per month (when the system is up), wait 15 minutes, then run all scripts in /etc/cron.monthly”

🧠 What is run-parts?

👉 It runs every executable file in a directory

So:

run-parts /etc/cron.monthly

👉 executes:

all monthly maintenance scripts
backups, cleanup, updates, etc.

</details>

---

## Task:

Add an anacron job with the following specifications:

A. It should run once every 10 days.

B. It should have 5 minutes of delay.

C. The job id should be db_cleanup

D. The command to run is /usr/bin/touch /root/anacron_created_this

Is the required anacron added?


<details><summary>Answer</summary>
Save the line given below in the /etc/anacrontab file.

#### sudo vim /etc/anacrontab

and add below line to file.

#### 10 5 db_cleanup /usr/bin/touch /root/anacron_created_this


### Explanation:
- /etc/anacrontab → anacron configuration file
- sudo vim → edit file with elevated privileges
- 10 → run every 10 days
- 5 → delay execution by 5 minutes
- db_cleanup → job identifier
- /usr/bin/touch /root/anacron_created_this → command to run

## 🎯 THE LINE

    10 5 db_cleanup /usr/bin/touch /root/anacron_created_this

## 🔍 BREAKDOWN (FIELD BY FIELD)

👉 Anacron format:

    period  delay  job-id     command

### `10`
👉 Run every **10 days**

### `5`
👉 Wait **5 minutes after boot** before running

### `db_cleanup`
👉 Just a **name/label** for the job (no effect on execution)

### `/usr/bin/touch /root/anacron_created_this`
👉 The command that runs

## 🧠 WHAT `touch` DOES (SIMP)

👉 `touch` does NOT write text

👉 It:

- Creates the file if it doesn’t exist
- Updates the timestamp if it DOES exist

## 🧪 WHAT THIS JOB ACTUALLY DOES

👉 Every 10 days (after a reboot, with 5 min delay):

    /root/anacron_created_this

Will:

- ✅ Be created if missing
- 🔄 Have its timestamp updated if already exists

## ❗ IMPORTANT CLARIFICATION

👉 It does NOT:

- ❌ write "anacron_created_this" inside the file
- ❌ overwrite contents
- ❌ add any text at all

## 🧠 THINK OF IT LIKE THIS

👉 `touch` = “mark this file with current time”

## 🔎 HOW TO VERIFY

Check file:

    ls -l /root/anacron_created_this

👉 Look at the timestamp → it updates when job runs

## 🧠 FINAL LOCK-IN

👉 `touch` = create OR update timestamp  
👉 anacron job = runs on schedule after boot  
👉 this job = **timestamp marker, not content writer**

</details>

---

## Task:

Using the root user, schedule the below command to run at 15:30 August 20 2054 by using at utility:

#### /usr/bin/touch atscheduler

Has the required command been scheduled to run?

<details><summary>Answer</summary>
Switch to the root user using the sudo -i command. Then execute the command
at 15:30 August 20 2054.

####    sudo -i
####    at 15:30 August 20 2054
####    /usr/bin/touch atscheduler
####    Ctrl + D
####    atq

### Explanation:
- sudo -i → switch to root shell
- at 15:30 August 20 2054 → schedule one-time job for that date and time
- /usr/bin/touch atscheduler → command entered into the at prompt
- CTRL+D → save and submit the at job

👉 `touch` is a **program (binary)** located at:

    /usr/bin/touch

👉 It is NOT a text file you read  
👉 It is a compiled executable (like a program)

## 🔍 WHAT `touch atscheduler` DOES

👉 When this runs:

    /usr/bin/touch atscheduler

It will:

- ✅ Create a file named `atscheduler` (if it doesn’t exist)
- 🔄 OR update its timestamp (if it does exist)

## ❗ IMPORTANT

👉 It does NOT:
- ❌ write text
- ❌ store “atscheduler” inside the file
- ❌ do anything complex

## 🧠 THINK OF IT LIKE THIS

👉 `touch` = “create a blank file or update time”

## 🧪 WHAT THE TASK IS REALLY TESTING

NOT `touch`…

👉 It’s testing:

    “Do you know how to schedule a one-time job with `at`?”

## ⚙️ FULL FLOW

### 1️⃣ Become root
    sudo -i

### 2️⃣ Schedule job
    at 15:30 August 20 2054

### 3️⃣ Enter command
    /usr/bin/touch atscheduler

### 4️⃣ Exit input (CRITICAL)
    Ctrl + D

### 5️⃣ Verify job
    atq

## 🧠 WHAT WILL HAPPEN LATER

At:

    Aug 20, 2054 @ 15:30

👉 System will run:

    /usr/bin/touch atscheduler

👉 Result:
- A file named `atscheduler` will appear
- In the **current working directory at time of execution**

## ⚠️ LFCS GOTCHA (IMPORTANT)

👉 If no path is given:

    atscheduler

👉 It gets created wherever the job runs from (often `/root` if root)

👉 SAFER version (real-world):

    /usr/bin/touch /root/atscheduler

## 🧠 FINAL LOCK-IN

👉 `/usr/bin/touch` = the program  
👉 `atscheduler` = the file name  

👉 `at` = schedule it  
👉 `atq` = verify it  

👉 This task = **AT scheduling test, not touch test**

## 🔥 WHY LFCS USES `touch`

👉 It’s the **simplest way to prove a command ran**

Example:

    at 15:00
    touch testfile

👉 If file appears later:
✔️ job worked

## ⚠️ LFCS GOTCHA

👉 If you see:

    /usr/bin/touch file

👉 That’s just the **full path to the command**

Same as:

    touch file

## 🧠 FINAL LOCK-IN

👉 `touch file` = create empty file  
👉 existing file = update timestamp  
👉 no content is written  

👉 Think:

    “touch = existence + time”

</details>

---

## Task:

Using crontab utility, add a cron for user root to run the below command:

#### /usr/bin/touch monthly

Make it run at 12:00AM on the 1st of every month.

Is the required cron added?

<details><summary>Answer</summary>
Execute the command sudo crontab -e and add the code given below.

#### sudo crontab -e
#### 0 0 1 * * /usr/bin/touch monthly
       
 [time fields] [command]

👉 The command MUST be separated by a space

### Explanation:
- sudo → edit root user's crontab
- crontab -e → open crontab editor
- 0 → minute field
- 0 → hour field, 12:00 AM
- 1 → first day of month
- '*' → every month
- '*' → every day of week
- /usr/bin/touch monthly → command to run

## 🧠 Cron Format

A cron entry has:

    minute hour day-of-month month day-of-week command

That means:

    [1] [2] [3] [4] [5] [command]

## 🧪 Examples

| Field | `*` Means |
|------|----------|
| minute | every minute |
| hour | every hour |
| day | every day |
| month | every month |

</details>

--- 

## Task:

Using crontab utility, add a cron for user root to run the below command:

#### /usr/bin/touch weekly

Make it run at 11:00AM on every Sunday.

Is the required cron added?

<details><summary>Answer</summary>
Execute the command sudo crontab -e and add the code given below.

#### sudo crontab -e
#### 0 11 * * 0 /usr/bin/touch weekly

### Explanation:
- sudo → edit root user's crontab
- crontab -e → open crontab editor
- 0 → minute field
- 11 → hour field, 11:00 AM
- * → every day of month
- * → every month
- 0 → Sunday
- /usr/bin/touch weekly → command to run

👉 Run at:
> 11:00 AM  
> every Sunday  
> every month  
> every day-of-month (doesn’t matter because Sunday is specified)

## 🧠 FULL MAPPING

| Value | Day       |
|------|----------|
| 0    | Sunday    |
| 1    | Monday    |
| 2    | Tuesday   |
| 3    | Wednesday |
| 4    | Thursday  |
| 5    | Friday    |
| 6    | Saturday  |
| 7    | Sunday    |


## 🔑 MEMORY LOCK-IN

👉 Think:

> 🗣️ “Week starts at Sunday = 0”

## 🧪 EXAMPLES

### Run every Sunday at midnight
    0 0 * * 0 /script.sh

### Same thing (alternative)
    0 0 * * 7 /script.sh

## ⚠️ LFCS GOTCHA

👉 BOTH 0 and 7 = Sunday

👉 But most people use:
    0

## 🧠 FINAL LOCK-IN

👉 0 = Sunday  
👉 7 = Sunday (alternate)  
👉 1–6 = Monday–Saturday  

👉 Think:

    “Sunday wraps the week”

</details>

---

## Task:

Add a cron for the user bob to execute the sudo /usr/bin/systemctl restart nginx command on Sundays every week at 6am and 11pm.

Has the required cron been added?

<details><summary>Answer</summary>
Execute the crontab -e command and add the code given below.

#### 0 6,23 * * 0 sudo /usr/bin/systemctl restart nginx
</details>

### Explanation:
- crontab -e → open current user's crontab
- 0 → minute field
- 6,23 → run at 6 AM and 11 PM
- * → every day of month
- * → every month
- 0 → Sunday
- sudo /usr/bin/systemctl restart nginx → command to run
- restart nginx → restart the nginx service

🧠 The Key Concept (LOCK THIS IN)

crontab -e edits the cron for the current user

🔍 So how do you target bob?
✅ Option 1 (MOST EXPLICIT — exam safe)
sudo crontab -u bob -e

👉 This clearly means:

“Edit bob’s cron”

⚠️ Option 2 (context-based)

If you are already logged in as bob:

crontab -e

👉 That edits bob’s cron


## Cron Line
    0 6,23 * * 0 sudo /usr/bin/systemctl restart nginx

## 🧠 Core Question
> Why `6,23` instead of two separate lines?

## 🔥 Short Answer

> The comma `,` lets you run a job at **multiple specific times in the same field**

## 🧠 Mental Model

    , = “AND ALSO at this time”

# 🔍 Full Breakdown

    0        → minute (0)
    6,23     → hour (6 AM AND 11 PM)
    *        → every day of month
    *        → every month
    0        → Sunday
    command  → run this

## 🔥 What `6,23` Means

👉 Run at:
- 06:00  
- 23:00  

ON:
- Sundays only

## 🧠 Why This Works

Cron allows **lists** in fields:

    value1,value2,value3

👉 means:
> run at ALL those values

## 🧪 Equivalent (But Less Efficient)

You COULD write:

    0 6 * * 0 sudo /usr/bin/systemctl restart nginx
    0 23 * * 0 sudo /usr/bin/systemctl restart nginx

👉 But:
- duplicates the command  
- harder to maintain  

## ✅ Preferred (Cleaner)

    0 6,23 * * 0 ...

👉 one line  
👉 same result  

## 🧠 Mental Model (LOCK THIS IN)

| Symbol | Meaning |
|--------|--------|
| `,`    | multiple values |
| `*`    | every |
| `-`    | range |
| `/`    | step |

## 🧪 Examples

### Multiple times
    0 1,5,9 * * *

👉 1 AM, 5 AM, 9 AM

### Range
    0 1-5 * * *

👉 1 AM through 5 AM

### Step
    */10 * * * *

👉 every 10 minutes

## ⚠️ Important Detail

    6,23

👉 is NOT a range  
👉 it is a **list**

## 🔁 1-Line Recall

    comma = “run at these multiple times”

## ⚡ Exam Pattern

If you see:
- “at X and Y times” → use `,`

## 🧨 Operator Insight

Cron fields are powerful because you can combine:

    1,5,10-15/2

👉 lists + ranges + steps

## Final Takeaway

    0 6,23 * * 0 ...

👉 means:
> run at 6:00 AM AND 11:00 PM every Sunday

👉 using a single, clean cron entry
