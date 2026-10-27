#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254

service apache2 start
rsyslogd
fail2ban-server -x -b

/usr/sbin/sshd -D