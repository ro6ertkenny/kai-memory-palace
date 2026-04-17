# Lab - Packet Filtering

## Task:

By default, Uncomplicated Firewall (ufw) is disabled. So, do the following before proceeding into the lab.

1. Turn on ufw
2. All traffic is blocked by default, so we must allow SSH on port 22 so the lab won't be broken.

Is the UFW firewall tool status active?

Is traffic allowed on port 22? 

<details><summary>Answer</summary>
Start ufw with

#### sudo ufw enable

All traffic is blocked by default, so we must allow SSH on port 22 so the lab won't be broken.

#### sudo ufw allow 22

### Explanation:
- ufw → uncomplicated firewall tool
- enable → turn firewall on
- allow 22 → permit SSH traffic
- sudo → run with elevated privileges

</details>

---

## Task:

Set up a firewall rule to allow incoming traffic to this machine on port 80.

Have incoming connections to port 80 been allowed?

<details><summary>Answer</summary>
Execute the below command:

#### sudo ufw allow 80

### Explanation:
- ufw allow → permit traffic
- 80 → HTTP port
- sudo → run with elevated privileges

</details>

---

## Task:

Set up a firewall rule to allow incoming traffic to this machine on port 53, through the TCP protocol.

Have incoming connections to port 53 been allowed?

<details><summary>Answer</summary>
Execute the below command:

#### sudo ufw allow 53/tcp

### Explanation:
- ufw allow → permit traffic
- 53/tcp → DNS over TCP
- tcp → protocol specification
- sudo → run with elevated privileges

</details>

---

## Task:

Set up a firewall rule to deny incoming traffic to this machine on port 443, through the TCP protocol.

Is the rule to deny access through 443/tcp added?

<details><summary>Answer</summary>
Execute the below command to finish the task.

#### sudo ufw deny 443/tcp

### Explanation:
- ufw deny → block traffic
- 443/tcp → HTTPS port
- tcp → protocol
- sudo → run with elevated privileges

> Why do they write:
    443/tcp

instead of just:
    443

## 🔥 Short Answer

> Because `ufw` wants the rule to match:

    port + protocol

## 🧠 Mental Model

    443/tcp

means:

    port 443 using TCP

    443   → port number  
    /     → separator  
    tcp   → protocol  

## ⚠️ Why Not Just:

    sudo ufw deny 443

You often *can* do that.

BUT:

👉 it may be less explicit

## 🔥 Why Explicit Is Better

Because:

    443/tcp

clearly says:

> block HTTPS over TCP

## And HTTPS Uses…

Port:
    443

Protocol:
    TCP

## 🧪 Same Pattern Elsewhere

    53/udp
    22/tcp
    80/tcp

## 🧠 Memory Hook

    port/protocol

say it like:

> “443 slash TCP”

## ⚡ Why This Matters for LFCS

If task says:

> deny access through 443/tcp

👉 mirror it exactly:

    sudo ufw deny 443/tcp

## 🔁 1-Line Recall

    443/tcp = port + protocol

## 🧨 Operator Insight

In firewalls:
- specificity is good  
- ambiguity is bad

## Final Takeaway

    sudo ufw deny 443/tcp

👉 means:
> block incoming traffic to port 443 using TCP

</details>

---

## Task:

Delete a firewall rule denying incoming traffic to this machine on port 443, through the TCP protocol (That is created in previous step).

Is the rule deleted?

<details><summary>Answer</summary>
Execute the below command

#### sudo ufw delete deny 443/tcp

### Explanation:
- ufw delete → remove rule
- deny 443/tcp → target rule to delete
- sudo → run with elevated privileges

</details>

---

## Task:

Rules that we add are numbered. What is the rule with number 5?

<details><summary>Answer</summary>
Execute the below command and check for the rule in number 5.

#### sudo ufw status numbered

Output will be shown below.

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    Anywhere                  
[ 2] 80/tcp                     ALLOW IN    Anywhere                  
[ 3] 3306                       ALLOW IN    10.0.0.0/24               
[ 4] 22 (v6)                    ALLOW IN    Anywhere (v6)             
[ 5] 80/tcp (v6)                ALLOW IN    Anywhere (v6)

### Explanation:
- ufw status numbered → show rules with numbers
- [5] → rule index
- allows identification and management of specific rules


> ✅ Yes — every numbered entry shown is a firewall rule

and

> ✅ Yes — rule `[5]` allows incoming traffic to port 80 over TCP via IPv6

    [ 5 ] 80/tcp (v6) ALLOW IN Anywhere (v6)

