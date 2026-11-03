#!/bin/bash
route add default gw 10.5.2.1
route del default gw 10.5.2.254

# Part 5.4: Beszel hub (interfaz web y API en el 8090)
cd /opt/beszel
./beszel serve --http "0.0.0.0:8090" > /var/log/beszel-hub.log 2>&1 &
cd /

/usr/sbin/sshd -D