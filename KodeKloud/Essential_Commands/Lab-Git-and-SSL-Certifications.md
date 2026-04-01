# Lab - Git & SSL Certifications

## Task:

Generate a 4096-bit RSA private key and a Certificate Signing Request with a single command. The private key should be encrypted with the following password: "kkloud".

Save the key in a file called priv.key. Save the CSR in a file called cert.csr. There are no requirements for the certificate details like country name, organisation name, and so on. You can pick anything, or press Enter to pick the default values when prompted.

Private key is created?

Certificate signing request is created?

<details><summary>Answer</summary>
Use the below command to generate a key and certificate signing request.

### openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

and enter password when it prompts like below

Enter PEM pass phrase:kkloud
Verifying - Enter PEM pass phrase:kkloud

Leave rest of the options default
</details>

### Explanation:
- openssl → tool for SSL/TLS and cryptography operations
- req → generate certificate requests
- -newkey rsa:4096 → create a new 4096-bit RSA private key
- -keyout priv.key → save private key to file
- -out cert.csr → save certificate signing request to file
- passphrase → encrypts the private key with provided password

---

## Task:

Generate a self-signed certificate

- Use no encryption for the private key.
- Save the key in a file called priv.key.
- Set the expiration for the certificate to 365 days.
- Save the certificate in a file called kodekloud.crt.

Set the Common Name to kodekloud.com. The rest of the certificate details you can set to whatever you want.

Common name is set as kodekloud.com ?

<details><summary>Answer</summary>
You can use the below command to generate a key and self-signed certificate.

openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt
Enter kodekloud.com for common name
</details>

### Explanation:
- openssl → cryptography tool
- req → certificate request utility
- -x509 → generate a self-signed certificate
- -noenc → do not encrypt the private key
- -days 365 → certificate validity period
- -keyout priv.key → output private key file
- -out kodekloud.crt → output certificate file
- Common Name → identifies the domain (kodekloud.com)

---

## Task:

In your /home/bob/ directory you will find a file called my.crt. What is the Common Name set in this certificate?

<details><summary>Answer</summary>
Identify the CN by below command

#### openssl x509 -in my.crt -text

in the output of the command Identify the common name.

CN = labs.kodekloud.com
</details>

### Explanation:
- openssl → cryptography tool
- x509 → work with certificates
- -in my.crt → input certificate file
- -text → display certificate details in readable format
- CN → Common Name field in certificate

---

## Task:

We've created a local Git repository for you.

- Please switch to the directory called /root/kode to access it.
- You can stage all the files with the .cpp extension to prepare them for a future commit. The other files should NOT be staged.
- Next, create a commit with the following message: Added C++ files.

File3 with .txt extension is untracked?

Commit message is set correctly?

<details><summary>Answer</summary>
Navigate to directory kode

### cd kode
Stage the files with .cpp extension.

### git add *.cpp
Commit the files with the commit message Added C++ files

### git commit -m "Added C++ files"
</details>

### Explanation:
- cd kode → change into repository directory
- git add *.cpp → stage only .cpp files
- *.cpp → wildcard matching all .cpp files
- git commit → create a commit
- -m "Added C++ files" → commit message

---

## Task:

Switch to the Git repository that can be found in the kode directory. Create a new branch called testing.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

Git branch with the name testing is created?

<details><summary>Answer</summary>
Navigate to kode directory.
Use the below command to create a branch with the name testing.

### git branch testing
</details>

### Explanation:
- git branch testing → create a new branch named testing
- branch → represents a separate line of development

---

## Task:

In the local Git repository that can be found in the kode directory do the following:

- Delete the branch called "testing".
- The error you will encounter is expected.

Figure out what is preventing you from performing the task, solve the issue, and then delete the "testing" branch?

Branch with name testing is deleted?

<details><summary>Answer</summary>
Navigate to kode directory.

### cd kode
Check out to master branch first because active branches can't be deleted.

### git checkout master
Delete the testing branch now

### git branch --delete testing
</details>

### Explanation:
- cd kode → change into repository directory
- git checkout master → switch to master branch
- active branch → cannot be deleted while checked out
- git branch --delete testing → delete branch named testing

---

## Task:

Go into the local Git repository found in the kode directory and find the file that modified in latest commit.

<details><summary>Answer</summary>
Check for the file modified in the latest commit.

### git log --raw

You will find output similar to below one.

### commit 6a64b289a71e970f94bcb6b0bd07424a05a98b83 (HEAD -> master)
Author: Bob <bob@kodekloud.com>
Date:   Fri Feb 16 09:11:41 2024 +0000

    Added text

:100644 100644 e69de29 a11f211 M        file2.cpp

We can find the file file2.cpp is modified.
</details>

### Explanation:
- git log → view commit history
- --raw → show file-level changes in commits
- M → indicates file was modified
- file2.cpp → file changed in latest commit

---

## Task:

Go into the local Git repository that you can find in the kode directory. Merge the documentation branch into the master branch.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

documentation branch merged to the master branch ?

<details><summary>Answer</summary>
Navigate to kode directory.

### cd kode

To merge the documentation branch to the master branch we need to checkout in the master branch first.

### git checkout master

Now merge the documentation branch to the master branch.

### git merge documentation
</details>

### Explanation:
- cd kode → change into repository directory
- git checkout master → switch to master branch
- git merge documentation → merge documentation branch into master
- merge → combine changes from another branch

---

## Task:

What command would you use to push the master branch from your local repository to a remote repository nicknamed origin?

<details><summary>Answer</summary>
### git push origin master 
is the command we use to push changes to master branch of remote repository.
</details>

### Explanation:
- git push → send commits to remote repository
- origin → remote repository name
- master → branch being pushed

---

## Task:

Clone the remote repository from https://github.com/kodekloudhub/git-for-beginners-course.git in your /home/bob/ directory. A subdirectory for the local repository will be automatically created.

Repository cloned ?

<details><summary>Answer</summary>
Navigate to /home/bob directory by cd /home/bob
Clone the repo by below command

### git clone https://github.com/kodekloudhub/git-for-beginners-course.git
</details>

### Explanation:
- cd /home/bob → change to target directory
- git clone → copy remote repository locally
- URL → location of remote repository
- result → new directory created with repository contents
