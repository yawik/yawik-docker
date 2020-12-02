FROM php:7.4-apache

MAINTAINER "Carsten Bleek" <bleek@cross-solution.de>

RUN 	curl -sL https://deb.nodesource.com/setup_12.x | bash - ; \
	apt-get install -y nodejs

RUN apt-get update && apt-get install -y git-core 


RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
	libicu-dev \
	libssl-dev \
	libcurl4-openssl-dev \
	zip unzip \
   	&& docker-php-ext-install -j$(nproc) intl \
    	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
    	&& docker-php-ext-install -j$(nproc) gd \
	&& pecl install mongodb \
    	&& docker-php-ext-enable mongodb

# Allow .htaccess files in the Apache HTTP Server configuration.
RUN cat /etc/apache2/sites-enabled/000-default.conf | while read line ; do \
        case $line in \
            '</VirtualHost>') \
                echo '<Directory /var/www/html/YAWIK/public>' ; \
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
        /etc/apache2/sites-enabled/000-default.conf; \
        cat /etc/apache2/sites-enabled/000-default.conf;


RUN a2enmod rewrite

ENV COMPOSER_CACHE_DIR=/var/www/YAWIK/cache/.composer \
	COMPOSER_HOME=$COMPOSER_CACHE_DIR;
	
RUN	mkdir -p $COMPOSER_CACHE_DIR; \
	mkdir -p /var/www/.npm/_locks; \
	mkdir -p /var/www/.config; \
	chown www-data:www-data -R /var/www/.npm; \
	chown www-data:www-data -R /var/www/.config; \
        curl -sS https://getcomposer.org/installer > installer.php; \
	php ./installer.php --install-dir=/usr/local/bin --filename=composer; \
	chmod +x /usr/local/bin/composer ; \
	su www-data --shell /bin/sh --command 'composer create-project yawik/standard YAWIK --no-dev' ;

RUN     cd /var/www/html/YAWIK \
	chown www-data:www-data -R `dirname $COMPOSER_CACHE_DIR` ; \


