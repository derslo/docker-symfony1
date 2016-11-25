FROM debian:wheezy
MAINTAINER "Stephan Losse" <stephan.losse@me.com>

ENV TERM xterm

RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

RUN echo Europe/Berlin | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get update && \
    apt-get install -y wget
RUN echo 'deb http://packages.dotdeb.org wheezy-php55 all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org wheezy-php55 all' >> /etc/apt/sources.list && \
    wget http://www.dotdeb.org/dotdeb.gpg && \
    cat dotdeb.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y nano dialog net-tools curl git supervisor nginx php5-fpm php5-cli php5-mysql mysql-client php5-ldap

ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown root:root /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /var/www/web
ADD index.php /var/www/web/index.php

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]
