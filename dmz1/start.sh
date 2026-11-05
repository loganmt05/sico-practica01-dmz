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

# Part 5.4: Beszel agent
HUB_URL="http://10.5.2.22:8090" \
TOKEN="d4cadb0b-3e4d-446e-877c-3118e91a6f06" \
KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5fU2TYZOiGtUJkHxgy6JtBzrW/paFNq8Z3qDYLnA1s" \
DISABLE_SSH=true \
USE_CGROUP=true \
DATA_DIR=/var/lib/beszel-agent \
runuser -u beszel -- /opt/beszel-agent/beszel-agent > /var/log/beszel-agent.log 2>&1 &

/usr/sbin/sshd -D