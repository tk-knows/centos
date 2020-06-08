FROM amd64/centos:latest

RUN yum install -y httpd

ENV APACHE_RUN_USER  apache
ENV APACHE_RUN_GROUP apache
ENV APACHE_LOG_DIR  /var/log/httpd

RUN yum install -y net-tools telnet \
    sudo \
    vim \
    epel-release

RUN yum install -y sshuttle \
    expect 

COPY config/index.html /var/www/html/index.html
COPY config/customhttpd.conf /etc/httpd/conf/httpd.conf

RUN  usermod -aG wheel apache
RUN  chown -R root:wheel /var/log/httpd
RUN  chmod -R 2775 /var/log/httpd
RUN  chown -R root:wheel /var/run

RUN  useradd nsoadmin
RUN  usermod -aG wheel nsoadmin 

EXPOSE 8080

RUN echo "Defaults !authenticate" >> /etc/sudoers

COPY shuttle_start.sh shuttle_start.sh
COPY apache_start.sh  apache_start.sh
COPY runas_daemon.sh runas_daemon.sh
RUN chmod +x shuttle_start.sh
RUN chmod +x apache_start.sh
RUN chmod +x runas_daemon.sh

# USER apache
# USER nsoadmin
CMD ./runas_daemon.sh

# ENTRYPOINT ["/usr/sbin/httpd"]
# CMD ["-D", "FOREGROUND"]