## Break It Down

    [5]          → rule number
    80/tcp       → port 80 using TCP
    (v6)         → IPv6
    ALLOW IN     → allow incoming traffic
    Anywhere(v6) → from any IPv6 source

## 🧠 Plain English

> Allow anyone on IPv6  
> to connect inbound  
> to port 80/TCP

## 🔥 Yes, `ufw status numbered` Shows Rules

Each numbered line:

    [1]
    [2]
    [3]

👉 is a rule in the firewall policy.

## 🧠 Mental Model

    numbered list = firewall rules table

## ⚠️ Why You See BOTH IPv4 and IPv6 Rules

Look:

    [2] 80/tcp ALLOW IN Anywhere

👉 IPv4 rule

and

    [5] 80/tcp (v6) ALLOW IN Anywhere (v6)

👉 IPv6 rule

## They Are Separate Rules

Even though they look related:

- one handles IPv4  
- one handles IPv6  

## 🔁 Memory Hook

    (v6) = IPv6 version of the rule

## 🧪 Why This Matters

If you delete:

    sudo ufw delete 2

👉 you remove IPv4 rule only

IPv6 rule [5] may still exist.

# ⚡ Exam Pattern

If task asks:

> “What is rule 5?”

You answer:

> Allow inbound TCP port 80 from anywhere over IPv6

## 🔁 1-Line Recall

    `[5] 80/tcp (v6)` = allow HTTP over IPv6

## 🧨 Operator Insight

Always check whether:
- IPv4 rule exists  
- IPv6 rule exists  

They may differ.

## Final Takeaway

✅ Yes — all numbered lines are firewall rules

✅ Rule `[5]` means:

    allow incoming traffic on 80/tcp over IPv6 from anywhere

</details>

---

## Task:

Allow all traffic that is coming from the following IP address 207.45.232.181.

Is the rule added to allow access from IP address specified?

<details><summary>Answer</summary>
Execute the below command to complete this task.

#### sudo ufw allow from 207.45.232.181

### Explanation:
- ufw allow from → permit traffic from specific IP
- 207.45.232.181 → source IP
- sudo → run with elevated privileges

## 🔍 Yes, `from` Is a Real Keyword (ufw - **uncomplicated firewall**)

It is not random text.

It is part of `ufw` syntax.

## Meaning

    allow     → permit traffic  
    from      → source address  
    207...    → source IP

## 🧠 Think of It Like Grammar

    action   source

    allow    from 207.45.232.181

## 🧪 UFW Often Reads Like Sentences

## Allow from source
    ufw allow from 10.0.0.5

## Allow to port
    ufw allow 22/tcp

## Allow from source to port
    ufw allow from 10.0.0.5 to any port 22

👉 literally reads like English.

</details>

---

## Task:

Allow all traffic coming from any IP in this network range: 10.11.12.0 to 10.11.12.255 (i.e., 10.11.12.0/24). Add the required rule.

Has the required firewall rule been added?

<details><summary>Answer</summary>
Execute the below command:

#### sudo ufw allow from 10.11.12.0/24 

### Explanation:
- ufw allow from → permit traffic from network
- 10.11.12.0/24 → CIDR range
- sudo → run with elevated privileges

The task says:

    10.11.12.0 to 10.11.12.255

Then adds:

    (i.e. 10.11.12.0/24)

👉 it is telling you:

> “these two expressions mean the same network”

## 🔁 Memory Hook

    i.e. = that is

## 🔥 2. Why No Need To Specify `.255`

Because:

    /24 ALREADY defines the whole range

## 🧠 This Is The Big Idea

    10.11.12.0/24

means:

Network:
    10.11.12.0

Mask:
    255.255.255.0

Range:
    10.11.12.0 → 10.11.12.255

## 👉 The `.255` Is Already INCLUDED

You do NOT type:

    10.11.12.0 - 10.11.12.255

because CIDR replaces that.

## 🧠 Mental Model

    /24 = the range is implied

## 🧪 Think of It Like This

Writing:

    10.11.12.0/24

is shorthand for saying:

> “the entire 10.11.12.x network”

## ⚠️ Important Detail

Typically:

- `.0` = network address  
- `.255` = broadcast  
- usable hosts:
    .1 → .254

But for firewall matching:

👉 the CIDR covers the subnet as a whole.

## 🔁 1-Line Recall

    /24 already includes .0 through .255

## 🧨 Operator Insight

This is WHY CIDR exists:

👉 so you don’t have to manually write ranges.

## Final Takeaway

- `(i.e. 10.11.12.0/24)` is just clarification  
- you don’t specify `.255` because:

    /24 already means the entire range

