#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254
/usr/sbin/sshd -D