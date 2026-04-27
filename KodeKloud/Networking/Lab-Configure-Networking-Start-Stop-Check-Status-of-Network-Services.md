# Lab - Configure Networking, Start/Stop/Check Status of Network Services

## Task:

Where do we configure static hostname resolution?

<details><summary>Answer</summary>
We can configure static hostname resolution in /etc/hosts file.

### Explanation:
- /etc/hosts → local hostname resolution file
- static mapping → manually map IP addresses to hostnames

## 🧠 What You’re Doing

> Mapping a hostname → to an IP address manually

👉 bypasses DNS completely


## 🔥 Mental Model

    /etc/hosts = local DNS override


## ⚙️ Step-by-Step Process

## 1️⃣ Open the hosts file
    sudo vi /etc/hosts


## 2️⃣ Add a new entry

Format:
    IP_ADDRESS   HOSTNAME


## 🧪 Example

    192.168.1.50   webserver
    10.0.0.25      dbserver

## 3️⃣ Save and exit

</details>

---

## Task:

How do we see what processes on our system are listening for incoming network connections, on the TCP and UDP protocols?

<details><summary>Answer</summary>
Using sudo ss -tunlp command we can see what processes on our system are listening for incoming network connections, on the TCP and UDP protocols.

####    sudo ss -tunlp

### Explanation:
- ss → socket statistics tool
- sudo → run with elevated privileges
- -t → TCP sockets
- -u → UDP sockets
- -n → show numeric addresses
- -l → show listening sockets
- -p → show process using the socket

</details>

---

## Task:

Identify the IP address of the eth0 interface on our current system.

Create a file called /home/bob/ip and save the ip address value (with subnet) in it.

Is the IP address saved in the /home/bob/ip file?

<details><summary>Answer</summary>
Execute the below command:

#### ip a

Look for the IP address of eth0 interface and copy it:

Now, create the required file and save the IP value in it:

#### vi /home/bob/ip

For example, if the IP address is 172.16.1.0/24, then add it in the file:

#### 172.16.1.0/24

Finally, save the file.

### Explanation:
- ip a → show IP addresses of interfaces
- eth0 → target interface
- CIDR notation → IP address with subnet mask
- vi → manually save value
- /home/bob/ip → destination file

## 🧠 Alternative Commands 

## ✅ Option 1 (CLEANEST — LFCS READY)

    ip -o -f inet addr show eth0

## 🔍 What This Does

    -o        → one-line output  
    -f inet   → IPv4 only  
    addr show → show addresses  
    eth0      → specific interface  

## 🧪 Example Output

    2: eth0    inet 192.168.1.10/24 brd ...

👉 you want:
    192.168.1.10/24

## 🔥 Extract JUST the IP (EXAM GOLD)

    ip -o -f inet addr show eth0 | awk '{print $4}'

## Output

    192.168.1.10/24

## 🧠 Mental Model

    ip command → gives data  
    awk        → extracts what you need  

## 🧪 Then Save It

    ip -o -f inet addr show eth0 | awk '{print $4}' > /home/bob/ip

To filter, you must use:

    show eth0

## 🧨 Operator Insight

Think:

    ip = data  
    flags = filter  
    awk = extract  

> `{print $4}` means:

**print the 4th column (field) of each line**

## `awk`

👉 text processing tool (works with columns)

## `$4`

👉 column number 4

## `{print $4}`

👉 “for each line, print column 4”

   You determine `$4` by first viewing the output and counting the fields

</details>

---

## Task:

Identify the default gateway on this system and store the output (only the IP address) in the /home/bob/gateway.txt file

Has the default gateway value been stored in the /home/bob/gateway.txt file?

<details><summary>Answer</summary>
Execute the below command:

#### ip route show

Look for the line that contains default via string and copy the IP address you see after default via in this line:
Now, create the required file and save the IP address value in it:

#### vi /home/bob/gateway.txt

For example, if the IP address value is 172.17.0.1, then add it in the file:

#### 172.17.0.1

Finally, save the file.

### Explanation:
- ip route show → display routing table
- default via → default gateway entry
- IP after "via" → gateway address
- vi → manually save value
- /home/bob/gateway.txt → destination file

</details>

---

## Task:

Find out what process is listening for incoming connections on port 22 and identify its PID.

Create a file called /home/bob/pid and save the PID value in it.

PID is saved in the /home/bob/pid file?

<details><summary>Answer</summary>
Execute the below command:

#### sudo ss -tlnp | grep :22

Look for the pid= and copy it:

