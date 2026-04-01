# Git & SSL Certificates — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Generate a 4096-bit RSA private key and a Certificate Signing Request with a single command. The private key should be encrypted with the following password: "kkloud".

Save the key in a file called priv.key. Save the CSR in a file called cert.csr. There are no requirements for the certificate details like country name, organisation name, and so on. You can pick anything, or press Enter to pick the default values when prompted.

<details>
<summary>Answer</summary>

### Command
    openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

### Explanation
- openssl req → create or process certificate requests
- -newkey rsa:4096 → generate a new 4096-bit RSA key
- -keyout priv.key → save private key to priv.key
- -out cert.csr → save CSR to cert.csr
- the command will prompt for the PEM pass phrase
- enter `kkloud` when prompted to encrypt the private key

</details>

---

## 🧪 Task 2

Task: Generate a self-signed certificate.

- Use no encryption for the private key.
- Save the key in a file called priv.key.
- Set the expiration for the certificate to 365 days.
- Save the certificate in a file called kodekloud.crt.

Set the Common Name to kodekloud.com. The rest of the certificate details you can set to whatever you want.

<details>
<summary>Answer</summary>

### Command
    openssl req -x509 -nodes -days 365 -keyout priv.key -out kodekloud.crt

### Explanation
- openssl req → certificate request / certificate creation mode
- -x509 → create a self-signed certificate instead of a CSR
- -nodes → no DES encryption on private key, meaning no passphrase
- -days 365 → certificate valid for 365 days
- -keyout priv.key → save private key
- -out kodekloud.crt → save certificate
- set the Common Name to `kodekloud.com` when prompted

</details>

---

## 🧪 Task 3

Task: In your /home/bob/ directory you will find a file called my.crt. What is the Common Name set in this certificate?

<details>
<summary>Answer</summary>

### Command
    openssl x509 -in /home/bob/my.crt -text -noout

### Explanation
- openssl x509 → inspect X.509 certificates
- -in /home/bob/my.crt → certificate file to read
- -text → show human-readable certificate details
- -noout → do not print the encoded certificate
- look for the Subject field and identify the `CN`
- expected answer from the lab: `labs.kodekloud.com`

</details>

---

## 🧪 Task 4

Task: We've created a local Git repository for you.

- Please switch to the directory called /root/kode to access it.
- You can stage all the files with the .cpp extension to prepare them for a future commit. The other files should NOT be staged.
- Next, create a commit with the following message: Added C++ files.

<details>
<summary>Answer</summary>

### Command
    cd /root/kode
    git add *.cpp
    git commit -m "Added C++ files"

### Explanation
- cd /root/kode → enter the repository
- git add *.cpp → stage only files ending in `.cpp`
- git commit -m "Added C++ files" → create commit with exact message
- `.txt` files remain unstaged and untracked if not added

</details>

---

## 🧪 Task 5

Task: Switch to the Git repository that can be found in the kode directory. Create a new branch called testing.

<details>
<summary>Answer</summary>

### Command
    cd kode
    git branch testing

### Explanation
- git branch testing → create a new branch named `testing`
- this creates the branch but does not switch to it

</details>

---

## 🧪 Task 6

Task: In the local Git repository that can be found in the kode directory do the following:

- Delete the branch called "testing".
- The error you will encounter is expected.

Figure out what is preventing you from performing the task, solve the issue, and then delete the "testing" branch.

<details>
<summary>Answer</summary>

### Command
    cd kode
    git checkout master
    git branch --delete testing

### Explanation
- a branch cannot be deleted while it is the currently checked out branch
- git checkout master → switch off the `testing` branch
- git branch --delete testing → delete the branch safely

</details>

---

## 🧪 Task 7

Task: Go into the local Git repository found in the kode directory and find the file that modified in latest commit.

<details>
<summary>Answer</summary>

### Command
    cd kode
    git log --raw -1

### Explanation
- git log → show commit history
- --raw → show file-level change details
- -1 → only show the latest commit
- inspect the modified file listed in the output
- expected lab answer: `file2.cpp`

</details>

---

## 🧪 Task 8

Task: Go into the local Git repository that you can find in the kode directory. Merge the documentation branch into the master branch.

<details>
<summary>Answer</summary>

### Command
    cd kode
    git checkout master
    git merge documentation

### Explanation
- git checkout master → switch to target branch
- git merge documentation → merge `documentation` into `master`

</details>

---

## 🧪 Task 9

Task: What command would you use to push the master branch from your local repository to a remote repository nicknamed origin?

<details>
<summary>Answer</summary>

### Command
    git push origin master

### Explanation
- git push → send local commits to remote
- origin → remote nickname
- master → branch to push

</details>

---

## 🧪 Task 10

Task: Clone the remote repository from https://github.com/kodekloudhub/git-for-beginners-course.git in your /home/bob/ directory. A subdirectory for the local repository will be automatically created.

<details>
<summary>Answer</summary>

### Command
    cd /home/bob
    git clone https://github.com/kodekloudhub/git-for-beginners-course.git

### Explanation
- cd /home/bob → go to target parent directory
- git clone → download remote repository
- Git automatically creates the local repo directory based on the repository name

</details>