</details>

---

## Task:

A rule allow from 192.168.0.4 to any port 22 was added to the firewall, which is the port configured to rule one.

<details><summary>Answer</summary>
Execute below command and check the output for rule number 1

#### sudo ufw status numbered

Answer is 22

### Explanation:
- ufw status numbered → view rule list with indexes
- rule 1 → first matching rule
- port 22 → SSH port

## 🧠 You Are Querying Existing Rules

## Example Output (what you would have seen on their VM)

    [1] 22 ALLOW IN 192.168.0.4
    [2] 80/tcp ALLOW IN Anywhere

# 🔍 Now Read Rule 1

    [1] 22 ALLOW IN 192.168.0.4

## Breakdown

    [1]          → rule number 1  
    22           → port number  
    ALLOW IN     → permit inbound traffic  
    192.168.0.4  → source IP  

## 🔥 So Why Is Answer Just “22”?

Because the question asks:

> which port is configured in rule one?

Answer:

    22

That’s it.

</details>

---

## Task:

There's a firewall rule that denies any traffic coming from the 10.0.0.19 IP address. But this rule is in an incorrect spot (after an allow rule for the 10.0.0.0/24 range). So traffic is never denied because the rule is never matched. Correct this mistake.

Is the rule inserted as number 1 ?

<details><summary>Answer</summary>
First check for number of rule

#### ~ ➜  sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    192.168.0.0/24            
[ 2] 22                         ALLOW IN    192.168.0.4               
[ 3] 22                         ALLOW IN    Anywhere                  
[ 4] 80                         ALLOW IN    Anywhere                  
[ 5] 53/tcp                     ALLOW IN    Anywhere                  
[ 6] Anywhere                   ALLOW IN    207.45.232.181            
[ 7] Anywhere                   ALLOW IN    10.11.12.0/24             
[ 8] 3306                       ALLOW IN    10.0.0.0/24               
[ 9] 22 (v6)                    ALLOW IN    Anywhere (v6)             
[10] 80 (v6)                    ALLOW IN    Anywhere (v6)             
[11] 53/tcp (v6)                ALLOW IN    Anywhere (v6)             

Delete the rule as per requirement

#### ~ ➜  sudo ufw delete 8
Deleting:
 allow from 10.0.0.0/24 to any port 3306
Proceed with operation (y|n)? y
Rule deleted

Insert rule using the below command

#### ~ ➜ sudo ufw insert 1 deny from 10.0.0.19
Rule inserted

Check status again

#### ~ ➜ sudo ufw status numbered

### Explanation:
- ufw status numbered → view ordered rules
- ufw delete 8 → remove incorrect rule
- ufw insert 1 → insert rule at top priority
- deny from 10.0.0.19 → block specific IP
- rule order → first match wins in firewall processing

## This One *Is* Confusing — Let’s Untangle It

## 🧠 Core Problem

You’re seeing TWO DIFFERENT RULES involved:

1. a broad **ALLOW** rule  
2. a specific **DENY** rule that is missing (or in wrong order)

That’s the whole issue.

## 🔥 What Is Rule 8?

    [8] 3306 ALLOW IN 10.0.0.0/24

## Breakdown

    3306          → port 3306
    ALLOW IN      → allow inbound traffic
    10.0.0.0/24   → from any host in that subnet

## 🧠 What is Port 3306?

> Port **3306** is typically:
> **MySQL / MariaDB**

## Plain English

Rule 8 says:

> Allow anyone in:

    10.0.0.0/24

to access:

    port 3306

## ⚠️ Why Is That A Problem?

Because:

    10.0.0.19

is INSIDE:

    10.0.0.0/24

## Specifically

Range is:

    10.0.0.1  through 10.0.0.254

and:

    10.0.0.19

is in there.

## 🔥 The Bug

Current firewall sees:

Rule 8:
    allow subnet 10.0.0.0/24

So when:

    10.0.0.19

connects…

👉 it matches the ALLOW rule first.

Firewall stops there.

DENY never happens.

## 🧠 Mental Model

    first match wins

CRITICAL firewall rule concept.

## ❓ “Where Is The Deny Rule?”

Answer:

> It isn’t in the shown list.

That’s the problem.

It was:
- missing  
or
- previously below rule 8 (not shown)

Lab wants you to fix by inserting it FIRST.

## 🔥 Fix

Delete broad allow:

    sudo ufw delete 8

Then insert deny FIRST:

    sudo ufw insert 1 deny from 10.0.0.19

## New order

    [1] deny from 10.0.0.19
    [2] allow from 10.0.0.0/24 to any port 3306