Now, create the required file and save the PID value in it:

#### vi /home/bob/pid

For example, if the PID value is 1123, then add it in the file:

#### 1123

Finally, save the file.

### Explanation:
- ss → view socket information
- -t → TCP sockets
- -l → listening sockets
- -n → numeric output
- -p → show process and PID
- grep :22 → filter for port 22
- pid= → identifies process ID
- vi → manually save value

## Why `-t` (TCP) for Port 22?

## 🧠 Short Answer

> Because **SSH (port 22) uses TCP**, not UDP

## 🔥 Key Concept

> Different services use different protocols:

| Protocol | Use Case |
|----------|--------|
| TCP | reliable connections (SSH, HTTP, HTTPS) |
| UDP | fast, connectionless (DNS, streaming) |

## 🔍 SSH Uses TCP

Port:
    22

Service:
    sshd

👉 uses:
> TCP only

# 🧠 Mental Model

    SSH = login session → must be reliable → uses TCP

## 🔥 What `-t` Does

    ss -tlnp

👉 shows:
> only TCP sockets

## 🔍 Breakdown

    -t → TCP only  
    -l → listening sockets  
    -n → numeric (no DNS)  
    -p → show process/PID  

## 🧪 Why Not UDP?

Because:

👉 SSH needs:
- guaranteed delivery  
- ordered packets  
- persistent connection  

👉 UDP does NOT provide that

## ⚠️ What If You Omit `-t`?

    ss -lnp

👉 shows:
- TCP  
- UDP  
- everything  

👉 more clutter

## 🧠 Why Labs Use `-t`

To:
- reduce noise  
- focus only on relevant protocol  

## 🔁 Memory Hook

    TCP = connection → login → SSH  

## 🧪 Real Check

    ss -tlnp | grep :22

👉 shows:
    sshd process + PID

## ⚡ Alternative (Broader)

    ss -lnp | grep :22

👉 still works  
👉 but includes unnecessary protocols

## 🧠 Mental Model (LOCK THIS IN)

    port → service → protocol → filter with ss

## 🔁 1-Line Recall

    SSH (22) = TCP → use `-t`

## 🧨 Operator Insight

Always think:

    “What protocol does this service use?”

👉 then filter accordingly

## Final Takeaway

    ss -tlnp | grep :22

👉 uses TCP filter because:
> SSH runs over TCP, not UDP

</details>

---

## Task:

Now, find out what process is listening for incoming connections on port 53 and identify its PID.

Create a file called /home/bob/process_pid and save the PID value in it.

Is PID saved in the /home/bob/process_pid file?

<details><summary>Answer</summary>
Execute the below command. Since it is a UDP port, you need to use the u option as well with the ss command:

#### sudo ss -tlnpu | grep :53

Look for the pid= and copy it:
Now, create the required file and save the PID value in it:

#### vi /home/bob/process_pid

For example, if the PID value is 1123, then add it in the file:

#### 1123

Finally, save the file.

### Explanation:
- ss → socket statistics tool
- -t → TCP sockets
- -u → UDP sockets
- -l → listening sockets
- -n → numeric output
- -p → show process and PID
- grep :53 → filter for port 53
- vi → manually save PID
- /home/bob/process_pid → destination file

## Why UDP for Port 53 + How to Know Ports for LFCS

## 🧠 Core Question
1. Why UDP for port 53?  
2. How do I KNOW which ports use TCP vs UDP?

## 🔥 1. Why UDP for Port 53?

> Port 53 = **DNS (Domain Name System)**

## 🔥 DNS Uses UDP (Most of the Time)

Because:
- fast  
- lightweight  
- no connection setup  

## 🧠 Mental Model

    DNS = quick lookup → use UDP

## ⚠️ BUT (Important)

DNS can ALSO use TCP:
- large responses  
- zone transfers  


## ✅ That’s Why Lab Used

    ss -tlnpu

👉 includes:
- `-t` → TCP  
- `-u` → UDP  

👉 covers BOTH cases

---

## 🔥 2. How Are You Supposed to Know This?

## 🎯 LFCS Expectation

You are NOT expected to memorize EVERYTHING  
BUT you SHOULD know **common ports + protocols**

## 🧠 Core Ports to Know (LOCK THESE IN)

| Port | Service | Protocol |
|------|--------|----------|
| 22   | SSH    | TCP |
| 80   | HTTP   | TCP |
| 443  | HTTPS  | TCP |
| 21   | FTP    | TCP |
| 25   | SMTP   | TCP |
| 53   | DNS    | UDP (primarily) |
| 67/68| DHCP   | UDP |

