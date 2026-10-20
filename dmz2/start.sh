#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254

service apache2 start

/usr/sbin/sshd -D