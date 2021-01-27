.PHONY:  default  check-env  check-working-tree  docker  hugo  images  login  push  start

default: docker


check-env:
ifndef AWSCLI
	$(error AWSCLI is undefined)
endif


check-working-tree:
	@git diff-index --quiet HEAD -- \
	|| (echo "Working tree is dirty. Commit all changes."; false)


docker:
	docker-compose build --pull figlet
	docker-compose up --abort-on-container-exit --exit-code-from=figlet --force-recreate


hugo:
	cd site && hugo server


images:
	$(AWSCLI) ecr list-images \
	    --repository-name figlet


login: check-env
	$(AWSCLI) ecr get-login-password \
	| docker login \
	    --username AWS \
	    --password-stdin \
	    `scripts/get-ecr-registry`


push: check-env  check-working-tree  login
	$(eval TAG := $(shell echo `scripts/get-ecr-repository-url`:`git rev-parse HEAD`))
	docker build \
	    --compress --force-rm --pull \
	    -t $(TAG) \
	    docker/figlet/
	docker push $(TAG)


start:
	foreman start
