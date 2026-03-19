# Lab - Packet Filtering

## Task:

By default, Uncomplicated Firewall (ufw) is disabled. So, do the following before proceeding into the lab.

1. Turn on ufw
2. All traffic is blocked by default, so we must allow SSH on port 22 so the lab won't be broken.

Is the UFW firewall tool status active?

Is traffic allowed on port 22? 

## Solution:

Start ufw with

#### sudo ufw enable

All traffic is blocked by default, so we must allow SSH on port 22 so the lab won't be broken.

#### sudo ufw allow 22


## Task:

Set up a firewall rule to allow incoming traffic to this machine on port 80.

Have incoming connections to port 80 been allowed?

## Solution:

Execute the below command:

#### sudo ufw allow 80


## Task:

Set up a firewall rule to allow incoming traffic to this machine on port 53, through the TCP protocol.

Have incoming connections to port 53 been allowed?

## Solution:

Execute the below command:

#### sudo ufw allow 53/tcp


## Task:

Set up a firewall rule to deny incoming traffic to this machine on port 443, through the TCP protocol.

Is the rule to deny access through 443/tcp added?

## Solution:

Execute the below command to finish the task.

#### sudo ufw deny 443/tcp


## Task:

Delete a firewall rule denying incoming traffic to this machine on port 443, through the TCP protocol (That is created in previous step).

Is the rule deleted?

## Solution:

Execute the below command

#### sudo ufw delete deny 443/tcp


## Task:

Rules that we add are numbered. What is the rule with number 5?

## Solution:

Execute the below command and check for the rule in number 5.

#### sudo ufw status numbered

Output will be shown below.

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    Anywhere                  
[ 2] 80/tcp                     ALLOW IN    Anywhere                  
[ 3] 3306                       ALLOW IN    10.0.0.0/24               
[ 4] 22 (v6)                    ALLOW IN    Anywhere (v6)             
[ 5] 80/tcp (v6)                ALLOW IN    Anywhere (v6)


## Task:

Allow all traffic that is coming from the following IP address 207.45.232.181.

Is the rule added to allow access from IP address specified?

## Solution:

Execute the below command to complete this task.

#### sudo ufw allow from 207.45.232.181


## Task:

Allow all traffic coming from any IP in this network range: 10.11.12.0 to 10.11.12.255 (i.e., 10.11.12.0/24). Add the required rule.

Has the required firewall rule been added?

## Solution:

Execute the below command:

#### sudo ufw allow from 10.11.12.0/24 


## Task:

A rule allow from 192.168.0.4 to any port 22 was added to the firewall, which is the port configured to rule one.


## Solution:

Execute below command and check the output for rule number 1

#### sudo ufw status numbered

Answer is 22


## Task:

There's a firewall rule that denies any traffic coming from the 10.0.0.19 IP address. But this rule is in an incorrect spot (after an allow rule for the 10.0.0.0/24 range). So traffic is never denied because the rule is never matched. Correct this mistake.

Is the rule inserted as number 1 ?

## Solution:

First check for number of rule

#### ~ ➜  sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    192.168.0.0/24            
[ 2] 22                         ALLOW IN    192.168.0.4               
[ 3] 22                         ALLOW IN    Anywhere                  
[ 4] 80                         ALLOW IN    Anywhere                  
[ 5] 53/tcp                     ALLOW IN    Anywhere                  
[ 6] Anywhere                   ALLOW IN    207.45.232.181            
[ 7] Anywhere                   ALLOW IN    10.11.12.0/24             
[ 8] 3306                       ALLOW IN    10.0.0.0/24               
[ 9] 22 (v6)                    ALLOW IN    Anywhere (v6)             
[10] 80 (v6)                    ALLOW IN    Anywhere (v6)             
[11] 53/tcp (v6)                ALLOW IN    Anywhere (v6)             

Delete the rule as per requirement

#### ~ ➜  sudo ufw delete 8
Deleting:
 allow from 10.0.0.0/24 to any port 3306
Proceed with operation (y|n)? y
Rule deleted

Insert rule using the below command

#### ~ ➜ sudo ufw insert 1 deny from 10.0.0.19
Rule inserted

Check status again

#### ~ ➜ sudo ufw status numbered












