FROM yawik/build

MAINTAINER "Carsten Bleek" <bleek@cross-solution.de>

ENV DEBIAN_FRONTEND=noninteractive 

# update
RUN apt-get update && apt-get install -y git curl

COPY conf/nginx/yawik.conf /etc/nginx/sites-available/yawik.conf

RUN ln -s /etc/nginx/sites-available/yawik.conf /etc/nginx/sites-enabled/yawik.conf; \
	rm /etc/nginx/sites-enabled/default;
	
RUN	composer create-project yawik/standard /var/www/html/YAWIK --no-dev;

RUN     chown www-data:www-data -R /var/www/html/YAWIK ;