## 🔁 Memory Hooks

## 🔥 TCP = connection-based

Think:
    login, websites, sessions

👉 SSH, HTTP, HTTPS → TCP

## 🔥 UDP = fast + lightweight

Think:
    quick requests

👉 DNS, DHCP → UDP

## 🧠 Mental Model

    TCP → reliable (slow)  
    UDP → fast (no guarantees)

## 🔥 Why Use BOTH Flags?

    ss -tlnpu

👉 means:
> “show me everything (TCP + UDP)”

## 🧪 Safer Exam Strategy

Instead of guessing:

    ss -tlnpu | grep :53

👉 ALWAYS works

## ⚡ Alternative Commands

## Only UDP
    ss -ulnp

## Only TCP
    ss -tlnp

## 🧠 Mental Model (LOCK THIS IN)

    don’t guess protocol → include both

## 🔁 1-Line Recall

    53 = DNS → usually UDP  
    safest → use `-t -u`

## 🧨 Operator Insight

In real-world debugging:

👉 ALWAYS check BOTH:
    TCP + UDP

## Final Takeaway

- Port 53 = DNS → mainly UDP  
- Use:

    ss -tlnpu | grep :53

👉 to avoid missing anything

## ⚠️ Why The Lab Told You To Use `-u`

Because:

> DNS commonly uses UDP

👉 and they want to make sure you include it

## 🔁 Mental Model

    TCP = connection-based  
    UDP = connectionless  

Some services use BOTH.

## 🔁 Memory Hook

    -t = TCP  
    -u = UDP  
    -tu = both

## 🔁 1-Line Recall

    You see both because `-t` and `-u` were used, and some services (like DNS on port 53) use both TCP and UDP.

</details>

---

## Task:

So, now, let's try to identify the process name based on the port it's listening on. Find out the process name that is listening for incoming connections on port 8080.

Create a file called /home/bob/process and save the name of the process in it, for example sshd.

Is the process name saved in the /home/bob/process file?

<details><summary>Answer</summary>
Let's try to use netstat. Execute the below command:

#### sudo netstat -natp | grep :8080

Look for the string in the last of the line, for example:

#### tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      993/ttyd

Here, ttyd is the process name. Now, create the required file and save the process name in it:

#### vi /home/bob/process

In this case, the value should be ttyd:

#### ttyd

Finally, save the file.

### Explanation:
- netstat → network statistics tool
- -n → numeric output
- -a → all connections
- -t → TCP connections
- -p → show process info
- grep :8080 → filter for port 8080
- PID/process → format shows process name
- vi → manually save value

## Why Did They Use `netstat` Instead of `ss`?

> They *could have used either* — both work.

👉 The lab used `netstat` because:
- it’s older and widely taught  
- its output is easier to read for beginners  

## 🔥 Reality (IMPORTANT FOR LFCS)

> ✅ `ss` is the modern tool  
> ❌ `netstat` is considered legacy (but still works)

## Command
    sudo ss -tlnp | grep :8080

## 🧠 Output You’ll See

Something like:

    users:(("ttyd",pid=993,fd=3))

## Extract:

    ttyd

👉 that’s the process name

</details>

---

## Task:

Configure static resolution so that example.com hostname resolves to IP address 8.8.8.8.

Does example.com resolve to IP address 8.8.8.8?

<details><summary>Answer</summary>
Edit the /etc/hosts file:

#### sudo vi /etc/hosts

Add the below line in it:

#### 8.8.8.8         example.com

Save and exit.

### Explanation:
- /etc/hosts → local hostname mapping file
- 8.8.8.8 → target IP address
- example.com → hostname
- sudo vi → edit file with privileges

</details>

---

## Task:

Use the ip command to add a temporary extra IP to the eth1 interface. You should add the CIDR notation of the IP: 192.168.9.3/24.

Is extra IP added?

<details><summary>Answer</summary>
You can use the below command to set the new IP address.

#### sudo ip a add 192.168.9.3/24 dev eth1

### Explanation:
- ip a add → add IP address to interface
- 192.168.9.3/24 → IP with subnet mask
- dev eth1 → target interface
- sudo → run with elevated privileges
- temporary → not persistent after reboot

## Parts

    ip      → networking tool  
    a       → address (short for `addr`)  
    add     → add something  
    192...  → IP address  
    dev     → device  
    eth1    → interface  

## CIDR Notation (What `/24` Means)

> CIDR = **IP address + subnet size**

