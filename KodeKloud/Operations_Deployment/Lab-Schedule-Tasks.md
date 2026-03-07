# Lab - Schedule Tasks

## Task:

As per the cron given below:

0 3 15 * * /usr/bin/touch test_passed

When will /usr/bin/touch test_passed command run?

## Solution:

On the 15th of each month, at 3 AM


## Task:

We're logged in as the user called alex. How do we see the crontab for theroot user?

## Solution:

Using the sudo crontab -l command, we can see the crontab for the root user.


## Task:

Which file can we analyze to check if anacron jobs have run successfully?

## Solution:

The /var/log/cron file contains the information about anacron jobs run.


## Task:

How can we force anacron to rerun all jobs, regardless of when they were last executed?

## Solution:

We can force anacron to rerun all jobs, regardless of when they were last executed using sudo anacron -n -f command.


## Task:

What is the command to see the jobs that are scheduled to run in at utility?

Using the correct command, identify the currently scheduled jobs under user bob and save the command output in the /home/bob/at_jobs.txt file.

Verify the "/home/bob/at_jobs.txt" file.

## Solution:

Execute the below command:

#### atq > /home/bob/at_jobs.txt


## Task:

Remove all at jobs that exist for the user bob.

Have all at jobs been removed?

## Solution:

Identify the jobid using atq command:

Remove the job using jobid; for example, if jobid is 3, then execute the below command:

#### atrm 3


## Task:

Add this command to the crontab of root:

#### /usr/bin/touch test_passed

Make it run every day at 21:30

Is the required cron added?

## Solution:

Execute the sudo crontab -e command and add the code given below.

#### 30 21 * * * /usr/bin/touch test_passed


## Task:

Add an anacron job with the following specifications:

A. It should run once every 10 days.

B. It should have 5 minutes of delay.

C. The job id should be db_cleanup.

D. The command to run is /usr/bin/touch /root/anacron_created_this.`

Is the required anacron added?

## Solution:

Save the line given below in the /etc/anacrontab file.

#### sudo vim /etc/anacrontab

and add below line to file.

#### 10 5 db_cleanup /usr/bin/touch /root/anacron_created_this


## Task:

Using the root user, schedule the below command to run at 15:30 August 20 2054 by using at utility:

#### /usr/bin/touch atscheduler

Has the required command been scheduled to run?

## Solution:

Switch to the root user using the sudo -i command. Then execute the command
at 15:30 August 20 2054.

Add the /usr/bin/touch atscheduler line and then save it by pressing CTRL+D.


## Task:

Using crontab utility, add a cron for user root to run the below command:

#### /usr/bin/touch monthly

Make it run at 12:00AM on the 1st of every month.

Is the required cron added?

## Solution:

Execute the command sudo crontab -e and add the code given below.

#### 0 0 1 * * /usr/bin/touch monthly


## Task:

Using crontab utility, add a cron for user root to run the below command:

#### /usr/bin/touch weekly

Make it run at 11:00AM on every Sunday.

Is the required cron added?

## Solution:

Execute the command sudo crontab -e and add the code given below.

#### 0 11 * * 0 /usr/bin/touch weekly


## Task:

Add a cron for the user bob to execute the sudo /usr/bin/systemctl restart nginx command on Sundays every week at 6am and 11pm.

Has the required cron been added?

## Solution:

Execute the crontab -e command and add the code given below.

#### 0 6,23 * * 0 sudo /usr/bin/systemctl restart nginx


