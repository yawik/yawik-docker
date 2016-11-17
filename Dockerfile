FROM php:5-apache

MAINTAINER "Carsten Bleek" <bleek@cross-solution.de>

RUN apt-get update && apt-get install -y git-core 


RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
	libicu-dev \
	libssl-dev \
	libcurl4-openssl-dev \
	zip unzip \
   	&& docker-php-ext-install -j$(nproc) intl \
    	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    	&& docker-php-ext-install -j$(nproc) gd \
	&& pecl install mongo \
    	&& docker-php-ext-enable mongo

# Allow .htaccess files in the Apache HTTP Server configuration.
RUN cat /etc/apache2/sites-enabled/000-default.conf | while read line ; do \
        case $line in \
            '</VirtualHost>') \
                echo '<Directory /var/www/html/YAWIK>' ; \
                echo '    AllowOverride all' ; \
                echo '</Directory>' ; \
                echo "$line" ; \
                ;; \
            *) \
                echo "$line" ; \
                ;; \
        esac ; \
    done > /etc/apache2/sites-enabled/000-default.conf.new \
    && mv /etc/apache2/sites-enabled/000-default.conf.new \
        /etc/apache2/sites-enabled/000-default.conf


RUN a2enmod rewrite

# Download YAWIK from github
RUN cd /var/www/html \
	&& git clone https://github.com/cross-solution/YAWIK.git \
	&& chown -R www-data:www-data YAWIK

ENV COMPOSER_CACHE_DIR=/var/www/html/YAWIK/cache/.composer \
	COMPOSER_HOME=$COMPOSER_CACHE_DIR

RUN echo "create directory $COMPOSER_CACHE_DIR" \
	&& mkdir -p $COMPOSER_CACHE_DIR \
	&& cd /var/www/html/YAWIK \
	&& chown www-data:www-data -R `dirname $COMPOSER_CACHE_DIR` \
	&& su www-data --shell /bin/sh --command './install.sh'


