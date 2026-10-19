#!/bin/bash
route add default gw 10.5.0.1
route del default gw 10.5.0.254

service apache2 start && service ssh start && tail -f /dev/null

/usr/sbin/sshd -D