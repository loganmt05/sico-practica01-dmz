#!/bin/bash

# Change policies for chains
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# accept related and established connections
iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,80,443 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permit ping
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT -m limit --limit 5/second

/usr/sbin/sshd -D