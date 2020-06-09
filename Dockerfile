FROM amd64/centos:latest

# RUN yum install -y httpd
# ENV APACHE_RUN_USER  apache
# ENV APACHE_RUN_GROUP apache
# ENV APACHE_LOG_DIR  /var/log/httpd

RUN yum install -y net-tools telnet \
    sudo \
    vim \
    epel-release

RUN yum install -y sshuttle \
    expect sshpass

# COPY config/index.html /var/www/html/index.html
# COPY config/customhttpd.conf /etc/httpd/conf/httpd.conf
# RUN  usermod -aG wheel apache
# RUN  chown -R root:wheel /var/log/httpd
# RUN  chmod -R 2775 /var/log/httpd
# RUN  chown -R root:wheel /var/run

RUN  useradd nsoadmin
RUN  usermod -aG wheel nsoadmin 
RUN echo "Defaults !authenticate" >> /etc/sudoers  

EXPOSE 8080

USER nsoadmin
WORKDIR /home/nsoadmin

RUN  mkdir -p /tmp/ssh
RUN  mkdir .ssh
COPY --chown=nsoadmin:nsoadmin config/sshconfigfile .ssh/config
COPY --chown=nsoadmin:nsoadmin sh-run.sh sh-run.sh
COPY --chown=nsoadmin:nsoadmin httpserver_start.sh  httpserver_start.sh
COPY --chown=nsoadmin:nsoadmin runas_daemon.sh runas_daemon.sh

RUN  chmod +x sh-run.sh
RUN  chmod +x httpserver_start.sh
RUN  chmod +x runas_daemon.sh
RUN  ssh-keygen -q -t rsa -N '' -f /home/nsoadmin/.ssh/id_rsa 2>/dev/null <<< y >/dev/null

RUN  sudo chmod 600 /home/nsoadmin/.ssh/config
CMD  ./runas_daemon.sh

# ENTRYPOINT ["/usr/sbin/httpd"]
# CMD ["-D", "FOREGROUND"]
