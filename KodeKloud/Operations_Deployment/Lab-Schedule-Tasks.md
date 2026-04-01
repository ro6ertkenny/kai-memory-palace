# Schedule Tasks — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: As per the cron below:

0 3 15 * * /usr/bin/touch test_passed

When will this run?

<details>
<summary>Answer</summary>

### Command
    0 3 15 * *

### Explanation
- minute = 0
- hour = 3
- day = 15
- month = *
- day of week = *

→ runs at 03:00 on the 15th of every month

</details>

---

## 🧪 Task 2

Task: As user alex, how do we see the crontab for root?

<details>
<summary>Answer</summary>

### Command
    sudo crontab -l

### Explanation
- crontab -l → list cron jobs
- sudo → access root's crontab

</details>

---

## 🧪 Task 3

Task: Which file contains logs for anacron jobs?

<details>
<summary>Answer</summary>

### Command
    /var/log/cron

### Explanation
- /var/log/cron → contains cron and anacron job logs (distro-dependent)

</details>

---

## 🧪 Task 4

Task: Force anacron to rerun all jobs.

<details>
<summary>Answer</summary>

### Command
    sudo anacron -n -f

### Explanation
- -n → run jobs now
- -f → force execution regardless of timestamps

</details>

---

## 🧪 Task 5

Task: Show all at jobs for user bob and save output to /home/bob/at_jobs.txt.

<details>
<summary>Answer</summary>

### Command
    atq > /home/bob/at_jobs.txt

### Explanation
- atq → list scheduled at jobs
- `>` → redirect output to file

</details>

---

## 🧪 Task 6

Task: Remove all at jobs for user bob.

<details>
<summary>Answer</summary>

### Command
    atq | awk '{print $1}' | xargs atrm

### Explanation
- atq → list jobs
- awk '{print $1}' → extract job IDs
- xargs atrm → remove each job

</details>

---

## 🧪 Task 7

Task: Add cron job for root to run /usr/bin/touch test_passed daily at 21:30.

<details>
<summary>Answer</summary>

### Command
    sudo crontab -e

    30 21 * * * /usr/bin/touch test_passed

### Explanation
- 30 → minute
- 21 → hour (9:30 PM)
- * * * → every day

</details>

---

## 🧪 Task 8

Task: Add an anacron job:

- every 10 days
- 5 minute delay
- job id = db_cleanup
- command = /usr/bin/touch /root/anacron_created_this

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/anacrontab

    10 5 db_cleanup /usr/bin/touch /root/anacron_created_this

### Explanation
- 10 → run every 10 days
- 5 → delay in minutes
- db_cleanup → job identifier
- command → executed task

</details>

---

## 🧪 Task 9

Task: Schedule /usr/bin/touch atscheduler to run at 15:30 August 20 2054 using at.

<details>
<summary>Answer</summary>

### Command
    sudo -i
    at 15:30 Aug 20 2054

    /usr/bin/touch atscheduler
    Ctrl+D

### Explanation
- at → schedule one-time job
- Ctrl+D → save and exit input

</details>

---

## 🧪 Task 10

Task: Add cron for root to run /usr/bin/touch monthly at 12:00AM on the 1st of every month.

<details>
<summary>Answer</summary>

### Command
    sudo crontab -e

    0 0 1 * * /usr/bin/touch monthly

### Explanation
- 0 0 → midnight
- 1 → first day of month

</details>

---

## 🧪 Task 11

Task: Add cron for root to run /usr/bin/touch weekly at 11:00AM every Sunday.

<details>
<summary>Answer</summary>

### Command
    sudo crontab -e

    0 11 * * 0 /usr/bin/touch weekly

### Explanation
- 0 → Sunday (also can be 7)
- 11 → 11 AM

</details>

---

## 🧪 Task 12

Task: Add cron for user bob to run "sudo /usr/bin/systemctl restart nginx" at 6am and 11pm every Sunday.

<details>
<summary>Answer</summary>

### Command
    crontab -e

    0 6,23 * * 0 sudo /usr/bin/systemctl restart nginx

### Explanation
- 6,23 → 6 AM and 11 PM
- * * 0 → every Sunday
- sudo → requires proper sudo permissions in cron environment

</details>