## Now what happens?

Traffic from:

    10.0.0.19

hits:

Rule 1

DENIED ✅

## 🧠 Why Insert 1?

Because:

    lower number = evaluated first

## 🔁 Memory Hook

    specific DENY goes ABOVE broad ALLOW

## ⚡ This Is Classic Firewall Logic

Always:

    specific rules first  
    general rules later

## 🔁 1-Line Recall

    first match wins → deny bad host BEFORE allow subnet

## 🧨 Operator Insight

This is one of the most important firewall concepts on LFCS.

Not UFW.

Not syntax.

👉 Rule ORDER.

## Final Takeaway

- `3306` = MySQL port  
- Rule 8 allows the whole subnet  
- `10.0.0.19` is inside that subnet  
- deny must be inserted ABOVE that rule:

    sudo ufw insert 1 deny from 10.0.0.19

👉 so it matches first

## The “Subnet” There Is Defined By the CIDR

## Rule 8
    allow from 10.0.0.0/24 to any port 3306

## 🧠 Short Answer

> YES — the **subnet** is:

    10.0.0.0/24

And:

> the `/24` is the **CIDR notation** that defines the subnet size.

## 🔍 Break It Apart

## Network Address
    10.0.0.0

👉 this is the **subnet (network) base address**

## CIDR Prefix
    /24

👉 this tells you:
- how big the subnet is  
- which addresses are inside it

## 🧠 Together

    10.0.0.0/24

= one subnet

## 🧪 What’s Inside That Subnet?

Range:

    10.0.0.0  → network address
    10.0.0.1  → usable host
    ...
    10.0.0.19 ← inside the subnet ✅
    ...
    10.0.0.254
    10.0.0.255 → broadcast

## 🔥 So When I Said

> “allow subnet 10.0.0.0/24”

I meant:

> allow any host whose IP falls inside the CIDR-defined network.

## 🧠 Mental Model

    network address + CIDR = subnet

## 🔁 Memory Hook

    /24 defines the size  
    10.0.0.0 defines the network

Together:
    that’s the subnet

## ⚠️ Important Distinction

People often say:

> “the subnet is `/24`”

That’s shorthand.

More precisely:

- `/24` = CIDR prefix  
- `10.0.0.0/24` = subnet

## 🔁 1-Line Recall

    CIDR defines the subnet  
    the full subnet is network + CIDR

## Final Takeaway

✅ Yes —

    10.0.0.0/24

is the subnet

and

    /24

is the CIDR notation that defines it.


## Why `.0` Is Network, `.1` Is Host, and `.255` Is Broadcast

## Using:
    10.0.0.0/24

Because in a `/24`:

- first address = network identifier  
- last address = broadcast  
- everything in between = usable hosts

## 🔍 Why?

## `/24` means:

    255.255.255.0

👉 first 24 bits = network

👉 last 8 bits = host portion

## Last 8 Bits Can Vary

Binary:

    00000000  → .0
    ...
    11111111  → .255

## 🔥 Why `.0` Is Network Address

Host bits all zero:

    00000000

means:

> “this identifies the network itself”

NOT a machine.

## Mental Model

    10.0.0.0

= the name of the neighborhood

NOT a house.

## 🔥 Why `.1` Is Usable

Host bits:

    00000001

👉 now you have an actual host.

## That is the first usable “house”

    10.0.0.1

## 🔥 Why `.255` Is Broadcast

Host bits all ones:

    11111111

means:

> “send to EVERY host in this subnet”

## What “Broadcast” Means

It means:

> one packet intended for ALL machines on that network

## Example

If a machine sends to:

    10.0.0.255

👉 every host in:

    10.0.0.0/24

hears it.

## 🧠 **Mental Model**

Neighborhood:

    10.0.0.0   = neighborhood name  
    10.0.0.1   = first house  
    10.0.0.254 = last house  
    10.0.0.255 = shout to whole neighborhood

## 🔁 Memory Hook

    all 0s → network  
    all 1s → broadcast

## ⚠️ Usable Hosts

In `/24`:

256 total addresses

Minus:
- network (.0)
- broadcast (.255)

= 254 usable hosts

## 🔁 1-Line Recall

    first = network  
    last = broadcast  
    middle = hosts

## 🧨 Operator Insight

This pattern applies to ALL subnets:

not just `/24`

The first and last addresses are special.

## Final Takeaway

For:

    10.0.0.0/24

- `.0` = network identifier  
- `.1-.254` = usable hosts  
- `.255` = broadcast (send to everyone)

</details>
