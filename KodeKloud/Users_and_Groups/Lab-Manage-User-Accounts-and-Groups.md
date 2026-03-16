# Lab - Manage User Accounts and Groups

## Task:

Set the jane user account to expire on March 1, 2030.

Has the expiration date been set for user jane?

## Solution:

Use the below command:

#### sudo usermod -e 2030-03-01 jane


## Task:

Create a system account called apachedev

Has system account "apachedev" been created?

## Solution:

Use the below command:

#### sudo useradd --system apachedev


## Task:

Jane's account, i.e., jane, is expired. Unexpire the same and make sure it never expires again.

Has Jane user account been unexpired?

## Solution:

Use the below command:

#### sudo usermod -e "" jane


## Task:

Create a user account called jack with home directory and set its default login shell to be /bin/csh.

Has user Jack been added and is its shell /bin/csh?

## Solution:

Execute the below command:

#### sudo useradd -s /bin/csh -m jack


## Task:

Delete the user account called jack and ensure his home directory is removed.

Is user Jack removed?

Is user Jack's home directory also removed?

## Solution:

Execute the below command:

#### sudo userdel -r jack


## Task:

Mark the password for jane as expired to force her to immediately change it the next time she logs in.

Is password expiration set for user Jane?

## Solution:

Execute the below command:

#### sudo chage --lastday 0 jane


## Task:

Add the user jane to the group called developers.

Is user Jane added to the developers group?

## Solution:

Execute the below command:

#### sudo usermod -a -G developers jane


## Task:

Create a group named cricket and set its GID to 9875

Is cricket group created with GID 9875?

## Solution:

Execute the below command:

#### sudo groupadd -g 9875 cricket


## Task:

You already created a group cricket in the previous question. Now, rename this group soccer while preserving the same GID.

Is the group renamed from cricket to soccer with the same GID?

## Solution:

Execute the below command:

#### sudo groupmod -n soccer cricket


## Task:

Create a user sam with UID 5322. Also, make it a member of the soccer group.

Is user sam created with UID 5322?

Is user sam a member of group soccer?

## Solution:

Execute the below command:

#### sudo useradd -G soccer sam  --uid 5322


## Task:

Update primary group of user sam and set it to rugby

Has user sam's primary group been set to "rugby"?

## Solution:

Execute the below command:

#### sudo usermod -g rugby sam


## Task:

Delete the group called appdevs.

Has the group called appdevs been deleted?


## Solution:

Execute the below command:

#### sudo groupdel appdevs


## Task:

Make sure the user jane gets a warning at least 2 days before the password expires.

Are the required changes made?

## Solution:

Execute below given command:

#### sudo chage -W 2 jane


