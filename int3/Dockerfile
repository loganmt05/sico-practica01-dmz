FROM ubuntu:24.04
RUN apt-get update && apt-get install -y openssh-server net-tools iputils-ping traceroute vim nano iproute2 iptables pkg-config tcpdump nmap
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y curl ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/beszel \
    && cd /opt/beszel \
    && curl -fLsS "https://github.com/henrygd/beszel/releases/latest/download/beszel_Linux_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/').tar.gz" \
       | tar -xz -O beszel > beszel \
    && chmod +x beszel

EXPOSE 8090

COPY ./start.sh .
RUN chmod +x start.sh
CMD ["./start.sh"]