> CIDR = **Classless Inter-Domain Routing**

## 🔁 Memory Hook

    /24 = “standard home network”

## 🧠 Mental Model (LOCK THIS IN)

    IP + /number = address + network size


</details>

---

## Task:

Create the following Netplan config in the file named 99-custom.yaml under the /etc/netplan directory.

network:
  version: 2
  ethernets:
    enp6s0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 10.0.10.5/24

Is enp6s0 interface configured with the required IP address?

<details><summary>Answer</summary>
Navigate to the /etc/netplan directory and follow the below steps.

Create a file with name and copy the content provided.

#### sudo vim /etc/netplan/99-custom.yaml

Paste the following content in the file.

network:
  version: 2
  ethernets:
    enp6s0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 10.0.10.5/24

Change permissions using the below command.

#### sudo chmod 600 /etc/netplan/99-custom.yaml

After configuring, now apply the changes by following the command.

#### sudo netplan generate
#### sudo networkctl reload
#### sudo networkctl reconfigure enp6s0

### Explanation:
- /etc/netplan → network configuration directory
- YAML file → defines network settings
- enp6s0 → network interface
- addresses → static IP assignment
- chmod 600 → secure file permissions
- netplan generate → generate configuration
- networkctl reload → reload network config
- networkctl reconfigure → apply to interface

## Why Did They Add `chmod 600`? 🤔

> It’s **not required for the task**, but it’s done to ensure:

👉 **secure and accepted permissions for Netplan**

## 🔥 What `chmod 600` Means

    chmod 600 file

👉 permissions become:

    rw-------

## Breakdown

    6 → owner = read + write  
    0 → group = no access  
    0 → others = no access  

## 🧠 Why Do This For Netplan?

