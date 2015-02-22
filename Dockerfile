FROM ubuntu
MAINTAINER "Tobias Sturm"

ENV DEBIAN_FRONTEND noninteractive

ENV owncloudVersion 8.0.0
ENV nginxPort 443
ENV hostname YOUR_HOSTNAME_HERE

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y	php5-gd \
			php5-json \
			php5-intl \
			php5-mcrypt \
			php5-curl \
			php5-imagick \
			nginx \
			php5-fpm \
			curl \
			sqlite3 \
			php5-sqlite \
			smbclient

#generate SSL certs
RUN mkdir /etc/ssl/nginx
RUN openssl req -new -newkey rsa:8196 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Simpsons/CN=${hostname}" \
    -keyout /etc/ssl/nginx/${hostname}.key -out /etc/ssl/nginx/${hostname}.crt

#config nginx
ADD nginx.conf /nginx.conf
RUN cat /nginx.conf | \
	sed "s/<HOSTNAME>/${hostname}/" | \
	sed "s/<INTERNALPORT>/${nginxPort}/" > /etc/nginx/conf.d/owncloud.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#download owncloud and extract
RUN mkdir /var/www
RUN curl -s https://download.owncloud.org/community/owncloud-${owncloudVersion}.tar.bz2 | tar xj -C /var/www
VOLUME /var/www/owncloud/data
VOLUME /var/www/owncloud/config
RUN chown -R www-data: /var/www/owncloud/data
RUN chown -R www-data: /var/www/owncloud/config
RUN ln -s /etc/ssl/nginx/${hostname}.crt /var/www/owncloud/config

#expose port that connects to nginx
EXPOSE ${nginxPort}

#wire logging to stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
