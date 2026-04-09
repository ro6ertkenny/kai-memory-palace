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
- * → every month
- * → every day of week
- /usr/bin/touch test_passed → command that will run

</details>

---

## Task:

We're logged in as the user called alex. How do we see the crontab for theroot user?

<details><summary>Answer</summary>
Using the sudo crontab -l command, we can see the crontab for the root user.

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

</details>

---

## Task:

How can we force anacron to rerun all jobs, regardless of when they were last executed?

<details><summary>Answer</summary>
We can force anacron to rerun all jobs, regardless of when they were last executed using sudo anacron -n -f command.

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
- > → redirect output to file
- /home/bob/at_jobs.txt → destination file

</details>

---

## Task:

Remove all at jobs that exist for the user bob.

Have all at jobs been removed?

<details><summary>Answer</summary>
Identify the jobid using atq command:

Remove the job using jobid; for example, if jobid is 3, then execute the below command:

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

</details>

---

## Task:

Add an anacron job with the following specifications:

A. It should run once every 10 days.

B. It should have 5 minutes of delay.

C. The job id should be db_cleanup.

D. The command to run is /usr/bin/touch /root/anacron_created_this.

Is the required anacron added?


<details><summary>Answer</summary>
Save the line given below in the /etc/anacrontab file.

#### sudo vim /etc/anacrontab

and add below line to file.

#### 10 5 db_cleanup /usr/bin/touch /root/anacron_created_this

</details>

### Explanation:
- /etc/anacrontab → anacron configuration file
- sudo vim → edit file with elevated privileges
- 10 → run every 10 days
- 5 → delay execution by 5 minutes
- db_cleanup → job identifier
- /usr/bin/touch /root/anacron_created_this → command to run

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
</details>

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

# Why the Cron Is Written This Way (`0 6,23 * * 0 ...`)

## Cron Line
    0 6,23 * * 0 sudo /usr/bin/systemctl restart nginx

---

## 🧠 Core Question
> Why `6,23` instead of two separate lines?

---

## 🔥 Short Answer

> The comma `,` lets you run a job at **multiple specific times in the same field**

---

# 🧠 Mental Model

    , = “AND ALSO at this time”

---

# 🔍 Full Breakdown

    0        → minute (0)
    6,23     → hour (6 AM AND 11 PM)
    *        → every day of month
    *        → every month
    0        → Sunday
    command  → run this

---

# 🔥 What `6,23` Means

👉 Run at:
- 06:00  
- 23:00  

ON:
- Sundays only

---

# 🧠 Why This Works

Cron allows **lists** in fields:

    value1,value2,value3

👉 means:
> run at ALL those values

---

# 🧪 Equivalent (But Less Efficient)

You COULD write:

    0 6 * * 0 sudo /usr/bin/systemctl restart nginx
    0 23 * * 0 sudo /usr/bin/systemctl restart nginx

👉 But:
- duplicates the command  
- harder to maintain  

---

# ✅ Preferred (Cleaner)

    0 6,23 * * 0 ...

👉 one line  
👉 same result  

---

# 🧠 Mental Model (LOCK THIS IN)

| Symbol | Meaning |
|--------|--------|
| `,`    | multiple values |
| `*`    | every |
| `-`    | range |
| `/`    | step |

---

# 🧪 Examples

### Multiple times
    0 1,5,9 * * *

👉 1 AM, 5 AM, 9 AM

---

### Range
    0 1-5 * * *

👉 1 AM through 5 AM

---

### Step
    */10 * * * *

👉 every 10 minutes

---

# ⚠️ Important Detail

    6,23

👉 is NOT a range  
👉 it is a **list**

---

# 🔁 1-Line Recall

    comma = “run at these multiple times”

---

# ⚡ Exam Pattern

If you see:
- “at X and Y times” → use `,`

---

# 🧨 Operator Insight

Cron fields are powerful because you can combine:

    1,5,10-15/2

👉 lists + ranges + steps

---

# Final Takeaway

    0 6,23 * * 0 ...

👉 means:
> run at 6:00 AM AND 11:00 PM every Sunday

👉 using a single, clean cron entry
