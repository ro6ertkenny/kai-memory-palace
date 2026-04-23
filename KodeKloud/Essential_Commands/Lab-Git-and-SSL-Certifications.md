# Lab - Git & SSL Certifications

## Task:

Generate a 4096-bit RSA private key and a Certificate Signing Request with a single command. The private key should be encrypted with the following password: "kkloud".

Save the key in a file called priv.key. Save the CSR in a file called cert.csr. There are no requirements for the certificate details like country name, organisation name, and so on. You can pick anything, or press Enter to pick the default values when prompted.

Private key is created?

Certificate signing request is created?

<details><summary>Answer</summary>

Use the below command to generate a key and certificate signing request.

 #### openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

and enter password when it prompts like below

Enter PEM pass phrase:kkloud
Verifying - Enter PEM pass phrase:kkloud

Leave rest of the options default

### Explanation:
- openssl → tool for SSL/TLS and cryptography operations
- req → generate certificate requests
- -newkey rsa:4096 → create a new 4096-bit RSA private key
        rsa:4096 = algorithm:size
- -keyout priv.key → save private key to file
- -out cert.csr → save certificate signing request to file
- passphrase → encrypts the private key with provided password

## What Does RSA Mean?

## 🧠 Short Answer

> **RSA = Rivest, Shamir, Adleman**

👉 the last names of the three creators.

## 🔍 Who?

- Rivest  
- Shamir  
- Adleman  

They created the RSA algorithm.

## 🧠 What RSA Is

> A **public-key encryption algorithm**

Used for:
- SSH keys  
- SSL/TLS  
- secure communication  

## 🔥 Mental Model

    RSA = lock with two keys

- public key → share it  
- private key → keep it secret  

</details>

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

#### openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt

Enter kodekloud.com for common name

### Explanation:
- openssl → cryptography tool
- req → certificate request utility
- -x509 → generate a self-signed certificate
- -noenc → do not encrypt the private key
- -days 365 → certificate validity period
- -keyout priv.key → output private key file
- -out kodekloud.crt → output certificate file
- Common Name → identifies the domain (kodekloud.com)

## Why Do You Use `x509` Here?

> Because:

    .crt file = X.509 certificate

So you use:

    openssl x509

to read it.

## 🔍 What Is X.509?

> X.509 is the **standard format for certificates**

Used in:
- SSL/TLS  
- HTTPS  
- SSH (sometimes indirectly)

    file type → determines subcommand

## File Types → OpenSSL Commands

| File | Use |
|-----|-----|
| `.key` | private key |
| `.csr` | certificate request → `openssl req` |
| `.crt` / `.pem` | certificate → `openssl x509` |

## 🔥 So Here:

Task gives:

    my.crt

👉 that tells you:

> this is a certificate


## Therefore:

    openssl x509 -in my.crt -text

## 🧠 How You “Know”

You’re mapping:

    file type → tool

## 🔁 Memory Hook

    crt = certificate → x509

## 🧪 What `-text` Does

    -text

👉 prints human-readable details

Including:

    CN = labs.kodekloud.com

## 🔁 1-Line Recall

    Use `openssl x509` for `.crt` files because they are X.509 certificates.

</details>

---

## Task:

In your /home/bob/ directory you will find a file called my.crt. What is the Common Name set in this certificate?

<details><summary>Answer</summary>
Identify the CN by below command

#### openssl x509 -in my.crt -text

in the output of the command Identify the common name.

CN = labs.kodekloud.com

### Explanation:
- openssl → cryptography tool
- x509 → work with certificates
- -in my.crt → input certificate file
- -text → display certificate details in readable format
- CN → Common Name field in certificate

</details>

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

#### cd kode
Stage the files with .cpp extension.

#### git add *.cpp
Commit the files with the commit message Added C++ files

#### git commit -m "Added C++ files"

### Explanation:
- cd kode → change into repository directory
- git add *.cpp → stage only .cpp files
- *.cpp → wildcard matching all .cpp files
- git commit → create a commit
- -m "Added C++ files" → commit message

</details>

---

## Task:

Switch to the Git repository that can be found in the kode directory. Create a new branch called testing.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

Git branch with the name testing is created?

<details><summary>Answer</summary>
Navigate to kode directory.
Use the below command to create a branch with the name testing.

#### git branch testing

