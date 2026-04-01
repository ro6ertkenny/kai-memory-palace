# Kernel Runtime Parameters & SELinux/AppArmor — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Find the SELinux label of the sshd process and save it in /home/bob/sshd.

<details>
<summary>Answer</summary>

### Command
    ps auxZ | grep sshd | awk '{print $1}' | head -n1 > /home/bob/sshd

### Explanation
- ps auxZ → show processes with SELinux context
- grep sshd → filter sshd process
- awk '{print $1}' → extract SELinux context
- head -n1 → take first match
- `>` → save output

</details>

---

## 🧪 Task 2

Task: Enable kernel.modules_disabled runtime parameter.

<details>
<summary>Answer</summary>

### Command
    sudo sysctl -w kernel.modules_disabled=1

### Explanation
- sysctl -w → set runtime kernel parameter
- kernel.modules_disabled=1 → disable loading new modules

</details>

---

## 🧪 Task 3

Task: Find SELinux type of /bin/sudo and save it in /home/bob/selabel.

<details>
<summary>Answer</summary>

### Command
    ls -Z /bin/sudo | awk '{print $1}' | cut -d: -f3 > /home/bob/selabel

### Explanation
- ls -Z → show SELinux context
- awk '{print $1}' → extract full context
- cut -d: -f3 → extract type field only
- `>` → save output
- expected value → sudo_exec_t

</details>

---

## 🧪 Task 4

Task: Enable kernel parameter net.ipv6.conf.lo.seg6_enabled.

<details>
<summary>Answer</summary>

### Command
    sudo sysctl -w net.ipv6.conf.lo.seg6_enabled=1

### Explanation
- sysctl -w → apply runtime parameter
- =1 → enable setting

</details>

---

## 🧪 Task 5

Task: Set vm.swappiness to 10 and make it persistent.

<details>
<summary>Answer</summary>

### Command
    sudo sysctl -w vm.swappiness=10
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

### Explanation
- sysctl -w → apply immediately
- /etc/sysctl.conf → persistent config
- sysctl -p → reload config

</details>

---

## 🧪 Task 6

Task: Change SELinux context of /var/index.html to httpd_sys_content_t.

<details>
<summary>Answer</summary>

### Command
    sudo chcon -t httpd_sys_content_t /var/index.html

### Explanation
- chcon → change SELinux context
- -t → type field
- httpd_sys_content_t → web server content type

</details>

---

## 🧪 Task 7

Task: Temporarily set SELinux to permissive mode.

<details>
<summary>Answer</summary>

### Command
    sudo setenforce 0

### Explanation
- setenforce → change SELinux mode
- 0 → permissive (log only, no enforcement)

</details>

---

## 🧪 Task 8

Task: Find SELinux roles for staff_u and save them in /home/bob/serole.

<details>
<summary>Answer</summary>

### Command
    semanage user -l | grep staff_u | awk '{print $3}' > /home/bob/serole

### Explanation
- semanage user -l → list SELinux users
- grep staff_u → filter user
- awk '{print $3}' → extract roles field
- `>` → save output

</details>

---

## 🧪 Task 9

Task: Restore default SELinux labels for /var/log recursively.

<details>
<summary>Answer</summary>

### Command
    sudo restorecon -R /var/log/

### Explanation
- restorecon → restore default SELinux context
- -R → recursive
- fixes incorrect labels

</details>
