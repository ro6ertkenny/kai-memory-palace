# Lab - Configure User Resource Limits and User Privileges

## Task:

Which of the following keywords can we use to limit the number of processes a user can run?

<details><summary>Answer</summary>
nproc will be used to limit the number of processes a user can run.

### Explanation:
- nproc → limits the number of processes a user can run
- security limits keyword → used in limits.conf entries

> `nproc` is used inside:
> **/etc/security/limits.conf**
> `nproc` = **number of processes**

## 🔥 Step-by-Step (Exact Commands)

## Step 1 — Open the limits file
    sudo vi /etc/security/limits.conf

## Step 2 — Add a line like this

### Example: limit user `bob` to 100 processes

    bob hard nproc 100

## 🔍 Breakdown of That Line

    bob   → username  
    hard  → hard limit (cannot exceed)  
    nproc → number of processes  
    100   → max allowed  

## 🧠 Mental Model

    user → limit type → resource → value

## 🔥 Types of Limits

| Type | Meaning |
|------|--------|
| soft | warning / adjustable limit |
| hard | strict maximum |

## 🧪 Example with Both

    bob soft nproc 80
    bob hard nproc 100

👉 user:
- normally limited to 80  
- cannot exceed 100  

## ⚠️ Important

This only applies:
- after user logs out and back in  

## 🔍 How to Verify

Login as that user, then:

    ulimit -u

👉 shows max processes

## 🧠 Where `nproc` Comes From

It is a **keyword** used by:

    PAM (Pluggable Authentication Modules)

## ⚡ Mental Model (LOCK THIS IN)

    limits.conf = rulebook  
    nproc       = process limit  

## 🔁 1-Line Recall

    nproc = max number of processes a user can run

## 🧨 Operator Insight

This is used to:
- prevent runaway processes  
- stop fork bombs  
- control system resources  

</details>

---

## Task:

Modify the security limits file and make sure that the user called trinity can run no more than 30 processes in her session.
This should be both a hard limit and a soft limit, written in a single line.

Have required limits been set?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### trinity - nproc 30

Save and exit.

### Explanation:
- /etc/security/limits.conf → file for PAM resource limits
- sudo vi → edit file with elevated privileges
- trinity → target user
- - → apply both soft and hard limits
- nproc → process count limit
- 30 → maximum number of processes

## 🔍 Breakdown

    trinity   → user  
    -         → BOTH soft AND hard  
    nproc     → number of processes  
    30        → limit  

</details>

---

## Task:

Identify all the security limits currently applied in our user's session and save them in the /home/bob/limits file.

You can use the redirection to save your command's output in a file: [your-command] > /home/bob/limits

Verify the saved data.

<details><summary>Answer</summary>
Execute the below command:

#### ulimit -a > /home/bob/limits

### Explanation:
- ulimit → show or set shell resource limits
- -a → display all current limits
- '>' → redirect output to file
- /home/bob/limits → destination file

## `ulimit` — Control Resource Limits (LFCS Core)

> `ulimit` = control **resource limits for your shell session**

> `ulimit` sets or shows limits like:
- max processes  
- open files  
- memory  
- file size  

    ulimit = “how much can this shell use?”

## 🔍 What It Affects

Only:
- current shell  
- processes started from that shell  

👉 NOT system-wide (that’s `limits.conf`)

## ⚙️ Basic Commands

#### Show all limits
    ulimit -a

#### Show max processes
    ulimit -u

#### Show open files
    ulimit -n

## 🔥 Setting Limits

#### Example: limit processes
    ulimit -u 50

👉 user can run max 50 processes

#### Example: limit open files
    ulimit -n 100

# ⚠️ Soft vs Hard Limits

## Soft (default)
    ulimit -u 50

👉 can be increased (up to hard limit)

## Hard limit
    ulimit -Hu

👉 shows hard limit

## Set hard limit (requires root)
    ulimit -Hu 100

## 🧠 Mental Model

| Type | Meaning |
|------|--------|
| soft | current working limit |
| hard | maximum allowed limit |

## 🔥 Relationship to `limits.conf`

| Tool | Scope |
|------|------|
| `ulimit` | current session |
| `/etc/security/limits.conf` | persistent system-wide |

## 🧪 Example Flow

    sudo vi /etc/security/limits.conf

    bob hard nproc 100

    su - bob
    ulimit -u

