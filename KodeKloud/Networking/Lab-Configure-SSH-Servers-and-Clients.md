# Lab - Configure-SSH-Servers-and-Clients (Hidden Answers)

## Task:

In what file can we edit the settings of our SSH server?

<details><summary>Answer</summary>

We can edit the settings of our SSH server in /etc/ssh/sshd_config file.

### Explanation:
- sshd_config → SSH server configuration file

</details>

---

## Task:

In a squid proxy server, what does this line do?

#### http_access allow localnetwork

<details><summary>Answer</summary>

It makes it accept incoming connections from whatever was defined in the ACL named localnetwork.

### Explanation:
- http_access → access rule
- allow → permit access
- localnetwork → named ACL

> a machine that sits **between clients and the internet**

## 🧠 Mental Model

    Your computer
         ↓
      Squid proxy
         ↓
     Internet

## 🔥 What “Proxy” Means

Proxy means:

> “I make the request FOR you”

## Instead of:

    Your browser → website

You get:

    Your browser → Squid → website

## 🔍 What Squid Can Do

## 1. Control Access
Block or allow sites

Example:
- allow work sites  
- block social media

## 2. Filter Users

Using ACLs:

    acl localnetwork src 192.168.1.0/24

## 3. Cache Content

Store copies of web content

👉 faster repeated access

## 4. Log Traffic

See:
- who accessed what  
- when  
- from where

## 🧪 Real-World Example

In an office:

All users browse through:

    squid.company.local:3128

(Squid often uses port 3128)

## ⚠️ What “http_access allow localnetwork” Means Now

Now your line makes more sense:

    http_access allow localnetwork

👉 means:

> let those clients use the proxy

NOT:
> direct internet access

## 🧠 Mental Model (LOCK THIS IN)

    ACL defines who  
    http_access allows who  
    Squid is the middleman they use

## 🔁 1-Line Recall

    Squid = proxy server that sits between users and the internet

## 🧨 Operator Insight

Think:

- DNS resolves names  
- Firewall filters traffic  
- Proxy mediates web access

Different jobs.

## Final Takeaway

> Squid is a proxy server:

    client → squid → internet

👉 a controlled middleman for web traffic

## What Does ACL Mean?

## 🧠 Short Answer

> ACL = **Access Control List**

## Access
👉 who is allowed (or denied)

## Control
👉 rules that control that access

## List
👉 a list of those rules

## 🧠 Mental Model

    ACL = list of access rules

## In Your Squid Example

    http_access allow localnetwork

## `localnetwork` is an ACL name

Somewhere earlier you’d likely have:

    acl localnetwork src 192.168.1.0/24

## That means:

Define an ACL called:

    localnetwork

that includes:

    192.168.1.0/24

## Then this line:

    http_access allow localnetwork

means:

> allow whatever is in that ACL

## 🔥 So this is the correct Answer:

> accept incoming connections from whatever was defined in the ACL named `localnetwork`

## 🧠 Mental Model

Step 1:
    acl localnetwork ...  
    define the group

Step 2:
    http_access allow localnetwork

    use the group

## 🔁 Memory Hook

    ACL = Access Control List  
    = named rule set

# 🧪 Think of It Like

    acl staff ...
    acl admins ...

Then:

    allow staff
    deny admins

## ⚠️ Important

ACL does NOT itself grant access.

👉 It defines a set.

Then another rule USES it.

## 🔁 1-Line Recall

    ACL = named list of who a rule applies to

## 🧨 Operator Insight

You’ll see ACLs beyond Squid too:
- filesystems  
- firewalls  
- routers  
- SELinux contexts (conceptually similar access controls)

## Final Takeaway

> ACL = Access Control List

In your example:

    localnetwork

is a named access rule group being allowed by:

    http_access allow localnetwork

</details>

---

## Task:

Edit the configuration of the SSH server and disable password logins.

Please make sure to restart the sshd service after making the required changes.

Is SSH password login disabled?

<details><summary>Answer</summary>

Edit the /etc/ssh/sshd_config file:

    sudo vi /etc/ssh/sshd_config

Uncomment the below line or add it if doesn't exist:

    PasswordAuthentication no

Save your changes and restart the sshd service:

    sudo systemctl restart sshd


### Explanation:
- PasswordAuthentication no → disable password login
- systemctl restart sshd → apply changes

## 🧠 Mental Model

    systemctl = remote control  
    systemctl = supervisor  
    sshd      = the machine being controlled
    sshd      = background SSH server
    sshd      = worker

## 🔥 What It Does

`sshd`:

- listens on port 22  
- accepts incoming SSH connections  
- authenticates users  
- starts remote login sessions

`systemctl` is the control tool **for systemd**

They go together.

## 🔍 Relationship

    systemctl  → command you type

controls:

    systemd    → the service manager

which manages:

    ssh.service

