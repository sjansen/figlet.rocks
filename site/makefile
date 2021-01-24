.PHONY:  default  all  prod  production  staging


default: staging


all: staging production


prod: production


production:
	@echo =============================
	@echo Updating https://figlet.rocks
	@echo =============================
	HUGO_ENV="production" hugo
	hugo deploy --target $@


staging:
	@echo =====================================
	@echo Updating https://preview.figlet.rocks
	@echo =====================================
	hugo
	hugo deploy --target $@
