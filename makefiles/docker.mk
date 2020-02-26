DOCKER_BIN ?= docker

ifeq ($(shell which $(DOCKER_BIN)),)

root: docker_error

app: docker_error

logs: docker_error

up: docker_error

stop: docker_error

down: docker_error

docker_error:
	$(error "docker is not available")

.PHONY: docker_error

else

DOCKER_COMPOSE ?= docker-compose


PROJECT_NAME ?=
DC_EXEC_ROOT = $(DOCKER_COMPOSE) exec $(PROJECT_NAME)
DC_EXEC_USER = $(DOCKER_COMPOSE) exec --user=$$(id -u):$$(id -g) $(PROJECT_NAME)

##
## Docker actions
##---------------------------------------------------------------------------
##

root: 																			## docker-compose exec (root)
root:
	@$(DC_EXEC_ROOT) $(filter-out $@,$(MAKECMDGOALS))

app: 																			## docker-compose exec on your application container
app:
	@$(DC_EXEC_USER) $(filter-out $@,$(MAKECMDGOALS))

logs: 																			## docker-compose logs -f
logs:
	@$(DOCKER_COMPOSE) logs -f $(filter-out $@,$(MAKECMDGOALS))

build: 																			## docker build
build: docker-dev.lock

docker-dev.lock: $(DOCKER_FILES)
	$(DOCKER_COMPOSE) pull --ignore-pull-failures
	$(DOCKER_COMPOSE) build --force-rm --pull
	touch docker-dev.lock

rm-docker-dev.lock:
	rm -f docker-dev.lock

up: 																			## Create the containers (if needed) and launch them
up:
	@$(DOCKER_COMPOSE) up -d --remove-orphans

stop: 																			## stop the containers
stop:
	@$(DOCKER_COMPOSE) stop

down: 																			## Stops containers and removes containers
down:
	@$(DOCKER_COMPOSE) down

endif

.PHONY: root_ex app ex logs up stop down
