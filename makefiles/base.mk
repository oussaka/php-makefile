PROJECT_DIR ?= $(PWD)

##
## Makefile base
##---------------------------------------------------------------------------
##

start: build up app/config/parameters.yml db rabbitmq-fabric web/built assets-amp var/public.key perm  ## Install and start the project

stop:                                                                                                  ## Remove docker containers
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -v --force

reset: stop rm-docker-dev.lock start

tty:                                                                                                   ## Run app container in interactive mode
	$(RUN) /bin/bash

var/public.key: var/private.key                                                                        ## Generate the public key
	$(EXEC) openssl rsa -in var/private.key -pubout -out var/public.key

var/private.key:                                                                                       ## Generate the private key
	$(EXEC) openssl genrsa -out var/private.key 1024

wait-for-rabbitmq:
	$(EXEC) php -r "set_time_limit(60);for(;;){if(@fsockopen('rabbitmq',5672)){break;}echo \"Waiting for RabbitMQ\n\";sleep(1);}"

rabbitmq-fabric: wait-for-rabbitmq
	$(CONSOLE) rabbitmq:setup-fabric

chown-reset: 																						  ## reset the owner of all files in this directory and subdirectories
chown-reset:
	@echo "Resetting files rights to the project's user (might prompt super-user)"
	@sudo chown -R $$(id -u):$$(id -g) .

.DEFAULT_GOAL := help
help: 																								 ## Print this help
help:
	@grep -hE '(^[a-zA-Z._-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
	| grep -v "###>" \
	| grep -v "###<" \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: help
