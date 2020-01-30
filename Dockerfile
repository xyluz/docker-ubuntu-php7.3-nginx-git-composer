FROM ubuntu:18.04
MAINTAINER Friday Godswill <friday@hotels.ng>

ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Install Environment
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install software-properties-common
RUN apt-get install nginx -y
RUN apt-get install \
    php7.3 \
    php7.3-cli \
    php7.3-common \
	php-pear \
    php7.3-curl \
    php7.3-dev \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-zip \
    php7.3-mysql \
    php7.3-xml \
    php7.3-fpm \
    libapache2-mod-php7.3 \
    php7.3-imagick \
    php7.3-recode \
    php7.3-tidy \
    php7.3-xmlrpc \
    php7.3-intl -y && service nginx restart

#Install GIT

RUN apt-get -y update
RUN apt install git

#Install Composer 
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php --install-dir=/usr/bin --filename=composer && \
php -r "unlink('composer-setup.php');"
RUN apt-get install supervisor curl -y

WORKDIR /var/www
ADD conf/supervisord.conf /etc/supervisord.conf
ADD init.sh /init.sh
ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
ADD conf/start.sh /start.sh
RUN rm -rf /etc/nginx/sites-enabled/default
RUN chmod 755 /start.sh
RUN chmod 755 /init.sh
RUN service php7.3-fpm start
EXPOSE 443 80
CMD ["bash", "/init.sh"]