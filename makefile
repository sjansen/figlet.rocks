.PHONY:  default  docker

default: docker

docker:
	docker-compose build --pull figlet
	docker-compose up --abort-on-container-exit --exit-code-from=figlet --force-recreate
