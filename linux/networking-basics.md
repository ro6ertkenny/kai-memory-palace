# 🌐 Networking Basics
## Understanding how the system communicates

Mental mode: Knowing how traffic enters, leaves, and fails.

This document covers **node-level networking fundamentals**:
- interfaces
- addresses
- routes
- ports
- DNS

Most “it can’t connect” issues are local to the node, not the application.

---

## Purpose
You should be able to answer, without guessing:
- Does this host have network connectivity?
- Which interface is in use?
- What route is traffic taking?
- What ports are open, and who owns them?
- Is DNS working?

---

## Network Interfaces

List interfaces:
ip a

What to look for:
- interface name (eth0, wlan0, ens*)
- state: UP or DOWN
- assigned IP addresses

An interface that is DOWN cannot communicate.

---

## IP Addresses

IPv4 and IPv6 addresses appear as:
- inet
- inet6

Loopback:
127.0.0.1 is local-only.
Traffic never leaves the host.

If no non-loopback IP exists, the host is isolated.

---

## Routing

View routing table:
ip r

Key concept:
Traffic follows the most specific matching route.

Default route:
default via <gateway> dev <interface>

No default route means no outbound connectivity.

---

## Connectivity Testing

Basic reachability:
ping -c 3 1.1.1.1

If this fails:
- network or routing problem

Test DNS resolution:
ping -c 3 google.com

If IP works but name fails:
- DNS is broken

---

## Ports and Sockets

List listening ports and owners:
ss -tulpen

Fields to notice:
- protocol
- local address and port
- PID and process name

This answers:
“What is listening on this port?”

---

## Common Port Checks

Check for SSH:
ss -tulpen | grep :22

Check for kubelet:
ss -tulpen | grep kubelet

A service running without a listening port is misconfigured.

---

## DNS Resolution

System resolver status:
resolvectl status

Fallback:
cat /etc/resolv.conf

DNS failures often look like application failures.

Always test DNS early.

---

## Firewall Awareness

Linux firewalls may block traffic silently.

Common tools:
- nftables
- iptables
- ufw

If a service is running and listening but unreachable, suspect the firewall.

---

## Local vs Remote Failures

Ask:
- Can the host reach itself?
- Can another host reach it?
- Can it reach the outside world?

Change only one variable at a time.

---

## Practice

Run:
ip a
ip r
ss -tulpen
ping -c 3 1.1.1.1
ping -c 3 google.com

Explain:
- which interface is active
- how traffic leaves the host
- which ports are open

If you can explain that, networking is under control.

---

## Relationship to Networking Wing

This file covers **node-level basics only**.

Advanced topics live in:
kai-memory-palace/networking

Do not duplicate higher-level networking concepts here.

---

## Outcome

You should be able to say:

I know how this host communicates,  
I know where traffic flows,  
and I know where it is failing.

That is network awareness.