👉 shows:
    100

> su - bob **switch to user `bob` with a full login environment**

## ⚡ Common Flags

| Flag | Meaning |
|------|--------|
| `-u` | max user processes |
| `-n` | max open files |
| `-f` | max file size |
| `-t` | CPU time |
| `-v` | virtual memory |

## 🔁 Memory Hook

    ulimit = user limit

## ⚠️ Important Behavior

- resets when shell closes  
- must use config files for persistence  

## 🧨 Operator Insight

Use `ulimit` to:
- test limits  
- debug issues  
- simulate restrictions  

## Final Takeaway

    ulimit

👉 controls:
> how many resources your shell session is allowed to use

</details>

---

## Task:

Modify the sudoers file in such a way to allow the user called trinity to run any sudo command without needing to provide her password.

Are required changes added for the user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity ALL=(ALL) NOPASSWD: ALL

Save and exit.

### Explanation:
- sudoers file → controls sudo permissions
- visudo → safely edit sudoers configuration
- trinity → target user
- ALL=(ALL) → may run commands as any user on any host
- NOPASSWD: ALL → no password required for any command

</details>

---

## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to only run the /usr/bin/mount command with sudo.

Are required changes added for the user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Remove the previous entry for trinity user and add the below line at the end of the /etc/sudoers file:

#### trinity ALL=(ALL) /usr/bin/mount

Save and exit.

### Explanation:
- visudo → safely edit sudoers file
- trinity → target user
- ALL=(ALL) → may run command as any user on any host
- /usr/bin/mount → only allowed sudo command
- previous entry → must be removed to avoid broader access

</details>

---

## Task:

Make changes in security limits file for user stephen so that he can create maximum filesize upto 4 MiB. This should be a hard limit.

Are required changes added for the user stephen?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the below line at the end of the file:

#### stephen hard fsize 4096

Save and exit.

### Explanation:
- /etc/security/limits.conf → resource limits file
- stephen → target user
- hard → hard limit
- fsize → maximum file size
- 4096 → size value in this limits entry
- sudo vi → edit file with privileges

</details>

---

## Task:

Set a soft limit of 20 processes for everyone in the salesteam group.

Is the required soft limit set to the salesteam group ?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Add the following line at the end of the file:

#### @salesteam     soft    nproc     20

Save and exit.

### Explanation:
- @salesteam → apply rule to group
- soft → soft limit
- nproc → process count limit
- 20 → maximum allowed processes
- /etc/security/limits.conf → limits configuration file

</details>

---

## Task:

Define a policy for all the users in the salesteam group to run any sudo command.

Is the required policy defined for salesteam group to run all sudo commands?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo

Add the below line at the end of the file:

#### %salesteam     ALL=(ALL)     ALL

Save and exit.

### Explanation:
- %salesteam → apply sudo rule to group
- ALL=(ALL) → may run commands as any user on any host
- ALL → all commands permitted
- visudo → safely edit sudoers file

## 🧠 What `visudo` Actually Does

    visudo

👉 safely opens:

    /etc/sudoers

With:
- syntax checking  
- file locking  
- error prevention  

## 🔥 Clear Explanation of This `sudoers` Rule

## Line
    %salesteam ALL=(ALL) ALL

## 🧠 What This Actually Means (Plain English)

> “Any user in the **salesteam group** can run **ANY command as ANY user on ANY machine using sudo**”

## 🔍 Break It Down Piece by Piece

## 1️⃣ `%salesteam`

👉 `%` = group

> applies this rule to:
    all users in the **salesteam group**

## 2️⃣ First `ALL`

👉 this means:
> from ANY host

## 3️⃣ `(ALL)`

👉 this means:
> can run commands **as ANY user**

## 4️⃣ Last `ALL`

👉 this means:
> can run **ANY command**

## 🧠 Mental Model (SUPER IMPORTANT)

    who → where → as who → what

## Apply That Model

    %salesteam   → who
    ALL          → where
    (ALL)        → as who
    ALL          → what

## 🔥 Full Translation

> Users in `salesteam`  
> can run commands  
> on any system  
> as any user  
> with no restrictions

## 🧪 Real Example

If `bob` is in `salesteam`:

    sudo apt update
    sudo useradd test
    sudo su -

👉 ALL allowed