### Explanation:
- git branch testing → create a new branch named testing
- branch → represents a separate line of development

## Is a Git Branch Just a Folder?

## 🧠 Short Answer

> ❌ NO — a branch is NOT a folder/directory

## 🔥 What a Branch REALLY Is

> A branch is:

**a pointer to a commit**

## 🧠 Mental Model

    branch = movable label → points to a commit

## 🔍 Example

When you run:

    git branch testing

👉 Git creates:

    a new pointer called "testing"

pointing to the current commit.

## ⚠️ No New Folder Is Created

Nothing new appears like:

    /testing/

❌ that does NOT happen.

# 🔍 Where Does It Exist Then?

Inside Git’s internal data:

    .git/

## Specifically:

    .git/refs/heads/testing

👉 this file stores the commit reference.

## 🧠 Think Like This

    commits = snapshots

    branch  = name pointing to a snapshot

## 🔥 What Happens When You Switch

    git checkout testing

👉 now:

- your working directory changes  
- files update to match that branch  

## 🧠 Why It FEELS Like a Folder

Because:

- files change  
- project state changes  

But:

👉 it's just Git moving the pointer and updating files

## 🔁 Memory Hook

    branch = pointer, not folder

## 🔁 1-Line Recall

    A Git branch is a pointer to a commit, not a directory on your system.

</details>

---

## Task:

In the local Git repository that can be found in the kode directory do the following:

- Delete the branch called "testing".
- The error you will encounter is expected.

Figure out what is preventing you from performing the task, solve the issue, and then delete the "testing" branch?

Branch with name testing is deleted?

<details><summary>Answer</summary>
Navigate to kode directory.

#### cd kode
Check out to master branch first because active branches can't be deleted.

#### git checkout master
Delete the testing branch now

#### git branch --delete testing

### Explanation:
- cd kode → change into repository directory
- git checkout master → switch to master branch
- active branch → cannot be deleted while checked out
- git branch --delete testing → delete branch named testing

</details>

---

## Task:

Go into the local Git repository found in the kode directory and find the file that modified in latest commit.

<details><summary>Answer</summary>
Check for the file modified in the latest commit.

#### git log --raw

You will find output similar to below one.

#### commit 6a64b289a71e970f94bcb6b0bd07424a05a98b83 (HEAD -> master)
Author: Bob <bob@kodekloud.com>
Date:   Fri Feb 16 09:11:41 2024 +0000

    Added text

:100644 100644 e69de29 a11f211 M        file2.cpp

We can find the file file2.cpp is modified.

### Explanation:
- git log → view commit history
- --raw → show file-level changes in commits
- M → indicates file was modified
- file2.cpp → file changed in latest commit

    git log        → summary view

    git log --raw  → summary + low-level file changes

## 🔥 How To FORCE Seeing The Difference

Try:

    git log --raw -1

👉 shows raw details for latest commit

</details>

---

## Task:

Go into the local Git repository that you can find in the kode directory. Merge the documentation branch into the master branch.

NOTE: If you encounter an error while using a Git command, please exit the current directory and then re-enter it.

documentation branch merged to the master branch ?

<details><summary>Answer</summary>
Navigate to kode directory.

#### cd kode

To merge the documentation branch to the master branch we need to checkout in the master branch first.

#### git checkout master

Now merge the documentation branch to the master branch.

#### git merge documentation

### Explanation:
- cd kode → change into repository directory
- git checkout master → switch to master branch
- git merge documentation → merge documentation branch into master
- merge → combine changes from another branch

</details>

---

## Task:

What command would you use to push the master branch from your local repository to a remote repository nicknamed origin?

<details><summary>Answer</summary>

    git push origin master 

is the command we use to push changes to master branch of remote repository.

### Explanation:
- git push → send commits to remote repository
- origin → remote repository name
- master → branch being pushed

</details>
---

## Task:

Clone the remote repository from https://github.com/kodekloudhub/git-for-beginners-course.git in your /home/bob/ directory. A subdirectory for the local repository will be automatically created.

Repository cloned ?

<details><summary>Answer</summary>
Navigate to /home/bob directory by cd /home/bob
Clone the repo by below command

    git clone https://github.com/kodekloudhub/git-for-beginners-course.git

### Explanation:
- cd /home/bob → change to target directory
- git clone → copy remote repository locally
- URL → location of remote repository
- result → new directory created with repository contents

</details>
