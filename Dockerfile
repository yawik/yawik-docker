FROM ubuntu:16.04

MAINTAINER "Carsten Bleek" <bleek@cross-solution.de>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Update and install some useful apts
RUN apt-get update

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN apt-get upgrade -y

ENV COMPOSER_CACHE_DIR=/var/www/html/YAWIK/cache/.composer \
	COMPOSER_HOME=$COMPOSER_CACHE_DIR

RUN apt-get update \
	&& apt-get --quiet --yes --no-install-recommends install software-properties-common \
		git-core zip unzip joe

# Install php5.6
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
	&& apt-get update \
	&& apt-get --quiet --yes --no-install-recommends install php5.6-mongo php5.6-curl \
		php5.6-xsl php5.6-intl php5.6-common php5.6-cli php5.6-json curl apache2 libapache2-mod-php5.6 \
		php5.6-mbstring

# Install mongo 3.2
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
	&& echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
	&& apt-get update \
	&& apt-get install -y mongodb-org

# enable apche rewriting module
RUN a2enmod rewrite

# Allow .htaccess files in the Apache HTTP Server configuration.
run cat /etc/apache2/sites-enabled/000-default.conf | while read line ; do \
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



# Download YAWIK from github
RUN cd /var/www/html \
    && git clone https://github.com/cross-solution/YAWIK.git \
    && chown -R www-data:www-data YAWIK

RUN echo "create directory $COMPOSER_CACHE_DIR" \
        && mkdir -p $COMPOSER_CACHE_DIR \
	&& cd /var/www/html/YAWIK \
        && chown www-data:www-data -R `dirname $COMPOSER_CACHE_DIR` \
	&& su www-data --shell /bin/sh --command './install.sh'

EXPOSE 80

VOLUME /var/log

VOLUME /var/lib/mongodb

CMD sh -ecvx ' \
    . /etc/apache2/envvars ; \
    echo APACHE_RUN_USER=$APACHE_RUN_USER ; \
    /etc/init.d/apache2 start' 

#    && su mongodb --shell=/bin/sh  -c "/usr/bin/mongod -f /etc/mongod.conf --fork"


