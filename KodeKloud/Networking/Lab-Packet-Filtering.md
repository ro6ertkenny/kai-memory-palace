# Packet Filtering (UFW) — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Enable UFW and allow SSH (port 22).

<details>
<summary>Answer</summary>

### Command
    sudo ufw enable
    sudo ufw allow 22

### Explanation
- ufw enable → activate firewall
- allow 22 → allow SSH traffic
- critical to avoid locking yourself out

</details>

---

## 🧪 Task 2

Task: Allow incoming traffic on port 80.

<details>
<summary>Answer</summary>

### Command
    sudo ufw allow 80

### Explanation
- allow → permit traffic
- 80 → HTTP port

</details>

---

## 🧪 Task 3

Task: Allow incoming traffic on port 53 using TCP.

<details>
<summary>Answer</summary>

### Command
    sudo ufw allow 53/tcp

### Explanation
- 53/tcp → DNS over TCP
- explicitly specify protocol

</details>

---

## 🧪 Task 4

Task: Deny incoming traffic on port 443 using TCP.

<details>
<summary>Answer</summary>

### Command
    sudo ufw deny 443/tcp

### Explanation
- deny → block traffic
- 443/tcp → HTTPS port

</details>

---

## 🧪 Task 5

Task: Delete the rule denying traffic on port 443/tcp.

<details>
<summary>Answer</summary>

### Command
    sudo ufw delete deny 443/tcp

### Explanation
- delete → remove matching rule
- must match rule exactly

</details>

---

## 🧪 Task 6

Task: Identify rule number 5.

<details>
<summary>Answer</summary>

### Command
    sudo ufw status numbered

### Explanation
- shows rules with numbering
- rule [5] corresponds to:
    80/tcp (v6) ALLOW IN Anywhere (v6)

</details>

---

## 🧪 Task 7

Task: Allow all traffic from IP 207.45.232.181.

<details>
<summary>Answer</summary>

### Command
    sudo ufw allow from 207.45.232.181

### Explanation
- allow from → permit all traffic from specific IP

</details>

---

## 🧪 Task 8

Task: Allow all traffic from network 10.11.12.0/24.

<details>
<summary>Answer</summary>

### Command
    sudo ufw allow from 10.11.12.0/24

### Explanation
- CIDR notation → defines network range
- /24 → 256 IP addresses

</details>

---

## 🧪 Task 9

Task: Identify the port configured in rule allowing traffic from 192.168.0.4.

<details>
<summary>Answer</summary>

### Command
    sudo ufw status numbered

### Explanation
- find rule with source 192.168.0.4
- associated port is 22

</details>

---

## 🧪 Task 10

Task: Fix rule order so deny from 10.0.0.19 is evaluated before allow rules.

<details>
<summary>Answer</summary>

### Command
    sudo ufw status numbered
    sudo ufw delete <rule_number_of_allow>
    sudo ufw insert 1 deny from 10.0.0.19

### Explanation
- UFW rules are processed top → bottom
- first match wins
- insert 1 → place rule at top (highest priority)
- ensures deny rule is evaluated before allow

</details>
