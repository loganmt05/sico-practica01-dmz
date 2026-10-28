FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap apache2 rsyslog fail2ban
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Parte 5.1 - cambios de sshd config
RUN sed -i 's/^#\?Port.*/Port 2222/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN useradd -m -s /bin/bash user && echo "user:user" | chpasswd
RUN sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PermitEmptyPasswords\s+.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
COPY --chown=user:user keys/pass.pub /home/user/.ssh/authorized_keys
RUN sed -ri 's/^#?MaxAuthTries\s+.*/MaxAuthTries 4/' /etc/ssh/sshd_config
COPY banner.txt /etc/ssh/banner.txt
RUN sed -ri 's|^#?Banner.*|Banner /etc/ssh/banner.txt|' /etc/ssh/sshd_config
# TODO: remove?
RUN rm -f /etc/fail2ban/jail.d/defaults-debian.conf
COPY jail.local /etc/fail2ban/jail.local

EXPOSE 2222
RUN echo "<h1>Practica 1 Sistemas Confiables - Este servidor está en la máquina dmz2</h1>" > /var/www/html/index.html
COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]