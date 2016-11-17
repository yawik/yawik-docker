docker image
============

This docker image should help developes to quickly create a development
enviroment. It uses the offical PHP (5-apache) und mongo images and clones the YAWIK
repository into the php container.

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