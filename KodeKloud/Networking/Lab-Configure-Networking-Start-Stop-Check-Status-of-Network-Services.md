# Lab - Configure Networking, Start/Stop/Check Status of Network Services

## Task:

Where do we configure static hostname resolution?

## Solution:

We can configure static hostname resolution in /etc/hosts file.


## Task:

How do we see what processes on our system are listening for incoming network connections, on the TCP and UDP protocols?

## Solution:

Using sudo ss -tunlp command we can see what processes on our system are listening for incoming network connections, on the TCP and UDP protocols.


## Task:

Identify the IP address of the eth0 interface on our current system.

Create a file called /home/bob/ip and save the ip address value (with subnet) in it.

Is the IP address saved in the /home/bob/ip file?

## Solution:

Execute the below command:

#### ip a

Look for the IP address of eth0 interface and copy it:

Now, create the required file and save the IP value in it:

#### vi /home/bob/ip

For example, if the IP address is 172.16.1.0/24, then add it in the file:

#### 172.16.1.0/24

Finally, save the file.


## Task:

Identify the default gateway on this system and store the output (only the IP address) in the /home/bob/gateway.txt file

Has the default gateway value been stored in the /home/bob/gateway.txt file?

## Solution:

Execute the below command:

#### ip route show

Look for the line that contains default via string and copy the IP address you see after default via in this line:
Now, create the required file and save the IP address value in it:

#### vi /home/bob/gateway.txt

For example, if the IP address value is 172.17.0.1, then add it in the file:

#### 172.17.0.1

Finally, save the file.


## Task:

Find out what process is listening for incoming connections on port 22 and identify its PID.

Create a file called /home/bob/pid and save the PID value in it.

PID is saved in the /home/bob/pid file?

## Solution:

Execute the below command:

#### sudo ss -tlnp | grep :22

Look for the pid= and copy it:

Now, create the required file and save the PID value in it:

#### vi /home/bob/pid

For example, if the PID value is 1123, then add it in the file:

#### 1123

Finally, save the file.


## Task:

Now, find out what process is listening for incoming connections on port 53 and identify its PID.

Create a file called /home/bob/process_pid and save the PID value in it.

Is PID saved in the /home/bob/process_pid file?

## Solution:

Execute the below command. Since it is a UDP port, you need to use the u option as well with the ss command:

#### sudo ss -tlnpu | grep :53

Look for the pid= and copy it:
Now, create the required file and save the PID value in it:

#### vi /home/bob/process_pid

For example, if the PID value is 1123, then add it in the file:

#### 1123

Finally, save the file.


## Task:

So, now, let's try to identify the process name based on the port it's listening on. Find out the process name that is listening for incoming connections on port 8080.

Create a file called /home/bob/process and save the name of the process in it, for example sshd.

Is the process name saved in the /home/bob/process file?

## Solution:

Let's try to use netstat. Execute the below command:

#### sudo netstat -natp | grep :8080

Look for the string in the last of the line, for example:

#### tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      993/ttyd

Here, ttyd is the process name. Now, create the required file and save the process name in it:

#### vi /home/bob/process

In this case, the value should be ttyd:

#### ttyd

Finally, save the file.


## Task:

Configure static resolution so that example.com hostname resolves to IP address 8.8.8.8.

Does example.com resolve to IP address 8.8.8.8?

## Solution:

Edit the /etc/hosts file:

#### sudo vi /etc/hosts

Add the below line in it:

#### 8.8.8.8         example.com

Save and exit.


## Task:

Use the ip command to add a temporary extra IP to the eth1 interface. You should add the CIDR notation of the IP: 192.168.9.3/24.

Is extra IP added?

## Solution:

You can use the below command to set the new IP address.

#### sudo ip a add 192.168.9.3/24 dev eth1


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

## Solution:

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


## Task:

The interface named enp6s0 is configured with a permanent IP 10.0.10.5/24. Change this configuration so that the permanent IP is 192.168.10.10/24 instead of 10.0.10.5/24.

Don't forget to apply these new settings to the interface

Is the configuration updated and applied as follows?

## Solution:

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


## Task:

Check the network route of this system and store the output in the /home/bob/route.txt file.

Is the required output stored in the /home/bob/route.txt file?

## Solution:

Execute any one of the following commands:

#### sudo ip route show > /home/bob/route.txt

or

#### sudo ip r > /home/bob/route.txt


## Task:

Get the list of all incoming open ports on this system and store the output in the /home/bob/incoming.txt file.

Is the required output stored in the /home/bob/incoming.txt?

## Solution:

Execute the below commands:

#### sudo netstat -tulpn | grep LISTEN > /home/bob/incoming.txt


## Task:

Add a global DNS resolver (one that applies to all network interfaces). Set it to the following IP: 8.8.8.8.

Has a new DNS resolver been added?

## Solution:

Edit the /etc/systemd/resolved.conf file.

#### sudo vim /etc/systemd/resolved.conf

Uncomment the below line in it and update to 8.8.8.8: 8.8.8.8:

#### #DNS --> DNS=8.8.8.8
