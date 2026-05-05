# Lab - Kernel Runtime Parameters and SELinux/AppArmor

## Task:

Find the SELinux labels of sshd process running on this system. Save its value in the /home/bob/sshd file.

Verify the SELinux context.

<details><summary>Answer</summary>
Execute the below command:

#### ps auxZ | grep sshd

Copy the SELinux context from the output and save it in the /home/bob/sshd file.

#### vi /home/bob/sshd

For example, if the context is system_u:system_r:initrc_t:s0, then the file contents should be:

#### system_u:system_r:initrc_t:s0

### Explanation:
- ps → display running processes
- aux → detailed process listing
- Z → show SELinux security context
- grep sshd → filter for sshd process
- SELinux context → format user:role:type:level
- vi → manually save context
- /home/bob/sshd → destination file

### `a`
👉 show processes for **ALL users**

### `u`
👉 show **user-oriented format**

👉 adds columns like:
- USER
- CPU %
- MEM %
- START TIME

### `x`
👉 include processes **not attached to a terminal**

👉 (background daemons like `sshd`)

---

## 🧠 SIMP MEMORY

👉 Think:

> 🗣️ “a = all users, u = user view, x = everything”

### 'Z'
> 🗣️ “Z = Zero-Trust / Security Context”
👉 Not official — but VERY helpful mentally:

- SELinux = security layer
- `Z` = “show security labels”

## 🧠 ANOTHER WAY TO REMEMBER

👉 Look at what it adds:

    system_u:system_r:sshd_t:s0

👉 That’s a **security label**

👉 So think:

> 🗣️ “Z shows security zoning”

🧠 What is SELinux?

👉 SELinux = Security-Enhanced Linux

SELinux = extra security layer that controls what processes are ALLOWED to do

Even if permissions say “yes” → SELinux can still say “NO”

Linux permissions = who owns the file

SELinux = what the process is allowed to do

🔥 Two layers of control

Layer	Controls
Permissions (chmod)	users & groups
SELinux	process behavior

</details>

---

## Task:

Turn on kernel.modules_disabled kernel runtime parameter, so that loading new kernel modules will be disabled.

Check if the kernel.modules_disabled kernel runtime parameter is turned on.

<details><summary>Answer</summary>
Execute the below command:

#### sysctl -w kernel.modules_disabled=1

### Explanation:
- sysctl → view or modify kernel runtime parameters
- -w → write/change parameter value
- kernel.modules_disabled → parameter controlling module loading
- =1 → disable loading of new kernel modules

| Setting | Meaning                          |
|--------|----------------------------------|
| =1     | disable module loading ❌         |
| =0     | allow module loading ✅          |

👉 Once set to:

    =1

👉 You CANNOT re-enable module loading without reboot

</details>

---

## Task:

Check out the SELinux label for the file stored at /bin/sudo. Ignore the SELinux user and role here.
What is the SELinux type used on this file? Save its value in /home/bob/selabel file.

Verify the label.

<details><summary>Answer</summary>
Execute the below command:

#### ls -Z /bin/sudo

You should see sudo_exec_t in the output. Save it in the /home/bob/selabel file:

#### vi /home/bob/selabel

### Explanation:
- ls → list file details
- -Z → display SELinux context
- /bin/sudo → target file
- sudo_exec_t → SELinux type for sudo binary
- vi → manually save value
- /home/bob/selabel → destination file

</details>

---

## Task:

Use the sysctl command to make sure this kernel runtime parameter is actively enabling its settings:

#### net.ipv6.conf.lo.seg6_enabled

Is kernel runtime parameter enabled?

<details><summary>Answer</summary>
Use the below command:

#### sysctl -w net.ipv6.conf.lo.seg6_enabled=1

### Explanation:
- sysctl → manage kernel parameters
- -w → write/change parameter value
- net.ipv6.conf.lo.seg6_enabled → IPv6 Segment Routing setting for loopback
- =1 → enable the parameter

</details>

---

## Task:

Adjust the value of this kernel runtime parameter, vm.swappiness, to 10.

After you set this to 10, also make the change persistent so that it will be auto-set to this value on the next reboot.

Is the required value set for vm.swappiness?

<details><summary>Answer</summary>
Edit the /etc/sysctl.conf file:

#### vi /etc/sysctl.conf

Add the below code in this file and save it:

#### vm.swappiness=10

Apply the changes:

#### sysctl -p

### Explanation:
- /etc/sysctl.conf → persistent kernel parameter configuration file
- vi → edit configuration file
- vm.swappiness=10 → reduce swap usage preference
- sysctl -p → apply configuration without reboot
- `-p` stands for: **“load parameters from a file”** | “pull parameters from config file”

</details>

---

## Task:

Change the SELinux context of /var/index.html file to httpd_sys_content_t

Is SELinux context updated for the /var/index.html file?

<details><summary>Answer</summary>
Use the below command:

#### chcon -t httpd_sys_content_t /var/index.html

### Explanation:
- chcon → change SELinux context
- -t → set SELinux type
- httpd_sys_content_t → type for web server content
- /var/index.html → target file

</details>

---

## Task:

Temporarily change the SELinux status to Permissive on this system.

Check SELinux status.

<details><summary>Answer</summary>
Execute the below command:

#### sudo setenforce 0

### Explanation:
- setenforce → change SELinux mode
- 0 → set SELinux to permissive mode
- sudo → run with elevated privileges
- permissive → logs violations but does not enforce policies

</details>

---

## Task:

Identify the SELinux Roles for staff_u SELinux user and save the value(s) in /home/bob/serole file.

Verify the SELinux roles for "staff_u" user.

<details><summary>Answer</summary>
Execute the below command:

#### semanage user -l

Copy the SELinux Roles value for staff_u user and save it in the /home/bob/serole file:

#### vi /home/bob/serole

### Explanation:
- semanage → manage SELinux policy
- user -l → list SELinux users and roles
- staff_u → SELinux user
- roles → permissions associated with SELinux user
- vi → manually save values
- /home/bob/serole → destination file

👉 `-l` = **list**

## 🧠 CORE IDEA

👉 `semanage user -l`

👉 Means:

> 🗣️ “list SELinux users”

</details>

---

## Task:

The SELinux labels for the files in /var/log are wrong. Restore the correct (default) labels for every file and subdirectory in the /var/log directory. You only need to fix the SELinux type labels (user and role can be left as they are).

Default labels are restored for /var/log directory?

<details><summary>Answer</summary>
Run the below command to restore SELinux labels.

#### sudo restorecon -R /var/log/

### Explanation:
- restorecon → restore default SELinux contexts
- -R → apply recursively
- /var/log/ → target directory
- sudo → run with elevated privileges
- default labels → reset based on SELinux policy

</details>

