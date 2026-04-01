# Configure SSH Servers & Clients — LFCS Lab (Hidden Answers)

---

## 🧠 Mental Model

- /etc/ssh/sshd_config → SSH server configuration
- /etc/ssh/ssh_config → SSH client configuration (system-wide)
- Server = what YOU control
- Client = how YOU connect

---

## 🧪 Task 1

Task: Where can we edit SSH server settings?

<details>
<summary>Answer</summary>

### Command
    /etc/ssh/sshd_config

### Explanation
- sshd_config → SSH daemon (server) config file

</details>

---

## 🧪 Task 2

Task: What does this squid rule do?

    http_access allow localnetwork

<details>
<summary>Answer</summary>

### Explanation
- allows access based on ACL definition
- correct answer:
  accepts incoming connections from whatever is defined in ACL "localnetwork"

</details>

---

## 🧪 Task 3

Task: Disable SSH password logins and restart service.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/ssh/sshd_config

    PasswordAuthentication no

    sudo systemctl restart sshd

### Explanation
- PasswordAuthentication no → disable password auth
- restart required to apply changes

</details>

---

## 🧪 Task 4

Task: Enable X11 forwarding in SSH client config.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/ssh/ssh_config

    ForwardX11 yes

### Explanation
- ssh_config → client config
- ForwardX11 → enable GUI forwarding over SSH

</details>

---

## 🧪 Task 5

Task: Install and start squid proxy server.

<details>
<summary>Answer</summary>

### Command
    sudo apt install squid -y
    sudo systemctl start squid

### Explanation
- install squid package
- start squid service

</details>

---

## 🧪 Task 6

Task: Deny access to ACL localnet in squid.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/squid/squid.conf

    http_access deny localnet

### Explanation
- change allow → deny
- blocks access for localnet ACL

</details>

---

## 🧪 Task 7

Task: Add ACL vpn (203.0.110.5) and allow access.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/squid/squid.conf

    acl vpn src 203.0.110.5
    http_access allow vpn

### Explanation
- acl → define access list
- src → source IP
- allow rule must be above deny rules

</details>

---

## 🧪 Task 8

Task: Configure SSH server to use IPv4 only.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/ssh/sshd_config

    AddressFamily inet

### Explanation
- inet → IPv4 only
- disables IPv6 usage

</details>

---

## 🧪 Task 9

Task: Allow squid access to external ACL.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/squid/squid.conf

    http_access allow external

### Explanation
- allows traffic defined in ACL "external"
- placement matters (before deny rules)

</details>

---

## 🧪 Task 10

Task: Block facebook.com using squid.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/squid/squid.conf

    acl facebook dstdomain .facebook.com
    http_access deny facebook

### Explanation
- dstdomain → match destination domain
- .facebook.com → includes subdomains
- deny rule blocks access

</details>

---

## 🧪 Task 11

Task: Enable SSH password login and disable root login.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/ssh/sshd_config

    PasswordAuthentication yes
    PermitRootLogin no

    sudo systemctl restart sshd

### Explanation
- enable password login
- disable root login for security
- restart required

</details>

---

## 🧪 Task 12

Task: Set max authentication attempts to 4.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/ssh/sshd_config

    MaxAuthTries 4

### Explanation
- limits login attempts per connection
- helps prevent brute-force attacks

</details>
