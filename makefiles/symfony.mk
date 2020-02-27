WRAPPER_EXEC_USER ?=
APP_ENV ?= dev
SF ?= $(WRAPPER_EXEC_USER) bin/console --env=$(APP_ENV)

##
## Symfony
##---------------------------------------------------------------------------
##

clear: rm-docker-dev.lock                                                                                             ## Remove all the cache, the logs, the sessions and the built assets
	-$(EXEC) rm -rf var/cache/*
	-$(EXEC) rm -rf var/sessions/*
	-$(EXEC) rm -rf supervisord.log supervisord.pid npm-debug.log .tmp
	-$(CONSOLE) redis:flushall -n
	rm -rf var/logs/*
	rm -rf web/built
	rm var/.php_cs.cache

clean: clear                                                                                           ## Clear and remove dependencies
	rm -rf vendor node_modules

cc:                                                                                                    ## Clear the cache in dev env
	$(CONSOLE) cache:clear --no-warmup
	$(CONSOLE) cache:warmup

.PHONY: cc clean clear
