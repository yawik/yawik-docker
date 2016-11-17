DOCKER_REPO = yawik/yawik

.PHONY: all build build_nc run logs clean stop rm prune

all: build run logs

build:
	docker build -t ${DOCKER_REPO}:testing .

run:
	docker-compose up -d

logs:
	docker-compose logs

clean: stop rm prune

stop:
	docker-compose stop

rm:
	docker-compose rm

prune:
	docker rm $(docker ps --filter=status=exited --filter=status=created -q)
	docker rmi `docker images -q --filter "dangling=true"`
