#!/bin/bash

# TODO: evaluate against docker-compose
#echo 1 > /proc/sys/net/ipv4/ip_forward 

# Change policies for chains
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# loopback
iptables -A INPUT -i lo -j ACCEPT

# accept related and established connections
iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permit ping
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 10/minute --limit-burst 1 -j ACCEPT

# (Part 3) Allow tcp, udp, icmp traffic on FORWARD chain
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow traffic entering through intranet and exiting through extranet (TODO: todas las cadenas?, sin "-p" cubre todos de tcp, udp, icmp?)
iptables -A FORWARD -p tcp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD -p udp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD -p icmp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT

# Change IP address of output to fw extranet address
iptables -t nat -A POSTROUTING -s 10.5.2.0/24 -d 10.5.0.0/24 -j SNAT --to 10.5.0.1

# Part 4
# TODO: can we combine these?
# TODO: better to use IP ranges or single IPs for dmz1/dmz2?
# TODO: is --dport 80 equivalent to saying only http?
# http intranet -> DMZ
iptables -A FORWARD -p tcp -s 10.5.2.0/24 -d 10.5.1.0/24 --dport 80 -j ACCEPT
# http extranet -> DMZ
iptables -A FORWARD -p tcp -s 10.5.0.0/24 -d 10.5.1.0/24 --dport 80 -j ACCEPT

# ssh int1 -> DMZ
iptables -A FORWARD -p tcp -s 10.5.2.20 -d 10.5.1.0/24 --dport 22 -j ACCEPT


/usr/sbin/sshd -D