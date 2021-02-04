.PHONY:  default  all  prod  production  staging


default:
	hugo server


all: staging production


prod: production


production:
	@echo =============================
	@echo Updating https://figlet.rocks
	@echo =============================
	HUGO_ENV="production" NODE_ENV="production" hugo
	hugo deploy --target $@


staging:
	@echo =====================================
	@echo Updating https://preview.figlet.rocks
	@echo =====================================
	NODE_ENV="production" hugo
	hugo deploy --target $@