Netplan config files:

    /etc/netplan/*.yaml

are expected to be:

- owned by root  
- not writable/readable by others  

## ⚠️ If permissions are too open:

You might see warnings like:

    permissions for /etc/netplan/... are too open

## 🔥 So They Added It To:

- avoid permission warnings  
- follow best practice  
- ensure config is accepted cleanly  

## 🧠 Important For LFCS

> ❌ Not always required  
> ✅ But GOOD practice  

## 🔍 What Actually Matters For the Task

The task asked:

> configure the interface

So the REAL required steps are:

1. create the file  
2. add config  
3. apply it  

## `chmod 600` is:

👉 extra hardening / correctness step

## 🧠 Mental Model

    config files → should be locked down

# 🔁 Memory Hook

    600 = only root can touch it

# 🔁 1-Line Recall

    `chmod 600` is added to secure Netplan configs and avoid permission warnings, even if the task doesn’t explicitly require it.

</details>

---

## Task:

The interface named enp6s0 is configured with a permanent IP 10.0.10.5/24. Change this configuration so that the permanent IP is 192.168.10.10/24 instead of 10.0.10.5/24.

Don't forget to apply these new settings to the interface

Is the configuration updated and applied as follows?

<details><summary>Answer</summary>
Update the file /etc/netplan/99-custom.yaml created in the previous step using the vim command shown below.

network:
  version: 2
  ethernets:
    enp6s0:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.10.10/24

You can apply the configuration by two commands as follows.

#### sudo netplan generate
#### sudo networkctl reload
#### sudo networkctl reconfigure enp6s0

Check the changes using the below command.

#### ip a | grep enp6s0

### Explanation:
- netplan config → modify IP address
- 192.168.10.10/24 → new static IP
- netplan generate → regenerate config
- networkctl reload → reload network
- networkctl reconfigure → apply to interface
- ip a → verify IP assignment

> `enp6s0` is a **network interface name** (your network card)

👉 a specific network adapter on your system

Like:

- ethernet port  
- virtual NIC  
- VM network interface  

    enp6s0 = “this machine’s network port”

Modern Linux uses **predictable interface names** instead of:

    eth0, eth1

## 🔍 Break It Down

    en  = ethernet  
    p6  = PCI bus 6  
    s0  = slot 0  

</details>

---

## Task:

Check the network route of this system and store the output in the /home/bob/route.txt file.

Is the required output stored in the /home/bob/route.txt file?

<details><summary>Answer</summary>
Execute any one of the following commands:

#### sudo ip route show > /home/bob/route.txt

or

#### sudo ip r > /home/bob/route.txt

### Explanation:
- ip route show / ip r → display routing table
- sudo → run with elevated privileges
- '>' → redirect output
- /home/bob/route.txt → destination file

</details>

---

## Task:

Get the list of all incoming open ports on this system and store the output in the /home/bob/incoming.txt file.

Is the required output stored in the /home/bob/incoming.txt?

<details><summary>Answer</summary>
Execute the below commands:

#### sudo netstat -tulpn | grep LISTEN > /home/bob/incoming.txt

### Explanation:
- netstat → network statistics tool
- -t → TCP
- -u → UDP
- -l → listening ports
- -p → show process info
- -n → numeric output
- grep LISTEN → filter active listening ports
- '>' → redirect output to file

## Why `grep LISTEN` in This Command?

> To show ONLY services that are **waiting for incoming connections**

## Full Breakdown

## `netstat -tulpn`

| Flag | Meaning |
|------|--------|
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-l` | listening sockets ONLY |
| `-p` | show process (PID) |
| `-n` | numeric output |

## ⚠️ Key Insight

> `-l` already means “listening”

## 🧠 So Why `grep LISTEN`?

Because `netstat` still outputs a **STATE column**, like:

    tcp   0   0 0.0.0.0:22   0.0.0.0:*   LISTEN

👉 `grep LISTEN`:
- filters only those lines  
- makes output cleaner  
- ensures ONLY listening entries are saved  

## 🧪 What the Output Looks Like

Without grep:
    tcp   ... LISTEN
    tcp   ... ESTABLISHED
    udp   ... (no LISTEN label)

With grep:
    tcp   ... LISTEN

## ⚠️ Important Detail (ADVANCED)

UDP does NOT always show `LISTEN`

👉 so:

    grep LISTEN

❌ may exclude some UDP entries

## 🧠 Mental Model

    -l        = filter internally  
    grep      = filter visually/output  

## 🔥 Cleaner Alternative

For LFCS, better:

    sudo netstat -tulpn > /home/bob/incoming.txt

👉 because:
- `-l` already filters listening  
- keeps UDP entries too  

## 🧠 When SHOULD You Use `grep LISTEN`?

When:
- task explicitly says “LISTEN”  
- or you only care about TCP services  

## 🔁 Memory Hook

    LISTEN = waiting for connections

## 🔁 1-Line Recall

    `grep LISTEN` = show only listening services (mostly TCP)

## 🧨 Operator Insight

For exams:

👉 safest:
    use `-l`

👉 optional:
    use `grep LISTEN` for clarity

## Final Takeaway

    sudo netstat -tulpn | grep LISTEN

👉 filters output to:
> only processes actively listening for incoming connections

BUT:
> `-l` already does most of the work

## ✅ Modern `ss` Equivalent (Instead of `netstat`)

####    sudo ss -tulpn | grep LISTEN > /home/bob/incoming.txt

## 🔥 Even Better (Cleaner — No `grep` Needed)

    sudo ss -tulpn state listening > /home/bob/incoming.txt

## 🔍 Breakdown

## `ss -tulpn`

    -t → TCP  
    -u → UDP  
    -l → listening  
    -p → show process (PID/name)  
    -n → numeric  

## `state listening`

👉 filters ONLY listening ports  
👉 replaces `grep LISTEN`

## 🔁 Mapping

| netstat | ss |
|--------|----|
| -tulpn | -tulpn |
| grep LISTEN | state listening |

## 🔁 Memory Hook

    ss = socket statistics (modern netstat)

## 🔁 1-Line Recall

    Use `ss -tulpn state listening` as the modern equivalent of `netstat -tulpn | grep LISTEN`.

</details>

---

## Task:

Add a global DNS resolver (one that applies to all network interfaces). Set it to the following IP: 8.8.8.8.

Has a new DNS resolver been added?

<details><summary>Answer</summary>
Edit the /etc/systemd/resolved.conf file.

#### sudo vim /etc/systemd/resolved.conf

Uncomment the below line in it and update to 8.8.8.8: 8.8.8.8:

#### #DNS --> DNS=8.8.8.8

### Explanation:
- /etc/systemd/resolved.conf → DNS configuration file
- DNS=8.8.8.8 → set global DNS resolver
- uncomment → enable configuration line
- sudo vim → edit file with privileges

> `/etc/systemd/` = configuration for **systemd (the system manager)**

> systemd is the **core system manager** that controls:

- services (sshd, nginx, etc.)
- boot process
- logging (journalctl)
- networking pieces (like DNS via resolved)

## 🧠 Mental Model

    systemd = system controller

👉 configuration files that tell systemd:

- how services behave  
- how networking behaves  
- how DNS works (via resolved)

</details>
