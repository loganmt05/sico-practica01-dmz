#!/bin/bash
route add default gw 10.5.1.1
route del default gw 10.5.1.254

# # Clean up stale state from previous runs (container restarts keep the filesystem)
# mkdir -p /var/run/fail2ban
# rm -f /var/run/fail2ban/fail2ban.sock /var/run/fail2ban/fail2ban.pid
# rm -f /var/run/rsyslogd.pid
 
# # fail2ban won't start a jail whose logfile is missing
# touch /var/log/auth.log

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
rsyslogd
fail2ban-server -x -b

/usr/sbin/sshd -D