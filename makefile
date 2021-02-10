.PHONY:  default  check-env  check-working-tree  docker  hugo  images  login  push  start

default: start


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
	scripts/push-staging


start:
	foreman start