## ⚠️ Why `visudo` Is Used

    sudo visudo

👉 protects you from:
- syntax errors  
- breaking sudo access  

## 🧠 Memory Hook

    %group ALL=(ALL) ALL

👉 means:
> “group can do anything with sudo”

## 🔁 1-Line Recall

    %group ALL=(ALL) ALL = full sudo access

## 🧨 Operator Insight

This is basically:

> “make this group root-equivalent”

## ⚡ Exam Pattern

If you see:
- “allow all sudo commands” → use:

    %group ALL=(ALL) ALL

## Final Takeaway

    %salesteam ALL=(ALL) ALL

👉 gives:
> full unrestricted sudo access to the entire group

## 🔍 Mental Model

    visudo = safe editor for sudoers file

</details>

---

## Task:

Define a policy so that user trinity can run sudo commands as the user sam.

Have required changes been added?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line at the end of the file:

#### trinity   ALL=(sam)   ALL

Save and exit.

### Explanation:
- trinity → user receiving sudo permission
- ALL=(sam) → may run commands as user sam
- ALL → all commands allowed in that context
- visudo → safely edit sudoers file

</details>

---

## Task:

We applied a hard limit of 10 processes for all the users under developers group, but somehow the limit isn't working. Look into the issue and fix the same.

Has the limits issue for "developers" group been fixed?

<details><summary>Answer</summary>
Edit the /etc/security/limits.conf file:

#### sudo vi /etc/security/limits.conf

Look for the developers group entry and make sure it looks like this:

#### @developers     hard    nproc  10

### Explanation:
- @developers → apply rule to group
- hard → hard limit
- nproc → process count limit
- 10 → maximum allowed processes
- correct group syntax → requires @ before group name
- /etc/security/limits.conf → file being fixed

</details>

---

## Task:

Modify the sudoers file again. Remove your previous entry for the user called trinity if it still exists.
Now add a new entry that allows trinity to run all commands with sudo, but only after entering the password.

Have required changes been made for user trinity?

<details><summary>Answer</summary>
Edit the /etc/sudoers file:

#### sudo visudo /etc/sudoers

Add the below line in the /etc/sudoers file:

#### trinity ALL=(ALL) ALL

Save and exit.

### Explanation:
- trinity → target user
- ALL=(ALL) → may run commands as any user on any host
- ALL → all commands allowed
- password required → no NOPASSWD present, so password is required
- visudo → safely edit sudoers file

# ✅ Is This Correct (Password Required)?

## Line
    trinity ALL=(ALL) ALL

## 🧠 Short Answer

> ✅ YES — this is correct  
> AND it **DOES require a password**

## 🔥 Key Insight (This Is What You Missed)

> In `sudoers`, **password is required by DEFAULT**

## 🧠 Mental Model

    no keyword → password required  
    NOPASSWD   → password NOT required  

## 🔍 Why This Works

    trinity ALL=(ALL) ALL

👉 does NOT include:

    NOPASSWD

👉 therefore:
> sudo WILL prompt for password

## 🧪 Compare Both Cases

## ✅ Password REQUIRED (your case)
    trinity ALL=(ALL) ALL

## ❌ Password NOT required
    trinity ALL=(ALL) NOPASSWD: ALL

## 🧠 Breakdown

    trinity      → user
    ALL          → any host
    (ALL)        → run as any user
    ALL          → all commands

👉 since no `NOPASSWD`:
> password is enforced

## 🔁 Memory Hook

    no NOPASSWD = password required

## ⚠️ About the Command They Gave

    sudo visudo /etc/sudoers

👉 same note as before:

## ✅ Preferred
    sudo visudo

## 🧠 Mental Model (LOCK THIS IN)

| Entry | Behavior |
|------|--------|
| `ALL=(ALL) ALL` | password required |
| `ALL=(ALL) NOPASSWD: ALL` | no password |

## ⚡ Exam Pattern

If you see:
- “require password” → DO NOTHING special  
- just avoid `NOPASSWD`

## 🔁 1-Line Recall

    password is required UNLESS you say NOPASSWD

## 🧨 Operator Insight

Default behavior in Linux:
> secure by default

👉 sudo assumes:
> password required

## Final Takeaway

    trinity ALL=(ALL) ALL

👉 is correct because:
> it allows full sudo access AND requires a password

</details>
