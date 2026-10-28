FROM ubuntu:24.04
RUN apt-get update && apt-get install -y \
    openssh-server net-tools iputils-ping \
    traceroute vim nano iproute2 iptables \
    pkg-config tcpdump nmap apache2 \
    python3-pip python3-venv python3-minimal \
    libpython3-dev libssl-dev libffi-dev build-essential
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
RUN echo "<h1>Practica 1 Sistemas Confiables - Este servidor está en la máquina dmz1</h1>" > /var/www/html/index.html

# Part 5.3: Cowrie
RUN useradd -m -s /bin/bash cowrie
USER cowrie
WORKDIR /home/cowrie
RUN mkdir my-honeypot && cd my-honeypot \
    && python3 -m venv cowrie-env \
    && . cowrie-env/bin/activate \
    && python -m pip install --upgrade pip \
    && python -m pip install cowrie \
    && cowrie init
RUN printf '[honeypot]\nhostname = sico\n' > my-honeypot/etc/cowrie.cfg
RUN echo 'sico:x:sicopassword' > my-honeypot/etc/userdb.txt

USER root
WORKDIR /

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]