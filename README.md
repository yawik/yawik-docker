docker image
============

This docker image should help developes to quickly create a development
enviroment. It uses the [yawik/build](https://github.com/cbleek/yawik-docker-build)
and runs a composer `create-project yawik/standard /var/www/html/YAWIK
--no-dev`

Requirements
------------

- docker
- docker-composer

Installation
------------

<pre>
git clone https://github.com/cross-solution/yawik-docker
cd yawik-docker
docker-composer up
</pre>

Status
------

work in progress. Image is not ready for work.

License
-------

MIT