which runs:

    sshd

## 🧠 Mental Model

    systemctl = steering wheel  
    systemd   = engine/control system  
    sshd      = the service being managed

</details>

---

## Task:

Edit the system-wide configuration of the SSH client and turn on X11 forwarding.

Has X11 forwarding been turned on?

<details><summary>Answer</summary>

Edit the /etc/ssh/ssh_config file:

    sudo vi /etc/ssh/ssh_config

Uncomment the below line or add it if doesn't exist:

    ForwardX11 yes


### Explanation:
- ssh_config → SSH client config
- ForwardX11 yes → enable X11 forwarding

</details>

---

## Task:

Install squid proxy server on this system and start its service.

Is squid proxy server installed?

Is squid service started?

<details><summary>Answer</summary>

Execute the below command to install the required package:

    sudo apt install squid -y

Start squid service

    sudo systemctl start squid


### Explanation:
- apt install squid → install package
- systemctl start squid → start service

</details>

---

## Task:

Edit the config file of the Squid proxy daemon. Modify it to deny access to the IP addresses defined in the ACL called localnet.

Is squid proxy configured to deny access to localnet?

<details><summary>Answer</summary>

Edit the /etc/squid/squid.conf file:

    sudo vi /etc/squid/squid.conf

And change the line http_access allow localnet to http_access deny localnet.


### Explanation:
- deny localnet → block defined ACL

## 🔁 Memory Hook

    define ACL first  
    reference ACL by name later

## ⚠️ This Is Exactly Why ACLs Exist

So instead of writing:

    deny 192.168.1.0/24
    deny 10.0.0.0/24
    deny 172.16.0.0/16

You can define a named ACL once:

    localnet

Then use it in rules.

Cleaner.

## 🔁 1-Line Recall

    `deny localnet` = deny everything inside the ACL named localnet

## 🧨 Operator Insight

This pattern shows up everywhere:

- ACLs  
- firewall objects  
- security groups  
- named sets

Define once.

Reference many times.

## Final Takeaway

✅ Yes —

    http_access deny localnet

blocks **all IP addresses defined in the ACL named `localnet`**

</details>

---

## Task:

Edit the configuration of the Squid proxy daemon. Add a src type acl and name it vpn. The IP you should use in this acl is 203.0.110.5. Now add a new rule that tells the proxy server to allow access to the acl named vpn.

Is the new acl named vpn added?

Is the new rule added?

<details><summary>Answer</summary>

Edit the /etc/squid/squid.conf file:

    sudo vi /etc/squid/squid.conf

Add this line

    acl vpn src 203.0.110.5

Add the below line in the same file before the http_access deny all line:

    http_access allow vpn


### Explanation:
- acl vpn src → define source ACL
- http_access allow vpn → permit that ACL

## Yes — And **Where** You Insert It Is Everything

## 🧠 Short Answer

> YES — the existing:

    http_access deny all

at the end is the catch-all rule that blocks everything NOT previously allowed.

And:

    http_access allow vpn

must go **before** it.

## 🔥 This Is Rule-Order Logic Again

Squid evaluates top to bottom.

👉 first match wins.

## 🧠 Mental Model

    allow exceptions first  
    deny everything else last

## 🔍 What You’re Adding

Define ACL:

    acl vpn src 203.0.110.5

This creates a named set:

    vpn = 203.0.110.5

Then add:

    http_access allow vpn

Meaning:

> allow that IP through the proxy

## 🔥 Then Existing Rule Stays

    http_access deny all

Meaning:

> deny everyone else not already allowed

## 🧪 Final Logic

Example:

    acl vpn src 203.0.110.5

    http_access allow vpn

    http_access deny all

## What Happens?

### If source is:

    203.0.110.5

Matches:

    allow vpn

✅ allowed

Stops processing.

## If source is:

    203.0.110.8

Does not match allow.

Falls to:

    deny all

❌ blocked

## 🧠 So Your Interpretation Was Close

You asked:

> does it block all HTTP traffic except the vpn ACL?

## More precisely:

> it blocks all proxy access except anything matched by earlier allow rules (including vpn).

## ⚠️ Important Subtlety

It may NOT be only vpn.

There may already be earlier rules like:

    http_access allow localnet

If those remain above:

    deny all

they also remain allowed.

## 🧠 Mental Model

    all ALLOW rules above  
    deny all at bottom  
    = whitelist model

## 🔁 Memory Hook

    deny all = catch-all net

Anything not caught earlier falls into it.

## 🔁 1-Line Recall

    `http_access deny all` blocks everything not previously allowed.

## 🧨 Operator Insight

This is identical conceptually to:

- firewall rule ordering  
- explicit allow list (whitelist)

Very important pattern.

## Final Takeaway

✅ Yes —

    http_access allow vpn

must be inserted before:

    http_access deny all

so:

- vpn is allowed  
- everything else (not otherwise allowed) is denied

</details>

---

## Task:

Edit the configuration of the SSH server and configure it to use only IPv4 IP address family.

Is SSHD server configured to use 'IPv4' IP address family?

<details><summary>Answer</summary>

Edit the /etc/ssh/sshd_config file:

    sudo vi /etc/ssh/sshd_config

Uncomment the below line in it:

    #AddressFamily any

Change or add:

    AddressFamily inet

### Explanation:
- inet → IPv4 only

🔍 Why inet means IPv4

In SSH config:

AddressFamily inet

means:

inet = IPv4
inet6 = IPv6
any = both

That is OpenSSH syntax.

</details>

---

## Task:

Edit the configuration of the Squid proxy daemon. Now, add a new rule that allows http access to external.

Is squid server configured to allow http access to external?

<details><summary>Answer</summary>

Edit the /etc/squid/squid.conf file:

    sudo vi /etc/squid/squid.conf

Add the below line after the http_access allow localhost line:

    http_access allow external


### Explanation:
- allow external → permit ACL named external

> You are **not** allowing “external” as a generic concept.

You are allowing:

> whatever IPs are defined in the ACL named:

    external

## 🔥 Same Pattern as `localnet`

If earlier in the file you have something like:

    acl localhost src 127.0.0.1/32
    acl external  src 203.0.113.10

Then:

    http_access allow localhost
    http_access allow external

means:

- allow anything matching ACL `localhost`
- allow anything matching ACL `external`

## 🧠 `external` Is Just a NAME

Just like:

- localnet  
- vpn  
- external  

These are labels.

</details>

---

## Task:

Edit the configuration of the Squid proxy daemon, and add an acl and http access rule to block facebook.com.

Has the required acl been added?

Has facebook.com been blocked?

<details><summary>Answer</summary>

Edit the /etc/squid/squid.conf file:

    sudo vi /etc/squid/squid.conf

Add the acl:

    acl facebook dstdomain .facebook.com

Add the rule:

    http_access deny facebook


### Explanation:
- dstdomain → destination domain ACL
- deny facebook → block access

> `dstdomain` means:

**destination domain**

## 🔍 Break It Apart

    dst     = destination  
    domain  = domain name

## So:

    dstdomain

means:

> match requests going TO a domain name

## 🧠 Mental Model

    src       → source IP (where traffic comes FROM)

    dstdomain → destination website (where traffic goes TO)

## 🔥 What This ACL Is Defining

    acl facebook dstdomain .facebook.com

means:

Create an ACL named:

    facebook

that matches:

    facebook.com

## ❓Why The Leading Dot?

    .facebook.com

That means:

> match the domain and subdomains

## Matches:

- facebook.com  
- www.facebook.com  
- m.facebook.com  

## 🧠 Without The Dot

    facebook.com

may be less broad.

The dot is intentional.

## 🔥 Then This Rule

    http_access deny facebook

means:

> deny anything matching that ACL

## 🧪 Put Together

Define:

    acl facebook dstdomain .facebook.com

Use it:

    http_access deny facebook

## Plain English

> block access to facebook.com (and subdomains)

## 🧠 Mental Model

    ACL defines target  
    http_access enforces rule

## 🔁 Memory Hook

    src       = source IP  
    dstdomain = destination website

## ⚡ This Is New Because…

You’ve mostly seen:

    acl NAME src ...

(source-based ACLs)

Now this is:

    acl NAME dstdomain ...

(destination-based ACLs)

Same ACL idea.

Different match type.

## 🔁 1-Line Recall

    dstdomain = match destination domain names

## Final Takeaway

    acl facebook dstdomain .facebook.com

creates an ACL matching Facebook domains

and:

    http_access deny facebook

blocks them.

</details>

---

## Task:

Edit the configuration of the SSH server and re-enable password logins, but disable the SSH login for user root.

Is SSH password login enabled?

Is SSH login disabled for user root?

<details><summary>Answer</summary>

Edit /etc/ssh/sshd_config file:

    sudo vi /etc/ssh/sshd_config

Change the below line:

PasswordAuthentication no

to

PasswordAuthentication yes

    Add or uncomment:

    PermitRootLogin no

Restart:

    sudo systemctl restart sshd


### Explanation:
- PasswordAuthentication yes → enable password login
- PermitRootLogin no → disable root SSH login

</details>

---

## Task:

In the configuration file of the SSH server, change the maximum number of authentication attempts permitted per connection to 4.

Is the maximum number of authentication attempts permitted per connection changed to "4"?

<details><summary>Answer</summary>

Edit the /etc/ssh/sshd_config file:

    sudo vi /etc/ssh/sshd_config

Uncomment the below line or add it if doesn't exist:

    MaxAuthTries 4


### Explanation:
- MaxAuthTries 4 → limit login attempts


</details>
