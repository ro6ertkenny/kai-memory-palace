one more for Networking:

# Lab - Configure-SSH-Servers-and-Clients

## Task:

In what file can we edit the settings of our SSH server?

## Solution:

We can edit the settings of our SSH server in /etc/ssh/sshd_config file.


## Task:

In a squid proxy server, what does this line do?

#### http_access allow localnetwork

A. It makes it accept connections from the computers in our local network.

B. It lets computers in the local network use the http protocol, but not the https protocol.

C. It makes it accept incoming connections from whatever was defined in the ACL named "localnetwork"

D. It lets computers use the proxy server to access devices in the "localnetwork" ACL.

## Solution:

It makes it accept incoming connections from whatever was defined in the ACL named localnetwork.


## Task:

Edit the configuration of the SSH server and disable password logins.

Please make sure to restart the sshd service after making the required changes.

Is SSH password login disabled?

## Solution:

Edit the /etc/ssh/sshd_config file:

#### sudo vi /etc/ssh/sshd_config

Uncomment the below line or add it if doesn't exist:

#### PasswordAuthentication no

Save your changes and restart the sshd service:

#### sudo systemctl restart sshd


## Task:

Edit the system-wide configuration of the SSH client and turn on X11 forwarding.

Has X11 forwarding been turned on?

## Solution:

Edit the /etc/ssh/ssh_config file:

#### sudo vi /etc/ssh/ssh_config

Uncomment the below line or add it if doesn't exist:

#### ForwardX11 yes


## Task:

Install squid proxy server on this system and start its service.

Is squid proxy server installed?

Is squid service started?

## Solution:

Execute the below command to install the required package:

#### sudo apt install squid -y

Start squid service

#### sudo systemctl start squid


## Task:

Edit the config file of the Squid proxy daemon. Modify it to deny access to the IP addresses defined in the ACL called localnet.

Is squid proxy configured to deny access to localnet?

## Solution:

Edit the /etc/squid/squid.conf file:

#### sudo vi /etc/squid/squid.conf

And change the line http_access allow localnet to http_access deny localnet.


## Task:

Edit the configuration of the Squid proxy daemon. Add a src type acl and name it vpn. The IP you should use in this acl is 203.0.110.5. Now add a new rule that tells the proxy server to allow access to the acl named vpn.

Is the new acl named vpn added?

Is the new rule added?

## Solution:

Edit the /etc/squid/squid.conf file:

#### sudo vi /etc/squid/squid.conf

and Save the below changes in it:
Add this line

#### acl vpn src 203.0.110.5

Add the below line in the same file before the http_access deny all line:

#### http_access allow vpn


## Task:

Edit the configuration of the SSH server and configure it to use only IPv4 IP address family.

Is SSHD server configured to use 'IPv4' IP address family?

## Solution:

Edit the /etc/ssh/sshd_config file:

#### sudo vi /etc/ssh/sshd_config

Uncomment the below line in it:

#### #AddressFamily any

and change it to (add it if doesn't exist):

#### AddressFamily inet


## Task:

Edit the configuration of the Squid proxy daemon. Now, add a new rule that allows http access to external.

Is squid server configured to allow http access to external?

## Solution:

Edit the /etc/squid/squid.conf file:

#### sudo vi /etc/squid/squid.conf

Add the below line in this file after the http_access allow localhost line:

#### http_access allow external


## Task:

Edit the configuration of the Squid proxy daemon, and add an acl and http access rule to block facebook.com.

Has the required acl been added?

Has facebook.com been blocked?

## Solution:

Edit the /etc/squid/squid.conf file:

#### sudo vi /etc/squid/squid.conf

Add the acl provided below:

#### acl facebook dstdomain .facebook.com

And add the below line after the http_access allow localhost line:

#### http_access deny facebook


## Task:

Edit the configuration of the SSH server and re-enable password logins, but disable the SSH login for user root.

Is SSH password login enabled?

Is SSH login disabled for user root?

## Solution:

Edit /etc/ssh/sshd_config file:

#### sudo vi /etc/ssh/sshd_config

Change the below line:

#### PasswordAuthentication no

to

#### PasswordAuthentication yes

Uncomment the below line or add it if doesn't exist:

#### PermitRootLogin no

Save your changes and restart the sshd service:

#### sudo systemctl restart sshd


## Task:

In the configuration file of the SSH server, change the maximum number of authentication attempts permitted per connection to 4.

Is the maximum number of authentication attempts permitted per connection changed to "4"?

## Solution:

Edit the /etc/ssh/sshd_config file:

#### sudo vi /etc/ssh/sshd_config

Uncomment the below line or add it if doesn't exist:

#### MaxAuthTries 4
