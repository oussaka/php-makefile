PROJECT_DIR ?= $(PWD)

##
## Makefile base
## -------------
##

chown-reset: ## reset the owner of all files in this directory and subdirectories
chown-reset:
	@echo "Resetting files rights to the project's user (might prompt super-user)"
	@sudo chown -R $$(id -u):$$(id -g) .

.DEFAULT_GOAL := help
help: ## Print this help
help:
	@grep -hE '(^[a-zA-Z._-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) \
	| grep -v "###>" \
	| grep -v "###<" \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


.PHONY: help
