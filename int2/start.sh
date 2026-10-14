#!/bin/bash
route add default gw 10.5.2.1
route del default gw 10.5.2.254
/usr/sbin/sshd -D