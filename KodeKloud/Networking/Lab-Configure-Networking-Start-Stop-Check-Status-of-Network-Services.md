# Configure Networking & Network Services — LFCS Lab (Hidden Answers)

---

## 🧪 Task 1

Task: Where do we configure static hostname resolution?

<details>
<summary>Answer</summary>

### Command
    /etc/hosts

### Explanation
- /etc/hosts → local hostname-to-IP mapping
- used before DNS lookup

</details>

---

## 🧪 Task 2

Task: How do we see processes listening on TCP and UDP ports?

<details>
<summary>Answer</summary>

### Command
    sudo ss -tunlp

### Explanation
- ss → socket statistics
- -t → TCP
- -u → UDP
- -n → numeric (no DNS resolution)
- -l → listening sockets
- -p → show process info

</details>

---

## 🧪 Task 3

Task: Identify IP address of eth0 and save it in /home/bob/ip.

<details>
<summary>Answer</summary>

### Command
    ip -o -f inet addr show eth0 | awk '{print $4}' > /home/bob/ip

### Explanation
- ip addr → show interface info
- -o → one-line output
- -f inet → IPv4 only
- awk '{print $4}' → extract IP/CIDR
- `>` → save output

</details>

---

## 🧪 Task 4

Task: Identify default gateway and save only IP in /home/bob/gateway.txt.

<details>
<summary>Answer</summary>

### Command
    ip route | awk '/default/ {print $3}' > /home/bob/gateway.txt

### Explanation
- ip route → routing table
- default → default gateway line
- $3 → gateway IP
- `>` → save output

</details>

---

## 🧪 Task 5

Task: Find PID of process listening on port 22 and save it in /home/bob/pid.

<details>
<summary>Answer</summary>

### Command
    sudo ss -tlnp | awk -F'pid=' '/:22/ {split($2,a,","); print a[1]}' > /home/bob/pid

### Explanation
- ss -tlnp → listening TCP ports with PID
- :22 → filter SSH port
- extract pid value
- `>` → save output

</details>

---

## 🧪 Task 6

Task: Find PID of process listening on port 53 and save it in /home/bob/process_pid.

<details>
<summary>Answer</summary>

### Command
    sudo ss -ulnp | awk -F'pid=' '/:53/ {split($2,a,","); print a[1]}' > /home/bob/process_pid

### Explanation
- -u → UDP (DNS uses UDP)
- -l → listening
- extract PID
- `>` → save output

</details>

---

## 🧪 Task 7

Task: Find process name listening on port 8080 and save it in /home/bob/process.

<details>
<summary>Answer</summary>

### Command
    sudo ss -tlnp | awk -F'"' '/:8080/ {print $2}' > /home/bob/process

### Explanation
- ss → preferred over netstat
- extract process name from quotes
- `>` → save output

</details>

---

## 🧪 Task 8

Task: Configure static resolution for example.com → 8.8.8.8.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/hosts

    8.8.8.8 example.com

### Explanation
- /etc/hosts → static hostname mapping
- overrides DNS

</details>

---

## 🧪 Task 9

Task: Add temporary IP 192.168.9.3/24 to eth1.

<details>
<summary>Answer</summary>

### Command
    sudo ip addr add 192.168.9.3/24 dev eth1

### Explanation
- ip addr add → assign IP
- dev eth1 → target interface
- temporary → lost on reboot

</details>

---

## 🧪 Task 10

Task: Create Netplan config for enp6s0 with IP 10.0.10.5/24.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/netplan/99-custom.yaml

    network:
      version: 2
      ethernets:
        enp6s0:
          dhcp4: false
          dhcp6: false
          addresses:
            - 10.0.10.5/24

    sudo chmod 600 /etc/netplan/99-custom.yaml
    sudo netplan apply

### Explanation
- netplan → network configuration system
- chmod 600 → required permissions
- netplan apply → apply changes

</details>

---

## 🧪 Task 11

Task: Change enp6s0 IP to 192.168.10.10/24.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/netplan/99-custom.yaml

    (update address to 192.168.10.10/24)

    sudo netplan apply

### Explanation
- modify config file
- apply changes with netplan

</details>

---

## 🧪 Task 12

Task: Save routing table to /home/bob/route.txt.

<details>
<summary>Answer</summary>

### Command
    ip route > /home/bob/route.txt

### Explanation
- ip route → show routing table
- `>` → save output

</details>

---

## 🧪 Task 13

Task: List incoming open ports and save to /home/bob/incoming.txt.

<details>
<summary>Answer</summary>

### Command
    sudo ss -tuln > /home/bob/incoming.txt

### Explanation
- ss → modern replacement for netstat
- -tuln → TCP + UDP + listening + numeric
- `>` → save output

</details>

---

## 🧪 Task 14

Task: Add global DNS resolver 8.8.8.8.

<details>
<summary>Answer</summary>

### Command
    sudo vi /etc/systemd/resolved.conf

    DNS=8.8.8.8

    sudo systemctl restart systemd-resolved

### Explanation
- resolved.conf → system-wide DNS config
- DNS= → set resolver
- restart service → apply changes

</details>
