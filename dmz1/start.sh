#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254

# Parte 5.2 - create certificate for SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/CN=10.5.1.21"
# update cert paths in SSL config
sed -ri 's|^([[:space:]]*)#?SSLCertificateFile[[:space:]]+.*|\1SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt|' /etc/apache2/sites-available/default-ssl.conf
sed -ri 's|^([[:space:]]*)#?SSLCertificateKeyFile[[:space:]]+.*|\1SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key|' /etc/apache2/sites-available/default-ssl.conf

# enable ssl and start apache server
a2enmod ssl
a2ensite default-ssl.conf
service apache2 start

# Part 5.3: Cowrie
su - cowrie -c "cd /home/cowrie/my-honeypot && . cowrie-env/bin/activate && cowrie start"

/usr/sbin/sshd -D