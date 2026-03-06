# Lab - Git & SSL Certificates

## Task

Generate a 4096-bit RSA private key and a Certificate Signing Request with a single command. The private key should be encrypted with the following password: "kkloud".


Save the key in a file called priv.key. Save the CSR in a file called cert.csr. There are no requirements for the certificate details like country name, organisation name, and so on. You can pick anything, or press Enter to pick the default values when prompted.


Private key is created?

Certificate signing request is created?

## Solution:

Use the below command to generate a key and certificate signing request.

### openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr
and enter password when it prompts like below

Enter PEM pass phrase:kkloud
Verifying - Enter PEM pass phrase:kkloud
Leave rest of the options default.


## Task:

Generate a self-signed certificate

Use no encryption for the private key.
Save the key in a file called priv.key.
Set the expiration for the certificate to 365 days.
Save the certificate in a file called kodekloud.crt.
Set the Common Name to kodekloud.com. The rest of the certificate details you can set to whatever you want.

Common name is set as kodekloud.com ?

## Solution:

You can use the below command to generate a key and self-signed certificate.

openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt
Enter kodekloud.com for common name

## Task:

In your /home/bob/ directory you will find a file called my.crt. What is the Common Name set in this certificate?

## Solution:

Identify the CN by below command

### openssl x509 -in my.crt -text
in the output of the command Identify the common name.

CN = labs.kodekloud.com

## Task:

We've created a local Git repository for you.

Please switch to the directory called /root/kode to access it.
You can stage all the files with the .cpp extension to prepare them for a future commit. The other files should NOT be staged.
Next, create a commit with the following message: Added C++ files.


File3 with .txt extension is untracked?

Commit message is set correctly?

## Solution:

Navigate to directory kode

#### cd kode
Stage the files with .cpp extension.

#### git add *.cpp
Commit the files with the commit message Added C++ files

#### git commit -m "Added C++ files"


## Task:

Switch to the Git repository that can be found in the kode directory. Create a new branch called testing.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

Git branch with the name testing is created?

## Solution:

Navigate to kode directory.
Use the below command to create a branch with the name testing.

#### git branch testing


## Task:

In the local Git repository that can be found in the kode directory do the following:

Delete the branch called "testing".
The error you will encounter is expected.
Figure out what is preventing you from performing the task, solve the issue, and then delete the "testing" branch?

Branch with name testing is deleted?

## Solution:

Navigate to kode directory.

#### cd kode
Check out to master branch first because active branches can't be deleted.

#### git checkout master
Delete the testing branch now

#### git branch --delete testing


## Task:

Go into the local Git repository found in the kode directory and find the file that modified in latest commit.

## Solution:

Check for the file modified in the latest commit.

#### git log --raw
You will find output similar to below one.

commit 6a64b289a71e970f94bcb6b0bd07424a05a98b83 (HEAD -> master)
Author: Bob <bob@kodekloud.com>
Date:   Fri Feb 16 09:11:41 2024 +0000

    Added text

:100644 100644 e69de29 a11f211 M        file2.cpp
We can find the file file2.cpp is modified.


## Task:

Go into the local Git repository that you can find in the kode directory. Merge the documentation branch into the master branch.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

documentation branch merged to the master branch

## Solution:

Navigate to kode directory.

#### cd kode
To merge the documentation branch to the master branch we need to checkout in the master branch first.

#### git checkout master
Now merge the documentation branch to the master branch.

#### git merge documentation


## Task:

What command would you use to push the master branch from your local repository to a remote repository nicknamed origin?

## Solution:

#### git push origin master 
is the command we use to push changes to master branch of remote repository.

## Task:

Clone the remote repository from https://github.com/kodekloudhub/git-for-beginners-course.git in your /home/bob/ directory. A subdirectory for the local repository will be automatically created.

Repository cloned ?

## Solution:

Navigate to /home/bob directory by cd /home/bob
Clone the repo by below command

#### git clone https://github.com/kodekloudhub/git-for-beginners-course.git
