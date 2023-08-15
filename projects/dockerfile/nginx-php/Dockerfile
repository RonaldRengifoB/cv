FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y openssh-server

RUN useradd remote_user && \
    echo "remote_user:1234" | chpasswd && \
    mkdir /home/remote_user/.ssh -p && \
    chmod 700 /home/remote_user/.ssh && \
    mkdir -p -m0755 /var/run/sshd

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user && \
    chmod 400 /home/remote_user/.ssh/authorized_keys
    
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo

RUN                                                                          \
    yum -y install nginx-1.12.2 openssl --enablerepo=nginx                  && \
    yum -y install https://repo.ius.io/ius-release-el7.rpm                  && \
    yum -y install                                                             \
    php71u-fpm                                                               \
    php71u-cli                                                               \
    php71u-mysqlnd                                                           \
    php71u-soap                                                              \
    php71u-xml                                                               \
    php71u-zip                                                               \
    php71u-json                                                              \
    php71u-mcrypt                                                            \
    php71u-mbstring                                                          \
    php71u-zip                                                               \
    php71u-gd                                                                \
    --enablerepo=ius-archive && yum clean all

EXPOSE 80 443

VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

COPY ./bin/start.sh /start.sh

RUN chmod +x /start.sh

CMD /usr/sbin/sshd -D && /start.sh